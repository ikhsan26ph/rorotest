# Selector Map — Portal Operator `/partner` (elemen bersama: login, header, sidebar)

Hasil `/harvest-selectors` 2026-09-25 (run `20260925-pengaturan-user`, Operator Pusat & Cabang) memakai `scripts/harvest_selectors.js`
(Playwright langsung, headless Brave). Dipakai bersama semua modul portal Operator. Sumber mentah: `artifacts/harvest/20260925-pengaturan-user*/`.

Host: `baseUrl` di `config/env.md`. Login portal Operator: `<baseUrl>/partner` (judul "Login Partner | Prahu Roro").

## Alur login (diverifikasi 2026-09-25)

1. `goto /partner` → isi `#username`, `#password` → klik tombol **Login** (form POST ke `/user/dologin`, hidden `JenisLogin=PARTNER`).
2. Sesudah login halaman **tetap di `/partner`** menampilkan "AKUN SAYA", lalu redirect otomatis ke `/partner/profil` (Operator Pusat) atau `/partner/profilsubuser` (Sub User Cabang). Tunggu `waitForURL(/\/partner\/(profil|profilsubuser|dashboard)/)` — jangan mengecek body saat redirect (innerText bisa kosong).
3. Indikator sesi aktif: tombol header **KELUAR** (`#signOut`) ada dan `#username` tidak ada.
4. Halaman yang tidak boleh diakses → redirect `/partner/dashboard` + `.alert-danger` "Anda Tidak Memiliki Akses Ke Halaman Tersebut".
5. Pesan login gagal (rule P39–P40: "Masukkan Kata Sandi Dengan Benar" / "Akun Belum Terdaftar") **belum diharvest** — tidak dicoba agar akun tidak terkunci.

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-00 | Input Email | `#username` | id | `name=username`, type text, tanpa placeholder/label for |
| SCR-00 | Input Kata Sandi | `#password` | id | type password |
| SCR-00 | Toggle lihat sandi | `#button-password` | id | ikon mata |
| SCR-00 | Tombol Login | `getByRole('button', { name: 'Login', exact: true })` | role | `button[type=submit]`, tanpa id |
| SCR-00 | Lupa Kata Sandi | `getByRole('link', { name: 'Lupa Kata sandi?' })` | role | href `/partner/ForgotPassword` |
| SCR-00 | Registrasi Sekarang | `getByRole('link', { name: 'Registrasi Sekarang' })` | role | href `/partner/register` |
| HDR | Tombol Keluar | `#signOut` | id | juga `getByRole('link', { name: 'KELUAR' })`; `#signOut1` versi mobile (hidden) |
| HDR | Badge jenis akun ("Kantor Pusat"/"Kantor Cabang") | `header button:has-text("Kantor Pusat")` | TIDAK STABIL | teks; tidak ada id |
| HDR | Nama perusahaan / user | `.app-header` teks | TIDAK STABIL | informasi saja |
| SIDE | Saldo Operator | `a.href_topup[href$="/partner/riwayatsaldo"]` | css | teks "Saldo Operator Rp. …" |
| SIDE | TOP-UP SALDO | `#btn-topup` | id | link `/partner/isi_saldo` |
| SIDE | Grup menu PENGATURAN USER | `getByRole('link', { name: 'PENGATURAN USER' })` | role | toggle collapsible (`a.sidebar_icon.k11`) |
| SIDE | Menu Hak Akses | `a[href$="/partner/hakAkses"]` | css | teks "Hak Akses" (submenu; visible hanya saat grup terbuka) |
| SIDE | Menu Sub User | `a[href$="/partner/subUser"]` | css | |
| SIDE | Menu Petugas Scan | `a[href$="/partner/petugasscan"]` | css | |
| SIDE | Menu Hak Akses Agen | `a[href$="/partner/hakAksesagen"]` | css | |
| SIDE | Menu Sub User Agen | `a[href$="/partner/subuseragen"]` | css | |
| SIDE | Menu AKUN SAYA | `a[href$="/partner/profil"]` | css | cabang: `/partner/profilsubuser` |
| SIDE | Menu lain (DASHBOARD, LAPORAN, MANIFEST, DAFTAR ORDER, TERMINAL, PEMBATALAN TIKET, LAPORAN AGEN, DAFTAR PIUTANG, PERSETUJUAN TIKET, CETAK TIKET, JUAL TIKET, KUOTA & JADWAL, DAFTAR RELASI, SALDO AGEN, VOUCHER, MASTER) | `getByRole('link', { name: '<TEKS KAPITAL>' })` | role | route lengkap lihat `explore/module-map.md` |
| ANY | Alert halaman (mis. tidak punya akses) | `.alert-danger` | css | teks "Anda Tidak Memiliki Akses Ke Halaman Tersebut" |
| ANY | Dialog konfirmasi SweetAlert2 | `.swal2-popup` ; tombol `getByRole('button', { name: 'Ya' })` / `'Batal'` / `'Hapus'` / `'Oke'` | css/role | `.swal2-confirm` / `.swal2-cancel` |
| ANY | Popover validasi field (`zemPopover`) | `.popover` / `.popover-body` | css | teks pesan per field, lihat selector-map modul |
| ANY | Native `alert()` | `page.on('dialog')` | — | dipakai untuk "Tidak bisa hapus! Hak akses sudah digunakan.", "Pilih Hak akses minimal 1", "Email Sudah Ada" |
| ANY | Pagination daftar | `#zem-pagination a[data-page="N"]` | css | `a.paginate_button`; "Selanjutnya »", "Akhir »" |
| ANY | Jumlah baris per halaman | `#valuelimit` | id | opsi 10/20/50/100 |
| ANY | Tombol toggle panel filter | `#btn-filter` | id | `<button>` di sebagian halaman, `<a href="#">` di halaman agen |

## Pola teknis yang perlu diketahui executor

- Daftar dirender AJAX (`partner/search…`) setelah load; tunggu `table tbody tr` ≥ 1 atau `networkidle` sebelum membaca baris. Beberapa tabel punya baris pemisah pertama (`td[colspan="3"]`) — cari baris lewat `getByRole('row', { name: /teks/ })`, bukan indeks.
- Dropdown memakai **select2**: `selectOption()` pada `<select>` asli berhasil (elemen `select2-hidden-accessible`), tampilan `.select2-selection__rendered` ikut berubah. Untuk multi-select (`hak_akses[]`, `jenisApk[]`) pakai `selectOption([...])`.
- Klik biasa (`locator.click()`) **berfungsi** di aplikasi ini (toggle filter, "Ganti kata sandi" diverifikasi) — hipotesis `dispatchEvent('click')` dari OMS tidak diperlukan di sini.
- Hapus data: klik tombol baris → SweetAlert2 → "Ya"/"Hapus" → POST AJAX → `location.reload()`. Tunggu reload selesai sebelum assert.
- Simpan form: tombol `type=button` + AJAX POST lalu `window.location.replace(...)` ke daftar; validasi sisi klien memakai `zemPopover` (Bootstrap popover) dan `alert()`.
