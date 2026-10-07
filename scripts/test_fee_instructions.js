// Uji sampai instruksi bayar saja. Tidak menyelesaikan pembayaran/simulator/otorisasi wallet.
const fs = require('fs'); const path = require('path'); const { execFile } = require('child_process'); const { promisify } = require('util');
const { chromium } = require('@playwright/test'); const { parseEnv } = require('../tests/helpers/env');
const { loginPartner } = require('../tests/helpers/partner-session');
const { fields, write, quote, base, baseline } = require('./test_fee_configuration');
const ROOT = path.resolve(__dirname, '..'); const dir = path.join(ROOT, 'artifacts/fee-audit/instructions'); fs.mkdirSync(dir, { recursive: true });
const originalDir = path.join(ROOT, 'artifacts/fee-audit/order');
const original = JSON.parse(fs.readFileSync(path.join(originalDir, 'order.json'), 'utf8'));
const resultPath = path.join(dir, 'instructions.json');
const out = process.env.FEE_INSTRUCTION_RESUME === '1' && fs.existsSync(resultPath)
  ? JSON.parse(fs.readFileSync(resultPath, 'utf8'))
  : { startedAt: new Date().toISOString(), completedPayment: false, bookings: [...original.bookings], methods: [], restoration: [], rateEvidence: null };
