#!/usr/bin/env node
// Harvest selector asli per layar (workflow docs/workflows/harvest-selectors.md) memakai Playwright
// langsung (tanpa MCP) — read-only: hanya login, navigasi, klik toggle/filter/modal yang disebut config,
// tidak pernah submit/simpan. Kredensial dari config/env.md (tidak pernah dicetak).
//
// Usage: node scripts/harvest_selectors.js <screens.json> <runId> [--role "Operator Pusat"] [--only id1,id2]
// Output: artifacts/harvest/<runId>/<screen>.json + artifacts/screenshots/harvest/<runId>/<screen>.png
//
// Format screens.json:
// { "portal": "/partner", "loginPath": "/partner",
//   "screens": [ { "id": "hakakses-list", "scr": "SCR-01", "name": "Daftar Hak Akses", "url": "/partner/hakAkses",
//                  "urlFrom": {"screen": "hakakses-list", "hrefMatch": "/partner/detailhakakses/"},   // opsional: ambil href pertama yg cocok dari hasil layar lain
//                  "steps": [ {"click": "role=button[name='Filter']"}, {"wait": 500}, {"press": "Escape"} ],  // opsional, sebelum harvest
//                  "screenshot": true } ] }
const fs = require('fs');
const path = require('path');
const { chromium } = require('@playwright/test');
const { parseEnv } = require('../tests/helpers/env');

const ROOT = path.resolve(__dirname, '..');
const args = process.argv.slice(2);
if (args.length < 2) { console.error('Usage: node scripts/harvest_selectors.js <screens.json> <runId> [--role X] [--only a,b]'); process.exit(1); }
const [cfgPath, runId] = args;
const opt = (k, d) => { const i = args.indexOf(k); return i >= 0 ? args[i + 1] : d; };
const roleWanted = opt('--role', 'Operator Pusat');
const only = opt('--only', null);
const cfg = JSON.parse(fs.readFileSync(path.resolve(ROOT, cfgPath), 'utf8'));

const OUT = path.join(ROOT, 'artifacts', 'harvest', runId);
const SHOT = path.join(ROOT, 'artifacts', 'screenshots', 'harvest', runId);
fs.mkdirSync(OUT, { recursive: true });
fs.mkdirSync(SHOT, { recursive: true });

