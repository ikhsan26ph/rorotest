// Spec modul OP-11 Master — Sistem Penjualan Tiket Kapal (portal Operator /partner).
// Judul test = "SCN-xxxx: <judul scenarios.json>" (dibaca langsung dari file agar traceability 1:1).
// Sumber skenario: scenario/master/master_scenarios.json (40 skenario). Selector: shared/selector-map-master.md
// & shared/selector-map-partner-common.md (harvest 27 September 2026). Urutan eksekusi = urutan file (workers: 1),
// sama dengan urutan ID di scenarios.json (SCN-0001..SCN-0040) — urutan ini SUDAH menghormati prasyarat berantai
// (mis. SCN-0015 sebelum SCN-0017/0019/0021/0023), jadi TIDAK di-reorder seperti OP-21.
//
// ATURAN KHUSUS MODUL INI (BEDA dari OP-21 — lihat master_analysis.md/master_scenarios.json/master_coverage.md):
// 1. TIDAK ADA test cleanup di akhir file. Data Master adalah data referensi bersama; skenario yang datanya aman
//    dihapus (Golongan AUTOTEST SCN-0007, Informasi AUTOTEST SCN-0036/0037) membersihkan diri sendiri DI DALAM
//    test yang sama — bukan lewat test cleanup terpisah.
// 2. SCN-0015 (dan SCN-0017/0019 yang menumpuk di atasnya) membuat Trayek+Harga
//    "AUTOTEST-20260927-TRAYEK-AC04" yang SEKALI PAKAI — DATA PERMANEN, TIDAK BISA DIBERSIHKAN (REQ-014/015:
//    trayek yang sudah punya harga tidak bisa diedit/dihapus). Dijalankan APA ADANYA, tanpa logic penghapusan.
// 3. SCN-0030/0031/0032 (REQ-039/040/043, Setting Denda Pembatalan) HANYA memverifikasi tampilan form (field ada,
//    nilai saat ini) dan SELALU ditutup lewat tombol "Batal". Kode test di seluruh file ini TIDAK PERNAH dan TIDAK
//    BOLEH memanggil klik "Simpan" pada modal Setting Denda Pembatalan (SCR-25) — termasuk SCN-0026/0029/0033.
//    Menguji alert penolakan sungguhan (P533/P534/P538) butuh Simpan nyata pada setting tenant dan MEMBUTUHKAN IZIN
//    EKSPLISIT USER + catatan di shared/decisions.md — di luar cakupan spec otomatis ini.
// 4. SCN-0003 (Golongan dipakai Kapal), SCN-0020 (Harga dipakai Kuota&Jadwal), SCN-0024 (Tarif Pass dipakai
//    Kuota&Jadwal) butuh identifikasi data lintas modul yang di luar cakupan Master — ditandai blockedUnless(false)
//    apa adanya, tidak menebak/membuat data buatan.
const fs = require('fs');
const path = require('path');
const { test, expect } = require('./helpers/partner-session');

const MODULE = 'master';
const SCN = Object.fromEntries(
  JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'scenario', MODULE, `${MODULE}_scenarios.json`), 'utf8'))
    .scenarios.map((s) => [s.id, s])
);
const t = (id, fn) => test(`${id}: ${SCN[id].title}`, fn);

const TAG = 'AUTOTEST-20260927';
const DATA = {
  golUmum: `${TAG}-GOL-UMUM`,
  golCabang: `${TAG}-GOL-CABANG`,
  trayekAc04: `${TAG}-TRAYEK-AC04`,
  infoPusat: `${TAG}-INFO`,
  infoCabang: `${TAG}-INFO-CABANG`,
};

