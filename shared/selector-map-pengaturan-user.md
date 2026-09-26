# Selector Map — Modul OP-21 Pengaturan User (portal Operator `/partner`)

Hasil `/harvest-selectors pengaturan-user` 2026-09-25, run `20260925-pengaturan-user` (Operator Pusat) dan `20260925-pengaturan-user-cabang`
(Sub User Cabang Parepare, hak akses "Akses IK"). Alat: `scripts/harvest_selectors.js` + config `scripts/harvest/pengaturan-user*.screens.json`.
Data mentah: `artifacts/harvest/20260925-pengaturan-user*/<screen>.json`, screenshot `artifacts/screenshots/harvest/20260925-pengaturan-user*/`.
Elemen bersama (login, header, sidebar, SweetAlert, popover, pagination) ada di `shared/selector-map-partner-common.md`.

Tidak ada `data-testid` sama sekali di aplikasi ini. Prioritas yang dipakai: id stabil → role+name → label/placeholder → css.
Id yang **duplikat per baris tabel** (`select_golongan`, `delete_golongan`, `delete_Petugas`) dan id sisa template (`submit_crew`, `nama_golongan`, `fds`, `statff`) ditandai di kolom Catatan.

## Indeks layar

| SCR | Layar | Route | Akun yang diverifikasi |
|---|---|---|---|
| SCR-01 | Daftar Hak Akses | `/partner/hakAkses` | Pusat, Cabang |
| SCR-02 | Tambah Hak Akses | `/partner/buathakakses` | Pusat, Cabang |
| SCR-03 | Detail Hak Akses | `/partner/detailhakakses/<idEnc>` | Pusat |
| SCR-04 | Edit Hak Akses | `/partner/edithakakses/<idEnc>` | Pusat |
| SCR-05 | Daftar Sub User | `/partner/subUser` | Pusat, Cabang |
| SCR-06 | Tambah Sub User | `/partner/buatsubuser` | Pusat, Cabang |
| SCR-07 | Detail Sub User | `/partner/detailsubuser/<id>` | Pusat |
| SCR-08 | Edit Sub User | `/partner/editsubuser/<id>` | Pusat |
| SCR-09 | Daftar Petugas Scan | `/partner/petugasscan` | Pusat, Cabang |
| SCR-10 | Tambah Petugas Scan | `/partner/tambahPetugasScan_` | Pusat, Cabang |
| SCR-11 | Detail Petugas Scan / Edit Petugas Scan | `/partner/petugasview/<base64(id)>` / `/partner/petugasScanEdit/<base64(id)>` | Pusat |
| SCR-12 | Daftar Hak Akses Agen | `/partner/hakAksesagen` | Pusat, Cabang |
| SCR-13 | Detail Hak Akses Agen | `/partner/detailhakaksesagen/<id>` | Pusat, Cabang |
| SCR-14 | Daftar Sub User Agen | `/partner/subuseragen` | Pusat, Cabang |
| SCR-15 | Detail Sub User Agen | `/partner/detailsubuseragen/<id>` | Pusat (cabang: tidak ada data) |

`<idEnc>` = id hak akses terenkripsi base64 (mis. `bEdWR0VFUC9qRy9LeWV1T0RpSFVwdz09`); tombol hapus membawa nilai yang sama di atribut `value`.