// Script harvest — versi diperluas dari docs/workflows/harvest-selectors.md (tambah label, options, region, data-*).
const HARVEST = () => {
  const vis = (el) => !!(el.offsetWidth || el.offsetHeight || el.getClientRects().length);
  const txt = (el, n = 60) => (el && (el.innerText || el.textContent) || '').replace(/\s+/g, ' ').trim().slice(0, n) || null;
  const labelFor = (el) => {
    if (el.id) { const l = document.querySelector(`label[for="${CSS.escape(el.id)}"]`); if (l) return txt(l); }
    const p = el.closest('label'); if (p) return txt(p);
    const fg = el.closest('.form-group, .mb-3, .form-floating, .input-group, .col-md-6, .col-md-4, .col-md-12, .col, .position-relative');
    const l2 = fg && fg.querySelector('label'); if (l2) return txt(l2);
    return null;
  };
  const region = (el) => {
    if (el.closest('.modal, [role="dialog"], .swal2-container, .swal-modal')) return 'modal';
    if (el.closest('header, .app-header, .navbar, .app-header__content')) return 'header';
    if (el.closest('aside, nav.sidebar, .app-sidebar, .sidebar, .app-sidebar__inner, .vertical-nav-menu')) return 'sidebar';
    if (el.closest('footer, .app-footer')) return 'footer';
    if (el.closest('table')) return 'table';
    return 'main';
  };
  const sel = 'button, a, input, select, textarea, [role="button"], [role="tab"], [role="menuitem"], [onclick], label.switch, .custom-control-input';
  const els = [...document.querySelectorAll(sel)];
  return {
    url: location.href,
    title: document.title,
    headings: [...document.querySelectorAll('h1,h2,h3,h4,h5,h6,.card-title,.page-title,.page-title-heading,.breadcrumb,.card-header')]
      .filter(vis).map((h) => txt(h, 100)).filter(Boolean).slice(0, 40),
    tableHeaders: [...document.querySelectorAll('table thead th, table thead td')].map((t) => txt(t, 40)).filter(Boolean).slice(0, 60),
    tableRowCount: document.querySelectorAll('table tbody tr').length,
    mainText: txt(document.querySelector('.app-main__inner') || document.querySelector('main') || document.body, 1500),
    firstRowCells: [...(document.querySelector('table tbody tr')?.querySelectorAll('td') || [])].map((t) => txt(t, 60)),
    alerts: [...document.querySelectorAll('.alert, .invalid-feedback, .text-danger, .swal2-popup, .swal-modal, .toast, .noty_body, .modal.show, .modal[style*="block"]')]
      .map((a) => ({ cls: String(a.className).slice(0, 80), text: txt(a, 160), visible: vis(a) })).slice(0, 25),
    forms: [...document.querySelectorAll('form')].map((f) => ({ id: f.id || null, action: f.getAttribute('action'), method: f.getAttribute('method'), fields: f.querySelectorAll('input,select,textarea').length })),
    elements: els.map((el) => {
      const tag = el.tagName;
      const type = el.getAttribute('type');
      const o = {
        tag, id: el.id || null, testid: el.getAttribute('data-testid'), name: el.getAttribute('name'), type,
        aria: el.getAttribute('aria-label'), placeholder: el.getAttribute('placeholder'), title: el.getAttribute('title'),
        text: tag === 'SELECT' ? null : txt(el, 50), href: el.getAttribute('href'),
        value: (tag === 'INPUT' && ['submit', 'button', 'checkbox', 'radio', 'hidden'].includes(type)) || tag === 'BUTTON' ? (el.value || null) : undefined,
        disabled: el.disabled || el.getAttribute('aria-disabled') === 'true' || null,
        readonly: el.readOnly || null,
        checked: (type === 'checkbox' || type === 'radio') ? el.checked : undefined,
        required: el.required || null,
        visible: vis(el),
        label: ['INPUT', 'SELECT', 'TEXTAREA'].includes(tag) && type !== 'hidden' ? labelFor(el) : null,
        onclick: (el.getAttribute('onclick') || '').slice(0, 140) || null,
        data: Object.fromEntries([...el.attributes].filter((a) => a.name.startsWith('data-') && a.name !== 'data-testid').map((a) => [a.name, a.value.slice(0, 60)])),
        cls: String(el.className || '').slice(0, 160) || null,
        region: region(el),
        form: el.form ? (el.form.id || el.form.getAttribute('action') || 'form') : null,
        options: tag === 'SELECT' ? [...el.options].slice(0, 60).map((op) => ({ v: op.value, t: txt(op, 60), sel: op.selected })) : undefined,
        rowIndex: el.closest('tbody tr') ? [...el.closest('tbody').children].indexOf(el.closest('tbody tr')) : undefined,
        html: (tag === 'BUTTON' || tag === 'A' || el.hasAttribute('onclick')) && el.closest('table, .modal, [role="dialog"], .swal2-container') ? el.outerHTML.slice(0, 260) : undefined,
      };
      Object.keys(o).forEach((k) => (o[k] === undefined || o[k] === null || (typeof o[k] === 'object' && !Array.isArray(o[k]) && Object.keys(o[k]).length === 0)) && delete o[k]);
      return o;
    }),
  };
};

