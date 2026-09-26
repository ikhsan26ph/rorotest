// Spec modul OP-21 Pengaturan User — Sistem Penjualan Tiket Kapal (portal Operator /partner).
// Judul test = "SCN-xxxx: <judul scenarios.json>" (dibaca langsung dari file agar traceability 1:1).
// Selector: shared/selector-map-pengaturan-user.md & shared/selector-map-partner-common.md (harvest 2026-09-25).
// Urutan eksekusi = urutan dalam file (workers: 1): Hak Akses → Sub User → Hak Akses (hapus ditolak) → Petugas Scan
// → hapus Sub User → hapus Hak Akses → Agen (pusat) → Cabang. Data uji berprefix AUTOTEST-20260925-, dibersihkan di akhir.
const fs = require('fs');
const path = require('path');
const { test, expect } = require('./helpers/partner-session');

const MODULE = 'op-21-pengaturan-user';
const SCN = Object.fromEntries(
  JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'scenario', MODULE, `${MODULE}_scenarios.json`), 'utf8'))
    .scenarios.map((s) => [s.id, s])
);
const t = (id, fn) => test(`${id}: ${SCN[id].title}`, fn);

const TAG = 'AUTOTEST-20260925';
const DATA = {
  ha: { nama: `${TAG}-HA`, ket: `${TAG} hak akses uji otomatis` },
  su: { nama: `${TAG}-SU`, email: 'autotest-20260925-su@example.com', wa: '081200000925', pass: 'Autotest2026', pass2: 'Autotest2026b', staff: `${TAG}-QA` },
  ps: { nama: `${TAG}-PS`, pass: 'Autotest2026', staff: `${TAG}-QA`, kota: 'Surabaya' },
};
const HA_7 = ['melihat_hak_akses', 'detail_hak_akses', 'melihat_sub_user', 'detail_sub_user', 'melihat_petugas_scan', 'melihat_hak_akses_agen', 'melihat_sub_user_agen'];
const MODUL_USER_20 = ['membuat_hak_akses', 'melihat_hak_akses', 'detail_hak_akses', 'edit_hak_akses', 'hapus_hak_akses',
  'membuat_sub_user', 'melihat_sub_user', 'detail_sub_user', 'edit_sub_user', 'hapus_sub_user',
  'melihat_hak_akses_agen', 'detail_hak_akses_agen', 'melihat_sub_user_agen', 'detail_sub_user_agen',
  'membuat_petugas_scan', 'melihat_petugas_scan', 'detail_petugas_scan', 'edit_petugas_scan', 'hapus_petugas_scan', 'download_petugas_scan'];

// Status data uji diturunkan dari aplikasi, bukan variabel memori: Playwright me-restart worker setelah test gagal
// sehingga variabel modul ter-reset (terbukti di run 20260925-004317).
async function exists(page, urlPath, text) {
  await openList(page, urlPath);
  return (await row(page, text).count()) > 0;
}
const haExists = (page) => exists(page, '/partner/hakAkses', DATA.ha.nama);
const suExists = (page) => exists(page, '/partner/subUser', DATA.su.email);
const psExists = (page) => exists(page, '/partner/petugasscan', DATA.ps.nama);

