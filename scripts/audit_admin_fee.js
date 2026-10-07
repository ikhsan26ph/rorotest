// Audit read-only seluruh halaman menu. Tidak menyelesaikan pembayaran atau membuat booking.
const fs = require('fs');
const path = require('path');
const { chromium } = require('@playwright/test');
const { parseEnv } = require('../tests/helpers/env');
const { loginPartner } = require('../tests/helpers/partner-session');
const ROOT = path.resolve(__dirname, '..');
const runId = process.env.FEE_AUDIT_RUN || new Date().toISOString().replace(/[-:]/g, '').slice(0, 15).replace('T', '-');
const dir = path.join(ROOT, 'artifacts', 'fee-audit', runId);
fs.mkdirSync(dir, { recursive: true });
const env = parseEnv();
const output = fs.existsSync(path.join(dir, 'pages.json')) ? JSON.parse(fs.readFileSync(path.join(dir, 'pages.json'), 'utf8')) : { runId, startedAt: new Date().toISOString(), pages: [], logins: [] };
delete output.finishedAt;
const save = () => fs.writeFileSync(path.join(dir, 'pages.json'), JSON.stringify(output, null, 2));
const unsafe = /logout|signout|keluar|delete|hapus|destroy|remove|simulator|callback|download|export|PrintTix|(?:\/|^)save(?:\/|$)/i;

async function login(browser, role, route, account) {
  const context = await browser.newContext({ baseURL: env.baseUrl });
  const page = await context.newPage();
  await page.goto(route, { waitUntil: 'domcontentloaded', timeout: 45000 });
  const fields = await page.locator('input').evaluateAll(es => es.map(e => ({ id: e.id, name: e.name, type: e.type })));
  fs.writeFileSync(path.join(dir, `${role}-login-fields.json`), JSON.stringify(fields, null, 2));
  const email = page.locator('#username, input[name=Email], input[type=email]').first();
  const password = page.locator('#password, input[type=password]').first();
  await email.fill(account.email);
  await password.fill(account.password);
  await page.getByRole('button', { name: /^(Login|Masuk|Log in)$/i }).first().click();
  await page.waitForFunction(() => !document.querySelector('input[type=password]') || !document.querySelector('input[type=password]').offsetParent, null, { timeout: 20000 });
  await page.waitForLoadState('networkidle', { timeout: 8000 }).catch(() => {});
  output.logins.push({ role, status: 'passed', landing: new URL(page.url()).pathname }); save();
  return { context, page };
}

async function inspect(page, route, role) {
  const start = Date.now();
  const rec = { role, route, status: 'passed', error: null, calculationStatus: 'not-evaluated' };
  const errors = [];
  const onResponse = r => { if (r.status() >= 400 && new URL(r.url()).origin === env.baseUrl) errors.push({ path: new URL(r.url()).pathname, status: r.status() }); };
  page.on('response', onResponse);
  try {
    const response = await page.goto(route, { waitUntil: 'domcontentloaded', timeout: 30000 });
    await page.waitForLoadState('networkidle', { timeout: 7000 }).catch(() => {});
    await page.waitForFunction(() => !/Mohon tunggu sebentar/i.test(document.body.innerText), null, { timeout: 6000 }).catch(() => {});
    const filter = page.getByText('Filter', { exact: true }).first();
    if (await filter.count() && await filter.isVisible()) {
      await filter.click({ timeout: 5000 });
      rec.readOnlyInteraction = 'Buka panel Filter tanpa submit';
    } else {
      rec.readOnlyInteraction = 'Baca komponen halaman tanpa aksi bisnis';
    }
    const content = page.locator('.app-main__inner, main, .cms-content').first();
    const body = await (await content.count() ? content : page.locator('body')).innerText();
    const basename = `${role}-${route.replace(/[^a-z0-9]+/gi, '-')}`;
    fs.writeFileSync(path.join(dir, `${basename}.txt`), body);
    rec.httpStatus = response?.status(); rec.finalRoute = new URL(page.url()).pathname;
    rec.headers = await page.locator('table thead').allInnerTexts();
    rec.feeLabels = [...new Set(body.match(/.{0,35}(?:biaya admin|processing fee|tarif pass|saldo|total pembayaran|total harga|total penjualan).{0,70}/gi) || [])].slice(0, 30);
    rec.loadingUnresolved = /Mohon tunggu sebentar/i.test(body);
    rec.hasContent = body.trim().length > 20;
    rec.httpErrors = errors;
    if (response?.status() >= 400 || /Fatal error|Uncaught|ApiException|SQLSTATE|Cloudflare.*1015/i.test(body)) {
      rec.status = 'failed'; rec.error = 'Halaman atau lookup menghasilkan error server.';
      rec.screenshot = path.join(dir, `${basename}.png`); await page.screenshot({ path: rec.screenshot, fullPage: true });
    }
    rec.links = await page.locator('a[href]').evaluateAll(es => es.map(e => ({ text: e.textContent.trim().replace(/\s+/g, ' '), href: e.href, visible: !!e.offsetParent })));
    rec.fields = await page.locator('input:not([type=password]),select').evaluateAll(es => es.filter(e => !/Security|token/i.test(e.name) && e.type !== 'hidden').map(e => ({ id: e.id, name: e.name, type: e.type })));
  } catch (e) { rec.status = 'blocked'; rec.error = e.message.slice(0, 350); }
  page.off('response', onResponse);
  rec.durationSec = (Date.now() - start) / 1000;
  output.pages.push(rec); save();
  console.log(role, route, rec.status, rec.loadingUnresolved ? 'lookup masih loading' : '');
  return rec;
}

