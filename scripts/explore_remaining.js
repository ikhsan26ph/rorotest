const fs = require('fs');
const path = require('path');
const { chromium } = require('@playwright/test');
const { loginPartner } = require('../tests/helpers/partner-session');
const { loginUser } = require('../tests/helpers/user-session');

const ROOT = path.join(__dirname, '..');
const RUN_ID = new Date().toISOString().replace(/[-:]/g, '').replace(/\..+/, '').replace('T', '-');
const OUT_DIR = path.join(ROOT, 'artifacts', 'screenshots', 'explore', `${RUN_ID}-remaining`);
const OUT_JSON = path.join(ROOT, 'artifacts', 'explore', `${RUN_ID}-remaining.json`);

const dashboardRoutes = [
  '/partner/DashboardListPenjualanPerChannel',
  '/partner/DashboardListPenjualanPerJadwal',
  '/partner/DashboardListPenjualanPenumpang',
  '/partner/DashboardListPenjualanKendaraan',
  '/partner/DashboardListPenjualanBagasiPenumpang',
  '/partner/DashboardListPenjualanBagasiKendaraan',
  '/partner/getDetailTIketGratis',
  '/partner/getDetailPekerja',
];

function slug(route) {
  return route.replace(/^\//, '').replace(/[^a-z0-9]+/gi, '-').toLowerCase();
}

async function inspect(page, route, role) {
  const started = Date.now();
  try {
    const response = await page.goto(route, { waitUntil: 'domcontentloaded', timeout: 60_000 });
    await page.waitForTimeout(2_000);
    const info = await page.evaluate(() => ({
      title: document.title,
      headings: [...document.querySelectorAll('h1,h2,h3,h4,h5,.card-title,.page-title')]
        .filter((el) => el.offsetParent)
        .map((el) => el.innerText.trim().replace(/\s+/g, ' '))
        .filter(Boolean)
        .slice(0, 12),
      buttons: [...document.querySelectorAll('button,input[type="submit"],a.btn')]
        .filter((el) => el.offsetParent)
        .map((el) => (el.innerText || el.value || '').trim().replace(/\s+/g, ' '))
        .filter(Boolean)
        .slice(0, 20),
      bodySample: document.body.innerText.trim().replace(/\s+/g, ' ').slice(0, 500),
    }));
    const screenshot = path.join(OUT_DIR, `${role}-${slug(route)}.png`);
    await page.screenshot({ path: screenshot, fullPage: false });
    return {
      role,
      route,
      finalUrl: page.url(),
      status: response?.status() ?? null,
      durationMs: Date.now() - started,
      screenshot: path.relative(ROOT, screenshot),
      ...info,
    };
  } catch (error) {
    return { role, route, finalUrl: page.url(), durationMs: Date.now() - started, error: error.message };
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
    for (const route of dashboardRoutes) {
      const result = await inspect(page, route, role);
      results.push(result);
      console.log(role, route, result.status ?? 'ERR', `${result.durationMs}ms`, result.error || result.headings.join(' / '));
    }
    await page.close();
    await session.context.close();
  }

  const userSession = await loginUser(browser);
  const userPage = await userSession.context.newPage();
  const hiddenRoute = await inspect(userPage, '/partner/riwayatsaldo', 'user-umum');
  results.push(hiddenRoute);
  console.log('user-umum', hiddenRoute.route, hiddenRoute.status ?? 'ERR', `${hiddenRoute.durationMs}ms`, hiddenRoute.error || hiddenRoute.headings.join(' / '));
  await userPage.close();
  await userSession.context.close();
  await browser.close();

  fs.writeFileSync(OUT_JSON, JSON.stringify({ runId: RUN_ID, results }, null, 2));
  console.log('OUTPUT', OUT_JSON);
})().catch((error) => {
  console.error(error.stack || error.message);
  process.exit(1);
});
