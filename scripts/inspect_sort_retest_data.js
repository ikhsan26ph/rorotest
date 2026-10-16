// Diagnosis DOM tanpa menyalin nama/kontak pribadi atau payload autentikasi.
const fs = require('fs');
const path = require('path');
const { chromium } = require('@playwright/test');
const H = require('./audit_sort_icons');
const source = JSON.parse(fs.readFileSync(process.argv[2]));
if (!source.finishedAt) throw Error('Tunggu run sumber selesai sebelum diagnosis');
async function main() {
  const browser = await chromium.launch({ headless: true });
  const session = await H.login(browser, 0);
  const observations = [];
  try {
    for (const id of process.argv.includes('--city-only') ? ['SCN-0002'] : process.argv.includes('--name-only') ? ['SCN-0006'] : ['SCN-0002', 'SCN-0006', 'SCN-0007']) {
      const s = source.scenarios.find(s => s.id === id);
      await session.page.goto(s.route, { waitUntil: 'domcontentloaded' });
      await H.settle(session.page);
      const head = (await H.inventory(session.page)).find(h => h.label === s.column.label);
      const details = await session.page.locator('thead th').nth(head.index).evaluate((th, column) => {
        const rows = [...th.closest('table').querySelectorAll('tbody tr')].filter(r => r.cells.length > column.cellIndex && ![...r.cells].some(c => c.colSpan > 1));
        const cells = rows.slice(0, 3).map(r => r.cells[column.cellIndex]);
        const publicCity = /Kota Asal|Kota Tujuan/.test(column.label);
        const limit = document.querySelector('#valuelimit');
        return {
          rows: rows.length,
          limit: limit ? { tag: limit.tagName, value: limit.value, options: [...(limit.options || [])].map(o => ({ value: o.value, label: o.text })) } : null,
          cells: cells.map(c => ({ segments: publicCity ? c.innerText.split('\n').map(s => s.trim()).filter(Boolean) : undefined, children: [...c.children].map(e => ({ tag: e.tagName, className: e.className, textLength: e.innerText.length })), textLength: c.innerText.length }))
        };
      }, head);
      observations.push({ id, column: s.column.label, ...details });
      if (process.argv.includes('--city-only')) {
        await session.page.locator('#valuelimit').selectOption('100');
        await H.settle(session.page);
        observations.at(-1).cityCycles = [];
        for (let n = 0; n < 2; n++) {
          const th = session.page.locator('thead th').nth(head.index);
          await th.evaluate(el => el.scrollIntoView({ block: 'center', inline: 'nearest', behavior: 'instant' }));
          await th.locator('i.fa-sort,i.fa-sort-up,i.fa-sort-down').first().click();
          await H.settle(session.page);
          const state = await H.state(session.page, head);
          const cities = state.values.map(v => v.split('\n').map(t => t.trim()).filter(Boolean)[0] || '');
          const cityNames = cities.map(v => v.replace(/\s*\([^)]*\)\s*$/, '').trim());
          const check = H.oracle(cityNames, state.sortType, head);
          const cycle = { direction: state.sortType, check, violations: check.violations?.map(v => ({ beforeRow: v.beforeRow, beforeCity: cities[v.beforeRow - 1], afterRow: v.afterRow, afterCity: cities[v.afterRow - 1] })) };
          if (check.verifiable && !check.ordered) {
            const screenshot = path.join(H.shots, `${id}-${state.sortType}-violation.png`);
            await th.evaluate((el, row) => {
              const rows = [...el.closest('table').querySelectorAll('tbody tr')].filter(r => r.cells.length > el.cellIndex && ![...r.cells].some(c => c.colSpan > 1) && r.getClientRects().length > 0);
              rows[row - 1]?.scrollIntoView({ block: 'center', behavior: 'instant' });
            }, check.violations[0].beforeRow);
            await session.page.screenshot({ path: screenshot, fullPage: false });
            cycle.screenshot = path.relative(H.ROOT, screenshot);
          }
          observations.at(-1).cityCycles.push(cycle);
        }
      }
      if (id === 'SCN-0006') {
        const th = session.page.locator('thead th').nth(head.index);
        await th.locator('i.fa-sort,i.fa-sort-up,i.fa-sort-down').first().click();
        await H.settle(session.page);
        const after = await H.state(session.page, head);
        const check = H.oracle(after.values, after.sortType, head);
        observations.at(-1).recheck = { direction: after.sortType, check, rowHashes: after.values.map(H.hash) };
        if (check.verifiable && !check.ordered) {
          const screenshot = path.join(H.shots, `${id}-${after.sortType}.png`);
          await session.page.screenshot({ path: screenshot, fullPage: true });
          observations.at(-1).recheck.screenshot = path.relative(H.ROOT, screenshot);
          observations.at(-1).recheck.valueProfiles = check.violations.map(v => [v.beforeRow, v.afterRow].map(n => ({ row: n, hash: H.hash(after.values[n - 1]), length: after.values[n - 1].length, leadingNonLetter: !/^\p{L}/u.test(after.values[n - 1]), trailingWhitespace: /\s$/.test(after.values[n - 1]) })));
        }
      }
      console.log(JSON.stringify(observations.at(-1)));
    }
    fs.writeFileSync(path.join(H.dir, 'dom-diagnosis.json'), JSON.stringify(observations, null, 2));
  } finally { await session.context.close(); await browser.close(); }
}
main().catch(e => { console.error(H.safeError(e)); process.exitCode = 1; });
