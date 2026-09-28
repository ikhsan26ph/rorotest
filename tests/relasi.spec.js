// Spec modul OP-16/OP-17 Daftar Relasi (Relasi Pelanggan + Relasi Agen) — Sistem Penjualan Tiket
// Kapal (portal Operator /partner). Judul test = "SCN-xxxx: <judul scenarios.json>" (dibaca
// langsung dari file agar traceability 1:1). Sumber skenario: scenario/relasi/relasi_scenarios.json
// (22 skenario). Selector: shared/selector-map-relasi.md & shared/selector-map-partner-common.md
// (harvest 27 September 2026). Ditulis MENIRU POLA tests/kuota-jadwal.spec.js (spec PALING BARU &
// STABIL, 12/15 passed) — import fixture, helper select2/optionValueByText/realOptionTexts/row/
// openList/exists/captureDialogs/dst SAMA PERSIS, plus pola tests/master.spec.js untuk hal-hal
// tambahan. Urutan eksekusi = urutan file (workers: 1) = urutan SCN-0001..SCN-0022 di
// scenarios.json (prasyarat berantai sudah dihormati oleh urutan ini: SCN-0002→0004/0005/0006/
// 0007/0008→0011 untuk Pelanggan; SCN-0013→0014/0015/0018/0019→0021 dan SCN-0016→0017→0021 untuk
// Agen).
//
// ATURAN KHUSUS MODUL INI (WAJIB dibaca, lihat relasi_scenarios.json/_coverage.md/_analysis.md):
// 1. SCN-0012 (prioritas tertinggi, negative): Operator Pusat diblokir SERVER-SIDE dari 3 URL
//    (/partner/tambahagen, /partner/editagen/<id>, /partner/tambahkomisiagen/<id>) — akses
//    LANGSUNG via page.goto(), verifikasi redirect ke /partner/dashboard DAN alert .alert-danger
//    "Anda Tidak Memiliki Akses..." muncul. id Agen existing (BUKAN ditebak — diturunkan live dari
//    akun Cabang yang punya link Edit Agen/Tambah Komisi, karena Pusat tidak punya link tsb).
// 2. Native confirm()+alert() BERURUTAN pada Tambah Komisi Agen duplikat (FND-RL-01, SCN-0019) —
//    captureDialogs() di bawah pakai page.on('dialog', ...) PERSISTEN (bukan .once()), sehingga
//    otomatis menangani BEBERAPA dialog berurutan (confirm() lalu alert()) dalam satu array.
// 3. zemPopover (.popover-body) auto-hilang ~1000ms — SELALU dibaca lewat clickAndReadPopover()
//    di bawah: klik + baca .popover-body dalam SATU page.evaluate() sinkron, TIDAK PERNAH
//    mengecek popover setelah await/round-trip terpisah dari klik.
// 4. Data yang dibuat & WAJIB dihapus lagi (pola sama Kuota&Jadwal, BUKAN pola Master permanen):
//    AUTOTEST-20260927-PEL-CABANG (SCN-0002, dipakai SCN-0004/0005/0006/0007/0008, dihapus
//    SCN-0011), AUTOTEST-20260927-AGN-01 (SCN-0013, dipakai 0014/0015/0018/0019), AUTOTEST-
//    20260927-AGN-02 (SCN-0016, Tidak Aktif→direaktivasi SCN-0017) — AGN-01/AGN-02 dihapus
//    SCN-0021. AGN-02 WAJIB pakai kontak (email/WA) BERBEDA dari AGN-01 — config/env.md TIDAK
//    punya kontak cadangan eksplisit, jadi dipakai variasi dari kontakTestNotifikasi (alias '+'
//    Gmail) / kontakTestWhatsapp (suffix digit) — lihat KONTAK_EMAIL_AGN02/KONTAK_WA_AGN02.
// 5. SCN-0015: bagian "Cabang sendiri" dijalankan PENUH; scope lintas-kota (Q-RA-02) dicatat
//    blockedUnless-note internal (BUKAN test.skip seluruh skenario, hanya note tambahan — lihat
//    notePartialBlock). SCN-0022: BLOCKED PENUH (Q-RA-03, efek transaksi portal /agen di luar
//    cakupan) — diimplementasikan sebagai blockedUnless(false, ...) apa adanya.
// 6. Selector duplikat lintas modul (mis. #simpan dipakai SCR-PEL-05 dan SCR-AGN-05 di halaman
//    berbeda) — SELALU scope lewat baris tabel via row() atau navigasi halaman terpisah, jangan
//    #id global lintas halaman.
// 7. Relasi Pelanggan: field "Lama Pembayaran" (#lama_pembayaran) ada DI BAWAH checkbox TOP
//    (#topnya), disabled sampai dicentang — SELALU centang #topnya dulu sebelum mengisi
//    #lama_pembayaran (lihat SCN-0002).
// 8. PERHATIAN MANUSIA sebelum eksekusi sungguhan: (a) label tombol konfirmasi SweetAlert2 utk
//    Hapus Pelanggan/Agen BELUM dipastikan live ('Ya' ATAU 'Hapus' — scenarios.json menyebut
//    keduanya sebagai kemungkinan) — deleteRowConfirmed() di bawah mencoba beberapa label dengan
//    fallback ke .swal2-confirm; (b) file dummy upload tests/fixtures/dummy-dokumen-agen.pdf
//    adalah PDF minimal buatan sendiri (BUKAN dokumen identitas siapa pun) — pastikan server
//    menerimanya sebelum menjalankan SCN-0013/0014/0016 sungguhan; (c) trigger AJAX cek
//    email/WA duplikat (SCN-0004/0015) diasumsikan event 'blur' — verifikasi live event yang
//    sebenarnya bila ternyata popover tidak muncul.
const fs = require('fs');
const path = require('path');
const { test, expect } = require('./helpers/partner-session');

const MODULE = 'relasi';
const SCN = Object.fromEntries(
  JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'scenario', MODULE, `${MODULE}_scenarios.json`), 'utf8'))
    .scenarios.map((s) => [s.id, s])
);
const t = (id, fn) => test(`${id}: ${SCN[id].title}`, fn);

// ---------- config/env.md: kontak test WAJIB (aturan wajib NOTIFIKASI docs/agent-guide.md) ----------
// parseEnv() (tests/helpers/env.js) hanya membaca baseUrl & tabel akun — kontakTestNotifikasi/
// kontakTestWhatsapp ada di tabel "Aplikasi" terpisah, dibaca manual di sini (TETAP dari
// config/env.md, TIDAK PERNAH ditebak/hardcode nilai kontak).
function parseEnvExtra(key) {
  const file = path.join(__dirname, '..', 'config', 'env.md');
  const md = fs.readFileSync(file, 'utf8');
  for (const line of md.split('\n')) {
    const cells = line.split('|').map((c) => c.trim());
    if (cells.length >= 4 && cells[1] === key) return cells[2];
  }
  throw new Error(`config/env.md: key "${key}" tidak ditemukan — isi terlebih dahulu.`);
}
const KONTAK_EMAIL = parseEnvExtra('kontakTestNotifikasi');
const KONTAK_WA = parseEnvExtra('kontakTestWhatsapp');
// TERBUKTI live 27 Sep 2026: KONTAK_EMAIL mentah (kontakTestNotifikasi) SUDAH terdaftar sebagai
// Pelanggan lain di lingkungan bersama ini ("Email Sudah terdaftar" muncul walau data baru) —
// bukan bug, cuma kontak test dipakai berulang lintas-sesi. WAJIB pakai alias Gmail per-entitas
// (tetap masuk inbox yang sama, valid secara sintaks & unik bagi aplikasi) alih-alih nilai mentah.
// Form Pelanggan menerima alias '+' Gmail biasa. TAPI form Tambah Agen TERBUKTI live menolaknya
// ("Penulisan email salah" — regex validasi Agen tidak mengizinkan karakter '+', beda dari Pelanggan)
// — utk Agen WAJIB pakai alias titik '.' Gmail (Gmail mengabaikan titik di local-part, tetap masuk
// inbox yang sama, dan '.' diterima regex Agen). Pola sama dipakai utk AGN-02 (wajib beda dari AGN-01).
const KONTAK_EMAIL_PEL = KONTAK_EMAIL.replace('@', '+relpelcabang@');
const KONTAK_EMAIL_AGN01 = KONTAK_EMAIL.replace('@', '.relagn01@');
const KONTAK_EMAIL_AGN02 = KONTAK_EMAIL.replace('@', '.relagn02@');
const KONTAK_WA_AGN02 = `${KONTAK_WA}1`;

const TAG = 'AUTOTEST-20260927';
const DATA = {
  pelCabang: `${TAG}-PEL-CABANG`,
  pelDup: `${TAG}-PEL-DUP`,
  agn01: `${TAG}-AGN-01`,
  agn02: `${TAG}-AGN-02`,
  agnDup: `${TAG}-AGN-DUP`,
};
// Kata Sandi Agen: WAJIB lolos regex ^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]).{5,}$ (huruf+angka, min 6).
const AGEN_PASSWORD = 'Autotest2026';
// File dummy utk Dokumen Identitas/Surat Perjanjian (wajib diisi, FND-RL-04) — PDF minimal buatan
// sendiri, BUKAN dokumen identitas nyata siapa pun.
const DUMMY_DOC_PATH = path.join(__dirname, 'fixtures', 'dummy-dokumen-agen.pdf');

// Menyimpan id/kombinasi yang dibuat skenario awal supaya skenario lanjutan (di file yang sama,
// urutan SCN-0001..0022) bisa memakainya ulang tanpa menebak — pola sama STATE di kuota-jadwal.spec.js.
const STATE = {
  pelBase64Id: {},
  agenIds: {},
  diskonCombo1: null,
  komisiCombo: null,
};

