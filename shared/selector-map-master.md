# Selector Map — Modul OP-11 Master (portal Operator `/partner`)

Disusun dari `scenario/master/master_ui-inventory.md` (eksplorasi READ-ONLY 27 September 2026, `browser_evaluate`
atas DOM tiap layar — **bukan** hasil `/harvest-selectors` formal; jalankan skrip itu di kemudian hari bila
dibutuhkan sumber selector yang lebih tervalidasi). Elemen login/header/sidebar/SweetAlert/popover/pagination yang
dipakai bersama seluruh portal Operator ada di `shared/selector-map-partner-common.md` (tidak diulang di sini,
kecuali menu sidebar grup MASTER).

Tidak ada `data-testid` di aplikasi ini. Prioritas selector yang dipakai: id stabil → role+name → css scoping
per-baris → teks (tanpa id, ditandai TIDAK STABIL). **Id tombol aksi baris (`select_kapal`, `delete_kapal`,
`select_golongan`, `delete_golongan`, `select_crew`, `delete_crew`) dipakai ULANG lintas beberapa daftar** (mis.
`select_kapal`/`delete_kapal` juga dipakai tombol Edit/Hapus di Master Trayek, bukan hanya Master Kapal — FND-M-06,
analog FND-06 pada OP-21) — **jangan** pakai `#id` sebagai selector baris, selalu scoping lewat `tr` baris tabel
terkait terlebih dahulu.

Menu sidebar grup **MASTER**: `getByText('MASTER', {exact:true})` (toggle collapsible), 10 submenu:
`a[href$="/partner/masterkelasnew"]`, `a[href$="/partner/mastergolongan"]`, `a[href$="/partner/mkapal"]`,
`a[href$="/partner/DaftarTrayek"]`, `a[href$="/partner/masterharga"]`, `a[href$="/partner/tarifpass"]`,
`a[href$="/partner/masterasuransi"]`, `a[href$="/partner/MasterCrew"]`, `a[href$="/partner/masterdenda"]`,
`a[href$="/partner/informasi_show"]`.

Pola umum semua daftar: tabel dirender AJAX ("Mohon tunggu sebentar" lalu terisi), tombol Filter (`#btn-filter`,
toggle), dropdown jumlah baris (`#valuelimit`), tombol Reset. Aksi per baris dominan `<button class="btn-edit">` /
`<button class="btn-delete">` (SweetAlert2 konfirmasi via `shared/selector-map-partner-common.md`); beberapa
submodul menambah `<a class="btn-viewnya">`.

## SCR-01 Daftar Master Kelas & SCR-02 Tambah Kelas & SCR-03 Edit Kelas (modal)

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-01 | Tombol toggle Filter | `#btn-filter` | id | |
| SCR-01 | Link Tambah Kelas | `getByRole('link', { name: 'Tambah Kelas' })` | role | href `/partner/tambahkelas` |
| SCR-01 | Filter Nama Kelas | `input[name="nama_kelas"]` | css | |
| SCR-01 | Tabel daftar | `table tbody tr` | css | kolom No, Nama Kelas, Aksi |
| SCR-01 | Aksi Edit (per baris) | `row.locator('.btn-edit')` | css | id `select_golongan`? — ui-inventory tidak menegaskan id spesifik utk Kelas, buka modal SCR-03; scoping via `tr` |
| SCR-01 | Aksi Hapus (per baris) | `row.locator('.btn-delete')` | css | id `delete_kelas` — **cek duplikasi id lintas baris sebelum dipakai sebagai selector tunggal** |
| SCR-01 | Alert data dipakai (M-01) | `.swal2-popup` title "Data Digunakan di Master Kapal" | css | REQ-001, dikonfirmasi live 27 Sep 2026 |
| SCR-02 | Input Nama Kelas (baris ke-n) | `#nama0`, `#nama1`, ... | id | placeholder "Masukkan Kelas"; `name="nama[]"` |
| SCR-02 | Tombol Tambah Baris Input | `#add_menu` | id | menambah baris `nama1`, `nama2`, ... |
| SCR-02 | Tombol Simpan | `#submit_kelas` | id | Simpan kosong = silent, tidak ada request (FND-M-01) |
| SCR-03 (modal) | Hidden id kelas | `#id_kelas`, `#id_kelas_edit` | id | |
| SCR-03 (modal) | Input Nama (prefill) | `#nama`, `#nama_kelas_edit` | id | |
| SCR-03 (modal) | Hidden nama lama | `#nama_lama`, `#nama_lama_kelas_edit` | id | dipakai validasi backend |
| SCR-03 (modal) | Tombol Batal | `.close2` | css | |
| SCR-03 (modal) | Tombol Simpan | `#btn_update_kelas` | id | |

