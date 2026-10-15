// Jalankan sesudah audit selesai: node scripts/diagnose_sort_icons.js <results.json>.
// Menyelidiki kegagalan dengan klik pengguna biasa dan hit-test DOM, tanpa force.
const fs = require('fs');
const path = require('path');
const { chromium } = require('@playwright/test');
process.env.SORT_AUDIT_WAIT_MS ||= '45000';
const H = require('./audit_sort_icons');
const sourcePath = path.resolve(process.argv[2]);
const source = JSON.parse(fs.readFileSync(sourcePath));
H.run.module = 'sorting-diagnosis';
H.run.source = path.relative(H.ROOT, sourcePath);
const output = path.join(H.ROOT, 'results', `sorting-diagnosis__${H.runId}.json`);
const save = () => fs.writeFileSync(output, JSON.stringify(H.run, null, 2));

async function hitTest(page, head) {
  const th = page.locator('thead th').nth(head.index);
  await th.evaluate(el => el.scrollIntoView({ block: 'center', inline: 'nearest', behavior: 'instant' }));
  await page.waitForTimeout(300);
  return th.evaluate(el => {
    const icon = el.querySelector('i.fa-sort,i.fa-sort-up,i.fa-sort-down');
    if (!icon) return { reason: 'Tidak ada ikon FontAwesome' };
    const r = icon.getBoundingClientRect(), rect = el.getBoundingClientRect();
    const x = r.x + r.width / 2, y = r.y + r.height / 2;
    const target = document.elementFromPoint(x, y);
    const targetHeader = target?.closest('th');
    return { x, y, iconRect: { x: r.x, y: r.y, width: r.width, height: r.height }, headerRect: { x: rect.x, y: rect.y, width: rect.width, height: rect.height }, ownHeader: targetHeader === el, targetHeader: targetHeader?.innerText.trim().replace(/\s+/g, ' '), targetGroup: targetHeader?.getAttribute('groupnya'), targetTag: target?.tagName, targetClass: target?.className, targetInteractive: !!target?.closest('a,button,input'), expectedGroup: el.getAttribute('groupnya') };
  });
}

(async () => {
  // Semua failed diulang; sampel masalah klik pada setiap template halaman.
  const technical = new Set();
  const targets = source.scenarios.filter(s => {
    if (s.status === 'failed' && s.screenshot && s.responseErrors?.some(e => e.status >= 500)) return false;
    if (s.status === 'failed' && /Arah sortir tidak berganti/.test(s.error || '') && s.evidence?.cycles?.every(c => c.network.some(n => n.sorting.sortType === 'ASC') && c.network.some(n => n.sorting.sortType === 'DESC'))) return false;
    if (s.status === 'failed') return true;
    if (s.status === 'passed' && /whatsapp|\bWA\b|\bHP\b|telp|telepon|phone|rekening/i.test(s.column?.label || '')) return true;
    if (s.status !== 'blocked' || !/intercepts|not stable|waitForFunction.*Timeout/i.test(s.error || '')) return false;
    const key = `${s.accountIndex}:${s.screen}`;
    if (technical.has(key)) return false;
    technical.add(key); return true;
  });
  const browser = await chromium.launch({ headless: true });
  try {
    for (const index of [...new Set(targets.map(s => s.accountIndex))]) {
      const account = { index, role: H.env.accounts[index].role };
      H.run.accounts.push(account);
      let session;
      let streak = 0, pattern = null, stopped = false;
      try {
        session = await H.login(browser, index);
        account.status = session.gated ? 'device-gated' : 'authenticated';
        const page = session.page;
        for (const original of targets.filter(s => s.accountIndex === index)) {
          const started = Date.now();
          const r = { ...original, evidence: undefined, screenshot: null, error: null, bugCandidate: null, status: 'blocked', notes: 'Diagnosis ulang; hasil sumber dipertahankan sebagai provenance.', provenance: { source: H.run.source, previousStatus: original.status, previousError: original.error }, startedAt: new Date().toISOString() };
          try {
            if (stopped) throw Error('Guard tiga failed beruntun pola sama; diagnosis interaksi dihentikan untuk akun ini');
            await page.goto(original.screen, { waitUntil: 'domcontentloaded' });
            await H.settle(page);
            const heads = await H.inventory(page);
            const head = heads.find(h => h.group === original.column.group && h.label === original.column.label);
            if (!head) throw Error('Header sumber tidak ditemukan pada DOM aktual');
            r.hitTest = await hitTest(page, head);
            if (!r.hitTest.ownHeader && r.hitTest.targetHeader && !r.hitTest.targetInteractive && r.hitTest.targetGroup !== head.group) {
              const before = await H.state(page, head);
              await page.mouse.click(r.hitTest.x, r.hitTest.y);
              await H.settle(page);
              const after = await H.state(page, head);
              r.evidence = { expectedGroup: head.group, actualGroup: after.sortBy, expectedIconHeader: head.label, actualHitHeader: r.hitTest.targetHeader, actualDirection: after.sortType };
              const sortedOther = r.hitTest.targetGroup && after.sortBy === r.hitTest.targetGroup;
              if (sortedOther || (after.sortBy === before.sortBy && after.sortType === before.sortType && after.attr === before.attr)) {
                r.status = 'failed'; r.bugCandidate = 'SORT-ICON-WRONG-COLUMN';
                r.error = sortedOther ? `Klik posisi ikon ${head.label} menyortir ${r.hitTest.targetHeader}; expected field ${head.group}, actual ${after.sortBy}` : `Klik posisi ikon ${head.label} tertutup header ${r.hitTest.targetHeader}; handler sortir tidak berjalan (field/direction/indikator tidak berubah)`;
              } else { r.error = 'Hit-test menunjukkan kolom lain, tetapi efek sortir belum terkonfirmasi'; }
            } else {
              const before = H.run.scenarios.length;
              const retest = await H.auditColumn(page, head, account, original.screen);
              H.run.scenarios.splice(before);
              Object.assign(r, retest, { id: original.id, title: original.title, requirements: original.requirements, hitTest: r.hitTest, provenance: r.provenance });
            }
            if (r.status === 'failed' && !r.screenshot) {
              r.screenshot = path.relative(H.ROOT, path.join(H.shots, `${r.id}.png`));
              await page.screenshot({ path: path.join(H.ROOT, r.screenshot), fullPage: true });
            }
          } catch (e) { r.status = 'blocked'; r.error = H.safeError(e); }
          const next = r.status === 'failed' && r.bugCandidate === 'SORT-ICON-WRONG-COLUMN' ? 'wrong-column' : H.failurePattern(r);
          streak = next && next === pattern ? streak + 1 : next ? 1 : 0;
          pattern = next;
          if (streak >= 3) { stopped = true; account.guard = 'Tiga failed beruntun pola sama'; }
          r.durationSec = (Date.now() - started) / 1000;
          H.run.scenarios.push(r); save();
          console.log(JSON.stringify({ title: r.title, status: r.status, error: r.error }));
        }
      } catch (e) { account.error = H.safeError(e); save(); }
      finally { if (session) await session.context.close(); }
    }
  } finally { await browser.close(); H.run.finishedAt = new Date().toISOString(); save(); }
  console.log('DIAGNOSIS', output);
})().catch(e => { H.run.fatal = H.safeError(e); save(); console.error(H.run.fatal); process.exitCode = 1; });