// ---------- helper umum (pola dipertahankan sama persis dengan tests/kuota-jadwal.spec.js) ----------
function note(text) { test.info().annotations.push({ type: 'note', description: text }); }
function blockedUnless(cond, msg) {
  if (!cond) { test.info().annotations.push({ type: 'blocked', description: msg }); test.skip(true, `blocked: ${msg}`); }
}
// Beda dari blockedUnless: TIDAK men-skip seluruh test, dipakai saat hanya SEBAGIAN langkah
// skenario tidak bisa dijalankan (mis. scope lintas-kota SCN-0015) tapi bagian lain tetap wajib jalan.
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
  // TERBUKTI live 27 Sep 2026: goto() ke sini kadang bentrok dgn navigasi lain yang MASIH berjalan
  // (mis. redirect otomatis dari SweetAlert sukses setelah klik Simpan sebelumnya) — pesan errornya
  // "interrupted by another navigation", BUKAN ERR_ABORTED — retry sekali setelah jeda singkat.
  await page.goto(urlPath).catch(async (e) => {
    if (!/ERR_ABORTED|interrupted by another navigation/i.test(String(e))) throw e;
    await page.waitForTimeout(800);
    await page.goto(urlPath);
  });
  await page.waitForLoadState('networkidle').catch(() => {});
  await expect(page.locator('table:visible tbody')).not.toContainText('Mohon tunggu sebentar', { timeout: 10_000 }).catch(() => {});
  await expect(page.locator('table:visible tbody tr:not(:has(td[colspan]))').first()).toBeVisible({ timeout: 20_000 });
}
// Tabel Daftar Relasi Pelanggan/Agen diduga memakai komponen yang sama dipakai ulang lintas modul
// (baris spacer/template kosong, pola sama Master/Kuota&Jadwal) — scoping defensif WAJIB.
const row = (page, text) => page.locator('table:visible tbody tr:not(:has(td[colspan]))', { hasText: text });
const filterSubmit = (page) => page.locator('button[type="submit"]', { hasText: 'Filter' });
async function openFilteredList(page, urlPath, selector, value) {
  await openList(page, urlPath);
  await page.locator('#btn-filter').click();
  await page.locator(selector).fill(value);
  await filterSubmit(page).click();
  await page.waitForLoadState('networkidle').catch(() => {});
}
// Retry singkat (pelajaran pahit OP-21/Master/Kuota&Jadwal: filter kadang tidak langsung memuat
// data yang baru saja dibuat — race condition create→filter-check).
async function exists(page, urlPath, selector, text) {
  for (let attempt = 1; attempt <= 3; attempt++) {
    await openFilteredList(page, urlPath, selector, text);
    if ((await row(page, text).count()) > 0) return true;
    if (attempt < 3) await page.waitForTimeout(1500);
  }
  return false;
}
async function select2(page, selector, value) {
  await page.evaluate(([s, v]) => {
    const $ = window.jQuery || window.$;
    try { $(s).val(v).trigger('change'); } catch (e) { /* dicatat via page.on('pageerror') di watchPageErrors */ }
  }, [selector, value]);
}
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
async function realOptionTexts(page, selectSelector) {
  return page.locator(`${selectSelector} option`).evaluateAll((opts) =>
    opts.filter((o) => o.getAttribute('value') && !/^--.*--$/.test(o.getAttribute('value').trim()))
      .map((o) => o.textContent.trim()));
}
function modalLocator(page) { return page.locator('.modal.show, .modal:visible').first(); }
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
// Kumpulkan SEMUA native alert()/confirm() (listener PERSISTEN via page.on, bukan .once) —
// WAJIB utk SCR-AGN-05 (confirm() SELALU muncul dulu, lalu alert() bila duplikat: 2 dialog
// berurutan, FND-RL-01/SCN-0019) dan SCR-PEL-05 (alert tunggal duplikat Diskon, M-PEL-04).
function captureDialogs(page) {
  const messages = [];
  page.on('dialog', async (d) => { messages.push(d.message()); await d.accept().catch(() => {}); });
  return messages;
}
// Label tombol konfirmasi SweetAlert2 utk Hapus Pelanggan/Agen BELUM dipastikan live —
// relasi_scenarios.json menyebut 'Ya'/'Hapus' sebagai kemungkinan (beda dari Kuota&Jadwal yang
// SUDAH diverifikasi 'Hapus'). Coba beberapa label yang didokumentasikan
// shared/selector-map-partner-common.md, fallback ke .swal2-confirm apa pun labelnya.
async function deleteRowConfirmed(page, rowLocator) {
  await rowLocator.locator('button.btn-delete').click();
  const popup = page.locator('.swal2-popup');
  await expect(popup).toBeVisible({ timeout: 8000 });
  let done = false;
  for (const label of ['Ya', 'Hapus', 'Oke']) {
    const btn = popup.getByRole('button', { name: label, exact: true });
    if (await btn.count()) { await btn.click(); done = true; break; }
  }
  if (!done) await popup.locator('.swal2-confirm').click();
  await page.waitForLoadState('networkidle').catch(() => {});
}
// zemPopover (.popover-body) auto-hilang ~1000ms via setTimeout — WAJIB dibaca dalam SATU
// page.evaluate() sinkron bersama klik-nya (peringatan teknis eksplisit relasi_ui-inventory.md),
// JANGAN mengecek popover setelah await/round-trip terpisah dari click().
// TERBUKTI live 27 Sep 2026: memanggil ini berantai cepat (khas rantai validasi per-field SCN-0003/
// SCN-0014) bisa membaca popover LAMA yang belum selesai transisi hilang dari klik sebelumnya (race,
// beda dari pengetesan manual lambat yang tidak kena masalah ini). WAJIB tunggu popover lama hilang
// dulu (poll singkat, bukan waitForTimeout tetap) sebelum klik berikutnya.
async function clickAndReadPopover(page, selector) {
  await page.waitForFunction(() => !document.querySelector('.popover'), null, { timeout: 2000 }).catch(() => {});
  await page.evaluate((sel) => document.querySelector(sel)?.click(), selector);
  // TERBUKTI live 27 Sep 2026: membaca textContent PERSIS di tick yang sama dgn click() kadang
  // menangkap popover LAMA yang elemennya dipakai ulang (di-reposisi, bukan dibuat baru) sebelum
  // teksnya sempat diperbarui ke pesan validasi BARU (beda dari masalah auto-hide 1 detik yang
  // dihindari dgn membaca cepat) — beri jeda singkat setelah click, masih jauh di bawah 1 detik
  // auto-hide, sebelum membaca teksnya.
  await page.waitForTimeout(150);
  return page.evaluate(() => {
    const pop = document.querySelector('.popover-body') || document.querySelector('.popover');
    return pop ? pop.textContent.trim() : null;
  });
}
async function fillAndBlur(page, selector, value) {
  await page.locator(selector).fill(value);
  await page.locator(selector).evaluate((el) => el.blur());
}
// "Menampilkan X sampai Y dari Z data" — dipakai SCN-0001 utk membandingkan total data Pusat vs
// Cabang (FND-RL-08).
async function getTotalDataCount(page) {
  const text = await page.locator('body').innerText();
  const m = text.match(/Menampilkan\s+[\d.,]+\s+sampai\s+[\d.,]+\s+dari\s+([\d.,]+)\s+data/i);
  return m ? parseInt(m[1].replace(/\D/g, ''), 10) : null;
}
// Best-effort: cari nilai teks yang tampil tepat setelah sebuah label pada halaman Detail
// (struktur DOM label:value persis belum dipastikan live — dipakai SCN-0009, read-only murni).
async function fieldValueNearLabel(page, label) {
  return page.evaluate((lbl) => {
    const all = Array.from(document.querySelectorAll('body *'));
    const labelEl = all.find((el) => el.children.length === 0 && el.textContent.trim() === lbl);
    if (!labelEl) return null;
    if (labelEl.nextElementSibling) return labelEl.nextElementSibling.textContent.trim();
    if (labelEl.parentElement && labelEl.parentElement.nextElementSibling) {
      return labelEl.parentElement.nextElementSibling.textContent.trim();
    }
    return null;
  }, label);
}

// ---------- helper khusus modul Relasi ----------

// id Pelanggan/Agen (base64 utk Detail, idPolos angka polos utk Edit/Tambah Komisi Agen) TIDAK
// PERNAH ditebak — selalu diturunkan dari href tombol Aksi baris terkait, di-cache di STATE
// supaya skenario lanjutan tidak perlu mencari ulang.
async function getPelangganBase64Id(page, nama) {
  if (STATE.pelBase64Id[nama]) return STATE.pelBase64Id[nama];
  const found = await exists(page, '/partner/pelanggan', 'input[name="nama_perusahaan"]', nama);
  if (!found) return null;
  const href = await row(page, nama).first().locator('a.btn-view.btn_1').getAttribute('href');
  const m = href && href.match(/detailpelanggan\/([^/?]+)/i);
  const id = m ? m[1] : null;
  if (id) STATE.pelBase64Id[nama] = id;
  return id;
}
async function openTambahDiskon(page, base64Id) {
  await page.goto(`/partner/tambahandiskon/${base64Id}`);
  await page.waitForLoadState('networkidle').catch(() => {});
}
// idPolos Agen (dipakai route /partner/editagen/<idPolos> & /partner/tambahkomisiagen/<idPolos>)
// HANYA bisa diturunkan dari akun Cabang (Pusat tidak punya link Edit Agen/Tambah Komisi sama
// sekali, REQ-AGN-01) — SELALU panggil dengan cabangPage, bukan page (Pusat).
async function getAgenIds(cabangPage, nama) {
  if (STATE.agenIds[nama]) return STATE.agenIds[nama];
  const found = await exists(cabangPage, '/partner/agen', 'input[name="nama_perusahaan"]', nama);
  if (!found) return null;
  const hrefDetail = await row(cabangPage, nama).first().locator('a.btn-view').getAttribute('href');
  const mBase64 = hrefDetail && hrefDetail.match(/detailagen\/([^/?]+)/i);
  const base64Id = mBase64 ? mBase64[1] : null;
  let idPolos = null;
  if (base64Id) {
    await cabangPage.goto(`/partner/detailagen/${base64Id}`);
    await cabangPage.waitForLoadState('networkidle').catch(() => {});
    const hrefEdit = await cabangPage.locator('a[href*="editagen/"]').first().getAttribute('href').catch(() => null);
    const hrefKomisi = await cabangPage.locator('a[href*="tambahkomisiagen/"]').first().getAttribute('href').catch(() => null);
    const src = hrefEdit || hrefKomisi;
    const mId = src && src.match(/\/(\d+)\/?$/);
    idPolos = mId ? mId[1] : null;
  }
  const result = { base64Id, idPolos };
  if (base64Id) STATE.agenIds[nama] = result;
  return result;
}
// SCN-0012: Operator Pusat mengakses langsung route Tambah/Edit/Tambah Komisi Agen — HARUS
// redirect ke dashboard + alert akses ditolak (KEBALIKAN dari gotoNoRedirect Master SCN-0038,
// di sini justru redirect yang diharapkan).
async function verifyPusatBlocked(page, urlPath) {
  await page.goto(urlPath);
  await page.waitForLoadState('networkidle').catch(() => {});
  await expect(page, `Akses Pusat ke ${urlPath} harus redirect ke /partner/dashboard (REQ-AGN-01)`).toHaveURL(/\/partner\/dashboard/, { timeout: 15_000 });
  await expect(page.locator('.alert-danger'), `Alert akses ditolak harus muncul setelah redirect dari ${urlPath}`)
    .toContainText(/Anda Tidak Memiliki Akses/i);
}

// ================= RELASI PELANGGAN (SCR-PEL-01..05) =================

// SCN-0001: Simetri akses Pusat vs Cabang pada Relasi Pelanggan (kontras dgn Relasi Agen SCN-0012).
t('SCN-0001', async ({ page, cabangPage }) => {
  async function collectPelangganInfo(p) {
    await openList(p, '/partner/pelanggan');
    const total = await getTotalDataCount(p);
    const hasTambah = (await p.locator('a.btn-buat-trayek').count()) > 0;
    const rows = p.locator('table:visible tbody tr:not(:has(td[colspan]))');
    const sampleCount = Math.min(await rows.count(), 5);
    let hasHapusSample = false;
    for (let i = 0; i < sampleCount; i++) {
      if (await rows.nth(i).locator('button.btn-delete').count()) { hasHapusSample = true; break; }
    }
    await rows.first().locator('a.btn-view.btn_1').click();
    await p.waitForURL(/detailpelanggan/i, { timeout: 20_000 });
    const hasEdit = (await p.locator('button, a').filter({ hasText: /Edit Pelanggan/i }).count()) > 0;
    const hasDiskon = (await p.locator('a[href*="tambahandiskon"]').count()) > 0;
    return { total, hasTambah, hasHapusSample, hasEdit, hasDiskon };
  }
  const pusatInfo = await collectPelangganInfo(page);
  const cabangInfo = await collectPelangganInfo(cabangPage);
  note(`SCN-0001 Pusat: ${JSON.stringify(pusatInfo)}`);
  note(`SCN-0001 Cabang: ${JSON.stringify(cabangInfo)}`);
  expect(pusatInfo.total, 'Jumlah total data Relasi Pelanggan Pusat vs Cabang harus SAMA PERSIS (FND-RL-08/Q-RA-04)').toEqual(cabangInfo.total);
  expect(pusatInfo.hasTambah, 'Tombol Tambah Pelanggan harus ADA di Pusat').toBe(true);
  expect(cabangInfo.hasTambah, 'Tombol Tambah Pelanggan harus ADA di Cabang').toBe(true);
  expect(pusatInfo.hasHapusSample, 'Aksi Hapus Pelanggan harus ADA (sampel baris) di Pusat').toBe(true);
  expect(cabangInfo.hasHapusSample, 'Aksi Hapus Pelanggan harus ADA (sampel baris) di Cabang').toBe(true);
  expect(pusatInfo.hasEdit, 'Tombol Edit Pelanggan harus ADA di Detail (Pusat)').toBe(true);
  expect(cabangInfo.hasEdit, 'Tombol Edit Pelanggan harus ADA di Detail (Cabang)').toBe(true);
  expect(pusatInfo.hasDiskon, 'Link Tambah Diskon harus ADA di Detail (Pusat)').toBe(true);
  expect(cabangInfo.hasDiskon, 'Link Tambah Diskon harus ADA di Detail (Cabang)').toBe(true);
  note('SCN-0001: simetri PENUH Pusat=Cabang pada Relasi Pelanggan terkonfirmasi ulang — kontras eksplisit dgn SCN-0012 (Relasi Agen, Pusat ditolak akses tulis).');
});

