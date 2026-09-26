# OP-21 Pengaturan User — UI Inventory

Hasil harvest 2026-09-25 (UI v1.5.2). Selector lengkap: `shared/selector-map-pengaturan-user.md` (sumber utama executor) dan `shared/selector-map-partner-common.md` (login/header/sidebar). Screenshot: `artifacts/screenshots/harvest/20260925-pengaturan-user*/`.

## Layar (SCR)

| SCR | Layar | Route | Elemen utama (ringkas) |
|---|---|---|---|
| SCR-00 | Login Operator | `/partner` | `#username`, `#password`, tombol Login → redirect `/partner/profil` (pusat) / `/partner/profilsubuser` (sub user) |
| SCR-01 | Daftar Hak Akses | `/partner/hakAkses` | `#btn-filter`, link Tambah Hak Akses, `#valuelimit`, filter `#Nama` `#keterangan`, Reset, Filter(submit), tabel (No, Nama Hak Akses, Deskripsi, Total Hak Akses, Aksi), aksi Lihat/Edit/Hapus per baris, pagination |
| SCR-02 | Tambah Hak Akses | `/partner/buathakakses` | `#nama_hak_akses`, `#ket_hak_akses`, `#modul_all`, `#semua_all`, 19 checkbox "Pilih Semua" per modul, 199 checkbox akses ber-id semantik, Simpan `#submit_crew`, Batal `#button-batal`, KEMBALI |
| SCR-03 | Detail Hak Akses | `/partner/detailhakakses/<idEnc>` | Teks Nama/Deskripsi/Tanggal Buat/Tanggal Diperbarui/Total Hak Akses, daftar PERIJINAN HAK AKSES, KEMBALI |
| SCR-04 | Edit Hak Akses | `/partner/edithakakses/<idEnc>` | Sama dengan SCR-02 + hidden `#IDhakakses`; Simpan `#update_data` |
| SCR-05 | Daftar Sub User | `/partner/subUser` | `#btn-filter`, link Tambah Sub User, filter `#nama_golongan` `#jenis_user` `#emailnya` `#fds` `#status_user`, tabel (No, Nama Sub User, Email Sub User, Jenis User, Cabang Kota, Status User, Aksi), aksi Detail/Edit/Hapus |
| SCR-06 | Tambah Sub User | `/partner/buatsubuser` | `#email` `#password` `#password_confirm` `#nama` `#wa` `#jenis_user` `#cabang_kota` `#bagian_staff` `#status_user` `#hak_akses`(multi), Simpan `#submit_sub`, Batal |
| SCR-07 | Detail Sub User | `/partner/detailsubuser/<id>` | Teks Nama/Email/Nomor Whatsapp/Jenis User/Cabang Kota/Bagian Staff/Hak Akses/Status User |
| SCR-08 | Edit Sub User | `/partner/editsubuser/<id>` | Sama dengan SCR-06 + `#ID`, `#ganti_sandi` (small) & `#batal_ganti`; sandi readonly `*******` sampai Ganti diklik |
| SCR-09 | Daftar Petugas Scan | `/partner/petugasscan` | `#btn-filter`, link Tambah Petugas Scan, tombol Download Scanner (APK), filter `#nama_petugasnya` `#wanya` `#emailnya` `#kota` `#status`, tabel (No, Nama Petugas, Nomor WA, Email Petugas, Cabang Kota, Status User, Aksi), aksi `button.viewPetugas` / `button.petugasScanEdit` / `button.btn-delete` |
| SCR-10 | Buat Petugas Scan | `/partner/tambahPetugasScan_` | `#email` `#sandi` `#konfirmasiSandi` `#nama` `#statff` `#wa` `#port_data` `select[name="jenisApk[]"]` `#statusUser`, Simpan `#btn_petugas` |
| SCR-11 | Detail / Edit Petugas Scan | `/partner/petugasview/<b64>` / `/partner/petugasScanEdit/<b64>` | Detail: teks Nama/Email/Nomor Whatsapp/Status User/Cabang Kota/Bagian Staff/Jenis Akses Aplikasi. Edit: field seperti SCR-10 (+ `#cabangKota`, `#ganti_sandi`) |
| SCR-12 | Daftar Hak Akses Agen | `/partner/hakAksesagen` | `#btn-filter`(a), ⚑ link Tambah Hak Akses → `/agen/buathakakses` (pusat), filter `#AgentID` `#Nama` `#deskripsi`, tabel (No, Nama Agen, Nama Hak Akses, Deskripsi, Total Hak Akses, Aksi), aksi Lihat saja |
| SCR-13 | Detail Hak Akses Agen | `/partner/detailhakaksesagen/<id>` | Teks Agen/Nama Hak Akses/Deskripsi/Tanggal/Total, PERIJINAN |
| SCR-14 | Daftar Sub User Agen | `/partner/subuseragen` | `#btn-filter`(a), filter `#AgentID` `#nama_golongan` `#bagian_staff` `#status_user`, tabel (No, Nama Agen, Nama Sub User, Bagian Staff, Status User, Aksi), aksi Detail saja; kosong → "Tidak Ada Data yang tersedia" |
| SCR-15 | Detail Sub User Agen | `/partner/detailsubuseragen/<id>` | Teks Nama Agen/Nama Sub User/Email/Nomor Whatsapp/Bagian Staff/Hak Akses/Status User |

