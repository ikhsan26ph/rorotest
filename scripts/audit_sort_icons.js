// Audit read-only: setiap ikon sortir, dua arah, seluruh menu akun env.
// Tidak menyimpan kredensial, payload request lengkap, atau isi baris personal.
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const { chromium } = require('@playwright/test');
const { parseEnv } = require('../tests/helpers/env');

const ROOT = path.resolve(__dirname, '..');
const env = parseEnv();
const resumed = process.env.SORT_AUDIT_RESUME_FILE ? JSON.parse(fs.readFileSync(path.resolve(process.env.SORT_AUDIT_RESUME_FILE))) : null;
const runId = process.env.SORT_AUDIT_RUN_ID || resumed?.runId || new Date().toISOString().replace(/[-:]/g, '').replace('T', '-').slice(0, 15);
const dir = path.join(ROOT, 'artifacts', 'sorting', runId);
const shots = path.join(ROOT, 'artifacts', 'screenshots', runId);
fs.mkdirSync(dir, { recursive: true });
fs.mkdirSync(shots, { recursive: true });
const output = path.join(ROOT, 'results', `sorting-icons__${runId}.json`);
const run = resumed || { module: 'sorting-icons', runId, startedAt: new Date().toISOString(), environment: { baseUrl: env.baseUrl, user: 'Akun config/env.md', role: 'Semua akun yang tersedia' }, scenarios: [], pages: [], accounts: [], bookingsCreated: 0, businessWrites: 0 };
const save = () => fs.writeFileSync(path.join(ROOT, 'results', `${run.module}__${runId}.json`), JSON.stringify(run, null, 2));
const hash = s => crypto.createHash('sha256').update(String(s)).digest('hex').slice(0, 12);
const safeError = e => {
  let text = String(e.message || e).replace(/\x1b\[[0-9;]*m/g, '').slice(0, 600);
  for (const a of env.accounts) for (const v of [a.email, a.password]) text = text.split(v).join('[privat]');
  return text;
};
const baseScenario = (id, title, screen) => ({ id, title, category: 'positive', priority: 'medium', screen, requirements: ['SORT-ASC-DESC', 'SORT-INDICATOR-DATA'], status: 'blocked', durationSec: 0, error: null, screenshot: null, bugCandidate: null, notes: '' });
function failurePattern(r) {
  if (r.status !== 'failed') return null;
  if (/Arah sortir tidak berganti/.test(r.error || '')) return 'direction-toggle';
  if (/dialog aplikasi/.test(r.error || '') || r.responseErrors?.some(e => e.status >= 500)) return 'application-error';
  if (/Urutan data/.test(r.error || '')) return 'data-order';
  return r.error;
}
function restoredGuard(index) {
  const guard = { count: 0, pattern: null, stopped: false };
  for (const r of run.scenarios.filter(s => s.accountIndex === index && s.column)) {
    const next = failurePattern(r);
    guard.count = next && next === guard.pattern ? guard.count + 1 : next ? 1 : 0;
    guard.pattern = next;
    if (guard.count >= 3 || /Guard tiga failed/.test(r.error || '')) guard.stopped = true;
  }
  return guard;
}
function normal(value) {
  const v = String(value).trim().replace(/\s+/g, ' ');
  if (!v || /^[-–—]$/.test(v)) return { type: 'empty', value: '' };
  if (/^(?:Rp\.?\s*)?-?[\d.,]+(?:\s*(?:%|Hak Akses|orang|tiket|data|unit|poin|kg|ton|hari))?$/i.test(v)) {
    const n = v.replace(/Rp\.?|Hak Akses|orang|tiket|data|unit|poin|kg|ton|hari|\s|%/gi, '');
    let numeric = n;
    if (n.includes('.') && n.includes(',')) numeric = n.lastIndexOf(',') > n.lastIndexOf('.') ? n.replace(/\./g, '').replace(',', '.') : n.replace(/,/g, '');
    else if (/^-?\d{1,3}(?:[.,]\d{3})+$/.test(n)) numeric = n.replace(/[.,]/g, '');
    else numeric = n.replace(',', '.');
    if (Number.isFinite(Number(numeric))) return { type: 'number', value: Number(numeric) };
  }
  const months = { januari: 1, februari: 2, maret: 3, april: 4, mei: 5, juni: 6, juli: 7, agustus: 8, september: 9, oktober: 10, november: 11, desember: 12, jan: 1, feb: 2, mar: 3, apr: 4, jun: 6, jul: 7, agu: 8, ags: 8, aug: 8, sep: 9, okt: 10, oct: 10, nov: 11, des: 12, dec: 12 };
  let m = v.toLowerCase().match(/^(\d{1,2})\s+([a-z]+)\s+(\d{4})(?:\s+(\d{1,2}):(\d{2})(?::(\d{2}))?)?/);
  if (m && months[m[2]]) return { type: 'date', value: Date.UTC(+m[3], months[m[2]] - 1, +m[1], +(m[4] || 0), +(m[5] || 0), +(m[6] || 0)) };
  m = v.match(/^(\d{4})-(\d{2})-(\d{2})(?:[ T](\d{2}):(\d{2})(?::(\d{2}))?)?/);
  if (m) return { type: 'date', value: Date.UTC(+m[1], +m[2] - 1, +m[3], +(m[4] || 0), +(m[5] || 0), +(m[6] || 0)) };
  m = v.match(/^(\d{1,2})[/-](\d{1,2})[/-](\d{4})(?:\s+(\d{2}):(\d{2}))?/);
  if (m) return { type: 'date', value: Date.UTC(+m[3], +m[2] - 1, +m[1], +(m[4] || 0), +(m[5] || 0)) };
  if (/\n/.test(String(value).trim())) return { type: 'composite', value: v };
  return { type: 'text', value: v.toLowerCase() };
}
function oracle(values, direction, column = {}) {
  if (/status|s&k|^reward$/i.test(column.label || '')) return { verifiable: false, reason: 'Urutan enum/status backend belum diverifikasi; label tampilan bukan oracle alfabetis', rows: values.length, distinct: new Set(values).size };
  const identifier = /whatsapp|\bWA\b|\bHP\b|telp|telepon|phone|rekening/i.test(column.label || '');
  // Placeholder tambahan harus opt-in pada kolom setelah diagnosis tampilan.
  // Tidak mengasumsikan kata "null" sebagai kosong pada semua jenis kolom.
  const emptyPlaceholders = new Set((column.emptyPlaceholders || []).map(v => String(v).trim().toLowerCase()));
  const ignoredPlaceholderRows = values.flatMap((v, i) => emptyPlaceholders.has(String(v).trim().toLowerCase()) ? [i + 1] : []);
  const normalization = ignoredPlaceholderRows.length ? { emptyPlaceholders: [...emptyPlaceholders], ignoredPlaceholderRows } : {};
  const parsed = values.map(v => {
    if (emptyPlaceholders.has(String(v).trim().toLowerCase())) return { type: 'empty', value: '' };
    if (identifier) return { type: 'text', value: String(v).trim().toLowerCase() };
    const age = /^(umur|usia)$/i.test(column.label || '') && String(v).trim().match(/^(\d+)\s*Th\s*\/\s*(?:Bayi|Anak|Dewasa)$/i);
    return age ? { type: 'number', value: Number(age[1]) } : normal(v);
  });
  const types = [...new Set(parsed.filter(p => p.type !== 'empty').map(p => p.type))];
  const distinct = new Set(parsed.filter(p => p.type !== 'empty').map(p => p.value)).size;
  if (values.length < 2 || distinct < 2) return { verifiable: false, reason: 'Kurang dari dua nilai berbeda pada data yang tampil', rows: values.length, distinct, ...normalization };
  if (types.length !== 1 || types.includes('composite')) return { verifiable: false, reason: 'Kolom gabungan/tipe campuran membutuhkan oracle field backend', rows: values.length, distinct, types, ...normalization };
  const violations = [];
  // Empty values can sort as SQL NULL or empty string; do not assume their placement.
  const entries = parsed.map((p, i) => ({ ...p, i })).filter(p => p.type !== 'empty');
  for (let j = 1; j < entries.length; j++) {
    const a = entries[j - 1], b = entries[j];
    const compare = a.type === 'text' ? a.value.localeCompare(b.value, 'id', { sensitivity: 'base' }) : Math.sign(a.value - b.value);
    if ((direction === 'ASC' && compare > 0) || (direction === 'DESC' && compare < 0)) violations.push({ beforeRow: a.i + 1, afterRow: b.i + 1, beforeHash: hash(a.value), afterHash: hash(b.value) });
  }
  if (types[0] === 'text' && violations.length) {
    const binaryOrdered = entries.every((p, i) => i === 0 || (direction === 'ASC' ? entries[i - 1].value <= p.value : entries[i - 1].value >= p.value));
    if (binaryOrdered) return { verifiable: true, type: 'text', rows: values.length, distinct, ordered: true, violations: [], collation: 'Kode karakter; urutan punctuation berbeda dari Intl id', ...normalization };
  }
  return { verifiable: true, type: types[0], rows: values.length, distinct, ordered: violations.length === 0, violations, ...normalization };
}
async function settle(page) {
  await page.waitForLoadState('domcontentloaded');
  await page.waitForFunction(() => document.body && document.body.innerText.trim().length > 30 && (!window.jQuery || window.jQuery.active === 0) && !/Mohon tunggu sebentar/i.test(document.body.innerText), null, { timeout: Number(process.env.SORT_AUDIT_WAIT_MS || 25000) });
}
async function login(browser, index) {
  const acct = env.accounts[index];
  const role = acct.role;
  const guard = path.join(ROOT, 'artifacts', '.auth', `sorting-login-${hash(acct.email)}.json`);
  let count = 0;
  try { count = JSON.parse(fs.readFileSync(guard)).count || 0; } catch {}
  if (index === 4 || count >= 2) throw Error('Guard akun: kredensial pernah gagal dua kali; tidak dicoba ulang');
  const context = await browser.newContext({ baseURL: env.baseUrl, viewport: { width: 1600, height: 1000 } });
  const page = await context.newPage();
  page.setDefaultTimeout(10000);
  page.setDefaultNavigationTimeout(45000);
  page.on('dialog', dialog => dialog.dismiss());
  // Known endpoints whose GETs can mutate an order; never follow them.
  await context.route(/\/(?:home|agen|partner)\/(?:savebooking|savetmpbooking|apifaspay2?|simulator|expiredxendit|potongkomisisaldouser)(?:[/?]|$)/i, route => route.abort());
  const finance = /Admin Finance/i.test(role), partner = /Operator/i.test(role), agent = /Agen/i.test(role), user = /User Umum/i.test(role);
  const route = finance ? '/admin/Finance/' : partner ? '/partner' : agent ? '/agen' : user ? '/user/login' : '/adminprahu';
  try {
    await page.goto(route, { waitUntil: 'domcontentloaded' });
    if (finance) {
      await page.getByRole('textbox', { name: 'Email', exact: true }).fill(acct.email);
      await page.getByRole('textbox', { name: 'Kata Sandi', exact: true }).fill(acct.password);
    } else {
      await page.locator('#username').fill(acct.email);
      await page.locator('#password').fill(acct.password);
    }
    try {
      await (user ? page.locator('#login1') : page.getByRole('button', { name: 'Login', exact: true })).click();
      await page.waitForFunction(({ email, finance }) => {
        const signed = document.querySelector('#signOut');
        return (signed && signed.getClientRects().length > 0) || (/^\/device\/?$/.test(location.pathname) && document.body.innerText.includes(email)) || (finance && location.pathname.startsWith('/admin/') && !document.querySelector('input[type=password]'));
      }, { email: acct.email, finance }, { timeout: 30000 });
      fs.writeFileSync(guard, JSON.stringify({ count: 0, at: new Date().toISOString() }), { mode: 0o600 });
    } catch (e) {
      fs.writeFileSync(guard, JSON.stringify({ count: count + 1, at: new Date().toISOString() }), { mode: 0o600 });
      throw e;
    }
    await settle(page);
    return { context, page, gated: /^\/device\/?$/.test(new URL(page.url()).pathname) };
  } catch (e) { await context.close(); throw e; }
}
function safePath(href) {
  try {
    const u = new URL(href, env.baseUrl);
    if (u.origin !== new URL(env.baseUrl).origin) return null;
    if (/logout|signout|delete|hapus|dosave|do_|download|export|printtix|callback|simulator|expired|approve|reject|revoke|savebooking|savetmp|markread|readall|settingpreferencenotif/i.test(u.pathname)) return null;
    if (/\.(pdf|png|jpg|zip)$/i.test(u.pathname)) return null;
    return u.pathname + u.search;
  } catch { return null; }
}
function routeTemplate(route) {
  const u = new URL(route, env.baseUrl);
  const parts = u.pathname.split('/');
  const mapped = parts.map((p, i) => /^\d+$/.test(p) || (i > 1 && /detail|riwayat|pemakaian/i.test(parts[i - 1])) ? ':id' : p);
  const params = [...u.searchParams].filter(([k, v]) => v !== '' && !/^(page|sort|dir)$/i.test(k)).map(([k, v]) => [k, /^id\w*$/i.test(k) ? ':id' : v]);
  return (mapped.join('/') + (params.length ? '?' + new URLSearchParams(params.sort()) : '')).replace(/\/$/, '').toLowerCase();
}
async function navigation(page) {
  return page.evaluate(() => [...document.querySelectorAll('.app-sidebar a[href],.app-header a[href],header a[href],.cms-menu a[href]')].map(a => ({ label: a.innerText.trim().replace(/\s+/g, ' '), href: a.href })).filter(a => a.label));
}
async function inventory(page) {
  return page.evaluate(() => {
    const visible = e => !!e.getClientRects().length;
    const tables = [...document.querySelectorAll('table')];
    const heads = [...document.querySelectorAll('thead th')];
    return heads.map((th, index) => ({ index, label: th.innerText.trim().replace(/\s+/g, ' '), tableIndex: tables.indexOf(th.closest('table')), cellIndex: th.cellIndex, group: th.getAttribute('groupnya'), sort: th.getAttribute('sortnya'), visible: visible(th), sortable: th.matches('.clicknya,.sorting,.sorting_asc,.sorting_desc,[aria-sort],.ss-gridfield-sort,.sortable') || !!th.querySelector('.fa-sort,.fa-sort-up,.fa-sort-down,.sort,.sortable,a.sort-link,.grid-field__sort') || !!th.querySelector('a[href*="sort"],button[name*="sort"],button[name*="Sort"]'), icons: [...th.querySelectorAll('i')].map(i => i.className) })).filter(h => h.visible && h.sortable);
  });
}
async function state(page, head) {
  return page.evaluate(h => {
    const th = document.querySelectorAll('thead th')[h.index];
    const table = th.closest('table');
    const sortingClass = th.className + ' ' + (th.querySelector('.grid-field__sort')?.className || '');
    const rows = [...table.querySelectorAll('tbody tr')].filter(r => r.cells.length > h.cellIndex && ![...r.cells].some(c => c.colSpan > 1) && r.getClientRects().length > 0);
    return { values: rows.map(r => r.cells[h.cellIndex].innerText.trim()), fingerprints: rows.map(r => [...r.cells].slice(1).map(c => c.innerText.trim()).join('|')), sortBy: typeof window.sortBy === 'undefined' ? null : String(window.sortBy), sortType: typeof window.sortType === 'undefined' ? null : String(window.sortType), attr: th.getAttribute('sortnya'), aria: th.getAttribute('aria-sort') || (/sorted[-_]asc|sorting_asc/.test(sortingClass) ? 'ascending' : /sorted[-_]desc|sorting_desc/.test(sortingClass) ? 'descending' : null), icons: [...th.querySelectorAll('i')].map(i => i.className) };
  }, head);
}
async function auditColumn(page, head, account, route) {
  const id = `SORT-A${account.index + 1}-${hash(route)}-${head.index}`;
  const r = baseScenario(id, `${account.role}: ${route} — ${head.label} (ASC/DESC)`, route);
  r.accountIndex = account.index;
  r.column = { label: head.label, group: head.group, cellIndex: head.cellIndex };
  const started = Date.now();
  const requests = [];
  const responseErrors = [];
  const responseListener = response => {
    if (['xhr', 'fetch'].includes(response.request().resourceType()) && response.status() >= 400) responseErrors.push({ path: new URL(response.url()).pathname, status: response.status() });
  };
  const listener = request => {
    if (!['xhr', 'fetch', 'document'].includes(request.resourceType())) return;
    const u = new URL(request.url());
    let data = {};
    try { data = request.postDataJSON() || {}; } catch {}
    const params = { ...Object.fromEntries(u.searchParams), ...data };
    const sorting = Object.fromEntries(Object.entries(params).filter(([k]) => /^(sortBy|sortType|sort|order|dir|orderby|direction|page|pageNow)$/i.test(k)));
    if (Object.keys(sorting).length) requests.push({ path: u.pathname, sorting });
  };
  page.on('request', listener);
  page.on('response', responseListener);
  try {
    const cycles = [];
    const initial = await state(page, head);
    for (let n = 0; n < 2; n++) {
      const current = await state(page, head);
      const header = page.locator('thead th').nth(head.index);
      await header.evaluate(el => el.scrollIntoView({ block: 'center', inline: 'nearest', behavior: 'instant' }));
      await page.waitForTimeout(150);
      const icon = header.locator('i.fa-sort,i.fa-sort-up,i.fa-sort-down').first();
      const button = header.locator('button.grid-field__sort,button[name*="sort"],button[name*="Sort"],a.sort-link,a[href*="sort"]').first();
      // The requested icon itself is clicked, using the actual harvested header.
      const control = await icon.count() && await icon.isVisible() ? icon : await button.count() && await button.isVisible() ? button : header;
      await control.click();
      await settle(page);
      const popup = page.locator('.swal2-popup:visible');
      if (await popup.count()) {
        const message = (await popup.innerText()).trim().slice(0, 350);
        const error = Error(`Klik sortir memunculkan dialog aplikasi: ${message}`);
        error.applicationFailure = true;
        throw error;
      }
      const after = await state(page, head);
      const network = requests.splice(0);
      const last = network.at(-1)?.sorting || {};
      const direction = String(last.sortType || last.dir || last.direction || (head.group ? after.sortType : '') || (after.aria === 'ascending' ? 'ASC' : after.aria === 'descending' ? 'DESC' : '')).toUpperCase();
      const iconDirection = after.icons.some(i => /fa-sort-up/.test(i)) ? 'ASC' : after.icons.some(i => /fa-sort-down/.test(i)) ? 'DESC' : after.aria === 'ascending' ? 'ASC' : after.aria === 'descending' ? 'DESC' : null;
      const check = oracle(after.values, direction, head);
      cycles.push({ cycle: n + 1, direction, expectedRequestedDirection: current.attr, iconDirection, attrAfter: after.attr, groupAfter: after.sortBy, network, rowHashes: after.fingerprints.map(hash), valueHashes: after.values.map(hash), numericValues: check.type === 'number' && /^(No\.?|Jumlah.*|Qty.*|Total.*|Harga.*|Pendapatan.*|Penjualan.*|Kuota.*|Kapasitas.*|Poin.*)$/i.test(head.label) ? after.values.map(v => normal(v).value) : undefined, check, changed: JSON.stringify(after.fingerprints) !== JSON.stringify(current.fingerprints) });
    }
    r.evidence = { initialRows: initial.values.length, cycles };
    const issues = [];
    for (const c of cycles) {
      if (!['ASC', 'DESC'].includes(c.direction)) continue;
      if (c.iconDirection && c.iconDirection !== c.direction) issues.push(`Indikator ${c.iconDirection} berbeda dari arah request ${c.direction}`);
      if (c.check.verifiable && !c.check.ordered) issues.push(`Urutan data ${c.direction} salah (${c.check.violations.length} pasangan terbalik)`);
      if (head.group && c.groupAfter !== head.group) issues.push('Field sortir tidak sesuai kolom yang diklik');
    }
    if (cycles[0].direction && cycles[0].direction === cycles[1].direction) issues.push('Arah sortir tidak berganti pada klik kedua');
    if (issues.length) {
      r.status = 'failed'; r.error = [...new Set(issues)].join('; '); r.bugCandidate = 'SORT-PROBABLE';
      r.screenshot = path.relative(ROOT, path.join(shots, `${id}.png`));
      await page.screenshot({ path: path.join(ROOT, r.screenshot), fullPage: true });
    } else if (cycles.every(c => ['ASC', 'DESC'].includes(c.direction) && c.check.verifiable && c.check.ordered && c.iconDirection === c.direction)) {
      r.status = 'passed'; r.notes = 'Klik ikon dua kali; request, indikator, dan urutan nilai ASC/DESC cocok pada baris yang tampil.';
    } else {
      r.status = 'blocked';
      r.error = cycles.map(c => c.check.reason || (!c.direction ? 'Arah sortir belum dapat dibaca' : !c.iconDirection ? 'Indikator arah tidak dapat dibaca' : '')).filter(Boolean).join('; ') || 'Oracle belum lengkap';
      r.notes = 'Interaksi dicoba; data/kolom belum cukup untuk membuktikan sortir dua arah. Bukan verdict bug.';
    }
  } catch (e) {
    r.status = e.applicationFailure ? 'failed' : 'blocked'; r.error = safeError(e);
    if (r.status === 'failed') {
      r.bugCandidate = 'SORT-PROBABLE';
      r.screenshot = path.relative(ROOT, path.join(shots, `${id}.png`));
      await page.screenshot({ path: path.join(ROOT, r.screenshot), fullPage: true });
    }
  }
  finally { page.off('request', listener); page.off('response', responseListener); }
  if (responseErrors.length) r.responseErrors = responseErrors;
  r.durationSec = (Date.now() - started) / 1000;
  run.scenarios.push(r); save();
  console.log(JSON.stringify({ type: 'column', account: account.index + 1, route, label: head.label, status: r.status, error: r.error }));
  return r;
}
async function auditPage(page, route, account, interactionGuard) {
  const p = { accountIndex: account.index, role: account.role, route, status: 'blocked', columns: [], detailLinks: [] };
  const previousIndex = run.pages.findIndex(old => old.accountIndex === account.index && old.route === route);
  if (previousIndex >= 0) run.pages[previousIndex] = p; else run.pages.push(p);
  try {
    const response = await page.goto(route, { waitUntil: 'domcontentloaded' });
    await settle(page);
    p.httpStatus = response?.status(); p.finalPath = new URL(page.url()).pathname;
    if (p.httpStatus >= 400) throw Error(`HTTP ${p.httpStatus}`);
    if (await page.locator('input[type=password]:visible').count()) throw Error('Sesi kembali ke login');
    if (p.finalPath !== new URL(route, env.baseUrl).pathname && /^\/device/.test(p.finalPath)) throw Error('Akses terhalang verifikasi perangkat');
    const denied = await page.locator('.alert-danger').allTextContents();
    if (denied.some(t => /Tidak Memiliki Akses/i.test(t))) throw Error('Akun tidak memiliki akses halaman');
    const headers = await inventory(page);
    p.columns = headers.map(h => ({ label: h.label, group: h.group, index: h.index }));
    p.status = headers.length ? 'inspected' : 'no-sort-icon';
    // Follow representative read-only detail templates, never editing/actions.
    p.detailLinks = await page.evaluate(() => [...document.querySelectorAll('table tbody a[href]')].filter(a => /detail|riwayat|pemakaian/i.test(a.getAttribute('href')) && !/edit|print|download|export/i.test(a.getAttribute('href'))).map(a => a.href));
    for (const head of headers) {
      if (run.scenarios.some(s => s.id === `SORT-A${account.index + 1}-${hash(route)}-${head.index}`)) continue;
      if (interactionGuard.stopped) {
        const r = baseScenario(`SORT-A${account.index + 1}-${hash(route)}-${head.index}`, `${account.role}: ${route} — ${head.label} (ASC/DESC)`, route);
        r.accountIndex = account.index; r.column = { label: head.label, group: head.group }; r.error = 'Guard tiga failed berturut-turut dengan pola sama; hanya inventory setelah diagnosis'; run.scenarios.push(r); continue;
      }
      const r = await auditColumn(page, head, account, route);
      const pattern = failurePattern(r);
      interactionGuard.count = pattern && pattern === interactionGuard.pattern ? interactionGuard.count + 1 : pattern ? 1 : 0;
      interactionGuard.pattern = pattern;
      if (interactionGuard.count >= 3) { interactionGuard.stopped = true; account.guard = 'Tiga failed beruntun pola sama; sisa ikon diinventarisasi tanpa klik'; }
    }
  } catch (e) { p.error = safeError(e); }
  save();
  console.log(JSON.stringify({ type: 'page', account: account.index + 1, route, status: p.status, columns: p.columns.length, error: p.error }));
  return p;
}
async function main() {
  const indices = process.argv.slice(2).length ? process.argv.slice(2).map(Number) : env.accounts.map((_, i) => i);
  fs.writeFileSync(path.join(ROOT, 'results', `_plan__sorting-icons__${runId}.md`), `# Audit ikon sortir ${runId}\n\nPermintaan: seluruh halaman dan seluruh akun. Read-only, peran explorer → planner → executor → triager berurutan pada agent utama.\n\nAkun: ${indices.map(i => `${i + 1}: ${env.accounts[i].role}`).join('; ')}.\n\nHalaman dari menu aktual dan peta existing, termasuk satu contoh tiap template detail. Setiap ikon: klik ASC dan DESC, cocokkan arah request/indikator/urutan nilai; tanpa pembuatan fixture/booking/perubahan konfigurasi. Nilai personal tidak disalin; hash dan indeks pelanggaran disimpan. Data kosong, seragam, gabungan atau gate perangkat: blocked, bukan passed. Akun User Umum lama guard2 tidak dicoba ulang. Guard tiga failed pola sama tetap berlaku per akun.\n`);
  const browser = await chromium.launch({ headless: true });
  try {
    for (const index of indices) {
      let account = run.accounts.find(a => a.index === index);
      if (account?.completed) continue;
      if (!account) { account = { index, role: env.accounts[index].role, status: 'blocked' }; run.accounts.push(account); }
      save();
      let session;
      try {
        session = await login(browser, index);
        delete account.error;
        account.status = session.gated ? 'device-gated' : 'authenticated';
        const page = session.page;
        let links = await navigation(page);
        const landing = new URL(page.url()).pathname;
        let routes = [...new Set([...(account.routes || []), landing, ...links.map(l => safePath(l.href)).filter(Boolean)])];
        if (/Operator/i.test(account.role)) {
          const map = fs.readFileSync(path.join(ROOT, 'explore', 'module-map.md'), 'utf8');
          const section = map.split(index === 1 ? '## Peta Operator Pusat' : '## Peta Cabang / Sub User Cabang Parepare')[1]?.split('\n## ')[0] || '';
          routes = [...new Set([...routes, ...[...section.matchAll(/\| `([^`]+)` \|/g)].map(m => m[1])])];
        }
        if (process.env.SORT_AUDIT_ROUTE) routes = [process.env.SORT_AUDIT_ROUTE];
        const queued = new Set();
        routes = routes.filter(route => { const key = routeTemplate(route); if (queued.has(key)) return false; queued.add(key); return true; });
        account.routes = routes;
        const guard = restoredGuard(index);
        if (guard.stopped) account.guard = 'Guard tiga failed pola sama dipertahankan dari checkpoint; hanya inventory';
        for (let i = 0; i < routes.length; i++) {
          const completed = run.pages.find(p => p.accountIndex === index && routeTemplate(p.route) === routeTemplate(routes[i]) && (p.status !== 'inspected' || p.columns.every(h => run.scenarios.some(s => s.id === `SORT-A${index + 1}-${hash(p.route)}-${h.index}`))));
          if (completed) continue;
          const observed = await auditPage(page, routes[i], account, guard);
          // Dashboard links and nested navigation, restricted to page-like read-only URLs.
          const nested = await page.evaluate(() => [...document.querySelectorAll('.app-sidebar a[href],.cms-menu a[href],a[href*="DashboardList"],a[href*="getDetailTIket"],a[href*="getDetailPekerja"]')].map(a => a.href)).catch(() => []);
          if (!process.env.SORT_AUDIT_ROUTE) for (const href of nested) { const route = safePath(href); if (route && !queued.has(routeTemplate(route))) { queued.add(routeTemplate(route)); routes.push(route); } }
          if (!process.env.SORT_AUDIT_ROUTE) for (const href of observed.detailLinks) {
            const route = safePath(href); if (!route) continue;
            const template = routeTemplate(route);
            if (!queued.has(template)) { queued.add(template); routes.push(route); }
          }
          await page.waitForTimeout(800);
        }
        account.completed = true;
      } catch (e) {
        account.error = safeError(e);
        const r = baseScenario(`SORT-A${index + 1}-LOGIN`, `${account.role}: akses untuk audit sortir`, 'Login'); r.accountIndex = index; r.error = account.error;
        const oldLogin = run.scenarios.findIndex(s => s.id === r.id); if (oldLogin >= 0) run.scenarios[oldLogin] = r; else run.scenarios.push(r); save();
        console.log(JSON.stringify({ type: 'login', account: index + 1, status: 'blocked', error: account.error }));
      } finally { if (session) await session.context.close(); }
    }
  } finally { await browser.close(); run.finishedAt = new Date().toISOString(); save(); }
  console.log(JSON.stringify({ type: 'done', output, pages: run.pages.length, scenarios: run.scenarios.length, counts: run.scenarios.reduce((a, r) => ({ ...a, [r.status]: (a[r.status] || 0) + 1 }), {}) }));
}
module.exports = { login, settle, inventory, state, normal, oracle, auditColumn, baseScenario, run, save, failurePattern, safePath, routeTemplate, navigation, ROOT, dir, shots, env, runId, output, hash, safeError };
if (require.main === module) main().catch(e => { run.fatal = safeError(e); save(); console.error(run.fatal); process.exitCode = 1; });