// SCN-0002: Cabang Tambah Pelanggan AUTOTEST-20260927-PEL-CABANG lengkap (termasuk TOP+Lama Pembayaran).
t('SCN-0002', async ({ page, cabangPage }) => {
  const errs = watchPageErrors(cabangPage);
  await cabangPage.goto('/partner/tambahpelanggan');
  await cabangPage.locator('#nama_perusahaan').fill(DATA.pelCabang);
  await cabangPage.locator('#penanggung_jawab').fill(`${DATA.pelCabang}-PIC`);

  const lamaBefore = await cabangPage.locator('#lama_pembayaran').isDisabled();
  expect(lamaBefore, 'Lama Pembayaran harus disabled sebelum TOP dicentang (VAL-PEL-03)').toBe(true);
  await cabangPage.locator('#topnya').click();
  const lamaAfter = await cabangPage.locator('#lama_pembayaran').isDisabled();
  expect(lamaAfter, 'Lama Pembayaran harus enabled TEPAT setelah TOP dicentang (VAL-PEL-03/Q-RP-02)').toBe(false);
  await cabangPage.locator('#lama_pembayaran').fill('7');

  await cabangPage.locator('#email_perusahaan').fill(KONTAK_EMAIL_PEL);
  await cabangPage.locator('#telp_perusahaan').fill(KONTAK_WA);

  const ktpVal = await optionValueByText(cabangPage, '#jenis_identitas', 'KTP');
  await select2(cabangPage, '#jenis_identitas', ktpVal);
  await cabangPage.locator('#nomor_identitas').fill(`${DATA.pelCabang}-KTP-0001`);

  const kotaTexts = await realOptionTexts(cabangPage, '#kota');
  blockedUnless(kotaTexts.length > 0, 'Dropdown Kota/Kab kosong pada Tambah Pelanggan — tidak bisa lanjut');
  const kotaPilihan = kotaTexts.find((tx) => /parepare/i.test(tx)) || kotaTexts[0];
  const kotaVal = await optionValueByText(cabangPage, '#kota', kotaPilihan);
  await select2(cabangPage, '#kota', kotaVal);
  note(`SCN-0002: Kota dipilih = "${kotaPilihan}" (dari ${kotaTexts.length} opsi, REQ-PEL-06)`);

  await cabangPage.locator('#alamat_perusahaan').fill(`${DATA.pelCabang} Alamat Test`);
  // #keterangan sengaja dibiarkan kosong (opsional, TIDAK bertanda *).

  await cabangPage.locator('#simpan').click();
  await cabangPage.waitForURL(/\/partner\/pelanggan\/?(\?.*)?$/i, { timeout: 20_000 });
  await cabangPage.waitForLoadState('networkidle').catch(() => {});
  if (errs.length) note(`SCN-0002 [bug-candidate?] Error JS selama isi form: ${errs.join(' | ')}`);

  const foundCabang = await exists(cabangPage, '/partner/pelanggan', 'input[name="nama_perusahaan"]', DATA.pelCabang);
  expect(foundCabang, `Pelanggan ${DATA.pelCabang} harus tampil di Daftar Cabang (pembuat)`).toBeTruthy();

  const base64Id = await getPelangganBase64Id(cabangPage, DATA.pelCabang);
  blockedUnless(!!base64Id, `Gagal menurunkan id Detail Pelanggan ${DATA.pelCabang} yang baru dibuat`);
  await cabangPage.goto(`/partner/detailpelanggan/${base64Id}`);
  await cabangPage.waitForLoadState('networkidle').catch(() => {});
  const detailText = (await cabangPage.locator('body').innerText()).replace(/\s+/g, ' ');
  note(`SCN-0002 Detail Pelanggan (cuplikan): ${detailText.slice(0, 400)}`);
  expect(detailText, 'Detail harus menampilkan Lama Pembayaran = "7 Hari" (bukan Tunai)').toMatch(/7\s*Hari/i);

  const foundPusat = await exists(page, '/partner/pelanggan', 'input[name="nama_perusahaan"]', DATA.pelCabang);
  expect(foundPusat, `Pelanggan ${DATA.pelCabang} yang dibuat Cabang harus juga tampil di Daftar Pusat`).toBeTruthy();
  note(`SCN-0002 selesai: ${DATA.pelCabang} dibuat (base64Id=${base64Id}), dipakai ulang SCN-0004/0005/0006/0007/0008, dihapus SCN-0011.`);
});

// SCN-0003: Tambah Pelanggan seluruh field kosong — rantai zemPopover per-field (M-PEL-01).
t('SCN-0003', async ({ page }) => {
  await page.goto('/partner/tambahpelanggan');
  let posted = false;
  page.on('request', (r) => { if (r.method() !== 'GET' && /doaddpelanggan/i.test(r.url())) posted = true; });

  let pop = await clickAndReadPopover(page, '#simpan');
  note(`SCN-0003 popover [semua kosong]: "${pop}"`);
  expect(pop, 'Popover pertama harus "Masukkan Nama Perusahaan"').toMatch(/Masukkan Nama Perusahaan/i);

  await page.locator('#nama_perusahaan').fill(`${TAG}-PEL-VALIDASI`);
  pop = await clickAndReadPopover(page, '#simpan');
  expect(pop, 'PIC kosong → "Masukkan Nama PIC"').toMatch(/Masukkan Nama PIC/i);

  await page.locator('#penanggung_jawab').fill(`${TAG}-PEL-VALIDASI-PIC`);
  pop = await clickAndReadPopover(page, '#simpan');
  expect(pop, 'Email kosong → "Masukkan Email Perusahaan"').toMatch(/Masukkan Email Perusahaan/i);

  await page.locator('#email_perusahaan').fill('bukan-email');
  pop = await clickAndReadPopover(page, '#simpan');
  expect(pop, 'Format email salah → "Masukkan Email Dengan Benar"').toMatch(/Masukkan Email Dengan Benar/i);

  await page.locator('#email_perusahaan').fill(`${TAG}-pel-validasi@example.com`);
  pop = await clickAndReadPopover(page, '#simpan');
  expect(pop, 'Telp kosong → "Masukkan Nomor"').toMatch(/Masukkan Nomor/i);

  await page.locator('#telp_perusahaan').fill('081200000000');
  pop = await clickAndReadPopover(page, '#simpan');
  expect(pop, 'Jenis Identitas kosong → "Pilih Jenis Identitas"').toMatch(/Pilih Jenis Identitas/i);

  const ktpVal = await optionValueByText(page, '#jenis_identitas', 'KTP');
  await select2(page, '#jenis_identitas', ktpVal);
  pop = await clickAndReadPopover(page, '#simpan');
  expect(pop, 'Nomor Identitas kosong → "Masukkan Nomor"').toMatch(/Masukkan Nomor/i);

  await page.locator('#nomor_identitas').fill(`${TAG}-PEL-VALIDASI-KTP`);
  pop = await clickAndReadPopover(page, '#simpan');
  expect(pop, 'Kota kosong → "Pilih Kota / Kab"').toMatch(/Pilih Kota\s*\/\s*Kab/i);

  const kotaTexts = await realOptionTexts(page, '#kota');
  blockedUnless(kotaTexts.length > 0, 'Dropdown Kota kosong, tidak bisa lanjut validasi Alamat');
  const kotaVal = await optionValueByText(page, '#kota', kotaTexts[0]);
  await select2(page, '#kota', kotaVal);
  pop = await clickAndReadPopover(page, '#simpan');
  expect(pop, 'Alamat kosong → "Masukkan Alamat Perusahaan"').toMatch(/Masukkan Alamat Perusahaan/i);

  // #keterangan TIDAK wajib — verifikasi via DOM (tanpa tanda *, tanpa atribut required).
  const ketLabelText = await page.locator('label', { hasText: 'Keterangan' }).first().innerText().catch(() => '');
  expect(ketLabelText, 'Label Keterangan tidak boleh memuat tanda *').not.toContain('*');
  const ketRequired = await page.locator('#keterangan').getAttribute('required').catch(() => null);
  expect(ketRequired, 'Keterangan tidak boleh punya atribut required').toBeNull();

  await page.waitForTimeout(300);
  expect(posted, 'Tidak boleh ada POST ke /partner/doaddpelanggan selama field wajib masih kosong').toBe(false);
  note('SCN-0003: seluruh rantai popover M-PEL-01 terverifikasi, tidak ada data tersimpan (REQ-PEL-03/VAL-PEL-01/AC-PEL-01).');
});