// ---------- helper ----------
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
  await expect(page.locator('table:visible tbody tr').first()).toBeVisible({ timeout: 20_000 });
}
// Ada tabel template tersembunyi (modal "Detail kapal") di setiap halaman → selalu scoping ke tabel yang terlihat.
const row = (page, text) => page.locator('table:visible tbody tr', { hasText: text });
const filterSubmit = (page) => page.locator('button[type="submit"]', { hasText: 'Filter' });
const popover = (page) => page.locator('.popover').first();
async function expectPopover(page, text) { await expect(popover(page)).toContainText(text, { timeout: 4000 }); }
async function checkLabel(page, id) {
  await page.locator(`label[for="${id}"]`).click();
  await expect(page.locator(`#${id}`)).toBeChecked();
}
async function select2(page, selector, value) {
  await page.evaluate(([s, v]) => { const $ = window.jQuery || window.$; $(s).val(v).trigger('change'); }, [selector, value]);
}
async function optionValueByText(page, selectSelector, text) {
  const v = await page.locator(`${selectSelector} option`, { hasText: text }).first().getAttribute('value');
  if (!v) throw new Error(`opsi "${text}" tidak ditemukan di ${selectSelector}`);
  return v;
}
function captureDialog(page) {
  const box = { message: null };
  page.once('dialog', async (d) => { box.message = d.message(); await d.accept(); });
  return box;
}
async function swalClick(page, buttonName) {
  await expect(page.locator('.swal2-popup')).toBeVisible({ timeout: 8000 });
  await page.locator('.swal2-popup').getByRole('button', { name: buttonName, exact: true }).click();
}
const mainText = (page) => page.locator('body');
async function fillSubUserBase(page, overrides = {}) {
  const d = { ...DATA.su, ...overrides };
  await page.locator('#email').fill(d.email);
  await page.locator('#password').fill(d.pass);
  await page.locator('#password_confirm').fill(d.confirm ?? d.pass);
  await page.locator('#nama').fill(d.nama);
  await page.locator('#wa').fill(d.wa);
}
// FND-10: di Tambah/Edit Petugas Scan, klik Simpan memanggil $('.pilih-multiple-apk').select2("val") pada elemen yang
// tidak diinisialisasi Select2 → TypeError, validasi tidak jalan, tombol Simpan tetap disabled (diverifikasi 2026-09-25).
function watchPageErrors(page) {
  const errs = [];
  page.on('pageerror', (e) => errs.push(String(e.message || e).slice(0, 200)));
  return errs;
}
async function petugasSubmit(page, errs, fn) {
  await flag('FND-10', 'Klik Simpan Petugas Scan memicu error JS (select2("val") pada Jenis Akses Aplikasi yang tidak diinisialisasi Select2) sehingga validasi/penyimpanan tidak berjalan.', async () => {
    try { await fn(); } catch (e) {
      if (errs.length) note(`error JS halaman: ${errs.join(' | ')}`);
      throw e;
    }
  });
}
async function fillPetugasBase(page, overrides = {}) {
  const d = { email: DATA.su.email, pass: DATA.ps.pass, nama: DATA.ps.nama, staff: DATA.ps.staff, wa: DATA.su.wa, ...overrides };
  await page.locator('#email').fill(d.email);
  await page.locator('#sandi').fill(d.pass);
  await page.locator('#konfirmasiSandi').fill(d.confirm ?? d.pass);
  await page.locator('#nama').fill(d.nama);
  await page.locator('#statff').fill(d.staff);
  await page.locator('#wa').fill(d.wa);
}

// ================= HAK AKSES =================
t('SCN-0001', async ({ page }) => {
  await openList(page, '/partner/hakAkses');
  for (const h of ['No', 'Nama Hak Akses', 'Deskripsi', 'Total Hak Akses', 'Aksi']) await expect(page.locator('table:visible thead')).toContainText(h);
  await expect(page.getByRole('link', { name: 'Tambah Hak Akses' })).toBeVisible();
  await expect(page.locator('table:visible tbody tr').first()).toContainText(/\d+ Hak Akses/);
});

t('SCN-0002', async ({ page }) => {
  await page.goto('/partner/buathakakses');
  await page.locator('#ket_hak_akses').fill(DATA.ha.ket);
  await page.locator('#submit_crew').click();
  await expectPopover(page, 'Masukkan Nama Hak Akses');
  await expect(page).toHaveURL(/buathakakses/);
});

t('SCN-0003', async ({ page }) => {
  await page.goto('/partner/buathakakses');
  await page.locator('#nama_hak_akses').fill(DATA.ha.nama);
  await page.locator('#submit_crew').click();
  await expectPopover(page, 'Masukkan Deskripsi Hak Akses');
  await expect(page).toHaveURL(/buathakakses/);
});

t('SCN-0004', async ({ page }) => {
  await page.goto('/partner/buathakakses');
  await page.locator('#nama_hak_akses').fill(DATA.ha.nama);
  await page.locator('#ket_hak_akses').fill(DATA.ha.ket);
  const dlg = captureDialog(page);
  await page.locator('#submit_crew').click();
  await expect.poll(() => dlg.message, { timeout: 5000 }).toContain('Pilih Hak akses minimal 1');
  await page.waitForTimeout(1500);
  await expect(page).toHaveURL(/buathakakses/);
});

t('SCN-0005', async ({ page }) => {
  await page.goto('/partner/buathakakses');
  await checkLabel(page, 'modul_jualtiket');
  await expect(page.locator('#melihat_daftar_penjualan')).toBeChecked();
  await expect(page.locator('#melihat_detail_penjualan')).toBeChecked();
  await expect(page.locator('#melihat_jualtiket')).toBeChecked();
});

t('SCN-0006', async ({ page }) => {
  await page.goto('/partner/buathakakses');
  await checkLabel(page, 'modul_piutang');
  await expect(page.locator('#melihat_daftar_penjualan')).toBeChecked();
  await expect(page.locator('#melihat_detail_penjualan')).toBeChecked();
  await expect(page.locator('#melihat_daftar_piutang')).toBeChecked();
});

t('SCN-0007', async ({ page }) => {
  await page.goto('/partner/buathakakses');
  await checkLabel(page, 'modul_persetujuan_tiket');
  await expect(page.locator('#melihat_daftar_penjualan')).toBeChecked();
  await expect(page.locator('#melihat_detail_penjualan')).toBeChecked();
  await expect(page.locator('#melihat_persetujuan_tiket')).toBeChecked();
});