## Pesan (M-xx) — dari skrip inline halaman (bukan dari rule)

| ID | Layar | Pemicu | Pesan / bentuk |
|---|---|---|---|
| M-01 | SCR-02/04 | Nama kosong | popover "Masukkan Nama Hak Akses" |
| M-02 | SCR-02/04 | Deskripsi kosong | popover "Masukkan Deskripsi Hak Akses" |
| M-03 | SCR-02/04 | Tidak ada akses tercentang | `alert()` "Pilih Hak akses minimal 1" |
| M-04 | SCR-01 | Hapus hak akses yang dipakai | `alert()` "Tidak bisa hapus! Hak akses sudah digunakan." |
| M-05 | SCR-01 | Hapus hak akses | SweetAlert "Apakah anda yakin ingin hapus hak akses?" tombol Ya/Batal |
| M-06 | SCR-05 | Hapus sub user | SweetAlert "Apakah anda yakin ingin hapus sub user?" tombol Ya/Batal |
| M-07 | SCR-06/08 | Email kosong | popover "Masukkan email" |
| M-08 | SCR-06/08 | Email sudah ada (cek AJAX `cek_email_sub` saat keyup) | `.email_alert` tampil; saat Simpan popover "Email sudah Terdaftar" |
| M-09 | SCR-06/08 | Email tidak valid (keyup) | `.email_not_valid` tampil; saat Simpan popover "Masukkan Email dengan benar" / "Penulisan email salah" |
| M-10 | SCR-06/08 | Kata sandi kosong / tidak memenuhi regex `^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]).{5,}$` | popover "Masukkan Password" / "Password Harus Terdiri Dari Huruf & Angka" |
| M-11 | SCR-06/08 | Konfirmasi kosong / beda | popover "Ketik Ulang Password" / "Password Belum Sama" |
| M-12 | SCR-06/08 | Nama / WA / Bagian Staff kosong | popover "Masukkan Nama" / "Masukkan Nomor WA" / "Masukkan Bagian Staff" |
| M-13 | SCR-06/08 | WA sudah ada (cek AJAX `cek_wa_sub`) | `.wa_alert`; popover "Nomor sudah Terdaftar" |
| M-14 | SCR-06 | Jenis User / Status User / Hak Akses kosong | popover "Pilih Jenis User" / "Pilih Status User" / "Pilih Hak Akses" — target `#11`/`#22`/`#33` (⚑ FND-03: tidak ada elemen) |
| M-15 | SCR-06/08 | Jenis cabang tanpa kota | popover "Pilih Kota" (`#form_cabang_kota` / `#cabang_kota`) |
| M-16 | SCR-10/11 | Email kosong/salah | popover "Masukkan Email" / "Penulisan email salah" / "Masukkan Email dengan benar" |
| M-17 | SCR-10/11 | Sandi kosong / regex / konfirmasi | popover "Masukkan Password" / "Kombinasi Hanya Boleh Huruf dan Angka" / "Ketik Ulang Password" / "Password Belum Sama" |
| M-18 | SCR-10/11 | Nama / Staff / WA kosong | popover "Masukkan Nama" / "Input Staff" / "Masukkan Nomor wa" |
| M-19 | SCR-10/11 | WA > 13 digit | popover "Tidak boleh lebih dari 13 angka" |
| M-20 | SCR-10/11 | Kota / Jenis Akses kosong | popover "Pilih Kota" (`#port_data_alert`) / "Pilih Akses" (`#jenisApkalert`) |
| M-21 | SCR-10/11 | Email petugas sudah ada (respons server `sudah_ada`) | `alert()` "Email Sudah Ada" |
| M-22 | SCR-09 | Hapus petugas | SweetAlert "Hapus?" tombol Hapus/Batal |
| M-23 | ANY | Halaman tanpa akses / id tidak valid | redirect `/partner/dashboard` + `.alert-danger` "Anda Tidak Memiliki Akses Ke Halaman Tersebut" |

