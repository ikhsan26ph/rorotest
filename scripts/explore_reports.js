const fs = require('fs');
const path = require('path');
const { chromium } = require('@playwright/test');
const { loginPartner } = require('../tests/helpers/partner-session');

const ROOT = path.join(__dirname, '..');
const RUN_ID = new Date().toISOString().replace(/[-:]/g, '').replace(/\..+/, '').replace('T', '-');
const OUT_DIR = path.join(ROOT, 'artifacts', 'screenshots', 'explore', `${RUN_ID}-reports`);
const OUT_JSON = path.join(ROOT, 'artifacts', 'explore', `${RUN_ID}-reports.json`);

const modules = [
  ['Penjualan Harian', '/partner/laporanpenjualanharian'],
  ['Pendapatan Penumpang', '/partner/laporanPendapatanPenumpang'],
  ['Pendapatan Kendaraan', '/partner/laporanrincianpendapatankendaraan'],
  ['Rekap Pendapatan Per Trip', '/partner/laporanpendapatanpertrip'],
  ['Laporan Pembatalan Tiket', '/partner/laporanpembatalantiket'],
  ['Rekap Asuransi', '/partner/laporanrekapasuransi'],
  ['Pemakaian Saldo', '/partner/laporanpemakaiansaldo'],
  ['Penjualan Harian Agen', '/partner/laporanpenjualanharianagen'],
  ['Rekap Penjualan Agen', '/partner/laporanrekappenjualanagen'],
  ['Pembatalan Tiket Agen', '/partner/laporanpembatalantiketagen'],
];

function slug(value) {
  return value.replace(/^\//, '').replace(/[^a-z0-9]+/gi, '-').toLowerCase();
}

async function inspect(page, route, role, moduleName) {
  const started = Date.now();
  const requests = [];
  const onRequest = (request) => {
    const parsed = new URL(request.url());
    if (request.method() !== 'GET' && /\/(partner|home|jsonpage)\//.test(parsed.pathname)) requests.push({ method: request.method(), path: parsed.pathname });
  };
  page.on('request', onRequest);
  try {
    const response = await page.goto(route, { waitUntil: 'domcontentloaded', timeout: 60_000 });
    await page.waitForTimeout(3_000);
    const data = await page.evaluate(() => {
      const visible = (el) => !!el.offsetParent;
      const text = (el) => (el.innerText || el.value || el.title || '').trim().replace(/\s+/g, ' ');
      const content = document.querySelector('.app-main__inner') || document.querySelector('main') || document.body;
      return {
        title: document.title,
        labels: [...content.querySelectorAll('h1,h2,h3,h4,h5,label,legend')].filter(visible).map(text).filter(Boolean).slice(0, 120),
        controls: [...content.querySelectorAll('button,input[type="submit"],a.btn,[role="button"]')]
          .filter(visible).map((el) => ({ text: text(el), id: el.id || null, disabled: !!el.disabled }))
          .filter((item) => item.text).slice(0, 100),
        fields: [...content.querySelectorAll('input,select,textarea')]
          .filter((el) => visible(el) && el.type !== 'hidden')
          .map((el) => ({ tag: el.tagName.toLowerCase(), type: el.type || null, name: el.name || null, id: el.id || null, disabled: el.disabled, readonly: el.readOnly, placeholder: el.placeholder || null }))
          .slice(0, 250),
        forms: [...content.querySelectorAll('form')].map((form) => ({ method: (form.method || 'get').toUpperCase(), action: form.action })),
        tables: [...content.querySelectorAll('table')].filter(visible).map((table) => ({
          headers: [...table.querySelectorAll('thead th')].map(text).filter(Boolean), rows: table.querySelectorAll('tbody tr').length,
          footer: [...table.querySelectorAll('tfoot th,tfoot td')].map(text).filter(Boolean),
        })),
        bodySample: content.innerText.trim().replace(/\s+/g, ' ').slice(0, 3_000),
      };
    });
    let filterPanel = null;
    const filterButton = page.getByText('Filter', { exact: true }).first();
    if (await filterButton.count()) {
      await filterButton.click();
      await page.waitForTimeout(400);
      filterPanel = await page.evaluate(() => {
        const visible = (el) => !!el.offsetParent;
        const text = (el) => (el.innerText || el.value || '').trim().replace(/\s+/g, ' ');
        const content = document.querySelector('.app-main__inner') || document.body;
        return {
          labels: [...content.querySelectorAll('label,legend')].filter(visible).map(text).filter(Boolean),
          fields: [...content.querySelectorAll('input,select,textarea')]
            .filter((el) => visible(el) && el.type !== 'hidden' && el.id !== 'valuelimit')
            .map((el) => ({ tag: el.tagName.toLowerCase(), type: el.type || null, name: el.name || null, id: el.id || null, placeholder: el.placeholder || null })),
          controls: [...content.querySelectorAll('button,input[type="submit"],a.btn')].filter(visible).map(text).filter(Boolean),
        };
      });
    }
    page.off('request', onRequest);
    const screenshot = path.join(OUT_DIR, `${role}-${slug(route)}.png`);
    await page.screenshot({ path: screenshot, fullPage: false });
    return { role, module: moduleName, route, finalUrl: page.url(), status: response?.status() ?? null,
      durationMs: Date.now() - started, screenshot: path.relative(ROOT, screenshot), requests, filterPanel, ...data };
  } catch (error) {
    page.off('request', onRequest);
    return { role, module: moduleName, route, finalUrl: page.url(), durationMs: Date.now() - started, requests, error: error.message };
  }
}

(async () => {
  fs.mkdirSync(OUT_DIR, { recursive: true });
  fs.mkdirSync(path.dirname(OUT_JSON), { recursive: true });
  const browser = await chromium.launch({ headless: true });
  const results = [];
  for (const [keyword, role] of [['Operator Pusat', 'pusat'], ['Operator Cabang', 'cabang']]) {
    const session = await loginPartner(browser, keyword);
    const page = await session.context.newPage();
    for (const [moduleName, route] of modules) {
      const result = await inspect(page, route, role, moduleName);
      results.push(result);
      console.log(role, moduleName, result.status ?? 'ERR', `${result.durationMs}ms`, result.error || new URL(result.finalUrl).pathname);
    }
    await page.close();
    await session.context.close();
  }
  await browser.close();
  fs.writeFileSync(OUT_JSON, JSON.stringify({ runId: RUN_ID, results }, null, 2));
  console.log('OUTPUT', OUT_JSON);
})().catch((error) => {
  console.error(error.stack || error.message);
  process.exit(1);
});