t('SCN-0008', async ({ page }) => {
  await page.goto('/partner/buathakakses');
  await checkLabel(page, 'edit_hak_akses');
  await flag('FND-04', 'Mencentang Edit Hak Akses tidak otomatis mencentang Lihat Hak Akses (tidak ada skrip auto-centang "Melihat"; aplikasi mengikuti desain form, REQ-001/P820 ambigu).', async () => {
    await expect(page.locator('#melihat_hak_akses')).toBeChecked({ timeout: 2000 });
  });
});

t('SCN-0009', async ({ page }) => {
  await page.goto('/partner/buathakakses');
  await page.locator('#nama_hak_akses').fill(DATA.ha.nama);
  await page.locator('#ket_hak_akses').fill(DATA.ha.ket);
  for (const id of HA_7) await checkLabel(page, id);
  await page.locator('#submit_crew').click();
  await page.waitForURL(/\/partner\/hakakses\/?$/i, { timeout: 30_000 });
  await openList(page, '/partner/hakAkses');
  await expect(row(page, DATA.ha.nama)).toHaveCount(1);
  note(`data dibuat: hak akses ${DATA.ha.nama}`);
  await expect(row(page, DATA.ha.nama)).toContainText('7 Hak Akses');
});

t('SCN-0010', async ({ page }) => {
  blockedUnless(await haExists(page), 'hak akses uji belum dibuat (SCN-0009)');
  await openList(page, '/partner/hakAkses');
  await row(page, DATA.ha.nama).locator('a[href*="/partner/detailhakakses/"]').click();
  await expect(page).toHaveURL(/detailhakakses/);
  const txt = mainText(page);
  await expect(txt).toContainText('DETAIL HAK AKSES');
  await expect(txt).toContainText(new RegExp(`Nama Hak Akses\\s*:\\s*${DATA.ha.nama}`));
  await expect(txt).toContainText(/Total Hak Akses\s*:\s*7\b/);
  note(`perijinan aktual: ${(await txt.innerText()).replace(/\s+/g, ' ').split('PERIJINAN HAK AKSES')[1]?.slice(0, 300) || '-'}`);
  for (const re of [/Lihat (Daftar )?Hak Akses/i, /Detail Sub User/i, /Lihat (Daftar )?Petugas Scan/i, /Lihat (Daftar )?Sub User Agen/i]) await expect(txt).toContainText(re);
});

t('SCN-0011', async ({ page }) => {
  blockedUnless(await haExists(page), 'hak akses uji belum dibuat (SCN-0009)');
  await openList(page, '/partner/hakAkses');
  await row(page, DATA.ha.nama).locator('a[href*="/partner/edithakakses/"]').click();
  await expect(page).toHaveURL(/edithakakses/);
  await expect(page.locator('#nama_hak_akses')).toHaveValue(DATA.ha.nama);
  await checkLabel(page, 'modul_user');
  for (const id of MODUL_USER_20) await expect(page.locator(`#${id}`), `#${id} harus tercentang oleh Pilih Semua`).toBeChecked();
  await page.locator('#update_data').click();
  await page.waitForURL(/\/partner\/hakakses\/?$/i, { timeout: 30_000 });
  await openList(page, '/partner/hakAkses');
  await flag('FND-08', 'Total Hak Akses setelah Pilih Semua Modul Pengaturan User tidak sama dengan 20 sub-akses (aturan P1063 milik Agen diterapkan analog).', async () => {
    await expect(row(page, DATA.ha.nama)).toContainText('20 Hak Akses');
  });
});

t('SCN-0012', async ({ page }) => {
  blockedUnless(await haExists(page), 'hak akses uji belum dibuat (SCN-0009)');
  await openList(page, '/partner/hakAkses');
  await page.locator('#btn-filter').click();
  await page.locator('#Nama').fill(DATA.ha.nama);
  await filterSubmit(page).click();
  await page.waitForLoadState('networkidle').catch(() => {});
  await expect(row(page, DATA.ha.nama)).toHaveCount(1);
  await expect(page.locator('table:visible tbody tr', { hasText: /Hak Akses/ })).toHaveCount(1);
  await page.getByRole('button', { name: 'Reset' }).click();
  await page.waitForLoadState('networkidle').catch(() => {});
  await openList(page, '/partner/hakAkses');
  expect(await page.locator('table:visible tbody tr', { hasText: /Hak Akses/ }).count()).toBeGreaterThan(1);
});

// ================= SUB USER =================
t('SCN-0016', async ({ page }) => {
  await openList(page, '/partner/subUser');
  for (const h of ['No', 'Nama Sub User', 'Email Sub User', 'Jenis User', 'Cabang Kota', 'Status User', 'Aksi']) await expect(page.locator('table:visible thead')).toContainText(h);
  await expect(page.getByRole('link', { name: 'Tambah Sub User' })).toBeVisible();
  await page.locator('#btn-filter').click();
  for (const s of ['#nama_golongan', '#emailnya']) await expect(page.locator(s)).toBeVisible();
  for (const s of ['#jenis_user', '#fds', '#status_user']) await expect(page.locator(s)).toHaveCount(1);
});