async function login(page, baseUrl, acct) {
  await page.goto(baseUrl + (cfg.loginPath || '/partner'), { waitUntil: 'networkidle', timeout: 60000 });
  await page.locator('#username').fill(acct.email);
  await page.locator('#password').fill(acct.password);
  await page.getByRole('button', { name: 'Login', exact: true }).click();
  // Sesudah login Operator: /partner (Akun Saya) lalu redirect ke /partner/profil (pusat) atau /partner/profilsubuser (sub user).
  // Diverifikasi 2026-09-25. Tunggu redirect selesai sebelum memeriksa, karena innerText saat navigasi bisa kosong.
  await page.waitForURL(/\/partner\/(profil|profilsubuser|dashboard)/i, { timeout: 30000 }).catch(() => {});
  await page.waitForLoadState('networkidle', { timeout: 60000 }).catch(() => {});
  let loggedIn = false;
  for (let i = 0; i < 5 && !loggedIn; i++) {
    const stillLoginForm = (await page.locator('#username').count().catch(() => 0)) > 0;
    const body = (await page.locator('body').innerText().catch(() => '')) || '';
    loggedIn = !stillLoginForm && /keluar|logout/i.test(body);
    if (!loggedIn) await page.waitForTimeout(1000);
  }
  return { loggedIn, url: page.url() };
}

async function runSteps(page, steps, log) {
  for (const st of steps || []) {
    try {
      if (st.click) {
        const loc = page.locator(st.click).first();
        await loc.waitFor({ state: 'visible', timeout: 8000 });
        if (st.dispatch) await loc.dispatchEvent('click'); else await loc.click({ timeout: 8000 });
        log.push(`click ok: ${st.click}`);
      } else if (st.press) { await page.keyboard.press(st.press); log.push(`press ${st.press}`); }
      else if (st.fill) { await page.locator(st.fill).first().fill(st.value || ''); log.push(`fill ${st.fill}`); }
      else if (st.select) { await page.locator(st.select).first().selectOption(st.value); log.push(`select ${st.select}`); }
      if (st.wait) await page.waitForTimeout(st.wait);
      else await page.waitForTimeout(400);
    } catch (e) {
      log.push(`STEP FAILED ${JSON.stringify(st)}: ${String(e).split('\n')[0].slice(0, 200)}`);
      if (st.required !== false) return false;
    }
  }
  return true;
}