async function walk(page, role, root) {
  const first = output.pages.find(p => p.role === role && p.route === root) || await inspect(page, root, role);
  const menuLinks = first.links || [];
  const map = fs.readFileSync(path.join(ROOT, 'explore/module-map.md'), 'utf8');
  const mapped = role === 'pusat' || role === 'cabang' ? [...map.matchAll(/`(\/partner\/[^`?\s]+|\/home\/directprint)`/g)].map(m => m[1]) : [];
  const routes = new Set(mapped);
  for (const l of menuLinks) {
    try {
      const u = new URL(l.href);
      if (u.origin !== env.baseUrl || unsafe.test(u.pathname + ' ' + l.text)) continue;
      if (role === 'user' && !/^\/home\//.test(u.pathname)) continue;
      if (role === 'adminprahu' && !/^\/adminprahu\//.test(u.pathname)) continue;
      if (role !== 'user' && role !== 'adminprahu' && !/^\/(partner|home)\//.test(u.pathname)) continue;
      if (/\d+$/.test(u.pathname)) continue;
      if (u.search && !/DashboardList|getDetailTIketGratis|getDetailPekerja/.test(u.pathname)) continue;
      routes.add(u.pathname + u.search);
    } catch {}
  }
  // Form/halaman submenu pada level kedua, tanpa mengikuti URL detail record/token.
  for (const record of output.pages.filter(p => p.role === role)) {
    for (const l of record.links || []) {
      try {
        const u = new URL(l.href);
        if (u.origin !== env.baseUrl || u.search || unsafe.test(u.pathname + ' ' + l.text)) continue;
        if (!/^\/(home|partner|adminprahu)\/[A-Za-z_]+\/?$/.test(u.pathname)) continue;
        if (/\/(?:batal|cancel)(?:order|booking|tiket)/i.test(u.pathname)) continue;
        if (role === 'user' && !/^\/home\//.test(u.pathname)) continue;
        if (role === 'adminprahu' && !/^\/adminprahu\//.test(u.pathname)) continue;
        if ((role === 'pusat' || role === 'cabang') && !/^\/(partner|home)\//.test(u.pathname)) continue;
        routes.add(u.pathname);
      } catch {}
    }
  }
  // Routes mapped from UI may contain placeholder tokens; do not navigate those.
  for (const route of routes) {
    if (route === root || /[<>:]|\/\d+$/.test(route) || (/logout|signout|simulator|callback/i.test(route))) continue;
    if (output.pages.some(p => p.role === role && p.route === route)) continue;
    await inspect(page, route, role);
  }
}

(async () => {
  const browser = await chromium.launch({ headless: true });
  try {
    for (const role of ['user', 'adminprahu', 'pusat', 'cabang']) {
      let session;
      try {
        if (role === 'pusat' || role === 'cabang') {
          session = await loginPartner(browser, role === 'pusat' ? 'Operator Pusat' : 'Operator Cabang');
          session.page = await session.context.newPage();
        } else {
          const account = role === 'user' ? env.accounts.filter(a => /User Umum/i.test(a.role)).at(-1) : env.accounts.find(a => /Admin Pusat/i.test(a.role));
          session = await login(browser, role, role === 'user' ? '/user/login' : '/adminprahu', account);
        }
        const root = role === 'user' ? '/home/pencarian' : role === 'adminprahu' ? new URL(session.page.url()).pathname : role === 'pusat' ? '/partner/profil' : '/partner/profilsubuser';
        await walk(session.page, role, root);
      } catch (e) { output.logins.push({ role, status: 'blocked', error: e.message.slice(0, 350) }); save(); console.log(role, 'BLOCKED', e.message.slice(0, 150)); }
      finally { if (session) await session.context.close(); }
    }
  } finally { await browser.close(); output.finishedAt = new Date().toISOString(); save(); console.log('OUTPUT', path.join(dir, 'pages.json')); }
})().catch(e => { console.error(e.message); save(); process.exitCode = 1; });
