// GET/read-only: bandingkan instruksi invoice aktif sesudah Finance dipulihkan.
const fs = require('fs'); const path = require('path');
const { chromium } = require('@playwright/test'); const { parseEnv } = require('../tests/helpers/env');
const ROOT = path.resolve(__dirname, '..'); const root = path.join(ROOT, 'artifacts/fee-audit');
const stage = JSON.parse(fs.readFileSync(path.join(root, 'instructions/instructions.json'), 'utf8'));
const latest = new Map(stage.methods.map(m => [m.method, m]));
const checks = []; const save = () => fs.writeFileSync(path.join(root, 'instructions/pending-totals.json'), JSON.stringify(checks, null, 2));
const number = t => Number(String(t).replace(/[^0-9]/g, ''));
(async () => {
  const env = parseEnv(); const account = env.accounts.filter(a => /User Umum/i.test(a.role)).at(-1);
  const browser = await chromium.launch({ headless: true }); const context = await browser.newContext({ baseURL: env.baseUrl }); const p = await context.newPage();
  try {
    await p.goto('/user/login', { waitUntil: 'domcontentloaded' }); await p.locator('#username').fill(account.email); await p.locator('#password').fill(account.password); await p.locator('#login1').click(); await p.waitForURL(/\/home\//, { timeout: 30000 });
    for (const name of ['Bank Mandiri', 'Bank BCA', 'Bank BNI', 'Bank BRI', 'QRIS']) {
      const m = latest.get(name); if (!m || m.status !== 'passed') continue;
      const index = stage.bookings.findIndex(b => b.code === m.booking);
      const dir = path.join(root, index === 0 ? 'order' : `gateway-order-${String(index + 1).padStart(2, '0')}`);
      const html = fs.readFileSync(path.join(dir, 'payment.html'), 'utf8'); const route = html.match(/href="(\/home\/pilihpembayaran\/[^"#]+)#/)?.[1];
      const rec = { method: name, booking: m.booking, issuedGatewayAmount: m.gateway.money.amount, status: 'blocked', quoteResponses: [] }; checks.push(rec); save();
      const listener = async r => { if (new URL(r.url()).pathname === '/home/getFeeAdmin') { try { rec.quoteResponses.push(await r.json()); } catch {} } };
      p.on('response', listener);
      try {
        await p.goto(route, { waitUntil: 'domcontentloaded', timeout: 30000 });
        await p.waitForLoadState('networkidle', { timeout: 8000 }).catch(() => {});
        await p.waitForFunction(() => jQuery.active === 0, null, { timeout: 8000 }).catch(() => {});
        const text = await p.locator('body').innerText(); if (!text.includes(m.booking)) throw new Error('Halaman tidak menunjukkan kode booking target');
        rec.fee = await p.locator('#TotalAdmin1').textContent().catch(() => null);
        rec.total = await p.locator('#TotalAll1').textContent().catch(() => null);
        rec.displayedTotal = number(rec.total);
        rec.status = rec.quoteResponses.length && rec.total ? (rec.displayedTotal === rec.issuedGatewayAmount ? 'passed' : 'failed') : 'blocked';
        if (rec.status === 'failed') {
          rec.error = `Invoice dibuat ${rec.issuedGatewayAmount}, instruksi setelah restore Finance menampilkan ${rec.displayedTotal}`;
          rec.screenshot = path.join(root, 'instructions', name.replace(/\W+/g, '-') + '-after-restore.png'); await p.screenshot({ path: rec.screenshot, fullPage: true });
        }
        fs.writeFileSync(path.join(root, 'instructions', name.replace(/\W+/g, '-') + '-after-restore.txt'), text);
      } catch (e) { rec.error = e.message.slice(0, 350); }
      p.off('response', listener); save(); console.log(name, rec.status, 'issued', rec.issuedGatewayAmount, 'displayed', rec.displayedTotal, 'quote', rec.quoteResponses.at(-1)?.biayaadmin);
    }
  } finally { await browser.close(); save(); }
})().catch(e => { console.error(e.message); save(); process.exitCode = 1; });