// ---------- helper (pola dipertahankan sama persis dengan tests/op-21-pengaturan-user.spec.js) ----------
function note(text) { test.info().annotations.push({ type: 'note', description: text }); }
function blockedUnless(cond, msg) {
  if (!cond) { test.info().annotations.push({ type: 'blocked', description: msg }); test.skip(true, `blocked: ${msg}`); }
}
async function flag(fnd, actualNote, fn) {
  try { await fn(); } catch (e) {
    test.info().annotations.push({ type: 'bugCandidate', description: `${fnd} ${actualNote}` });
    throw e;
  }
}
async function openList(page, urlPath) {
  await page.goto(urlPath);
  await page.waitForLoadState('networkidle').catch(() => {});
  // Tabel AJAX kadang masih menampilkan teks "Mohon tunggu sebentar" sesaat setelah networkidle — tunggu hilang
  // dulu sebelum baca isi tabel (race condition ditemukan di SCN-0008 run pertama, cf. race condition OP-21).
  await expect(page.locator('table:visible tbody')).not.toContainText('Mohon tunggu sebentar', { timeout: 10_000 }).catch(() => {});
  await expect(page.locator('table:visible tbody tr:not(:has(td[colspan]))').first()).toBeVisible({ timeout: 20_000 });
}
async function gotoNoRedirect(page, url) {
  await page.goto(url);
  await page.waitForLoadState('networkidle').catch(() => {});
  await expect(page).not.toHaveURL(/\/partner\/dashboard/);
  await expect(page.locator('.alert-danger')).toHaveCount(0);
}
// Ada tabel template tersembunyi di banyak halaman (pelajaran OP-21, dikonfirmasi ulang di master_analysis.md
// FND-M-06 gaya-duplikasi id) → selalu scoping ke tabel yang terlihat.
const row = (page, text) => page.locator('table:visible tbody tr:not(:has(td[colspan]))', { hasText: text });
const filterSubmit = (page) => page.locator('button[type="submit"]', { hasText: 'Filter' });
async function openFilteredList(page, urlPath, selector, value) {
  await openList(page, urlPath);
  await page.locator('#btn-filter').click();
  await page.locator(selector).fill(value);
  await filterSubmit(page).click();
  await page.waitForLoadState('networkidle').catch(() => {});
}
// Filter kadang tidak langsung memuat data yang baru saja dibuat (race condition create→filter-check,
// pelajaran pahit OP-21 run 20260926-105949/111659/120311) — retry singkat sebelum disimpulkan tidak ada.
// WAJIB direplikasi sama persis di modul ini sesuai instruksi.
async function exists(page, urlPath, selector, text) {
  for (let attempt = 1; attempt <= 3; attempt++) {
    await openFilteredList(page, urlPath, selector, text);
    if ((await row(page, text).count()) > 0) return true;
    if (attempt < 3) await page.waitForTimeout(1500);
  }
  return false;
}
const trayekAc04ExistsInDaftar = (page) => exists(page, '/partner/DaftarTrayek', '#nama_trayek_filter', DATA.trayekAc04);
const trayekAc04HasHarga = (page) => exists(page, '/partner/masterharga', '#nama_harga_filter', DATA.trayekAc04);
async function openLihatHargaAc04(page) {
  const found = await trayekAc04HasHarga(page);
  if (!found) return false;
  await row(page, DATA.trayekAc04).first().locator('a.btn-view.lihatharga').click();
  await page.waitForURL(/lihatharga/i, { timeout: 20_000 });
  return true;
}
// Beberapa halaman Master (mis. Tambah Golongan #jenis1) crash JS saat trigger('change') — TERBUKTI juga terjadi
// lewat klik UI Select2 asli (bukan artefak trigger terprogram), pola sama dengan FND-10 OP-21 (Petugas Scan).
// Tangkap di sini (bukan menahan skenario yang bukan tentang JS crash) — watchPageErrors mencatatnya terpisah.
async function select2(page, selector, value) {
  await page.evaluate(([s, v]) => {
    const $ = window.jQuery || window.$;
    try { $(s).val(v).trigger('change'); } catch (e) { /* dicatat via page.on('pageerror') di watchPageErrors */ }
  }, [selector, value]);
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
  return (await opt.getAttribute('value')) ?? ''; // opsi placeholder valid punya value="" — bukan "tidak ditemukan"
}
async function firstRealOptionValue(page, selectSelector) {
  const opts = page.locator(`${selectSelector} option`);
  const count = await opts.count();
  for (let i = 0; i < count; i++) {
    const val = await opts.nth(i).getAttribute('value');
    if (val) return val;
  }
  throw new Error(`Tidak ada opsi valid pada ${selectSelector}`);
}
// Opsi placeholder (mis. "-- Pilih Pelabuhan --") selalu value="" — kumpulkan HANYA teks opsi dengan value non-kosong
// (pelajaran SCN-0013/14/15: .filter(Boolean) pada teks saja tidak cukup, placeholder juga punya teks non-kosong).
async function realOptionTexts(page, selectSelector) {
  // select[name="port[]"] (Tambah Trayek) punya placeholder dengan value SAMA PERSIS dengan teksnya
  // ("-- Pilih Pelabuhan --"), bukan value="" — filter truthy saja tidak cukup, exclude pola "--...--" juga.
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
// Kumpulkan SEMUA native alert()/confirm() yang muncul selama test (bukan cuma sekali seperti captureDialog OP-21)
// — dibutuhkan untuk SCN-0035 (2 field) dan expectSilentSubmit (FND-M-01).
function captureDialogs(page) {
  const messages = [];
  page.on('dialog', async (d) => { messages.push(d.message()); await d.accept().catch(() => {}); });
  return messages;
}
// FND-M-01: Simpan pada form Tambah dengan SEMUA field kosong TIDAK menampilkan popover/alert apa pun DAN TIDAK
// ADA request POST/AJAX terkirim — verifikasi via page.waitForRequest dengan timeout pendek yang di-catch (bukan
// menunggu lama pesan yang memang tidak akan muncul), sesuai instruksi.
async function expectSilentSubmit(page, clickFn) {
  const messages = captureDialogs(page);
  const reqPromise = page.waitForRequest((r) => r.method() !== 'GET', { timeout: 2500 }).catch(() => null);
  await clickFn();
  const req = await reqPromise;
  expect(req, `Tidak boleh ada request non-GET terkirim (FND-M-01)${req ? ` — terlihat ${req.method()} ${req.url()}` : ''}`).toBeNull();
  expect(messages.length, `Tidak boleh ada native alert/confirm (muncul: ${messages.join(' | ')})`).toBe(0);
  await expect(page.locator('.swal2-popup')).toHaveCount(0);
  await expect(page.locator('.popover:visible')).toHaveCount(0);
}
// Simulasi paste sungguhan (bukan keystroke satu-satu) via clipboard API — dibutuhkan SCN-0035/FND-M-02 karena
// assignment value terprogram (fill()) tidak selalu ditegakkan oleh atribut HTML maxlength.
async function pasteText(page, locator, text) {
  await page.context().grantPermissions(['clipboard-read', 'clipboard-write']);
  await locator.click();
  await page.evaluate(async (txt) => { await navigator.clipboard.writeText(txt); }, text);
  await page.keyboard.press('Control+A');
  await page.keyboard.press('Control+V');
}
async function deleteRowConfirmed(page, rowLocator, confirmLabel = 'Ya') {
  await rowLocator.locator('.btn-delete').click();
  await swalClick(page, confirmLabel);
  await page.waitForLoadState('networkidle').catch(() => {});
}
// Master Informasi (beda dari submodul Master lain) memakai native confirm() untuk Hapus, BUKAN SweetAlert2
// (dikonfirmasi live 27 Sep 2026: "Apakah anda yakin untuk menghapus data informasi ?") — deleteRowConfirmed()
// akan timeout menunggu .swal2-popup yang tidak pernah muncul di sini.
async function deleteInformasiRow(page, rowLocator) {
  page.once('dialog', (d) => d.accept());
  await rowLocator.locator('.btn-delete').click();
  await page.waitForLoadState('networkidle').catch(() => {});
}
// Datepicker "Berlaku Sampai" (Master Informasi) TIDAK menerima .fill() teks biasa dan TIDAK ada default value
// (lihat FND-M-08) — wajib klik hari yang clickable (cursor:pointer) di kalender popup untuk mengisi field wajib
// ini sebelum Simpan, kalau tidak Simpan gagal senyap (pola FND-M-01).
async function fillDatepickerToday(page, inputLocator) {
  await inputLocator.click();
  await page.locator('li, td').filter({ hasText: /^\d{1,2}$/ }).evaluateAll((els) => {
    const clickable = els.find((el) => el.textContent.trim().length > 0 && getComputedStyle(el).cursor === 'pointer'
      && !el.children.length);
    if (clickable) clickable.click();
  });
  await page.waitForTimeout(200);
}

// ================= MASTER KELAS (SCR-01/02/03) =================
t('SCN-0001', async ({ page }) => {
  await openList(page, '/partner/mkapal');
  await page.locator('table:visible tbody tr:not(:has(td[colspan]))').first().locator('.btn-edit').click();
  await page.waitForURL(/edit_kapal/i, { timeout: 20_000 });
  const selectedTexts = (await page.locator('select[name="kelas[]"] option:checked').allInnerTexts()).map((s) => s.trim()).filter(Boolean);
  blockedUnless(selectedTexts.length > 0, 'Kapal existing yang dibuka tidak memiliki Kelas terpilih (select[name="kelas[]"])');
  const namaKelas = selectedTexts[0];
  note(`Kelas dipakai Kapal (data existing): ${namaKelas}`);

  // row(page, namaKelas) pakai substring match — nama kelas pendek (mis. "Ekonomi") cocok dengan beberapa baris
  // lain ("Ekonomi Cabin", dst). Cari baris dengan teks kolom Nama Kelas PERSIS sama.
  const exactRow = (text) => page.locator('table:visible tbody tr:not(:has(td[colspan]))')
    .filter({ has: page.locator('td', { hasText: new RegExp(`^${text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}$`) }) });
  await openList(page, '/partner/masterkelasnew');
  const kelasRow = exactRow(namaKelas);
  blockedUnless((await kelasRow.count()) > 0, `Baris Kelas "${namaKelas}" tidak ditemukan di Master Kelas`);
  await kelasRow.first().locator('.btn-delete').click();
  await expect(page.locator('.swal2-popup')).toContainText('Data Digunakan di Master Kapal', { timeout: 8000 });
  await closeSwal(page);
  await openList(page, '/partner/masterkelasnew');
  await expect(exactRow(namaKelas)).toHaveCount(1);
});

t('SCN-0002', async ({ page }) => {
  await page.goto('/partner/tambahkelas');
  await flag('FND-M-01', 'Simpan Tambah Kelas kosong: tidak ada popover/alert dan tidak ada request terkirim (silent no-op).', async () => {
    await expectSilentSubmit(page, () => page.locator('#submit_kelas').click());
  });
  await expect(page).toHaveURL(/tambahkelas/);
});

// ================= MASTER GOLONGAN (SCR-04/05/06) =================
t('SCN-0003', async ({ page }) => {
  // Master Kapal (SCR-08/09) hanya mengekspos field kelas[], TIDAK ada golongan[] (dikonfirmasi live di
  // master_ui-inventory.md) — tidak ada cara mengidentifikasi Golongan yang "dipakai" di Master Kapal lewat UI.
  // Sesuai instruksi (jangan menebak/membuat data buatan untuk precondition lintas modul), skenario ini blocked.
  blockedUnless(false, 'Form Tambah/Edit Kapal (SCR-08/09) hanya punya field kelas[], tidak ada golongan[] — tidak ada cara mengidentifikasi Golongan yang dipakai di Master Kapal lewat UI (lihat catatan master_analysis.md REQ-004/Q terkait SCN-0003).');
});

t('SCN-0004', async ({ page }) => {
  await page.goto('/partner/tambahgolongan');
  await flag('FND-M-01', 'Simpan Tambah Golongan kosong: silent no-op.', async () => {
    await expectSilentSubmit(page, () => page.locator('#submit_golongan').click());
  });
  await expect(page).toHaveURL(/tambahgolongan/);
});

t('SCN-0005', async ({ page }) => {
  const errs = watchPageErrors(page);
  await page.goto('/partner/tambahgolongan');
  const kendaraanVal = await optionValueByText(page, '#jenis1', 'Kendaraan');
  await select2(page, '#jenis1', kendaraanVal);
  await page.waitForTimeout(400);
  // Q-M-01: kalimat sumber P485 ambigu — observasi longgar field mana yang aktif, tidak menebak field spesifik.
  const candidates = ['golongan_kendaraan', 'bonus_tiket', 'muatan'];
  const visibility = {};
  for (const idPart of candidates) {
    const loc = page.locator(`[id*="${idPart}" i], [name*="${idPart}" i]`).first();
    visibility[idPart] = (await loc.count()) > 0 ? await loc.isVisible().catch(() => false) : false;
  }
  note(`Q-M-01 — field aktif saat Jenis Tiket=Kendaraan: ${JSON.stringify(visibility)}`);
  if (errs.length) note(`[bug-candidate] FND-M-07(?) error JS saat ganti Jenis Tiket: ${errs.join(' | ')}`);
  expect(Object.values(visibility).some(Boolean), 'setidaknya satu field terkait Kendaraan harus aktif saat Jenis Tiket=Kendaraan').toBeTruthy();
});

t('SCN-0006', async ({ page }) => {
  await page.goto('/partner/tambahgolongan');
  await expect(page.locator('#muncul1 option[value="UMUM"]')).toHaveText(/Semua Channel/i);
  await expect(page.locator('#muncul1 option[value="CABANG"]')).toHaveText(/Hanya Cabang/i);
});

t('SCN-0007', async ({ page }) => {
  const errs = watchPageErrors(page);
  await page.goto('/partner/tambahgolongan');
  const jenisVal1 = await optionValueByText(page, '#jenis1', 'Penumpang');
  await select2(page, '#jenis1', jenisVal1);
  await page.waitForTimeout(300);
  // Dikonfirmasi live 27 Sep 2026: error JS saat ganti Jenis Tiket (lihat watchPageErrors) TERBUKTI menghapus
  // input[name="nama[]"] dari DOM sepenuhnya (bukan cuma console error kosmetik) — form Tambah Golongan jadi
  // tidak bisa dipakai sama sekali begitu Jenis Tiket disentuh. Deteksi eksplisit sebelum lanjut, jangan timeout.
  const namaGone = (await page.locator('input[name="nama[]"]').count()) === 0;
  if (namaGone) {
    await flag('FND-M-09', `Field Nama Golongan Tiket (input[name="nama[]"]) HILANG dari DOM setelah memilih Jenis Tiket=Penumpang — form Tambah Golongan tidak bisa dipakai via UI sama sekali. Error JS: ${errs.join(' | ')}`, async () => {
      expect(namaGone, 'input[name="nama[]"] harus tetap ada setelah memilih Jenis Tiket').toBe(false);
    });
  }
  await page.locator('input[name="nama[]"]').nth(0).fill(DATA.golUmum);
  await select2(page, '#muncul1', 'UMUM');
  await page.locator('#add_menu').click();
  await expect(page.locator('#jenis2')).toBeVisible();
  const jenisVal2 = await optionValueByText(page, '#jenis2', 'Penumpang');
  await select2(page, '#jenis2', jenisVal2);
  await page.locator('input[name="nama[]"]').nth(1).fill(DATA.golCabang);
  await select2(page, '#muncul2', 'CABANG');
  await page.locator('#submit_golongan').click();
  await page.waitForURL(/\/partner\/mastergolongan\/?$/i, { timeout: 30_000 });

  await openList(page, '/partner/mastergolongan');
  note(`data dibuat: golongan ${DATA.golUmum}, ${DATA.golCabang}`);
  if (errs.length) note(`[bug-candidate] FND-M-07(?) error JS saat ganti Jenis Tiket: ${errs.join(' | ')}`);
  await expect(row(page, DATA.golUmum)).toContainText(/Semua Channel|UMUM/i);
  await expect(row(page, DATA.golCabang)).toContainText(/Hanya Cabang|CABANG/i);

  // Cleanup di dalam test yang sama: Golongan ini TIDAK dipakai submodul lain (lihat catatan scenarios.json),
  // aman dihapus — beda dari data permanen SCN-0015.
  for (const nama of [DATA.golUmum, DATA.golCabang]) {
    await openFilteredList(page, '/partner/mastergolongan', '#nama_golongan', nama);
    const r = row(page, nama);
    if ((await r.count()) > 0) await deleteRowConfirmed(page, r.first(), 'Ya');
  }
  await openFilteredList(page, '/partner/mastergolongan', '#nama_golongan', DATA.golUmum);
  await expect(row(page, DATA.golUmum)).toHaveCount(0);
});

// ================= MASTER KAPAL (SCR-07/08/09) =================
t('SCN-0008', async ({ page }) => {
  await openList(page, '/partner/masterkelasnew');
  const kelasNames = (await page.locator('table:visible tbody tr:not(:has(td[colspan])) td').allInnerTexts())
    .map((s) => s.trim())
    .filter((s) => s && !/^\d+$/.test(s) && !/hak akses|hapus|edit/i.test(s));
  const namesToCheck = [...new Set(kelasNames)].slice(0, 3);
  blockedUnless(namesToCheck.length > 0, 'Tidak ada data Master Kelas untuk dibandingkan dengan opsi Kelas di Tambah Kapal');

  await page.goto('/partner/tambahkapal');
  const kelasSelect = page.locator('select[name="kelas[]"]');
  await expect(kelasSelect).toHaveAttribute('multiple', /.*/);
  const optionTexts = (await kelasSelect.locator('option').allInnerTexts()).map((s) => s.trim()).filter(Boolean);
  note(`Opsi Kelas di Tambah Kapal: ${optionTexts.join(', ')}`);
  for (const nama of namesToCheck) {
    expect(optionTexts, `opsi Kelas di Tambah Kapal harus memuat "${nama}" (berasal dari Master Kelas)`).toContain(nama);
  }
});

t('SCN-0009', async ({ page }) => {
  await page.goto('/partner/tambahkapal');
  await flag('FND-M-01', 'Simpan Tambah Kapal kosong: silent no-op.', async () => {
    await expectSilentSubmit(page, () => page.getByRole('button', { name: 'Simpan' }).click());
  });
  await expect(page).toHaveURL(/tambahkapal/);
});

t('SCN-0010', async ({ page }) => {
  await page.goto('/partner/tambahkapal');
  const fields = [
    { id: '#nama_kapal', label: 'Nama Kapal' },
    { id: '#kode_kapal', label: 'Call Sign' },
    { id: '#kapasitas', label: 'Kapasitas Penumpang' },
  ];
  for (const f of fields) {
    await expect(page.locator('label', { hasText: f.label }).first()).toContainText('*');
  }
  await expect(page.locator('label', { hasText: 'Kelas' }).first()).toContainText('*');
  await flag('FND-M-03', 'Label bertanda * tapi atribut required elemen DOM = false pada form Tambah Kapal (tidak konsisten).', async () => {
    for (const f of fields) {
      await expect(page.locator(f.id)).not.toHaveAttribute('required', /.*/, { timeout: 1000 });
    }
    await expect(page.locator('select[name="kelas[]"]')).not.toHaveAttribute('required', /.*/, { timeout: 1000 });
  });
});

// ================= MASTER TRAYEK (SCR-10/11) =================
t('SCN-0011', async ({ page }) => {
  await page.goto('/partner/mtrayek_tambah');
  for (const label of ['Nama Trayek', 'Pilih Pelabuhan', 'Pelabuhan Dipilih', 'Pelabuhan Asal', 'Pelabuhan Tujuan']) {
    await expect(page.locator('label', { hasText: label }).first()).toContainText('*');
  }
  await expect(page.locator('label', { hasText: 'Konsumsi Penumpang' }).first()).not.toContainText('*');
});

t('SCN-0012', async ({ page }) => {
  await page.goto('/partner/mtrayek_tambah');
  await flag('FND-M-01', 'Simpan Tambah Trayek kosong: silent no-op.', async () => {
    await expectSilentSubmit(page, () => page.getByRole('button', { name: 'Simpan' }).click());
  });
  await expect(page).toHaveURL(/mtrayek_tambah/);
});

t('SCN-0013', async ({ page }) => {
  await page.goto('/partner/mtrayek_tambah');
  // select[name="port[]"] adalah Select2 (native <select> disembunyikan) — WAJIB via select2(), .selectOption()
  // Playwright akan timeout menunggu "visible" pada elemen yang sengaja disembunyikan Select2.
  const texts = await realOptionTexts(page, 'select[name="port[]"]');
  blockedUnless(texts.length >= 2, 'Data Pelabuhan tidak cukup (butuh minimal 2) untuk skenario ini');
  const [a, b] = texts.slice(0, 2);
  const valA = await optionValueByText(page, 'select[name="port[]"]', a);
  const valB = await optionValueByText(page, 'select[name="port[]"]', b);
  await select2(page, 'select[name="port[]"]', [valA, valB]);
  await page.waitForTimeout(600);
  const bodyText = await page.locator('body').innerText();
  const idxA = bodyText.indexOf(a);
  const idxB = bodyText.lastIndexOf(b);
  note(`Urutan pelabuhan dipilih (2): ${a} (pos ${idxA}), ${b} (pos ${idxB})`);
  expect(idxA, `"${a}" harus tampil di halaman`).toBeGreaterThanOrEqual(0);
  expect(idxB, `"${b}" harus tampil di halaman`).toBeGreaterThanOrEqual(0);
  expect(idxA, 'Pelabuhan A harus muncul sebelum Pelabuhan B pada baris Pelabuhan Dipilih/Rute').toBeLessThan(idxB);
});

t('SCN-0014', async ({ page }) => {
  await page.goto('/partner/mtrayek_tambah');
  const texts = await realOptionTexts(page, 'select[name="port[]"]');
  blockedUnless(texts.length >= 3, 'Data Pelabuhan tidak cukup (butuh minimal 3) untuk skenario ini');
  const [a, b, c] = texts.slice(0, 3);
  const valA = await optionValueByText(page, 'select[name="port[]"]', a);
  const valB = await optionValueByText(page, 'select[name="port[]"]', b);
  const valC = await optionValueByText(page, 'select[name="port[]"]', c);
  await select2(page, 'select[name="port[]"]', [valA, valB, valC]);
  await page.waitForTimeout(600);
  const bodyText = await page.locator('body').innerText();
  const idxA = bodyText.indexOf(a);
  const idxB = bodyText.indexOf(b, idxA + 1);
  const idxC = bodyText.indexOf(c, idxB + 1);
  note(`Urutan pelabuhan dipilih (3): ${a} (pos ${idxA}), ${b} (pos ${idxB}), ${c} (pos ${idxC})`);
  expect(idxA).toBeGreaterThanOrEqual(0);
  expect(idxB, `"${b}" harus muncul setelah "${a}"`).toBeGreaterThan(idxA);
  expect(idxC, `"${c}" harus muncul setelah "${b}"`).toBeGreaterThan(idxB);
});

// SCN-0015 — [SEKALI PAKAI — DATA PERMANEN, TIDAK BISA DIBERSIHKAN]. Trayek+Harga "AUTOTEST-20260927-TRAYEK-AC04"
// akan TERTINGGAL PERMANEN di lingkungan setelah skenario ini (REQ-014/015: trayek yang sudah punya harga tidak
// bisa diedit/dihapus). TIDAK ADA LANGKAH CLEANUP di sini, sesuai instruksi eksplisit modul ini. Entitas ini
// SENGAJA dipakai ulang oleh SCN-0017/0019/0021/0023 — jangan membuat Trayek+Harga permanen kedua untuk tujuan
// serupa.
t('SCN-0015', async ({ page }) => {
  note(`DATA PERMANEN: skenario ini membuat Trayek+Harga "${DATA.trayekAc04}" yang TIDAK BISA dibersihkan (REQ-014/015).`);
  await page.goto('/partner/mtrayek_tambah');
  await page.locator('#nama_trayek').fill(DATA.trayekAc04);
  const portTexts = await realOptionTexts(page, 'select[name="port[]"]');
  blockedUnless(portTexts.length >= 2, 'Data Pelabuhan tidak cukup untuk membuat Trayek uji permanen');
  const [portA, portB] = portTexts.slice(0, 2);
  const portValA = await optionValueByText(page, 'select[name="port[]"]', portA);
  const portValB = await optionValueByText(page, 'select[name="port[]"]', portB);
  await select2(page, 'select[name="port[]"]', [portValA, portValB]);
  await page.waitForTimeout(600);
  await expect(page.locator('#port_asal1')).toBeVisible();
  await expect(page.locator('#port_tujuan1')).toBeVisible();
  // Dikonfirmasi live 27 Sep 2026: klik Simpan di Tambah Trayek memicu error JS "Cannot read properties of null
  // (reading 'scrollIntoView')" TERLEPAS dari kelengkapan data (2 pelabuhan valid pun tetap crash) dan form TIDAK
  // pernah benar-benar tersimpan (dicek: tidak ada request tersimpan di Daftar Trayek). Deteksi eksplisit, jangan
  // timeout 30s tanpa penjelasan.
  const errs = watchPageErrors(page);
  await page.getByRole('button', { name: 'Simpan' }).click();
  const navigated = await page.waitForURL(/DaftarTrayek/i, { timeout: 8_000 }).then(() => true).catch(() => false);
  if (!navigated) {
    await flag('FND-M-10', `Simpan Tambah Trayek tidak menyimpan/navigasi (data valid: ${portA} - ${portB}). Error JS: ${errs.join(' | ') || '(tidak ada tertangkap watchPageErrors, cek trace)'}`, async () => {
      expect(navigated, 'Simpan Tambah Trayek harus berhasil menyimpan dan redirect ke Daftar Trayek').toBe(true);
    });
  }
  note(`DATA PERMANEN: Trayek dibuat: ${DATA.trayekAc04} (${portA} - ${portB})`);

  const trayekAda = await trayekAc04ExistsInDaftar(page);
  blockedUnless(trayekAda, `Trayek ${DATA.trayekAc04} gagal tersimpan di Daftar Trayek`);

  // Tambah Harga untuk trayek permanen ini
  await page.goto('/partner/tambahharga');
  const trayekVal = await optionValueByText(page, '#trayek', DATA.trayekAc04);
  await select2(page, '#trayek', trayekVal);
  await page.waitForLoadState('networkidle').catch(() => {});
  const ruteVal = await firstRealOptionValue(page, '#rute');
  await select2(page, '#rute', ruteVal);
  await page.getByRole('button', { name: 'Tambahkan' }).click();
  await expect(page.locator('input[name="harga[]"]').first()).toBeVisible({ timeout: 10_000 }); // lihat catatan SCN-0018 soal Select2 aria-hidden
  const jenisVal = await firstRealOptionValue(page, 'select[name="ParentID[]"]');
  await select2(page, 'select[name="ParentID[]"]', jenisVal);
  const golVal = await firstRealOptionValue(page, 'select[name="golongan[]"]');
  await select2(page, 'select[name="golongan[]"]', golVal);
  const kelasVal = await firstRealOptionValue(page, 'select[name="kelas[]"]');
  await select2(page, 'select[name="kelas[]"]', kelasVal);
  await page.locator('input[name="harga[]"]').first().fill('100000');
  await page.locator('input[name="tgl_berlaku[]"]').first().fill('01/01/2027');
  const muatanVal = await firstRealOptionValue(page, 'select[name="muatan[]"]').catch(() => null);
  if (muatanVal) await select2(page, 'select[name="muatan[]"]', muatanVal);
  await page.getByRole('button', { name: 'Simpan' }).click();
  await page.waitForLoadState('networkidle').catch(() => {});
  note(`DATA PERMANEN: baris Harga dibuat untuk Trayek ${DATA.trayekAc04}`);

  const hargaAda = await trayekAc04HasHarga(page);
  blockedUnless(hargaAda, `Harga untuk Trayek ${DATA.trayekAc04} gagal tersimpan di Master Harga`);

  // Verifikasi Edit Trayek ditolak/diblokir
  await openFilteredList(page, '/partner/DaftarTrayek', '#nama_trayek_filter', DATA.trayekAc04);
  await row(page, DATA.trayekAc04).locator('.btn-edit').click();
  await page.waitForTimeout(1200);
  const stillOnList = /DaftarTrayek/i.test(page.url());
  const swalVisibleAfterEdit = await page.locator('.swal2-popup').isVisible().catch(() => false);
  note(`Hasil klik Edit Trayek berharga: stillOnList=${stillOnList}, swalVisible=${swalVisibleAfterEdit}, url=${page.url()}`);
  expect(stillOnList || swalVisibleAfterEdit, 'Aksi Edit Trayek yang sudah punya Harga harus ditolak/diblokir (alert, tetap di daftar, atau bentuk lain)').toBeTruthy();
  if (swalVisibleAfterEdit) await closeSwal(page);

  // Verifikasi Hapus Trayek ditolak dengan pesan menyebut harga
  await openFilteredList(page, '/partner/DaftarTrayek', '#nama_trayek_filter', DATA.trayekAc04);
  await row(page, DATA.trayekAc04).locator('.btn-delete').click();
  await expect(page.locator('.swal2-popup')).toBeVisible({ timeout: 8000 });
  const swalText = (await page.locator('.swal2-popup').innerText()).replace(/\s+/g, ' ');
  note(`Pesan penolakan Hapus Trayek (redaksi apa adanya): ${swalText}`);
  expect(swalText.toLowerCase()).toMatch(/harga/);
  await closeSwal(page);
  await openFilteredList(page, '/partner/DaftarTrayek', '#nama_trayek_filter', DATA.trayekAc04);
  await expect(row(page, DATA.trayekAc04)).toHaveCount(1);
});

t('SCN-0016', async ({ page }) => {
  await openList(page, '/partner/DaftarTrayek');
  await page.locator('table:visible tbody tr:not(:has(td[colspan]))').first().locator('a.btn-viewnya').click();
  await page.waitForTimeout(500);
  await flag('FND-M-04', 'Panel collapse "Lihat" Trayek kosong (hanya elemen pembatas, tanpa detail).', async () => {
    const collapse = page.locator('.collapse.show').first();
    await expect(collapse).toBeVisible({ timeout: 5000 });
    const text = (await collapse.innerText()).trim();
    expect(text.length, 'panel collapse Trayek seharusnya kosong (FND-M-04)').toBeLessThan(5);
  });

  await openList(page, '/partner/MasterCrew');
  await page.locator('table:visible tbody tr:not(:has(td[colspan]))').first().locator('a.btn-viewnya').click();
  await page.waitForTimeout(500);
  await flag('FND-M-04', 'Panel collapse "Lihat" Crew kosong (hanya elemen pembatas, tanpa detail).', async () => {
    const collapse = page.locator('.collapse.show').first();
    await expect(collapse).toBeVisible({ timeout: 5000 });
    const text = (await collapse.innerText()).trim();
    expect(text.length, 'panel collapse Crew seharusnya kosong (FND-M-04)').toBeLessThan(5);
  });
});

// ================= MASTER HARGA (SCR-12/13/14/14b) =================
// SCN-0017 menambah baris Harga PERMANEN di atas Trayek permanen SCN-0015 (tidak bisa dibersihkan, tapi tidak
// menambah entitas permanen BARU — lihat catatan scenarios.json).
t('SCN-0017', async ({ page }) => {
  const ok = await openLihatHargaAc04(page);
  blockedUnless(ok, `Trayek permanen ${DATA.trayekAc04} belum ada Harga (jalankan SCN-0015 dulu)`);
  await expect(page.locator('table:visible tbody tr:not(:has(td[colspan]))').first()).toBeVisible({ timeout: 10_000 });
  const existingRowText = (await page.locator('table:visible tbody tr:not(:has(td[colspan]))').first().innerText()).replace(/\s+/g, ' ').trim();
  note(`Baris Harga existing (dari SCN-0015): ${existingRowText}`);
  const rowCountBefore = await page.locator('table:visible tbody tr:not(:has(td[colspan]))').count();

  // Tambah Harga baru pada trayek yang sama — DUPLIKASI DISENGAJA, menumpuk pada data permanen SCN-0015.
  await page.goto('/partner/tambahharga');
  const trayekVal = await optionValueByText(page, '#trayek', DATA.trayekAc04);
  await select2(page, '#trayek', trayekVal);
  await page.waitForLoadState('networkidle').catch(() => {});
  const ruteVal = await firstRealOptionValue(page, '#rute');
  await select2(page, '#rute', ruteVal);
  await page.getByRole('button', { name: 'Tambahkan' }).click();
  await expect(page.locator('input[name="harga[]"]').first()).toBeVisible({ timeout: 10_000 }); // lihat catatan SCN-0018 soal Select2 aria-hidden
  const jenisVal = await firstRealOptionValue(page, 'select[name="ParentID[]"]');
  await select2(page, 'select[name="ParentID[]"]', jenisVal);
  // Golongan Tiket & Kondisi Kendaraan dipilih sama dengan opsi pertama yang tersedia agar berpotensi duplikat
  // dengan baris SCN-0015 (kombinasi persis tidak bisa dipastikan dari tabel tampilan saja — lihat Q-M-02).
  const golVal = await firstRealOptionValue(page, 'select[name="golongan[]"]');
  await select2(page, 'select[name="golongan[]"]', golVal);
  const kelasVal = await firstRealOptionValue(page, 'select[name="kelas[]"]');
  await select2(page, 'select[name="kelas[]"]', kelasVal);
  await page.locator('input[name="harga[]"]').first().fill('150000');
  await page.locator('input[name="tgl_berlaku[]"]').first().fill('01/01/2027');
  const muatanVal = await firstRealOptionValue(page, 'select[name="muatan[]"]').catch(() => null);
  if (muatanVal) await select2(page, 'select[name="muatan[]"]', muatanVal);
  await page.getByRole('button', { name: 'Simpan' }).click();
  await page.waitForLoadState('networkidle').catch(() => {});

  await openLihatHargaAc04(page);
  const rowCountAfter = await page.locator('table:visible tbody tr:not(:has(td[colspan]))').count();
  const bodyHtml = await page.locator('table:visible tbody').innerHTML();
  const hasRedMark = /(text-danger|bg-danger|style="[^"]*color:\s*red|class="[^"]*\bred\b)/i.test(bodyHtml);
  note(`REQ-018/019 (Q-M-02): rowCountBefore=${rowCountBefore}, rowCountAfter=${rowCountAfter}, hasRedMark=${hasRedMark}`);
  expect(
    rowCountAfter === rowCountBefore || hasRedMark,
    'Kombinasi duplikat harus ditandai merah (REQ-019) DAN/ATAU Simpan ditolak sehingga baris tidak bertambah (REQ-018)'
  ).toBeTruthy();

  if (rowCountAfter > rowCountBefore) {
    // REQ-020: observasi Edit pada baris duplikat — dicatat apa adanya, tidak menebak detail lebih jauh.
    const dupRow = page.locator('table:visible tbody tr:not(:has(td[colspan]))').last();
    await dupRow.locator('.btn-edit').click();
    await page.waitForTimeout(500);
    const modalVisible = await page.locator('.modal.show, .modal:visible').isVisible().catch(() => false);
    note(`REQ-020: modal Edit Harga terbuka=${modalVisible} untuk baris yang berpotensi duplikat`);
    if (modalVisible) {
      const modal = modalLocator(page);
      const batalBtn = modal.getByRole('button', { name: 'Batal' });
      if (await batalBtn.count()) await batalBtn.click();
    }
  }
});

