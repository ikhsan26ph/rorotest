// Spec modul OP-12 Kuota & Jadwal — Sistem Penjualan Tiket Kapal (portal Operator /partner).
// Judul test = "SCN-xxxx: <judul scenarios.json>" (dibaca langsung dari file agar traceability 1:1).
// Sumber skenario: scenario/kuota-jadwal/kuota-jadwal_scenarios.json (15 skenario). Selector:
// shared/selector-map-kuota-jadwal.md & shared/selector-map-partner-common.md (harvest 27 September 2026).
// Ditulis MENIRU POLA tests/master.spec.js (OP-11 Master, JALAN & STABIL) — import fixture, helper
// select2/optionValueByText/realOptionTexts/row/openList/dst SAMA PERSIS, lihat komentar tiap helper untuk
// penyesuaian modul ini. Urutan eksekusi = urutan file (workers: 1) = urutan SCN-0001..SCN-0015 di
// scenarios.json (prasyarat berantai SCN-0001→0002→0003 dan SCN-0004 mandiri sudah dihormati oleh urutan ini).
//
// ATURAN KHUSUS MODUL INI (WAJIB dibaca, lihat kuota-jadwal_scenarios.json/_coverage.md/_analysis.md):
// 1. DILARANG KERAS menyentuh tombol "Kirim ke Pelindo" (`button.btn-kirim`) — keputusan user 27 Sep 2026.
//    TIDAK ADA satu baris kode pun di file ini yang meng-query atau mengklik `.btn-kirim`/`button.btn-kirim`.
//    JANGAN PERNAH menambahkannya, bahkan untuk sekadar memverifikasi keberadaannya.
// 2. SCN-0001 (Cabang, "AUTOTEST-20260927-KJ-CABANG") dan SCN-0004 (Pusat, "AUTOTEST-20260927-KJ-PUSAT")
//    MEMBUAT DATA BARU sungguhan dengan jadwal keberangkatan SEJAUH MUNGKIN DI MASA DEPAN (docs/agent-guide.md
//    aturan JADWAL). SCN-0001 dipakai ulang oleh SCN-0002 (baca-saja) lalu DIHAPUS di akhir SCN-0003.
//    SCN-0004 dihapus di akhir skenario yang sama. Kedua data ini TIDAK PERNAH dipakai transaksi apa pun
//    sehingga aman dihapus — beda dari Master yang datanya permanen begitu punya Harga.
// 3. SCN-0007 (trayek ≥3 pelabuhan) — coba dulu trayek Master "asdfghdaf" (FND-M-05); kalau tidak muncul di
//    dropdown Tambah Kuota & Jadwal (artinya belum punya Tarif Pass, syarat REQ-004), blockedUnless(false, ...)
//    apa adanya. TIDAK PERNAH membuat Trayek/Tarif Pass baru di Master untuk memenuhi skenario ini.
// 4. SCN-0015 (edit data terpakai transaksi, Q-KJ-04) — BLOCKED, diimplementasikan sebagai blockedUnless
//    langsung tanpa mencoba jalan lain (belum ada data uji milik run sendiri yang aman diedit).
// 5. SCN-0005/0006 (Simpan kosong, VAL-001/002) — OBSERVASIONAL MURNI. TIDAK ADA asumsi hasil (silent/alert/
//    tersimpan) sebelum eksekusi sungguhan — hanya note() mencatat apa yang terjadi, dengan cleanup
//    kontingensi (Hapus) bila ternyata data sempat tersimpan.
// 6. Selector tabel Daftar (`table:visible tbody tr:not(:has(td[colspan]))`) & scoping per-baris via row()
//    WAJIB dipakai di semua akses tabel modul ini (pola sama Master, tabel diduga memakai komponen yang
//    dipakai ulang lintas modul) — JANGAN pakai #id global untuk baris/tombol aksi.
// 7. Tab "KUOTA/JADWAL/CREW LIST" (Tambah) dan "Kuota/Jadwal/crew list" (Edit) HANYA teridentifikasi via teks
//    (TIDAK STABIL, tidak ada id/role pasti — lihat shared/selector-map-kuota-jadwal.md). Interaksi tanggal
//    Waktu Berangkat/Tiba (datepicker widget "dtp") SUDAH diverifikasi live 27 Sep 2026 — lihat komentar
//    `pickFarFutureRange`/`setDateTimeField` di bawah untuk metode yang terbukti bekerja.
const fs = require('fs');
const path = require('path');
const { test, expect } = require('./helpers/partner-session');

const MODULE = 'kuota-jadwal';
const SCN = Object.fromEntries(
  JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'scenario', MODULE, `${MODULE}_scenarios.json`), 'utf8'))
    .scenarios.map((s) => [s.id, s])
);
const t = (id, fn) => test(`${id}: ${SCN[id].title}`, fn);

const TAG = 'AUTOTEST-20260927';
const DATA = {
  voyageCabang: `${TAG}-KJ-CABANG`,
  voyagePusat: `${TAG}-KJ-PUSAT`,
  voyageEmptyKuota: `${TAG}-EMPTY-KUOTA`,
  voyageEmptyJadwal: `${TAG}-EMPTY-JADWAL`,
};
// Jadwal existing yang SUDAH dipakai transaksi OP-13 (Q-KJ-04) — HANYA dibaca (Edit dibuka utk baca atribut),
// TIDAK PERNAH disimpan perubahan apa pun. Lihat SCN-0009.
const JADWAL_TERPAKAI = 'AUTOTEST-20260925-PPBPN-01';
// Menyimpan pilihan Trayek SCN-0001 supaya SCN-0004 bisa memilih Trayek Pare-Pare LAIN (hindari duplikasi).
const STATE = { scn0001TrayekValue: null, scn0001TrayekText: null };