## SCR-01 Daftar Hak Akses

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-01 | Judul halaman | `getByText('HAK AKSES', { exact: true })` | text | tanpa heading semantik |
| SCR-01 | Tombol toggle Filter | `#btn-filter` | id | `type=button`; membuka panel filter |
| SCR-01 | Tombol Tambah Hak Akses | `getByRole('link', { name: 'Tambah Hak Akses' })` | role | href `/partner/buathakakses` |
| SCR-01 | Jumlah per halaman | `#valuelimit` | id | 10/20/50/100 |
| SCR-01 | Filter Nama Hak Akses | `#Nama` | id | `name=nama`, placeholder "Masukkan Nama Hak Akses"; hanya terlihat setelah `#btn-filter` |
| SCR-01 | Filter Deskripsi | `#keterangan` | id | placeholder "Masukkan Deskripsi" |
| SCR-01 | Tombol Reset filter | `getByRole('button', { name: 'Reset' })` | role | |
| SCR-01 | Tombol terapkan Filter | `locator('button[type="submit"]', { hasText: 'Filter' })` | css | ada 2 tombol bertuliskan "Filter" (toggle & submit) |
| SCR-01 | Tabel daftar | `table tbody tr` | css | kolom: No, Nama Hak Akses, Deskripsi, Total Hak Akses ("N Hak Akses"), Aksi; dirender AJAX `partner/searchhakakses` |
| SCR-01 | Baris berdasarkan nama | `getByRole('row', { name: /AUTOTEST-…/ })` | role | |
| SCR-01 | Aksi Lihat (per baris) | `row.locator('a[href*="/partner/detailhakakses/"]')` | css | tooltip `data-original-title="Lihat Hak Akses"`; tanpa id |
| SCR-01 | Aksi Edit (per baris) | `row.locator('a[href*="/partner/edithakakses/"]')` | css | id `select_golongan` DUPLIKAT tiap baris → TIDAK STABIL |
| SCR-01 | Aksi Hapus (per baris) | `row.locator('button.btn-delete')` | css | id `delete_golongan` DUPLIKAT; `value=<idEnc>`; tooltip "Hapus Hak Akses" |
| SCR-01 | Konfirmasi hapus | `.swal2-popup` teks "Apakah anda yakin ingin hapus hak akses?" ; `getByRole('button', { name: 'Ya' })` / `'Batal'` | css/role | hanya muncul bila `partner/cekDeleteHak` ≠ "Tidak" |
| SCR-01 | Alert hak akses sudah dipakai | `page.on('dialog')` → message "Tidak bisa hapus! Hak akses sudah digunakan." | dialog | native `alert()` (REQ-005) |
| SCR-01 | Pagination | `#zem-pagination a[data-page]` | css | |

## SCR-02 Tambah Hak Akses & SCR-04 Edit Hak Akses

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-02/04 | Link KEMBALI | `getByRole('link', { name: 'KEMBALI' })` | role | ke `/partner/hakakses` |
| SCR-02/04 | Nama Hak Akses | `#nama_hak_akses` | id | placeholder "Masukkan Nama Hak Akses", `required` |
| SCR-02/04 | Deskripsi Hak Akses | `#ket_hak_akses` | id | placeholder "Masukkan Deskripsi Hak Akses" |
| SCR-02/04 | Pilih Semua (Modul Administrator) | `#modul_all` | id | label "Modul Administrator Pilih Semua"; mencentang seluruh `.all_modul` |
| SCR-02/04 | Semua Akses | `#semua_all` | id | sinkron dengan `#modul_all` |
| SCR-02/04 | Pilih Semua per modul | `#modul_master`, `#modul_kuota_dan_jadwal`, `#modul_relasi`, `#modul_voucher`, `#modul_master_member`, `#modul_aksi_member`, `#modul_refund`, `#modul_penjualan`, `#modul_jualtiket`, `#modul_piutang`, `#modul_persetujuan_tiket`, `#modul_boarding_pass`, `#modul_manifest`, `#modul_saldo`, `#modul_laporan`, `#modul_laporan_agen`, `#modul_dashboard`, `#modul_user`, `#modul_notifikasi` | id | label "Modul … (Pilih Semua)"; **tidak dikirim ke server** (id mengandung "modul" difilter saat submit) |
| SCR-02/04 | Checkbox akses (contoh) | `#melihat_daftar_penjualan`, `#melihat_detail_penjualan`, `#melihat_jualtiket`, `#pembayaran_tunai`, `#melihat_daftar_piutang`, `#melihat_aksi_piutang`, `#melihat_persetujuan_tiket`, `#membuat_hak_akses`, `#melihat_hak_akses`, `#detail_hak_akses`, `#edit_hak_akses`, `#hapus_hak_akses`, `#membuat_sub_user`, `#melihat_sub_user`, `#detail_sub_user`, `#edit_sub_user`, `#hapus_sub_user`, `#membuat_petugas_scan`, `#melihat_petugas_scan`, `#detail_petugas_scan`, `#edit_petugas_scan`, `#hapus_petugas_scan`, `#download_petugas_scan`, `#melihat_hak_akses_agen`, `#detail_hak_akses_agen`, `#melihat_sub_user_agen`, `#detail_sub_user_agen` | id | 218 checkbox `name=check`, semua id semantik & unik; daftar lengkap: `artifacts/harvest/20260925-pengaturan-user/hakakses-create.json`. Alternatif `getByLabel('Lihat Hak Akses', { exact: true })` |
| SCR-02/04 | Kelas grup checkbox | `.jualtiket`, `.piutang`, `.persetujuan`, `.penjualan`, `.all_modul` | css | dipakai skrip auto-centang (REQ-002..004) |
| SCR-02 | Tombol Simpan | `#submit_crew` | id | id sisa template tapi stabil; POST `partner/savehakakses` → redirect `/partner/hakakses` |
| SCR-04 | Tombol Simpan | `#update_data` | id | POST `partner/saveedithakakses`; hidden `#IDhakakses` |
| SCR-02/04 | Tombol Batal | `#button-batal` | id | kembali ke daftar |
| SCR-02/04 | Popover validasi Nama | `.popover:has-text("Masukkan Nama Hak Akses")` | css | `zemPopover` → hilang otomatis ±1 detik; assert segera setelah klik Simpan |
| SCR-02/04 | Popover validasi Deskripsi | `.popover:has-text("Masukkan Deskripsi Hak Akses")` | css | |
| SCR-02/04 | Alert tanpa akses | `page.on('dialog')` → "Pilih Hak akses minimal 1" | dialog | native `alert()` |

