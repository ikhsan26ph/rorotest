// Retest dua kasus tersisa dengan sesi baru; dua pengulangan pada ukuran data berbeda.
const fs = require('fs');
const path = require('path');
const { chromium } = require('@playwright/test');
process.env.SORT_AUDIT_RUN_ID = new Date().toISOString().replace(/[-:]/g, '').replace('T', '-').slice(0, 15);
const { execute, H, spec } = require('./retest_sort_icons');
const sourcePath = process.argv[2] || 'results/sorting-retest__20261016-065823.json';
const source = JSON.parse(fs.readFileSync(path.join(H.ROOT, sourcePath)));
const nameNullPlaceholder = process.argv.includes('--name-null-placeholder');
const targets = spec.scenarios.filter(s => ['SCN-0006', 'SCN-0034'].includes(s.id) && source.scenarios.some(p => p.id === s.id));
H.run.module = 'sorting-recheck';
H.run.source = sourcePath;
H.run.scope = 'Dua kasus dari retest sebelumnya; tidak mewariskan verdict kasus lain.';
H.run.environment.role = 'Admin Pusat dan Operator Cabang Pare-Pare';
H.run.limitations = ['Hanya dua kasus failed terakhir.', 'Desktop1600px; data tampil20 dan100baris, bukan seluruh pagination.', 'Tidak membuat data atau mengubah setting bisnis.'];
if (nameNullPlaceholder) {
  H.run.nameValuePolicy = { column: 'Nama Lengkap', emptyPlaceholders: ['null'], assertionScope: 'Urutan nama yang terisi; posisi placeholder tidak diasert.' };
  H.run.limitations.push('Nama Lengkap: literal null masih dapat tampil; validasi urutan mengecualikan placeholder ini.');
}
const save = () => H.save();
const output = path.join(H.ROOT, 'results', `${H.run.module}__${H.runId}.json`);
const plan = ['# Retest dua masalah sortir terakhir', '', `Run: ${H.runId}. Sumber: ${sourcePath}.`, '', 'Dua skenario dalam satu batch; login sekali per akun dengan context terpisah. Setiap skenario diulang pada20 dan100baris melalui kontrol UI bila tersedia, selalu membuka ulang halaman. Klik ASC/DESC, periksa posisi ikon, field request, indikator dan urutan. Respons endpoint sortir dicatat tanpa payload/header pribadi. Tidak membuat fixture/transaksi/settings. Guard login2 dipertahankan. Screenshot hanya failed.', '', ...targets.map(s => `${s.id}: ${s.title}`), ''];
if (nameNullPlaceholder) plan.push('Kebijakan nilai: hanya Nama Lengkap mengecualikan label null dari urutan nama terisi; penempatan placeholder dicatat tanpa assertion. Kasus W→A/T→A tetap failed pada pemeriksaan regresi oracle.');
fs.writeFileSync(path.join(H.ROOT, 'results', `_plan__sorting-recheck__${H.runId}.md`), plan.join('\n'));
save();

async function main() {
  const browser = await chromium.launch({ headless: true });
  try {
    for (const s of targets) {
      const account = { index: s.accountIndex, role: H.env.accounts[s.accountIndex].role, status: 'blocked' };
      H.run.accounts.push(account);
      let session;
      try {
        session = await H.login(browser, s.accountIndex);
        account.status = session.gated ? 'device-gated' : 'authenticated';
        const attempts = [];
        for (const rowLimit of [20, 100]) {
          const responses = [];
          const onResponse = response => {
            const url = new URL(response.url());
            if (!/\/(searchuserumum|searchpiutang)$/.test(url.pathname)) return;
            const req = response.request();
            let data = {};
            try { data = req.postDataJSON() || {}; } catch {}
            responses.push({ path: url.pathname, status: response.status(), method: req.method(), sorting: { sortBy: data.sortBy, sortType: data.sortType } });
          };
          session.page.on('response', onResponse);
          let r;
          const auditColumn = nameNullPlaceholder && s.id === 'SCN-0006'
            ? (page, head, account, route) => H.auditColumn(page, { ...head, emptyPlaceholders: ['null'] }, account, route)
            : undefined;
          try { r = await execute(session.page, s, account, { rowLimit, auditColumn }); }
          finally { session.page.off('response', onResponse); }
          r.requestedRowLimit = rowLimit;
          if (nameNullPlaceholder && s.id === 'SCN-0006') {
            r.notes += ' Validasi nama yang terisi; label null dikecualikan sebagai placeholder pada kolom ini saja. Penempatan placeholder tidak diasert.';
          }
          r.sortResponses = responses;
          r.provenance = { ...r.provenance, latestSource: sourcePath, latestPreviousStatus: source.scenarios.find(p => p.id === s.id).status, latestPreviousError: source.scenarios.find(p => p.id === s.id).error };
          if (r.screenshot) {
            const copy = r.screenshot.replace(/\.png$/, `-rows${rowLimit}.png`);
            fs.copyFileSync(path.join(H.ROOT, r.screenshot), path.join(H.ROOT, copy));
            r.screenshot = copy;
          }
          attempts.push(r);
          console.log(JSON.stringify({ id: s.id, rowLimit, status: r.status, error: r.error, responses }));
        }
        const worst = attempts.find(a => a.status === 'failed') || attempts.find(a => a.status !== 'passed') || attempts.at(-1);
        const result = { ...worst, attempts, durationSec: attempts.reduce((n, a) => n + a.durationSec, 0), notes: [worst.notes, `Retest ${attempts.length} kali dengan20/100baris; setiap percobaan membuka ulang halaman. Verdict passed hanya jika semua percobaan lolos.`].filter(Boolean).join(' ') };
        H.run.scenarios.push(result);
      } catch (e) {
        account.error = H.safeError(e);
        H.run.scenarios.push({ ...H.baseScenario(s.id, s.title, s.screen), category: s.category, priority: s.priority, requirements: s.requirements, route: s.route, column: s.column, accountIndex: s.accountIndex, error: account.error });
      } finally { if (session) await session.context.close(); }
      save();
    }
  } finally {
    await browser.close();
    H.run.finishedAt = new Date().toISOString();
    H.run.summary = { total: H.run.scenarios.length, statuses: H.run.scenarios.reduce((a, s) => ({ ...a, [s.status]: (a[s.status] || 0) + 1 }), {}) };
    save();
  }
  console.log(JSON.stringify({ output: path.relative(H.ROOT, output), summary: H.run.summary }));
}
main().catch(e => { H.run.fatal = H.safeError(e); save(); console.error(H.run.fatal); process.exitCode = 1; });