t('SCN-0018', async ({ page }) => {
  await page.goto('/partner/tambahharga');
  // select[name="ParentID[]"] langkah 2 SUDAH ada di DOM sejak load (hidden, template tersembunyi — pola sama
  // dengan tabel template OP-21) — cek :visible, bukan count DOM mentah.
  await expect(page.locator('select[name="ParentID[]"]:visible')).toHaveCount(0);
  // Tidak semua Trayek punya Rute terkonfigurasi — coba beberapa opsi Trayek sampai #rute terisi valid.
  const trayekOpts = await page.locator('#trayek option').evaluateAll((opts) => opts.filter((o) => o.getAttribute('value')).map((o) => o.getAttribute('value')));
  let ruteVal = null;
  for (const tv of trayekOpts.slice(0, 5)) {
    await select2(page, '#trayek', tv);
    await page.waitForLoadState('networkidle').catch(() => {});
    ruteVal = await firstRealOptionValue(page, '#rute').catch(() => null);
    if (ruteVal) break;
  }
  blockedUnless(!!ruteVal, 'Tidak ada Trayek dengan Rute terkonfigurasi di antara 5 opsi pertama untuk uji Tambah Harga');
  await select2(page, '#rute', ruteVal);
  await page.getByRole('button', { name: 'Tambahkan' }).click();
  // select[name="ParentID[]"] jadi aria-hidden begitu Select2 mem-widget-kannya (race — kadang masih sempat
  // "visible" sesaat, kadang tidak, lihat lesson SCN-0018 run 3 vs 4) — cek input teks biasa (bukan Select2)
  // yang lebih stabil untuk memastikan baris langkah 2 sudah dirender.
  await expect(page.locator('input[name="harga[]"]').first()).toBeVisible({ timeout: 10_000 });
  await flag('FND-M-01', 'Simpan Tambah Harga langkah 2 kosong: silent no-op.', async () => {
    await expectSilentSubmit(page, () => page.getByRole('button', { name: 'Simpan' }).click());
  });
  await expect(page).toHaveURL(/tambahharga/);
});