t('SCN-0017', async ({ page }) => {
  await page.goto('/partner/buatsubuser');
  await page.locator('#submit_sub').click();
  await expectPopover(page, 'Masukkan email');
  await expect(page).toHaveURL(/buatsubuser/);
});

t('SCN-0018', async ({ page }) => {
  await openList(page, '/partner/subUser');
  const existingEmail = (await page.locator('table:visible tbody tr').first().locator('td').nth(2).innerText()).trim();
  expect(existingEmail).toMatch(/@/);
  await page.goto('/partner/buatsubuser');
  await page.locator('#email').pressSequentially(existingEmail, { delay: 20 });
  await expect(page.locator('.email_alert').first()).toBeVisible({ timeout: 8000 });
  await page.locator('#submit_sub').click();
  await expectPopover(page, 'Email sudah Terdaftar');
  await expect(page).toHaveURL(/buatsubuser/);
  note(`email existing yang dipakai (read-only): ${existingEmail}`);
});

t('SCN-0019', async ({ page }) => {
  await page.goto('/partner/buatsubuser');
  await fillSubUserBase(page, { pass: '123456' });
  await page.locator('#submit_sub').click();
  await expectPopover(page, 'Password Harus Terdiri Dari Huruf & Angka');
});

t('SCN-0020', async ({ page }) => {
  await page.goto('/partner/buatsubuser');
  await fillSubUserBase(page, { confirm: 'Autotest2027' });
  await page.locator('#submit_sub').click();
  await expectPopover(page, 'Password Belum Sama');
});

t('SCN-0021', async ({ page }) => {
  await page.goto('/partner/buatsubuser');
  await page.locator('#email').pressSequentially('autotest-salah', { delay: 20 });
  await page.locator('#submit_sub').click();
  await expect(popover(page)).toContainText(/Masukkan Email dengan benar|Penulisan email salah/, { timeout: 4000 });
});

t('SCN-0022', async ({ page }) => {
  await page.goto('/partner/buatsubuser');
  await fillSubUserBase(page);
  await page.locator('#submit_sub').click();
  await flag('FND-03', 'Tidak ada pesan "Pilih Jenis User": popover ditargetkan ke #11 yang tidak ada; tombol Simpan diam tanpa umpan balik (data tidak tersimpan).', async () => {
    await expectPopover(page, 'Pilih Jenis User');
  });
  await expect(page).toHaveURL(/buatsubuser/);
});

t('SCN-0023', async ({ page }) => {
  await page.goto('/partner/buatsubuser');
  await select2(page, '#jenis_user', 'cabang');
  await expect(page.locator('#cabang_kota')).toBeEnabled();
  await select2(page, '#jenis_user', 'pusat');
  await expect(page.locator('#cabang_kota')).toBeDisabled();
});

t('SCN-0024', async ({ page }) => {
  blockedUnless(await haExists(page), 'hak akses uji belum dibuat (SCN-0009)');
  await page.goto('/partner/buatsubuser');
  await fillSubUserBase(page);
  await select2(page, '#jenis_user', 'pusat');
  await page.locator('#bagian_staff').fill(DATA.su.staff);
  await select2(page, '#status_user', '1');
  const haVal = await optionValueByText(page, '#hak_akses', DATA.ha.nama);
  await select2(page, '#hak_akses', [haVal]);
  await page.locator('#submit_sub').click();
  await page.waitForURL(/\/partner\/subuser\/?$/i, { timeout: 30_000 });
  await openList(page, '/partner/subUser');
  const r = row(page, DATA.su.email);
  await expect(r).toHaveCount(1);
  note(`data dibuat: sub user ${DATA.su.nama} <${DATA.su.email}>`);
  await expect(r).toContainText(DATA.su.nama);
  await expect(r).toContainText('Pusat');
  await expect(r).toContainText('AKTIF');
});

t('SCN-0025', async ({ page }) => {
  blockedUnless(await suExists(page), 'sub user uji belum dibuat (SCN-0024)');
  await openList(page, '/partner/subUser');
  await row(page, DATA.su.email).locator('a[href*="/partner/detailsubuser/"]').click();
  const txt = mainText(page);
  await expect(txt).toContainText('DETAIL SUB USER');
  await expect(txt).toContainText(new RegExp(`Nama\\s*:\\s*${DATA.su.nama}`));
  await expect(txt).toContainText(/Jenis User\s*:\s*Pusat/);
  await expect(txt).toContainText(new RegExp(`Hak Akses\\s*:\\s*${DATA.ha.nama}`));
  await expect(txt).toContainText(/Status User\s*:\s*AKTIF/);
});