## SCR-04 Daftar Master Golongan & SCR-05 Tambah Golongan & SCR-06 Edit Golongan (modal)

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-04 | Filter Nama | `#nama_golongan` | id | `name=nama` — id dipakai ulang lintas modul (mis. OP-21 filter Sub User juga `#nama_golongan`), scoping ke form/halaman ini |
| SCR-04 | Filter Jenis Tiket | `#ParentIDnya` | id | |
| SCR-04 | Filter Golongan Kendaraan | `#golongan_kendaraan` | id | |
| SCR-04 | Filter Bonus Tiket | `#bonus_tiket` | id | |
| SCR-04 | Filter Kondisi Kendaraan | `#muatan_barang` | id | |
| SCR-04 | Filter Status Aktif | `#status` | id | |
| SCR-04 | Tabel daftar | `table tbody tr` | css | kolom No, Nama Golongan Tiket, Jenis Tiket, Golongan Kendaraan, Bonus Tiket, Kondisi Kendaraan, Status Aktif, Aksi |
| SCR-04 | Aksi Edit (per baris) | `row.locator('.btn-edit')` | css | id `select_golongan` DUPLIKAT lintas baris — TIDAK STABIL sebagai `#id` |
| SCR-04 | Aksi Hapus (per baris) | `row.locator('.btn-delete')` | css | id `delete_golongan` DUPLIKAT |
| SCR-05 | Jenis Tiket (baris ke-n) | `#jenis1`, ... | id | `select[name="ParentID[]"]`; opsi Penumpang/Kendaraan/Bagasi Kendaraan/Bagasi Penumpang |
| SCR-05 | Nama Golongan Tiket | `input[name="nama[]"]` | css | |
| SCR-05 | Status Aktif | `#muncul1`, ... | id | `select[name="muncul[]"]`; opsi `UMUM`="Semua Channel", `CABANG`="Hanya Cabang" (REQ-005) |
| SCR-05 | Tombol Tambah Baris Input | `#add_menu` | id | |
| SCR-05 | Tombol Simpan | `#submit_golongan` | id | Simpan kosong = silent (FND-M-01) |
| SCR-06 (modal) | Hidden id golongan | `#id_golongan_edit` | id | |
| SCR-06 (modal) | Input Nama (prefill) | `#nama`, `#nama_golongan_edit` | id | |
| SCR-06 (modal) | Hidden nama lama | `#nama_lama` | id | |
| SCR-06 (modal) | Select Golongan Penumpang | `#golongan_penumpang` | id | |
| SCR-06 (modal) | Select Jenis Tiket (edit) | `#ParentID`, `#ParentID_golongan` | id | |
| SCR-06 (modal) | Select Jenis Kendaraan | `#jenis_kendaraan` | id | |
| SCR-06 (modal) | Bonus Tiket (number) | `#bonus_tiket`, `#bonus_tiket_golongan` | id | |
| SCR-06 (modal) | Checkbox Kondisi Kendaraan | `#muatan`, `#muatan-edit` | id | |
| SCR-06 (modal) | Select Status Aktif (edit) | `#muncul` | id | |

