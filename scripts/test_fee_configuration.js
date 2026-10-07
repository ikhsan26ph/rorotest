// Test nilai Finance terhadap quote backend dan renderer showva milik aplikasi.
// Tidak memanggil gateway; hasil quote bukan bukti pembayaran/ledger.
const fs = require('fs'); const path = require('path');
const { chromium } = require('@playwright/test'); const { parseEnv } = require('../tests/helpers/env');
const ROOT = path.resolve(__dirname, '..'); const dir = path.join(ROOT, 'artifacts/fee-audit/finance'); fs.mkdirSync(dir, { recursive: true });
const baseline = JSON.parse(fs.readFileSync(path.join(dir, 'baseline.json'), 'utf8')).rows;
const orderDir = path.join(ROOT, 'artifacts/fee-audit/order');
const order = JSON.parse(fs.readFileSync(path.join(orderDir, 'order.json'), 'utf8'));
const html = fs.readFileSync(path.join(orderDir, 'payment.html'), 'utf8');
const paymentPath = html.match(/href="(\/home\/pilihpembayaran\/[^"#]+)#/)?.[1];
const bookingId = html.match(/idbooking:\s*'([0-9]+)'/)?.[1];
const rowMatch = html.match(/<tbody class="isidetailpembelian">([\s\S]*?)<\/tbody>/)?.[1];
const prices = [...(rowMatch || '').matchAll(/class="table_harga">Rp\. ([\d.]+)/g)].map(m => +m[1].replace(/\./g, ''));
if (!paymentPath || !bookingId || prices.length !== 3) throw new Error('Komponen order/URL pembayaran belum terverifikasi');
const base = prices[0] + prices[1]; if (base !== prices[2]) throw new Error('Harga + tarif pass tidak cocok subtotal');
const out = { startedAt: new Date().toISOString(), booking: order.bookings[0].code, components: { harga: prices[0], tarifPass: prices[1], base }, scope: 'backend-quote-and-existing-UI-renderer; no-gateway', channels: [], restoration: [] };
const save = () => fs.writeFileSync(path.join(dir, 'calculations.json'), JSON.stringify(out, null, 2));
const numeric = s => Number(String(s).replace(/,/g, ''));
const normLimit = s => String(s).replace(/,/g, '');
const rupiah = s => Number(String(s).replace(/[^0-9]/g, ''));
const map = { 'Bank Mandiri': 'Mandiri', 'Bank BCA': 'BCA', 'Bank BNI': 'BNI', 'Bank BRI': 'BRI' };

async function fields(page, url) {
  await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 30000 });
  await page.locator('#Form_ItemEditForm_jumlah').waitFor({ state: 'visible' });
  return { jumlah: await page.locator('#Form_ItemEditForm_jumlah').inputValue(), processing: await page.locator('#Form_ItemEditForm_processing_fee').inputValue(), limit: await page.locator('#Form_ItemEditForm_limit').inputValue() };
}
async function write(page, url, value) {
  await fields(page, url);
  await page.locator('#Form_ItemEditForm_jumlah').fill(String(value.jumlah));
  await page.locator('#Form_ItemEditForm_processing_fee').fill(String(value.processing));
  const [response] = await Promise.all([
    page.waitForResponse(r => r.request().method() === 'POST' && r.url().includes('/admin/Finance/'), { timeout: 20000 }),
    page.locator('[name="action_save"]').click(),
  ]);
  if (response.status() >= 400) throw new Error('Save Finance HTTP ' + response.status());
  const actual = await fields(page, url);
  if (numeric(actual.jumlah) !== numeric(value.jumlah) || numeric(actual.processing) !== numeric(value.processing) || normLimit(actual.limit) !== normLimit(value.limit)) throw new Error('Nilai tersimpan Finance tidak cocok atau Limit berubah');
  return actual;
}
async function quote(page, channel, expected) {
  const responsePromise = page.waitForResponse(r => r.url().includes('/home/getFeeAdmin') && r.request().method() === 'POST', { timeout: 15000 });
  await page.evaluate(c => window.showva(c), channel);
  const response = await responsePromise; const api = await response.json();
  await page.waitForFunction(() => jQuery.active === 0, null, { timeout: 10000 }).catch(() => {});
  const ui = await page.locator('#totaladmin_modal,#TotalAdmin1,#TotalAll1,#TotalHarga_modal').evaluateAll(es => es.map(e => ({ id: e.id, text: e.textContent.trim() })));
  const fee = ui.find(e => e.id === 'TotalAdmin1'); const total = ui.find(e => e.id === 'TotalAll1');
  const status = Number(api.biayaadmin) === expected && Number(api.subtotal) === base && rupiah(fee?.text) === expected && rupiah(total?.text) === base + expected ? 'passed' : 'failed';
  return { expectedFee: expected, expectedTotal: base + expected, api, ui, status, error: status === 'failed' ? 'Quote backend atau total renderer berbeda dari harga+pass dan fee yang diharapkan.' : null };
}

module.exports = { fields, write, quote, base, baseline };

