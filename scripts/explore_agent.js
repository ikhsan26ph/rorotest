const fs = require('fs');
const path = require('path');
const { chromium } = require('@playwright/test');
const { loginAgent } = require('../tests/helpers/agent-session');

const ROOT = path.join(__dirname, '..');
const RUN_ID = new Date().toISOString().replace(/[-:]/g, '').replace(/\..+/, '').replace('T', '-');
const OUT_DIR = path.join(ROOT, 'artifacts', 'screenshots', 'explore', `${RUN_ID}-agent`);
const OUT_JSON = path.join(ROOT, 'artifacts', 'explore', `${RUN_ID}-agent.json`);
const unsafe = /logout|signout|keluar|hapus|delete|destroy|remove|download|export|print|cetak|bayar|payment|topup|isi.?saldo|simpan|submit|proses|approve|setuju|batal|cancel|whatsapp|wa\.me/i;
const detailHint = /detail|show|info|riwayat|profil/i;

function slug(value) { return value.replace(/^\//, '').replace(/[^a-z0-9]+/gi, '-').toLowerCase() || 'root'; }
function routeShape(href) {
  const pathname = new URL(href).pathname.replace(/\/\d+(?=\/|$)/g, '/:id');
  const parts = pathname.split('/');
  if (parts.length > 3 && /detail|show|info|riwayat|profil/i.test(parts.at(-2))) parts[parts.length - 1] = ':id';
  return parts.join('/');
}

async function inspect(page, url, level) {
  const started = Date.now();
  const requests = [];
  const onRequest = (request) => {
    const parsed = new URL(request.url());
    if (request.method() !== 'GET' && /\/(agen|home|jsonpage)\//.test(parsed.pathname)) requests.push({ method: request.method(), path: parsed.pathname });
  };
  page.on('request', onRequest);
  try {
    const response = await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 60_000 });
    await page.waitForTimeout(2_500);
    const data = await page.evaluate(() => {
      const visible = (el) => !!el.offsetParent;
      const text = (el) => (el.innerText || el.value || el.title || '').trim().replace(/\s+/g, ' ');
      const content = document.querySelector('.app-main__inner') || document.querySelector('main') || document.body;
      return {
        title: document.title,
        headings: [...content.querySelectorAll('h1,h2,h3,h4,h5,.card-title,.page-title')].filter(visible).map(text).filter(Boolean).slice(0, 40),
        controls: [...content.querySelectorAll('button,input[type="submit"],a.btn,[role="button"]')].filter(visible)
          .map((el) => ({ text: text(el), href: el.href || null, id: el.id || null, disabled: !!el.disabled })).filter((item) => item.text).slice(0, 100),
        fields: [...content.querySelectorAll('input,select,textarea')].filter((el) => visible(el) && el.type !== 'hidden')
          .map((el) => ({ tag: el.tagName.toLowerCase(), type: el.type || null, name: el.name || null, id: el.id || null, disabled: el.disabled, readonly: el.readOnly })).slice(0, 200),
        tables: [...content.querySelectorAll('table')].filter(visible).map((table) => ({
          headers: [...table.querySelectorAll('thead th')].map(text).filter(Boolean), rows: table.querySelectorAll('tbody tr').length,
        })),
        links: [...content.querySelectorAll('a[href]')].map((a) => ({ text: text(a), href: a.href, visible: visible(a), inNav: !!a.closest('nav,header,.sidebar,.app-sidebar,.vertical-nav-menu') })).filter((a) => a.href),
        navLinks: [...document.querySelectorAll('a[href]')]
          .filter(visible)
          .map((a) => ({ text: text(a), href: a.href, inNav: !!a.closest('nav,header,.sidebar,.app-sidebar,.vertical-nav-menu,ul') }))
          .filter((a) => a.href && a.inNav),
        alerts: [...content.querySelectorAll('.alert,.iziToast,.swal2-container,[role="alert"]')].filter(visible).map(text).filter(Boolean),
        bodySample: content.innerText.trim().replace(/\s+/g, ' ').slice(0, 2_500),
      };
    });
    page.off('request', onRequest);
    const screenshot = path.join(OUT_DIR, `${level}-${slug(new URL(page.url()).pathname)}.png`);
    await page.screenshot({ path: screenshot, fullPage: false });
    return { level, requestedUrl: url, finalUrl: page.url(), status: response?.status() ?? null, durationMs: Date.now() - started,
      screenshot: path.relative(ROOT, screenshot), requests, ...data };
  } catch (error) {
    page.off('request', onRequest);
    return { level, requestedUrl: url, finalUrl: page.url(), durationMs: Date.now() - started, requests, error: error.message };
  }
}

(async () => {
  fs.mkdirSync(OUT_DIR, { recursive: true });
  fs.mkdirSync(path.dirname(OUT_JSON), { recursive: true });
  const browser = await chromium.launch({ headless: true });
  const session = await loginAgent(browser);
  const page = await session.context.newPage();
  const landing = await inspect(page, session.landing, 0);
  const origin = new URL(landing.finalUrl).origin;
  const navUrls = [...new Set(landing.navLinks
    .filter((link) => link.href.startsWith(origin + '/agen') || link.href.startsWith(origin + '/home/'))
    .filter((link) => !unsafe.test(link.href) && !unsafe.test(link.text))
    .map((link) => link.href.split('#')[0]))];

  const results = [landing];
  const visited = new Set([new URL(landing.finalUrl).pathname]);
  for (const url of navUrls) {
    const pathname = new URL(url).pathname;
    if (visited.has(pathname)) continue;
    visited.add(pathname);
    const main = await inspect(page, url, 1);
    results.push(main);
    console.log(pathname, main.status ?? 'ERR', `${main.durationMs}ms`, main.error || main.title);
    if (main.error || new URL(main.finalUrl).pathname !== pathname) continue;
    const shapes = new Set();
    for (const link of main.links) {
      if (!link.href.startsWith(origin + '/')) continue;
      if (unsafe.test(link.href) || unsafe.test(link.text)) continue;
      if (!detailHint.test(link.href) && !detailHint.test(link.text)) continue;
      const shape = routeShape(link.href);
      if (shapes.has(shape) || visited.has(new URL(link.href).pathname)) continue;
      shapes.add(shape);
      const child = await inspect(page, link.href.split('#')[0], 2);
      child.parentPath = pathname;
      child.routeShape = shape;
      results.push(child);
      console.log('  ', shape, child.status ?? 'ERR', `${child.durationMs}ms`);
      if (shapes.size >= 2) break;
    }
  }
  await page.close();
  await session.context.close();
  await browser.close();
  fs.writeFileSync(OUT_JSON, JSON.stringify({ runId: RUN_ID, landing: session.landing, results }, null, 2));
  console.log('OUTPUT', OUT_JSON);
})().catch((error) => {
  console.error(error.stack || error.message);
  process.exit(1);
});