## SCR-03 Detail Hak Akses

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-03 | Judul | `getByText('DETAIL HAK AKSES', { exact: true })` | text | |
| SCR-03 | Link KEMBALI | `getByRole('link', { name: 'KEMBALI' })` | role | |
| SCR-03 | Field info | `.app-main__inner` teks: "Nama Hak Akses : …", "Deskripsi : …", "Tanggal Buat : …", "Tanggal Diperbarui : …", "Total Hak Akses : N" | TIDAK STABIL | pasangan label/nilai tanpa id; assert via regex pada `innerText` |
| SCR-03 | Daftar perijinan | teks "PERIJINAN HAK AKSES" diikuti nama modul & akses tercentang | TIDAK STABIL | hanya teks |

## SCR-05 Daftar Sub User

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-05 | Tombol toggle Filter | `#btn-filter` | id | |
| SCR-05 | Tombol Tambah Sub User | `getByRole('link', { name: 'Tambah Sub User' })` | role | href `/partner/buatsubuser` |
| SCR-05 | Filter Nama Sub User | `#nama_golongan` | id | `name=nama`, placeholder "Masukkan Nama Sub User" (id sisa template) |
| SCR-05 | Filter Jenis User | `#jenis_user` | id | select2; opsi `pusat`=Kantor Pusat, `cabang`=Kantor Cabang |
| SCR-05 | Filter Email | `#emailnya` | id | `name=email` |
| SCR-05 | Filter Cabang Kota | `#fds` | id | `name=idcabang`, select2 daftar kota (mis. Parepare) |
| SCR-05 | Filter Status User | `#status_user` | id | `1`=Aktif, `2`=Tidak Aktif |
| SCR-05 | Reset / Filter | `getByRole('button', { name: 'Reset' })` / `locator('button[type="submit"]', { hasText: 'Filter' })` | role/css | |
| SCR-05 | Tabel | `table tbody tr` | css | kolom: No, Nama Sub User, Email Sub User, Jenis User (Pusat/Cabang), Cabang Kota ("-" untuk pusat), Status User (AKTIF/TIDAK AKTIF), Aksi; AJAX `partner/searchsubuser` |
| SCR-05 | Aksi Detail | `row.locator('a[href*="/partner/detailsubuser/"]')` | css | tooltip "Detail Sub User" |
| SCR-05 | Aksi Edit | `row.locator('a[href*="/partner/editsubuser/"]')` | css | id `select_golongan` DUPLIKAT |
| SCR-05 | Aksi Hapus | `row.locator('button.btn-delete')` | css | `value=<id>`; tanpa id; tooltip "Hapus Sub User" |
| SCR-05 | Konfirmasi hapus | `.swal2-popup` "Apakah anda yakin ingin hapus sub user?" ; tombol `Ya` / `Batal` | css/role | POST `partner/doDeletesub` lalu reload |