## Temuan harvest (FND-xx) — kandidat bug / gap, belum verdict

| ID | Layar | Temuan | Rujukan | Status |
|---|---|---|---|---|
| FND-01 | SCR-12 | Operator Pusat melihat link "Tambah Hak Akses" (href `/agen/buathakakses`) di Hak Akses Agen; Cabang tidak. Rule: operator hanya list & detail. | P841 | diuji SCN-0041 |
| FND-02 | SCR-12/14 | Cabang Parepare melihat hak akses agen "RORO COBA" (Nama Agen di Sub User Agen: "Agen Surabaya \| RORO COBA"), padahal filter agen cabang hanya berisi PT. Integritas Kuasa dan Sub User Agen cabang kosong. | P843–P844 | diuji SCN-0047 |
| FND-03 | SCR-06 | Validasi Jenis User/Status User/Hak Akses kosong memanggil popover pada `#11`/`#22`/`#33` yang tidak ada → tidak ada pesan, tombol Simpan diam. | VAL-003 | diuji SCN-0022 |
| FND-04 | SCR-02 | Belum ditemukan skrip yang mencentang "Melihat" otomatis saat akses lain dicentang (REQ-001); hanya logika Pilih Semua per modul. | P820 | diuji SCN-0008 |
| FND-05 | SCR-01/05/09 | Id elemen duplikat per baris tabel (`select_golongan`, `delete_golongan`, `delete_Petugas`); id sisa template (`submit_crew`, `nama_golongan`, `fds`, `statff`). | — | catatan automasi/a11y, bukan bug bisnis |
| FND-06 | SCR-08 | Placeholder salah pada Edit Sub User: Nama & Bagian Staff "Masukkan Email", WA "Masukkan Kata Sandi". | — | kosmetik |
| FND-07 | SCR-09 | Markup modal `#modalpetugas` (EDIT PETUGAS SCAN) dan handler `.edit` lama masih ada, tidak dipakai tombol aksi. | — | kode mati |
| FND-08 | SCR-01/04 | Aturan "Total Hak Akses tidak menghitung checkbox Pilih Semua" hanya tertulis di bagian Agen (P1063); diterapkan analog ke operator. | P1063 | diuji SCN-0011 |
| FND-09 | SCR-10 | `cek_email_petugas` (cek email saat ketik) dinonaktifkan (komentar); duplikat hanya diketahui dari respons server. | — | diuji SCN-0038 |
| FND-10 | SCR-10/11 | Klik Simpan pada Tambah/Edit Petugas Scan memanggil `$(".pilih-multiple-apk").select2("val")` pada select yang tidak diinisialisasi Select2 → `TypeError: Cannot read properties of undefined (reading 'val')`; validasi tidak berjalan dan tombol Simpan tetap disabled. | VAL-008, REQ-012 | ditemukan run 20260925-004317; diuji SCN-0031..0038 |

## Data dinamis yang dipakai skenario

- Hak akses uji: `AUTOTEST-20260925-HA`; sub user uji: `AUTOTEST-20260925-SU` / `autotest-20260925-su@example.com` / WA `081200000925`; petugas uji: `AUTOTEST-20260925-PS` (email & WA sama dengan sub user uji, REQ-012).
- Sub user existing untuk uji duplikat email: dibaca dari baris pertama daftar saat run (tidak diubah).
- Agen existing (pusat): PT. Integritas Kuasa (19534), PT. Agen RORO Balikpapan (19532), RORO COBA (1283); hak akses agen id 1; sub user agen id 1285.