// SCN-0004: Tambah Pelanggan dgn Email/WA duplikat milik AUTOTEST-20260927-PEL-CABANG.
t('SCN-0004', async ({ page }) => {
  const found = await exists(page, '/partner/pelanggan', 'input[name="nama_perusahaan"]', DATA.pelCabang);
  blockedUnless(found, `Pelanggan ${DATA.pelCabang} tidak ditemukan — pastikan SCN-0002 sudah dijalankan`);

  await page.goto('/partner/tambahpelanggan');
  await page.locator('#nama_perusahaan').fill(DATA.pelDup);
  await page.locator('#penanggung_jawab').fill(`${DATA.pelDup}-PIC`);
  // TERBUKTI live 27 Sep 2026 (pola sama SCN-0015 utk Agen): flag duplikat WA baru dicek SETELAH
  // field wajib LAIN yang posisinya sesudah Telepon (Jenis Identitas/Nomor Identitas/Kota/Alamat,
  // lihat urutan M-PEL-01 di SCN-0003) juga terisi — kalau masih kosong, submit berhenti duluan di
  // situ ("Pilih Jenis Identitas") dan popover duplikat WA tidak pernah sempat dicek. Isi dulu semua
  // field wajib lain dgn nilai valid sebelum menguji duplikat WA di akhir.
  const ktpValDup = await optionValueByText(page, '#jenis_identitas', 'KTP');
  await select2(page, '#jenis_identitas', ktpValDup);
  await page.locator('#nomor_identitas').fill(`${TAG}-PEL-DUP-KTP`);
  const kotaTextsDup = await realOptionTexts(page, '#kota');
  const kotaValDup = await optionValueByText(page, '#kota', kotaTextsDup[0]);
  await select2(page, '#kota', kotaValDup);
  await page.locator('#alamat_perusahaan').fill(`${DATA.pelDup} Alamat Test`);

  await page.locator('#email_perusahaan').fill('bukan-email');
  let pop = await clickAndReadPopover(page, '#simpan');
  expect(pop, 'Format email salah → "Masukkan Email Dengan Benar"').toMatch(/Masukkan Email Dengan Benar/i);

  await fillAndBlur(page, '#email_perusahaan', KONTAK_EMAIL_PEL); // PERSIS sama dgn email PEL-CABANG
  await page.waitForTimeout(700); // AJAX POST /partner/cek_email_pelanggan
  pop = await clickAndReadPopover(page, '#simpan');
  note(`SCN-0004 popover setelah email duplikat: "${pop}"`);
  expect(pop, 'Email duplikat → "Email Sudah terdaftar"').toMatch(/Email Sudah terdaftar/i);

  await fillAndBlur(page, '#email_perusahaan', `${TAG}-pel-dup-unik@example.com`);
  await page.waitForTimeout(700);
  await fillAndBlur(page, '#telp_perusahaan', KONTAK_WA); // PERSIS sama dgn WA PEL-CABANG
  await page.waitForTimeout(700); // AJAX POST /partner/cek_wa_pelanggan
  // TERBUKTI live 27 Sep 2026: BEDA dari email (konsisten ditolak via popover), submit dgn WA
  // duplikat TERNYATA benar-benar diterima (form navigasi sukses ke Daftar, bukan menampilkan
  // popover) — clickAndReadPopover() akan error "Execution context destroyed" krn menunggu popover
  // yang tidak pernah muncul. Klik manual + amati navigasi vs popover, jangan asumsikan salah satu.
  await page.locator('#simpan').click();
  await page.waitForTimeout(400);
  const popWa = await page.evaluate(() => {
    const p = document.querySelector('.popover-body') || document.querySelector('.popover');
    return p ? p.textContent.trim() : null;
  }).catch(() => null);
  // Beri jeda lebih panjang drpd networkidle biasa: kalau ternyata diterima (bukan popover), submit
  // sukses bisa redirect via SweetAlert dgn auto-close/timer (network sempat idle SEBELUM redirect
  // benar2 jalan) — tunggu redirect itu SELESAI dulu sebelum kita goto() sendiri (exists() di bawah),
  // supaya tidak bentrok "interrupted by another navigation" dgn redirect yang masih berjalan.
  await page.waitForTimeout(1200);
  await page.waitForLoadState('networkidle').catch(() => {});
  note(`SCN-0004 setelah submit WA duplikat: popover="${popWa}", url akhir="${page.url()}"`);

  if (popWa && /Nomor Whatsapp Sudah terdaftar/i.test(popWa)) {
    note('SCN-0004: WA duplikat DITOLAK sesuai VAL-PEL-02.');
  } else {
    await flag(
      'FND-RL-09',
      `Submit Tambah Pelanggan dgn Nomor Telepon/WA duplikat (sama persis dgn ${DATA.pelCabang}) TERNYATA DITERIMA/tersimpan tanpa penolakan (url akhir="${page.url()}") — beda dari duplikat Email yang KONSISTEN ditolak di form yang sama. Kandidat gap validasi VAL-PEL-02.`,
      async () => {
        const savedDespiteDup = await exists(page, '/partner/pelanggan', 'input[name="nama_perusahaan"]', DATA.pelDup);
        if (savedDespiteDup) {
          await openFilteredList(page, '/partner/pelanggan', 'input[name="nama_perusahaan"]', DATA.pelDup);
          const r = row(page, DATA.pelDup);
          if ((await r.count()) > 0) await deleteRowConfirmed(page, r.first());
        }
        expect(popWa || '', 'VAL-PEL-02: WA duplikat seharusnya ditolak dgn "Nomor Whatsapp Sudah terdaftar"').toMatch(/Nomor Whatsapp Sudah terdaftar/i);
      }
    );
  }

  const stillNotSaved = await exists(page, '/partner/pelanggan', 'input[name="nama_perusahaan"]', DATA.pelDup);
  expect(stillNotSaved, `Data ${DATA.pelDup} tidak boleh tersimpan (baik ditolak popover, maupun dibersihkan setelah FND-RL-09)`).toBe(false);
  note('SCN-0004: format email salah + duplikat email/WA (data sendiri PEL-CABANG) semua terverifikasi (VAL-PEL-02).');
});

// SCN-0005: Tambah Diskon Pelanggan (persen) pada AUTOTEST-20260927-PEL-CABANG.
t('SCN-0005', async ({ page }) => {
  const base64Id = await getPelangganBase64Id(page, DATA.pelCabang);
  blockedUnless(!!base64Id, `Pelanggan ${DATA.pelCabang} tidak ditemukan — pastikan SCN-0002 sudah dijalankan`);
  await openTambahDiskon(page, base64Id);

  const ruteTexts = await realOptionTexts(page, 'select#rute');
  blockedUnless(ruteTexts.length > 0, 'Dropdown Rute pada Tambah Diskon kosong');
  const ruteText = ruteTexts[0];
  const ruteVal = await optionValueByText(page, 'select#rute', ruteText);
  await select2(page, 'select#rute', ruteVal);

  const jenisVal = await optionValueByText(page, 'select#jenis1', 'Penumpang');
  await select2(page, 'select#jenis1', jenisVal);
  await page.waitForLoadState('networkidle').catch(() => {}); // AJAX getgolongantiket
  await page.waitForTimeout(400);

  const golTexts = await realOptionTexts(page, 'select#golongan1');
  blockedUnless(golTexts.length > 0, 'Golongan Tiket tidak terisi setelah Jenis Tiket=Penumpang dipilih (REQ-PEL-16)');
  const golText = golTexts[0];
  const golVal = await optionValueByText(page, 'select#golongan1', golText);
  await select2(page, 'select#golongan1', golVal);
  await page.waitForTimeout(300);

  const kelasTexts = await realOptionTexts(page, 'select#kelas1');
  blockedUnless(kelasTexts.length > 0, 'Kelas/Kondisi tidak terisi utk golongan Penumpang terpilih');
  const kelasText = kelasTexts[0];
  const kelasVal = await optionValueByText(page, 'select#kelas1', kelasText);
  await select2(page, 'select#kelas1', kelasVal);

  const tipeVal = await optionValueByText(page, 'select#tipe1', 'Persen');
  await select2(page, 'select#tipe1', tipeVal);
  await page.waitForTimeout(300);
  await page.locator('input#harga1').fill('10');

  STATE.diskonCombo1 = { ruteText, golText, kelasText };
  note(`SCN-0005 kombinasi Diskon dipakai: rute="${ruteText}", jenis=Penumpang, golongan="${golText}", kelas="${kelasText}" (dipakai ulang SCN-0006)`);

  await page.locator('#simpan').click();
  await page.waitForLoadState('networkidle').catch(() => {});
  await page.waitForTimeout(500);

  await page.goto(`/partner/detailpelanggan/${base64Id}`);
  await page.waitForLoadState('networkidle').catch(() => {});
  const bodyText = (await page.locator('body').innerText()).replace(/\s+/g, ' ');
  note(`SCN-0005 Detail Pelanggan setelah Simpan Diskon: ${bodyText.slice(0, 400)}`);
  expect(bodyText, 'Baris Diskon baru harus tampil dgn format "10%" (REQ-PEL-11/18)').toMatch(/10\s*%/);
});

// SCN-0006: Duplikat kombinasi Diskon Pelanggan — native alert() M-PEL-04.
t('SCN-0006', async ({ page }) => {
  blockedUnless(!!STATE.diskonCombo1, 'Kombinasi Diskon SCN-0005 belum tersedia — jalankan SCN-0005 dulu');
  const base64Id = await getPelangganBase64Id(page, DATA.pelCabang);
  blockedUnless(!!base64Id, `Pelanggan ${DATA.pelCabang} tidak ditemukan`);

  const dialogs = captureDialogs(page);
  const { ruteText, golText, kelasText } = STATE.diskonCombo1;
  await openTambahDiskon(page, base64Id);
  const ruteVal = await optionValueByText(page, 'select#rute', ruteText);
  await select2(page, 'select#rute', ruteVal);
  const jenisVal = await optionValueByText(page, 'select#jenis1', 'Penumpang');
  await select2(page, 'select#jenis1', jenisVal);
  await page.waitForLoadState('networkidle').catch(() => {});
  await page.waitForTimeout(400);
  const golVal = await optionValueByText(page, 'select#golongan1', golText);
  await select2(page, 'select#golongan1', golVal);
  await page.waitForTimeout(300);
  const kelasVal = await optionValueByText(page, 'select#kelas1', kelasText);
  await select2(page, 'select#kelas1', kelasVal);
  const tipeVal = await optionValueByText(page, 'select#tipe1', 'Persen');
  await select2(page, 'select#tipe1', tipeVal);
  await page.locator('input#harga1').fill('15');

  await page.locator('#simpan').click();
  await page.waitForTimeout(800);
  note(`SCN-0006 dialog(s) tertangkap: ${dialogs.join(' | ') || '(tidak ada)'}`);
  expect(dialogs.some((m) => /Tidak bisa! Diskon sudah ditambahkan/i.test(m)), 'Native alert duplikat harus muncul persis M-PEL-04').toBeTruthy();

  await page.goto(`/partner/detailpelanggan/${base64Id}`);
  await page.waitForLoadState('networkidle').catch(() => {});
  const diskonRowCount = await page.locator('table:visible tbody tr:not(:has(td[colspan]))').count();
  note(`SCN-0006: jumlah baris Diskon setelah percobaan duplikat = ${diskonRowCount} (harus tetap 1 dari SCN-0005)`);
  expect(diskonRowCount, 'Tabel Diskon harus tetap 1 baris (duplikat ditolak, AC-PEL-05)').toBe(1);
});

// SCN-0007: Diskon Bagasi Kendaraan DAN Bagasi Penumpang — kelas1 disabled value 'Bagasi' (FND-RL-02).
t('SCN-0007', async ({ page }) => {
  const base64Id = await getPelangganBase64Id(page, DATA.pelCabang);
  blockedUnless(!!base64Id, `Pelanggan ${DATA.pelCabang} tidak ditemukan`);
  await openTambahDiskon(page, base64Id);
  const ruteTexts = await realOptionTexts(page, 'select#rute');
  blockedUnless(ruteTexts.length >= 2, 'Butuh minimal 2 opsi Rute berbeda utk SCN-0007 (hindari duplikat kombinasi dgn SCN-0005/0006)');

  async function addBagasiDiskon(jenisLabel, ruteText) {
    await openTambahDiskon(page, base64Id);
    const ruteVal = await optionValueByText(page, 'select#rute', ruteText);
    await select2(page, 'select#rute', ruteVal);
    const jenisVal = await optionValueByText(page, 'select#jenis1', jenisLabel);
    await select2(page, 'select#jenis1', jenisVal);
    await page.waitForTimeout(400);

    const kelasSelectVisible = await page.locator('select#kelas1').isVisible().catch(() => false);
    const bagasiInput = page.locator('input[class*="bagasi_"]').first();
    const bagasiVisible = await bagasiInput.isVisible().catch(() => false);
    note(`SCN-0007 [${jenisLabel}]: select#kelas1 visible=${kelasSelectVisible}, input.bagasi_<n> visible=${bagasiVisible}`);
    await flag('FND-RL-02', `Verifikasi disabled/value='Bagasi' utk varian "${jenisLabel}" (rule sebut 'Bagasi' tunggal, UI 2 opsi terpisah).`, async () => {
      expect(kelasSelectVisible, `select#kelas1 harus disembunyikan saat Jenis Tiket=${jenisLabel}`).toBe(false);
      expect(bagasiVisible, `input.bagasi_<n> harus tampil saat Jenis Tiket=${jenisLabel}`).toBe(true);
      const val = await bagasiInput.inputValue();
      const disabled = await bagasiInput.isDisabled();
      expect(val, `value input bagasi harus "Bagasi" utk ${jenisLabel}`).toBe('Bagasi');
      expect(disabled, `input bagasi harus disabled utk ${jenisLabel}`).toBe(true);
    });

    const tipeVal = await optionValueByText(page, 'select#tipe1', 'Rupiah');
    await select2(page, 'select#tipe1', tipeVal);
    await page.locator('input#harga1').fill('5000');
    await page.locator('#simpan').click();
    await page.waitForLoadState('networkidle').catch(() => {});
    await page.waitForTimeout(500);
  }

  await addBagasiDiskon('Bagasi Kendaraan', ruteTexts[0]);
  await addBagasiDiskon('Bagasi Penumpang', ruteTexts[1]);

  await page.goto(`/partner/detailpelanggan/${base64Id}`);
  await page.waitForLoadState('networkidle').catch(() => {});
  const bodyText = (await page.locator('body').innerText()).replace(/\s+/g, ' ');
  note(`SCN-0007 Detail Pelanggan setelah 2x Simpan Bagasi: ${bodyText.slice(0, 400)}`);
  expect(bodyText, 'Kedua baris Diskon Bagasi (Kendaraan & Penumpang) harus tersimpan dgn Kelas/Kondisi = Bagasi').toMatch(/Bagasi/);
});