if (require.main === module) (async () => {
  const env = parseEnv(); const browser = await chromium.launch({ headless: true }); const contexts = [];
  let admin, user;
  try {
    const ac = env.accounts.find(a => a.role === 'Admin Finance');
    const adminContext = await browser.newContext({ baseURL: env.baseUrl }); contexts.push(adminContext); admin = await adminContext.newPage(); admin.setDefaultTimeout(10000);
    await admin.goto('/admin/Finance/', { waitUntil: 'domcontentloaded' }); await admin.getByRole('textbox', { name: 'Email', exact: true }).fill(ac.email); await admin.getByRole('textbox', { name: 'Kata Sandi', exact: true }).fill(ac.password); await admin.getByRole('button', { name: 'Login', exact: true }).click(); await admin.waitForURL(/\/admin\//, { timeout: 30000 });
    const uc = env.accounts.filter(a => /User Umum/i.test(a.role)).at(-1);
    const userContext = await browser.newContext({ baseURL: env.baseUrl }); contexts.push(userContext); user = await userContext.newPage(); user.setDefaultTimeout(10000);
    await userContext.route(/\/home\/(?:apifaspay|apifaspay2|simulator|saveva|potongkomisisaldouser)(?:[/?]|$)/, r => r.abort());
    await user.goto('/user/login', { waitUntil: 'domcontentloaded' }); await user.locator('#username').fill(uc.email); await user.locator('#password').fill(uc.password); await user.locator('#login1').click(); await user.waitForURL(/\/home\//, { timeout: 30000 });
    await user.goto(paymentPath, { waitUntil: 'domcontentloaded' }); await user.waitForFunction(() => typeof window.showva === 'function', null, { timeout: 10000 });
    for (const method of order.methods) {
      const financeName = map[method.text] || method.text; const original = baseline.find(r => r.cells[0].toLowerCase() === financeName.toLowerCase());
      if (!original) throw new Error('Channel Finance tidak ditemukan: ' + method.text);
      const percent = ['OVO', 'DANA', 'QRIS'].includes(financeName);
      const rec = { method: method.text, financeName, type: percent ? 'percent' : 'flat', original: { jumlah: numeric(original.cells[1]), processing: numeric(original.cells[2]), limit: original.cells[3] }, changed: { jumlah: percent ? { OVO: 7, DANA: 4, QRIS: 3 }[financeName] : 13500, processing: 1700, limit: original.cells[3] } };
      out.channels.push(rec); save();
      let changed = false;
      try {
        const before = await fields(admin, original.edit);
        if (numeric(before.jumlah) !== rec.original.jumlah || numeric(before.processing) !== rec.original.processing || normLimit(before.limit) !== normLimit(rec.original.limit)) throw new Error('Konfigurasi sudah berbeda dari snapshot; hindari menimpa perubahan di luar run');
        const calculate = value => (percent ? base * value.jumlah / 100 : value.jumlah) + value.processing;
        rec.before = await quote(user, method.attrs['data-channel'], calculate(rec.original)); save();
        changed = true; rec.saved = await write(admin, original.edit, rec.changed); save();
        rec.after = await quote(user, method.attrs['data-channel'], calculate(rec.changed));
        rec.status = rec.before.status === 'passed' && rec.after.status === 'passed' ? 'passed' : 'failed';
        if (rec.status === 'failed') { rec.screenshot = path.join(dir, financeName + '-failed.png'); await user.screenshot({ path: rec.screenshot, fullPage: true }); }
      } catch (e) { rec.status = 'blocked'; rec.error = e.message; rec.screenshot = path.join(dir, financeName + '-blocked.png'); await user.screenshot({ path: rec.screenshot, fullPage: true }).catch(() => {}); }
      finally {
        if (changed) {
          try { const restored = await write(admin, original.edit, rec.original); out.restoration.push({ financeName, status: 'passed', restored }); }
          catch (e) { out.restoration.push({ financeName, status: 'failed', error: e.message }); save(); throw new Error('Pemulihan gagal ' + financeName + ': ' + e.message); }
        }
        save();
      }
      console.log(method.text, rec.status, JSON.stringify({ before: rec.before?.api?.biayaadmin, after: rec.after?.api?.biayaadmin, expected: rec.after?.expectedFee, error: rec.error }));
    }
    await admin.goto('/admin/Finance/', { waitUntil: 'domcontentloaded' });
    const rows = await admin.locator('tbody tr').evaluateAll(es => es.filter(e => e.querySelector('a.edit-link')).map(e => [...e.querySelectorAll('td')].slice(0, 4).map(e => e.innerText.trim())));
    out.finalConfig = rows; out.baselineRestored = JSON.stringify(rows) === JSON.stringify(baseline.map(r => r.cells.slice(0, 4))); save();
  } finally { for (const c of contexts) await c.close(); await browser.close(); out.finishedAt = new Date().toISOString(); save(); }
})().catch(e => { out.fatal = e.message; save(); console.error(e.message); process.exitCode = 1; });