## SCR-06 Tambah Sub User & SCR-08 Edit Sub User

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-06/08 | Email | `#email` | id | `type=email`, placeholder "Masukkan Email"; blur → AJAX `partner/cek_email_sub` |
| SCR-06/08 | Kata Sandi | `#password` | id | SCR-08: readonly `type=text` berisi `*******` sampai "Ganti kata sandi" diklik |
| SCR-06/08 | Konfirmasi Kata Sandi | `#password_confirm` | id | idem |
| SCR-08 | Tautan "Ganti kata sandi" | `#ganti_sandi` | id | `<small>`; klik → kedua field readonly=false, `type=password`, kosong, attr `live=on`; tautan lalu disembunyikan |
| SCR-06/08 | Nama | `#nama` | id | placeholder "Masukkan Nama" (SCR-08 placeholder salah: "Masukkan Email") |
| SCR-06/08 | Nomor Whatsapp | `#wa` | id | class `hanyaangka` (hanya digit); blur → AJAX `partner/cek_wa_sub` |
| SCR-06/08 | Jenis User | `#jenis_user` | id | select2; `pusat`/`PUSAT`=Kantor Pusat, `cabang`=Kantor Cabang; memilih cabang mengaktifkan Cabang Kota |
| SCR-06/08 | Cabang Kota | `#cabang_kota` | id | select2, disabled bila Jenis User bukan cabang; wrapper `#form_cabang_kota` (target popover) |
| SCR-06/08 | Bagian Staff | `#bagian_staff` | id | |
| SCR-06/08 | Status User | `#status_user` | id | `1`=Aktif, `2`=Tidak Aktif |
| SCR-06/08 | Hak Akses (multi) | `#hak_akses` | id | `<select multiple name="hak_akses[]">` select2; opsi = nama hak akses (value id numerik, mis. 16 "Akses IK"); wrapper `#div_hak_akses` (target popover) |
| SCR-06/08 | Tombol Simpan | `#submit_sub` | id | SCR-06 POST `partner/dosavesubuser`; SCR-08 POST `partner/doeditsubuser`; redirect `/partner/subuser` |
| SCR-06/08 | Tombol Batal | `#button-batal` | id | SCR-08 juga link `getByRole('link', { name: 'Batal' })` |
| SCR-06/08 | Popover validasi | `.popover` | css | pesan: lihat ui-inventory M-xx (mis. "Ketik Ulang Password", "Password Belum Sama", "Pilih Jenis User", "Pilih Kota", "Pilih Hak Akses") |

## SCR-07 Detail Sub User

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-07 | Judul | `getByText('DETAIL SUB USER', { exact: true })` | text | |
| SCR-07 | Link KEMBALI | `getByRole('link', { name: 'KEMBALI' })` | role | |
| SCR-07 | Field info | teks "Nama : …", "Email : …", "Nomor Whatsapp : …", "Jenis User : …", "Cabang Kota : …", "Bagian Staff : …", "Hak Akses : …", "Status User : …" | TIDAK STABIL | regex pada `.app-main__inner` innerText |