(async () => {
  const { baseUrl, accounts } = parseEnv();
  const acct = accounts.find((a) => a.role.toLowerCase().includes(roleWanted.toLowerCase()));
  if (!acct) { console.error(`Akun dengan role "${roleWanted}" tidak ada di config/env.md`); process.exit(1); }
  const exe = process.env.BROWSER_EXE || (fs.existsSync('/usr/bin/brave-browser') ? '/usr/bin/brave-browser' : undefined);
  const browser = await chromium.launch({ headless: true, executablePath: exe, args: ['--no-sandbox'] });
  const context = await browser.newContext({ viewport: { width: 1440, height: 900 }, baseURL: baseUrl });
  const page = await context.newPage();
  page.setDefaultTimeout(15000);
  const summary = { runId, role: acct.role, user: acct.email, baseUrl, startedAt: new Date().toISOString(), screens: [] };
  const results = {};

  // Layar login (sebelum login) selalu dipetakan sebagai SCR-00.
  const lp = cfg.loginPath || '/partner';
  await page.goto(baseUrl + lp, { waitUntil: 'networkidle', timeout: 60000 });
  results.login = await page.evaluate(HARVEST);
  fs.writeFileSync(path.join(OUT, 'login.json'), JSON.stringify(results.login, null, 1));
  await page.screenshot({ path: path.join(SHOT, 'login.png'), fullPage: true });
  summary.screens.push({ id: 'login', scr: 'SCR-00', url: page.url(), elements: results.login.elements.length, status: 'OK' });

  const li = await login(page, baseUrl, acct);
  if (!li.loggedIn) {
    await page.screenshot({ path: path.join(SHOT, 'login-failed.png'), fullPage: true });
    console.error('LOGIN GAGAL (1x) — berhenti, tidak mencoba lagi. URL:', li.url);
    summary.loginFailed = true;
    fs.writeFileSync(path.join(OUT, '_summary.json'), JSON.stringify(summary, null, 1));
    await browser.close(); process.exit(3);
  }
  summary.postLoginUrl = li.url;
  console.error('login OK ->', li.url);

  const wanted = only ? only.split(',') : null;
  for (const sc of cfg.screens) {
    if (wanted && !wanted.includes(sc.id)) continue;
    const log = [];
    const entry = { id: sc.id, scr: sc.scr, name: sc.name, status: 'OK', log };
    try {
      let url = sc.url;
      if (sc.urlFrom) {
        const src = results[sc.urlFrom.screen] || JSON.parse(fs.readFileSync(path.join(OUT, sc.urlFrom.screen + '.json'), 'utf8'));
        let hit;
        if (sc.urlFrom.hrefMatch) {
          hit = (src.elements || []).find((e) => e.href && e.href.includes(sc.urlFrom.hrefMatch) && (sc.urlFrom.index == null || e.rowIndex === sc.urlFrom.index));
          if (!hit) throw new Error(`urlFrom: tidak ada href cocok ${sc.urlFrom.hrefMatch} di ${sc.urlFrom.screen}`);
          url = hit.href;
        } else if (sc.urlFrom.clsMatch && sc.urlFrom.template) {
          // Tombol baris tanpa href (mis. <button value="57" class="viewPetugas">) → URL dari template + value.
          hit = (src.elements || []).find((e) => e.value && String(e.cls || '').includes(sc.urlFrom.clsMatch));
          if (!hit) throw new Error(`urlFrom: tidak ada elemen class ${sc.urlFrom.clsMatch} dengan value di ${sc.urlFrom.screen}`);
          url = sc.urlFrom.template.replace('{value}', hit.value).replace('{b64value}', Buffer.from(String(hit.value)).toString('base64'));
        } else throw new Error('urlFrom butuh hrefMatch atau clsMatch+template');
      }
      if (url) {
        await page.goto(url.startsWith('http') ? url : baseUrl + url, { waitUntil: 'networkidle', timeout: 60000 });
        await page.waitForTimeout(600);
      }
      if (/\/partner\/?$/.test(page.url()) || /login/i.test(await page.title())) throw new Error('sesi hilang / redirect ke login');
      const ok = await runSteps(page, sc.steps, log);
      if (!ok) entry.status = 'PARTIAL';
      const data = await page.evaluate(HARVEST);
      data.harvestedAt = new Date().toISOString();
      data.steps = log;
      results[sc.id] = data;
      fs.writeFileSync(path.join(OUT, sc.id + '.json'), JSON.stringify(data, null, 1));
      if (sc.screenshot !== false) await page.screenshot({ path: path.join(SHOT, sc.id + '.png'), fullPage: true });
      entry.url = data.url; entry.elements = data.elements.length; entry.visible = data.elements.filter((e) => e.visible).length;
      entry.headings = data.headings.slice(0, 6);
      await runSteps(page, sc.after, log); // mis. tutup modal
    } catch (e) {
      entry.status = 'SKIPPED'; entry.error = String(e).split('\n')[0].slice(0, 300);
      await page.screenshot({ path: path.join(SHOT, sc.id + '-error.png'), fullPage: true }).catch(() => {});
    }
    summary.screens.push(entry);
    console.error(`${entry.status.padEnd(7)} ${sc.scr || ''} ${sc.id} -> ${entry.url || ''} (${entry.elements ?? '-'} el)${entry.error ? ' ERR: ' + entry.error : ''}`);
  }
  summary.finishedAt = new Date().toISOString();
  fs.writeFileSync(path.join(OUT, '_summary.json'), JSON.stringify(summary, null, 1));
  await context.close(); await browser.close();
  console.log(path.relative(ROOT, OUT));
})().catch(async (e) => { console.error('FATAL', e); process.exit(1); });
