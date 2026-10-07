const fs = require('fs'); const path = require('path');
const { chromium } = require('@playwright/test'); const { parseEnv } = require('../tests/helpers/env');
const ROOT = path.resolve(__dirname, '..'); const dir = path.join(ROOT, 'artifacts/fee-audit/order');
(async () => {
  const env = parseEnv(); const acct = env.accounts.filter(a => /User Umum/i.test(a.role)).at(-1);
  const order = JSON.parse(fs.readFileSync(path.join(dir, 'order.json'), 'utf8')); const code = order.bookings[0].code;
  const browser = await chromium.launch({ headless: true }); const context = await browser.newContext({ baseURL: env.baseUrl }); const p = await context.newPage();
  try {
    await p.goto('/user/login', { waitUntil: 'domcontentloaded' }); await p.locator('#username').fill(acct.email); await p.locator('#password').fill(acct.password); await p.locator('#login1').click(); await p.waitForURL(/\/home\//, { timeout: 30000 });
    await p.goto('/home/daftarpembelian', { waitUntil: 'domcontentloaded' }); await p.locator('tr').filter({ hasText: code }).first().waitFor({ timeout: 30000 });
    const row = p.locator('tr').filter({ hasText: code }).first(); const rowText = await row.innerText();
    const controls = await row.locator('a,button').evaluateAll(es => es.map(e => ({ text: e.textContent.trim(), href: e.getAttribute('href'), onclick: e.getAttribute('onclick'), class: e.className })));
    fs.writeFileSync(path.join(dir, 'status.json'), JSON.stringify({ code, rowText, controls, cancelled: false }, null, 2));
    const detailLink = row.locator('a[href*="detailpembelian"]').first();
    const originalHtml = fs.readFileSync(path.join(dir, 'payment.html'), 'utf8');
    const detail = await detailLink.count() ? await detailLink.getAttribute('href') : originalHtml.match(/href="([^"]*\/home\/detailpembelian\/\d+)"/)?.[1];
    if (!detail) throw new Error('Link detail order uji tidak tersedia');
    await p.goto(detail, { waitUntil: 'domcontentloaded' }); await p.waitForLoadState('networkidle', { timeout: 10000 }).catch(() => {});
    const text = await p.locator('body').innerText(); fs.writeFileSync(path.join(dir, 'user-detail.txt'), text);
    const detailControls = await p.locator('a,button').evaluateAll(es => es.filter(e => /batal|cancel|bayar|saldo/i.test(e.textContent)).map(e => ({ text: e.textContent.trim(), href: e.getAttribute('href'), onclick: e.getAttribute('onclick'), visible: !!e.offsetParent })));
    const data = { code, rowText, controls, detailControls, cancelled: false };
    fs.writeFileSync(path.join(dir, 'status.json'), JSON.stringify(data, null, 2)); console.log(JSON.stringify(data));
  } finally { await browser.close(); }
})().catch(e => { console.error(e.message); process.exitCode = 1; });
