// Retest read-only terhadap kasus gagal; sumber skenario dan provenance eksplisit.
const fs = require('fs');
const path = require('path');
const { chromium } = require('@playwright/test');
process.env.SORT_AUDIT_WAIT_MS ||= '30000';
process.env.SORT_AUDIT_RUN_ID ||= JSON.parse(fs.readFileSync(path.resolve(__dirname, '../results/_sorting-retest-current.json'))).runId;
const H = require('./audit_sort_icons');
const spec = JSON.parse(fs.readFileSync(path.join(H.ROOT, 'scenario/sorting-retest/sorting-retest_scenarios.json')));
H.run.module = 'sorting-retest';
H.run.source = spec.source;
H.run.scope = spec.scope;
H.run.environment.role = 'Admin Pusat, Operator Pusat, Operator Cabang, Admin Finance';
H.run.limitations = ['Retest hanya 43 kasus failed sumber; verdict lain tidak diwariskan.', 'Desktop Chromium 1600px; data tampil, bukan seluruh pagination.', 'Data kosong/seragam/gabungan tanpa oracle tidak diklaim passed.'];
const save = () => H.save();

async function hitTest(page, head) {
  const header = page.locator('thead th').nth(head.index);
  await header.evaluate(el => el.scrollIntoView({ block: 'center', inline: 'nearest', behavior: 'instant' }));
  await page.waitForTimeout(200);
  return header.evaluate(el => {
    const icon = el.querySelector('i.fa-sort,i.fa-sort-up,i.fa-sort-down');
    if (!icon) return { customControl: !!el.querySelector('.grid-field__sort') };
    const rect = icon.getBoundingClientRect();
    const x = rect.x + rect.width / 2, y = rect.y + rect.height / 2;
    const actual = document.elementFromPoint(x, y), th = actual?.closest('th');
    return { x, y, width: rect.width, height: rect.height, ownHeader: th === el, targetLabel: th?.innerText.trim().replace(/\s+/g, ' '), targetGroup: th?.getAttribute('groupnya'), interactive: !!actual?.closest('a,button,input') };
  });
}

async function execute(page, s, account, options = {}) {
  const started = Date.now();
  let r = { ...H.baseScenario(s.id, s.title, s.screen), category: s.category, priority: s.priority, requirements: s.requirements, route: s.route, accountIndex: s.accountIndex, column: s.column, provenance: { source: spec.source, originalId: s.originalId, previousStatus: 'failed', previousError: s.previousError }, startedAt: new Date().toISOString() };
  try {
    const response = await page.goto(s.route, { waitUntil: 'domcontentloaded' });
    await H.settle(page);
    r.pageHttpStatus = response?.status();
    r.finalPath = new URL(page.url()).pathname;
    if (r.pageHttpStatus >= 400) throw Error(`Halaman sumber HTTP ${r.pageHttpStatus}`);
    if (r.finalPath !== new URL(s.route, H.env.baseUrl).pathname) throw Error('Halaman sumber dialihkan; prasyarat akses belum terpenuhi');
    if (await page.locator('input[type=password]:visible').count()) throw Error('Sesi kembali ke login');
    if (options.rowLimit) {
      const limit = page.locator('#valuelimit');
      if (await limit.count() && await limit.isVisible()) {
        const available = await limit.locator('option').evaluateAll(es => es.map(e => e.value));
        if (available.includes(String(options.rowLimit))) {
          const before = await limit.inputValue();
          r.rowLimit = { before, requested: options.rowLimit };
          if (before !== String(options.rowLimit)) {
            await limit.selectOption(String(options.rowLimit));
            await H.settle(page);
          }
        }
      }
    }
    const heads = await H.inventory(page);
    let head = heads.find(h => h.label === s.column.label && h.group === s.column.group) || heads.find(h => h.label === s.column.label);
    r.actualHeaders = heads.map(h => ({ label: h.label, group: h.group, index: h.index }));
    if (!head) throw Error('Header sumber belum ditemukan pada DOM aktual; perlu diagnosis perubahan UI');
    r.actualColumn = { label: head.label, group: head.group, index: head.index, cellIndex: head.cellIndex };
    r.hitTest = await hitTest(page, head);
    if (r.hitTest.ownHeader === false && r.hitTest.targetLabel && !r.hitTest.interactive) {
      const before = await H.state(page, head);
      await page.mouse.click(r.hitTest.x, r.hitTest.y);
      await H.settle(page);
      const after = await H.state(page, head);
      r.evidence = { expectedGroup: head.group, actualGroup: after.sortBy, expectedIconHeader: head.label, actualHitHeader: r.hitTest.targetLabel, beforeDirection: before.sortType, actualDirection: after.sortType };
      if (r.hitTest.targetGroup !== head.group && after.sortBy === r.hitTest.targetGroup) {
        r.status = 'failed'; r.bugCandidate = 'SORT-ICON-WRONG-COLUMN';
        r.error = `Klik ikon ${head.label} menyortir ${r.hitTest.targetLabel}; expected ${head.group}, actual ${after.sortBy}`;
      } else if (before.sortBy === after.sortBy && before.sortType === after.sortType && before.attr === after.attr) {
        r.status = 'failed'; r.bugCandidate = 'SORT-ICON-COVERED';
        r.error = `Ikon ${head.label} tertutup header ${r.hitTest.targetLabel}; klik tidak mengubah field/arah/indikator`;
      } else throw Error('Hit-test berbeda header tetapi dampak sortir belum pasti; perlu diagnosis');
    } else {
      const priorLength = H.run.scenarios.length;
      const measured = await (options.auditColumn || H.auditColumn)(page, head, account, s.route);
      H.run.scenarios.splice(priorLength);
      r = { ...r, ...measured, id: s.id, title: s.title, screen: s.screen, route: s.route, category: s.category, priority: s.priority, requirements: s.requirements, column: s.column, provenance: r.provenance, hitTest: r.hitTest, actualColumn: r.actualColumn, actualHeaders: r.actualHeaders, pageHttpStatus: r.pageHttpStatus, finalPath: r.finalPath, startedAt: r.startedAt };
    }
    // A single click must not issue both directions, even if a race happens to
    // leave an ordered final table on this attempt.
    const duplicate = r.evidence?.cycles?.filter(c => {
      const directions = new Set(c.network.map(n => String(n.sorting.sortType || n.sorting.dir || '').toUpperCase()).filter(Boolean));
      return directions.has('ASC') && directions.has('DESC');
    });
    if (duplicate?.length) {
      r.status = 'failed'; r.bugCandidate = 'SORT-DUPLICATE-DIRECTION';
      r.error = [r.error, 'Satu klik masih mengirim request ASC dan DESC sekaligus'].filter(Boolean).join('; ');
    }
    if (r.responseErrors?.some(e => e.status >= 500)) {
      r.status = 'failed'; r.bugCandidate = 'SORT-SERVER-ERROR';
      r.error = [r.error, 'Request sortir mengembalikan HTTP 5xx'].filter(Boolean).join('; ');
    }
  } catch (e) { r.status = 'blocked'; r.error = H.safeError(e); r.bugCandidate = null; }
  if (r.status === 'failed') {
    r.screenshot = path.relative(H.ROOT, path.join(H.shots, `${s.id}.png`));
    await page.screenshot({ path: path.join(H.ROOT, r.screenshot), fullPage: true });
    r.triage = { classification: 'BUG (probable)', severity: /5xx|server|500/i.test(r.error) ? 'major' : 'minor', analysis: r.error };
  }
  r.durationSec = (Date.now() - started) / 1000;
  return r;
}

