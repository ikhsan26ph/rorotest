// Cakupan tab read-only pada template Manifest dan Detail Asuransi.
const fs = require('fs');
const path = require('path');
const { chromium } = require('@playwright/test');
const H = require('./audit_sort_icons');
const sourcePath = path.resolve(process.argv[2]);
const source = JSON.parse(fs.readFileSync(sourcePath));
H.run.module = 'sorting-tabs';
H.run.source = path.relative(H.ROOT, sourcePath);
const targets = source.pages.filter(p => /detailmanifest|detailasuransi/i.test(p.route) && p.status !== 'blocked');
for (const parent of source.pages.filter(p => /manifestkapal$/i.test(p.route))) {
  if (!targets.some(p => p.accountIndex === parent.accountIndex && /detailmanifest/i.test(p.route))) targets.push({ ...parent, isManifestParent: true });
}

(async () => {
  const browser = await chromium.launch({ headless: true });
  try {
    for (const index of [...new Set(targets.map(p => p.accountIndex))]) {
      const account = { index, role: H.env.accounts[index].role };
      const guarded = source.scenarios.some(s => s.accountIndex === index && /Guard tiga failed/.test(s.error || ''));
      if (guarded) account.guard = 'Guard run sumber dipertahankan: hanya inventaris tab dan header';
      H.run.accounts.push(account);
      let session;
      let streak = 0, pattern = null, stopped = false;
      try {
        session = await H.login(browser, index);
        account.status = session.gated ? 'device-gated' : 'authenticated';
        const page = session.page;
        for (const target of targets.filter(p => p.accountIndex === index)) {
          let route = target.route;
          if (target.isManifestParent) {
            try {
              await page.goto(route, { waitUntil: 'domcontentloaded' }); await H.settle(page);
              const links = await page.locator('table tbody a[href*="detailmanifest"]').evaluateAll(es => es.map(e => e.href));
              const next = H.safePath(links[1] || links[0]);
              if (!next) throw Error('Tidak ada detail Manifest pada DOM aktual');
              const headers = await H.inventory(page);
              H.run.pages.push({ accountIndex: index, role: account.role, route, status: 'inspected', columns: headers.map(h => ({ index: h.index, label: h.label, group: h.group })) });
              for (const head of headers) {
                if (guarded) {
                  const r = H.baseScenario(`SORT-A${index + 1}-${H.hash(route)}-${head.index}`, `${account.role}: ${route} — ${head.label} (ASC/DESC)`, route);
                  r.accountIndex = index; r.column = { label: head.label, group: head.group, cellIndex: head.cellIndex }; r.error = 'Guard tiga failed sumber; header Manifest diinventarisasi tanpa klik sortir'; H.run.scenarios.push(r); H.save();
                } else await H.auditColumn(page, head, account, route);
              }
              route = next;
            } catch (e) { H.run.pages.push({ accountIndex: index, route, status: 'blocked', error: H.safeError(e) }); H.save(); continue; }
          }
          if (/detailmanifest/i.test(route)) {
            const parent = source.pages.find(p => p.accountIndex === index && /manifestkapal$/i.test(p.route));
            const choices = [...new Set((parent?.detailLinks || []).filter(u => /detailmanifest/i.test(u)))];
            // Alternate actual record; default manifest may be an empty future fixture.
            if (choices[1]) route = H.safePath(choices[1]);
          }
          try {
            await page.goto(route, { waitUntil: 'domcontentloaded' });
            await H.settle(page);
            const tabs = await page.evaluate(() => [...document.querySelectorAll('[data-toggle="tab"],[data-bs-toggle="tab"],[role="tab"]')].filter(el => el.getClientRects().length).map((el, index) => ({ index, name: el.innerText.trim(), target: el.getAttribute('href') || el.getAttribute('data-target') || el.getAttribute('data-bs-target') || '#' + el.getAttribute('aria-controls') })).filter(t => t.target?.startsWith('#') && t.target.length > 1));
            const pageInfo = { accountIndex: index, role: account.role, route, sourceRoute: target.route, status: 'inspected', columns: [], tabs };
            H.run.pages.push(pageInfo);
            pageInfo.columns = (await H.inventory(page)).map(h => ({ index: h.index, label: h.label, group: h.group }));
            for (const tab of tabs) {
              if (stopped) break;
              const control = page.locator(`[data-toggle="tab"],[data-bs-toggle="tab"],[role="tab"]`).filter({ hasText: tab.name }).first();
              await control.click();
              await H.settle(page);
              const screen = route + '#audit-tab-' + H.hash(tab.target);
              for (const head of await H.inventory(page)) {
                if (stopped) break;
                if (!pageInfo.columns.some(h => h.index === head.index && h.group === head.group)) pageInfo.columns.push({ index: head.index, label: head.label, group: head.group });
                if (guarded) {
                  const r = H.baseScenario(`SORT-A${index + 1}-${H.hash(screen)}-${head.index}`, `${account.role}: ${screen} — ${head.label} (ASC/DESC)`, screen);
                  r.accountIndex = index; r.column = { label: head.label, group: head.group, cellIndex: head.cellIndex }; r.error = 'Guard tiga failed sumber; tab diinventarisasi tanpa klik sortir'; r.tab = tab.name; H.run.scenarios.push(r); H.save(); continue;
                }
                const r = await H.auditColumn(page, head, account, screen);
                r.notes = (r.notes ? r.notes + ' ' : '') + `Tab ${tab.name}; binding aktual ${route}; sumber template ${target.route}.`;
                r.tab = tab.name;
                const next = H.failurePattern(r);
                streak = next && next === pattern ? streak + 1 : next ? 1 : 0;
                pattern = next;
                if (streak >= 3) { stopped = true; account.guard = 'Tiga failed beruntun pola sama'; }
                H.save();
              }
            }
          } catch (e) { H.run.pages.push({ accountIndex: index, role: account.role, route, status: 'blocked', error: H.safeError(e) }); H.save(); }
        }
      } catch (e) { account.error = H.safeError(e); H.save(); }
      finally { if (session) await session.context.close(); }
    }
  } finally { await browser.close(); H.run.finishedAt = new Date().toISOString(); H.save(); }
  console.log('TABS', path.join(H.ROOT, 'results', `sorting-tabs__${H.runId}.json`));
})().catch(e => { H.run.fatal = H.safeError(e); H.save(); console.error(H.run.fatal); process.exitCode = 1; });
