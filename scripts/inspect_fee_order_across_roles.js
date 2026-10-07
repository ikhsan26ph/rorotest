// Read-only: telusuri order milik run ini dan opsi cleanup pada empat role.
const fs = require('fs'); const path = require('path');
const { chromium } = require('@playwright/test'); const { parseEnv } = require('../tests/helpers/env');
const { loginPartner } = require('../tests/helpers/partner-session');
const ROOT = path.resolve(__dirname, '..'); const dir = path.join(ROOT, 'artifacts/fee-audit/order');
const order = JSON.parse(fs.readFileSync(path.join(dir, 'order.json'), 'utf8')); const code = order.bookings[0].code;
const env = parseEnv(); const roles=process.env.FEE_AUDIT_ROLES?.split(',')||['user','adminprahu','pusat','cabang']; const output = fs.existsSync(path.join(dir,'cross-role.json')) ? JSON.parse(fs.readFileSync(path.join(dir,'cross-role.json'),'utf8')).filter(r=>!roles.includes(r.role)) : [];
const save = () => fs.writeFileSync(path.join(dir, 'cross-role.json'), JSON.stringify(output, null, 2));

async function login(browser, role) {
  if (role === 'pusat' || role === 'cabang') {
    const session = await loginPartner(browser, role === 'pusat' ? 'Operator Pusat' : 'Operator Cabang');
    session.page = await session.context.newPage(); return session;
  }
  const account = role === 'user' ? env.accounts.filter(a => /User Umum/i.test(a.role)).at(-1) : env.accounts.find(a => /Admin Pusat/i.test(a.role));
  const context = await browser.newContext({ baseURL: env.baseUrl }); const p = await context.newPage();
  await p.goto(role === 'user' ? '/user/login' : '/adminprahu', { waitUntil: 'domcontentloaded' });
  await p.locator('#username').fill(account.email); await p.locator('#password').fill(account.password);
  if (role === 'user') await p.locator('#login1').click(); else await p.getByRole('button', { name: 'Login', exact: true }).click();
  await p.waitForFunction(() => !document.querySelector('input[type=password]')?.offsetParent, null, { timeout: 30000 });
  return { context, page: p };
}

(async () => {
  const browser = await chromium.launch({ headless: true });
  try {
    for (const role of roles) {
      let session; const rec = { role, code, status: 'blocked', cleanupControls: [] }; output.push(rec); save();
      try {
        session = await login(browser, role); const p = session.page; p.setDefaultTimeout(10000);
        const route = role === 'user' ? '/home/daftarpembelian' : role === 'adminprahu' ? '/adminprahu/daftarpenjualan' : '/partner/daftarpenjualan';
        await p.goto(route, { waitUntil: 'domcontentloaded' });
        const row = p.locator('tr').filter({ hasText: code }).first(); await row.waitFor({ timeout: 30000 });
        await p.waitForLoadState('networkidle', {timeout: 10000}).catch(()=>{});
        fs.writeFileSync(path.join(dir, `${role}-row.html`), await row.evaluate(e=>e.outerHTML));
        rec.listPrice = (await row.innerText()).match(/Rp\.\s*[\d.]+/)?.[0]; rec.listFound = true;
        const actions=role==='user'?row:row.locator('xpath=following-sibling::tr[1]');
        const menu=actions.locator('.dropdown-toggle'); if(await menu.count()) {await menu.first().click(); await p.waitForLoadState('networkidle',{timeout:8000}).catch(()=>{});}
        const link = actions.locator('a[href*="detailpenjualan"],a[href*="detailpembelian"]').first();
        let href = await link.count() ? await link.getAttribute('href') : null;
        if (!href && role === 'user') href = fs.readFileSync(path.join(dir, 'payment.html'), 'utf8').match(/href="([^"]*\/home\/detailpembelian\/\d+)"/)?.[1];
        if (!href) throw new Error('Link detail untuk kode order uji tidak tersedia');
        await p.goto(href, { waitUntil: 'domcontentloaded' }); await p.waitForLoadState('networkidle', { timeout: 8000 }).catch(() => {});
        let text = await p.locator('body').innerText(); if (!text.includes(code)) throw new Error('Detail tidak memuat kode order uji');
        const detail = p.getByText('Lihat Detail Pembayaran', { exact: true }).first();
        if (await detail.count() && await detail.isVisible()) { await detail.click(); await p.waitForLoadState('networkidle',{timeout:8000}).catch(()=>{}); }
        text = await p.locator('body').innerText(); fs.writeFileSync(path.join(dir, `${role}-detail.txt`), text);
        rec.hasSubtotal = /Rp\.\s*310\.000/.test(text);
        rec.components = await p.locator('.isidetailpembelian tr').evaluateAll(es => es.map(e => [...e.querySelectorAll('td')].map(e => e.textContent.trim())));
        rec.cleanupControls = await p.locator('a,button').evaluateAll(es => es.filter(e => /batalkan order|batal order|hapus order|cancel order|cancel booking/i.test(e.textContent)).map(e => ({ text: e.textContent.trim(), visible: !!e.offsetParent, onclick: e.getAttribute('onclick'), href: e.getAttribute('href') })));
        rec.paymentState = text.match(/Memilih Pembayaran|Pilih Pembayaran|Lakukan Pembayaran|Pembelian Kadaluarsa|Order Expired|Belum Bayar/i)?.[0] || null;
        rec.status = rec.hasSubtotal ? 'passed' : 'blocked'; rec.scope = 'subtotal order sebelum pemilihan gateway, bukan fee invoice setelah pembayaran';
        if (role === 'user') {
          await p.goto('/home/Profil_user_umum', { waitUntil: 'domcontentloaded' });
          const edit = p.getByText('Edit Akun Saya', { exact: true }).first();
          if (await edit.count() && await edit.isVisible()) {
            await edit.click(); await p.waitForLoadState('domcontentloaded');
            rec.profileEditOpened = true; rec.profileFields = await p.locator('input,select').evaluateAll(es => es.filter(e => e.offsetParent).map(e => ({ id: e.id, name: e.name, type: e.type })));
          } else rec.profileEditOpened = false;
        }
      } catch (e) { rec.error = e.message.slice(0, 350); }
      finally { if (session) await session.context.close(); save(); console.log(role, rec.status, 'subtotal', rec.hasSubtotal, 'cleanup', rec.cleanupControls.length, rec.error || ''); }
    }
  } finally { await browser.close(); save(); }
})().catch(e => { console.error(e.message); save(); process.exitCode = 1; });