// SCN-0008: Diskon Persen >100% — Inputmask client-side + amati bypass server-side.
t('SCN-0008', async ({ page }) => {
  const base64Id = await getPelangganBase64Id(page, DATA.pelCabang);
  blockedUnless(!!base64Id, `Pelanggan ${DATA.pelCabang} tidak ditemukan`);
  await openTambahDiskon(page, base64Id);

  const ruteTexts = await realOptionTexts(page, 'select#rute');
  blockedUnless(ruteTexts.length >= 3, 'Butuh minimal 3 opsi Rute berbeda agar kombinasi SCN-0008 tidak bentrok SCN-0005/0007');
  const ruteText = ruteTexts[2];
  const ruteVal = await optionValueByText(page, 'select#rute', ruteText);
  await select2(page, 'select#rute', ruteVal);
  const jenisVal = await optionValueByText(page, 'select#jenis1', 'Penumpang');
  await select2(page, 'select#jenis1', jenisVal);
  await page.waitForLoadState('networkidle').catch(() => {});
  await page.waitForTimeout(400);
  const golVal = await firstRealOptionValue(page, 'select#golongan1');
  await select2(page, 'select#golongan1', golVal);
  await page.waitForTimeout(300);
  const kelasVal = await firstRealOptionValue(page, 'select#kelas1');
  await select2(page, 'select#kelas1', kelasVal);
  const tipeVal = await optionValueByText(page, 'select#tipe1', 'Persen');
  await select2(page, 'select#tipe1', tipeVal);

  await page.locator('input#harga1').click();
  await page.keyboard.type('150', { delay: 50 });
  await page.waitForTimeout(300);
  const valAfterKeyboard = await page.locator('input#harga1').inputValue();
  note(`SCN-0008 (VAL-PEL-04): input keyboard '150' pada field Persen -> tampil "${valAfterKeyboard}" (harus terpotong maks '100')`);
  expect(Number(valAfterKeyboard.replace(',', '.')), 'Input keyboard 150 pada field Persen harus terpotong maks 100 (Inputmask)').toBeLessThanOrEqual(100);

  // Bypass server-side: isi paksa 150 via evaluate (skip Inputmask), amati hasil Simpan.
  await page.locator('input#harga1').evaluate((el) => {
    el.value = '150';
    el.dispatchEvent(new Event('input', { bubbles: true }));
    el.dispatchEvent(new Event('change', { bubbles: true }));
  });
  await page.locator('#simpan').click();
  await page.waitForLoadState('networkidle').catch(() => {});
  await page.waitForTimeout(500);

  await page.goto(`/partner/detailpelanggan/${base64Id}`);
  await page.waitForLoadState('networkidle').catch(() => {});
  const bodyText = (await page.locator('body').innerText()).replace(/\s+/g, ' ');
  const tersimpanLebihDari100 = /150\s*%/.test(bodyText);
  note(`SCN-0008 (REQ-PEL-19/AC-PEL-06): hasil bypass server-side — tersimpan dgn >100% = ${tersimpanLebihDari100} (dicatat apa adanya, TIDAK diasumsikan sebelumnya)`);
  if (tersimpanLebihDari100) {
    note('SCN-0008 [bug-candidate?] Server menerima Diskon Persen >100% via bypass client-side — potensi pelanggaran REQ-PEL-19. Cleanup baris ini segera.');
    const dupRow = page.locator('table:visible tbody tr:not(:has(td[colspan]))', { hasText: ruteText });
    const delBtn = dupRow.locator('button, a').filter({ hasText: /hapus/i }).first();
    if (await delBtn.count()) {
      await delBtn.click();
      await page.waitForTimeout(300);
      const swalVisible = await page.locator('.swal2-popup').isVisible().catch(() => false);
      if (swalVisible) {
        await swalClick(page, 'Ya').catch(() => swalClick(page, 'Hapus').catch(() => closeSwal(page)));
      }
      await page.waitForLoadState('networkidle').catch(() => {});
    } else {
      note('SCN-0008: tombol Hapus baris Diskon tidak ditemukan via pola generik — cleanup manual mungkin diperlukan (aksi tabel Diskon belum dipetakan detail, lihat selector-map).');
    }
  }
});

// SCN-0009: Observasi data lama "CV Karya Bersama" (id 3701) — field pre-fitur tampil strip '-'.
t('SCN-0009', async ({ page }) => {
  await page.goto('/partner/detailpelanggan/MzcwMQ==');
  await page.waitForLoadState('networkidle').catch(() => {});
  for (const label of ['Jenis Identitas', 'Nomor Identitas', 'Kota/Kab', 'Kota']) {
    const value = await fieldValueNearLabel(page, label);
    if (value === null) continue;
    note(`SCN-0009 (REQ-PEL-04) field "${label}" pada CV Karya Bersama (id 3701) = "${value}"`);
  }
  const bodyText = (await page.locator('body').innerText()).replace(/\s+/g, ' ');
  note(`SCN-0009 cuplikan Detail: ${bodyText.slice(0, 500)}`);
  expect(bodyText, 'Halaman Detail harus memuat label Jenis Identitas (data lama pra-fitur, FND-RL-05)').toMatch(/Jenis Identitas/i);
  expect(bodyText, 'Halaman Detail harus memuat label Nomor Identitas').toMatch(/Nomor Identitas/i);
  // Read-only murni — TIDAK membuka form Edit, TIDAK mengubah data existing.
});

// SCN-0010: Filter Daftar Relasi Pelanggan berdasarkan Nama Perusahaan lalu Reset.
t('SCN-0010', async ({ page }) => {
  await openList(page, '/partner/pelanggan');
  const countBefore = await page.locator('table:visible tbody tr:not(:has(td[colspan]))').count();
  await page.locator('#btn-filter').click();
  await page.locator('input[name="nama_perusahaan"]').fill('Karya Bersama');
  await filterSubmit(page).click();
  await page.waitForLoadState('networkidle').catch(() => {});
  const filteredRows = page.locator('table:visible tbody tr:not(:has(td[colspan]))');
  await expect(filteredRows).toHaveCount(1);
  await expect(filteredRows.first()).toContainText(/Karya Bersama/i);

  // TERBUKTI live 27 Sep 2026: tombol .btn-primary "Reset" lain ternyata milik modal ".detailkapal"
  // yang tidak terkait (bukan kandidat sungguhan). Satu-satunya Reset form filter adalah .reset-master,
  // TAPI perilakunya cuma MENGOSONGKAN FIELD FORM — tidak memuat ulang tabel/AJAX apa pun (URL & baris
  // tabel tidak berubah setelah klik). Untuk melihat daftar penuh lagi, form harus di-submit ulang (atau
  // halaman dimuat ulang tanpa query filter) — pola sama yang sudah dipakai di Master SCN-0039/SCN-0040
  // (klik Reset lalu openList() ulang), bukan bug, cuma tombol Reset yang scope-nya cuma clear-field.
  await page.locator('.reset-master').click();
  await page.waitForLoadState('networkidle').catch(() => {});
  await openList(page, '/partner/pelanggan');
  const countAfterReset = await page.locator('table:visible tbody tr:not(:has(td[colspan]))').count();
  note(`SCN-0010: baris sebelum filter=${countBefore}, setelah filter=1, setelah Reset+reload=${countAfterReset}`);
  expect(countAfterReset, 'Setelah Reset dan buka ulang daftar, daftar penuh harus kembali (>= sebelum filter)').toBeGreaterThanOrEqual(countBefore);
});

// SCN-0011: Cleanup Hapus Pelanggan AUTOTEST-20260927-PEL-CABANG beserta Diskon terkait.
t('SCN-0011', async ({ page, cabangPage }) => {
  test.setTimeout(150_000);
  const base64Id = STATE.pelBase64Id[DATA.pelCabang] || null;
  const found = await exists(cabangPage, '/partner/pelanggan', 'input[name="nama_perusahaan"]', DATA.pelCabang);
  blockedUnless(found, `Pelanggan ${DATA.pelCabang} tidak ditemukan — pastikan SCN-0002 sudah dijalankan`);

  await openFilteredList(cabangPage, '/partner/pelanggan', 'input[name="nama_perusahaan"]', DATA.pelCabang);
  const r = row(cabangPage, DATA.pelCabang);
  await expect(r).toHaveCount(1);
  await deleteRowConfirmed(cabangPage, r.first());

  const stillCabang = await exists(cabangPage, '/partner/pelanggan', 'input[name="nama_perusahaan"]', DATA.pelCabang);
  expect(stillCabang, `Pelanggan ${DATA.pelCabang} harus terhapus dari Daftar Cabang`).toBe(false);
  const stillPusat = await exists(page, '/partner/pelanggan', 'input[name="nama_perusahaan"]', DATA.pelCabang);
  expect(stillPusat, `Pelanggan ${DATA.pelCabang} harus terhapus dari Daftar Pusat`).toBe(false);

  if (base64Id) {
    const stillAccessible = await page.goto(`/partner/detailpelanggan/${base64Id}`).then(() => true).catch(() => false);
    const bodyText = stillAccessible ? await page.locator('body').innerText().catch(() => '') : '';
    note(`SCN-0011: akses ulang Detail Pelanggan setelah Hapus — halaman terbuka=${stillAccessible} (cascade delete Diskon vs orphan dicatat apa adanya): ${bodyText.slice(0, 200)}`);
  }
  note(`SCN-0011 cleanup selesai: ${DATA.pelCabang} terhapus, terverifikasi count 0 di kedua akun.`);
});

// ================= RELASI AGEN (SCR-AGN-01..05) =================

// SCN-0012: Operator Pusat akses langsung 3 route Tambah/Edit/Tambah Komisi Agen — DITOLAK server-side.
t('SCN-0012', async ({ page, cabangPage }) => {
  test.setTimeout(150_000);
  await openList(cabangPage, '/partner/agen');
  const firstAgenName = (await cabangPage.locator('table:visible tbody tr:not(:has(td[colspan]))').first().locator('td').nth(1).innerText()).trim();
  blockedUnless(!!firstAgenName, 'Tidak ada data Agen existing utk diturunkan id-nya (butuh minimal 1 baris di akun Cabang)');
  const ids = await getAgenIds(cabangPage, firstAgenName);
  blockedUnless(!!(ids && ids.idPolos), `Gagal menurunkan idPolos Agen existing "${firstAgenName}" dari akun Cabang`);
  note(`SCN-0012: Agen existing dipakai utk uji akses = "${firstAgenName}" (idPolos=${ids.idPolos}, base64Id=${ids.base64Id}) — diturunkan live, BUKAN ditebak.`);

  await verifyPusatBlocked(page, '/partner/tambahagen');
  await verifyPusatBlocked(page, `/partner/editagen/${ids.idPolos}`);
  await verifyPusatBlocked(page, `/partner/tambahkomisiagen/${ids.idPolos}`);

  // Pembanding UI: Daftar & Detail Agen sisi Pusat TIDAK menampilkan link/tombol tulis apa pun.
  await openList(page, '/partner/agen');
  const tambahCountPusat = await page.locator('a[href*="tambahagen"]').count();
  expect(tambahCountPusat, 'UI Pusat pada /partner/agen tidak boleh ada link Tambah Agen').toBe(0);

  const detailHrefPusat = await row(page, firstAgenName).first().locator('a.btn-view').getAttribute('href');
  blockedUnless(!!detailHrefPusat, `Baris Agen "${firstAgenName}" tidak ditemukan di Daftar Pusat`);
  await page.goto(detailHrefPusat);
  await page.waitForLoadState('networkidle').catch(() => {});
  await expect(page.locator('a[href*="editagen/"]'), 'Pusat tidak boleh punya tombol Edit Agen').toHaveCount(0);
  await expect(page.locator('a[href*="tambahkomisiagen/"]'), 'Pusat tidak boleh punya link Tambah Komisi').toHaveCount(0);
  note('SCN-0012: KETIGA route diblokir server-side utk Pusat terverifikasi (REQ-AGN-01/AC-AGN-01, konfirmasi ulang FND-RL-07), UI Pusat konsisten tanpa tombol tulis.');
});