t('SCN-0026', async ({ page }) => {
  blockedUnless(await suExists(page), 'sub user uji belum dibuat (SCN-0024)');
  await openList(page, '/partner/subUser');
  await row(page, DATA.su.email).locator('a[href*="/partner/editsubuser/"]').click();
  await expect(page).toHaveURL(/editsubuser/);
  await expect(page.locator('#password')).toHaveAttribute('readonly', /.*/);
  await page.locator('#ganti_sandi').click();
  await expect(page.locator('#password')).not.toHaveAttribute('readonly', /.*/);
  await expect(page.locator('#password')).toHaveAttribute('type', 'password');
  await expect(page.locator('#password')).toHaveValue('');
  await page.locator('#password').fill(DATA.su.pass2);
  await page.locator('#password_confirm').fill(DATA.su.pass2);
  await page.locator('#submit_sub').click();
  await page.waitForURL(/\/partner\/subuser\/?$/i, { timeout: 30_000 });
  await openList(page, '/partner/subUser');
  await expect(row(page, DATA.su.email)).toHaveCount(1);
});

t('SCN-0027', async ({ page }) => {
  blockedUnless(await suExists(page), 'sub user uji belum dibuat (SCN-0024)');
  await openList(page, '/partner/subUser');
  await row(page, DATA.su.email).locator('a[href*="/partner/editsubuser/"]').click();
  await page.locator('#ganti_sandi').click();
  await page.locator('#password').fill(DATA.su.pass2);
  await page.locator('#password_confirm').fill('Autotest2026c');
  await page.locator('#submit_sub').click();
  await expectPopover(page, 'Password Belum Sama');
  await expect(page).toHaveURL(/editsubuser/);
});

t('SCN-0028', async ({ page }) => {
  blockedUnless(await suExists(page), 'sub user uji belum dibuat (SCN-0024)');
  await openList(page, '/partner/subUser');
  await page.locator('#btn-filter').click();
  await page.locator('#emailnya').fill(DATA.su.email);
  await filterSubmit(page).click();
  await page.waitForLoadState('networkidle').catch(() => {});
  await expect(row(page, DATA.su.email)).toHaveCount(1);
  await expect(page.locator('table:visible tbody tr', { hasText: '@' })).toHaveCount(1);
  await page.getByRole('button', { name: 'Reset' }).click();
  await page.waitForLoadState('networkidle').catch(() => {});
  await openList(page, '/partner/subUser');
  expect(await page.locator('table:visible tbody tr', { hasText: '@' }).count()).toBeGreaterThan(1);
});

// ================= HAK AKSES: hapus ditolak saat dipakai =================
t('SCN-0013', async ({ page }) => {
  blockedUnless((await haExists(page)) && (await suExists(page)), 'hak akses/sub user uji belum tersedia (SCN-0009/SCN-0024)');
  await openList(page, '/partner/hakAkses');
  const dlg = captureDialog(page);
  await row(page, DATA.ha.nama).locator('button.btn-delete').click();
  await expect.poll(() => dlg.message, { timeout: 8000 }).toContain('Tidak bisa hapus');
  await expect(page.locator('.swal2-popup')).toHaveCount(0);
  await openList(page, '/partner/hakAkses');
  await expect(row(page, DATA.ha.nama)).toHaveCount(1);
});

// ================= PETUGAS SCAN =================
t('SCN-0030', async ({ page }) => {
  await openList(page, '/partner/petugasscan');
  for (const h of ['No', 'Nama Petugas', 'Nomor WA', 'Email Petugas', 'Cabang Kota', 'Status User', 'Aksi']) await expect(page.locator('table:visible thead')).toContainText(h);
  await expect(page.getByRole('link', { name: 'Tambah Petugas Scan' })).toBeVisible();
  await expect(page.getByRole('button', { name: 'Download Scanner' })).toBeVisible();
});

t('SCN-0031', async ({ page }) => {
  const errs = watchPageErrors(page);
  await page.goto('/partner/tambahPetugasScan_');
  await petugasSubmit(page, errs, async () => {
  await page.locator('#btn_petugas').click();
  await expectPopover(page, 'Masukkan Email');
  await expect(page).toHaveURL(/tambahPetugasScan_/);
  });
});

t('SCN-0032', async ({ page }) => {
  const errs = watchPageErrors(page);
  await page.goto('/partner/tambahPetugasScan_');
  await fillPetugasBase(page, { wa: '08120000092512' });
  await petugasSubmit(page, errs, async () => {
  await page.locator('#btn_petugas').click();
  await expectPopover(page, 'Tidak boleh lebih dari 13 angka');
  });
});

