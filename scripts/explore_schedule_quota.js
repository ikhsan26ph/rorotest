const fs = require('fs');
const path = require('path');
const { chromium } = require('@playwright/test');
const { loginPartner } = require('../tests/helpers/partner-session');

const ROOT = path.join(__dirname, '..');
const RUN_ID = new Date().toISOString().replace(/[-:]/g, '').replace(/\..+/, '').replace('T', '-');
const OUT_DIR = path.join(ROOT, 'artifacts', 'screenshots', 'explore', `${RUN_ID}-schedule-quota`);
const OUT_JSON = path.join(ROOT, 'artifacts', 'explore', `${RUN_ID}-schedule-quota.json`);
const unsafe = /hapus|delete|destroy|remove|logout|signout|keluar|download|export|print|cetak|bayar|payment|topup/i;
const childHint = /tambah|buat|create|detail|show|edit|ubah|kuota|jadwal|schedule/i;

function slug(value) {
  return value.replace(/^\//, '').replace(/[^a-z0-9]+/gi, '-').toLowerCase();
}

function routeShape(href) {
  const pathname = new URL(href).pathname;
  return pathname
    .replace(/\/[A-Za-z0-9+_=-]{16,}(?=\/|$)/g, '/:token')
    .replace(/\/\d+(?=\/|$)/g, '/:id');
}

async function inspectDynamicForm(page, role) {
  const requests = [];
  const record = (request) => {
    if (request.method() !== 'GET' || !/\/(partner|jsonpage)\//.test(request.url())) {
      requests.push({ method: request.method(), url: new URL(request.url()).pathname });
    }
  };
  page.on('request', record);
  await page.locator('#trayek').selectOption({ index: 1 });
  await page.waitForTimeout(2_000);
  await page.locator('#kapal').selectOption({ index: 1 });
  await page.waitForTimeout(3_000);
  page.off('request', record);
  const data = await page.evaluate(() => {
    const visible = (el) => !!el.offsetParent;
    const text = (el) => (el.innerText || el.value || '').trim().replace(/\s+/g, ' ');
    const content = document.querySelector('.app-main__inner') || document.body;
    return {
      labels: [...content.querySelectorAll('label,legend,h1,h2,h3,h4,h5')].filter(visible).map(text).filter(Boolean),
      fields: [...content.querySelectorAll('input,select,textarea')].filter((el) => visible(el) && el.type !== 'hidden').map((el) => ({
        tag: el.tagName.toLowerCase(), type: el.type || null, name: el.name || null, id: el.id || null,
        required: el.required, disabled: el.disabled, readonly: el.readOnly,
      })),
      controls: [...content.querySelectorAll('button,input[type="submit"],a.btn')].filter(visible).map(text).filter(Boolean),
      tables: [...content.querySelectorAll('table')].filter(visible).map((table) => ({
        headers: [...table.querySelectorAll('thead th')].map(text).filter(Boolean), rows: table.querySelectorAll('tbody tr').length,
      })),
      bodySample: content.innerText.trim().replace(/\s+/g, ' ').slice(0, 4_000),
    };
  });
  const screenshot = path.join(OUT_DIR, `${role}-3-dynamic-schedule-form.png`);
  await page.screenshot({ path: screenshot, fullPage: false });
  const tabs = [];
  for (const tabName of ['KUOTA', 'JADWAL', 'CREW LIST']) {
    const tab = page.getByText(tabName, { exact: true }).first();
    if (!(await tab.count())) continue;
    await tab.click();
    await page.waitForTimeout(500);
    const state = await page.evaluate(() => {
      const visible = (el) => !!el.offsetParent;
      const text = (el) => (el.innerText || el.value || '').trim().replace(/\s+/g, ' ');
      const content = document.querySelector('.app-main__inner') || document.body;
      return {
        fields: [...content.querySelectorAll('input,select,textarea')].filter((el) => visible(el) && el.type !== 'hidden').map((el) => ({
          tag: el.tagName.toLowerCase(), type: el.type || null, name: el.name || null, id: el.id || null,
          disabled: el.disabled, readonly: el.readOnly,
        })),
        tables: [...content.querySelectorAll('table')].filter(visible).map((table) => ({
          headers: [...table.querySelectorAll('thead th')].map(text).filter(Boolean), rows: table.querySelectorAll('tbody tr').length,
        })),
        text: content.innerText.trim().replace(/\s+/g, ' ').slice(-1_500),
      };
    });
    const tabShot = path.join(OUT_DIR, `${role}-3-tab-${slug(tabName)}.png`);
    await page.screenshot({ path: tabShot, fullPage: false });
    tabs.push({ name: tabName, screenshot: path.relative(ROOT, tabShot), ...state });
  }
  return { role, level: 3, finalUrl: page.url(), screenshot: path.relative(ROOT, screenshot), requests, tabs, ...data };
}

async function inspect(page, url, role, level) {
  const started = Date.now();
  try {
    const response = await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 60_000 });
    await page.waitForTimeout(2_000);
    const data = await page.evaluate(() => {
      const visible = (el) => !!el.offsetParent;
      const text = (el) => (el.innerText || el.value || el.title || '').trim().replace(/\s+/g, ' ');
      const content = document.querySelector('.app-main__inner') || document.querySelector('main') || document.body;
      return {
        title: document.title,
        headings: [...content.querySelectorAll('h1,h2,h3,h4,h5,.card-title,.page-title')]
          .filter(visible).map(text).filter(Boolean).slice(0, 30),
        labels: [...content.querySelectorAll('label,legend')]
          .filter(visible).map(text).filter(Boolean).slice(0, 100),
        controls: [...content.querySelectorAll('button,input[type="submit"],a.btn,[role="button"]')]
          .filter(visible).map((el) => ({ text: text(el), href: el.href || null, id: el.id || null, disabled: !!el.disabled }))
          .filter((item) => item.text).slice(0, 80),
        fields: [...content.querySelectorAll('input,select,textarea')]
          .filter((el) => visible(el) && el.type !== 'hidden')
          .map((el) => ({ tag: el.tagName.toLowerCase(), type: el.type || null, name: el.name || null, id: el.id || null, required: el.required, disabled: el.disabled, readonly: el.readOnly }))
          .slice(0, 200),
        forms: [...content.querySelectorAll('form')].map((form) => ({ method: (form.method || 'get').toUpperCase(), action: form.action })),
        tables: [...content.querySelectorAll('table')].filter(visible).map((table) => ({
          headers: [...table.querySelectorAll('thead th')].map(text).filter(Boolean),
          rows: table.querySelectorAll('tbody tr').length,
        })),
        links: [...content.querySelectorAll('a[href]')]
          .filter(visible).map((a) => ({ text: text(a), href: a.href })).filter((a) => a.href),
        bodySample: content.innerText.trim().replace(/\s+/g, ' ').slice(0, 1_500),
      };
    });
    const screenshot = path.join(OUT_DIR, `${role}-${level}-${slug(new URL(page.url()).pathname)}.png`);
    await page.screenshot({ path: screenshot, fullPage: false });
    return {
      role, level, requestedUrl: url, finalUrl: page.url(), status: response?.status() ?? null,
      durationMs: Date.now() - started, screenshot: path.relative(ROOT, screenshot), ...data,
    };
  } catch (error) {
    return { role, level, requestedUrl: url, finalUrl: page.url(), durationMs: Date.now() - started, error: error.message };
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
    const main = await inspect(page, '/partner/masterjadwal', role, 1);
    results.push(main);
    console.log(role, 'main', main.status ?? 'ERR', `${main.durationMs}ms`, main.error || main.finalUrl);

    if (!main.error) {
      const origin = new URL(main.finalUrl).origin;
      const candidates = [
        { text: 'Buat Jadwal', href: origin + '/partner/tambahjadwal' },
        ...main.links,
      ].filter((link) => link.href.startsWith(origin + '/partner/'))
        .filter((link) => !unsafe.test(link.href) && !unsafe.test(link.text))
        .filter((link) => childHint.test(link.href) || childHint.test(link.text));
      const shapes = new Set();
      const children = [];
      for (const item of candidates) {
        const href = item.href.split('#')[0];
        const shape = routeShape(href);
        if (shapes.has(shape)) continue;
        shapes.add(shape);
        children.push({ text: item.text, href, shape });
        if (children.length >= 12) break;
      }
      for (const childInfo of children) {
        const child = await inspect(page, childInfo.href, role, 2);
        child.linkText = childInfo.text;
        child.routeShape = childInfo.shape;
        results.push(child);
        console.log(role, childInfo.shape, child.status ?? 'ERR', `${child.durationMs}ms`, child.error || child.finalUrl);
        if (!child.error && new URL(child.finalUrl).pathname === '/partner/tambahjadwal') {
          const dynamic = await inspectDynamicForm(page, role);
          results.push(dynamic);
          console.log(role, 'dynamic-form', dynamic.fields.length, 'fields', dynamic.requests.length, 'requests');
        }
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