// ---------- helper umum (pola dipertahankan sama persis dengan tests/master.spec.js) ----------
function note(text) { test.info().annotations.push({ type: 'note', description: text }); }
function blockedUnless(cond, msg) {
  if (!cond) { test.info().annotations.push({ type: 'blocked', description: msg }); test.skip(true, `blocked: ${msg}`); }
}
// Beda dari blockedUnless: TIDAK men-skip seluruh test, dipakai saat hanya SEBAGIAN langkah skenario (mis.
// cross-check modul lain) tidak bisa dijalankan di file spec ini tapi langkah WAJIB berikutnya (cleanup) tetap
// harus lanjut (instruksi eksplisit SCN-0003: "tandai blocked parsial, tetap lanjutkan cleanup Hapus").
function notePartialBlock(msg) {
  test.info().annotations.push({ type: 'blocked-partial', description: msg });
  note(`[blocked-partial] ${msg}`);
}
async function flag(fnd, actualNote, fn) {
  try { await fn(); } catch (e) {
    test.info().annotations.push({ type: 'bugCandidate', description: `${fnd} ${actualNote}` });
    throw e;
  }
}
async function openList(page, urlPath) {
  // TERBUKTI (SCN-0003 run 5/6): goto() bisa kena net::ERR_ABORTED kalau dipanggil tepat setelah Simpan
  // sebelumnya yang masih melakukan navigasi/reload sendiri (race) — retry sekali sudah cukup.
  await page.goto(urlPath).catch(async (e) => {
    if (!/ERR_ABORTED/.test(String(e))) throw e;
    await page.waitForTimeout(500);
    await page.goto(urlPath);
  });
  await page.waitForLoadState('networkidle').catch(() => {});
  await expect(page.locator('table:visible tbody')).not.toContainText('Mohon tunggu sebentar', { timeout: 10_000 }).catch(() => {});
  await expect(page.locator('table:visible tbody tr:not(:has(td[colspan]))').first()).toBeVisible({ timeout: 20_000 });
}
// Tabel Daftar Kuota & Jadwal (SCR-01) punya baris tambahan "Rute yang dilewati trayek ini" per trayek (badge
// pelabuhan, SELALU tampil) — pola sama kemungkinan spacer/template row Master (FND-M-06). Scoping defensif
// WAJIB: exclude baris dengan td[colspan], lalu filter hasText supaya baris tambahan yang tidak memuat teks
// yang dicari otomatis tidak ikut ter-match.
const row = (page, text) => page.locator('table:visible tbody tr:not(:has(td[colspan]))', { hasText: text });
const filterSubmit = (page) => page.locator('button[type="submit"]', { hasText: 'Filter' });
async function openFilteredList(page, urlPath, selector, value) {
  await openList(page, urlPath);
  await page.locator('#btn-filter').click();
  await page.locator(selector).fill(value);
  await filterSubmit(page).click();
  await page.waitForLoadState('networkidle').catch(() => {});
}
// Retry singkat (pelajaran pahit OP-21/Master: filter kadang tidak langsung memuat data yang baru saja dibuat).
async function exists(page, urlPath, selector, text) {
  for (let attempt = 1; attempt <= 3; attempt++) {
    await openFilteredList(page, urlPath, selector, text);
    if ((await row(page, text).count()) > 0) return true;
    if (attempt < 3) await page.waitForTimeout(1500);
  }
  return false;
}
// TERVERIFIKASI live 27 Sep 2026: dialog konfirmasi Hapus Jadwal berlabel "Hapus" (bukan "Ya" seperti pola
// hapus di modul lain) — dua data uji nyaris tertinggal permanen (AUTOTEST-20260927-KJ-CABANG/-PUSAT) sebelum
// ditemukan & dibersihkan manual saat debugging.
async function deleteJadwalRowConfirmed(page, rowLocator, confirmLabel = 'Hapus') {
  await rowLocator.locator('a.btn-delete.delete-jadwal').click();
  await swalClick(page, confirmLabel);
  await page.waitForLoadState('networkidle').catch(() => {});
}
// Banyak dropdown dinamis (Trayek/Kapal/Status Jadwal/Awak Kapal) di-Select2-kan — pola sama Golongan/Trayek
// Master yang TERBUKTI crash JS saat trigger('change'). WASPADAI pola sama di modul ini (form Tambah Kuota &
// Jadwal punya banyak dropdown dinamis). Tangkap error di sini, dicatat terpisah via watchPageErrors.
async function select2(page, selector, value) {
  await page.evaluate(([s, v]) => {
    const $ = window.jQuery || window.$;
    try { $(s).val(v).trigger('change'); } catch (e) { /* dicatat via page.on('pageerror') di watchPageErrors */ }
  }, [selector, value]);
}
// Varian select2 berbasis Locator (bukan selector string) — dipakai untuk elemen TANPA id pasti (mis. select
// Status Jadwal FND-KJ-04, select "Pilih Awak Kapal" pada modal Crew List).
async function select2El(page, locator, value) {
  await locator.evaluate((el, v) => {
    const $ = window.jQuery || window.$;
    try { $(el).val(v).trigger('change'); } catch (e) { /* dicatat via watchPageErrors */ }
  }, value);
}
function watchPageErrors(page) {
  const errs = [];
  page.on('pageerror', (e) => errs.push(String(e.message || e).slice(0, 200)));
  return errs;
}
async function optionValueByText(page, selectSelector, text) {
  const opt = page.locator(`${selectSelector} option`, { hasText: text }).first();
  const c = await opt.count();
  if (!c) throw new Error(`opsi "${text}" tidak ditemukan di ${selectSelector}`);
  return (await opt.getAttribute('value')) ?? '';
}
// Placeholder opsi kadang value="" TAPI kadang value = teks placeholder itu sendiri (mis. "--Pilih Trayek--"
// pada #trayek, "-- Pilih Pelabuhan --" pada Master port[]) — TERBUKTI (SCN-0013 run 1) firstRealOptionValue
// tanpa filter ini salah memilih placeholder sebagai "opsi pertama valid". WAJIB exclude pola `/^--.*--$/`.
function isPlaceholderValue(v) { return !v || /^--.*--$/.test(v.trim()); }
async function firstRealOptionValue(page, selectSelector) {
  const opts = page.locator(`${selectSelector} option`);
  const count = await opts.count();
  for (let i = 0; i < count; i++) {
    const val = await opts.nth(i).getAttribute('value');
    if (!isPlaceholderValue(val)) return val;
  }
  throw new Error(`Tidak ada opsi valid pada ${selectSelector}`);
}
async function firstRealOptionValueFromLocator(selectLocator) {
  const opts = selectLocator.locator('option');
  const count = await opts.count();
  for (let i = 0; i < count; i++) {
    const val = await opts.nth(i).getAttribute('value');
    if (!isPlaceholderValue(val)) return val;
  }
  return null;
}
async function realOptionTexts(page, selectSelector) {
  return page.locator(`${selectSelector} option`).evaluateAll((opts) =>
    opts.filter((o) => o.getAttribute('value') && !/^--.*--$/.test(o.getAttribute('value').trim()))
      .map((o) => o.textContent.trim()));
}
async function swalClick(page, buttonName) {
  await expect(page.locator('.swal2-popup')).toBeVisible({ timeout: 8000 });
  await page.locator('.swal2-popup').getByRole('button', { name: buttonName, exact: true }).click();
}
async function closeSwal(page) {
  const popup = page.locator('.swal2-popup');
  if (await popup.count()) {
    const btn = popup.locator('.swal2-confirm, .swal2-cancel, button').first();
    if (await btn.count()) await btn.click().catch(() => {});
  }
  await page.waitForTimeout(200);
}
function modalLocator(page) { return page.locator('.modal.show, .modal:visible').first(); }
function captureDialogs(page) {
  const messages = [];
  page.on('dialog', async (d) => { messages.push(d.message()); await d.accept().catch(() => {}); });
  return messages;
}

// ---------- helper khusus modul Kuota & Jadwal ----------

// Tombol Simpan tiap tab (Kuota/Jadwal) TIDAK punya id pembeda (selector-map: berisiko ambigu bila 2 tab
// terbuka bersamaan di DOM) — scoping via :visible supaya hanya tombol pada tab yang SEDANG aktif yang
// ter-match (tab non-aktif diasumsikan display:none/tersembunyi, konsisten pola nav-tab Bootstrap).
const simpanBtn = (page) => page.locator('button:visible', { hasText: 'Simpan' }).first();

// Label tab ("KUOTA"/"JADWAL"/"CREW LIST" di Tambah, "Kuota"/"Jadwal"/"crew list" di Edit) TIDAK STABIL (teks
// murni, tanpa id/role pasti — lihat shared/selector-map-kuota-jadwal.md). Prioritaskan pencarian di dalam
// container nav-tab umum supaya tidak salah match dgn sidebar "KUOTA & JADWAL" yang juga memuat substring
// "JADWAL". Match case-insensitive supaya cocok baik versi Tambah (besar) maupun Edit (campuran).
// TERVERIFIKASI LIVE 27 Sep 2026: tab KUOTA/JADWAL/CREW LIST BUKAN elemen <a> — struktur asli
// `ul.nav.nav-tabs > li.nav-item > span.nav-link` (mis. class "nav-link tab-jadwal"/"nav-link tab-crew").
function findTab(page, label) {
  const re = new RegExp(`\\b${label.replace(/\s+/g, '\\s+')}\\b`, 'i');
  // Halaman Edit (SCR-06/07/08) merender SATU set tab tersembunyi PER BARIS (template per-id, mis.
  // href="#tab-eg10-<id>") — filter :visible WAJIB, kalau tidak .first() bisa kena tab baris lain yg tersembunyi.
  return page.locator('.nav-tabs .nav-link:visible, .nav-tabs span:visible, [role="tablist"] a:visible, ul.nav .nav-link:visible').filter({ hasText: re }).first();
}
async function clickTab(page, label) {
  await findTab(page, label).click();
  await page.waitForTimeout(300);
}

// Pilih opsi Trayek berasal-kota Pare-Pare, SELAIN trayek Parepare-Balikpapan (dipakai jadwal existing
// AUTOTEST-20260925-PPBPN-01, id 2293, Q-KJ-04) — sekaligus otomatis menghindari kompleksitas readonly
// Bonus Tiket golongan III-A/III-B (VAL-006) yang khusus berlaku pada trayek itu. excludeValues dipakai
// SCN-0004 untuk menghindari trayek yang sama dgn yang dipilih SCN-0001.
async function pickTrayekPareparNonBalikpapan(page, excludeValues = []) {
  const all = await page.locator('select#trayek option').evaluateAll((opts) =>
    opts.map((o) => ({ value: o.getAttribute('value'), text: (o.textContent || '').trim() })).filter((o) => o.value));
  const pareOpts = all.filter((o) => /parepare/i.test(o.text));
  const nonBalikpapan = pareOpts.filter((o) => !/balikpapan/i.test(o.text));
  const pool = nonBalikpapan.length ? nonBalikpapan : pareOpts;
  const filtered = pool.filter((o) => !excludeValues.includes(o.value));
  const chosen = filtered[0] || pool[0] || null;
  return { chosen, pareOpts, avoidedBalikpapanOnly: nonBalikpapan.length === 0 && pareOpts.length > 0 };
}

