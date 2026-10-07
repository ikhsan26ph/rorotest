// Satu order uji; berhenti di daftar metode pembayaran. Tidak memanggil simulator.
const fs = require('fs'); const path = require('path');
const { chromium } = require('@playwright/test'); const { parseEnv } = require('../tests/helpers/env');
const ROOT = path.resolve(__dirname, '..');
const tag = process.env.FEE_ORDER_TAG; const run = process.env.FEE_PURCHASE_RUN; if(!tag||!run||!/^[0-9]{8}-[0-9]{6}$/.test(run)) throw Error('Run/tag baru wajib diisi');
if (!/^[a-z0-9-]+$/.test(tag)) throw new Error('Tag artifact tidak valid');
const dir = path.join(ROOT, 'artifacts/fee-purchase', run, 'orders', tag); if(fs.existsSync(path.join(dir,'order.json'))) throw Error('Artifact order sudah ada; tidak membuat booking ulang'); fs.mkdirSync(dir, { recursive: true });
const testIndex = Number(tag.match(/(\d+)$/)?.[1] || 1);
const testSuffix = String.fromCharCode(64 + testIndex);
const out = { startedAt: new Date().toISOString(), bookings: [], gatewayCompleted: false };
const save = () => fs.writeFileSync(path.join(dir, 'order.json'), JSON.stringify(out, null, 2));
(async () => {
  const env = parseEnv(); const account = env.accounts.filter(a => /User Umum/i.test(a.role)).at(-1);
  const config = fs.readFileSync(path.join(ROOT, 'config/env.md'), 'utf8');
  const contact = key => config.split('\n').map(l => l.split('|').map(x => x.trim())).find(c => c[1] === key)?.[2];
  if (!contact('kontakTestNotifikasi') || !contact('kontakTestWhatsapp')) throw new Error('Kontak test belum tersedia');
  const browser = await chromium.launch({ headless: true }); const context = await browser.newContext({ baseURL: env.baseUrl }); const p = await context.newPage();
  let creates = 0;
  await context.route('**/home/savebooking**', r => { creates++; return creates === 1 ? r.continue() : r.abort(); });
  await context.route('**/home/simulator**', r => r.abort());
  p.on('dialog', d => d.accept());
  try {
    await p.goto('/user/login', { waitUntil: 'domcontentloaded' }); await p.locator('#username').fill(account.email); await p.locator('#password').fill(account.password); await p.locator('#login1').click(); await p.waitForURL(/\/home\//, { timeout: 30000 });
    await p.goto('/home/pencarian?kota_asal=6&kota_tujuan=5&tgl_berangkat=09%2F10%2F2026&jenis=%25&kelas=%25&golongan_kendaraan=%25&Carijadwal=1', { waitUntil: 'domcontentloaded' });
    await p.locator('[id^=btn_pilih]').last().waitFor({ timeout: 30000 });
    const button = p.locator('[id^=btn_pilih]').last(); const id = (await button.getAttribute('id')).replace('btn_pilih', '');
    const allSchedules=await p.locator('[id^=btn_pilih]').evaluateAll(es=>es.map(e=>({id:e.id,description:e.closest('.card').innerText}))); out.schedulesObserved=allSchedules; const schedule = await button.evaluate(e => e.closest('.card').innerText); if (!/AUTOTEST-/.test(schedule)) throw new Error('Jadwal bukan data test');
    out.schedule = { id, description: schedule.trim() }; save();
    await button.click(); const quantities = p.locator('.masukkan-jumlah:visible'); await quantities.first().waitFor();
    const adults = p.locator('.masukkan-jumlah[ketgolongan="Dewasa"]:visible').first();
    if (+await adults.getAttribute('max_kuota') < 1) throw new Error('Kuota Dewasa tidak tersedia');
    out.ticket = await adults.evaluate(e => e.closest('tr').innerText.trim()); await adults.fill('1'); await adults.dispatchEvent('keyup'); await adults.dispatchEvent('change');
    await p.locator('.pesannya' + id).click(); await p.waitForURL(/inputpesanan/, { timeout: 30000 });
    await p.locator('#no_hp_pemesan').fill(contact('kontakTestWhatsapp'));
    if (await p.locator('#emailPemesan').isVisible()) await p.locator('#emailPemesan').fill(contact('kontakTestNotifikasi'));
    if (await p.locator('#nama').isVisible()) await p.locator('#nama').fill('AUTOTEST-'+run.slice(0,8)+'-FEE'+run.slice(-6)+' PEMBELI ' + testSuffix);
    const titles = p.locator('select[name="title_penumpang[]"]:visible');
    for (let i = 0; i < await titles.count(); i++) {
      const t = titles.nth(i); const key = (await t.getAttribute('id')).replace('titleberangkat', '');
      const options = await t.locator('option').evaluateAll(es => es.map(e => ({ value: e.value, text: e.text.trim() })));
      await t.selectOption(options.find(o => o.value && !/pilih|---/i.test(o.text)).value);
      await p.locator('.nama_penumpang' + key).fill('AUTOTEST-'+run.slice(0,8)+'-FEE'+run.slice(-6)+' PENUMPANG ' + testSuffix);
      const identity = p.locator('#jenis_identitasberangkat' + key); if (await identity.isVisible()) { await identity.selectOption('KTP'); await p.locator('.identitas_penumpang' + key + ':visible').fill('990710'+run.slice(-6)+String(testIndex).padStart(4,'0')); }
      await p.locator('#datepicker' + key).fill('01/01/1990'); await p.locator('#datepicker' + key).dispatchEvent('change'); await p.keyboard.press('Escape'); await p.locator('#kotaberangkat' + key).selectOption({ label: 'Parepare' });
    }
    out.inputSummary = (await p.locator('body').innerText()).match(/Total Pembayaran[\s\S]{0,100}/)?.[0];
    await p.locator('label[for=exampleCustomCheckbox1266]').click();
    const handlers = await p.locator('#lanjut_bayar').evaluate(e => (jQuery._data(e, 'events') || {}).click?.length || 0); if (handlers !== 1) throw new Error('Handler submit bukan satu: ' + handlers);
    await p.locator('#lanjut_bayar').click(); await p.waitForURL(/pilihpembayaran\//, { timeout: 45000 });
    await p.waitForLoadState('networkidle', { timeout: 10000 }).catch(() => {});
    const text = await p.locator('body').innerText(); const booking = text.match(/Order\s*:\s*([A-Z]\d{7})/)?.[1];
    if (booking) out.bookings.push({ code: booking, scheduleId: id, cleanup: 'pending' });
    out.savebookingCount = creates;
    out.methods = await p.locator('.pilihbankbayar').evaluateAll(es => es.filter(e => e.offsetParent).map(e => ({ text: e.innerText.trim(), attrs: Object.fromEntries([...e.attributes].map(a => [a.name, a.value])) })));
    fs.writeFileSync(path.join(dir, 'payment.txt'), text); fs.writeFileSync(path.join(dir, 'payment.html'), await p.content());
    out.status = 'prepared'; save(); console.log(JSON.stringify({ booking, methods: out.methods.map(m => m.text), savebookingCount: creates }));
  } catch (e) { out.status = 'blocked'; out.error = e.message; out.savebookingCount = creates; save(); await p.screenshot({ path: path.join(dir, 'blocked.png'), fullPage: true }).catch(() => {}); console.log(JSON.stringify({ status: out.status, error: out.error, savebookingCount: creates })); }
  finally { await browser.close(); save(); }
})().catch(e => { out.error = e.message; save(); console.error(e.message); process.exitCode = 1; });