## SCR-09 Daftar Petugas Scan

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-09 | Tombol toggle Filter | `#btn-filter` | id | |
| SCR-09 | Tombol Tambah Petugas Scan | `getByRole('link', { name: 'Tambah Petugas Scan' })` | role | href `/partner/tambahPetugasScan_` |
| SCR-09 | Tombol Download Scanner | `getByRole('button', { name: 'Download Scanner' })` | role | `onclick=download('…/assets/apk/RORO-Scanner-LIVE-v1.4.9-b4.apk')` — jangan diklik di test (unduh APK) |
| SCR-09 | Filter Nama Petugas | `#nama_petugasnya` | id | |
| SCR-09 | Filter No. WA | `#wanya` | id | |
| SCR-09 | Filter Email Petugas | `#emailnya` | id | |
| SCR-09 | Filter Cabang Kota | `#kota` | id | select2 kota |
| SCR-09 | Filter Status | `#status` | id | `aktif` / `tidak_aktif` |
| SCR-09 | Reset / Filter | `getByRole('button', { name: 'Reset' })` / `locator('button[type="submit"]', { hasText: 'Filter' })` | role/css | |
| SCR-09 | Tabel | `table tbody tr` | css | baris pertama = pemisah kosong (`td[colspan=3]`); kolom: No, Nama Petugas, Nomor WA, Email Petugas, Cabang Kota, Status User, Aksi; AJAX `partner/searchPetugas` |
| SCR-09 | Aksi Lihat | `row.locator('button.viewPetugas')` | css | `value=<id>`, `milik=operator`; navigasi JS ke `/partner/petugasview/<base64(id)>` |
| SCR-09 | Aksi Edit | `row.locator('button.petugasScanEdit')` | css | navigasi JS ke `/partner/petugasScanEdit/<base64(id)>` |
| SCR-09 | Aksi Hapus | `row.locator('button.btn-delete')` | css | id `delete_Petugas` DUPLIKAT; SweetAlert "Hapus?" tombol `Hapus` / `Batal`; POST `partner/doDeletePetugas` |
| SCR-09 | Modal `#modalpetugas` (EDIT PETUGAS SCAN) | `#modalpetugas` | id | markup sisa (handler `.edit` lama), **tidak dipakai** tombol aksi saat ini |

## SCR-10 Tambah Petugas Scan & SCR-11 Edit Petugas Scan

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-10/11 | Email | `#email` | id | `type=email`, required |
| SCR-10/11 | Kata Sandi | `#sandi` | id | SCR-11 readonly `type=text` sampai `#ganti_sandi` diklik |
| SCR-10/11 | Konfirmasi Kata Sandi | `#konfirmasiSandi` | id | |
| SCR-11 | Tautan "Ganti kata sandi" | `#ganti_sandi` | id | `<small>` |
| SCR-10/11 | Nama | `#nama` | id | |
| SCR-10/11 | Bagian Staff | `#statff` | id | typo id, `name=staff`; stabil |
| SCR-10/11 | Nomor Whatsapp | `#wa` | id | |
| SCR-10 | Cabang Kota | `#port_data` | id | `name=port`, select2 kota; popover target `#port_data_alert` |
| SCR-11 | Cabang Kota | `#cabangKota` | id | `name=kota` |
| SCR-10/11 | Jenis Akses Aplikasi (multi) | `locator('select[name="jenisApk[]"]')` | css | id `jenisApk[]` (perlu escape); opsi `1`=Scan Check In, `2`=Scan Boarding; popover target `#jenisApkalert` |
| SCR-10/11 | Status User | `#statusUser` | id | `0`=Tidak Aktif (default), `1`=Aktif |
| SCR-10/11 | Tombol Simpan | `#btn_petugas` | id | SCR-10 POST `partner/petugasScanSimpan` (respons duplikat → `alert("Email Sudah Ada")`); SCR-11 POST `partner/dosavePetugas`; redirect `/partner/petugasscan` |
| SCR-10/11 | Tombol Batal | `#button-batal` | id | SCR-11 juga link Batal |
| SCR-11 | Detail: judul & field | `getByText('DETAIL PETUGAS SCAN')`; teks "Nama", "Email", "Nomor Whatsapp", "Status User", "Cabang Kota", "Bagian Staff", "Jenis Akses Aplikasi" | TIDAK STABIL | link KEMBALI `a.kembaliya` |
| SCR-11 | Akses id tidak valid | redirect `/partner/dashboard` + `.alert-danger` "Anda Tidak Memiliki Akses Ke Halaman Tersebut" | css | |