// SCN-0019: bug-candidate P508/Q-M-03 — WAJIB memakai data Harga uji permanen SCN-0015/0017 (bukan data produksi).
t('SCN-0019', async ({ page }) => {
  const ok = await openLihatHargaAc04(page);
  blockedUnless(ok, `Trayek permanen ${DATA.trayekAc04} belum ada Harga (jalankan SCN-0015 dulu)`);
  const rowCount = await page.locator('table:visible tbody tr:not(:has(td[colspan]))').count();
  blockedUnless(rowCount >= 2, `Butuh minimal 2 baris Harga pada Trayek ${DATA.trayekAc04} (jalankan SCN-0017 dulu) agar aman menghapus 1 baris di modal Edit`);

  const targetRow = page.locator('table:visible tbody tr:not(:has(td[colspan]))').nth(1);
  await targetRow.locator('.btn-edit').click();
  const modal = modalLocator(page);
  await expect(modal).toBeVisible({ timeout: 8000 });
  const rowDeleteBtn = modal.locator('button, a').filter({ hasText: /hapus/i }).first();
  const hasDeleteInModal = await rowDeleteBtn.count();
  blockedUnless(hasDeleteInModal > 0, 'Modal Edit Harga tidak memiliki tombol hapus baris — tidak bisa menguji P508/Q-M-03');
  await rowDeleteBtn.click();
  await page.waitForTimeout(300);
  await modal.getByRole('button', { name: 'Batal' }).click(); // BUKAN Simpan
  await page.waitForLoadState('networkidle').catch(() => {});

  await openLihatHargaAc04(page);
  const rowCountAfter = await page.locator('table:visible tbody tr:not(:has(td[colspan]))').count();
  note(`Q-M-03/P508: rowCount sebelum modal=${rowCount}, sesudah Batal=${rowCountAfter}`);
  await flag('bug-candidate-P508', 'Edit Harga: menghapus baris di modal tetap terhapus meski klik Batal (P508/Q-M-03) — sumber sendiri menandai "harus dipastikan lagi".', async () => {
    expect(rowCountAfter, 'Baris yang dihapus di modal Edit seharusnya TETAP ADA setelah klik Batal').toBe(rowCount);
  });
});

