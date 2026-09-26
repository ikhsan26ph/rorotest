const fs = require('fs');
const path = require('path');
const { chromium } = require('@playwright/test');
const { loginPartner } = require('../tests/helpers/partner-session');

const ROOT = path.join(__dirname, '..');
const RUN_ID = new Date().toISOString().replace(/[-:]/g, '').replace(/\..+/, '').replace('T', '-');
const OUT_DIR = path.join(ROOT, 'artifacts', 'screenshots', 'explore', `${RUN_ID}-master`);
const OUT_JSON = path.join(ROOT, 'artifacts', 'explore', `${RUN_ID}-master.json`);

const modules = [
  ['Master Kelas', '/partner/masterkelasnew'],
  ['Master Golongan', '/partner/mastergolongan'],
  ['Master Kapal', '/partner/mkapal'],
  ['Master Trayek', '/partner/DaftarTrayek'],
  ['Master Harga', '/partner/masterharga'],
  ['Tarif Pass Pelabuhan', '/partner/tarifpass'],
  ['Master Asuransi', '/partner/masterasuransi'],
  ['Master Crew', '/partner/MasterCrew'],
  ['Denda Pembatalan', '/partner/masterdenda'],
  ['Master Informasi', '/partner/informasi_show'],
];

const unsafe = /hapus|delete|destroy|remove|logout|signout|keluar|download|export|print|cetak|bayar|payment|topup/i;
const childHint = /tambah|buat|create|detail|show|edit|setting/i;

function slug(value) {
  return value.replace(/^\//, '').replace(/[^a-z0-9]+/gi, '-').toLowerCase();
}

async function inspect(page, url, role, moduleName, level) {
  const started = Date.now();
  try {
    const response = await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 60_000 });
    await page.waitForTimeout(1_500);
    const data = await page.evaluate(() => {
      const visible = (el) => !!el.offsetParent;
      const text = (el) => (el.innerText || el.value || el.title || '').trim().replace(/\s+/g, ' ');
      const content = document.querySelector('.app-main__inner') || document.querySelector('main') || document.body;
      return {
        title: document.title,
        labels: [...document.querySelectorAll('h1,h2,h3,h4,h5,.card-title,.page-title,label')]
          .filter(visible).map(text).filter(Boolean).slice(0, 40),
        controls: [...document.querySelectorAll('button,input[type="submit"],a.btn,[role="button"]')]
          .filter(visible).map((el) => ({ text: text(el), href: el.href || null, id: el.id || null }))
          .filter((item) => item.text).slice(0, 40),
        fields: [...document.querySelectorAll('input,select,textarea')]
          .filter((el) => visible(el) && el.type !== 'hidden')
          .map((el) => ({ tag: el.tagName.toLowerCase(), type: el.type || null, name: el.name || null, id: el.id || null, required: el.required, disabled: el.disabled, readonly: el.readOnly })),
        forms: [...document.querySelectorAll('form')].map((form) => ({ method: (form.method || 'get').toUpperCase(), action: form.action })),
        tables: [...document.querySelectorAll('table')].filter(visible).map((table) => ({
          headers: [...table.querySelectorAll('thead th')].map(text).filter(Boolean),
          rows: table.querySelectorAll('tbody tr').length,
        })),
        links: [...content.querySelectorAll('a[href]')]
          .filter(visible).map((a) => ({ text: text(a), href: a.href })).filter((a) => a.href),
        bodySample: document.body.innerText.trim().replace(/\s+/g, ' ').slice(0, 800),
      };
    });
    const screenshot = path.join(OUT_DIR, `${role}-${level}-${slug(new URL(page.url()).pathname)}.png`);
    await page.screenshot({ path: screenshot, fullPage: false });
    return {
      role, module: moduleName, level, requestedUrl: url, finalUrl: page.url(),
      status: response?.status() ?? null, durationMs: Date.now() - started,
      screenshot: path.relative(ROOT, screenshot), ...data,
    };
  } catch (error) {
    return { role, module: moduleName, level, requestedUrl: url, finalUrl: page.url(), durationMs: Date.now() - started, error: error.message };
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
      console.log(role, moduleName, main.status ?? 'ERR', `${main.durationMs}ms`, main.error || main.finalUrl);
      if (main.error) continue;
      const actualOrigin = new URL(main.finalUrl).origin;
      const children = [...new Set(main.links
        .filter((link) => link.href.startsWith(actualOrigin + '/partner/'))
        .filter((link) => !unsafe.test(link.href) && !unsafe.test(link.text))
        .filter((link) => childHint.test(link.href) || childHint.test(link.text))
        .map((link) => link.href.split('#')[0]))].slice(0, 5);
      for (const childUrl of children) {
        const child = await inspect(page, childUrl, role, moduleName, 2);
        results.push(child);
        console.log(role, '  child', child.status ?? 'ERR', `${child.durationMs}ms`, child.error || child.finalUrl);
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