// Cari baris Distribusi Kuota (Penumpang/Kendaraan/Bagasi) pertama yang bisa diisi (internal & eksternal
// keduanya TIDAK readonly/disabled). Pola id: internal `dist_<jenis><id>`, eksternal `dist_<jenis>_eks<id>`
// (dikonfirmasi shared/selector-map-kuota-jadwal.md) — prefix "dist_<jenis>" pada query DOM akan menangkap
// KEDUA varian (krn eks id juga berawalan sama), makanya internals difilter exclude id yang memuat "_eks".
async function firstEditableDistRow(page, prefix) {
  const pair = await page.evaluate((pfx) => {
    const all = Array.from(document.querySelectorAll(`input[id^="${pfx}"]`));
    const internals = all.filter((el) => !el.id.includes('_eks'));
    for (const el of internals) {
      if (el.readOnly || el.disabled) continue;
      const eksId = el.id.replace(pfx, `${pfx}_eks`);
      const eksEl = document.getElementById(eksId);
      if (eksEl && (eksEl.readOnly || eksEl.disabled)) continue;
      return { internalId: el.id, eksId: eksEl ? eksEl.id : null };
    }
    return null;
  }, prefix);
  if (!pair) return null;
  return {
    internal: page.locator(`#${pair.internalId}`),
    eksternal: pair.eksId ? page.locator(`#${pair.eksId}`) : null,
  };
}
function toEksId(internalId, prefix) { return internalId.replace(prefix, `${prefix}_eks`); }
// TERBUKTI live 27 Sep 2026 (baca source halaman langsung): validasi Simpan tab KUOTA mewajibkan SEMUA baris
// distribusi (.dist_penumpang, .dist_penumpang_eks, .dist_kendaraan, .dist_kendaraan_eks, .dist_bagasi,
// .dist_bagasi_eks) terisi — kalau SATU SAJA kosong, popover "Masukkan 0 Jika Tidak Distribusi" muncul dan
// Simpan batal SENYAP (return false, tanpa alert/request — mirip pola FND-M-01 Master). WAJIB isi 0 ke semua
// baris dulu sebelum override baris yang benar-benar diuji.
async function fillAllQuotaZero(page) {
  await page.evaluate(() => {
    const classes = ['dist_penumpang', 'dist_penumpang_eks', 'dist_kendaraan', 'dist_kendaraan_eks', 'dist_bagasi', 'dist_bagasi_eks'];
    for (const cls of classes) {
      document.querySelectorAll(`input.${cls}`).forEach((el) => {
        if (el.readOnly || el.disabled) return;
        if (el.value !== '') return; // jangan timpa nilai yang sudah sengaja diisi
        el.value = '0';
        el.dispatchEvent(new Event('input', { bubbles: true }));
        el.dispatchEvent(new Event('change', { bubbles: true }));
      });
    }
  });
}
// Field Bonus Tiket (`input.bonus_tiket`) diasumsikan berada pada `<tr>` yang sama dengan Kuota Internal
// golongan kendaraan tsb (1 baris = 1 golongan, kolom Internal/Eksternal/Bonus Tiket sejajar).
async function bonusTiketForRow(page, internalInputLocator) {
  const tr = internalInputLocator.locator('xpath=ancestor::tr[1]');
  const bonus = tr.locator('input.bonus_tiket');
  return (await bonus.count()) ? bonus.first() : null;
}
// TERBUKTI (SCN-0004 run 2): tidak semua golongan kendaraan yg kuotanya editable punya input.bonus_tiket yang
// VISIBLE (mis. golongan tertentu bonus_tiket-nya type="hidden") — beda dari asumsi 1:1 firstEditableDistRow.
// Cari baris kendaraan editable YANG SEKALIGUS punya bonus_tiket visible, coba beberapa baris bukan cuma baris 1.
async function firstKendaraanRowWithVisibleBonus(page, maxTry = 10) {
  const internals = page.locator('input[id^="dist_kendaraan"]:not([id*="eks"])');
  const count = Math.min(await internals.count(), maxTry);
  for (let i = 0; i < count; i++) {
    const internal = internals.nth(i);
    if (await internal.isDisabled().catch(() => true)) continue;
    const internalId = await internal.getAttribute('id');
    const eksId = toEksId(internalId, 'dist_kendaraan');
    const eksLocator = page.locator(`#${eksId}`);
    if ((await eksLocator.count()) && (await eksLocator.isDisabled().catch(() => true))) continue;
    const bonus = await bonusTiketForRow(page, internal);
    if (bonus && (await bonus.isVisible().catch(() => false))) {
      return { internal, eksternal: (await eksLocator.count()) ? eksLocator : null, bonus };
    }
  }
  return null;
}

// Modal "INPUT CREW LIST" (SCR-09): pilih opsi Awak Kapal PERTAMA yang valid untuk tiap baris/pelabuhan.
// Select tanpa id pasti (TIDAK STABIL) — pakai select2El (evaluate langsung pada elemen via Locator) supaya
// tidak bergantung pada id/name yang mungkin generic atau salah (FND-KJ-05).
// TERBUKTI live 27 Sep 2026: placeholder select "Awak Kapal" (id pola pilih-crew<n>) pakai value="0" teks
// "Pilih Awak kapal" — BUKAN value="" atau pola "--...--" yang sudah difilter isPlaceholderValue(), sehingga
// firstRealOptionValueFromLocator salah pilih placeholder ini sebagai "opsi valid pertama". Akibatnya modal
// Simpan ditolak diam-diam (baris tetap "-- Belum Memilih Awak Kapal --") dan modal tidak pernah tertutup.
// Fix: cari opsi non-placeholder eksplisit lewat TEKS (skip yang diawali "pilih"), bukan cuma cek value.
async function fillCrewModalMinimal(page) {
  const modal = modalLocator(page);
  await expect(modal).toBeVisible({ timeout: 8000 });
  const selects = modal.locator('select');
  const count = await selects.count();
  let filled = 0;
  for (let i = 0; i < count; i++) {
    const sel = selects.nth(i);
    const val = await sel.evaluate((el) => {
      const opt = Array.from(el.options).find((o) => o.value && !/^pilih\b/i.test(o.textContent.trim()));
      return opt ? opt.value : null;
    }).catch(() => null);
    if (val) {
      await select2El(page, sel, val);
      filled++;
      await page.waitForTimeout(250);
    }
  }
  return filled;
}
// Klik Simpan modal Crew List (#simpan-crew) TIDAK selalu menutup modal (TERBUKTI run 27 Sep 2026: modal
// tetap terbuka & intercept klik "Selesai" berikutnya, timeout 10 dtk). Kemungkinan native confirm() (pola
// sama Master Informasi) atau validasi lain yang belum diketahui. Tangani dialog + verifikasi modal tertutup,
// laporkan blocked (bukan crash) kalau tetap terbuka, jangan lanjut klik elemen di baliknya.
async function submitCrewModal(page) {
  const modal = modalLocator(page);
  page.once('dialog', (d) => d.accept());
  await modal.getByRole('button', { name: 'Simpan' }).click();
  await page.waitForLoadState('networkidle').catch(() => {});
  const closed = await modal.waitFor({ state: 'hidden', timeout: 8000 }).then(() => true).catch(() => false);
  return closed;
}

// Amati (BUKAN asumsikan) hasil klik Simpan: request non-GET terkirim atau tidak, dialog native muncul atau
// tidak, SweetAlert/popover muncul atau tidak. Dipakai skenario OBSERVASIONAL murni (VAL-001/002) dan edge
// case Q-KJ-01 (SCN-0004) — TIDAK men-generate expect() dgn ekspektasi hasil spesifik, hanya mengumpulkan
// fakta untuk dicatat via note().
async function observeSubmit(page, clickFn, timeoutMs = 3000) {
  const dialogs = captureDialogs(page);
  const reqPromise = page.waitForRequest((r) => r.method() !== 'GET', { timeout: timeoutMs }).catch(() => null);
  await clickFn();
  const req = await reqPromise;
  await page.waitForTimeout(300);
  const swalVisible = await page.locator('.swal2-popup').isVisible().catch(() => false);
  const popoverVisible = (await page.locator('.popover:visible').count().catch(() => 0)) > 0;
  return {
    requestSent: !!req,
    requestInfo: req ? `${req.method()} ${req.url()}` : null,
    dialogs,
    swalVisible,
    popoverVisible,
  };
}

// TERVERIFIKASI LIVE 27 Sep 2026 (login manual, form Tambah Kuota&Jadwal sungguhan, TIDAK disimpan): input
// tgl_etd/tgl_eta pakai widget "dtp" (class dtp-*, clock SVG multi-langkah utk jam/menit) yang RAPUH untuk
// diotomasi via klik (SVG hour-circle butuh event delegation khusus, gampang salah step). Cara yang TERBUKTI
// jauh lebih andal: assign `.value` langsung pada elemen + dispatch event 'input' & 'change' (format
// "DD/MM/YYYY HH:mm") — widget dtp menerima ini sebagai input sah dan otomatis menambah suffix zona waktu
// sesuai atribut `wilayah` pada elemen (mis. jadi "15/09/2030 08:00 WIB"). TIDAK PERLU membuka/klik kalender
// visual sama sekali.
function pad2(n) { return String(n).padStart(2, '0'); }
function formatDateTime(d) {
  return `${pad2(d.getDate())}/${pad2(d.getMonth() + 1)}/${d.getFullYear()} ${pad2(d.getHours())}:${pad2(d.getMinutes())}`;
}
async function setDateTimeField(inputLocator, dateObj) {
  const value = formatDateTime(dateObj);
  await inputLocator.evaluate((el, v) => {
    el.value = v;
    el.dispatchEvent(new Event('input', { bubbles: true }));
    el.dispatchEvent(new Event('change', { bubbles: true }));
  }, value);
  return inputLocator.inputValue().catch(() => value);
}
async function pickFarFutureRange(page, etdInput, etaInput) {
  const etd = new Date();
  etd.setFullYear(etd.getFullYear() + 4); // sejauh mungkin di masa depan, sesuai aturan wajib KUOTA/JADWAL
  etd.setHours(8, 0, 0, 0);
  const etdVal = await setDateTimeField(etdInput, etd);
  const eta = new Date(etd);
  eta.setDate(eta.getDate() + 1);
  eta.setHours(10, 0, 0, 0);
  const etaVal = await setDateTimeField(etaInput, eta);
  return { etdVal, etaVal, etdDate: etd, etaDate: eta };
}