t('SCN-0020', async ({ page }) => {
  // Butuh identifikasi Harga yang sudah dipakai jadwal aktif di modul Kuota & Jadwal (OP-12) — di luar cakupan
  // Master, tidak boleh menebak/membuat data buatan untuk memenuhi precondition ini (sesuai instruksi).
  blockedUnless(false, 'Butuh identifikasi Harga yang sudah dipakai jadwal aktif di modul Kuota & Jadwal (OP-12) sebelum eksekusi — di luar cakupan Master, tidak ditebak.');
});

t('SCN-0021', async ({ page }) => {
  const ok = await openLihatHargaAc04(page);
  blockedUnless(ok, `Trayek permanen ${DATA.trayekAc04} belum ada Harga (jalankan SCN-0015 dulu)`);
  await page.getByRole('link', { name: 'Riwayat Harga' }).click();
  await page.waitForURL(/historyharga/i, { timeout: 20_000 });
  await expect(page.locator('table:visible thead')).toContainText('Status');
  await expect(page.locator('table:visible tbody tr:not(:has(td[colspan]))').first()).toBeVisible({ timeout: 10_000 });
  const rowsText = (await page.locator('table:visible tbody').innerText()).replace(/\s+/g, ' ');
  note(`Riwayat Harga trayek ${DATA.trayekAc04}: ${rowsText.slice(0, 400)}`);
  expect(await page.locator('table:visible tbody tr:not(:has(td[colspan]))').count()).toBeGreaterThan(0);
});

