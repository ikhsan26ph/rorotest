const fs = require('fs');
const path = require('path');
const { chromium } = require('@playwright/test');
const { loginPartner } = require('../tests/helpers/partner-session');

const ROOT = path.join(__dirname, '..');
const RUN_ID = new Date().toISOString().replace(/[-:]/g, '').replace(/\..+/, '').replace('T', '-');
const OUT_DIR = path.join(ROOT, 'artifacts', 'screenshots', 'explore', `${RUN_ID}-sales-operations`);
const OUT_JSON = path.join(ROOT, 'artifacts', 'explore', `${RUN_ID}-sales-operations.json`);

const modules = [
  ['Jual Tiket', '/partner/jualtiket'],
  ['Daftar Order', '/partner/daftarpenjualan'],
  ['Cetak Tiket', '/home/directprint'],
  ['Persetujuan Tiket', '/partner/persetujuantiket'],
  ['Daftar Piutang', '/partner/daftarpiutang'],
  ['Manifest', '/partner/manifestkapal'],
  ['Konter Tiket', '/partner/boarding'],
  ['Data Kendaraan', '/partner/data_kendaraan_show'],
];

const unsafe = /hapus|delete|destroy|remove|logout|signout|keluar|download|export|print|cetak|bayar|payment|topup|batal|cancel|approve|setuju|boarding/i;
const detailHint = /detail|show|info|lihat/i;

function slug(value) {
  return value.replace(/^\//, '').replace(/[^a-z0-9]+/gi, '-').toLowerCase();
}

function routeShape(href) {
  const pathname = new URL(href).pathname;
  return pathname
    .replace(/\/[A-Za-z0-9+_=-]{16,}(?=\/|$)/g, '/:token')
    .replace(/\/\d+(?=\/|$)/g, '/:id');
}

async function inspect(page, url, role, moduleName, level) {
  const started = Date.now();
  const requests = [];
  const onRequest = (request) => {
    const parsed = new URL(request.url());
    if (request.method() !== 'GET' && /\/(partner|home|jsonpage)\//.test(parsed.pathname)) {
      requests.push({ method: request.method(), path: parsed.pathname });
    }
  };
  page.on('request', onRequest);
  try {
    const response = await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 60_000 });
    await page.waitForTimeout(3_000);
    const data = await page.evaluate(() => {
      const visible = (el) => !!el.offsetParent;
      const text = (el) => (el.innerText || el.value || el.title || '').trim().replace(/\s+/g, ' ');
      const content = document.querySelector('.app-main__inner') || document.querySelector('main') || document.body;
      return {
        title: document.title,
        headings: [...content.querySelectorAll('h1,h2,h3,h4,h5,.card-title,.page-title')].filter(visible).map(text).filter(Boolean).slice(0, 30),
        labels: [...content.querySelectorAll('label,legend')].filter(visible).map(text).filter(Boolean).slice(0, 100),
        controls: [...content.querySelectorAll('button,input[type="submit"],a.btn,[role="button"]')]
          .filter(visible).map((el) => ({ text: text(el), href: el.href || null, id: el.id || null, disabled: !!el.disabled }))
          .filter((item) => item.text).slice(0, 100),
        fields: [...content.querySelectorAll('input,select,textarea')]
          .filter((el) => visible(el) && el.type !== 'hidden')
          .map((el) => ({ tag: el.tagName.toLowerCase(), type: el.type || null, name: el.name || null, id: el.id || null, disabled: el.disabled, readonly: el.readOnly }))
          .slice(0, 200),
        forms: [...content.querySelectorAll('form')].map((form) => ({ method: (form.method || 'get').toUpperCase(), action: form.action })),
        tables: [...content.querySelectorAll('table')].filter(visible).map((table) => ({
          headers: [...table.querySelectorAll('thead th')].map(text).filter(Boolean), rows: table.querySelectorAll('tbody tr').length,
        })),
        links: [...content.querySelectorAll('a[href]')].filter(visible).map((a) => ({ text: text(a), href: a.href })).filter((a) => a.href),
        alerts: [...content.querySelectorAll('.alert,.iziToast,.swal2-container,[role="alert"]')].filter(visible).map(text).filter(Boolean),
        bodySample: content.innerText.trim().replace(/\s+/g, ' ').slice(0, 2_500),
      };
    });
    page.off('request', onRequest);
    const screenshot = path.join(OUT_DIR, `${role}-${level}-${slug(new URL(page.url()).pathname)}.png`);
    await page.screenshot({ path: screenshot, fullPage: false });
    return {
      role, module: moduleName, level, requestedUrl: url, finalUrl: page.url(), status: response?.status() ?? null,
      durationMs: Date.now() - started, screenshot: path.relative(ROOT, screenshot), requests, ...data,
    };
  } catch (error) {
    page.off('request', onRequest);
    return { role, module: moduleName, level, requestedUrl: url, finalUrl: page.url(), durationMs: Date.now() - started, requests, error: error.message };
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
      const main = await inspect(page, route, role, moduleName, 1);
      results.push(main);
      console.log(role, moduleName, main.status ?? 'ERR', `${main.durationMs}ms`, main.error || new URL(main.finalUrl).pathname);
      if (main.error) continue;
      const requestedPath = new URL(route, main.finalUrl).pathname;
      if (new URL(main.finalUrl).pathname.toLowerCase() !== requestedPath.toLowerCase()) continue;
      const origin = new URL(main.finalUrl).origin;
      const shapes = new Set();
      const children = [];
      for (const link of main.links) {
        if (!link.href.startsWith(origin + '/')) continue;
        if (unsafe.test(link.href) || unsafe.test(link.text)) continue;
        if (!detailHint.test(link.href) && !detailHint.test(link.text)) continue;
        const href = link.href.split('#')[0];
        const shape = routeShape(href);
        if (shapes.has(shape)) continue;
        shapes.add(shape);
        children.push({ href, shape, text: link.text });
        if (children.length >= 2) break;
      }
      for (const info of children) {
        const child = await inspect(page, info.href, role, moduleName, 2);
        child.linkText = info.text;
        child.routeShape = info.shape;
        results.push(child);
        console.log(role, moduleName, info.shape, child.status ?? 'ERR', `${child.durationMs}ms`);
      }
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