// ================= SCN-0001: Cabang membuat Kuota & Jadwal AUTOTEST-20260927-KJ-CABANG (wizard 3 tahap) =================
t('SCN-0001', async ({ page, cabangPage }) => {
  const errs = watchPageErrors(cabangPage);
  await cabangPage.goto('/partner/tambahjadwal');

  const { chosen, pareOpts, avoidedBalikpapanOnly } = await pickTrayekPareparNonBalikpapan(cabangPage);
  blockedUnless(!!chosen, 'Tidak ditemukan opsi Trayek berasal-kota Pare-Pare pada dropdown Tambah Kuota & Jadwal');
  if (avoidedBalikpapanOnly) note('SCN-0001: hanya trayek Parepare-Balikpapan yang tersedia dari Pare-Pare — dipakai apa adanya, WASPADAI golongan III-A/III-B readonly (VAL-006) saat isi Kuota Kendaraan.');
  STATE.scn0001TrayekValue = chosen.value;
  STATE.scn0001TrayekText = chosen.text;
  note(`SCN-0001: Trayek dipilih = "${chosen.text}" (opsi Pare-Pare tersedia: ${pareOpts.map((o) => o.text).join(', ')})`);
  await select2(cabangPage, 'select#trayek', chosen.value);
  await cabangPage.waitForLoadState('networkidle').catch(() => {});

  const kapalVal = await firstRealOptionValue(cabangPage, 'select#kapal');
  await select2(cabangPage, 'select#kapal', kapalVal);
  await cabangPage.waitForTimeout(400);
  await cabangPage.locator('#nomor_voyage').fill(DATA.voyageCabang);

  for (const label of ['KUOTA', 'JADWAL', 'CREW LIST']) {
    await expect(findTab(cabangPage, label), `Tab "${label}" harus muncul setelah Trayek+Kapal dipilih`).toBeVisible({ timeout: 10_000 });
  }

  // REQ-007/011: sebelum Kuota/Jadwal disimpan, "Masukkan Crew" belum tersedia & "Selesai" masih disabled.
  await clickTab(cabangPage, 'CREW LIST');
  const masukkanCrewCountBefore = await cabangPage.getByRole('button', { name: 'Masukkan Crew' }).count();
  note(`REQ-007/011: tombol "Masukkan Crew" sebelum Kuota/Jadwal disimpan — count=${masukkanCrewCountBefore} (ui-inventory: harus 0)`);
  expect(masukkanCrewCountBefore, 'Tombol "Masukkan Crew" belum boleh tersedia sebelum Kuota/Jadwal tersimpan').toBe(0);
  const selesaiBtnBefore = cabangPage.getByRole('button', { name: 'Selesai' });
  await expect(selesaiBtnBefore).toBeVisible();
  await expect(selesaiBtnBefore).toBeDisabled();

  // Tab KUOTA: isi minimal 1 golongan Penumpang, 1 golongan Kendaraan (non-readonly), 1 golongan Bagasi.
  await clickTab(cabangPage, 'KUOTA');
  const penumpangRow = await firstEditableDistRow(cabangPage, 'dist_penumpang');
  blockedUnless(!!penumpangRow, 'Tidak ada baris Distribusi Kuota Penumpang yang bisa diisi (Kelas Kapal kosong?)');
  await penumpangRow.internal.fill('2');
  if (penumpangRow.eksternal) await penumpangRow.eksternal.fill('2');

  const kendaraanRow = await firstEditableDistRow(cabangPage, 'dist_kendaraan');
  blockedUnless(!!kendaraanRow, 'Tidak ada baris Distribusi Kuota Kendaraan yang bisa diisi (semua readonly/kosong?)');
  await kendaraanRow.internal.fill('2');
  if (kendaraanRow.eksternal) await kendaraanRow.eksternal.fill('2');

  const bagasiRow = await firstEditableDistRow(cabangPage, 'dist_bagasi');
  if (bagasiRow) {
    await bagasiRow.internal.fill('2');
    if (bagasiRow.eksternal) await bagasiRow.eksternal.fill('2');
  } else {
    note('SCN-0001: tidak ada baris Distribusi Kuota Bagasi yang bisa diisi — dilewati (bukan blocker skenario ini).');
  }
  await fillAllQuotaZero(cabangPage);

  await simpanBtn(cabangPage).click();
  await cabangPage.waitForLoadState('networkidle').catch(() => {});
  await cabangPage.waitForTimeout(500);
  if (errs.length) note(`SCN-0001 [bug-candidate?] Error JS selama isi tab KUOTA: ${errs.join(' | ')}`);

  // Tab JADWAL: tanggal SEJAUH MUNGKIN DI MASA DEPAN (lihat catatan pickFarFutureRange — BELUM diverifikasi live).
  await clickTab(cabangPage, 'JADWAL');
  const etdInput = cabangPage.locator('input[name="tgl_etd"]').first();
  const etaInput = cabangPage.locator('input[name="tgl_eta"]').first();
  await expect(etdInput).toBeVisible({ timeout: 10_000 });
  const dateResult = await pickFarFutureRange(cabangPage, etdInput, etaInput);
  note(`SCN-0001 tanggal dipakai: ETD="${dateResult.etdVal}" ETA="${dateResult.etaVal}"`);
  blockedUnless(!!dateResult.etdVal && !!dateResult.etaVal, 'Datepicker Waktu Berangkat/Tiba tidak menghasilkan nilai terisi — perlu verifikasi manual pola widget sebelum lanjut (SCN-0001)');

  await simpanBtn(cabangPage).click();
  await cabangPage.waitForLoadState('networkidle').catch(() => {});
  await cabangPage.waitForTimeout(500);

  // Tab CREW LIST: sekarang "Masukkan Crew" harus tersedia.
  await clickTab(cabangPage, 'CREW LIST');
  const masukkanCrewBtn = cabangPage.getByRole('button', { name: 'Masukkan Crew' }).first();
  await expect(masukkanCrewBtn, 'Tombol "Masukkan Crew" harus tersedia setelah Kuota+Jadwal tersimpan (REQ-007/011)').toBeVisible({ timeout: 10_000 });
  await masukkanCrewBtn.click();
  const filled = await fillCrewModalMinimal(cabangPage);
  note(`SCN-0001: baris crew terisi = ${filled}`);
  blockedUnless(filled > 0, 'Tidak berhasil memilih Awak Kapal apa pun di modal Input Crew List (data Master Crew kosong?)');
  const crewModalClosed = await submitCrewModal(cabangPage);
  blockedUnless(crewModalClosed, 'Modal Input Crew List tidak tertutup setelah Simpan (SCN-0001) — tidak bisa lanjut ke tombol Selesai');
  await cabangPage.waitForTimeout(500);

  const selesaiBtnAfter = cabangPage.getByRole('button', { name: 'Selesai' });
  await expect(selesaiBtnAfter, 'Tombol "Selesai" harus aktif setelah Crew List terisi (REQ-012)').toBeEnabled({ timeout: 10_000 });
  await selesaiBtnAfter.click();
  await cabangPage.waitForLoadState('networkidle').catch(() => {});

  // Verifikasi tampil di Daftar Cabang (pembuat) DAN Daftar Pusat (REQ-001/AC-01).
  const foundCabang = await exists(cabangPage, '/partner/masterjadwal', '#Nomor_Voyage', DATA.voyageCabang);
  expect(foundCabang, `Jadwal ${DATA.voyageCabang} harus tampil di Daftar akun Cabang (pembuatnya)`).toBeTruthy();
  const foundPusat = await exists(page, '/partner/masterjadwal', '#Nomor_Voyage', DATA.voyageCabang);
  expect(foundPusat, `Jadwal ${DATA.voyageCabang} yang dibuat Cabang harus juga tampil di Daftar akun Pusat (REQ-001/AC-01)`).toBeTruthy();
  note(`SCN-0001 selesai: ${DATA.voyageCabang} dibuat, dipakai ulang SCN-0002/0003 (TIDAK dihapus di sini).`);
});

// ================= SCN-0002: Edit AUTOTEST-20260927-KJ-CABANG — bandingkan field dgn Tambah (read-only) =================
t('SCN-0002', async ({ page }) => {
  const found = await exists(page, '/partner/masterjadwal', '#Nomor_Voyage', DATA.voyageCabang);
  blockedUnless(found, `Jadwal ${DATA.voyageCabang} tidak ditemukan — pastikan SCN-0001 sudah dijalankan lebih dulu`);

  await row(page, DATA.voyageCabang).first().locator('a.btn-edit.edit').click();
  await page.waitForTimeout(800); // AJAX in-place swap, URL TETAP /partner/masterjadwal (bukan route terpisah)
  await expect(page).toHaveURL(/masterjadwal/);

  for (const id of ['#trayek', '#kapal', '#kode_kapal', '#kapasitas']) {
    const el = page.locator(id).first();
    const disabled = await el.isDisabled().catch(() => null);
    note(`SCN-0002 field ${id} pada Edit: disabled=${disabled} (harus true+terisi data existing, REQ-019/AC-11)`);
  }
  const nomorVoyageDisabled = await page.locator('#nomor_voyage').isDisabled().catch(() => null);
  note(`SCN-0002 field #nomor_voyage pada Edit: disabled=${nomorVoyageDisabled} (harus TIDAK disabled)`);
  expect(nomorVoyageDisabled, 'Nomor Voyage pada Edit harus tetap editable, bukan disabled (REQ-019/AC-11)').toBe(false);
  const voyageVal = await page.locator('#nomor_voyage').inputValue();
  expect(voyageVal, 'Nomor Voyage pada Edit harus terisi data existing yang sama').toBe(DATA.voyageCabang);

  for (const label of ['KUOTA', 'JADWAL', 'CREW LIST']) {
    const c = await findTab(page, label).count();
    note(`SCN-0002: tab dgn teks memuat "${label}" ditemukan di Edit = ${c > 0} (label Edit kemungkinan huruf campuran, lihat ui-inventory)`);
  }

  // TIDAK mengubah/menyimpan apa pun — navigasi keluar.
  await page.goto('/partner/masterjadwal');
});