t('SCN-0033', async ({ page }) => {
  const errs = watchPageErrors(page);
  await page.goto('/partner/tambahPetugasScan_');
  await fillPetugasBase(page);
  await petugasSubmit(page, errs, async () => {
  await page.locator('#btn_petugas').click();
  await expectPopover(page, 'Pilih Kota');
  });
});

t('SCN-0034', async ({ page }) => {
  const errs = watchPageErrors(page);
  await page.goto('/partner/tambahPetugasScan_');
  await fillPetugasBase(page);
  await select2(page, '#port_data', await optionValueByText(page, '#port_data', DATA.ps.kota));
  await petugasSubmit(page, errs, async () => {
  await page.locator('#btn_petugas').click();
  await expectPopover(page, 'Pilih Akses');
  });
});

t('SCN-0035', async ({ page }) => {
  const errs = watchPageErrors(page);
  blockedUnless(await suExists(page), 'sub user uji (sumber email/WA) belum dibuat (SCN-0024)');
  await page.goto('/partner/tambahPetugasScan_');
  await fillPetugasBase(page);
  await select2(page, '#port_data', await optionValueByText(page, '#port_data', DATA.ps.kota));
  await select2(page, 'select[name="jenisApk[]"]', ['1', '2']);
  await select2(page, '#statusUser', '1');
  const dlg = captureDialog(page);
  await petugasSubmit(page, errs, async () => {
  await page.locator('#btn_petugas').click();
  await page.waitForURL(/\/partner\/petugasscan\/?$/i, { timeout: 30_000 }).catch(() => {});
  expect(dlg.message, 'tidak boleh ada alert Email Sudah Ada').toBeNull();
  await openList(page, '/partner/petugasscan');
  const r = row(page, DATA.ps.nama);
  await expect(r).toHaveCount(1);
  note(`data dibuat: petugas scan ${DATA.ps.nama} <${DATA.su.email}>`);
  await expect(r).toContainText(DATA.ps.kota);
  await expect(r).toContainText('AKTIF');
  });
});

t('SCN-0036', async ({ page }) => {
  blockedUnless(await psExists(page), 'petugas scan uji belum dibuat (SCN-0035)');
  await openList(page, '/partner/petugasscan');
  await row(page, DATA.ps.nama).locator('button.viewPetugas').click();
  await page.waitForURL(/petugasview/, { timeout: 20_000 });
  const txt = mainText(page);
  await expect(txt).toContainText('DETAIL PETUGAS SCAN');
  await expect(txt).toContainText(DATA.ps.nama);
  await expect(txt).toContainText(/Scan Check ?in/i);
  await expect(txt).toContainText(/Scan Boarding/i);
  await expect(txt).toContainText(/Status User\s*AKTIF/);
});

t('SCN-0037', async ({ page }) => {
  const errs = watchPageErrors(page);
  blockedUnless(await psExists(page), 'petugas scan uji belum dibuat (SCN-0035)');
  await openList(page, '/partner/petugasscan');
  await row(page, DATA.ps.nama).locator('button.petugasScanEdit').click();
  await page.waitForURL(/petugasScanEdit/, { timeout: 20_000 });
  await expect(page.locator('#nama')).toHaveValue(DATA.ps.nama);
  await select2(page, '#statusUser', '0');
  const dlg = captureDialog(page);
  await petugasSubmit(page, errs, async () => {
  await page.locator('#btn_petugas').click();
  await page.waitForURL(/\/partner\/petugasscan\/?$/i, { timeout: 30_000 });
  expect(dlg.message).toBeNull();
  await openList(page, '/partner/petugasscan');
  await expect(row(page, DATA.ps.nama)).toContainText('TIDAK AKTIF');
  });
});

t('SCN-0038', async ({ page }) => {
  const errs = watchPageErrors(page);
  blockedUnless(await psExists(page), 'petugas scan uji belum dibuat (SCN-0035)');
  await page.goto('/partner/tambahPetugasScan_');
  await fillPetugasBase(page, { nama: `${DATA.ps.nama}-DUP` });
  await select2(page, '#port_data', await optionValueByText(page, '#port_data', DATA.ps.kota));
  await select2(page, 'select[name="jenisApk[]"]', ['1']);
  const dlg = captureDialog(page);
  await petugasSubmit(page, errs, async () => {
  await page.locator('#btn_petugas').click();
  await expect.poll(() => dlg.message, { timeout: 15_000 }).toContain('Email Sudah Ada');
  await page.waitForTimeout(1500);
  await expect(page).toHaveURL(/tambahPetugasScan_/);
  });
});

t('SCN-0039', async ({ page }) => {
  blockedUnless(await psExists(page), 'petugas scan uji belum dibuat (SCN-0035)');
  await openList(page, '/partner/petugasscan');
  await row(page, DATA.ps.nama).locator('button.btn-delete').click();
  const resp = page.waitForResponse((r) => r.url().includes('doDeletePetugas'), { timeout: 15_000 });
  await swalClick(page, 'Hapus');
  await resp;
  await openList(page, '/partner/petugasscan');
  await expect(row(page, DATA.ps.nama)).toHaveCount(0);
});

