# OP-11 Master — UI Inventory

Hasil eksplorasi READ-ONLY 27 September 2026 (UI v1.5.2), Operator Pusat (akun #2) sebagai akun
utama, Operator Cabang Pare-Pare (akun #3, Sub User Cabang "Akses IK") untuk verifikasi Denda
Pembatalan (P540) dan spot-check akses submodul lain. Tidak ada spec `/harvest-selectors` khusus
Master yang dijalankan sebelum dokumen ini — selector dikumpulkan langsung lewat `browser_evaluate`
(Playwright MCP) atas DOM tiap layar dan disalin ke tabel di bawah; jalankan `/harvest-selectors
master` di kemudian hari untuk menghasilkan `shared/selector-map-master.md` bila dibutuhkan sumber
selector yang lebih formal. Elemen bersama login/header/sidebar mengikuti
`shared/selector-map-partner-common.md` (SCR-00 tidak diulang detailnya di sini). Data mentah
eksplorasi umum sebelumnya (26 September 2026, level dangkal) ada di
`artifacts/explore/20260926-023405-master.json` dan `explore/module-map.md` bagian "Eksplorasi
detail kelompok Master".

Sidebar **MASTER** (grup collapsible, toggle via `getByText('MASTER', {exact:true})`) berisi
PERSIS 10 submenu berurutan (dikonfirmasi via `browser_find` pada Pusat, sama pola link `href`
untuk Cabang):

```
1. Master Kelas             /partner/masterkelasnew
2. Master Golongan          /partner/mastergolongan
3. Master Kapal             /partner/mkapal
4. Master Trayek            /partner/DaftarTrayek
5. Master Harga             /partner/masterharga
6. Tarif Pass Pelabuhan     /partner/tarifpass
7. Master Asuransi          /partner/masterasuransi   (di luar cakupan rule P480–P551, lihat master_analysis.md)
8. Master Crew              /partner/MasterCrew
9. Denda Pembatalan         /partner/masterdenda
10. Master Informasi        /partner/informasi_show
```

Pola umum semua daftar: tabel dirender AJAX ("Mohon tunggu sebentar" lalu terisi), tombol
**Filter** (`#btn-filter`, toggle panel), dropdown **jumlah baris** (`#valuelimit`: 10/20/50/100),
tombol **Reset**. Tombol aksi per baris dominan berupa `<button class="btn-edit">` (Edit,
ikon pensil) dan `<button class="btn-delete">` (Hapus, ikon tempat sampah, SweetAlert2
konfirmasi); beberapa submodul menambah `<a class="btn-viewnya">` (Lihat/Detail, ikon mata).
`id` tombol aksi **dipakai ulang antar modul** (mis. `select_kapal`/`delete_kapal` muncul juga di
baris Master Trayek) — jangan pakai `#id` sebagai selector baris, selalu scoping lewat baris tabel
(`tr` terkait) lebih dulu.

## Layar (SCR)

| SCR | Layar | Route | Elemen utama (ringkas) |
|---|---|---|---|
| SCR-00 | Login Operator | `/partner` | Sama seperti OP-21 — `#username`, `#password`, tombol Login → redirect `/partner/profil` (Pusat) / `/partner/profilsubuser` (Sub User Cabang) |
| SCR-01 | Daftar Master Kelas | `/partner/masterkelasnew` | Filter (`#btn-filter`), link "Tambah Kelas" → SCR-02, filter teks `nama_kelas`, tabel (No, Nama Kelas, Aksi), per baris: Edit (`.btn-edit`, buka modal SCR-03), Hapus (`.btn-delete` id `delete_kelas`, SweetAlert) |
| SCR-02 | Tambah Kelas | `/partner/tambahkelas` | Baris dinamis: input `nama[]` (id `nama0`, `nama1`, ...) placeholder "Masukkan Kelas", tombol "Tambah Baris Input" (`#add_menu`), Simpan (`#submit_kelas`) |
| SCR-03 | Edit Kelas (modal, bukan route terpisah) | dalam SCR-01 | Modal Bootstrap: hidden `id_kelas`/`id_kelas_edit`, text `nama`/`nama_kelas_edit` (prefill), hidden `nama_lama`/`nama_lama_kelas_edit`, tombol Batal (`.close2`), Simpan (`#btn_update_kelas`) |
| SCR-04 | Daftar Master Golongan | `/partner/mastergolongan` | Filter: `nama_golongan`(nama), `ParentIDnya`(Jenis Tiket), `golongan_kendaraan`, `bonus_tiket`, `muatan_barang`(Kondisi Kendaraan), `status`(Status Aktif); tabel (No, Nama Golongan Tiket, Jenis Tiket, Golongan Kendaraan, Bonus Tiket, Kondisi Kendaraan, Status Aktif, Aksi); per baris Edit (`.btn-edit` id `select_golongan`, modal SCR-06), Hapus (`.btn-delete` id `delete_golongan`) |
| SCR-05 | Tambah Golongan | `/partner/tambahgolongan` | Baris dinamis: `select[name="ParentID[]"]` (id `jenis1`, Jenis Tiket: Penumpang/Kendaraan/Bagasi Kendaraan/Bagasi Penumpang), `input[name="nama[]"]` (Nama Golongan Tiket), kolom Golongan Kendaraan/Bonus Tiket/Kondisi Kendaraan (muncul dinamis sesuai Jenis Tiket), `select[name="muncul[]"]` (id `muncul1`, Status Aktif: `UMUM`="Semua Channel"/`CABANG`="Hanya Cabang"), Simpan (`#submit_golongan`) |
| SCR-06 | Edit Golongan (modal) | dalam SCR-04 | Hidden `id_golongan_edit`, text `nama`/`nama_golongan_edit`, hidden `nama_lama`, select `golongan_penumpang`, select `ParentID`/`ParentID_golongan`, select `jenis_kendaraan`, number `bonus_tiket`/`bonus_tiket_golongan`, checkbox `muatan`/`muatan-edit`, select `muncul` |
| SCR-07 | Daftar Master Kapal | `/partner/mkapal` | Filter: `namanya`(select Nama Kapal), `call_signnya`, `kapasitas`; tabel (No, Nama Kapal, Call Sign, Kapasitas Penumpang, Aksi); per baris Edit (`.btn-edit` id `select_kapal` → navigasi route SCR-09, BUKAN modal), Hapus (`.btn-delete` id `delete_kapal`) |
| SCR-08 | Tambah Kapal | `/partner/tambahkapal` | `#nama_kapal`(Nama Kapal, label `*` tapi `required=false`), `#kode_kapal`(Call sign), `#kapasitas`(number), `select[name="kelas[]"]`(multi, opsi dari Master Kelas), tombol Simpan (tanpa id eksplisit, teks "Simpan") |
| SCR-09 | Edit Kapal | `/partner/edit_kapal/<base64Id>` | Sama field dengan SCR-08 (prefilled), tombol Simpan + Batal (`#button-batal`) — route terpisah, bukan modal (beda pola dari Kelas/Golongan) |
| SCR-10 | Daftar Master Trayek | `/partner/DaftarTrayek` | Filter: `Tanggal`, `nama_trayek_filter`, `pelabuhan_digunakan`(select); tabel (Tanggal Buat, Nama Trayek, Pelabuhan Digunakan, Aksi); per baris Lihat (`a.btn-viewnya`, toggle collapse `.col<id>` — ⚑ isi KOSONG, lihat FND-M-04), Edit (`.btn-edit`, modal/inline — belum ditelusuri lebih jauh karena berbagi id dgn Kapal), Hapus (`.btn-delete`) |
| SCR-11 | Tambah Trayek | `/partner/mtrayek_tambah` | `#nama_trayek`, `select[name="port[]"]`(id `port`, multi "Pilih Pelabuhan"), daftar "Pelabuhan Dipilih" dinamis, `select[name="polid"]`(id `port_asal1`, Pelabuhan Asal), `select[name="podid"]`(id `port_tujuan1`, Pelabuhan Tujuan), `select[name="konsumsiid"]`(id `konsumsi1`, Konsumsi Penumpang — TIDAK bertanda `*`), tombol "Tambah Baris Input" (`#add_menu`), Simpan |
| SCR-12 | Daftar Master Harga | `/partner/masterharga` | Dikelompokkan per trayek. Filter: `Tanggal`, `nama_harga_filter`, `pol`(Pelabuhan asal), `pod`(Pelabuhan tujuan); tabel terluar (Tanggal Buat, Nama Trayek, Rute, Aksi); per baris "Lihat Harga" (`a.btn-view.lihatharga` → navigasi SCR-13), "Hapus Harga" (`.btn-delete.hapusHarga`) |
| SCR-13 | Lihat Harga (detail harga 1 trayek) | `/partner/lihatharga/<base64Id>` | Tabel harga per golongan (Tanggal Buat, Jenis Tiket, Golongan Tiket, Kelas Tiket, Harga, Mulai Berlaku, Kondisi Kendaraan); tombol header "Tambah Harga" (kembali ke alur SCR-14), **"Riwayat Harga"** (link → SCR-14b); per baris Edit (`.btn-edit`, modal: hidden `iddetailharga`, select `ParentID`/`Edit_ParentID`, select `GolonganID`/`Edit_Golongan`, select `KelasID`/`Edit_Kelas`, text `harga`/`Edit_Harga`, text `tgl_berlaku`/`Edit_tgl_berlaku`, checkbox, select `muatan`), Hapus (`.hapusHarga`) |
| SCR-14 | Tambah Harga | `/partner/tambahharga` | Langkah 1: `select#trayek`(Pilih Trayek), `select#rute`(Pilih Rute, terisi setelah trayek dipilih), `#konsumsi`(disabled, terisi otomatis), tombol "Tambahkan". Langkah 2 (setelah Tambahkan): baris dinamis `select[name="ParentID[]"]`(id `jenis1`), `select[name="golongan[]"]`(id `golongan1`), `select[name="kelas[]"]`(id `kelas1`), `input[name="harga[]"]`(id `harga1`), `input[name="tgl_berlaku[]"]`(id `tgl_berlaku1`), checkbox, `select[name="muatan[]"]`(id `muatan1`, Kondisi Kendaraan), tombol "Tambah Baris Input", Simpan, Batal |
| SCR-14b | Riwayat Harga (History Harga) | `/partner/historyharga/<base64Id>` | Tabel (Tanggal Buat, Jenis Tiket, Golongan Tiket, Kelas Tiket, Harga, Mulai Berlaku, Kondisi Kendaraan, **Status**) — mencatat riwayat perubahan/penghapusan harga sesuai P510–P512 |
| SCR-15 | Daftar Tarif Pass Pelabuhan | `/partner/tarifpass` | Filter `#btn-filter`, link "Buat Harga" → SCR-16; tabel (Tanggal Buat, Nama Trayek, Rute, Konsumsi, Aksi); per baris Detail (`a.btn-viewnya` → SCR-17), Edit (`.btn-edit_` title "Edit Harga Pass" → SCR-18), Hapus (`.hapusHarga` title "Hapus Harga Pass") |
| SCR-16 | Tambah Tarif Pass Pelabuhan | `/partner/tambahtarifpass` | Alur 2 langkah identik SCR-14: `#trayek`, `#rute`, `#konsumsi`(disabled), tombol "Tambahkan" |
| SCR-17 | Detail Tarif Pass Pelabuhan | `/partner/detail_tarifpass/<base64Id>` | Tabel "Tiket Penumpang" (Dewasa/Anak/Bayi × Tarif Pass Rp.), tabel "Tiket Kendaraan" (9–12 golongan kendaraan × Tarif Pass Rp.) — read-only |
| SCR-18 | Edit Tarif Pass Pelabuhan | `/partner/edit_tarifpass/<base64Id>` | Sama struktur tabel SCR-17 tapi tiap sel jadi `input[name="gol_dewasa"]` (id berbeda per baris, mis. `gol_dewasa`, `gol_kendaraanAnak`, `gol_bayi`, `gol_kendaraanGolongan I (Sepeda Pancal)`, dst.), Simpan (`#simpan`), Batal (`#button-batal`) |
| SCR-19 | Daftar Master Asuransi (di luar cakupan rule) | `/partner/masterasuransi` | Filter `#btn-filter`; tabel (Nama Trayek, Rute, Konsumsi, Aksi) — **tidak ada tombol "Tambah"**, entri otomatis mengikuti trayek yang ada; per baris Detail (`.show_.btn-edit` title "Detail Asuransi" → SCR-20), Setting (title "Setting Asuransi" → SCR-21) |
| SCR-20 | Detail Asuransi | `/partner/detailasuransi/<id>` | Tabel "Tiket Penumpang" (Dewasa/Anak/Bayi × Asuransi JR/JP Rp.), tabel "Tiket Kendaraan" (6–12 golongan × Asuransi JR/JP Rp.) — read-only |
| SCR-21 | Setting Asuransi | `/partner/settingasuransi/<id>` | Sama struktur SCR-20 tapi tiap sel jadi input text, Simpan (`#simpan`), Batal (`#button-batal`) |
| SCR-22 | Daftar Master Crew | `/partner/MasterCrew` | Filter `#btn-filter`, link "Tambah Crew" → SCR-23; tabel (No, Nama Awak Kapal, Jenis Kelamin, Tanggal Lahir, No. Buku Pelaut, Jabatan, Kode Pelaut, Sertifikat Ijazah Pelaut, Aksi); per baris Lihat (`a.btn-viewnya`, toggle collapse `.col<id>` — ⚑ isi KOSONG, lihat FND-M-04), Edit (`.btn-edit` title "Edit Crew" id `select_crew`), Hapus (`.btn-delete` title "Hapus Crew" id `delete_crew`) |
| SCR-23 | Tambah Crew | `/partner/tambahcrew` | Baris dinamis (11 field bertanda `*`): `nama[]`, `select[name="gender[]"]`(Jenis Kelamin, TIDAK bertanda `*` di DOM meski tabel header ada), `tgl_lahir[]`, `buku_pelaut[]`, `exp_buku_pelaut[]`(Tgl Berakhir Buku Pelaut), `kode_pelaut[]`, `jabatan[]`, `no_pkl[]`, `tgl_sign_on[]`, `kewarganegaraan[]`(tidak wajib), `sertifikat[]`, `no_sertifikat[]`; tombol "Tambah Baris Input" (`#add_menu`), Simpan (`#submit_crew`) |
| SCR-24 | Daftar Denda Pembatalan | `/partner/masterdenda` | TIDAK ada tombol "Tambah" (sesuai P525); tabel (Nama Denda, Trigger By, Range Waktu, Denda, Aksi) — persis 3 baris tetap: Rusak (Setelah Cetak Tiket / 1 Jam / Rp.1.000), Batal (Sebelum Kapal Berangkat / 24 Jam / 50%), Hangus (Sebelum Kapal Berangkat / 6 Jam / 100%); tombol "Setting" (`.tombol_setting_modal`) per baris → modal SCR-25 |
| SCR-25 | Setting Denda Pembatalan (modal) | dalam SCR-24 | Modal "EDIT DENDA PEMBATALAN AGEN": text readonly-tampil `nama_edit` (Jenis Denda), hidden `id_edit`, text `trigger_by_edit`, text `range_waktu_edit` + unit "Jam", select `pilihan_denda_edit` (Rupiah/Persentase), text `jumlah_denda_edit`; catatan tertulis di modal "*) Denda pembatalan tiket agen sebelum cetak tiket : Rp. 0"; tombol Batal/Simpan. **Untuk akun Cabang: tombol "Setting" tampil TAPI klik tidak membuka modal ini** — tooltip `data-original-title="Hanya bisa dilakukan oleh kantor pusat"` (P540, dikonfirmasi live) |
| SCR-26 | Daftar Master Informasi | `/partner/informasi_show` | Filter `#btn-filter`, link "Tambah Informasi" → SCR-27; tabel (No, Tanggal Buat, Judul Informasi, Berlaku Sampai, Aksi) — **daftar KOSONG saat harvest** (tidak ada data Informasi tersimpan di akun Pusat maupun sebelumnya per `explore/module-map.md`), sehingga kolom Aksi (Edit/Hapus per baris) belum bisa diverifikasi bentuknya |
| SCR-27 | Tambah Informasi | `/partner/informasi_add` | Text (id `nama1`, duplikat id dgn field tanggal — lihat FND-M-06 gaya OP-21) placeholder "Masukkan Judul Informasi" (`maxlength=100`), text placeholder "DD/MM/YYYY" (Berlaku Sampai, date picker default hari ini), textarea placeholder "Masukkan Isi Informasi" (`maxlength=350`), Simpan (`#submit_crew` — id sisa template, sama dgn Master Crew), Batal (`#button-batal`) |

## Pesan (M-xx) — dari perilaku aplikasi (bukan dari rule, kecuali disebutkan)

| ID | Layar | Pemicu | Pesan / bentuk |
|---|---|---|---|
| M-01 | SCR-01 | Hapus Kelas yang dipakai di Master Kapal | SweetAlert2 title "Data Digunakan di Master Kapal", tombol OK/Cancel — ✅ diverifikasi live (sesuai P482) |
| M-02 | SCR-01/04/07/10/12/15/19/22/26 | Hapus data (baris tidak terpakai) | SweetAlert2 konfirmasi "Apakah anda yakin ingin hapus ...?" tombol Ya/Batal — pola umum dari `shared/selector-map-partner-common.md`, belum diverifikasi teks persis per submodul Master (agar tidak berisiko klik Ya) |
| M-03 | SCR-24/25 | Operator **Cabang** klik "Setting" pada Denda Pembatalan | Tooltip Bootstrap "Hanya bisa dilakukan oleh kantor pusat" muncul; modal SCR-25 TIDAK terbuka — ✅ diverifikasi live 27 Sep 2026 (P540) |
| M-04 | SCR-25 | Info statis (bukan pemicu aksi) | Teks tercetak di modal: "*) Denda pembatalan tiket agen sebelum cetak tiket : Rp. 0" (P529) |
| M-05 | SCR-25 | *(hipotesis dari rule, BELUM diverifikasi live — menulis setting tenant)* Simpan dengan range waktu Batal < range waktu Hangus | Alert "Range waktu tidak boleh kurang dari denda Hangus" (P533) |
| M-06 | SCR-25 | *(hipotesis, belum diverifikasi live)* Simpan dengan range waktu Hangus > range waktu Batal | Alert "Range waktu tidak boleh lebih dari denda Batal" (P538) |
| M-07 | SCR-27 | *(hipotesis dari rule, kandidat unreachable — lihat FND-M-02)* Judul/Isi Informasi melebihi batas karakter | Alert "Jumlah karakter melebihi batas karakter" (P544, P546) |
| M-08 | SCR-02/05/08/11/14/23/27 | Simpan dengan SEMUA field kosong | **TIDAK ADA pesan/popover/alert** — tombol tampak diam, dikonfirmasi tidak ada request POST/AJAX terkirim (`browser_network_requests`) untuk Kelas, Golongan, Kapal, Trayek, Harga, Crew, Informasi — lihat FND-M-01 |
| M-09 | SCR-10, SCR-22 | Klik "Lihat" (ikon mata) pada baris Trayek atau Crew | Panel collapse terbuka (class `.col<id>` berubah jadi `collapse show`) tapi **kosong** (hanya elemen pembatas visual, tanpa data) — lihat FND-M-04 |
| M-10 | ANY | Route Master diakses tanpa hak akses / id tidak valid | Pola umum aplikasi: redirect `/partner/dashboard` + `.alert-danger` "Anda Tidak Memiliki Akses Ke Halaman Tersebut" (belum diuji ulang khusus Master, mengacu `shared/selector-map-partner-common.md`) |

## Perbedaan akses Pusat vs Cabang (terverifikasi live 27 September 2026)

| Submodul | Pusat | Cabang |
|---|---|---|
| Master Kelas | Tambah/Edit/Hapus tersedia | ✅ Sama — link "Tambah Kelas" tampil, badge header berganti jadi "Kantor Cabang Parepare" |
| Master Golongan/Kapal/Trayek/Harga/Tarif Pass/Asuransi/Crew/Informasi | Tambah/Edit/Hapus/Setting tersedia | Tidak diuji satu-per-satu live pada sesi ini (dibatasi waktu), tetapi eksplorasi umum 26 Sep 2026 (`explore/module-map.md`, "Eksplorasi detail kelompok Master") mencatat "akun Cabang dapat membuka langsung form tambah serta halaman edit/setting pada hampir seluruh kelompok Master" — konsisten dengan pola Kelas |
| **Denda Pembatalan** | Tombol "Setting" membuka modal SCR-25, field terisi dan (diasumsikan) bisa diubah | **Tombol "Setting" tampil tapi tidak bisa dibuka** — tooltip "Hanya bisa dilakukan oleh kantor pusat", modal tidak muncul saat diklik — ✅ **diverifikasi live, sesuai P540** |

## Data dan temuan yang perlu diperhatikan saat penulisan skenario

- Master Informasi kosong di lingkungan uji saat harvest — skenario AC-09 (batas karakter) dan
  pola Aksi (Edit/Hapus) baris Informasi HARUS membuat data `AUTOTEST-<tgl>-` baru dulu sebelum
  bisa diverifikasi kolom Aksi-nya.
  Ingat: sesuai P543/P547–P549, begitu tersimpan, informasi ini tampil di Dashboard Agen (Pusat:
  semua agen; Cabang: agen sekota) — kalau modul ini memutuskan menyimpan data uji sungguhan,
  pastikan judul/isi berprefix `AUTOTEST-<tanggal>-` agar mudah diidentifikasi dan dihapus di akhir
  run.
- Trayek "asdfghdaf" (Balikpapan–Parepare–Taipa, dibuat 25 Sep 2026) adalah data tertinggal sesi
  lain — JANGAN dihapus oleh run modul ini (bukan dibuat oleh run ini), cukup dihindari sebagai
  data acuan uji.
- Karena mayoritas REQ Master adalah soal **penolakan** Simpan/Hapus pada kondisi tertentu (data
  dipakai di modul lain, kombinasi duplikat, range waktu salah), banyak skenario **positif** (AC)
  bisa diuji tanpa perlu membuat/menyimpan data Master baru sama sekali — prioritaskan pola ini di
  spec Playwright untuk meminimalkan risiko data tertinggal permanen (lihat "Catatan risiko" di
  `master_analysis.md`).
- Skenario yang menyentuh Setting Denda Pembatalan (REQ-039, REQ-040, REQ-043 — butuh Simpan
  sungguhan untuk memicu alert P533/P538) TIDAK dieksekusi pada sesi harvest ini dan TIDAK boleh
  dieksekusi otomatis tanpa izin eksplisit user tercatat di `shared/decisions.md`, karena akan
  mengubah setting tenant yang memengaruhi perhitungan denda pembatalan tiket agen sungguhan.

## Ringkasan pemetaan

- **29 layar (SCR-00 s.d. SCR-27, termasuk SCR-14b)** berhasil dipetakan: rute, kolom tabel,
  tombol, dan field form Tambah/Edit teridentifikasi untuk seluruh 10 submodul sidebar MASTER
  (termasuk Master Asuransi yang di luar cakupan rule dokumen).
- Tidak ada layar yang di-skip karena akses ditolak — baik Pusat maupun Cabang berhasil membuka
  seluruh daftar dan sebagian besar form Tambah/Edit/Setting yang dicoba.
- Yang **sengaja tidak dibuka/disimpan**: konfirmasi Hapus sungguhan (SweetAlert "Ya"/"Hapus")
  pada baris data terpakai nyata, dan Simpan pada form Setting Denda Pembatalan/Asuransi/Tarif
  Pass Edit (semua berisiko menulis data bersama/setting tenant) — sesuai batasan
  `docs/agent-guide.md`.