## SCR-07 Daftar Master Kapal & SCR-08 Tambah Kapal & SCR-09 Edit Kapal

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-07 | Filter Nama Kapal | `#namanya` | id | select |
| SCR-07 | Filter Call Sign | `#call_signnya` | id | |
| SCR-07 | Filter Kapasitas | `#kapasitas` | id | id sama dengan field form SCR-08 — scoping per halaman |
| SCR-07 | Tabel daftar | `table tbody tr` | css | kolom No, Nama Kapal, Call Sign, Kapasitas Penumpang, Aksi |
| SCR-07 | Aksi Edit (per baris) | `row.locator('.btn-edit')` | css | id `select_kapal` DUPLIKAT (dipakai ulang di Master Trayek juga — FND-M-06); navigasi route SCR-09, bukan modal |
| SCR-07 | Aksi Hapus (per baris) | `row.locator('.btn-delete')` | css | id `delete_kapal` DUPLIKAT (idem FND-M-06) |
| SCR-08 | Nama Kapal | `#nama_kapal` | id | label `*`, atribut `required=false` (FND-M-03) |
| SCR-08 | Call Sign | `#kode_kapal` | id | idem |
| SCR-08 | Kapasitas Penumpang | `#kapasitas` | id | `type=number`, idem |
| SCR-08 | Kelas Yang Tersedia (multi) | `select[name="kelas[]"]` | css | opsi berasal dari Master Kelas (REQ-008), idem FND-M-03 |
| SCR-08 | Tombol Simpan | `getByRole('button', { name: 'Simpan' })` | role | TANPA id eksplisit; Simpan kosong = silent (FND-M-01) |
| SCR-09 | Tombol Batal | `#button-batal` | id | route terpisah `/partner/edit_kapal/<base64Id>`, field sama dengan SCR-08 (prefilled) |

## SCR-10 Daftar Master Trayek & SCR-11 Tambah Trayek

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-10 | Filter Tanggal | `#Tanggal` | id | |
| SCR-10 | Filter Nama Trayek | `#nama_trayek_filter` | id | |
| SCR-10 | Filter Pelabuhan Digunakan | `#pelabuhan_digunakan` | id | select |
| SCR-10 | Tabel daftar | `table tbody tr` | css | kolom Tanggal Buat, Nama Trayek, Pelabuhan Digunakan, Aksi |
| SCR-10 | Aksi Lihat (per baris) | `row.locator('a.btn-viewnya')` | css | toggle collapse `.col<id>` — isi KOSONG (FND-M-04) |
| SCR-10 | Aksi Edit (per baris) | `row.locator('.btn-edit')` | css | berbagi id dengan Kapal (`select_kapal`) — FND-M-06, TIDAK STABIL sebagai `#id` |
| SCR-10 | Aksi Hapus (per baris) | `row.locator('.btn-delete')` | css | berbagi id dengan Kapal (`delete_kapal`) — FND-M-06 |
| SCR-11 | Nama Trayek | `#nama_trayek` | id | label `*` |
| SCR-11 | Pilih Pelabuhan (multi) | `select[name="port[]"]` | css | id `#port`; label `*` |
| SCR-11 | Pelabuhan Asal (baris ke-n) | `#port_asal1`, ... | id | `select[name="polid"]`; label `*` |
| SCR-11 | Pelabuhan Tujuan (baris ke-n) | `#port_tujuan1`, ... | id | `select[name="podid"]`; label `*` |
| SCR-11 | Konsumsi Penumpang (baris ke-n) | `#konsumsi1`, ... | id | `select[name="konsumsiid"]`; TIDAK bertanda `*` (P495) |
| SCR-11 | Tombol Tambah Baris Input | `#add_menu` | id | |
| SCR-11 | Tombol Simpan | `getByRole('button', { name: 'Simpan' })` | role | tanpa id eksplisit dicatat di ui-inventory; Simpan kosong = silent (FND-M-01) |

