// Fixture sesi portal Operator (/partner) Sistem Penjualan Tiket Kapal — login per ROLE dari config/env.md.
// Dibuat 2026-09-25 untuk modul yang butuh akun Operator Pusat / Cabang; tidak mengubah tests/helpers/fixtures.js
// (fixture OMS lama, akun #1). Alur login diverifikasi lewat /harvest-selectors 2026-09-25 (shared/selector-map-partner-common.md):
//   goto /partner → #username, #password → tombol "Login" → redirect /partner/profil (pusat) | /partner/profilsubuser (sub user).
// Satu context per role per worker, dibuat lazily saat pertama dipakai, hidup sampai worker selesai (workers: 1).
// Guard aturan docs/agent-guide.md: login gagal 2x berturut-turut → BERHENTI (jangan sampai akun terkunci).
const fs = require('fs');
const path = require('path');
const base = require('@playwright/test');
const { parseEnv } = require('./env');

const FAIL_FILE = path.join(__dirname, '..', '..', 'artifacts', '.auth', 'login-failures-partner.json');

function readFailures() {
  try { return JSON.parse(fs.readFileSync(FAIL_FILE, 'utf8')).count || 0; } catch { return 0; }
}
function writeFailures(count) {
  fs.mkdirSync(path.dirname(FAIL_FILE), { recursive: true });
  fs.writeFileSync(FAIL_FILE, JSON.stringify({ count, at: new Date().toISOString() }));
}

function findAccount(roleKeyword) {
  const { baseUrl, accounts } = parseEnv();
  const acct = accounts.find((a) => a.role.toLowerCase().includes(roleKeyword.toLowerCase()));
  if (!acct) throw new Error(`config/env.md: tidak ada akun dengan role mengandung "${roleKeyword}"`);
  return { baseUrl, acct };
}

async function loginPartner(browser, roleKeyword) {
  const { baseUrl, acct } = findAccount(roleKeyword);
  if (readFailures() >= 2) {
    throw new Error(
      'Login portal Operator sudah gagal 2x berturut-turut — eksekusi dihentikan demi keamanan akun. ' +
      'Periksa kredensial di config/env.md, lalu hapus artifacts/.auth/login-failures-partner.json untuk mencoba lagi.'
    );
  }
  const context = await browser.newContext({ baseURL: baseUrl, viewport: { width: 1440, height: 900 } });
  const page = await context.newPage();
  try {
    await page.goto('/partner', { waitUntil: 'domcontentloaded' });
    await page.locator('#username').fill(acct.email);
    await page.locator('#password').fill(acct.password);
    await page.getByRole('button', { name: 'Login', exact: true }).click();
    await page.waitForURL(/\/partner\/(profil|profilsubuser|dashboard)/i, { timeout: 30_000 });
    await page.waitForLoadState('networkidle').catch(() => {});
    await page.locator('#signOut').waitFor({ state: 'visible', timeout: 15_000 });
    writeFailures(0);
  } catch (err) {
    writeFailures(readFailures() + 1);
    await context.close();
    throw new Error(`Login portal Operator (${acct.role}) gagal (percobaan ${readFailures()}/2): ${err.message}`);
  }
  await page.close();
  return { context, acct };
}

const test = base.test.extend({
  // Context Operator Pusat — dipakai fixture `page` bawaan.
  pusatSession: [
    async ({ browser }, use) => {
      const s = await loginPartner(browser, 'Operator Pusat');
      await use(s);
      await s.context.close();
    },
    { scope: 'worker' },
  ],
  // Context Operator Cabang (Sub User Cabang) — hanya dibuat bila ada test yang memakainya.
  cabangSession: [
    async ({ browser }, use) => {
      const s = await loginPartner(browser, 'Operator Cabang');
      await use(s);
      await s.context.close();
    },
    { scope: 'worker' },
  ],
  context: async ({ pusatSession }, use) => { await use(pusatSession.context); },
  page: async ({ pusatSession }, use) => {
    const page = await pusatSession.context.newPage();
    await use(page);
    await page.close();
  },
  cabangPage: async ({ cabangSession }, use) => {
    const page = await cabangSession.context.newPage();
    await use(page);
    await page.close();
  },
  // Context manual tidak mendapat auto-screenshot dari konfigurasi `screenshot:` — ambil manual saat gagal
  // agar scripts/playwright_to_results.py menemukan attachment "screenshot".
  attachScreenshotOnFailure: [
    async ({ page }, use, testInfo) => {
      await use();
      if (testInfo.status !== testInfo.expectedStatus && !page.isClosed()) {
        const shot = testInfo.outputPath('test-failed-1.png');
        try {
          await page.screenshot({ path: shot, fullPage: true });
          testInfo.attachments.push({ name: 'screenshot', path: shot, contentType: 'image/png' });
        } catch { /* halaman keburu mati */ }
      }
    },
    { auto: true },
  ],
});

module.exports = { test, expect: base.expect, loginPartner };
