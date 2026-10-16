// Perluas data lewat kontrol UI; proyeksi kota hanya setelah diagnosis DOM.
const fs = require('fs');
const path = require('path');
const { chromium } = require('@playwright/test');
process.env.SORT_AUDIT_RUN_ID = new Date().toISOString().replace(/[-:]/g, '').replace('T', '-').slice(0, 15);
const { execute, H, spec } = require('./retest_sort_icons');
const sourcePath = process.argv[2];
const source = JSON.parse(fs.readFileSync(sourcePath));
if (!source.finishedAt) throw Error('Tunggu run sumber selesai sebelum diagnosis');
const cityProjectionConfirmed = process.argv.includes('--city-first-line');
H.run.scenarios = structuredClone(source.scenarios);
H.run.sourceRuns = [sourcePath];
H.run.scope = source.scope;
H.run.limitations = source.limitations;
H.run.accounts = [];
const save = () => H.save();

async function auditCity(page, head, account, route) {
  const r = H.baseScenario(`SORT-A${account.index + 1}-${H.hash(route)}-${head.index}`, `${account.role}: ${route} — ${head.label}`, route);
  r.accountIndex = account.index;
  r.column = { label: head.label, group: head.group, cellIndex: head.cellIndex };
  const network = [], responses = [];
  const onRequest = request => {
    if (!['xhr', 'fetch', 'document'].includes(request.resourceType())) return;
    const url = new URL(request.url());
    let post = {};
    try { post = request.postDataJSON() || {}; } catch {}
    const params = { ...Object.fromEntries(url.searchParams), ...post };
    const sorting = Object.fromEntries(Object.entries(params).filter(([k]) => /^(sortBy|sortType|pageNow)$/i.test(k)));
    if (sorting.sortBy || sorting.sortType) network.push({ path: url.pathname, sorting });
  };
  const onResponse = response => {
    if (['xhr', 'fetch'].includes(response.request().resourceType())) responses.push({ path: new URL(response.url()).pathname, status: response.status() });
  };
  page.on('request', onRequest); page.on('response', onResponse);
  const cycles = [], issues = [];
  try {
    for (let n = 0; n < 2; n++) {
      const current = await H.state(page, head);
      const th = page.locator('thead th').nth(head.index);
      await th.evaluate(el => el.scrollIntoView({ block: 'center', inline: 'nearest', behavior: 'instant' }));
      await th.locator('i.fa-sort,i.fa-sort-up,i.fa-sort-down').first().click();
      await H.settle(page);
      const popup = page.locator('.swal2-popup:visible');
      if (await popup.count()) {
        const e = Error('Klik sortir kota memunculkan dialog error aplikasi');
        e.applicationFailure = true; throw e;
      }
      const after = await H.state(page, head);
      const requests = network.splice(0);
      const direction = String(requests.at(-1)?.sorting.sortType || after.sortType || '').toUpperCase();
      const iconDirection = after.icons.some(i => /fa-sort-up/.test(i)) ? 'ASC' : after.icons.some(i => /fa-sort-down/.test(i)) ? 'DESC' : null;
      // BPN dan KRG adalah kode pelabuhan pada kota Balikpapan yang sama.
      // Kolom kota tidak mendefinisikan kode sebagai secondary sort key.
      const values = after.values.map(v => (v.split('\n').map(t => t.trim()).filter(Boolean)[0] || '').replace(/\s*\([^)]*\)\s*$/, '').trim());
      const check = H.oracle(values, direction, head);
      cycles.push({ cycle: n + 1, direction, iconDirection, expectedRequestedDirection: current.attr, groupAfter: after.sortBy, network: requests, responses: responses.splice(0), check, rowHashes: after.fingerprints.map(H.hash), valueHashes: values.map(H.hash), valueProjection: 'Nama kota baris pertama tanpa kode pelabuhan; tanggal/waktu kedua dikecualikan', changed: JSON.stringify(current.fingerprints) !== JSON.stringify(after.fingerprints) });
      if (after.sortBy !== head.group) issues.push('Field request tidak sesuai kolom kota');
      if (direction !== iconDirection) issues.push('Indikator berbeda dari arah request');
      if (check.verifiable && !check.ordered) issues.push(`Urutan kota ${direction} salah`);
      if (new Set(requests.map(x => x.sorting.sortType)).size > 1) issues.push('Satu klik mengirim kedua arah');
      if (cycles.at(-1).responses.some(x => x.status >= 400)) issues.push('Request sortir mengembalikan HTTP error');
    }
    if (cycles[0].direction === cycles[1].direction) issues.push('Arah tidak berubah pada klik kedua');
    r.evidence = { cycles, projectionVerifiedBy: 'Diagnosis DOM: nama kota pada baris pertama, kode pelabuhan dalam kurung; tanggal/waktu berikutnya. Kode bukan secondary key yang disyaratkan.' };
    if (issues.length) { r.status = 'failed'; r.error = [...new Set(issues)].join('; '); r.bugCandidate = 'SORT-PROBABLE'; }
    else if (cycles.every(c => ['ASC', 'DESC'].includes(c.direction) && c.check.verifiable && c.check.ordered)) {
      r.status = 'passed'; r.notes = 'Klik ASC/DESC, field pol/pod dan indikator cocok; urutan kota diverifikasi terpisah dari tanggal/waktu dalam sel gabungan.';
    } else { r.status = 'blocked'; r.error = cycles.map(c => c.check.reason).filter(Boolean).join('; '); }
  } catch (e) { r.status = e.applicationFailure ? 'failed' : 'blocked'; r.error = H.safeError(e); r.bugCandidate = e.applicationFailure ? 'SORT-PROBABLE' : null; }
  finally { page.off('request', onRequest); page.off('response', onResponse); }
  return r;
}