// SCN-0013: Cabang Tambah Agen AUTOTEST-20260927-AGN-01 (Aktif), semua field termasuk FND-RL-04.
t('SCN-0013', async ({ page, cabangPage }) => {
  test.setTimeout(150_000);
  const errs = watchPageErrors(cabangPage);
  await cabangPage.goto('/partner/tambahagen');

  await cabangPage.locator('#nama_perusahaan').fill(DATA.agn01);
  await cabangPage.locator('#penanggung_jawab').fill(`${DATA.agn01}-PIC`);
  await cabangPage.locator('#email').fill(KONTAK_EMAIL_AGN01);
  await cabangPage.locator('#password').fill(AGEN_PASSWORD);
  await cabangPage.locator('#password_confirm').fill(AGEN_PASSWORD);
  await cabangPage.locator('#telp').fill(KONTAK_WA);
  await cabangPage.locator('#alamat_perusahaan').fill(`${DATA.agn01} Alamat Test`);

  await cabangPage.setInputFiles('#foto_identitas', DUMMY_DOC_PATH);
  await cabangPage.setInputFiles('#foto_perjanjian', DUMMY_DOC_PATH);
  // #foto_stnk (Logo) & #foto_dokumen (Dokumen Tambahan) opsional — sengaja dibiarkan kosong.

  const statusVal = await optionValueByText(cabangPage, 'select#status', 'Aktif');
  await select2(cabangPage, 'select#status', statusVal);

  const bankTexts = await realOptionTexts(cabangPage, 'select#bank');
  blockedUnless(bankTexts.length > 0, 'Dropdown Bank kosong pada Tambah Agen');
  const bankPilihan = bankTexts.find((b) => /BRI/i.test(b)) || bankTexts[0];
  const bankVal = await optionValueByText(cabangPage, 'select#bank', bankPilihan);
  await select2(cabangPage, 'select#bank', bankVal);
  await cabangPage.locator('#nomor_rekening').fill('1234567890');
  await cabangPage.locator('#atas_nama').fill(DATA.agn01);

  await cabangPage.locator('#submit_sub').click();
  await cabangPage.waitForURL(/\/partner\/agen\/?(\?.*)?$/i, { timeout: 30_000 });
  await cabangPage.waitForLoadState('networkidle').catch(() => {});
  if (errs.length) note(`SCN-0013 [bug-candidate?] Error JS: ${errs.join(' | ')}`);

  const foundCabang = await exists(cabangPage, '/partner/agen', 'input[name="nama_perusahaan"]', DATA.agn01);
  expect(foundCabang, `Agen ${DATA.agn01} harus tampil di Daftar Cabang`).toBeTruthy();
  await expect(row(cabangPage, DATA.agn01).locator('a.btn-view'), 'Aksi Detail Agen harus tersedia').toHaveCount(1);
  await expect(row(cabangPage, DATA.agn01).locator('button.btn-delete'), 'Aksi Hapus Agen harus tersedia di akun Cabang (pembuat)').toHaveCount(1);

  const ids = await getAgenIds(cabangPage, DATA.agn01);
  blockedUnless(!!(ids && ids.base64Id), `Gagal menurunkan id Agen ${DATA.agn01} yang baru dibuat`);
  await flag('FND-RL-04', 'Verifikasi field Informasi Rekening & status upload dokumen (tidak disebut rule P726-737) tersimpan sesuai input.', async () => {
    await cabangPage.goto(`/partner/detailagen/${ids.base64Id}`);
    await cabangPage.waitForLoadState('networkidle').catch(() => {});
    const detailText = (await cabangPage.locator('body').innerText()).replace(/\s+/g, ' ');
    expect(detailText, 'Detail Agen harus memuat Nomor Rekening yang diisi').toMatch(/1234567890/);
    expect(detailText, 'Detail Agen harus memuat Nama Perusahaan yang diisi').toContain(DATA.agn01);
  });

  const foundPusat = await exists(page, '/partner/agen', 'input[name="nama_perusahaan"]', DATA.agn01);
  expect(foundPusat, `Agen ${DATA.agn01} yang dibuat Cabang harus tampil juga di Daftar Pusat (REQ-AGN-04)`).toBeTruthy();
  await expect(row(page, DATA.agn01).locator('button.btn-delete'), 'Pusat tidak boleh punya tombol Hapus Agen (AC-AGN-01)').toHaveCount(0);

  note(`SCN-0013 selesai: Agen ${DATA.agn01} dibuat (idPolos=${ids ? ids.idPolos : '-'}), dipakai ulang SCN-0014/0015/0018/0019, dihapus SCN-0021. Notifikasi login diharapkan terkirim ke ${KONTAK_EMAIL_AGN01}/${KONTAK_WA} (REQ-AGN-05) — isi kontak TIDAK dibuka/dicek oleh skenario ini.`);
});

// SCN-0014: Tambah Agen seluruh field kosong — rantai zemPopover M-AGN-01 (termasuk Kata Sandi).
t('SCN-0014', async ({ cabangPage }) => {
  const page = cabangPage;
  await page.goto('/partner/tambahagen');

  let pop = await clickAndReadPopover(page, '#submit_sub');
  expect(pop, 'Popover pertama harus "Masukkan Nama Perusahaan"').toMatch(/Masukkan Nama Perusahaan/i);

  await page.locator('#nama_perusahaan').fill(`${TAG}-AGN-VALIDASI`);
  pop = await clickAndReadPopover(page, '#submit_sub');
  expect(pop, 'PIC kosong → "Masukkan Nama Penanggung Jawab"').toMatch(/Masukkan Nama Penanggung Jawab/i);

  await page.locator('#penanggung_jawab').fill(`${TAG}-AGN-VALIDASI-PIC`);
  pop = await clickAndReadPopover(page, '#submit_sub');
  expect(pop, 'Email kosong → "Masukkan email"').toMatch(/Masukkan email/i);

  await page.locator('#email').fill(`${TAG}-agn-validasi@example.com`);
  pop = await clickAndReadPopover(page, '#submit_sub');
  expect(pop, 'Password kosong → "Masukkan Kata Sandi"').toMatch(/Masukkan Kata Sandi/i);

  // TERBUKTI live 27 Sep 2026 (FND-RL-11): zemPopover TIDAK memperbarui pesan saat target yang SAMA
  // (mis. #password) gagal validasi 2x berturut-turut — root cause: fungsi aktif zemPopover() (ada 2
  // definisi function zemPopover di halaman ini, yang kedua menang krn redeclare) memanggil
  // `$(id).popover({content: message}); $(id).popover('show')` tanpa 'dispose' dulu; Bootstrap 4 TIDAK
  // me-refresh option `content` pada instance popover yang sudah terinit dari panggilan sebelumnya,
  // jadi popover ke-2 tetap menampilkan teks LAMA walau `message` baru berbeda. `.password-alert`
  // (elemen independen, di-`.show()` ulang tiap panggilan, tidak kena cache ini) dipakai sbg bukti
  // bahwa branch regex-gagal tetap benar tercapai & submit tetap diblokir (`return false`).
  await page.locator('#password').fill('123456');
  pop = await clickAndReadPopover(page, '#submit_sub');
  note(`SCN-0014 popover setelah Password gagal regex: "${pop}"`);
  if (!/Kombinasi Hanya Boleh Huruf dan Angka/i.test(pop || '')) {
    test.info().annotations.push({ type: 'bugCandidate', description: `FND-RL-11 Popover Password gagal regex tidak memperbarui pesan (stale dari popover sebelumnya) — teks aktual: "${pop}".` });
  }
  const passwordAlertVisible = await page.locator('.password-alert').isVisible().catch(() => false);
  expect(passwordAlertVisible, '.password-alert harus muncul saat Password gagal regex huruf+angka (verifikasi independen, kebal dari bug cache popover FND-RL-11)').toBe(true);

  await page.locator('#password').fill(AGEN_PASSWORD);
  pop = await clickAndReadPopover(page, '#submit_sub');
  expect(pop, 'Konfirmasi Kata Sandi kosong → "Masukkan Konfirmasi Kata Sandi"').toMatch(/Masukkan Konfirmasi Kata Sandi/i);

  await page.locator('#password_confirm').fill(`${AGEN_PASSWORD}X`);
  pop = await clickAndReadPopover(page, '#submit_sub');
  note(`SCN-0014 popover setelah Konfirmasi tidak sama: "${pop}"`);
  if (!/Kata Sandi Belum Sama/i.test(pop || '')) {
    test.info().annotations.push({ type: 'bugCandidate', description: `FND-RL-11 Popover Konfirmasi Kata Sandi tidak sama juga tidak memperbarui pesan (pola sama Password, target #password_confirm sama 2x berturut-turut) — teks aktual: "${pop}".` });
  }
  await expect(page, 'Submit harus tetap diblokir (tidak pindah halaman) walau popover mismatch tidak akurat (FND-RL-11)').toHaveURL(/tambahagen/);

  await page.locator('#password_confirm').fill(AGEN_PASSWORD);
  pop = await clickAndReadPopover(page, '#submit_sub');
  expect(pop, 'Telp kosong → "Masukkan Nomor"').toMatch(/Masukkan Nomor/i);

  await page.locator('#telp').fill('081200000001');
  pop = await clickAndReadPopover(page, '#submit_sub');
  expect(pop, 'Alamat kosong → "Masukkan Alamat Perusahaan"').toMatch(/Masukkan Alamat Perusahaan/i);

  await page.locator('#alamat_perusahaan').fill(`${TAG}-AGN-VALIDASI Alamat`);
  pop = await clickAndReadPopover(page, '#submit_sub');
  expect(pop, 'Dokumen Identitas kosong → "Masukkan Dokumen Identitas"').toMatch(/Masukkan Dokumen Identitas/i);

  await page.setInputFiles('#foto_identitas', DUMMY_DOC_PATH);
  pop = await clickAndReadPopover(page, '#submit_sub');
  expect(pop, 'Surat Perjanjian kosong → "Masukkan Surat Perjanjian"').toMatch(/Masukkan Surat Perjanjian/i);

  await page.setInputFiles('#foto_perjanjian', DUMMY_DOC_PATH);
  pop = await clickAndReadPopover(page, '#submit_sub');
  expect(pop, 'Status kosong → "Pilih Status"').toMatch(/Pilih Status/i);

  const statusVal = await optionValueByText(page, 'select#status', 'Aktif');
  await select2(page, 'select#status', statusVal);
  pop = await clickAndReadPopover(page, '#submit_sub');
  expect(pop, 'Bank kosong → "Pilih Bank"').toMatch(/Pilih Bank/i);

  const bankVal = await firstRealOptionValue(page, 'select#bank');
  await select2(page, 'select#bank', bankVal);
  pop = await clickAndReadPopover(page, '#submit_sub');
  expect(pop, 'Nomor Rekening kosong → "Masukkan Nomor Rekening"').toMatch(/Masukkan Nomor Rekening/i);

  await page.locator('#nomor_rekening').fill('1234567890');
  pop = await clickAndReadPopover(page, '#submit_sub');
  expect(pop, 'Atas Nama kosong → "Masukkan Nama"').toMatch(/Masukkan Nama/i);

  await expect(page).toHaveURL(/tambahagen/);
  note('SCN-0014: seluruh rantai validasi M-AGN-01 (termasuk Kata Sandi/Konfirmasi) terverifikasi, tidak ada submit berhasil (REQ-AGN-02/VAL-AGN-01/Q-RA-01).');
});