## SCR-12 Daftar Master Harga, SCR-13 Lihat Harga, SCR-14 Tambah Harga, SCR-14b Riwayat Harga

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-12 | Filter Tanggal | `#Tanggal` | id | |
| SCR-12 | Filter Nama Trayek | `#nama_harga_filter` | id | |
| SCR-12 | Filter Pelabuhan asal/tujuan | `#pol`, `#pod` | id | |
| SCR-12 | Tabel daftar (per trayek) | `table tbody tr` | css | kolom Tanggal Buat, Nama Trayek, Rute, Aksi |
| SCR-12 | Aksi Lihat Harga (per baris) | `row.locator('a.btn-view.lihatharga')` | css | navigasi ke SCR-13 |
| SCR-12 | Aksi Hapus Harga (per baris) | `row.locator('.btn-delete.hapusHarga')` | css | REQ-022 |
| SCR-13 | Tabel harga per golongan | `table tbody tr` | css | kolom Tanggal Buat, Jenis Tiket, Golongan Tiket, Kelas Tiket, Harga, Mulai Berlaku, Kondisi Kendaraan; baris duplikat kombinasi ditandai merah (REQ-019, verifikasi via CSS class/warna) |
| SCR-13 | Tombol header Tambah Harga | `getByRole('link', { name: 'Tambah Harga' })` atau tombol setara | role/css | kembali ke alur SCR-14 |
| SCR-13 | Tombol header Riwayat Harga | `getByRole('link', { name: 'Riwayat Harga' })` | role | menuju SCR-14b |
| SCR-13 | Aksi Edit (per baris, modal) | `row.locator('.btn-edit')` | css | hidden `#iddetailharga`; select `#ParentID`/`#Edit_ParentID`, `#GolonganID`/`#Edit_Golongan`, `#KelasID`/`#Edit_Kelas`; text `#harga`/`#Edit_Harga`, `#tgl_berlaku`/`#Edit_tgl_berlaku`; checkbox; select `#muatan` |
| SCR-13 | Aksi Hapus (per baris) | `row.locator('.hapusHarga')` | css | Q-M-03: hapus baris di modal Edit lalu klik Batal dilaporkan tetap terhapus (P508) |
| SCR-14 | Pilih Trayek (langkah 1) | `#trayek` | id | |
| SCR-14 | Pilih Rute (langkah 1) | `#rute` | id | terisi setelah Trayek dipilih |
| SCR-14 | Konsumsi (langkah 1, readonly) | `#konsumsi` | id | disabled, terisi otomatis |
| SCR-14 | Tombol Tambahkan | `getByRole('button', { name: 'Tambahkan' })` | role | memunculkan langkah 2 (VAL-005) |
| SCR-14 | Jenis Tiket (langkah 2, baris ke-n) | `#jenis1`, ... | id | `select[name="ParentID[]"]` |
| SCR-14 | Golongan (langkah 2) | `#golongan1`, ... | id | `select[name="golongan[]"]` |
| SCR-14 | Kelas (langkah 2) | `#kelas1`, ... | id | `select[name="kelas[]"]` |
| SCR-14 | Harga (langkah 2) | `#harga1`, ... | id | `input[name="harga[]"]` |
| SCR-14 | Mulai Berlaku (langkah 2) | `#tgl_berlaku1`, ... | id | `input[name="tgl_berlaku[]"]` |
| SCR-14 | Kondisi Kendaraan (langkah 2) | `#muatan1`, ... | id | `select[name="muatan[]"]` |
| SCR-14 | Tombol Tambah Baris Input | `getByRole('button', { name: 'Tambah Baris Input' })` | role | |
| SCR-14 | Tombol Simpan / Batal | `getByRole('button', { name: 'Simpan' })` / `{ name: 'Batal' }` | role | Simpan kosong (langkah 2) = silent (FND-M-01) |
| SCR-14b | Tabel Riwayat Harga | `table tbody tr` | css | kolom sama SCR-13 + kolom **Status** (REQ-023) |