// ================= TARIF PASS PELABUHAN (SCR-15/16) =================
t('SCN-0022', async ({ page }) => {
  await openList(page, '/partner/tarifpass');
  const trayekName = (await page.locator('table:visible tbody tr:not(:has(td[colspan]))').first().locator('td').nth(1).innerText()).trim();
  note(`Trayek dengan Tarif Pass existing: ${trayekName}`);
  await page.goto('/partner/tambahtarifpass');
  let trayekVal = null;
  try { trayekVal = await optionValueByText(page, '#trayek', trayekName); } catch { /* tidak ditemukan */ }
  blockedUnless(!!trayekVal, `Trayek "${trayekName}" tidak ditemukan di dropdown Tambah Tarif Pass`);
  await select2(page, '#trayek', trayekVal);
  await page.waitForLoadState('networkidle').catch(() => {});
  const ruteVal = await firstRealOptionValue(page, '#rute');
  await select2(page, '#rute', ruteVal);
  await page.getByRole('button', { name: 'Tambahkan' }).click();
  await page.waitForTimeout(800);
  const bodyText = await page.locator('body').innerText();
  const indikasiBlokir = /(sudah (ada|memiliki|ditambahkan)|tidak bisa|gagal)/i.test(bodyText);
  note(`Q-M-02 Tarif Pass rute existing — setelah klik Tambahkan, indikasi blokir=${indikasiBlokir} (dicatat apa adanya, tidak ditebak)`);
  await expect(page).toHaveURL(/tambahtarifpass/);
  // TIDAK klik Simpan akhir — sesuai instruksi skenario ini berhenti sebelum Simpan.
});

t('SCN-0023', async ({ page }) => {
  await page.goto('/partner/tambahtarifpass');
  let trayekVal = null;
  try { trayekVal = await optionValueByText(page, '#trayek', DATA.trayekAc04); } catch { /* belum ada */ }
  blockedUnless(!!trayekVal, `Trayek permanen ${DATA.trayekAc04} belum ada (jalankan SCN-0015 dulu)`);
  await select2(page, '#trayek', trayekVal);
  await page.waitForLoadState('networkidle').catch(() => {});
  const ruteVal = await firstRealOptionValue(page, '#rute');
  await select2(page, '#rute', ruteVal);
  await page.getByRole('button', { name: 'Tambahkan' }).click();
  await page.waitForTimeout(800);
  const values = await page.locator('table input').evaluateAll((els) => els.map((e) => e.value));
  note(`Nilai rekomendasi Tarif Pass untuk rute baru Trayek ${DATA.trayekAc04}: ${JSON.stringify(values).slice(0, 400)}`);
  const anyFilled = values.some((v) => v && v.trim() && v.trim() !== '0');
  expect(anyFilled, 'Field harga Tarif Pass seharusnya menampilkan nilai rekomendasi (bukan kosong/0), sesuai P517').toBeTruthy();
  // TIDAK klik Simpan akhir — sesuai instruksi, tidak menambah entitas Tarif Pass baru.
});

t('SCN-0024', async ({ page }) => {
  // Butuh identifikasi Tarif Pass yang sudah dipakai di Kuota & Jadwal (OP-12) — di luar cakupan Master, tidak
  // ditebak (sama seperti SCN-0020).
  blockedUnless(false, 'Butuh identifikasi Tarif Pass yang sudah dipakai di Kuota & Jadwal (OP-12) sebelum eksekusi — di luar cakupan Master, tidak ditebak.');
});

// ================= MASTER CREW (SCR-22/23) =================
t('SCN-0025', async ({ page }) => {
  await page.goto('/partner/tambahcrew');
  await flag('FND-M-01', 'Simpan Tambah Crew kosong: silent no-op.', async () => {
    await expectSilentSubmit(page, () => page.locator('#submit_crew').click());
  });
  await expect(page).toHaveURL(/tambahcrew/);
});

// ================= DENDA PEMBATALAN (SCR-24/25) =================
// PERINGATAN WAJIB: SCR-25 (Setting Denda Pembatalan) mengubah setting tenant sungguhan. Seluruh skenario di
// bagian ini (SCN-0026, SCN-0029..SCN-0033) HANYA membaca field/nilai lalu SELALU menutup modal lewat tombol
// "Batal". Kode di bagian ini TIDAK PERNAH dan TIDAK BOLEH memanggil klik "Simpan" pada modal SCR-25.
t('SCN-0026', async ({ page }) => {
  await openList(page, '/partner/masterdenda');
  await page.locator('table:visible tbody tr:not(:has(td[colspan]))').first().locator('.tombol_setting_modal').click();
  const modal = modalLocator(page);
  await expect(modal).toBeVisible({ timeout: 8000 });
  await expect(modal).toContainText(/tiket agen/i);
  await modal.getByRole('button', { name: 'Batal' }).click(); // TANPA Simpan
});

t('SCN-0027', async ({ page }) => {
  await openList(page, '/partner/masterdenda');
  const rows = page.locator('table:visible tbody tr:not(:has(td[colspan]))');
  await expect(rows).toHaveCount(3);
  for (const nama of ['Rusak', 'Batal', 'Hangus']) {
    await expect(row(page, nama)).toHaveCount(1);
  }
  const count = await rows.count();
  for (let i = 0; i < count; i++) {
    const cells = (await rows.nth(i).locator('td').allInnerTexts()).map((c) => c.trim());
    note(`Baris Denda #${i}: ${cells.join(' | ')}`);
    expect(cells.some((c) => c.length > 0), `baris Denda ke-${i} harus punya kolom Trigger By terisi`).toBeTruthy();
  }
});

t('SCN-0028', async ({ page, cabangPage }) => {
  await openList(page, '/partner/masterdenda');
  await expect(page.getByRole('link', { name: /Tambah/i })).toHaveCount(0);
  await expect(page.locator('.tombol_setting_modal')).not.toHaveCount(0);

  await openList(cabangPage, '/partner/masterdenda');
  await expect(cabangPage.getByRole('link', { name: /Tambah/i })).toHaveCount(0);
  await expect(cabangPage.locator('.tombol_setting_modal')).not.toHaveCount(0);
});