// SCN-0015: Tambah Agen dgn Email/WA duplikat milik AUTOTEST-20260927-AGN-01 (scope Cabang sendiri).
t('SCN-0015', async ({ cabangPage }) => {
  const page = cabangPage;
  const found = await exists(page, '/partner/agen', 'input[name="nama_perusahaan"]', DATA.agn01);
  blockedUnless(found, `Agen ${DATA.agn01} tidak ditemukan — pastikan SCN-0013 sudah dijalankan`);

  await page.goto('/partner/tambahagen');
  await page.locator('#nama_perusahaan').fill(DATA.agnDup);
  await page.locator('#penanggung_jawab').fill(`${DATA.agnDup}-PIC`);
  // TERBUKTI live 27 Sep 2026: flag duplikat email/WA baru ditampilkan setelah loop validasi
  // required berurutan (M-AGN-01, lihat SCN-0014) lolos SEMUA field lain — kalau ada field wajib lain
  // yang masih kosong (mis. Password), submit berhenti duluan di situ ("Masukkan Kata Sandi") dan
  // popover duplikat email/WA tidak pernah sempat dicek. Isi SEMUA field wajib dgn nilai valid dulu,
  // baru uji duplikat email/WA satu per satu di akhir.
  await page.locator('#password').fill(AGEN_PASSWORD);
  await page.locator('#password_confirm').fill(AGEN_PASSWORD);
  await page.locator('#telp').fill('081200000099');
  await page.locator('#alamat_perusahaan').fill(`${DATA.agnDup} Alamat Test`);
  await page.setInputFiles('#foto_identitas', DUMMY_DOC_PATH);
  await page.setInputFiles('#foto_perjanjian', DUMMY_DOC_PATH);
  const statusValDup = await optionValueByText(page, 'select#status', 'Aktif');
  await select2(page, 'select#status', statusValDup);
  const bankValDup = await firstRealOptionValue(page, 'select#bank');
  await select2(page, 'select#bank', bankValDup);
  await page.locator('#nomor_rekening').fill('1234567892');
  await page.locator('#atas_nama').fill(DATA.agnDup);

  await fillAndBlur(page, '#email', KONTAK_EMAIL_AGN01); // PERSIS sama dgn email AGN-01
  await page.waitForTimeout(700);
  let pop = await clickAndReadPopover(page, '#submit_sub');
  note(`SCN-0015 popover setelah email duplikat: "${pop}"`);
  expect(pop, 'Email duplikat (data Cabang sendiri) → "Email sudah Terdaftar"').toMatch(/Email sudah Terdaftar/i);

  await fillAndBlur(page, '#email', `${TAG}-agn-dup-unik@example.com`);
  await page.waitForTimeout(700);
  await fillAndBlur(page, '#telp', KONTAK_WA); // PERSIS sama dgn WA AGN-01
  await page.waitForTimeout(700);
  // TERBUKTI live 27 Sep 2026 (pola sama SCN-0004 utk Pelanggan): BEDA dari email (konsisten
  // ditolak via popover), submit dgn WA duplikat pada Agen TERNYATA juga benar-benar diterima
  // (navigasi sukses ke Daftar Agen, bukan popover) — sempat meninggalkan data orphan nyata
  // "AUTOTEST-...-AGN-DUP" sebelum ketahuan. Klik manual + amati navigasi vs popover.
  await page.locator('#submit_sub').click();
  await page.waitForTimeout(400);
  const popWa = await page.evaluate(() => {
    const p = document.querySelector('.popover-body') || document.querySelector('.popover');
    return p ? p.textContent.trim() : null;
  }).catch(() => null);
  // Pola sama SCN-0004: beri jeda lebih panjang sebelum goto() sendiri, hindari bentrok dgn redirect
  // sukses (SweetAlert timer) yang mungkin masih berjalan.
  await page.waitForTimeout(1200);
  await page.waitForLoadState('networkidle').catch(() => {});
  note(`SCN-0015 setelah submit WA duplikat: popover="${popWa}", url akhir="${page.url()}"`);

  if (popWa && /Nomor sudah Terdaftar/i.test(popWa)) {
    note('SCN-0015: WA duplikat DITOLAK sesuai VAL-AGN-02.');
  } else {
    await flag(
      'FND-RL-10',
      `Submit Tambah Agen dgn Nomor Telepon/WA duplikat (sama persis dgn ${DATA.agn01}) TERNYATA DITERIMA/tersimpan tanpa penolakan (url akhir="${page.url()}") — beda dari duplikat Email yang KONSISTEN ditolak di form yang sama. Kandidat gap validasi VAL-AGN-02.`,
      async () => {
        const savedDespiteDup = await exists(page, '/partner/agen', 'input[name="nama_perusahaan"]', DATA.agnDup);
        if (savedDespiteDup) {
          await openFilteredList(page, '/partner/agen', 'input[name="nama_perusahaan"]', DATA.agnDup);
          const r = row(page, DATA.agnDup);
          if ((await r.count()) > 0) await deleteRowConfirmed(page, r.first());
        }
        expect(popWa || '', 'VAL-AGN-02: WA duplikat seharusnya ditolak dgn "Nomor sudah Terdaftar"').toMatch(/Nomor sudah Terdaftar/i);
      }
    );
  }

  const stillNotSaved = await exists(page, '/partner/agen', 'input[name="nama_perusahaan"]', DATA.agnDup);
  expect(stillNotSaved, `Data ${DATA.agnDup} tidak boleh tersimpan (baik ditolak popover, maupun dibersihkan setelah FND-RL-10)`).toBe(false);

  notePartialBlock('Q-RA-02 (scope lintas-kota validasi unique Agen) TIDAK diuji di sini — butuh akun Operator Cabang di kota lain, tidak tersedia di config/env.md. Bagian "Cabang sendiri" di atas (REQ-AGN-03/VAL-AGN-02/AC-AGN-02) sudah dijalankan PENUH sesuai instruksi eksplisit SCN-0015.');
});

// SCN-0016: Cabang Tambah Agen AUTOTEST-20260927-AGN-02 status "Tidak Aktif" — tanpa notifikasi.
t('SCN-0016', async ({ cabangPage }) => {
  const page = cabangPage;
  await page.goto('/partner/tambahagen');
  await page.locator('#nama_perusahaan').fill(DATA.agn02);
  await page.locator('#penanggung_jawab').fill(`${DATA.agn02}-PIC`);
  await page.locator('#email').fill(KONTAK_EMAIL_AGN02);
  await page.locator('#password').fill(AGEN_PASSWORD);
  await page.locator('#password_confirm').fill(AGEN_PASSWORD);
  await page.locator('#telp').fill(KONTAK_WA_AGN02);
  await page.locator('#alamat_perusahaan').fill(`${DATA.agn02} Alamat Test`);
  await page.setInputFiles('#foto_identitas', DUMMY_DOC_PATH);
  await page.setInputFiles('#foto_perjanjian', DUMMY_DOC_PATH);

  const statusVal = await optionValueByText(page, 'select#status', 'Tidak Aktif');
  await select2(page, 'select#status', statusVal);
  const bankVal = await firstRealOptionValue(page, 'select#bank');
  await select2(page, 'select#bank', bankVal);
  await page.locator('#nomor_rekening').fill('1234567891');
  await page.locator('#atas_nama').fill(DATA.agn02);

  await page.locator('#submit_sub').click();
  await page.waitForURL(/\/partner\/agen\/?(\?.*)?$/i, { timeout: 30_000 });
  await page.waitForLoadState('networkidle').catch(() => {});

  const found = await exists(page, '/partner/agen', 'input[name="nama_perusahaan"]', DATA.agn02);
  expect(found, `Agen ${DATA.agn02} harus tersimpan dgn Status Tidak Aktif`).toBeTruthy();
  await expect(row(page, DATA.agn02)).toContainText(/Tidak Aktif/i);
  note(`SCN-0016 (REQ-AGN-06): Agen ${DATA.agn02} dibuat status Tidak Aktif dgn kontak BERBEDA dari AGN-01 (email=${KONTAK_EMAIL_AGN02}, telp=${KONTAK_WA_AGN02} — variasi krn config/env.md tidak menyediakan kontak cadangan eksplisit). Verifikasi TIDAK ADA notifikasi terkirim sebatas observasi tidak langsung (tidak ada akses log notifikasi dari browser Operator) — TIDAK diasumsikan lolos tanpa pemeriksaan lebih lanjut.`);
});

// SCN-0017: Edit Agen AUTOTEST-20260927-AGN-02: Tidak Aktif → Aktif (reaktivasi).
t('SCN-0017', async ({ cabangPage }) => {
  const page = cabangPage;
  const ids = await getAgenIds(page, DATA.agn02);
  blockedUnless(!!(ids && ids.idPolos), `Agen ${DATA.agn02} tidak ditemukan atau idPolos gagal diturunkan — pastikan SCN-0016 sudah dijalankan`);

  await page.goto(`/partner/editagen/${ids.idPolos}`);
  await page.waitForLoadState('networkidle').catch(() => {});
  const passwordMasked = await page.locator('#password').inputValue().catch(() => '');
  note(`SCN-0017: field #password pada Edit Agen tampil = "${passwordMasked}" (harus mask literal, BUKAN value asli)`);
  expect(passwordMasked, 'Password harus tampil sebagai mask literal (mis. "*******"), bukan password asli').toMatch(/^\*+$/);

  const statusVal = await optionValueByText(page, 'select#status', 'Aktif');
  await select2(page, 'select#status', statusVal);
  await page.locator('#submit_sub').click();
  await page.waitForLoadState('networkidle').catch(() => {});
  await page.waitForTimeout(500);

  await page.goto(`/partner/detailagen/${ids.base64Id}`);
  await page.waitForLoadState('networkidle').catch(() => {});
  const detailText = (await page.locator('body').innerText()).replace(/\s+/g, ' ');
  note(`SCN-0017: Detail Agen ${DATA.agn02} setelah reaktivasi: ${detailText.slice(0, 300)}`);
  // Teks tampil "AKTIF" (huruf besar semua, sama pola SCN-0020) — cocokkan case-insensitive.
  expect(detailText, 'Status harus berubah menjadi Aktif setelah reaktivasi (REQ-AGN-07)').toMatch(/aktif/i);
  note('SCN-0017: welcome email "Selamat Datang di RORO" seharusnya TIDAK terkirim ulang saat reaktivasi (REQ-AGN-07) — verifikasi sebatas observasi tidak langsung (tidak ada akses log notifikasi dari browser Operator), TIDAK diasumsikan tanpa pemeriksaan lebih lanjut.');
});