## SCR-15 Daftar Tarif Pass, SCR-16 Tambah, SCR-17 Detail, SCR-18 Edit

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-15 | Tombol toggle Filter | `#btn-filter` | id | |
| SCR-15 | Link Buat Harga | `getByRole('link', { name: 'Buat Harga' })` | role | menuju SCR-16 |
| SCR-15 | Tabel daftar | `table tbody tr` | css | kolom Tanggal Buat, Nama Trayek, Rute, Konsumsi, Aksi |
| SCR-15 | Aksi Detail (per baris) | `row.locator('a.btn-viewnya')` | css | menuju SCR-17 |
| SCR-15 | Aksi Edit (per baris) | `row.locator('.btn-edit_')` | css | title "Edit Harga Pass"; menuju SCR-18 |
| SCR-15 | Aksi Hapus (per baris) | `row.locator('.hapusHarga')` | css | title "Hapus Harga Pass" (REQ-026) |
| SCR-16 | Pilih Trayek / Rute / Konsumsi | `#trayek`, `#rute`, `#konsumsi` | id | alur 2 langkah identik SCR-14 (VAL-006) |
| SCR-16 | Tombol Tambahkan | `getByRole('button', { name: 'Tambahkan' })` | role | memunculkan field rekomendasi harga (REQ-027) |
| SCR-17 | Tabel Tiket Penumpang | `table` (Dewasa/Anak/Bayi × Tarif Pass Rp.) | css | read-only |
| SCR-17 | Tabel Tiket Kendaraan | `table` (9–12 golongan × Tarif Pass Rp.) | css | read-only |
| SCR-18 | Input tiap sel (contoh) | `#gol_dewasa`, `#gol_kendaraanAnak`, `#gol_bayi`, `#gol_kendaraanGolongan I (Sepeda Pancal)`, dst. | id | id BERBEDA per baris/kolom — daftar lengkap di `master_ui-inventory.md` SCR-18; berisiko banyak, jangan disimpan tanpa izin bila menyentuh data produksi |
| SCR-18 | Tombol Simpan / Batal | `#simpan` / `#button-batal` | id | |

## SCR-19 Daftar Master Asuransi, SCR-20 Detail, SCR-21 Setting (di luar cakupan rule)

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-19 | Tombol toggle Filter | `#btn-filter` | id | TIDAK ada tombol Tambah (entri otomatis mengikuti Trayek) |
| SCR-19 | Tabel daftar | `table tbody tr` | css | kolom Nama Trayek, Rute, Konsumsi, Aksi |
| SCR-19 | Aksi Detail (per baris) | `row.locator('.show_.btn-edit')` | css | title "Detail Asuransi" → SCR-20 |
| SCR-19 | Aksi Setting (per baris) | title "Setting Asuransi" | css | → SCR-21 |
| SCR-20/21 | Tabel Tiket Penumpang/Kendaraan | `table` | css | SCR-20 read-only, SCR-21 input text per sel |
| SCR-21 | Tombol Simpan / Batal | `#simpan` / `#button-batal` | id | tidak disentuh (di luar cakupan rule, berisiko menulis data bersama) |