delete out.finishedAt; delete out.baselineRestored;
const save = () => fs.writeFileSync(path.join(dir, 'instructions.json'), JSON.stringify(out, null, 2));
const normalize = x => String(x).replace(/,/g, ''); const rupiah = x => Number(String(x).replace(/[^0-9]/g, ''));
const map = { 'Bank Mandiri': 'Mandiri', 'Bank BCA': 'BCA', 'Bank BNI': 'BNI', 'Bank BRI': 'BRI' };
let currentDir = originalDir; let currentOrder = original;
const paymentPath = () => fs.readFileSync(path.join(currentDir, 'payment.html'), 'utf8').match(/href="(\/home\/pilihpembayaran\/[^"#]+)#/)?.[1];
const currentCode = () => currentOrder.bookings[0].code;
const moneyFields = (obj, prefix = '') => {
  const result = {};
  if (!obj || typeof obj !== 'object') return result;
  for (const [key, value] of Object.entries(obj)) {
    const name = prefix ? `${prefix}.${key}` : key;
    if (value && typeof value === 'object') Object.assign(result, moneyFields(value, name));
    else if (/(amount|fee|subtotal|total)/i.test(key) && /^\d+(\.\d+)?$/.test(String(value))) result[name] = Number(value);
  }
  return result;
};

async function swals(p) {
  const messages = [];
  for (let i = 0; i < 4; i++) {
    const popup = p.locator('.swal2-popup:visible');
    if (!await popup.count()) break;
    const text = await popup.innerText(); messages.push(text.replace(/\s+/g, ' ').slice(0, 350));
    const confirm = popup.locator('.swal2-confirm'); if (!await confirm.count()) break;
    await confirm.click(); await p.waitForTimeout(300);
  }
  return messages;
}
async function readLedger(p, code) {
  await p.goto('/partner/riwayatsaldo', { waitUntil: 'domcontentloaded', timeout: 30000 });
  await p.waitForLoadState('networkidle', { timeout: 7000 }).catch(() => {});
  await p.waitForFunction(() => !/Mohon tunggu sebentar/.test(document.body.innerText), null, { timeout: 7000 }).catch(() => {});
  const saldo = p.locator('a').filter({ hasText: /Saldo Operator/ }).first();
  const saldoText = await saldo.count() ? await saldo.innerText() : null;
  const rows = await p.locator('tr').filter({ hasText: code }).allInnerTexts();
  return { balance: saldoText ? rupiah(saldoText) : null, rows: rows.map(t => t.replace(/\s+/g, ' ').trim()),
    debitForOrder: rows.reduce((s, t) => s + Number((t.match(/-\s*Rp\.\s*([\d.]+)/)?.[1] || '0').replace(/\./g, '')), 0),
    creditForOrder: rows.reduce((s, t) => s + Number((t.match(/\+\s*Rp\.\s*([\d.]+)/)?.[1] || '0').replace(/\./g, '')), 0) };
}

(async () => {
  const env = parseEnv(); const browser = await chromium.launch({ headless: true }); const contexts = [];
  let admin, user, ledger;
  try {
    const adminContext = await browser.newContext({ baseURL: env.baseUrl }); contexts.push(adminContext); admin = await adminContext.newPage(); admin.setDefaultTimeout(10000);
    const ac = env.accounts.find(a => a.role === 'Admin Finance');
    await admin.goto('/admin/Finance/', { waitUntil: 'domcontentloaded' }); await admin.getByRole('textbox', { name: 'Email', exact: true }).fill(ac.email); await admin.getByRole('textbox', { name: 'Kata Sandi', exact: true }).fill(ac.password); await admin.getByRole('button', { name: 'Login', exact: true }).click(); await admin.waitForURL(/\/admin\//, { timeout: 30000 });
    const userContext = await browser.newContext({ baseURL: env.baseUrl }); contexts.push(userContext); user = await userContext.newPage(); user.setDefaultTimeout(15000);
    const uc = env.accounts.filter(a => /User Umum/i.test(a.role)).at(-1);
    // API2 memulai otorisasi wallet; simulator menyelesaikan pembayaran. Keduanya tidak dipanggil pada fase ini.
    await userContext.route(/\/home\/(simulator|apifaspay2)(?:[/?]|$)/, r => r.abort());
    await user.goto('/user/login', { waitUntil: 'domcontentloaded' }); await user.locator('#username').fill(uc.email); await user.locator('#password').fill(uc.password); await user.locator('#login1').click(); await user.waitForURL(/\/home\//, { timeout: 30000 });
    const center = await loginPartner(browser, 'Operator Pusat'); contexts.push(center.context); ledger = await center.context.newPage();

    // Komisi dibaca dari modal Edit Komisi milik tenant, tanpa menyimpan.
    const prahuContext = await browser.newContext({ baseURL: env.baseUrl }); contexts.push(prahuContext); const prahu = await prahuContext.newPage();
    const pc = env.accounts.find(a => /Admin Pusat/i.test(a.role));
    await prahu.goto('/adminprahu', { waitUntil: 'domcontentloaded' }); await prahu.locator('#username').fill(pc.email); await prahu.locator('#password').fill(pc.password); await prahu.getByRole('button', { name: 'Login', exact: true }).click(); await prahu.waitForURL(/\/adminprahu\//, { timeout: 30000 });
    await prahu.goto('/adminprahu/komisi', { waitUntil: 'domcontentloaded' }); await prahu.getByRole('cell', { name: 'PT. JEMBATAN NUSANTARA', exact: true }).waitFor({ timeout: 20000 });
    const tenantRow = prahu.locator('tr').filter({ hasText: 'PT. JEMBATAN NUSANTARA' }).first();
    const edit = tenantRow.getByText('Edit Komisi', { exact: true });
    if (await edit.count()) {
      await edit.click(); await prahu.waitForTimeout(500);
      out.rateEvidence = await prahu.locator('input,select').evaluateAll(es => es.filter(e => e.offsetParent && !/password|token|Security/i.test(e.name)).map(e => ({ id: e.id, name: e.name, value: e.value, label: e.closest('.form-group')?.innerText.replace(/\s+/g, ' ').slice(0, 150) })));
      const rate = out.rateEvidence.find(e => /umum|general|public/i.test(e.id + ' ' + e.name + ' ' + e.label) && /^\d+(\.\d+)?$/.test(e.value));
      if (rate) out.generalCommissionRate = Number(rate.value);
    }
    save(); console.log('KOMISI', JSON.stringify(out.rateEvidence));

    const methods = process.env.FEE_INSTRUCTION_METHODS ? process.env.FEE_INSTRUCTION_METHODS.split(',') : ['Bank Mandiri', 'Bank BCA', 'Bank BNI', 'Bank BRI', 'OVO', 'DANA', 'Alfamart', 'Indomaret', 'QRIS'];
    for (const methodName of methods) {
      const method = original.methods.find(m => m.text === methodName); const financeName = map[methodName] || methodName;
      const snap = baseline.find(r => r.cells[0].toLowerCase() === financeName.toLowerCase());
      const percentage = ['OVO', 'DANA', 'QRIS'].includes(financeName);
      const changed = { jumlah: percentage ? { OVO: 7, DANA: 4, QRIS: 3 }[financeName] : 13500, processing: 1700, limit: snap.cells[3] };
      const initial = { jumlah: Number(snap.cells[1]), processing: Number(snap.cells[2]), limit: snap.cells[3] };
      const expectedFee = (percentage ? base * changed.jumlah / 100 : changed.jumlah) + changed.processing;
      const rec = { method: methodName, changed, expectedFee, expectedTotal: base + expectedFee, status: 'blocked' }; out.methods.push(rec); save();
      let changedFlag = false;
      try {
        await user.goto(paymentPath(), { waitUntil: 'domcontentloaded', timeout: 30000 }); await user.waitForLoadState('networkidle', { timeout: 8000 }).catch(() => {});
        if (!await user.locator('.pilihbankbayar:visible').count()) {
          const change = user.locator('.btn-ganti:visible').first();
          if (await change.count()) { await change.click(); await user.waitForTimeout(500); rec.changeMessages = await swals(user); await user.waitForLoadState('networkidle', { timeout: 8000 }).catch(() => {}); }
        }
        const forceFresh = process.env.FEE_INSTRUCTION_FORCE_FRESH === '1' || out.methods.slice(0, -1).at(-1)?.gatewayError;
        if (forceFresh || !await user.locator('.pilihbankbayar:visible').count()) {
          if (out.bookings.length >= 9) throw new Error('Batas 9 booking run tercapai');
          const tag = `gateway-order-${String(out.bookings.length + 1).padStart(2, '0')}`;
          await promisify(execFile)(process.execPath, [path.join(ROOT, 'scripts/prepare_fee_order.js')], { cwd: ROOT, env: { ...process.env, FEE_ORDER_TAG: tag }, timeout: 180000 });
          currentDir = path.join(ROOT, 'artifacts/fee-audit', tag); currentOrder = JSON.parse(fs.readFileSync(path.join(currentDir, 'order.json'), 'utf8'));
          if (currentOrder.status !== 'prepared' || !currentOrder.bookings.length) throw new Error('Booking pengganti terblokir: ' + currentOrder.error);
          out.bookings.push(...currentOrder.bookings); save(); await user.goto(paymentPath(), { waitUntil: 'domcontentloaded' }); await user.locator('.pilihbankbayar:visible').first().waitFor();
        }
        rec.booking = currentCode(); rec.ledgerBefore = await readLedger(ledger, rec.booking); save();
        const actual = await fields(admin, snap.edit);
        if (normalize(actual.jumlah) !== String(initial.jumlah) || normalize(actual.processing) !== String(initial.processing) || normalize(actual.limit) !== initial.limit) throw new Error('Konfigurasi berbeda dari snapshot; tidak diubah');
        changedFlag = true; await write(admin, snap.edit, changed); save();
        let captured;
        const responseWait = user.waitForResponse(r => {
          if (new URL(r.url()).pathname !== '/home/apifaspay' || r.request().method() !== 'POST') return false;
          const data = new URLSearchParams(r.request().postData() || '');
          return data.get('NomorOrder') === rec.booking && data.get('channel') === method.attrs['data-channel'];
        }, { timeout: 30000 }).then(async r => {
          const t = await r.text(); let data; try { data = JSON.parse(t); } catch {}
          captured = { httpStatus: r.status(), money: moneyFields(data), statusCode: data?.status_code ?? null, errorCode: data?.error_code ?? null,
            errorMessage: String(data?.message || data?.error_message || '').slice(0, 250), exception: /ApiException|unsupported IDR payment methods/i.test(t) ? t.match(/unsupported IDR payment methods|ApiException/i)?.[0] : null };
          return captured;
        }).catch(e => ({ timeout: true, error: e.message.slice(0, 150) }));
        await user.locator('.pilihbankbayar:visible').filter({ hasText: new RegExp('^\\s*' + methodName + '\\s*$') }).first().click();
        rec.gateway = await responseWait;
        await user.waitForFunction(() => jQuery.active === 0, null, { timeout: 15000 }).catch(() => {}); rec.messages = await swals(user);
        rec.ledgerAfter = await readLedger(ledger, rec.booking);
        rec.newDebit = rec.ledgerAfter.debitForOrder - rec.ledgerBefore.debitForOrder;
        if (out.generalCommissionRate !== undefined) rec.expectedDebit = rec.ledgerBefore.debitForOrder ? 0 : Math.ceil(265500 * out.generalCommissionRate / 100);
        const body = await user.locator('body').innerText(); fs.writeFileSync(path.join(dir, financeName + '-instructions.txt'), body);
        rec.gatewayError = rec.gateway.httpStatus >= 400 || rec.gateway.exception || rec.gateway.errorCode || ['DOUBLE_VA', 'ERROR', 'VOID'].includes(rec.gateway.statusCode);
        if (rec.gatewayError) {
          rec.status = rec.gateway.statusCode === 'DOUBLE_VA' ? 'blocked' : 'failed'; rec.error = 'Gateway gagal menyiapkan metode yang ditawarkan UI: ' + JSON.stringify(rec.gateway);
          rec.screenshot = path.join(dir, financeName + '-failed.png'); await user.screenshot({ path: rec.screenshot, fullPage: true });
        } else if (rec.gateway.timeout) { rec.status = 'blocked'; rec.error = 'Tidak mendapat response gateway pada tahap instruksi.'; }
        else {
          rec.quote = await quote(user, method.attrs['data-channel'], expectedFee);
          rec.walletAuthorizationNotStarted = ['OVO', 'DANA'].includes(methodName);
          rec.hasPaymentInstructions = rec.walletAuthorizationNotStarted ? /OVO|DANA/.test(body) : await user.locator('.div-virtual-account:visible,#no_va1:visible,.va_number:visible,.qr:visible,#acc_pay_qris:visible').count() > 0 || /Kode Pembayaran|Nomor Virtual Account|Download QR Code/.test(body);
          rec.status = rec.quote.status === 'passed' && rec.hasPaymentInstructions ? 'passed' : 'blocked';
          if (rec.expectedDebit !== undefined && rec.newDebit !== rec.expectedDebit) { rec.status = 'failed'; rec.error = `Potongan saldo baru ${rec.newDebit}, expected ${rec.expectedDebit}`; }
          if (rec.status === 'failed') { rec.screenshot = path.join(dir, financeName + '-failed.png'); await user.screenshot({ path: rec.screenshot, fullPage: true }); }
        }
      } catch (e) { rec.status = 'blocked'; rec.error = e.message.slice(0, 350); }
      finally {
        if (changedFlag) {
          try { const restored = await write(admin, snap.edit, initial); out.restoration.push({ financeName, status: 'passed', restored }); }
          catch (e) { out.restoration.push({ financeName, status: 'failed', error: e.message }); save(); throw new Error('Pemulihan Finance gagal: ' + e.message); }
        }
        save();
      }
      console.log(methodName, rec.status, JSON.stringify({ booking: rec.booking, gateway: rec.gateway, debit: rec.newDebit, error: rec.error }));
    }
    await admin.goto('/admin/Finance/', { waitUntil: 'domcontentloaded' });
    out.finalConfig = await admin.locator('tbody tr').evaluateAll(es => es.filter(e => e.querySelector('a.edit-link')).map(e => [...e.querySelectorAll('td')].slice(0, 4).map(e => e.innerText.trim())));
    out.baselineRestored = JSON.stringify(out.finalConfig) === JSON.stringify(baseline.map(r => r.cells.slice(0, 4))); save();
  } finally { for (const c of contexts) await c.close(); await browser.close(); out.finishedAt = new Date().toISOString(); save(); }
})().catch(e => { out.fatal = e.message; save(); console.error(e.message); process.exitCode = 1; });
