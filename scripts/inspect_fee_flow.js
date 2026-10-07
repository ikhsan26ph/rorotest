const fs = require('fs');
const path = require('path');
const { chromium } = require('@playwright/test');
const { parseEnv } = require('../tests/helpers/env');
const ROOT = path.resolve(__dirname, '..');
const dir = path.join(ROOT, 'artifacts', 'fee-audit', 'flow');
fs.mkdirSync(dir, { recursive: true });
(async () => {
  const env = parseEnv();
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({ baseURL: env.baseUrl });
  const p = await context.newPage();
  const account = env.accounts.filter(a => /User Umum/i.test(a.role)).at(-1);
  await p.goto('/user/login', { waitUntil: 'domcontentloaded' });
  await p.locator('#username').fill(account.email); await p.locator('#password').fill(account.password);
  await p.locator('#login1').click(); await p.waitForURL(/\/home\//, { timeout: 30000 });
  await p.goto('/home/pencarian', { waitUntil: 'domcontentloaded' });
  await p.waitForLoadState('networkidle', { timeout: 10000 }).catch(() => {});
  const data = await p.evaluate(() => ({
    fields: [...document.querySelectorAll('input,select')].filter(e => e.type !== 'hidden').map(e => ({ id: e.id, name: e.name, type: e.type, value: e.value, options: e.tagName === 'SELECT' ? [...e.options].map(o => ({ value: o.value, text: o.text })) : undefined })),
    scripts: [...document.scripts].map(e => e.src).filter(Boolean),
    buttons: [...document.querySelectorAll('button')].map(e => ({ id: e.id, text: e.textContent.trim() })),
    text: document.body.innerText,
  }));
  fs.writeFileSync(path.join(dir, 'search.json'), JSON.stringify(data, null, 2));
  fs.writeFileSync(path.join(dir, 'search.html'), await p.content());
  const scripts = data.scripts.filter(u => new URL(u).origin === env.baseUrl && /javascript|pencarian|pembayaran|order/i.test(u));
  for (const u of scripts) {
    const response = await context.request.get(u);
    fs.writeFileSync(path.join(dir, new URL(u).pathname.replace(/[^a-z0-9.-]+/gi, '_')), await response.text());
  }
  await p.goto('/home/pencarian?kota_asal=6&kota_tujuan=5&tgl_berangkat=09%2F10%2F2026&jenis=%25&kelas=%25&golongan_kendaraan=%25&Carijadwal=1', { waitUntil: 'domcontentloaded' });
  await p.waitForLoadState('networkidle', { timeout: 15000 }).catch(() => {});
  await p.locator('[id^=btn_pilih]').first().waitFor({ state: 'visible', timeout: 20000 }).catch(() => {});
  fs.writeFileSync(path.join(dir, 'schedules.html'), await p.content());
  fs.writeFileSync(path.join(dir, 'schedules.txt'), await p.locator('body').innerText());
  for (const u of await p.locator('script[src]').evaluateAll(es => es.map(e => e.src).filter(u => /javascript\/pencarian/.test(u)))) {
    const response = await context.request.get(u);
    fs.writeFileSync(path.join(dir, 'pencarian.js'), await response.text());
  }
  const choose = p.locator('[id^=btn_pilih]').last();
  if (await choose.count()) {
    await choose.click();
    await p.locator('.masukkan-jumlah:visible').first().waitFor({ timeout: 15000 }).catch(() => {});
    fs.writeFileSync(path.join(dir, 'tickets.html'), await p.content());
    fs.writeFileSync(path.join(dir, 'tickets.json'), JSON.stringify(await p.locator('.masukkan-jumlah:visible').evaluateAll(es => es.map(e => ({ id: e.id, attrs: Object.fromEntries([...e.attributes].map(a => [a.name, a.value])), row: e.closest('tr').innerText }))), null, 2));
  }
  console.log(JSON.stringify({ scripts, schedules: await p.locator('[id^=btn_pilih]').evaluateAll(es => es.map(e => ({ id: e.id, text: e.closest('.card')?.innerText.slice(0, 800) }))) }));
  await browser.close();
})().catch(e => { console.error(e.message); process.exitCode = 1; });