// ================= SUB USER: hapus =================
t('SCN-0029', async ({ page }) => {
  blockedUnless(await suExists(page), 'sub user uji belum dibuat (SCN-0024)');
  await openList(page, '/partner/subUser');
  await row(page, DATA.su.email).locator('button.btn-delete').click();
  const resp = page.waitForResponse((r) => r.url().includes('doDeletesub'), { timeout: 15_000 });
  await swalClick(page, 'Ya');
  await resp;
  await openList(page, '/partner/subUser');
  await expect(row(page, DATA.su.email)).toHaveCount(0);
});

// ================= HAK AKSES: hapus =================
t('SCN-0015', async ({ page }) => {
  blockedUnless((await haExists(page)) && !(await suExists(page)), 'hak akses uji masih dipakai / belum ada');
  await openList(page, '/partner/hakAkses');
  await row(page, DATA.ha.nama).locator('button.btn-delete').click();
  await swalClick(page, 'Batal');
  await expect(page.locator('.swal2-popup')).toHaveCount(0);
  await openList(page, '/partner/hakAkses');
  await expect(row(page, DATA.ha.nama)).toHaveCount(1);
});

t('SCN-0014', async ({ page }) => {
  blockedUnless((await haExists(page)) && !(await suExists(page)), 'hak akses uji masih dipakai / belum ada');
  await openList(page, '/partner/hakAkses');
  await row(page, DATA.ha.nama).locator('button.btn-delete').click();
  const resp = page.waitForResponse((r) => r.url().includes('hapushakakses'), { timeout: 15_000 });
  await swalClick(page, 'Ya');
  await resp;
  await openList(page, '/partner/hakAkses');
  await expect(row(page, DATA.ha.nama)).toHaveCount(0);
});

// ================= HAK AKSES AGEN & SUB USER AGEN (PUSAT) =================
t('SCN-0040', async ({ page }) => {
  await openList(page, '/partner/hakAksesagen');
  for (const h of ['No', 'Nama Agen', 'Nama Hak Akses', 'Deskripsi', 'Total Hak Akses', 'Aksi']) await expect(page.locator('table:visible thead')).toContainText(h);
  const dataRows = page.locator('table:visible tbody tr', { hasText: /Hak Akses/ });
  expect(await dataRows.count()).toBeGreaterThan(0);
  await expect(dataRows.first().locator('a[href*="/partner/detailhakaksesagen/"]')).toHaveCount(1);
  await expect(page.locator('table:visible tbody a[href*="edit"]')).toHaveCount(0);
  await expect(page.locator('table:visible tbody button.btn-delete')).toHaveCount(0);
});

t('SCN-0041', async ({ page }) => {
  await openList(page, '/partner/hakAksesagen');
  await flag('FND-01', 'Link "Tambah Hak Akses" (href /agen/buathakakses) tampil untuk Operator Pusat pada Hak Akses Agen; rule P841: operator hanya list & detail.', async () => {
    await expect(page.getByRole('link', { name: 'Tambah Hak Akses' })).toHaveCount(0, { timeout: 2000 });
  });
});

t('SCN-0042', async ({ page }) => {
  await openList(page, '/partner/hakAksesagen');
  await page.locator('table:visible tbody a[href*="/partner/detailhakaksesagen/"]').first().click();
  const txt = mainText(page);
  await expect(txt).toContainText('DETAIL HAK AKSES AGEN');
  for (const s of ['Agen :', 'Nama Hak Akses :', 'Total Hak Akses :', 'PERIJINAN HAK AKSES']) await expect(txt).toContainText(s);
  await expect(page.getByText('KEMBALI').first()).toBeVisible();
});

t('SCN-0043', async ({ page }) => {
  await openList(page, '/partner/hakAksesagen');
  await page.locator('#btn-filter').click();
  const opts = (await page.locator('#AgentID option').allInnerTexts()).map((s) => s.trim()).filter((s) => s && !/pilih agen/i.test(s));
  note(`opsi agen pusat: ${opts.join(' | ')}`);
  expect(opts.length).toBeGreaterThan(1);
});

t('SCN-0044', async ({ page }) => {
  await openList(page, '/partner/subuseragen');
  await expect(page.getByRole('link', { name: /Tambah/ })).toHaveCount(0);
  const dataRows = page.locator('table:visible tbody tr', { hasText: /AKTIF/ });
  expect(await dataRows.count()).toBeGreaterThan(0);
  await expect(dataRows.first().locator('a[href*="/partner/detailsubuseragen/"]')).toHaveCount(1);
  await expect(page.locator('table:visible tbody a[href*="edit"]')).toHaveCount(0);
  await expect(page.locator('table:visible tbody button.btn-delete')).toHaveCount(0);
});

