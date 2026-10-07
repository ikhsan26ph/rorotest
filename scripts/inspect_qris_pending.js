const fs = require('fs'); const path = require('path');
const { chromium } = require('@playwright/test'); const { parseEnv } = require('../tests/helpers/env');
const ROOT = path.resolve(__dirname, '..'); const root = path.join(ROOT, 'artifacts/fee-audit');
const stage = JSON.parse(fs.readFileSync(path.join(root, 'instructions/instructions.json'), 'utf8'));
const method = stage.methods.filter(m => m.method === 'QRIS').at(-1);
const index = stage.bookings.findIndex(b => b.code === method.booking);
const file = path.join(root, index === 0 ? 'order' : `gateway-order-${String(index + 1).padStart(2, '0')}`, 'payment.html');
const route = fs.readFileSync(file, 'utf8').match(/href="(\/home\/pilihpembayaran\/[^"#]+)#/)?.[1];
const result = { code: method.booking, issuedAmount: method.gateway.money.amount, responses: [] };
function financial(obj, prefix = '') {
  const fields = {};
  if (!obj || typeof obj !== 'object') return fields;
  for (const [k, v] of Object.entries(obj)) {
    const name = prefix ? prefix + '.' + k : k;
    if (v && typeof v === 'object') Object.assign(fields, financial(v, name));
    else if (/amount|fee|total|harga|subtotal/i.test(k) && /^\d+(\.\d+)?$/.test(String(v))) fields[name] = Number(v);
    else if (typeof v === 'string' && /^000201/.test(v)) {
      let cursor = 0;
      while (cursor + 4 <= v.length) {
        const tag = v.slice(cursor, cursor + 2), length = Number(v.slice(cursor + 2, cursor + 4));
        if (!Number.isFinite(length) || cursor + 4 + length > v.length) break;
        const value = v.slice(cursor + 4, cursor + 4 + length);
        if (tag === '54' && /^\d+(\.\d+)?$/.test(value)) fields[name + '.encodedAmount'] = Number(value);
        cursor += 4 + length;
      }
    }
  }
  return fields;
}
(async () => {
  const env = parseEnv(); const ac = env.accounts.filter(a => /User Umum/i.test(a.role)).at(-1); const b = await chromium.launch({ headless: true }); const c = await b.newContext({ baseURL: env.baseUrl }); const p = await c.newPage();
  try {
    await p.goto('/user/login', { waitUntil: 'domcontentloaded' }); await p.locator('#username').fill(ac.email); await p.locator('#password').fill(ac.password); await p.locator('#login1').click(); await p.waitForURL(/\/home\//, { timeout: 30000 });
    p.on('response', async r => { const u = new URL(r.url()); if (/cekva|getFeeAdmin/.test(u.pathname)) { try { const data = await r.json(); result.responses.push({ path: u.pathname, money: financial(data), status: data.status_code || null }); } catch {} } });
    await p.goto(route, { waitUntil: 'domcontentloaded' }); await p.waitForLoadState('networkidle', { timeout: 10000 }).catch(() => {}); await p.waitForTimeout(1000);
    result.fee = (await p.locator('#TotalAdmin1').textContent()).trim(); result.total = (await p.locator('#TotalAll1').textContent()).trim();
    result.domAmounts = await p.locator('input').evaluateAll(es => es.filter(e => /totalforqr|amount|harga/i.test(e.name + ' ' + e.id + ' ' + e.className)).map(e => ({ id: e.id, class: e.className, value: e.value })));
    result.simulatorAmount = new URL(await p.locator('#linknya').getAttribute('href'), env.baseUrl).searchParams.get('amount');
    fs.writeFileSync(path.join(root, 'instructions/qris-invoice-amount.json'), JSON.stringify(result, null, 2)); console.log(JSON.stringify(result));
  } finally { await b.close(); }
})().catch(e => { console.error(e.message); process.exitCode = 1; });