## SCR-12 Daftar Hak Akses Agen & SCR-13 Detail

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-12 | Tombol toggle Filter | `#btn-filter` | id | di sini `<a href="#">` |
| SCR-12 | Tombol Tambah Hak Akses (⚑ FND-01) | `getByRole('link', { name: 'Tambah Hak Akses' })` | role | href `/agen/buathakakses`; **terlihat untuk Operator Pusat**, tidak ada untuk Cabang. Rule P841: operator hanya list/detail |
| SCR-12 | Filter Nama Agen | `#AgentID` | id | select2; Pusat: PT. Integritas Kuasa (19534), PT. Agen RORO Balikpapan (19532), RORO COBA (1283); Cabang Parepare: hanya PT. Integritas Kuasa |
| SCR-12 | Filter Nama Hak Akses | `#Nama` | id | |
| SCR-12 | Filter Deskripsi | `#deskripsi` | id | |
| SCR-12 | Reset / Filter | `getByRole('button', { name: 'Reset' })` / `locator('button[type="submit"]', { hasText: 'Filter' })` | role/css | |
| SCR-12 | Tabel | `table tbody tr` | css | kolom: No, Nama Agen, Nama Hak Akses, Deskripsi, Total Hak Akses, Aksi; data saat harvest: 1 baris "RORO COBA / Hak Akses Penjualan / 13 Hak Akses" (Pusat **dan** Cabang Parepare) |
| SCR-12 | Aksi Lihat | `row.locator('a[href*="/partner/detailhakaksesagen/"]')` | css | satu-satunya aksi; tidak ada Edit/Hapus |
| SCR-13 | Detail | `getByText('DETAIL HAK AKSES AGEN')`; teks "Agen : …", "Nama Hak Akses : …", "Deskripsi", "Tanggal Buat", "Tanggal Diperbarui", "Total Hak Akses : 13", "PERIJINAN HAK AKSES" | TIDAK STABIL | link KEMBALI |

## SCR-14 Daftar Sub User Agen & SCR-15 Detail

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-14 | Tombol toggle Filter | `#btn-filter` | id | `<a href="#">`; tidak ada tombol Tambah (sesuai P846) |
| SCR-14 | Filter Nama Agen | `#AgentID` | id | select2 (isi sama dengan SCR-12) |
| SCR-14 | Filter Nama Sub User | `#nama_golongan` | id | `name=nama` |
| SCR-14 | Filter Bagian Staff | `#bagian_staff` | id | |
| SCR-14 | Filter Status | `#status_user` | id | `1`/`2` |
| SCR-14 | Tabel | `table tbody tr` | css | kolom: No, Nama Agen, Nama Sub User, Bagian Staff, Status User, Aksi; Pusat: 1 baris "Agen Surabaya \| RORO COBA / Ikhsan / Penjualan / AKTIF"; Cabang Parepare: "Tidak Ada Data yang tersedia" |
| SCR-14 | Aksi Detail | `row.locator('a[href*="/partner/detailsubuseragen/"]')` | css | satu-satunya aksi |
| SCR-14 | Teks kosong | `getByText('Tidak Ada Data yang tersedia')` | text | |
| SCR-15 | Detail | `getByText('DETAIL SUB USER')`; teks "Nama Agen : …", "Nama Sub User", "Email", "Nomor Whatsapp", "Bagian Staff", "Hak Akses", "Status User" | TIDAK STABIL | link KEMBALI |

## Ringkasan harvest

- Layar dipetakan: 19 layar/varian (Pusat) + 12 (Cabang); di-skip: 1 (Detail Sub User Agen pada Cabang — tidak ada data).
- Elemen unik area utama (tanpa sidebar/header): ±420 (218 di antaranya checkbox hak akses ber-id semantik).
- Stabil (id/role/label): ±395. Tidak stabil (id duplikat per baris, teks detail tanpa id, badge header): ±25.

## Rekomendasi data-testid untuk developer

| Layar | Elemen | Usulan data-testid |
|---|---|---|
| SCR-01/05/09 | Tombol aksi baris Lihat/Edit/Hapus | `hakakses-row-view-<id>`, `hakakses-row-edit-<id>`, `hakakses-row-delete-<id>` (dan `subuser-…`, `petugas-…`) — ganti id duplikat `select_golongan`/`delete_golongan`/`delete_Petugas` |
| SCR-01/05/09/12/14 | Tombol submit Filter vs toggle Filter | `filter-toggle`, `filter-submit`, `filter-reset` |
| SCR-03/07/11/13/15 | Nilai field detail | `detail-<field>` (mis. `detail-total-hak-akses`) |
| SCR-06/08/10/11 | Tautan Ganti kata sandi, tombol Batal (link+button ganda) | `ganti-sandi`, `form-cancel` |
| SweetAlert | Tombol Ya/Batal/Hapus | `swal-confirm`, `swal-cancel` |
| Header | Badge jenis akun, nama user | `header-account-type`, `header-user-name` |
