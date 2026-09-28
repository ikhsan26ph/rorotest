# OP-16/OP-17 Daftar Relasi (Relasi Pelanggan + Relasi Agen) — UI Inventory

Hasil eksplorasi READ-ONLY 27 September 2026 (UI v1.5.2), Operator Pusat (akun #2,
`prdct.atg@gmail.com`) dan Operator Cabang Pare-Pare (akun #3, `partnerbidph@gmail.com`) —
kedua akun login berhasil, tidak ada kegagalan login. Tidak ada spec `/harvest-selectors`
khusus modul ini yang dijalankan — selector dikumpulkan langsung lewat `browser_evaluate`
(Playwright MCP) atas DOM tiap layar DAN atas source JS inline halaman (skrip validasi
`onclick`/`change` dibaca langsung via `fetch`/`document.querySelectorAll('script')` untuk
memetakan pesan validasi tanpa perlu submit data nyata), mengikuti pola
`scenario/kuota-jadwal/kuota-jadwal_ui-inventory.md`. Elemen bersama login/header/sidebar
mengikuti `shared/selector-map-partner-common.md` (SCR-00 tidak diulang detailnya di sini).

**TIDAK ADA data ditulis/disimpan selama eksplorasi ini.** Form Tambah Pelanggan, Tambah
Agen, Tambah Diskon, dan Tambah Komisi Agen dibuka dan tombol Simpan diklik HANYA pada
form KOSONG (data baru, bukan data existing) untuk memicu pesan validasi per-field — TIDAK
ada AJAX POST/`form.submit()` sungguhan yang berhasil lolos validasi (dikonfirmasi via
`browser_network_requests`: tidak ada request ke `doaddpelanggan`/`doAddAgen`/
`saveIncludeDiskon`/`saveIncludeKomisi`). Form Edit Pelanggan (modal, data existing CV
Karya Bersama) dan Edit Agen (data existing PT. Integritas Kuasa) HANYA dibuka untuk
memetakan field lalu ditutup lewat tombol Batal — tombol Simpan pada form EDIT data
existing sengaja TIDAK diklik (berisiko benar-benar mengubah data nyata, beda dari form
Tambah yang kosong). Tombol Hapus (Pelanggan maupun Agen) tidak pernah diklik.

Sidebar **DAFTAR RELASI** adalah grup collapsible berisi 2 submenu, tampil IDENTIK secara
struktur pada **Operator Pusat maupun Operator Cabang Pare-Pare** (link sama-sama ada; isi
di baliknya yang berbeda signifikan — lihat bagian "Perbedaan akses"):

```
DAFTAR RELASI
├── Relasi Pelanggan   /partner/pelanggan
└── Relasi Agen        /partner/agen
```

Teknik harvest tambahan yang dipakai (BARU dibanding dokumen sebelumnya): karena aplikasi
ini memakai pola validasi `zemPopover` (Bootstrap popover `.popover-body` yang di-`setTimeout`
hapus otomatis setelah **1000ms**), mengecek `.popover` setelah `await`/round-trip terpisah
SELALU gagal (tampak seolah "tidak ada validasi", pola silent Master) — popover HARUS dibaca
di DALAM evaluate yang sama persis dengan `click()`-nya (`document.getElementById('simpan').click(); return document.querySelector('.popover')?.outerHTML`),
sinkron tanpa `await` di antaranya. Ini penyebab kebingungan awal saat harvest (lihat
"Catatan teknis" di bawah) — dicatat eksplisit karena berpotensi menjebak eksekusi skenario
otomatis nanti juga.

## Layar (SCR) — Relasi Pelanggan

| SCR | Layar | Route | Elemen utama (ringkas) |
|---|---|---|---|
| SCR-PEL-01 | Daftar Relasi Pelanggan | `/partner/pelanggan` | Tombol `#btn-filter` (Filter, toggle panel: input `nama_perusahaan`, `lama_pembayaran`, `pic`, `email_perusahaan`, `telp_perusahaan`, hidden `status_filter=1`; submit via GET query string; 2 tombol berlabel "Reset" ditemukan di DOM — `.reset-master` dan satu lagi `.btn-primary`, perilaku persis keduanya belum dibedakan detail, navigasi ulang ke URL bersih terbukti mengembalikan daftar penuh); link **"Tambah Pelanggan"** (tanpa id, class `.btn-buat-trayek`, href `/partner/tambahpelanggan`) → SCR-PEL-04; dropdown baris `#valuelimit` (20/30/50/100); tabel (No, Nama Perusahaan, **Lama Pembayaran**, Nama PIC, Email, Telepon/WA, Aksi) — kolom "Lama Pembayaran" berisi nilai "Tunai" (default/tanpa TOP) atau "N Hari" (mis. "3 Hari") bila TOP dicentang; per baris 2 aksi: Detail (`a.btn-view.btn_1`, title "Detail Pelanggan", href `/partner/detailpelanggan/<base64Id>`) → SCR-PEL-02, Hapus (`button.btn-delete`, title "Hapus Pelanggan", tidak diuji). **Pusat: 58 data. Cabang Pare-Pare: 58 data — SAMA PERSIS, tidak difilter kota** (lihat FND-RL-08) |
| SCR-PEL-02 | Detail Pelanggan | `/partner/detailpelanggan/<base64Id>` | Header "DETAIL PELANGGAN" + tombol "Kembali"; tombol **"Edit Pelanggan"** (buka modal SCR-PEL-03, BUKAN route terpisah); daftar field tampilan: Nama Perusahaan, Lama Pembayaran, Nama PIC, Email (mailto link), Telepon/Whatsapp, **Jenis Identitas, Nomor Identitas, Kota/Kab** (untuk data lama menampilkan `-` — **REQ-PEL-04 TERVERIFIKASI TRUE** memakai sampel nyata "CV Karya Bersama" id 3701, lihat FND-RL-05), Alamat Perusahaan, Keterangan; sub-bagian tabel Diskon: tombol Filter, link **"Tambah Diskon"** (href `/partner/tambahandiskon/<base64Id>`) → SCR-PEL-05, dropdown baris; tabel (Tanggal Buat, Jenis Tiket, Golongan Tiket, Kelas/Kondisi, Rute, Diskon Harga, Aksi) — Aksi 2 tombol tanpa title captured (kemungkinan Edit/Hapus Diskon, tidak dibuka lebih lanjut). **Identik pada Pusat maupun Cabang** (Edit Pelanggan + Tambah Diskon sama-sama tersedia) |
| SCR-PEL-03 | Edit Pelanggan (modal `#modalpelanggan`) | dalam SCR-PEL-02 | Modal title "EDIT DATA PELANGGAN". Field (semua bertanda `*` KECUALI Keterangan — **REQ-PEL-03 field wajib terverifikasi persis**): hidden `select#OperatorID` (tenant scoping, `display:none`, TIDAK user-facing); `#nama_perusahaan`*; `#penanggung_jawab`* (Nama PIC); checkbox `#topnya` "Pembayaran Bisa TOP" — **tepat di bawahnya** `#lama_pembayaran` (number, placeholder "Lama Pembayaran (Hari)", **`disabled` kecuali `#topnya` dicentang** — **VAL-PEL-03/Q-RP-02 TERJAWAB PENUH**: field ini ADA di form yang sama, kondisional pada checkbox TOP, bukan field terpisah/halaman lain); `#email_perusahaan`*; `#telp_perusahaan`*; `#jenis_identitas`* (select2: Pilih Jenis/KTP/SIM/Passport — REQ-PEL-05 cocok persis); `#nomor_identitas`*; `#kota`* (select, **satu-satunya field dengan atribut HTML `required` sungguhan**, ratusan opsi kota/kab Indonesia — REQ-PEL-06 terverifikasi sumbernya kompleks/lengkap); `#alamat_perusahaan`* (textarea); `#keterangan` (textarea, **TANPA** tanda `*`); hidden `#id_perusahaan`. Tombol Simpan (id `btn_update_golongan` — **id sisa template dari Master Golongan, kosmetik**, lihat FND-RL-06) dan Batal (id `button-batal`, `data-dismiss="modal"`) |
| SCR-PEL-04 | Tambah Pelanggan | `/partner/tambahpelanggan` | Field SAMA PERSIS dengan SCR-PEL-03 (bukan modal, halaman sendiri). Tombol Simpan (`#simpan`), Batal (`#button-batal`, redirect `/partner/pelanggan`). **Rantai validasi lengkap terverifikasi (live + source JS)** — lihat tabel Pesan M-PEL-01 s.d. M-PEL-05 |
| SCR-PEL-05 | Tambah Diskon | `/partner/tambahandiskon/<base64Id>` | Baris dinamis: `select#rute` (name `berlaku_untuk`, 58 opsi trayek); `select#jenis1` (name `ParentID[]`, opsi: Penumpang/Kendaraan/**Bagasi Kendaraan**/**Bagasi Penumpang** — CATATAN: 2 varian Bagasi terpisah, bukan satu opsi "Bagasi" tunggal seperti tersirat di REQ-PEL-16/17, lihat FND-RL-02); `select#golongan1` (name `golongan[]`, terisi AJAX POST `/partner/getgolongantiket` berdasar `jenis1`); `select#kelas1` (name `kelas[]`) **ATAU** saat `jenis1` = Bagasi Kendaraan/Bagasi Penumpang: `kelas1` **disembunyikan** dan digantikan input `.bagasi_<n>` (`value="Bagasi"`, `disabled`, awalnya `display:none` lalu di-`show()`) — **REQ-PEL-17/VAL-PEL-05 TERVERIFIKASI PENUH LIVE**, cocok persis rule; `select#tipe1` (name `tipe[]`, opsi Rupiah/Persen — REQ-PEL-18); `input#harga1` (name `harga[]`, placeholder "Harga Diskon", label **"%"** tampil di kiri input saat tipe=Persen — REQ-PEL-18 terverifikasi); Inputmask numeric pada field persen membatasi max **100** + JS keyup/keypress memotong nilai >100 (radixPoint koma) — **REQ-PEL-19/VAL-PEL-04 TERVERIFIKASI** (client-side, dari source, bukan cuma observasi DOM); tombol "Tambah Baris Input" (`#add_menu`), Simpan (`#simpan`, type submit), Batal (`#batal3`) |

## Layar (SCR) — Relasi Agen

| SCR | Layar | Route | Elemen utama (ringkas) |
|---|---|---|---|
| SCR-AGN-01 | Daftar Relasi Agen ("DAFTAR AGEN") | `/partner/agen` | Filter: `nama_perusahaan`, `penanggung_jawab`, `telp`, `select#status` (Pilih Status/Aktif/Tidak Aktif); dropdown baris `#valuelimit2`; tabel (No, Nama Perusahaan Agen, Penanggung Jawab, Telepon/WA, Status, Aksi). **Pusat: TIDAK ADA link/tombol "Tambah" di mana pun pada halaman ini** (dipindai penuh via `querySelectorAll`, dikonfirmasi absen) — Aksi HANYA "Detail Agen" (`a.btn-view`), **TIDAK ADA tombol Hapus**; data **3 baris** (semua kota: PT. Integritas Kuasa, PT. Agen RORO Balikpapan, RORO COBA). **Cabang Pare-Pare: link "Tambah Agen" ADA** (href `/partner/tambahagen`) → SCR-AGN-03; Aksi = "Detail Agen" **DAN** "Hapus Agen" (`button.btn-delete`); data **1 baris saja** (PT. Integritas Kuasa, Kota Parepare — REQ-AGN-04 "sekota" konsisten). **REQ-AGN-01/P727 TERVERIFIKASI LIVE DI SINI** |
| SCR-AGN-02 | Detail Agen | `/partner/detailagen/<base64Id>` | Field jauh lebih kaya dari yang disebut rule P726-737 (lihat FND-RL-04): Nama Perusahaan Agen, Penanggung Jawab, Email (mailto), Telepon/Whatsapp, Kota, Alamat Perusahaan, Logo Perusahaan (status upload), Dokumen Identitas (link PDF), Surat Perjanjian (link PDF), Dokumen Tambahan, Status; blok terpisah **"INFORMASI REKENING"** (Nama Bank, Nomor Rekening, Atas Nama Rekening); blok **"Komisi Agen"** (Filter + tabel: No, Jenis Tiket, Golongan Tiket, Kelas/Kondisi Kendaraan, Rute, Komisi (%), [Aksi]). **Pusat**: header cuma tombol "Kembali" (**TIDAK ADA "Edit Agen"**); tabel Komisi Agen **TANPA kolom Aksi**, **TANPA link "Tambah Komisi"**. **Cabang**: tombol **"Edit Agen"** (href `/partner/editagen/<idPolos>`) → SCR-AGN-04; blok Komisi Agen ADA link **"Tambah Komisi"** (href `/partner/tambahkomisiagen/<idPolos>`) → SCR-AGN-05, tabel Komisi Agen PUNYA kolom Aksi. Catatan: id Agen di route Edit/Tambah Komisi berupa **angka polos** (mis. `19534`), BEDA dari route Detail yang base64 |
| SCR-AGN-03 | Tambah Agen | `/partner/tambahagen` | **Cabang saja** — Pusat diblokir SERVER-SIDE (redirect `/partner/dashboard` + `.alert-danger` "Anda Tidak Memiliki Akses Ke Halaman Tersebut", dikonfirmasi via akses URL langsung, BUKAN cuma tombol tersembunyi — lihat FND-RL-07). Field (semua bertanda `*` KECUALI "Logo Perusahaan Agen" dan "Dokumen Tambahan"): `#nama_perusahaan`*, `#penanggung_jawab`*, `#email`* (type email), `#password`* (Kata Sandi), `#password_confirm`* (Konfirmasi Kata Sandi), `#telp`* (Telepon/WA), `#alamat_perusahaan`* (textarea), file `#foto_stnk`(Logo, opsional), file `#foto_identitas`* (Dokumen Identitas KTP/SIM), file `#foto_perjanjian`* (Surat Perjanjian), file `#foto_dokumen`(Dokumen Tambahan, opsional), `select#status`* (Aktif/Tidak Aktif), `select#bank`* (BRI/BNI/BCA/CIMB NIAGA/+2 lain, 6 opsi total), `#nomor_rekening`*, `#atas_nama`* (Atas Nama Rekening). **TIDAK ADA field Kota** — kota agen otomatis mengikuti kota Cabang pembuat (server-side, bukan dipilih user), konsisten konsep "sekota" REQ-AGN-04/-11. Tombol Simpan (`#submit_sub`) memicu **native `form.submit()`** (`#form-agen`, BUKAN AJAX seperti Pelanggan — karena upload file multipart) setelah semua validasi lolos |
| SCR-AGN-04 | Edit Agen | `/partner/editagen/<idPolos>` | **Cabang saja** (Pusat diblokir sama seperti SCR-AGN-03, dikonfirmasi via akses URL langsung). Field identik SCR-AGN-03, terisi data existing; `password`/`password_confirm` tampil sebagai teks mask literal `*******` (bukan value asli); `status` bisa diganti (mendukung REQ-AGN-06/07, efek notifikasi TIDAK diverifikasi — form ini SENGAJA tidak di-Simpan karena data existing nyata) |
| SCR-AGN-05 | Tambah Komisi Agen | `/partner/tambahkomisiagen/<idPolos>` | **Cabang saja** (Pusat diblokir sama, dikonfirmasi). Struktur field SAMA seperti Tambah Diskon Pelanggan (SCR-PEL-05): `select#rute`(berlaku_untuk), `select#jenis1`(ParentID[]), `select#golongan1`, `select#kelas1`, `input#harga1`(placeholder "0", class `hanyaangka-koma-`) — **TIDAK ADA selector `tipe1`** (Rupiah/Persen) karena Komisi Agen SELALU persentase (REQ-AGN-08, kolom list "Komisi (%)"); tombol "Tambah Baris Input"(`#add_menu`), Simpan(`#simpan`), Batal(`#batal3`), Kembali(`#kembalikan`). **Alur Simpan BERBEDA dari Diskon Pelanggan**: native `confirm("Apakah Anda yakin untuk menambahan komisi agen ?")` [kutip persis, ada typo tata bahasa "menambahan"] muncul LEBIH DULU sebelum AJAX POST `/partner/saveIncludeKomisi`; jika duplikat → native `alert('Komisi yang Anda inputkan sudah ada di database')` — lihat FND-RL-01 (teks BEDA dari rule P736) |

## Pesan (M-xx) — dari perilaku aplikasi/source JS (bukan dari rule, kecuali disebutkan)

| ID | Layar | Pemicu | Pesan / bentuk |
|---|---|---|---|
| M-PEL-01 | SCR-PEL-04 (juga SCR-PEL-03) | Simpan dengan field kosong, berurutan per field | zemPopover (`.popover-body`, Bootstrap popover, **auto-hilang dalam 1000ms** via `setTimeout`) — urutan & teks PERSIS dari source: (1) nama_perusahaan → "Masukkan Nama Perusahaan" **(live-verified)**; (2) penanggung_jawab → "Masukkan Nama PIC"; (3) *jika* `#topnya` dicentang dan lama_pembayaran kosong → "Masukkan Jumlah Hari"; nilai 0 → native `alert("Minimal 1")`; (4) email_perusahaan kosong → "Masukkan Email Perusahaan" **(live-verified)**; (5) format email salah (regex) → "Masukkan Email Dengan Benar" **(live-verified)**; (6) email sudah ada (AJAX POST `/partner/cek_email_pelanggan`) → "Email Sudah terdaftar"; (7) telp_perusahaan kosong → "Masukkan Nomor"; (8) WA sudah ada (AJAX POST `/partner/cek_wa_pelanggan`) → "Nomor Whatsapp Sudah terdaftar"; (9) jenis_identitas kosong → "Pilih Jenis Identitas"; (10) nomor_identitas kosong → "Masukkan Nomor"; (11) kota kosong → "Pilih Kota / Kab"; (12) alamat_perusahaan kosong → "Masukkan Alamat Perusahaan". **Keterangan TIDAK dicek** (opsional, sesuai REQ-PEL-03) |
| M-PEL-02 | SCR-PEL-04 | Semua field lolos validasi | AJAX POST `/partner/doaddpelanggan` → redirect `/partner/pelanggan` |
| M-PEL-03 | SCR-PEL-05 | 2 baris dalam satu submit punya kombinasi Golongan+Kelas sama | Native `alert('Input harga penumpang/kendaran ada yang sama ')` **[kutip persis dari source, termasuk typo "kendaran" dan spasi ganda di akhir]** — baris terkait di-highlight merah muda (`background:#ffc4c4`) |
| M-PEL-04 | SCR-PEL-05 | Kombinasi Golongan+Kelas+Rute+Kelas Tiket sudah ada di database Diskon Pelanggan (AJAX POST `/partner/saveIncludeDiskon`, response bukan "tersedia"/"gotologin") | Native `alert('Tidak bisa! Diskon sudah ditambahkan')` **[kutip persis]** — **teks ini melengkapi AC-PEL-05** yang di `relasi_analysis.md` sebelumnya hanya merujuk pola Master Harga tanpa teks konkret |
| M-PEL-05 | SCR-PEL-05 | Jenis Tiket = Bagasi Kendaraan/Bagasi Penumpang | `select#kelas1` disembunyikan, digantikan `input.bagasi_<n>` value="Bagasi" `disabled` — **REQ-PEL-17 cocok persis, bukan simulasi field "disabled" tunggal tapi swap 2 elemen** |
| M-PEL-06 | SCR-PEL-01 | Filter dengan `nama_perusahaan=Karya Bersama` | Daftar menyempit ke "Menampilkan 1 sampai 1 dari 1 data" (CV Karya Bersama saja) — **VAL-PEL-06 TERVERIFIKASI berfungsi** |
| M-AGN-01 | SCR-AGN-03 | Simpan dengan field kosong, berurutan | zemPopover, urutan & teks PERSIS dari source: (1) nama_perusahaan → "Masukkan Nama Perusahaan" **(live-verified)**; (2) penanggung_jawab → "Masukkan Nama Penanggung Jawab"; (3) email kosong → "Masukkan email"; email sudah ada (`$('#email').attr("ada")=="1"`) → "Email sudah Terdaftar"; ada=="2" → "Masukkan Email dengan benar"; gagal regex → "Penulisan email salah"; (4) password kosong → "Masukkan Kata Sandi"; gagal regex `^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]).{5,}$` (wajib campur huruf+angka, min 6 karakter) → "Kombinasi Hanya Boleh Huruf dan Angka"; (5) password_confirm kosong → "Masukkan Konfirmasi Kata Sandi"; tidak sama dengan password → "Kata Sandi Belum Sama"; (6) telp kosong → "Masukkan Nomor"; WA sudah ada (`attr("ada")=="1"`) → "Nomor sudah Terdaftar" **(REQ-AGN-03 terverifikasi di level kode, scope lintas-cabang tidak terverifikasi — tetap Q-RA-02)**; (7) alamat_perusahaan kosong → "Masukkan Alamat Perusahaan"; (8) Dokumen Identitas kosong → "Masukkan Dokumen Identitas"; (9) Surat Perjanjian kosong → "Masukkan Surat Perjanjian"; (10) status kosong → "Pilih Status"; (11) bank kosong → "Pilih Bank"; (12) nomor_rekening kosong → "Masukkan Nomor Rekening"; (13) atas_nama kosong → "Masukkan Nama". **Q-RA-01 TERJAWAB: pola IDENTIK dengan Pelanggan (per-field zemPopover), BUKAN pola silent Master** |
| M-AGN-02 | SCR-AGN-05 | Klik Simpan (sebelum validasi field, di awal handler) | Native `confirm("Apakah Anda yakin untuk menambahan komisi agen ?")` — **beda alur dari Diskon Pelanggan yang TIDAK punya confirm() ini** |
| M-AGN-03 | SCR-AGN-05 | Simpan dengan field kosong | zemPopover — live-verified: Rute kosong → "Pilih Rute" |
| M-AGN-04 | SCR-AGN-05 | Kombinasi Golongan+Kelas+Rute komisi sudah ada di database (AJAX POST `/partner/saveIncludeKomisi`, response bukan "tersedia"/"gotologin") | Native `alert('Komisi yang Anda inputkan sudah ada di database')` — **lihat FND-RL-01: TEKS BERBEDA dari rule P736 ("Komisi sudah ada di database")** |
| M-AGN-05 | SCR-AGN-01/02/03/04/05 | Operator Pusat mengakses route Tambah/Edit/Tambah Komisi Agen langsung via URL | Redirect `/partner/dashboard` + `.alert-danger` "Anda Tidak Memiliki Akses Ke Halaman Tersebut" — **pola sama dengan M-05 Kuota&Jadwal / M-10 Master**, dikonfirmasi ulang khusus 3 route Relasi Agen |

## Temuan (FND-RL-xx) — kandidat/catatan, belum verdict formal

| ID | Layar | Temuan | Status |
|---|---|---|---|
| FND-RL-01 | SCR-AGN-05 | Alert duplikat Komisi Agen berbunyi **"Komisi yang Anda inputkan sudah ada di database"**, BUKAN persis **"Komisi sudah ada di database"** seperti dikutip rule P736/REQ-AGN-10/AC-AGN-05. Fungsional sama (menolak duplikat), hanya teks berbeda. | kandidat bug-dokumentasi/wording, BUKAN bug fungsional — skenario assertion sebaiknya pakai teks aktual atau partial match `/sudah ada di database/i`, bukan exact match ke teks rule |
| FND-RL-02 | SCR-PEL-05, SCR-AGN-05 | Pilihan Jenis Tiket menampilkan **"Bagasi Kendaraan"** dan **"Bagasi Penumpang"** sebagai 2 opsi terpisah, bukan satu opsi "Bagasi" tunggal seperti tersirat REQ-PEL-16/17. Perilaku disabled/hide kelas (M-PEL-05) berlaku utk KEDUA varian — jadi REQ-PEL-17 tetap valid secara fungsional, hanya penamaan rule yang tidak 1:1 dengan opsi UI. | kandidat gap-dokumentasi, bukan bug — skenario harus menyebut kedua opsi eksplisit |
| FND-RL-03 | SCR-PEL-03/04 | Q-RP-02 TERJAWAB: field "Lama Pembayaran" ADA di form Tambah/Edit Pelanggan yang sama (bukan halaman terpisah), langsung di bawah checkbox "Pembayaran Bisa TOP", `disabled` sampai checkbox dicentang. | DITUTUP — bukan gap, VAL-PEL-03 terverifikasi penuh |
| FND-RL-04 | SCR-AGN-03/04 | Form Tambah/Edit Agen punya BANYAK field yang SAMA SEKALI tidak disebut rule P726-737: Kata Sandi + Konfirmasi (agen login pakai kredensial yang di-set Cabang langsung, bukan alur invite/OTP terpisah), 4 field upload dokumen (Logo/Identitas/Perjanjian/Tambahan), dan blok Informasi Rekening (Bank/Nomor Rekening/Atas Nama). | kandidat gap-dokumentasi rule vs UI aktual — PENTING untuk scenario-writing AC-AGN, field ini harus ikut dites (terutama validasi password & duplikat email/WA) walau tidak ada REQ eksplisit di analysis.md |
| FND-RL-05 | SCR-PEL-02 | Q-RP-04 TERJAWAB: environment demo memang punya data pelanggan lama pra-fitur (contoh "CV Karya Bersama" id 3701) yang menampilkan `-` untuk Jenis Identitas/Nomor Identitas/Kota — REQ-PEL-04 bisa diverifikasi dengan data ini. | DITUTUP — bukan gap, cakupan REQ-PEL-04 aman diuji |
| FND-RL-06 | SCR-PEL-03 | Tombol Simpan pada modal Edit Pelanggan memakai id `btn_update_golongan` — id sisa template dari form Master Golongan (kosmetik/copy-paste), pola sama dengan FND-KJ-04/FND-M-06 di modul lain. | catatan automasi — pakai selector teks "Simpan" dalam scope modal, jangan `#id` |
| FND-RL-07 | SCR-AGN-01/02/03/04/05 | REQ-AGN-01/P727 dikonfirmasi BUKAN cuma UI (tombol disembunyikan) tapi genuinely diblokir SERVER-SIDE — akses URL langsung `/partner/tambahagen`, `/partner/editagen/<id>`, `/partner/tambahkomisiagen/<id>` oleh Operator Pusat semuanya redirect ke `/partner/dashboard` + alert akses ditolak. | DITUTUP — hipotesis "Pusat read-only di Relasi Agen" TERKONFIRMASI PENUH, bukan bug, justru desain akses yang solid |
| FND-RL-08 | SCR-PEL-01/02 | Q-RA-04 TERJAWAB DEFINITIF: Relasi Pelanggan **SIMETRIS PENUH** antara Pusat dan Cabang — Tambah/Edit/Hapus/Tambah Diskon tersedia identik di kedua akun, dan KEDUANYA melihat dataset yang SAMA PERSIS (58 dari 58, tidak difilter kota sama sekali). Ini KONTRAS TAJAM dengan Relasi Agen (Pusat view-only + terfilter/tidak, Cabang 1 dari 3 data sekota saja). | DITUTUP — bukan bug, konfirmasi eksplisit pola tidak simetris antar 2 submodul yang digabung 1 dokumen ini |

## Perbedaan akses Pusat vs Cabang (terverifikasi live 27 September 2026)

### Relasi Pelanggan — SIMETRIS PENUH (kontras dengan hipotesis awal Q-RA-04)

| Aspek | Pusat | Cabang Pare-Pare |
|---|---|---|
| Akses menu Relasi Pelanggan | Tampil, `/partner/pelanggan` | Sama — tampil, route identik |
| Tombol/link Tambah Pelanggan | **ADA** (`/partner/tambahpelanggan`) | **ADA** — identik |
| Tombol Edit Pelanggan (di Detail) | **ADA** | **ADA** — identik |
| Tombol Hapus Pelanggan (di list) | **ADA** | **ADA** — identik |
| Link Tambah Diskon (di Detail) | **ADA** | **ADA** — identik |
| Jumlah data terlihat di Daftar | 58 dari 58 (semua kota) | 58 dari 58 — **SAMA PERSIS, TIDAK difilter kota** |

### Relasi Agen — SANGAT ASIMETRIS (REQ-AGN-01/P727 terverifikasi penuh)

| Aspek | Pusat | Cabang Pare-Pare |
|---|---|---|
| Akses menu Relasi Agen | Tampil, `/partner/agen` | Sama — tampil, route identik |
| Tombol/link Tambah Agen | **TIDAK ADA** (UI absen + `/partner/tambahagen` diblokir server, redirect dashboard) | **ADA** (`/partner/tambahagen`) |
| Tombol Edit Agen (di Detail) | **TIDAK ADA** (+ `/partner/editagen/<id>` diblokir server) | **ADA** |
| Tombol Hapus Agen (di list) | **TIDAK ADA** | **ADA** |
| Link/akses Tambah Komisi Agen | **TIDAK ADA** (+ `/partner/tambahkomisiagen/<id>` diblokir server); tabel Komisi Agen di Detail tanpa kolom Aksi | **ADA**; tabel Komisi Agen punya kolom Aksi |
| Jumlah data Agen terlihat di Daftar | 3 dari 3 (SEMUA kota) | 1 dari 1 (**HANYA sekota Pare-Pare** — REQ-AGN-04 konsisten) |

## Data dan temuan yang perlu diperhatikan saat penulisan skenario

- **Pola validasi `zemPopover` auto-hilang 1000ms** adalah jebakan harvest/eksekusi: mengecek
  `.popover` setelah `await`/round-trip terpisah dari `click()` akan SELALU tampak kosong
  (seolah tidak ada validasi). Skenario Playwright utk modul ini WAJIB memakai pola tunggu
  popover MUNCUL (`page.waitForSelector('.popover', {timeout: 500})` segera setelah klik,
  atau baca `.popover-body` di dalam callback yang sama) — bukan menyimpulkan "tidak ada
  pesan" dari observasi yang terlambat. Ini murni catatan teknis automasi, BUKAN bug aplikasi.
- **Data uji nyata yang dipakai untuk memetakan (BUKAN dibuat oleh sesi ini, tidak diubah)**:
  Pelanggan "CV Karya Bersama" (id 3701, base64 `MzcwMQ==`) untuk Detail/Edit; Agen "PT.
  Integritas Kuasa" (id 19534/base64 `MTk1MzQ=`, Kota Parepare) untuk Detail/Edit/Tambah
  Komisi. Keduanya HANYA dibuka (GET) untuk memetakan field, form Edit-nya TIDAK pernah
  di-Simpan.
  Perlu diverifikasi lagi & lupa dicek: title tombol Aksi pada tabel Diskon di Detail
  Pelanggan (kemungkinan besar "Edit Diskon"/"Hapus Diskon" mengikuti pola modul lain, belum
  dikonfirmasi langsung).
- **Kombinasi komisi/diskon duplikat memakai native `confirm()`/`alert()` browser** (bukan
  SweetAlert2 seperti Hapus, bukan zemPopover seperti validasi field-kosong) — automasi WAJIB
  menyiapkan handler dialog (`page.on('dialog', ...)`) khusus utk SCR-AGN-05 (confirm SEBELUM
  submit) dan utk deteksi alert duplikat SCR-PEL-05/SCR-AGN-05, beda pola penanganan dari
  modul Master/Kuota&Jadwal yang sejauh ini didominasi SweetAlert2 (`.swal2-popup`).
  Diskon Pelanggan (SCR-PEL-05) TIDAK punya `confirm()` sebelum submit, hanya alert duplikat
  setelah AJAX gagal — beda alur dari Komisi Agen, jangan disamakan.
- **REQ-PEL-15 (aturan Tambah Diskon = aturan Master Harga)** — TIDAK dikonfirmasi identik
  1:1 di level pesan: teks alert duplikat Diskon Pelanggan ("Tidak bisa! Diskon sudah
  ditambahkan") belum dibandingkan langsung dengan teks alert duplikat Master Harga (tidak
  diuji ulang di sesi ini, rujuk `master_ui-inventory.md` bila predisi tersedia). Aturan
  KOMBINASI field yang dianggap duplikat (Golongan+Kelas, tanpa mempertimbangkan Rute+Jenis
  Tiket secara eksplisit dari source yang dibaca) match dengan pola Master, tapi TEKS pesannya
  berbeda kata — cukup dicatat, bukan dianggap kontradiksi rule.
- **File upload pada Tambah/Edit Agen** (Logo, Dokumen Identitas, Surat Perjanjian, Dokumen
  Tambahan) belum diuji jenis file/ukuran yang diterima — tidak ada indikasi client-side
  `accept`/`maxsize` yang diperiksa pada sesi ini; PERLU VERIFIKASI UI lanjutan bila
  scenario-writing memutuskan menguji upload sungguhan (which juga berarti submit form Tambah
  Agen sungguhan — di luar cakupan read-only sesi ini).
- **Scope validasi WA/email lintas-cabang (Q-RA-02) TETAP TIDAK TERJAWAB** — source JS Tambah
  Agen hanya membaca flag boolean `ada` dari server (`attr("ada")=="1"`), tidak mengungkap
  apakah pengecekan server itu benar-benar lintas SEMUA kota atau cuma cabang terkait. Perlu
  akun Cabang kota lain yang tidak tersedia di `config/env.md` untuk menjawab tuntas.

## Ringkasan pemetaan

- **10 layar khusus modul (SCR-PEL-01..05, SCR-AGN-01..05)** berhasil dipetakan penuh: route,
  kolom tabel, tombol, field form Tambah/Edit, DAN rantai pesan validasi lengkap (dari source
  JS + live click pada form kosong) untuk KEDUA submodul.
- Tidak ada layar yang di-skip karena akses ditolak pada AKUN YANG SEHARUSNYA punya akses
  (Cabang untuk semua layar Agen, kedua akun untuk semua layar Pelanggan). 3 route Relasi Agen
  (Tambah/Edit/Tambah Komisi) SENGAJA diverifikasi DITOLAK untuk Pusat sebagai bagian dari
  pengujian (bukan skip kegagalan, melainkan hasil yang diharapkan & dikonfirmasi).
- Yang **sengaja tidak diklik/disimpan**: Simpan pada form Edit data existing (Pelanggan
  maupun Agen), konfirmasi Hapus sungguhan (SweetAlert/native confirm) pada baris data nyata,
  dan submit lolos-validasi pada form Tambah manapun (semua percobaan Simpan sengaja
  dijalankan pada form KOSONG untuk memicu validasi, bukan untuk benar-benar menyimpan) —
  sesuai batasan `docs/agent-guide.md` dan `docs/workflows/harvest-selectors.md`.