async function main() {
  const browser = await chromium.launch({ headless: true });
  try {
    for (const index of [...new Set(spec.scenarios.map(s => s.accountIndex))]) {
      const account = { index, role: H.env.accounts[index].role, status: 'blocked' };
      H.run.accounts.push(account);
      let session;
      let streak = 0, pattern = null;
      try {
        session = await H.login(browser, index);
        account.status = session.gated ? 'device-gated' : 'authenticated';
        for (const s of spec.scenarios.filter(s => s.accountIndex === index)) {
          const r = await execute(session.page, s, account);
          H.run.scenarios.push(r);
          const next = r.status === 'failed' ? r.bugCandidate || H.failurePattern(r) : null;
          streak = next && next === pattern ? streak + 1 : next ? 1 : 0;
          pattern = next;
          if (streak >= 3) {
            const healthy = r.pageHttpStatus === 200 && await session.page.locator('#signOut').count() > 0 && !await session.page.locator('input[type=password]:visible').count();
            r.batchDiagnosis = { sessionHealthy: healthy, isolatedPattern: next, continuation: healthy ? 'Bug sortir terisolasi; kasus independen berikutnya dibuka ulang pada halaman sumber.' : 'Prasyarat sesi perlu dipulihkan; tidak mengulang aksi bisnis.' };
            if (!healthy) throw Error('Guard3: sesi tidak sehat sesudah tiga kegagalan berpola sama');
            streak = 0;
          }
          save();
          console.log(JSON.stringify({ id: s.id, account: index + 1, route: s.route, column: s.column.label, status: r.status, error: r.error }));
        }
      } catch (e) {
        account.error = H.safeError(e);
        for (const s of spec.scenarios.filter(s => s.accountIndex === index && !H.run.scenarios.some(r => r.id === s.id))) {
          H.run.scenarios.push({ ...H.baseScenario(s.id, s.title, s.screen), route: s.route, accountIndex: index, column: s.column, requirements: s.requirements, error: account.error, provenance: { source: spec.source, originalId: s.originalId, previousStatus: 'failed' } });
        }
        save();
      } finally { if (session) await session.context.close(); }
    }
  } finally {
    await browser.close();
    H.run.finishedAt = new Date().toISOString();
    H.run.summary = { total: H.run.scenarios.length, statuses: H.run.scenarios.reduce((a, s) => ({ ...a, [s.status]: (a[s.status] || 0) + 1 }), {}), accounts: H.run.accounts.map(a => ({ index: a.index, role: a.role, status: a.status })) };
    save();
  }
  console.log(JSON.stringify({ output: `results/${H.run.module}__${H.runId}.json`, summary: H.run.summary }));
}
module.exports = { execute, hitTest, H, spec };
if (require.main === module) main().catch(e => { H.run.fatal = H.safeError(e); save(); console.error(H.run.fatal); process.exitCode = 1; });