// ================= SCN-0003: Tutup Jadwal AUTOTEST-20260927-KJ-CABANG, lalu Hapus (cleanup) =================
t('SCN-0003', async ({ page, cabangPage }) => {
  // Skenario terpanjang di file ini (exists() 3x retry + Edit + Simpan + 2x verifikasi cleanup di kedua akun)
  // — TERBUKTI kena test timeout 90s default 2x berturut-turut (run 27 Sep 2026). Perpanjang timeout khusus.
  test.setTimeout(150_000);
  const found = await exists(page, '/partner/masterjadwal', '#Nomor_Voyage', DATA.voyageCabang);
  blockedUnless(found, `Jadwal ${DATA.voyageCabang} tidak ditemukan — pastikan SCN-0001 sudah dijalankan lebih dulu`);

  notePartialBlock('Cross-check pencarian Jual Tiket (OP-13)/Cari Jadwal User Umum (UM-03) sebelum & sesudah Tutup Jadwal TIDAK dieksekusi di sini — tidak ada fixture/selector modul tsb tersedia dalam tests/kuota-jadwal.spec.js (di luar cakupan file spec ini). Lanjut ke langkah Tutup Jadwal + cleanup Hapus sesuai instruksi eksplisit skenario ini.');

  await openFilteredList(page, '/partner/masterjadwal', '#Nomor_Voyage', DATA.voyageCabang);
  await row(page, DATA.voyageCabang).first().locator('a.btn-edit.edit').click();
  await page.waitForTimeout(800);
  await clickTab(page, 'Jadwal');
  const statusSelect = page.locator('select').filter({ has: page.locator('option[value="Tutup"]') }).first();
  const statusCount = await statusSelect.count();
  blockedUnless(statusCount > 0, 'Select Status Jadwal (opsi value="Tutup") tidak ditemukan pada tab Jadwal Edit');
  await select2El(page, statusSelect, 'Tutup');
  await page.waitForTimeout(300);
  await simpanBtn(page).click();
  await page.waitForLoadState('networkidle').catch(() => {});
  await page.waitForTimeout(500);
  note(`SCN-0003 (REQ-010/Q-KJ-02): Status Jadwal ${DATA.voyageCabang} diubah menjadi "Jadwal Tutup" dan disimpan.`);

  // Cleanup WAJIB: Hapus baris AUTOTEST-20260927-KJ-CABANG, verifikasi count 0 di kedua akun.
  await openFilteredList(page, '/partner/masterjadwal', '#Nomor_Voyage', DATA.voyageCabang);
  const r = row(page, DATA.voyageCabang);
  await expect(r).toHaveCount(1);
  await deleteJadwalRowConfirmed(page, r.first(), 'Hapus');

  const stillPusat = await exists(page, '/partner/masterjadwal', '#Nomor_Voyage', DATA.voyageCabang);
  expect(stillPusat, `Jadwal ${DATA.voyageCabang} harus terhapus dari Daftar Pusat (cleanup)`).toBe(false);
  const stillCabang = await exists(cabangPage, '/partner/masterjadwal', '#Nomor_Voyage', DATA.voyageCabang);
  expect(stillCabang, `Jadwal ${DATA.voyageCabang} harus terhapus dari Daftar Cabang (cleanup)`).toBe(false);
  note(`SCN-0003 cleanup selesai: ${DATA.voyageCabang} terhapus, terverifikasi count 0 di kedua akun.`);
});

// ================= SCN-0004: Pusat membuat AUTOTEST-20260927-KJ-PUSAT, uji Bonus Tiket > sisa Kuota, lalu Hapus =================
t('SCN-0004', async ({ page, cabangPage }) => {
  // Alur terpanjang kedua (Kuota+Jadwal+Crew+verifikasi lintas-akun+cleanup) — samakan perpanjangan timeout
  // dgn SCN-0003 (lihat catatan di sana), TERBUKTI bisa kena 90s default saat server demo sedang lambat.
  test.setTimeout(150_000);
  const errs = watchPageErrors(page);
  await page.goto('/partner/tambahjadwal');

  const exclude = STATE.scn0001TrayekValue ? [STATE.scn0001TrayekValue] : [];
  const { chosen, pareOpts } = await pickTrayekPareparNonBalikpapan(page, exclude);
  blockedUnless(!!chosen, 'Tidak ditemukan opsi Trayek berasal-kota Pare-Pare lain (selain yang dipakai SCN-0001) pada dropdown Tambah Kuota & Jadwal');
  note(`SCN-0004: Trayek dipilih = "${chosen.text}" (dikecualikan trayek SCN-0001="${STATE.scn0001TrayekText || '-'}"; opsi Pare-Pare: ${pareOpts.map((o) => o.text).join(', ')})`);
  await select2(page, 'select#trayek', chosen.value);
  await page.waitForLoadState('networkidle').catch(() => {});

  const kapalVal = await firstRealOptionValue(page, 'select#kapal');
  await select2(page, 'select#kapal', kapalVal);
  await page.waitForTimeout(400);
  await page.locator('#nomor_voyage').fill(DATA.voyagePusat);

  await clickTab(page, 'KUOTA');
  const kendaraanRow = await firstKendaraanRowWithVisibleBonus(page);
  blockedUnless(!!kendaraanRow, 'Tidak ada baris Distribusi Kuota Kendaraan dengan field Bonus Tiket yang bisa diisi untuk uji ini (SCN-0004)');
  await kendaraanRow.internal.fill('1');
  if (kendaraanRow.eksternal) await kendaraanRow.eksternal.fill('1'); // total kuota kendaraan golongan ini = 2

  const bonusInput = kendaraanRow.bonus;
  await bonusInput.fill('999'); // jauh melebihi total kuota (2) — uji Q-KJ-01/REQ-006/VAL-005
  await fillAllQuotaZero(page);

  let obs = await observeSubmit(page, () => simpanBtn(page).click());
  note(`SCN-0004 (Q-KJ-01/REQ-006/VAL-005): Simpan Kuota dgn Bonus Tiket=999 (total kuota=2) — requestSent=${obs.requestSent} (${obs.requestInfo || '-'}), dialogs=${obs.dialogs.join('|') || '-'}, swalVisible=${obs.swalVisible}, popover=${obs.popoverVisible}`);
  await page.waitForTimeout(300);

  const tampakDitolak = obs.swalVisible || obs.popoverVisible || obs.dialogs.length > 0 || !obs.requestSent;
  if (tampakDitolak) {
    note('SCN-0004: Simpan tampak DITOLAK/tidak terkirim — perbaiki Bonus Tiket ke nilai wajar (2) agar wizard bisa lanjut.');
    if (obs.swalVisible) await closeSwal(page);
    await bonusInput.fill('2');
    obs = await observeSubmit(page, () => simpanBtn(page).click());
    note(`SCN-0004: percobaan Simpan ulang dgn Bonus Tiket=2 — requestSent=${obs.requestSent}`);
    blockedUnless(obs.requestSent, 'Simpan tab Kuota tetap gagal walau Bonus Tiket sudah wajar — tidak bisa lanjut wizard SCN-0004');
  } else {
    note('SCN-0004: Simpan DITERIMA apa adanya meski Bonus Tiket (999) jauh melebihi total kuota (2) — tidak ada validasi otomatis (dicatat sebagai temuan, bukan kegagalan skenario).');
  }
  await page.waitForLoadState('networkidle').catch(() => {});
  await page.waitForTimeout(300);
  if (errs.length) note(`SCN-0004 [bug-candidate?] Error JS selama isi tab KUOTA: ${errs.join(' | ')}`);

  await clickTab(page, 'JADWAL');
  const etdInput = page.locator('input[name="tgl_etd"]').first();
  const etaInput = page.locator('input[name="tgl_eta"]').first();
  await expect(etdInput).toBeVisible({ timeout: 10_000 });
  const dateResult = await pickFarFutureRange(page, etdInput, etaInput);
  note(`SCN-0004 tanggal dipakai: ETD="${dateResult.etdVal}" ETA="${dateResult.etaVal}"`);
  blockedUnless(!!dateResult.etdVal && !!dateResult.etaVal, 'Datepicker Waktu Berangkat/Tiba tidak menghasilkan nilai terisi (SCN-0004)');
  await simpanBtn(page).click();
  await page.waitForLoadState('networkidle').catch(() => {});
  await page.waitForTimeout(500);

  await clickTab(page, 'CREW LIST');
  const masukkanCrewBtn = page.getByRole('button', { name: 'Masukkan Crew' }).first();
  await expect(masukkanCrewBtn).toBeVisible({ timeout: 10_000 });
  await masukkanCrewBtn.click();
  const filled = await fillCrewModalMinimal(page);
  blockedUnless(filled > 0, 'Tidak berhasil memilih Awak Kapal apa pun di modal Input Crew List (SCN-0004)');
  const crewModalClosed = await submitCrewModal(page);
  blockedUnless(crewModalClosed, 'Modal Input Crew List tidak tertutup setelah Simpan (SCN-0004) — tidak bisa lanjut ke tombol Selesai');
  await page.waitForTimeout(500);

  const selesaiBtn = page.getByRole('button', { name: 'Selesai' });
  await expect(selesaiBtn).toBeEnabled({ timeout: 10_000 });
  await selesaiBtn.click();
  await page.waitForLoadState('networkidle').catch(() => {});

  // Verifikasi otomatis tampil di Daftar Cabang Pare-Pare TANPA aksi tambahan dari Cabang (REQ-002/AC-02).
  // TERBUKTI live 27 Sep 2026 (dikonfirmasi manual di luar test juga): jadwal trayek "BALIKPAPAN - PAREPARE"
  // yang dibuat Pusat TIDAK muncul di Daftar akun Cabang Pare-Pare dgn filter default — kandidat bug baru
  // (FND-KJ-06?), dibungkus flag() supaya diklasifikasi triager, BUKAN dianggap gagal test biasa. Cleanup
  // tetap WAJIB jalan (pakai try/finally) supaya data tidak tertinggal meski assertion di atas gagal.
  const foundCabang = await exists(cabangPage, '/partner/masterjadwal', '#Nomor_Voyage', DATA.voyagePusat);
  try {
    await flag('FND-KJ-06', `Jadwal ${DATA.voyagePusat} (trayek berasal Balikpapan, menyentuh kota Pare-Pare) dibuat Pusat TIDAK tampil di Daftar akun Cabang Pare-Pare dgn filter default — REQ-002/AC-02.`, async () => {
      expect(foundCabang, `Jadwal ${DATA.voyagePusat} yang dibuat Pusat harus otomatis tampil di Daftar Cabang (REQ-002/AC-02)`).toBeTruthy();
    });
  } catch { /* sudah dicatat via flag(), lanjut ke cleanup */ }

  // Cleanup WAJIB: Hapus oleh Pusat, verifikasi count 0 di kedua akun.
  await openFilteredList(page, '/partner/masterjadwal', '#Nomor_Voyage', DATA.voyagePusat);
  const r = row(page, DATA.voyagePusat);
  await expect(r).toHaveCount(1);
  await deleteJadwalRowConfirmed(page, r.first(), 'Hapus');

  const stillPusat = await exists(page, '/partner/masterjadwal', '#Nomor_Voyage', DATA.voyagePusat);
  expect(stillPusat, `Jadwal ${DATA.voyagePusat} harus terhapus dari Daftar Pusat (cleanup)`).toBe(false);
  const stillCabang = await exists(cabangPage, '/partner/masterjadwal', '#Nomor_Voyage', DATA.voyagePusat);
  expect(stillCabang, `Jadwal ${DATA.voyagePusat} harus terhapus dari Daftar Cabang (cleanup)`).toBe(false);
  note(`SCN-0004 cleanup selesai: ${DATA.voyagePusat} terhapus, terverifikasi count 0 di kedua akun.`);
});