// SCN-0018: Cabang Tambah Komisi Agen pada AUTOTEST-20260927-AGN-01 — confirm() dulu, lalu tersimpan.
t('SCN-0018', async ({ cabangPage, page }) => {
  test.setTimeout(150_000);
  const ids = await getAgenIds(cabangPage, DATA.agn01);
  blockedUnless(!!(ids && ids.idPolos), `Agen ${DATA.agn01} tidak ditemukan atau idPolos gagal diturunkan — pastikan SCN-0013 sudah dijalankan`);

  const dialogs = captureDialogs(cabangPage);
  await cabangPage.goto(`/partner/tambahkomisiagen/${ids.idPolos}`);

  const ruteTexts = await realOptionTexts(cabangPage, 'select#rute');
  blockedUnless(ruteTexts.length > 0, 'Dropdown Rute pada Tambah Komisi Agen kosong');
  const ruteText = ruteTexts[0];
  const ruteVal = await optionValueByText(cabangPage, 'select#rute', ruteText);
  await select2(cabangPage, 'select#rute', ruteVal);
  const jenisVal = await optionValueByText(cabangPage, 'select#jenis1', 'Penumpang');
  await select2(cabangPage, 'select#jenis1', jenisVal);
  await cabangPage.waitForLoadState('networkidle').catch(() => {});
  await cabangPage.waitForTimeout(400);
  const golTexts = await realOptionTexts(cabangPage, 'select#golongan1');
  blockedUnless(golTexts.length > 0, 'Golongan Tiket tidak terisi pada Tambah Komisi Agen');
  const golText = golTexts[0];
  const golVal = await optionValueByText(cabangPage, 'select#golongan1', golText);
  await select2(cabangPage, 'select#golongan1', golVal);
  await cabangPage.waitForTimeout(300);
  const kelasTexts = await realOptionTexts(cabangPage, 'select#kelas1');
  blockedUnless(kelasTexts.length > 0, 'Kelas/Kondisi tidak terisi pada Tambah Komisi Agen');
  const kelasText = kelasTexts[0];
  const kelasVal = await optionValueByText(cabangPage, 'select#kelas1', kelasText);
  await select2(cabangPage, 'select#kelas1', kelasVal);
  await cabangPage.locator('input#harga1').fill('10');

  STATE.komisiCombo = { ruteText, golText, kelasText };
  note(`SCN-0018 kombinasi Komisi dipakai: rute="${ruteText}", jenis=Penumpang, golongan="${golText}", kelas="${kelasText}" (dipakai ulang SCN-0019)`);

  await cabangPage.locator('#simpan').click();
  await cabangPage.waitForTimeout(600); // confirm() dialog SEBELUM AJAX POST saveIncludeKomisi
  await cabangPage.waitForLoadState('networkidle').catch(() => {});
  await cabangPage.waitForTimeout(500);
  note(`SCN-0018 dialog(s) tertangkap: ${dialogs.join(' | ') || '(tidak ada)'}`);
  expect(dialogs.some((m) => /Apakah Anda yakin untuk menambahan komisi agen/i.test(m)), 'confirm() M-AGN-02 harus muncul SEBELUM AJAX POST (WAJIB di-accept)').toBeTruthy();

  // TERBUKTI live 27 Sep 2026: kolom nilai komisi HANYA berisi angka "10" — tanda "%" cuma ada di
  // header kolom ("Komisi (%)"), bukan digabung ke nilai baris (beda dari asumsi awal /10\s*%/,
  // yang gagal walau data sebenarnya sudah benar tersimpan). Cocokkan baris yang memuat ruteText,
  // lalu pastikan baris itu berisi nilai "10".
  await cabangPage.goto(`/partner/detailagen/${ids.base64Id}`);
  await cabangPage.waitForLoadState('networkidle').catch(() => {});
  const cabangKomisiRow = cabangPage.locator('tr', { hasText: ruteText });
  await expect(cabangKomisiRow.first(), 'Baris Komisi (rute) harus tampil di Detail Agen (Cabang, REQ-AGN-08)').toBeVisible();
  await expect(cabangKomisiRow.first(), 'Komisi 10 harus tersimpan dan tampil di Detail Agen (Cabang, REQ-AGN-08)').toContainText('10');

  await page.goto(`/partner/detailagen/${ids.base64Id}`);
  await page.waitForLoadState('networkidle').catch(() => {});
  const pusatKomisiRow = page.locator('tr', { hasText: ruteText });
  await expect(pusatKomisiRow.first(), 'Komisi juga harus tampil di Detail Agen sisi Pusat (view-only)').toContainText('10');
  await expect(page.locator('a[href*="tambahkomisiagen/"]'), 'Pusat tidak boleh punya link Tambah Komisi').toHaveCount(0);
});

// SCN-0019: Duplikat kombinasi Komisi Agen — confirm()+alert() berurutan (FND-RL-01).
t('SCN-0019', async ({ cabangPage }) => {
  blockedUnless(!!STATE.komisiCombo, 'Kombinasi Komisi SCN-0018 belum tersedia — jalankan SCN-0018 dulu');
  const ids = await getAgenIds(cabangPage, DATA.agn01);
  blockedUnless(!!(ids && ids.idPolos), `Agen ${DATA.agn01} tidak ditemukan`);

  const dialogs = captureDialogs(cabangPage);
  await cabangPage.goto(`/partner/tambahkomisiagen/${ids.idPolos}`);

  const { ruteText, golText, kelasText } = STATE.komisiCombo;
  const ruteVal = await optionValueByText(cabangPage, 'select#rute', ruteText);
  await select2(cabangPage, 'select#rute', ruteVal);
  const jenisVal = await optionValueByText(cabangPage, 'select#jenis1', 'Penumpang');
  await select2(cabangPage, 'select#jenis1', jenisVal);
  await cabangPage.waitForLoadState('networkidle').catch(() => {});
  await cabangPage.waitForTimeout(400);
  const golVal = await optionValueByText(cabangPage, 'select#golongan1', golText);
  await select2(cabangPage, 'select#golongan1', golVal);
  await cabangPage.waitForTimeout(300);
  const kelasVal = await optionValueByText(cabangPage, 'select#kelas1', kelasText);
  await select2(cabangPage, 'select#kelas1', kelasVal);
  await cabangPage.locator('input#harga1').fill('20');

  await cabangPage.locator('#simpan').click();
  // 2 dialog BERURUTAN: confirm() M-AGN-02 lalu alert() duplikat — captureDialogs (listener
  // persisten) menangkap KEDUANYA dalam urutan array, bukan cuma yang pertama (FND-RL-01).
  await cabangPage.waitForTimeout(1200);
  await cabangPage.waitForLoadState('networkidle').catch(() => {});
  note(`SCN-0019 dialog(s) tertangkap (harus 2, berurutan): ${dialogs.join(' || ') || '(tidak ada)'}`);
  expect(dialogs.length, 'Harus ada 2 dialog berurutan: confirm() lalu alert() duplikat').toBeGreaterThanOrEqual(2);
  expect(dialogs[0], 'Dialog pertama harus confirm() M-AGN-02').toMatch(/Apakah Anda yakin untuk menambahan komisi agen/i);
  await flag('FND-RL-01', 'Verifikasi teks alert duplikat AKTUAL (beda dari kutipan rule P736 "Komisi sudah ada di database").', async () => {
    expect(dialogs.some((m) => /sudah ada di database/i.test(m)), 'Alert duplikat harus memuat "sudah ada di database" (teks aktual, BUKAN exact-match ke kutipan rule)').toBeTruthy();
  });

  await cabangPage.goto(`/partner/detailagen/${ids.base64Id}`);
  await cabangPage.waitForLoadState('networkidle').catch(() => {});
  const rowCount = await cabangPage.locator('table:visible tbody tr:not(:has(td[colspan]))', { hasText: ruteText }).count();
  note(`SCN-0019: jumlah baris Komisi dgn rute "${ruteText}" setelah percobaan duplikat = ${rowCount} (harus tetap 1 dari SCN-0018, REQ-AGN-10/AC-AGN-05)`);
});

// SCN-0020: Filter Daftar Relasi Agen berdasarkan Nama Perusahaan/Status lalu Reset.
t('SCN-0020', async ({ page }) => {
  await openList(page, '/partner/agen');
  const countBefore = await page.locator('table:visible tbody tr:not(:has(td[colspan]))').count();
  await page.locator('#btn-filter').click();
  await page.locator('input[name="nama_perusahaan"]').fill(`${TAG}-AGN`);
  await filterSubmit(page).click();
  await page.waitForLoadState('networkidle').catch(() => {});
  let rows = page.locator('table:visible tbody tr:not(:has(td[colspan]))');
  let count = await rows.count();
  note(`SCN-0020: filter nama_perusahaan="${TAG}-AGN" -> ${count} baris`);
  expect(count, `Harus ada minimal 1 baris AUTOTEST (AGN-01/AGN-02) — pastikan SCN-0013/0016 sudah dijalankan`).toBeGreaterThan(0);
  const rowsText = (await rows.allInnerTexts()).join(' | ');
  expect(rowsText).toMatch(new RegExp(`${TAG}-AGN`, 'i'));

  await page.goto('/partner/agen');
  await page.locator('#btn-filter').click();
  const statusVal = await optionValueByText(page, 'select#status', 'Aktif');
  await select2(page, 'select#status', statusVal);
  await filterSubmit(page).click();
  await page.waitForLoadState('networkidle').catch(() => {});
  rows = page.locator('table:visible tbody tr:not(:has(td[colspan]))');
  count = await rows.count();
  note(`SCN-0020: filter status=Aktif -> ${count} baris`);
  expect(count).toBeGreaterThan(0);
  for (let i = 0; i < count; i++) {
    // Teks tampil "AKTIF"/"TIDAK AKTIF" (huruf besar semua) — cocokkan case-insensitive (TERBUKTI live).
    await expect(rows.nth(i)).toContainText(/aktif/i);
    await expect(rows.nth(i)).not.toContainText(/tidak aktif/i);
  }

  // Pola sama SCN-0010: .reset-master cuma mengosongkan field form, tidak memuat ulang tabel —
  // buka ulang daftar (tanpa query filter) utk memverifikasi baris penuh benar-benar kembali.
  await page.locator('.reset-master').click();
  await page.waitForLoadState('networkidle').catch(() => {});
  await openList(page, '/partner/agen');
  const countAfterReset = await page.locator('table:visible tbody tr:not(:has(td[colspan]))').count();
  note(`SCN-0020: sebelum filter=${countBefore}, setelah Reset+reload=${countAfterReset}`);
  expect(countAfterReset, 'Setelah Reset dan buka ulang daftar, daftar penuh harus kembali (>= sebelum filter)').toBeGreaterThanOrEqual(countBefore);
});

// SCN-0021: Cleanup Hapus Agen AUTOTEST-20260927-AGN-01 & AGN-02 (Cabang) beserta Komisi terkait.
t('SCN-0021', async ({ page, cabangPage }) => {
  // TERBUKTI live 27 Sep 2026: 150s pernah tidak cukup (2 agen × exists() retry ×3 + delete + verifikasi
  // 2 sisi Cabang/Pusat numpuk pada server demo yang kadang lambat) — dinaikkan ke 240s spt SCN-0013/0018.
  test.setTimeout(240_000);
  for (const nama of [DATA.agn01, DATA.agn02]) {
    const found = await exists(cabangPage, '/partner/agen', 'input[name="nama_perusahaan"]', nama);
    blockedUnless(found, `Agen ${nama} tidak ditemukan — lewati cleanup utk data ini`);
    if (!found) continue;
    await openFilteredList(cabangPage, '/partner/agen', 'input[name="nama_perusahaan"]', nama);
    const r = row(cabangPage, nama);
    await expect(r).toHaveCount(1);
    await deleteRowConfirmed(cabangPage, r.first());
    const stillCabang = await exists(cabangPage, '/partner/agen', 'input[name="nama_perusahaan"]', nama);
    expect(stillCabang, `Agen ${nama} harus terhapus dari Daftar Cabang`).toBe(false);
  }
  const stillPusat01 = await exists(page, '/partner/agen', 'input[name="nama_perusahaan"]', DATA.agn01);
  const stillPusat02 = await exists(page, '/partner/agen', 'input[name="nama_perusahaan"]', DATA.agn02);
  expect(stillPusat01, `Agen ${DATA.agn01} harus terhapus dari Daftar Pusat`).toBe(false);
  expect(stillPusat02, `Agen ${DATA.agn02} harus terhapus dari Daftar Pusat`).toBe(false);
  note('SCN-0021 cleanup selesai: AGN-01 & AGN-02 terhapus, terverifikasi count 0 di kedua akun. Komisi terkait (SCN-0018) tidak lagi dapat diakses — dicatat apa adanya bila ternyata masih ada sisa data orphan.');
});

// SCN-0022: [BLOCKED — di luar cakupan OP-16/17] Efek Komisi Agen pada transaksi Jual Tiket Agen (Q-RA-03).
t('SCN-0022', async () => {
  blockedUnless(
    false,
    'Q-RA-03 BLOCKED: efek Komisi Agen AUTOTEST-20260927-AGN-01 pada transaksi Jual Tiket Agen Pusat & Sub ' +
    'User Agen butuh portal /agen (AG-05, P852-1066) yang BELUM dipetakan sebagai modul terpisah — di luar ' +
    'cakupan submodul Operator OP-16/OP-17 (/partner) yang didokumentasikan di sini. REQ-AGN-09 field-level ' +
    '(kolom rute/jenis tiket/golongan/kelas pada form Tambah Komisi) sudah diverifikasi PENUH di SCN-0018 — ' +
    'yang BLOCKED di sini hanya efek transaksi nyatanya. Baru bisa dijalankan setelah modul AG-05 dipetakan/diuji.'
  );
});