async function main() {
  const targets = source.scenarios.filter(s => s.status === 'blocked' || s.responseErrors?.some(e => e.status >= 500));
  const browser = await chromium.launch({ headless: true });
  try {
    for (const index of [...new Set(targets.map(s => s.accountIndex))]) {
      const account = { index, role: H.env.accounts[index].role, status: 'blocked' };
      H.run.accounts.push(account);
      let session;
      try {
        session = await H.login(browser, index);
        account.status = session.gated ? 'device-gated' : 'authenticated';
        for (const previous of targets.filter(s => s.accountIndex === index)) {
          const scenario = spec.scenarios.find(s => s.id === previous.id);
          const city = /Kota Asal|Kota Tujuan/.test(scenario.column.label);
          let result = await execute(session.page, scenario, account, { rowLimit: previous.status === 'blocked' ? 100 : undefined, auditColumn: city && cityProjectionConfirmed ? auditCity : undefined });
          result.attempts = [{ status: previous.status, error: previous.error, evidence: previous.evidence, source: sourcePath }];
          if (previous.status === 'failed' && result.status === 'passed') {
            const first = result;
            result = await execute(session.page, scenario, account);
            result.attempts = [...first.attempts, { status: first.status, error: first.error, evidence: first.evidence }];
            result.notes = [result.notes, 'Sumber mengalami HTTP5xx; pemeriksaan lanjutan pertama passed dan dilanjutkan satu pengulangan independen. Gangguan awal tetap dicatat, bukan dihapus.'].filter(Boolean).join(' ');
          } else result.notes = [result.notes, 'Pemeriksaan lanjutan memakai kontrol jumlah baris100 bila tersedia; tanpa perubahan data bisnis.'].filter(Boolean).join(' ');
          H.run.scenarios[H.run.scenarios.findIndex(s => s.id === result.id)] = result;
          save();
          console.log(JSON.stringify({ id: result.id, account: index + 1, column: result.column.label, status: result.status, error: result.error, rowLimit: result.rowLimit }));
        }
      } catch (e) { account.error = H.safeError(e); save(); }
      finally { if (session) await session.context.close(); }
    }
  } finally {
    await browser.close();
    H.run.finishedAt = new Date().toISOString();
    H.run.summary = { total: H.run.scenarios.length, statuses: H.run.scenarios.reduce((a, s) => ({ ...a, [s.status]: (a[s.status] || 0) + 1 }), {}), recheckedForEvidence: targets.length, initialRun: sourcePath };
    for (const original of source.accounts) if (!H.run.accounts.some(a => a.index === original.index)) H.run.accounts.push({ ...original, provenance: sourcePath });
    save();
  }
  console.log(JSON.stringify({ output: `results/${H.run.module}__${H.runId}.json`, summary: H.run.summary }));
}
main().catch(e => { H.run.fatal = H.safeError(e); save(); console.error(H.run.fatal); process.exitCode = 1; });