## SCR-22 Daftar Master Crew & SCR-23 Tambah Crew

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-22 | Tombol toggle Filter | `#btn-filter` | id | |
| SCR-22 | Link Tambah Crew | `getByRole('link', { name: 'Tambah Crew' })` | role | menuju SCR-23 |
| SCR-22 | Tabel daftar | `table tbody tr` | css | kolom No, Nama Awak Kapal, Jenis Kelamin, Tanggal Lahir, No. Buku Pelaut, Jabatan, Kode Pelaut, Sertifikat Ijazah Pelaut, Aksi |
| SCR-22 | Aksi Lihat (per baris) | `row.locator('a.btn-viewnya')` | css | toggle collapse `.col<id>` — isi KOSONG (FND-M-04) |
| SCR-22 | Aksi Edit (per baris) | `row.locator('.btn-edit')` | css | title "Edit Crew", id `select_crew` — cek duplikasi sebelum dipakai sebagai `#id` |
| SCR-22 | Aksi Hapus (per baris) | `row.locator('.btn-delete')` | css | title "Hapus Crew", id `delete_crew` — idem |
| SCR-23 | Nama (baris ke-n) | `input[name="nama[]"]` | css | bertanda `*` |
| SCR-23 | Jenis Kelamin | `select[name="gender[]"]` | css | TIDAK bertanda `*` di DOM meski header tabel ada tandanya (inkonsistensi kecil, dicatat) |
| SCR-23 | Tanggal Lahir | `input[name="tgl_lahir[]"]` | css | bertanda `*` |
| SCR-23 | No. Buku Pelaut | `input[name="buku_pelaut[]"]` | css | bertanda `*` |
| SCR-23 | Tgl Berakhir Buku Pelaut | `input[name="exp_buku_pelaut[]"]` | css | bertanda `*` |
| SCR-23 | Kode Pelaut | `input[name="kode_pelaut[]"]` | css | bertanda `*` |
| SCR-23 | Jabatan | `input[name="jabatan[]"]` | css | bertanda `*` |
| SCR-23 | No. PKL | `input[name="no_pkl[]"]` | css | bertanda `*` |
| SCR-23 | Tanggal Sign On | `input[name="tgl_sign_on[]"]` | css | bertanda `*` |
| SCR-23 | Kebangsaan | `input[name="kewarganegaraan[]"]` | css | TIDAK bertanda `*` |
| SCR-23 | Sertifikat Ijazah Pelaut | `input[name="sertifikat[]"]` | css | bertanda `*` |
| SCR-23 | No. Sertifikat | `input[name="no_sertifikat[]"]` | css | bertanda `*` |
| SCR-23 | Tombol Tambah Baris Input | `#add_menu` | id | |
| SCR-23 | Tombol Simpan | `#submit_crew` | id | Simpan kosong = silent (FND-M-01); **id ini dipakai ULANG di Master Informasi (SCR-27)** |

## SCR-24 Daftar Denda Pembatalan & SCR-25 Setting Denda (modal)

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-24 | Tabel daftar | `table tbody tr` | css | TIDAK ada tombol Tambah (P525); persis 3 baris tetap: Rusak, Batal, Hangus; kolom Nama Denda, Trigger By, Range Waktu, Denda, Aksi |
| SCR-24 | Tombol Setting (per baris) | `row.locator('.tombol_setting_modal')` | css | Cabang: tooltip `data-original-title="Hanya bisa dilakukan oleh kantor pusat"`, klik tidak membuka modal (P540) |
| SCR-25 (modal) | Jenis Denda (readonly) | `#nama_edit` | id | text |
| SCR-25 (modal) | Hidden id | `#id_edit` | id | |
| SCR-25 (modal) | Trigger By (readonly) | `#trigger_by_edit` | id | text |
| SCR-25 (modal) | Range Waktu + satuan Jam | `#range_waktu_edit` | id | text/number |
| SCR-25 (modal) | Jenis Denda (Rupiah/Persentase) | `#pilihan_denda_edit` | id | select |
| SCR-25 (modal) | Jumlah Denda | `#jumlah_denda_edit` | id | text/number; Hangus: default 100%, status disabled BELUM DIPASTIKAN (REQ-042, verifikasi di SCN-0029) |
| SCR-25 (modal) | Catatan statis (M-04) | teks "*) Denda pembatalan tiket agen sebelum cetak tiket : Rp. 0" | TIDAK STABIL (teks) | P529 |
| SCR-25 (modal) | Tombol Batal / Simpan | `getByRole('button', { name: 'Batal' })` / `{ name: 'Simpan' }` | role | **JANGAN klik Simpan tanpa izin eksplisit user** (REQ-039/040/043 menulis setting tenant) |