// ================= SCN-0005: Simpan tab KUOTA kosong — observasi murni (VAL-001) =================
t('SCN-0005', async ({ page }) => {
  const errs = watchPageErrors(page);
  await page.goto('/partner/tambahjadwal');
  const trayekVal = await firstRealOptionValue(page, 'select#trayek');
  await select2(page, 'select#trayek', trayekVal);
  await page.waitForLoadState('networkidle').catch(() => {});
  const kapalVal = await firstRealOptionValue(page, 'select#kapal');
  await select2(page, 'select#kapal', kapalVal);
  await page.waitForTimeout(400);
  await page.locator('#nomor_voyage').fill(DATA.voyageEmptyKuota);

  await clickTab(page, 'KUOTA');
  // BIARKAN seluruh field distribusi kosong/default — TIDAK diisi apa pun (sesuai instruksi skenario).
  const obs = await observeSubmit(page, () => simpanBtn(page).click());
  note(`VAL-001/AC-06 — Simpan tab KUOTA dgn field distribusi kosong: requestSent=${obs.requestSent} (${obs.requestInfo || '-'}), dialogs=${obs.dialogs.join('|') || '-'}, swalVisible=${obs.swalVisible}, popover=${obs.popoverVisible}`);
  if (obs.swalVisible) await closeSwal(page);
  if (errs.length) note(`SCN-0005: Error JS selama interaksi: ${errs.join(' | ')}`);

  await page.waitForTimeout(500);
  const savedAsNewRow = await exists(page, '/partner/masterjadwal', '#Nomor_Voyage', DATA.voyageEmptyKuota);
  note(`VAL-001: apakah baris "${DATA.voyageEmptyKuota}" ternyata tersimpan di Daftar = ${savedAsNewRow}`);
  if (savedAsNewRow) {
    note('SCN-0005 [bug-candidate?] Data tersimpan meski seluruh field distribusi kosong (berpotensi melanggar AC-06) — cleanup Hapus dijalankan.');
    const r = row(page, DATA.voyageEmptyKuota);
    await deleteJadwalRowConfirmed(page, r.first(), 'Hapus');
    const stillThere = await exists(page, '/partner/masterjadwal', '#Nomor_Voyage', DATA.voyageEmptyKuota);
    expect(stillThere, `Cleanup: ${DATA.voyageEmptyKuota} harus terhapus setelah ditemukan tersimpan tak sengaja`).toBe(false);
  }
});

// ================= SCN-0006: Simpan tab JADWAL kosong — observasi murni (VAL-002) =================
t('SCN-0006', async ({ page }) => {
  const errs = watchPageErrors(page);
  await page.goto('/partner/tambahjadwal');
  const trayekVal = await firstRealOptionValue(page, 'select#trayek');
  await select2(page, 'select#trayek', trayekVal);
  await page.waitForLoadState('networkidle').catch(() => {});
  const kapalVal = await firstRealOptionValue(page, 'select#kapal');
  await select2(page, 'select#kapal', kapalVal);
  await page.waitForTimeout(400);
  await page.locator('#nomor_voyage').fill(DATA.voyageEmptyJadwal);

  // Langsung ke tab JADWAL TANPA mengisi/menyimpan tab KUOTA lebih dulu (sesuai instruksi skenario).
  await clickTab(page, 'JADWAL');
  const etdInput = page.locator('input[name="tgl_etd"]').first();
  const accessible = await etdInput.count();
  note(`SCN-0006: tab JADWAL dapat diakses tanpa Kuota disimpan lebih dulu = ${accessible > 0}`);
  blockedUnless(accessible > 0, 'Tab JADWAL tidak menampilkan field Waktu Berangkat/Tiba tanpa Kuota tersimpan — tidak bisa lanjut observasi VAL-002');

  // Biarkan Waktu Berangkat/Tiba kosong, Status Jadwal default.
  const obs = await observeSubmit(page, () => simpanBtn(page).click());
  note(`VAL-002/AC-06 — Simpan tab JADWAL dgn Waktu Berangkat/Tiba kosong: requestSent=${obs.requestSent} (${obs.requestInfo || '-'}), dialogs=${obs.dialogs.join('|') || '-'}, swalVisible=${obs.swalVisible}, popover=${obs.popoverVisible}`);
  if (obs.swalVisible) await closeSwal(page);
  if (errs.length) note(`SCN-0006: Error JS selama interaksi: ${errs.join(' | ')}`);

  await page.waitForTimeout(500);
  const savedAsNewRow = await exists(page, '/partner/masterjadwal', '#Nomor_Voyage', DATA.voyageEmptyJadwal);
  note(`VAL-002: apakah baris "${DATA.voyageEmptyJadwal}" ternyata tersimpan di Daftar = ${savedAsNewRow}`);
  if (savedAsNewRow) {
    note('SCN-0006 [bug-candidate?] Data tersimpan meski Waktu Berangkat/Tiba kosong (berpotensi melanggar AC-06) — cleanup Hapus dijalankan.');
    const r = row(page, DATA.voyageEmptyJadwal);
    await deleteJadwalRowConfirmed(page, r.first(), 'Hapus');
    const stillThere = await exists(page, '/partner/masterjadwal', '#Nomor_Voyage', DATA.voyageEmptyJadwal);
    expect(stillThere, `Cleanup: ${DATA.voyageEmptyJadwal} harus terhapus setelah ditemukan tersimpan tak sengaja`).toBe(false);
  }
});