t('SCN-0029', async ({ page }) => {
  const defaults = {};
  for (const nama of ['Rusak', 'Batal', 'Hangus']) {
    await openList(page, '/partner/masterdenda');
    await row(page, nama).locator('.tombol_setting_modal').click();
    const modal = modalLocator(page);
    await expect(modal).toBeVisible({ timeout: 8000 });
    await expect(modal.locator('#range_waktu_edit')).toBeVisible();
    await expect(modal.locator('#pilihan_denda_edit')).toBeVisible();
    await expect(modal.locator('#jumlah_denda_edit')).toBeVisible();
    const rangeVal = await modal.locator('#range_waktu_edit').inputValue();
    const jumlahVal = await modal.locator('#jumlah_denda_edit').inputValue();
    const disabled = await modal.locator('#jumlah_denda_edit').isDisabled();
    defaults[nama] = { rangeVal, jumlahVal, disabled };
    note(`Setting ${nama}: Range Waktu=${rangeVal}, Jumlah Denda=${jumlahVal}, jumlah_denda_edit disabled=${disabled}`);
    await modal.getByRole('button', { name: 'Batal' }).click(); // TANPA Simpan
    await page.waitForTimeout(300);
  }
  expect(defaults.Hangus.jumlahVal.replace(/\D/g, '')).toContain('100');
  note(`REQ-042 (dikonfirmasi di sini): field jumlah_denda_edit pada Hangus disabled=${defaults.Hangus.disabled}`);
});

// SCN-0030 (REQ-039): MEMBUTUHKAN IZIN EKSPLISIT USER untuk PENGUJIAN SIMPAN SUNGGUHAN (alert P533) — TIDAK
// diimplementasikan di sini. Di bawah ini HANYA observasi field Range Waktu Batal & Hangus, ditutup via Batal.
t('SCN-0030', async ({ page }) => {
  await openList(page, '/partner/masterdenda');
  await row(page, 'Batal').locator('.tombol_setting_modal').click();
  let modal = modalLocator(page);
  await expect(modal).toBeVisible({ timeout: 8000 });
  const rangeBatal = await modal.locator('#range_waktu_edit').inputValue();
  note(`Range Waktu Batal saat ini: ${rangeBatal}`);
  await modal.getByRole('button', { name: 'Batal' }).click(); // tombol dialog "Batal", BUKAN Simpan
  await page.waitForTimeout(300);

  await openList(page, '/partner/masterdenda');
  await row(page, 'Hangus').locator('.tombol_setting_modal').click();
  modal = modalLocator(page);
  await expect(modal).toBeVisible({ timeout: 8000 });
  const rangeHangus = await modal.locator('#range_waktu_edit').inputValue();
  note(`Range Waktu Hangus saat ini: ${rangeHangus}`);
  expect(rangeBatal, 'field Range Waktu Batal harus terisi').not.toBe('');
  expect(rangeHangus, 'field Range Waktu Hangus harus terisi').not.toBe('');
  await modal.getByRole('button', { name: 'Batal' }).click(); // BUKAN Simpan
});

// SCN-0031 (REQ-040): MEMBUTUHKAN IZIN EKSPLISIT USER untuk PENGUJIAN SIMPAN SUNGGUHAN (alert P534) — TIDAK
// diimplementasikan. Di bawah ini HANYA observasi field Jumlah Denda Persentase, ditutup via Batal.
t('SCN-0031', async ({ page }) => {
  for (const nama of ['Rusak', 'Batal']) {
    await openList(page, '/partner/masterdenda');
    await row(page, nama).locator('.tombol_setting_modal').click();
    const modal = modalLocator(page);
    await expect(modal).toBeVisible({ timeout: 8000 });
    const persenVal = await optionValueByText(page, '#pilihan_denda_edit', 'Persentase');
    await select2(page, '#pilihan_denda_edit', persenVal); // ganti tampilan opsi saja, TANPA Simpan
    await expect(modal.locator('#jumlah_denda_edit')).toBeVisible();
    const maxAttr = await modal.locator('#jumlah_denda_edit').getAttribute('max');
    const patternAttr = await modal.locator('#jumlah_denda_edit').getAttribute('pattern');
    note(`Setting ${nama} (Persentase): max=${maxAttr ?? '-'} pattern=${patternAttr ?? '-'}`);
    await modal.getByRole('button', { name: 'Batal' }).click(); // BUKAN Simpan
    await page.waitForTimeout(300);
  }
});

// SCN-0032 (REQ-043): MEMBUTUHKAN IZIN EKSPLISIT USER untuk PENGUJIAN SIMPAN SUNGGUHAN (alert P538) — TIDAK
// diimplementasikan. Di bawah ini HANYA observasi field Range Waktu Hangus & Batal, ditutup via Batal.
t('SCN-0032', async ({ page }) => {
  await openList(page, '/partner/masterdenda');
  await row(page, 'Hangus').locator('.tombol_setting_modal').click();
  let modal = modalLocator(page);
  await expect(modal).toBeVisible({ timeout: 8000 });
  const rangeHangus = await modal.locator('#range_waktu_edit').inputValue();
  note(`Range Waktu Hangus saat ini: ${rangeHangus}`);
  await modal.getByRole('button', { name: 'Batal' }).click(); // BUKAN Simpan
  await page.waitForTimeout(300);

  await openList(page, '/partner/masterdenda');
  await row(page, 'Batal').locator('.tombol_setting_modal').click();
  modal = modalLocator(page);
  await expect(modal).toBeVisible({ timeout: 8000 });
  const rangeBatal = await modal.locator('#range_waktu_edit').inputValue();
  note(`Range Waktu Batal saat ini: ${rangeBatal}`);
  expect(rangeHangus).not.toBe('');
  expect(rangeBatal).not.toBe('');
  await modal.getByRole('button', { name: 'Batal' }).click(); // BUKAN Simpan
});

t('SCN-0033', async ({ page, cabangPage }) => {
  await openList(page, '/partner/masterdenda');
  await page.locator('table:visible tbody tr:not(:has(td[colspan]))').first().locator('.tombol_setting_modal').click();
  const modal = modalLocator(page);
  await expect(modal).toBeVisible({ timeout: 8000 });
  await expect(modal).toContainText(/EDIT DENDA PEMBATALAN AGEN/i);
  await modal.getByRole('button', { name: 'Batal' }).click(); // TANPA Simpan

  await openList(cabangPage, '/partner/masterdenda');
  const settingBtn = cabangPage.locator('table:visible tbody tr:not(:has(td[colspan]))').first().locator('.tombol_setting_modal');
  await settingBtn.hover();
  await expect(settingBtn).toHaveAttribute('data-original-title', /Hanya bisa dilakukan oleh kantor pusat/i);
  await settingBtn.click();
  await cabangPage.waitForTimeout(500);
  await expect(cabangPage.locator('.modal.show, .modal:visible')).toHaveCount(0);
});

// ================= MASTER INFORMASI (SCR-26/27) =================
t('SCN-0034', async ({ page }) => {
  await page.goto('/partner/informasi_add');
  await flag('FND-M-01', 'Simpan Tambah Informasi kosong: silent no-op.', async () => {
    await expectSilentSubmit(page, () => page.locator('#submit_crew').click());
  });
  await expect(page).toHaveURL(/informasi_add/);
});

t('SCN-0035', async ({ page }) => {
  await page.goto('/partner/informasi_add');
  const judul = page.locator('input[placeholder="Masukkan Judul Informasi"]');
  const isi = page.locator('textarea[placeholder="Masukkan Isi Informasi"]');
  const messages = captureDialogs(page);
  await flag('FND-M-02', 'Paste teks >100/>350 karakter: field terpotong maxlength ATAU alert batas karakter muncul.', async () => {
    await pasteText(page, judul, 'A'.repeat(120));
    await page.waitForTimeout(300);
    const judulVal = await judul.inputValue();
    const judulOk = judulVal.length <= 100 || messages.some((m) => /melebihi batas karakter/i.test(m));
    note(`Judul: panjang setelah paste=${judulVal.length}, dialog=${messages.join(' | ') || '-'}`);
    expect(judulOk, 'Judul harus terpotong ≤100 karakter ATAU muncul alert batas karakter').toBeTruthy();

    await pasteText(page, isi, 'B'.repeat(400));
    await page.waitForTimeout(300);
    const isiVal = await isi.inputValue();
    const isiOk = isiVal.length <= 350 || messages.some((m) => /melebihi batas karakter/i.test(m));
    note(`Isi Informasi: panjang setelah paste=${isiVal.length}, dialog=${messages.join(' | ') || '-'}`);
    expect(isiOk, 'Isi Informasi harus terpotong ≤350 karakter ATAU muncul alert batas karakter').toBeTruthy();
  });
  // Tutup form tanpa Simpan
  const batalBtn = page.locator('#button-batal');
  if (await batalBtn.count()) await batalBtn.click().catch(() => {});
});