## SCR-26 Daftar Master Informasi & SCR-27 Tambah Informasi

| SCR | Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|---|
| SCR-26 | Tombol toggle Filter | `#btn-filter` | id | |
| SCR-26 | Link Tambah Informasi | `getByRole('link', { name: 'Tambah Informasi' })` | role | menuju SCR-27 |
| SCR-26 | Tabel daftar | `table tbody tr` | css | kolom No, Tanggal Buat, Judul Informasi, Berlaku Sampai, Aksi — KOSONG saat harvest (lihat catatan di bawah) |
| SCR-27 | Judul Informasi | `#nama1` | id | placeholder "Masukkan Judul Informasi", `maxlength=100`; **id `nama1` berpotensi duplikat dengan field tanggal pada halaman ini** (FND-M-06 gaya OP-21) — verifikasi keunikan sebelum eksekusi, gunakan `placeholder` sebagai fallback |
| SCR-27 | Berlaku Sampai | `input[placeholder="DD/MM/YYYY"]` | css | date picker, default tanggal hari ini (REQ-049) |
| SCR-27 | Isi Informasi | `textarea[placeholder="Masukkan Isi Informasi"]` | css | `maxlength=350` |
| SCR-27 | Tombol Simpan | `#submit_crew` | id | id sisa template, SAMA dengan Master Crew (SCR-23); Simpan kosong = silent (FND-M-01) |
| SCR-27 | Tombol Batal | `#button-batal` | id | |

## Rekomendasi data-testid untuk developer

| Layar | Elemen | Usulan data-testid |
|---|---|---|
| SCR-01/04/07/10/22 | Tombol aksi baris Edit/Hapus (id duplikat lintas modul: `select_kapal`/`delete_kapal` di Kapal **dan** Trayek; `select_golongan`/`delete_golongan`; `select_crew`/`delete_crew`) | `master-row-edit-<modul>-<id>`, `master-row-delete-<modul>-<id>` — hilangkan berbagi id lintas submodul (FND-M-06) |
| SCR-01/04/07/10/12/15/19/22/26 | Tombol submit Filter vs toggle Filter | `filter-toggle`, `filter-submit`, `filter-reset` |
| SCR-03/07/13/17/20 | Nilai field detail tanpa id (Nama, Deskripsi, Tanggal Buat/Diperbarui, Total, dsb.) | `detail-<field>` |
| SCR-02/05/08/11/14/16/23/27 | Tombol Simpan pada form Tambah (banyak tanpa id eksplisit: Kapal, Trayek; beberapa id sisa template: `#submit_kelas`, `#submit_golongan`, `#submit_crew` dipakai ulang di Informasi) | `form-submit-<modul>` — satu id unik per form, bukan dipakai ulang lintas modul |
| SCR-02/05/08/11/14/16/23 | Tombol Tambah Baris Input | `add-row-<modul>` |
| SCR-10/22 | Aksi "Lihat" (panel collapse kosong, FND-M-04) | `viewnya-<modul>-<id>` + pastikan konten collapse benar-benar terisi data |
| SCR-08 | Ketidaksesuaian label `*` vs `required` (FND-M-03) | Tambahkan `required` sungguhan pada elemen DOM, atau hapus tanda `*` bila memang opsional |
| SCR-02/05/08/11/14/23/27 | Simpan dengan field kosong tidak memberi feedback (FND-M-01) | Tambahkan validasi client-side (popover/alert) konsisten dengan pola modul OP-21 (`zemPopover`), alih-alih silent no-op |
| SCR-27 | Alert batas karakter (kemungkinan unreachable, FND-M-02) | `char-limit-alert-judul`, `char-limit-alert-isi`; pastikan event `paste` juga memicu pesan, bukan hanya mengandalkan `maxlength` |
| SweetAlert | Tombol Ya/Batal/Hapus | `swal-confirm`, `swal-cancel` (sama seperti OP-21) |