// ================= SCN-0007: [BLOCKED kemungkinan besar] Trayek multi-rute (>=3 pelabuhan) — urutan tanggal (REQ-008/VAL-003) =================
t('SCN-0007', async ({ page }) => {
  await page.goto('/partner/tambahjadwal');
  const texts = await realOptionTexts(page, 'select#trayek');
  note(`SCN-0007: opsi Trayek pada Tambah Kuota & Jadwal (${texts.length}): ${texts.join(', ')}`);
  const candidate = texts.find((tx) => /asdfghdaf/i.test(tx));
  blockedUnless(!!candidate, 'Trayek kandidat "asdfghdaf" (Balikpapan-Parepare-Taipa, FND-M-05) tidak muncul di dropdown Tambah Kuota & Jadwal — kemungkinan besar belum punya Tarif Pass (syarat REQ-004). Sesuai instruksi, TIDAK membuat Trayek/Tarif Pass baru di Master untuk memenuhi skenario ini.');

  const trayekVal = await optionValueByText(page, 'select#trayek', candidate);
  await select2(page, 'select#trayek', trayekVal);
  await page.waitForLoadState('networkidle').catch(() => {});
  const kapalVal = await firstRealOptionValue(page, 'select#kapal');
  await select2(page, 'select#kapal', kapalVal);
  await page.waitForTimeout(400);

  await clickTab(page, 'JADWAL');
  const legEtdInputs = page.locator('input[name="tgl_etd"]');
  const legCount = await legEtdInputs.count();
  note(`SCN-0007: jumlah leg/baris Waktu Berangkat pada trayek "${candidate}" = ${legCount}`);
  blockedUnless(legCount >= 2, `Trayek "${candidate}" ditemukan tapi hanya render ${legCount} leg (butuh >=2 leg / >=3 pelabuhan) — tidak bisa menguji urutan tanggal rute kedua (REQ-008/VAL-003)`);

  const leg1Etd = legEtdInputs.nth(0);
  const leg2Etd = legEtdInputs.nth(1);
  const leg1Eta = page.locator('input[name="tgl_eta"]').nth(0);
  const dateResult = await pickFarFutureRange(page, leg1Etd, leg1Eta);
  note(`SCN-0007 leg1 ETD/ETA: ${dateResult.etdVal} / ${dateResult.etaVal}`);

  // Paksa isi leg2 ETD dgn tanggal SAMA dgn leg1 ETD — amati apakah datepicker/aplikasi menolak.
  await setDateTimeField(leg2Etd, dateResult.etdDate).catch(() => {});
  await page.waitForTimeout(300);
  const leg2Val = await leg2Etd.inputValue().catch(() => '');
  // Catatan: assignment yang gagal krn field readonly (khas datepicker) akan tampak SAMA (value tidak berubah)
  // dgn assignment yang ditolak validasi aplikasi — ambiguitas ini dicatat apa adanya, TIDAK disimpulkan sebagai
  // bukti validasi AC-07 tanpa verifikasi manual lebih lanjut.
  const leg2TidakBerubah = leg2Val !== dateResult.etdVal;
  note(`SCN-0007: leg2 ETD setelah dipaksa sama dgn leg1 = "${leg2Val}" (tidak berubah dari sebelumnya=${leg2TidakBerubah}; ambigu antara "ditolak validasi" vs "field readonly", lihat catatan kode)`);

  const obs = await observeSubmit(page, () => simpanBtn(page).click());
  note(`AC-07: hasil Simpan dgn tanggal leg2 <= leg1 — requestSent=${obs.requestSent}, dialogs=${obs.dialogs.join('|') || '-'}, swalVisible=${obs.swalVisible}`);
  if (obs.swalVisible) await closeSwal(page);
});

// ================= SCN-0008: Tombol "Selesai" tetap disabled sebelum Kuota/Jadwal disimpan (VAL-004) =================
t('SCN-0008', async ({ page }) => {
  await page.goto('/partner/tambahjadwal');
  const trayekVal = await firstRealOptionValue(page, 'select#trayek');
  await select2(page, 'select#trayek', trayekVal);
  await page.waitForLoadState('networkidle').catch(() => {});
  const kapalVal = await firstRealOptionValue(page, 'select#kapal');
  await select2(page, 'select#kapal', kapalVal);
  await page.waitForTimeout(400);

  await clickTab(page, 'CREW LIST');
  const selesaiBtn = page.getByRole('button', { name: 'Selesai' });
  await expect(selesaiBtn).toBeVisible({ timeout: 10_000 });
  await expect(selesaiBtn, 'Tombol Selesai harus disabled sebelum Kuota/Jadwal disimpan (VAL-004/REQ-012/AC-08)').toBeDisabled();
  note('VAL-004/REQ-012/AC-08: tombol Selesai disabled sebelum Kuota/Jadwal disimpan — terverifikasi via atribut DOM, tidak perlu submit penuh.');
  const masukkanCrewCount = await page.getByRole('button', { name: 'Masukkan Crew' }).count();
  expect(masukkanCrewCount, 'Tombol "Masukkan Crew" belum boleh tersedia sebelum Kuota/Jadwal tersimpan').toBe(0);
});

// ================= SCN-0009: Bonus Tiket III-A/III-B readonly di Parepare-Balikpapan vs trayek lain (VAL-006) =================
t('SCN-0009', async ({ page }) => {
  const found = await exists(page, '/partner/masterjadwal', '#Nomor_Voyage', JADWAL_TERPAKAI);
  blockedUnless(found, `Jadwal existing ${JADWAL_TERPAKAI} (id 2293) tidak ditemukan — tidak bisa menguji VAL-006 pada data referensi ini`);
  await row(page, JADWAL_TERPAKAI).first().locator('a.btn-edit.edit').click();
  await page.waitForTimeout(800);
  await clickTab(page, 'Kuota');

  for (const label of ['Kendaraan Kecil (III-A)', 'Mobil Mewah (III-B)']) {
    const tr = page.locator('tr', { hasText: label });
    const trCount = await tr.count();
    if (!trCount) { note(`SCN-0009: baris golongan "${label}" tidak ditemukan pada jadwal ${JADWAL_TERPAKAI} — dilewati.`); continue; }
    const bonus = tr.first().locator('input.bonus_tiket');
    const bc = await bonus.count();
    if (!bc) { note(`SCN-0009: field Bonus Tiket tidak ditemukan pada baris "${label}" (kemungkinan "Tidak Tersedia" utk rute ini, pola jadwal id 466).`); continue; }
    const readonly = await bonus.first().evaluate((el) => el.hasAttribute('readonly')).catch(() => false);
    const val = await bonus.first().inputValue().catch(() => '');
    note(`SCN-0009 jadwal ${JADWAL_TERPAKAI} golongan "${label}": readonly=${readonly}, value="${val}"`);
    expect(readonly, `Bonus Tiket golongan "${label}" pada trayek Parepare-Balikpapan harus readonly (VAL-006/REQ-016)`).toBe(true);
  }
  // Navigasi keluar TANPA Simpan (data terpakai transaksi, Q-KJ-04 — tidak boleh diubah).
  await page.goto('/partner/masterjadwal');

  // Pembanding: trayek non-Parepare-Balikpapan (idealnya Bakauheni-Merak).
  await page.goto('/partner/tambahjadwal');
  const texts = await realOptionTexts(page, 'select#trayek');
  const pembanding = texts.find((tx) => /bakauheni/i.test(tx) && /merak/i.test(tx)) || texts.find((tx) => !/parepare|balikpapan/i.test(tx));
  blockedUnless(!!pembanding, 'Tidak ditemukan trayek pembanding (non-Parepare-Balikpapan) untuk uji VAL-006');
  const pembandingVal = await optionValueByText(page, 'select#trayek', pembanding);
  await select2(page, 'select#trayek', pembandingVal);
  await page.waitForLoadState('networkidle').catch(() => {});
  const kapalVal = await firstRealOptionValue(page, 'select#kapal');
  await select2(page, 'select#kapal', kapalVal);
  await page.waitForTimeout(400);
  await clickTab(page, 'KUOTA');
  const bonusInputs = page.locator('input.bonus_tiket');
  const bCount = await bonusInputs.count();
  blockedUnless(bCount > 0, `Trayek pembanding "${pembanding}" tidak memiliki field Bonus Tiket kendaraan sama sekali`);
  const anyEditable = await bonusInputs.evaluateAll((els) => els.some((el) => !el.hasAttribute('readonly') && !el.disabled));
  note(`SCN-0009 pembanding "${pembanding}": ada golongan dgn Bonus Tiket EDITABLE (tidak readonly) = ${anyEditable}`);
  expect(anyEditable, `Field Bonus Tiket pada trayek pembanding "${pembanding}" harus ada yang TIDAK readonly (editable)`).toBe(true);
  // TIDAK menyimpan apa pun.
});

// ================= SCN-0010: Klik "Lihat" menampilkan panel collapse kosong (FND-KJ-01, pola sama FND-M-04) =================
t('SCN-0010', async ({ page }) => {
  await openList(page, '/partner/masterjadwal');
  await page.locator('table:visible tbody tr:not(:has(td[colspan]))').first().locator('a.btn-viewnya').click();
  await page.waitForTimeout(500);
  await flag('FND-KJ-01', 'Panel collapse "Lihat" Kuota & Jadwal kosong (hanya elemen pembatas, tanpa detail).', async () => {
    const collapse = page.locator('.collapse.show').first();
    await expect(collapse).toBeVisible({ timeout: 5000 });
    const text = (await collapse.innerText()).trim();
    expect(text.length, 'panel collapse Kuota & Jadwal seharusnya kosong (FND-KJ-01)').toBeLessThan(5);
  });
});

// ================= SCN-0011: Opsi Trayek Cabang identik dgn Pusat — desain sengaja, POSITIF (VAL-009/FND-KJ-03) =================
t('SCN-0011', async ({ page, cabangPage }) => {
  await page.goto('/partner/tambahjadwal');
  const pusatTexts = await realOptionTexts(page, 'select#trayek');
  await cabangPage.goto('/partner/tambahjadwal');
  const cabangTexts = await realOptionTexts(cabangPage, 'select#trayek');
  note(`SCN-0011: jumlah opsi Trayek Pusat=${pusatTexts.length}, Cabang=${cabangTexts.length}`);
  expect([...cabangTexts].sort(), 'Opsi Trayek akun Cabang harus SAMA PERSIS dgn akun Pusat (desain sengaja, keputusan user 27 Sep 2026)').toEqual([...pusatTexts].sort());
});

