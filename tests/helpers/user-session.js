// Sesi portal User Umum (/user/login) — dibuat 2026-09-25. Login: #username, #password, tombol #login1.
// Guard aturan docs/agent-guide.md: login gagal 2x berturut-turut → BERHENTI (file artifacts/.auth/login-failures-user.json).
const fs = require('fs');
const path = require('path');
const { parseEnv } = require('./env');

const FAIL_FILE = path.join(__dirname, '..', '..', 'artifacts', '.auth', 'login-failures-user.json');
const readFailures = () => { try { return JSON.parse(fs.readFileSync(FAIL_FILE, 'utf8')).count || 0; } catch { return 0; } };
const writeFailures = (count) => {
  fs.mkdirSync(path.dirname(FAIL_FILE), { recursive: true });
  fs.writeFileSync(FAIL_FILE, JSON.stringify({ count, at: new Date().toISOString() }));
};

async function loginUser(browser) {
  const { baseUrl, accounts } = parseEnv();
  const acct = accounts.find((a) => a.role.toLowerCase().includes('user umum'));
  if (!acct) throw new Error('config/env.md: tidak ada akun dengan role "User Umum"');
  if (readFailures() >= 2) throw new Error('Login User Umum sudah gagal 2x berturut-turut — berhenti. Hapus ' + FAIL_FILE + ' setelah kredensial diperiksa.');
  const context = await browser.newContext({ baseURL: baseUrl, viewport: { width: 1440, height: 900 } });
  const page = await context.newPage();
  // Gagal membuka halaman login (jaringan/server lambat) BUKAN kegagalan kredensial → tidak dihitung guard.
  try {
    await page.goto('/user/login', { waitUntil: 'domcontentloaded', timeout: 60_000 });
    await page.locator('#username').waitFor({ state: 'visible', timeout: 30_000 });
  } catch (err) {
    await context.close();
    throw new Error(`Halaman login User Umum tidak terbuka (tidak dihitung sebagai login gagal): ${err.message}`);
  }
  try {
    await page.locator('#username').fill(acct.email);
    await page.locator('#password').fill(acct.password);
    await page.locator('#login1').click();
    await page.waitForURL((u) => !/\/user\/login/i.test(u.pathname), { timeout: 30_000 });
    await page.waitForLoadState('networkidle').catch(() => {});
    writeFailures(0);
  } catch (err) {
    writeFailures(readFailures() + 1);
    const msg = await page.locator('body').innerText().catch(() => '');
    await context.close();
    throw new Error(`Login User Umum gagal (percobaan ${readFailures()}/2): ${err.message} | ${msg.slice(0, 200)}`);
  }
  const landing = page.url();
  await page.close();
  return { context, acct, landing };
}

module.exports = { loginUser };