t('SCN-0036', async ({ page }) => {
  await page.goto('/partner/informasi_add');
  const berlakuInput = page.locator('input[placeholder="DD/MM/YYYY"]');
  const berlakuDefault = await berlakuInput.inputValue();
  note(`Berlaku Sampai default saat form dibuka: "${berlakuDefault}" (kosong — datepicker TIDAK mengisi value default)`);
  // REQ-049 ternyata bukan "value terisi default" — dikonfirmasi live 27 Sep 2026 saat debugging: input value
  // tetap kosong walau kalender dibuka/diklik. Beda dari catatan ui-inventory ("default hari ini") — bug-candidate.
  await flag('FND-M-08', `Berlaku Sampai TIDAK terisi default hari ini (value kosong saat form dibuka), berbeda dari catatan ui-inventory.`, async () => {
    expect(berlakuDefault, 'Berlaku Sampai default harus tanggal hari ini (REQ-049)').toBe('27/09/2026');
  });

  await page.locator('input[placeholder="Masukkan Judul Informasi"]').fill(DATA.infoPusat);
  await page.locator('textarea[placeholder="Masukkan Isi Informasi"]').fill(`${TAG} info uji otomatis`);
  await fillDatepickerToday(page, berlakuInput);
  // Simpan memicu native confirm() "Apakah anda yakin untuk menambah data informasi ?" (dikonfirmasi live 27 Sep
  // 2026) — TANPA handler, Playwright auto-dismiss dialog secara default sehingga submit batal senyap.
  page.once('dialog', (d) => d.accept());
  await page.locator('#submit_crew').click();
  await page.waitForURL(/informasi_show/i, { timeout: 30_000 });

  await openList(page, '/partner/informasi_show');
  const r = row(page, DATA.infoPusat);
  await expect(r).toHaveCount(1);
  note(`data dibuat: informasi ${DATA.infoPusat}`);
  const rowTextBefore = (await r.innerText()).replace(/\s+/g, ' ');
  note(`Baris Informasi sebelum edit: ${rowTextBefore}`);

  // Selector Edit Informasi TIDAK terdokumentasi di master_ui-inventory.md (daftar kosong saat harvest) — pakai
  // pendekatan generik (tombol .btn-edit baris, lalu tombol "Simpan" by role) dan catat hasil apa adanya.
  await r.locator('.btn-edit').click();
  await page.waitForTimeout(800);
  const isiField = page.locator('textarea').first();
  if (await isiField.count()) {
    await isiField.fill(`${TAG} info uji otomatis - diedit`);
    const simpanBtn = page.getByRole('button', { name: 'Simpan' }).first();
    if (await simpanBtn.count()) {
      page.once('dialog', (d) => d.accept()); // jaga-jaga native confirm() seperti Tambah/Hapus Informasi
      await simpanBtn.click();
    }
    await page.waitForLoadState('networkidle').catch(() => {});
  } else {
    note('Form Edit Informasi tidak ditemukan lewat pendekatan generik (.btn-edit) — dicatat sebagai gap dokumentasi, bukan kegagalan skenario.');
  }
  await openList(page, '/partner/informasi_show');
  const rowTextAfter = (await row(page, DATA.infoPusat).innerText()).replace(/\s+/g, ' ');
  note(`Baris Informasi setelah edit (REQ-053/054, kolom Tanggal Edit/User Buat dicatat apa adanya): ${rowTextAfter}`);

  // Cleanup di dalam test yang sama — Informasi BUKAN data referensi permanen (beda dari Kelas/Golongan/Kapal/
  // Trayek/Harga/Tarif Pass), aman dihapus.
  await deleteInformasiRow(page, row(page, DATA.infoPusat).first());
  await openList(page, '/partner/informasi_show').catch(() => {});
  await expect(row(page, DATA.infoPusat)).toHaveCount(0);
});

t('SCN-0037', async ({ cabangPage }) => {
  const page = cabangPage;
  await page.goto('/partner/informasi_add');
  await page.locator('input[placeholder="Masukkan Judul Informasi"]').fill(DATA.infoCabang);
  await page.locator('textarea[placeholder="Masukkan Isi Informasi"]').fill(`${TAG} info cabang uji otomatis`);
  await fillDatepickerToday(page, page.locator('input[placeholder="DD/MM/YYYY"]'));
  page.once('dialog', (d) => d.accept()); // lihat catatan native confirm() di SCN-0036
  await page.locator('#submit_crew').click();
  await page.waitForURL(/informasi_show/i, { timeout: 30_000 });

  await openList(page, '/partner/informasi_show');
  const r = row(page, DATA.infoCabang);
  await expect(r).toHaveCount(1);
  note(`data dibuat: informasi cabang ${DATA.infoCabang}`);

  await deleteInformasiRow(page, r.first());
  await openList(page, '/partner/informasi_show').catch(() => {});
  await expect(row(page, DATA.infoCabang)).toHaveCount(0);
});

// ================= AKSES CABANG & FILTER (SCR-01 dkk) =================
t('SCN-0038', async ({ cabangPage }) => {
  const page = cabangPage;
  const withTambah = [
    '/partner/masterkelasnew', '/partner/mastergolongan', '/partner/mkapal', '/partner/DaftarTrayek',
    '/partner/masterharga', '/partner/tarifpass', '/partner/MasterCrew', '/partner/informasi_show',
  ];
  const withoutTambah = ['/partner/masterasuransi', '/partner/masterdenda'];
  for (const url of withTambah) {
    await gotoNoRedirect(page, url);
    // Master Harga & Tarif Pass Pelabuhan memakai label "Buat Harga", bukan "Tambah ..." (dikonfirmasi live 27
    // Sep 2026) — bukan pembatasan akses, cuma label tombol beda per submodul.
    await expect(page.getByRole('link', { name: /Tambah|Buat/i })).not.toHaveCount(0);
  }
  for (const url of withoutTambah) {
    await gotoNoRedirect(page, url);
  }
});

t('SCN-0039', async ({ page }) => {
  await openList(page, '/partner/masterkelasnew');
  const namaKelas = (await page.locator('table:visible tbody tr:not(:has(td[colspan]))').first().locator('td').nth(1).innerText()).trim();
  blockedUnless(!!namaKelas, 'Tidak ada data Master Kelas untuk difilter');
  await page.locator('#btn-filter').click();
  await page.locator('input[name="nama_kelas"]').fill(namaKelas);
  await filterSubmit(page).click();
  await page.waitForLoadState('networkidle').catch(() => {});
  const rows = page.locator('table:visible tbody tr:not(:has(td[colspan]))');
  const count = await rows.count();
  expect(count).toBeGreaterThan(0);
  for (let i = 0; i < count; i++) {
    await expect(rows.nth(i)).toContainText(namaKelas);
  }
  await page.getByRole('button', { name: 'Reset' }).click();
  await page.waitForLoadState('networkidle').catch(() => {});
  await openList(page, '/partner/masterkelasnew');
  const countAfterReset = await page.locator('table:visible tbody tr:not(:has(td[colspan]))').count();
  expect(countAfterReset).toBeGreaterThanOrEqual(count);
});

t('SCN-0040', async ({ page }) => {
  await openList(page, '/partner/DaftarTrayek');
  const namaTrayek = (await page.locator('table:visible tbody tr:not(:has(td[colspan]))').first().locator('td').nth(1).innerText()).trim();
  blockedUnless(!!namaTrayek, 'Tidak ada data Master Trayek untuk difilter');
  await page.locator('#btn-filter').click();
  await page.locator('#nama_trayek_filter').fill(namaTrayek);
  await filterSubmit(page).click();
  await page.waitForLoadState('networkidle').catch(() => {});
  const rows = page.locator('table:visible tbody tr:not(:has(td[colspan]))');
  const count = await rows.count();
  expect(count).toBeGreaterThan(0);
  await page.getByRole('button', { name: 'Reset' }).click();
  await page.waitForLoadState('networkidle').catch(() => {});
  await openList(page, '/partner/DaftarTrayek');
  const countAfterReset = await page.locator('table:visible tbody tr:not(:has(td[colspan]))').count();
  expect(countAfterReset).toBeGreaterThanOrEqual(count);
});
