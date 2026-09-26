// Sesi portal Agen (/agen). Guard: dua kegagalan login berturut-turut menghentikan percobaan.
const fs = require('fs');
const path = require('path');
const { parseEnv } = require('./env');

const FAIL_FILE = path.join(__dirname, '..', '..', 'artifacts', '.auth', 'login-failures-agent.json');
const readFailures = () => { try { return JSON.parse(fs.readFileSync(FAIL_FILE, 'utf8')).count || 0; } catch { return 0; } };
const writeFailures = (count) => {
  fs.mkdirSync(path.dirname(FAIL_FILE), { recursive: true });
  fs.writeFileSync(FAIL_FILE, JSON.stringify({ count, at: new Date().toISOString() }));
};

async function loginAgent(browser) {
  const { baseUrl, accounts } = parseEnv();
  const acct = accounts.find((account) => account.role.trim().toLowerCase() === 'agen');
  if (!acct) throw new Error('config/env.md: tidak ada akun dengan role "Agen"');
  if (readFailures() >= 2) throw new Error('Login Agen sudah gagal 2x berturut-turut — berhenti dan periksa kredensial.');

  const context = await browser.newContext({ baseURL: baseUrl, viewport: { width: 1440, height: 900 } });
  const page = await context.newPage();
  try {
    await page.goto('/agen', { waitUntil: 'domcontentloaded', timeout: 60_000 });
    await page.locator('#username').waitFor({ state: 'visible', timeout: 30_000 });
  } catch (error) {
    await context.close();
    throw new Error(`Halaman login Agen tidak terbuka (tidak dihitung sebagai login gagal): ${error.message}`);
  }
  try {
    await page.locator('#username').fill(acct.email);
    await page.locator('#password').fill(acct.password);
    await page.getByRole('button', { name: 'Login', exact: true }).click();
    await page.locator('#signOut').waitFor({ state: 'visible', timeout: 30_000 });
    await page.waitForLoadState('domcontentloaded');
    writeFailures(0);
  } catch (error) {
    writeFailures(readFailures() + 1);
    await context.close();
    throw new Error(`Login portal Agen gagal (percobaan ${readFailures()}/2): ${error.message}`);
  }
  const landing = page.url();
  await page.close();
  return { context, acct, landing };
}

module.exports = { loginAgent };