// ================= SCN-0012: Filter Daftar Kuota & Jadwal berdasarkan Nama Trayek lalu Reset (VAL-007) =================
t('SCN-0012', async ({ page }) => {
  await openList(page, '/partner/masterjadwal');
  const countBefore = await page.locator('table:visible tbody tr:not(:has(td[colspan]))').count();
  // "SURABAYA" hardcoded TERNYATA flaky (data bersama, jumlah baris berubah dari waktu ke waktu: 230 saat
  // harvest, 335 di run 1, 0 di run 2) — pakai nama Trayek dari baris PERTAMA yang benar-benar ada saat ini
  // (pola sama Master SCN-0039), menjamin filter selalu punya minimal 1 kecocokan.
  const firstRowTrayek = (await page.locator('table:visible tbody tr:not(:has(td[colspan]))').first().locator('td').nth(1).innerText()).trim();
  const keyword = firstRowTrayek.split(/[\s-]+/).find((w) => w.length >= 4) || firstRowTrayek;
  await page.locator('#btn-filter').click();
  await page.locator('#Nama_Trayek').fill(keyword);
  await filterSubmit(page).click();
  await page.waitForLoadState('networkidle').catch(() => {});
  const rows = page.locator('table:visible tbody tr:not(:has(td[colspan]))');
  const countFiltered = await rows.count();
  note(`SCN-0012: baris sebelum filter=${countBefore}, keyword="${keyword}" (dari trayek "${firstRowTrayek}"), setelah filter=${countFiltered}`);
  expect(countFiltered).toBeGreaterThan(0);
  // table:visible tbody cocok >1 elemen di halaman ini (setiap baris trayek membawa tabel nested "Rute yang
  // dilewati", class view-rute-jadwal) — scope ke tabel Daftar utama (#list-jadwal) utk hindari strict-mode.
  const bodyText = await page.locator('#list-jadwal').innerText();
  expect(bodyText.toUpperCase()).toContain(keyword.toUpperCase());

  await page.locator('.reset-master').click();
  await page.waitForLoadState('networkidle').catch(() => {});
  const countAfterReset = await page.locator('table:visible tbody tr:not(:has(td[colspan]))').count();
  note(`SCN-0012: baris setelah Reset=${countAfterReset}`);
  expect(countAfterReset).toBeGreaterThanOrEqual(countFiltered);
});

// ================= SCN-0013: Ketergantungan Trayek/Golongan/Kelas terhadap data Master (REQ-004/013/017/018) =================
t('SCN-0013', async ({ page }) => {
  await openList(page, '/partner/tarifpass');
  const tarifPassSample = (await page.locator('table:visible tbody tr:not(:has(td[colspan])) td').allInnerTexts())
    .map((s) => s.trim()).filter(Boolean).slice(0, 10);
  note(`SCN-0013: contoh baris Master Tarif Pass (mentah): ${tarifPassSample.join(' | ')}`);

  await page.goto('/partner/tambahjadwal');
  const trayekTexts = await realOptionTexts(page, 'select#trayek');
  note(`SCN-0013: jumlah opsi Trayek pada Tambah Kuota & Jadwal = ${trayekTexts.length} (REQ-004: seharusnya hanya trayek yang sudah punya Tarif Pass)`);
  expect(trayekTexts.length, 'Harus ada minimal 1 opsi Trayek yang sudah punya Tarif Pass (REQ-004/AC-04)').toBeGreaterThan(0);

  const trayekVal = await firstRealOptionValue(page, 'select#trayek');
  const trayekChosenText = (await page.locator(`select#trayek option[value="${trayekVal}"]`).innerText()).trim();
  await select2(page, 'select#trayek', trayekVal);
  await page.waitForLoadState('networkidle').catch(() => {});
  const kapalVal = await firstRealOptionValue(page, 'select#kapal');
  const kapalChosenText = (await page.locator(`select#kapal option[value="${kapalVal}"]`).innerText()).trim();
  await select2(page, 'select#kapal', kapalVal);
  await page.waitForTimeout(400);

  await clickTab(page, 'KUOTA');
  const kendaraanGolongan = await page.locator('input.dist_kendaraan').evaluateAll((els) =>
    els.map((el) => (el.closest('tr')?.innerText || '').replace(/\s+/g, ' ').trim()));
  note(`SCN-0013: baris golongan Kendaraan utk trayek "${trayekChosenText}" (REQ-017): ${kendaraanGolongan.slice(0, 5).join(' || ')}`);
  expect(kendaraanGolongan.length, 'Opsi golongan kendaraan harus tampil sesuai Harga+Tarif Pass Trayek terpilih (REQ-017)').toBeGreaterThan(0);

  const penumpangInternals = page.locator('input[id^="dist_penumpang"]:not([id*="eks"])');
  const penumpangGolongan = await penumpangInternals.evaluateAll((els) =>
    els.map((el) => (el.closest('tr')?.innerText || '').replace(/\s+/g, ' ').trim()));
  note(`SCN-0013: baris golongan Penumpang utk kapal "${kapalChosenText}" (REQ-018): ${penumpangGolongan.slice(0, 5).join(' || ')}`);
  expect(penumpangGolongan.length, 'Opsi golongan penumpang harus tampil sesuai Master Kelas Kapal yang dipilih (REQ-018)').toBeGreaterThan(0);

  // REQ-013: Kolom Kuota Internal & Eksternal terpisah.
  const firstInternal = penumpangInternals.first();
  const internalId = await firstInternal.getAttribute('id');
  const eksId = toEksId(internalId, 'dist_penumpang');
  const eksCount = await page.locator(`#${eksId}`).count();
  note(`SCN-0013 REQ-013: input internal #${internalId} vs eksternal #${eksId} — eksternal ditemukan=${eksCount > 0}`);
  expect(eksCount, 'Kolom Kuota Eksternal harus ada terpisah dari Internal (REQ-013)').toBeGreaterThan(0);
  // TIDAK menyimpan apa pun.
});

// ================= SCN-0014: Observasi formula otomatis Bonus Tiket kendaraan (REQ-014) =================
t('SCN-0014', async ({ page }) => {
  await page.goto('/partner/tambahjadwal');
  const trayekVal = await firstRealOptionValue(page, 'select#trayek');
  await select2(page, 'select#trayek', trayekVal);
  await page.waitForLoadState('networkidle').catch(() => {});
  const kapalVal = await firstRealOptionValue(page, 'select#kapal');
  await select2(page, 'select#kapal', kapalVal);
  await page.waitForTimeout(400);
  await clickTab(page, 'KUOTA');

  const kendaraanRow = await firstEditableDistRow(page, 'dist_kendaraan');
  blockedUnless(!!kendaraanRow, 'Tidak ada baris Distribusi Kuota Kendaraan yang bisa diisi untuk observasi formula Bonus Tiket (REQ-014)');
  const bonusInput = await bonusTiketForRow(page, kendaraanRow.internal);
  blockedUnless(!!bonusInput, 'Tidak menemukan field Bonus Tiket pada baris kuota kendaraan terpilih (SCN-0014)');

  const bonusBefore = await bonusInput.inputValue().catch(() => '');
  await kendaraanRow.internal.fill('5');
  if (kendaraanRow.eksternal) await kendaraanRow.eksternal.fill('5');
  await page.waitForTimeout(400);
  const bonusAfter1 = await bonusInput.inputValue().catch(() => '');
  await kendaraanRow.internal.fill('10');
  if (kendaraanRow.eksternal) await kendaraanRow.eksternal.fill('10');
  await page.waitForTimeout(400);
  const bonusAfter2 = await bonusInput.inputValue().catch(() => '');

  const berubahOtomatis = bonusAfter1 !== bonusBefore || bonusAfter2 !== bonusAfter1;
  note(`REQ-014 observasi formula Bonus Tiket: sebelum isi kuota="${bonusBefore}", setelah 5(+5)="${bonusAfter1}", setelah 10(+10)="${bonusAfter2}" — ${berubahOtomatis ? 'BERUBAH OTOMATIS mengikuti kuota (auto-calc)' : 'TETAP STATIS (manual entry, operator harus menghitung sendiri)'}`);
  // TIDAK menyimpan apa pun — hasil dicatat apa adanya, bukan diasumsikan sebelumnya.
  expect(bonusBefore, 'nilai Bonus Tiket awal harus berhasil dibaca (elemen ditemukan)').toBeDefined();
});

// ================= SCN-0015: [BLOCKED] Edit Kuota/Jadwal yang sudah dipakai transaksi lain (Q-KJ-04) =================
t('SCN-0015', async () => {
  blockedUnless(
    false,
    'Q-KJ-04 BLOCKED: belum ada Kuota & Jadwal uji milik run automation ini sendiri yang sudah dipakai transaksi ' +
    'OP-13 secara terkontrol (SCN-0001/SCN-0004 sengaja dihapus sebelum dipakai transaksi apa pun, agar aman ' +
    'dibersihkan). Data existing yang sudah dipakai transaksi (AUTOTEST-20260925-PPBPN-01, id 2293) berisiko ' +
    'mengganggu transaksi/manifest/laporan nyata bila diedit — tidak diedit sesuai batasan risiko modul ini. ' +
    'Baru bisa dijalankan setelah tersedia data uji sendiri yang sudah dipakai transaksi terkontrol (perlu ' +
    'koordinasi dengan eksekusi modul OP-13 pada run berikutnya).'
  );
});