t('SCN-0045', async ({ page }) => {
  await openList(page, '/partner/subuseragen');
  await page.locator('table:visible tbody a[href*="/partner/detailsubuseragen/"]').first().click();
  const txt = mainText(page);
  await expect(txt).toContainText('DETAIL SUB USER');
  for (const s of ['Nama Agen :', 'Nama Sub User :', 'Hak Akses :', 'Status User :']) await expect(txt).toContainText(s);
});

// ================= CABANG =================
t('SCN-0046', async ({ cabangPage }) => {
  const page = cabangPage;
  await openList(page, '/partner/hakAksesagen');
  await expect(page.getByRole('link', { name: 'Tambah Hak Akses' })).toHaveCount(0);
  await page.locator('#btn-filter').click();
  const opts = (await page.locator('#AgentID option').allInnerTexts()).map((s) => s.trim()).filter((s) => s && !/pilih agen/i.test(s));
  note(`opsi agen cabang: ${opts.join(' | ')}`);
  expect(opts.join(' ')).not.toMatch(/RORO COBA|Balikpapan/i);
});

t('SCN-0047', async ({ cabangPage }) => {
  const page = cabangPage;
  await openList(page, '/partner/hakAksesagen');
  const rowsText = await page.locator('table:visible tbody').first().innerText();
  note(`isi tabel cabang: ${rowsText.replace(/\s+/g, ' ').slice(0, 200)}`);
  await flag('FND-02', 'Cabang Parepare melihat hak akses agen "RORO COBA" (Agen Surabaya) di Hak Akses Agen; filter agen cabang hanya PT. Integritas Kuasa dan Sub User Agen cabang kosong. Rule P843.', async () => {
    expect(rowsText).not.toMatch(/RORO COBA/i);
  });
});

t('SCN-0048', async ({ cabangPage }) => {
  const page = cabangPage;
  await openList(page, '/partner/subuseragen');
  const rowsText = await page.locator('table:visible tbody').first().innerText();
  note(`isi tabel cabang: ${rowsText.replace(/\s+/g, ' ').slice(0, 200)}`);
  expect(rowsText).not.toMatch(/RORO COBA/i);
});

t('SCN-0049', async ({ cabangPage }) => {
  const page = cabangPage;
  for (const [url, tambah] of [['/partner/hakAkses', 'Tambah Hak Akses'], ['/partner/subUser', 'Tambah Sub User'], ['/partner/petugasscan', 'Tambah Petugas Scan']]) {
    await openList(page, url);
    await expect(page.getByRole('link', { name: tambah })).toBeVisible();
  }
});

// ================= CLEANUP (bukan skenario) =================
test('cleanup: hapus sisa data AUTOTEST-20260925 milik run ini', async ({ page }) => {
  const report = [];
  // petugas scan → sub user → hak akses (REQ-005 memaksa urutan ini)
  await openList(page, '/partner/petugasscan').catch(() => {});
  for (let i = 0; i < 3; i++) {
    const r = row(page, TAG);
    if ((await r.count()) === 0) break;
    await r.first().locator('button.btn-delete').click();
    const resp = page.waitForResponse((x) => x.url().includes('doDeletePetugas'), { timeout: 15_000 });
    await swalClick(page, 'Hapus');
    await resp; report.push('petugas scan dihapus');
    await openList(page, '/partner/petugasscan').catch(() => {});
  }
  await openList(page, '/partner/subUser').catch(() => {});
  for (let i = 0; i < 3; i++) {
    const r = row(page, TAG);
    if ((await r.count()) === 0) break;
    await r.first().locator('button.btn-delete').click();
    const resp = page.waitForResponse((x) => x.url().includes('doDeletesub'), { timeout: 15_000 });
    await swalClick(page, 'Ya');
    await resp; report.push('sub user dihapus');
    await openList(page, '/partner/subUser').catch(() => {});
  }
  await openList(page, '/partner/hakAkses').catch(() => {});
  for (let i = 0; i < 3; i++) {
    const r = row(page, TAG);
    if ((await r.count()) === 0) break;
    const dlg = captureDialog(page);
    await r.first().locator('button.btn-delete').click();
    try {
      const resp = page.waitForResponse((x) => x.url().includes('hapushakakses'), { timeout: 15_000 });
      await swalClick(page, 'Ya');
      await resp; report.push('hak akses dihapus');
    } catch (e) { report.push(`hak akses TIDAK terhapus: ${dlg.message || e.message.slice(0, 80)}`); break; }
    await openList(page, '/partner/hakAkses').catch(() => {});
  }
  note(report.length ? report.join('; ') : 'tidak ada sisa data');
  console.log('[cleanup]', report.length ? report.join('; ') : 'tidak ada sisa data');
});
