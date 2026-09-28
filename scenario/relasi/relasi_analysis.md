# OP-16/OP-17 Daftar Relasi (Pelanggan + Agen) — Analisis Requirement

Sumber: `scenario/Dokumen Rule RORO v1.5.0 v19042025.docx`, bagian **Daftar Relasi**
(P702–P737), dirujuk dari `docs/module-map-from-rules.md` baris OP-16 (Relasi Pelanggan,
P702–724) dan OP-17 (Relasi Agen, P726–737). Kedua submodul digabung jadi satu dokumen kerja
sesuai instruksi tugas ("Relasi Pelanggan/Agen" adalah satu langkah kerja bagi user), tetapi
tetap dipisah jelas per bagian karena sumbernya juga memisahkan sebagai dua sub-bab
("Relasi Pelanggan" P703, "Relasi Agen" P726).

Rujukan `P<n>` = indeks paragraf DOCX ke-n (mulai 0, termasuk paragraf kosong/tabel/judul,
urutan `word/document.xml//w:p`) — diekstrak dengan skrip Python (`xml.etree.ElementTree`
atas `word/document.xml` hasil unzip docx), PERSIS metode yang dipakai untuk OP-11 Master dan
OP-12 Kuota & Jadwal; bukan nomor halaman. Batas rentang dikonfirmasi lewat ekstraksi langsung:
P702 = judul "Daftar Relasi", P703 = judul "Relasi Pelanggan", P726 = judul "Relasi Agen",
P738 = judul "Saldo Agen" (modul berikutnya, OP-18, di luar cakupan dokumen ini) — cocok
dengan pembagian di `module-map-from-rules.md`.

**Sesuai instruksi tugas AWAL ini: tidak ada sesi browser/Playwright MCP yang dibuka** — semua
baris "Dapat diuji di web?" di bawah adalah proyeksi dari teks rule pada saat penulisan awal,
bukan hasil pengamatan aplikasi. **UPDATE 27 Sep 2026**: harvest UI read-only SUDAH dijalankan
pada langkah kerja berikutnya (login Pusat #2 + Cabang Pare-Pare #3) — hasilnya ada di
`scenario/relasi/relasi_ui-inventory.md`, dan bagian **VAL** serta **Perbedaan hak Pusat vs
Cabang** di dokumen ini SUDAH diperbarui untuk mencerminkan temuan live tersebut. Bagian
REQ/AC/Q-xx di bawah TETAP seperti semula (proyeksi dari rule) kecuali disebutkan lain secara
eksplisit — rujuk `relasi_ui-inventory.md` untuk detail selector/pesan/screenshot yang
sebelumnya belum ada.

Cakupan modul:
- **Relasi Pelanggan (OP-16, P703–724)**: data pelanggan (Nama Perusahaan/PIC, kontak,
  identitas), opsi pembayaran TOP/Tunai, dan diskon per pelanggan berdasarkan rute/atribut tiket.
- **Relasi Agen (OP-17, P726–737)**: pembuatan/aktivasi akun agen oleh Cabang, notifikasi agen,
  komisi agen per rute/atribut tiket, dan visibilitas data lintas cabang sekota.

Akun uji yang relevan (`config/env.md`):
- **Operator Pusat** (akun #2, `prdct.atg@gmail.com`) — akun utama untuk memverifikasi
  pembatasan **Relasi Agen hanya-lihat** (P727); juga dipakai sebagai baseline akses Relasi
  Pelanggan (lihat Q-RA-04 di bawah — sumber tidak menyatakan Pusat dibatasi di Relasi
  Pelanggan, PERLU VERIFIKASI UI).
- **Operator Cabang Pare-Pare** (akun #3, `partnerbidph@gmail.com`) — akun utama untuk Tambah
  Pelanggan/Tambah Agen/Tambah Komisi Agen (P727 menyatakan hanya Cabang yang bisa menambah
  agen). **Keterbatasan**: hanya ada **satu** akun Cabang di `config/env.md` (Pare-Pare) —
  aturan visibilitas "sekota" (P730, P737, P741) dan validasi silang-kota (P729) **tidak bisa
  diverifikasi penuh** tanpa akun Cabang kedua di kota yang sama; hanya sisi yang bisa diuji
  dengan satu akun (mis. data milik Cabang sendiri tampil, atau uniqueness check terhadap data
  Cabang Pare-Pare sendiri) yang dapat dijalankan. Pola keterbatasan ini identik dengan yang
  sudah dicatat di `kuota-jadwal_analysis.md` (Q-KJ terkait isolasi data antar-cabang).
- **Agen** (akun #4, `pengirimdidph@gmail.com`, portal `/agen`) — **mungkin diperlukan** untuk
  memverifikasi efek notifikasi login/welcome email (P731–733) dan penerapan komisi (P735) dari
  sisi Agen, tetapi portal `/agen` **di luar cakupan submodul Operator OP-16/OP-17** yang
  didokumentasikan di sini (portal `/partner`). Dicatat sebagai kebutuhan cross-portal untuk
  tahap scenario-writing, bukan bagian wajib dokumen ini.

## Catatan risiko khusus modul ini

- **Data referensi lintas modul** — sama seperti pola OP-11 Master, data Relasi Pelanggan dan
  Relasi Agen adalah data yang dipakai modul lain, bukan data mandiri:
  - Relasi Pelanggan dipakai di **Jual Tiket (OP-13)** untuk memilih metode pembayaran
    Tunai/TOP dan menerapkan diskon otomatis (P704, P710–717); dan di **Daftar Piutang
    (OP-15)** untuk menghitung tempo jatuh tempo lewat field "Lama pembayaran" (P713, field ini
    sendiri tidak eksplisit ada di form Tambah Pelanggan — lihat Q-RP-02).
  - Relasi Agen dipakai di **Saldo Agen (OP-18)**, yang secara XML persis melanjutkan langsung
    setelah rentang dokumen ini (P738 dst) — Cabang yang sama yang membuat agen juga yang
    topup saldo agen tersebut; dan di **Jual Tiket Agen (AG-05, portal `/agen`)** untuk
    penerapan komisi (P735).
  - Data email/nomor WA Relasi Pelanggan disebut "bisa digunakan juga" di menu **Petugas Scan**
    (P724, terkait OP-21/SC-01) — hubungan persis kedua data ini ambigu, lihat Q-RP-03.
  - **Karena statusnya sebagai data referensi**, hindari menghapus data uji `AUTOTEST-<tgl>-`
    Pelanggan/Agen/Komisi setelah dipakai skenario lintas modul (Jual Tiket, Piutang, Saldo
    Agen) sebelum dikonfirmasi aman — rule P702–737 **tidak menyatakan eksplisit** larangan
    hapus setelah data dipakai (beda dari Master P482/486/500/501/509/516 yang eksplisit
    melarang), tapi diamnya rule ini **tidak boleh diasumsikan sebagai "boleh dihapus bebas"**
    (pola sama seperti Q-KJ-04 di `kuota-jadwal_analysis.md`).
- **Perbedaan hak Pusat vs Cabang paling eksplisit ada di Relasi Agen, BUKAN di Relasi
  Pelanggan:**
  - **Relasi Agen (P727)**: Operator **Pusat hanya bisa melihat (view)**, tidak bisa menambah
    data agen; **hanya Cabang** yang bisa menambah agen dan mengatur komisinya (P727–737). Ini
    kebalikan arah dari pola Denda Pembatalan di OP-11 (yang justru Pusat-only-write, Cabang
    view-only) — **jangan disamakan arah pembatasannya**, harus diverifikasi terpisah per
    submodul saat scenario-writing.
  - **Relasi Pelanggan (P703–724)**: sumber **tidak menyatakan sama sekali** apakah Pusat
    dibatasi hanya-lihat seperti di Relasi Agen, atau punya akses sama dengan Cabang. Sesuai
    konvensi kajian ini ("akses yang tidak dijelaskan tidak dianggap otomatis tersedia" —
    `module-map-from-rules.md` baris 6), **jangan mengasumsikan Pusat punya akses Tambah
    Pelanggan yang sama dengan Cabang** hanya karena tidak ada larangan tertulis; tandai
    **PERLU VERIFIKASI UI** (lihat Q-RA-04).
- **NOTIFIKASI**: P731–733 (notifikasi login/welcome agen) dan efek serupa yang mungkin ada di
  Relasi Pelanggan harus tunduk pada aturan wajib `docs/agent-guide.md` — bila skenario
  benar-benar membuat data Agen/Pelanggan uji yang memicu pengiriman notifikasi, KONTAK yang
  didaftarkan **wajib** memakai `kontakTestNotifikasi`/`kontakTestWhatsapp` dari `config/env.md`
  (bukan email/WA milik agen/pelanggan produksi nyata), meskipun P731–733 tidak secara eksplisit
  disebut sebagai "e-tiket/invoice/OTP" — perlakuan hati-hati yang sama tetap dianjurkan karena
  ini juga notifikasi keluar ke kontak pihak ketiga.
- **Validasi uniqueness Agen (P729) berskala lintas-cabang/lintas-kota**, sementara visibilitas
  data agen dibatasi per kota (P730, P741–742) — artinya server kemungkinan memvalidasi
  terhadap seluruh database agen (termasuk milik cabang yang datanya tidak terlihat oleh Cabang
  pembuat), bukan hanya terhadap data yang tampil di scope Cabang tsb. Ini **tidak bisa
  diverifikasi penuh** dengan satu akun Cabang yang tersedia (lihat keterbatasan akun uji di
  atas) — PERLU VERIFIKASI UI lanjutan bila ada akun Cabang kedua.
- **Data test**: field bebas teks (Nama Perusahaan, Nama PIC, Keterangan pada Pelanggan; Nama
  Agen/PIC pada Agen bila ada) wajib berprefix `AUTOTEST-<tanggal>-` sesuai aturan wajib
  `docs/agent-guide.md`.

## REQ — Relasi Pelanggan (OP-16, P703–724)

| ID | Aturan | Sumber | Dapat diuji di web? |
|---|---|---|---|
| REQ-PEL-01 | Relasi Pelanggan digunakan untuk metode pembayaran Tunai / TOP (di Jual Tiket). | P704 | Sebagian — field tersimpan di sini; efek metode pembayaran diuji lintas modul (OP-13 Jual Tiket) |
| REQ-PEL-02 | Form Tambah Pelanggan berisi field: Nama Perusahaan, Nama PIC, Pembayaran bisa TOP, Email, Telepon/WhatsApp, Jenis Identitas, Nomor Identitas, Kota/Kab, Alamat Perusahaan, Keterangan. | P705 | Ya |
| REQ-PEL-03 | Semua field wajib diisi kecuali Keterangan; jika field wajib kosong, sistem menampilkan alert required di masing-masing field (per-field, bukan silent). | P706 | Ya — pola BERBEDA dari Master (FND-M-01 silent tanpa pesan), PERLU VERIFIKASI UI untuk teks/selector alert persisnya |
| REQ-PEL-04 | Field Jenis Identitas, Nomor Identitas, dan Kota/Kab adalah field baru; untuk data pelanggan lama, field ini tampil kosong di form input dan tampil strip (-) di halaman detail. | P707 | Sebagian — butuh data pelanggan lama pre-existing sebelum fitur ini ditambahkan; PERLU VERIFIKASI UI apakah environment demo punya data semacam itu (lihat Q-RP-04) |
| REQ-PEL-05 | Jenis Identitas terdiri dari: KTP, SIM, Passport. | P708 | Ya |
| REQ-PEL-06 | Data Kota/Kab diambil dari data master kota di sisi Administrator. | P709 | Sebagian — sumber data lintas portal (`/adminprahu`), nilai dropdown hanya bisa diobservasi dari sisi Operator |
| REQ-PEL-07 | Seluruh data pelanggan yang ditambahkan otomatis tampil saat Relasi Pelanggan melakukan transaksi pemesanan tiket. | P710 | Tidak di OP-16 murni — cross-module (OP-13 Jual Tiket) |
| REQ-PEL-08 | Jika "Pembayaran bisa TOP" TIDAK dicentang, data pelanggan tidak masuk ke metode pembayaran TOP. | P711 | Tidak di OP-16 murni — cross-module (OP-13 Jual Tiket) |
| REQ-PEL-09 | Jika "Pembayaran bisa TOP" dicentang, data pelanggan masuk ke metode pembayaran TOP DAN Tunai. | P712 | Tidak di OP-16 murni — cross-module (OP-13 Jual Tiket) |
| REQ-PEL-10 | "Lama pembayaran" berfungsi menghitung jangka waktu tempo di halaman Daftar Piutang. | P713 | Sebagian — field ini tidak eksplisit ada di daftar field P705 (lihat Q-RP-02); efek tempo diuji lintas modul (OP-15 Daftar Piutang) |
| REQ-PEL-11 | Di Detail Pelanggan → Tambah Diskon, operator dapat menambahkan diskon dengan jenis persentase atau nominal rupiah. | P714 | Ya |
| REQ-PEL-12 | Diskon pelanggan berlaku berdasarkan rute tertentu, jenis tiket, golongan tiket, dan kelas/kondisi kendaraan yang dipilih. | P715 | Ya (field-level); efek penuh saat transaksi cross-module (OP-13) |
| REQ-PEL-13 | Diskon otomatis mengurangi total harga di halaman pembayaran ketika Pelanggan dipilih DAN rute + atributnya (jenis tiket, golongan, kelas/kondisi) sesuai. | P716 | Tidak di OP-16 murni — cross-module (OP-13 Jual Tiket) |
| REQ-PEL-14 | Jika diskon tidak sesuai dengan tiket yang diorder, diskon tidak berlaku. | P717 | Tidak di OP-16 murni — cross-module (OP-13 Jual Tiket) |
| REQ-PEL-15 | Aturan Tambah Diskon Pelanggan mengikuti aturan yang sama dengan Master Harga. | P718 | Ya, dengan CATATAN: jangan diulang sebagai REQ baru — rujuk langsung ke `master_analysis.md` REQ-016/018/020 (larangan kombinasi duplikat, dsb; lihat "Ringkasan tumpang tindih" di bawah) |
| REQ-PEL-16 | Jika Jenis Tiket = Penumpang atau Kendaraan, Golongan Tiket dan Kelas/Kondisi Kendaraan tampil menyesuaikan Jenis Tiket yang dipilih. | P719 | Ya |
| REQ-PEL-17 | Jika Jenis Tiket = Bagasi, field Kelas/Kondisi Kendaraan otomatis tampil disabled dengan value "Bagasi". | P720 | Ya |
| REQ-PEL-18 | Format tampilan diskon menyesuaikan Jenis Diskon: persen menampilkan label "%" di depan field input harga, rupiah menampilkan format sebaliknya. | P721 | Ya |
| REQ-PEL-19 | Diskon persen maksimal 100%; penanda desimal memakai koma (,). | P722 | Ya |
| REQ-PEL-20 | Persentase diskon dikalikan dengan TOTAL HARGA ORDER (bukan harga per-tiket), contoh: diskon 5% × Rp100.000 = Rp5.000. | P723 | Sebagian — field/nilai bisa diuji di OP-16 sebagai contoh tunggal; basis perhitungan untuk order campuran (sebagian tiket cocok kriteria, sebagian tidak) belum eksplisit — lihat Q-RP-01 (= Q-12 di `module-map-from-rules.md`) |
| REQ-PEL-21 | Email dan nomor WA yang didaftarkan di Relasi Pelanggan "bisa digunakan juga" di menu Petugas Scan, karena data Relasi Pelanggan hanya dipakai di web sedangkan data Petugas Scan dipakai di aplikasi scanner. | P724 | Tidak di OP-16 murni — cross-module (OP-21 Petugas Scan / SC-01); makna persis relasinya ambigu, lihat Q-RP-03 |

## REQ — Relasi Agen (OP-17, P726–737)

| ID | Aturan | Sumber | Dapat diuji di web? |
|---|---|---|---|
| REQ-AGN-01 | **Operator Pusat tidak bisa menambahkan data agen — hanya bisa melihat (view). Hanya akun Cabang yang bisa menambahkan data agen.** | P727 | Ya — pembatasan hak Pusat vs Cabang paling eksplisit di modul ini |
| REQ-AGN-02 | Field-field required (bertanda bintang merah) wajib diisi pada form Tambah/Edit Agen. | P728 | Ya, tapi pola pesan error (alert per-field seperti Pelanggan P706, atau silent seperti pola Master) belum dinyatakan — lihat Q-RA-01 |
| REQ-AGN-03 | Email maupun nomor WA data agen baru tidak boleh sama dengan email/WA yang sudah ada di data Relasi Agen manapun (baik dari cabang terkait maupun cabang kota lain) — validasi bersifat lintas-cabang/lintas-kota. | P729 | Ya sebagian — hanya bisa diuji penuh terhadap data Cabang Pare-Pare sendiri, tidak bisa memverifikasi silang-kota tanpa akun Cabang kedua (lihat "Catatan risiko") |
| REQ-AGN-04 | Data agen yang telah dibuat sebuah Cabang akan muncul juga di sisi Cabang lain yang SEKOTA. | P730 | Sebagian — butuh 2 akun Cabang kota sama, hanya ada 1 di `config/env.md` |
| REQ-AGN-05 | Data agen yang ditambahkan akan menerima notifikasi untuk login di halaman Agen. | P731 | Ya, WAJIB pakai kontak test (lihat "Catatan risiko" — NOTIFIKASI) |
| REQ-AGN-06 | Jika status agen yang ditambahkan adalah "Tidak Aktif" (saat pertama kali dibuat), agen tersebut TIDAK menerima notifikasi apapun. | P732 | Ya, sama catatan kontak test seperti REQ-AGN-05 |
| REQ-AGN-07 | Jika akun agen dinonaktifkan lalu diaktifkan kembali, agen tersebut TIDAK mendapat notifikasi email "Selamat Datang di RORO" (welcome email hanya terpicu sekali, saat pembuatan awal berstatus aktif). | P733 | Ya, sama catatan kontak test seperti REQ-AGN-05 |
| REQ-AGN-08 | Di Detail Relasi Agen, Cabang dapat menambahkan komisi dari tiket yang akan dijual agen; komisi berbentuk persentase. | P734 | Ya |
| REQ-AGN-09 | Komisi agen yang diberlakukan dipakai untuk penjualan tiket oleh Agen Pusat & Sub User Agen, digolongkan berdasarkan rute, jenis tiket, golongan tiket, kelas/kondisi kendaraan. | P735 | Sebagian — field-level bisa diuji di OP-17; efek penuh saat transaksi ada di portal `/agen` (AG-05, di luar cakupan submodul Operator ini) |
| REQ-AGN-10 | Jika komisi agen yang ditambahkan sudah ada di list (duplikat kombinasi), muncul alert **"Komisi sudah ada di database"**. | P736 | Ya — pesan alert eksplisit, langsung testable sebagai assertion negatif |
| REQ-AGN-11 | Data komisi agen dapat dilihat/di-setting oleh Cabang lain yang SEKOTA. | P737 | Sebagian — sama keterbatasan seperti REQ-AGN-04 |

## VAL — validasi form (TERVERIFIKASI via harvest UI 27 Sep 2026 — lihat `relasi_ui-inventory.md`)

| ID | Validasi | Sumber | Catatan |
|---|---|---|---|
| VAL-PEL-01 | Tambah Pelanggan: semua field wajib kecuali Keterangan; kosong → alert required per-field. | P706 | **TERVERIFIKASI PENUH (live + source JS)**: zemPopover per-field, urutan & teks persis di `relasi_ui-inventory.md` M-PEL-01 (mis. "Masukkan Nama Perusahaan", "Masukkan Nama PIC", dst.). Popover Bootstrap `.popover-body`, auto-hilang 1000ms — harus dicek sinkron setelah klik. Keterangan terbukti TIDAK dicek (opsional sesuai rule) |
| VAL-PEL-02 | Format Email dan Telepon/WhatsApp pada form Pelanggan. | — | **TERVERIFIKASI**: Email — regex format (`"Masukkan Email Dengan Benar"`, live-verified) DAN cek unik via AJAX `/partner/cek_email_pelanggan` (`"Email Sudah terdaftar"`). Telepon/WA — hanya cek wajib-isi + unik via AJAX `/partner/cek_wa_pelanggan` (`"Nomor Whatsapp Sudah terdaftar"`), TIDAK ada validasi format/pola angka spesifik yang ditemukan di source |
| VAL-PEL-03 | Field "Lama Pembayaran" — lokasi dan kemunculannya pada form (kemungkinan kondisional saat "Pembayaran bisa TOP" dicentang). | P713 vs P705 | **Q-RP-02 TERJAWAB PENUH**: field `#lama_pembayaran` ADA di form Tambah/Edit Pelanggan yang SAMA (bukan halaman terpisah), tepat di bawah checkbox `#topnya`, `disabled` sampai checkbox dicentang; kosong saat checked → "Masukkan Jumlah Hari"; nilai 0 → native alert "Minimal 1" |
| VAL-PEL-04 | Diskon persen maksimal 100%; input di atas itu ditolak/dibatasi. | P722 | **TERVERIFIKASI dari source**: dibatasi CLIENT-SIDE via Inputmask (`mask: '(9[,9])|(99[,9])|(100)'`, radixPoint koma) + handler keyup/keypress yang memotong nilai >100. Tidak diuji apakah server juga menolak >100 bila client-side dilewati (mis. via `fill()` langsung) |
| VAL-PEL-05 | Jenis Tiket = Bagasi → field Kelas/Kondisi Kendaraan otomatis disabled dengan value "Bagasi". | P720 | **TERVERIFIKASI PENUH LIVE** di `relasi_ui-inventory.md` M-PEL-05: `select#kelas1` disembunyikan, digantikan `input.bagasi_<n>` value="Bagasi" `disabled`. Berlaku utk 2 opsi Jenis Tiket ("Bagasi Kendaraan" DAN "Bagasi Penumpang" — lihat FND-RL-02, rule menyebut "Bagasi" tunggal tapi UI punya 2 varian) |
| VAL-PEL-06 | Filter daftar Relasi Pelanggan menyaring baris sesuai input; Reset mengembalikan daftar penuh. | — | **TERVERIFIKASI berfungsi**: filter `nama_perusahaan=Karya Bersama` menyempitkan 58→1 data. Perilaku 2 tombol "Reset" yang ditemukan di DOM belum dibedakan detail (minor, non-blocking) |
| VAL-AGN-01 | Tambah/Edit Agen: field bertanda bintang merah wajib diisi. | P728 | **Q-RA-01 TERJAWAB**: pola IDENTIK dengan Pelanggan (per-field zemPopover, BUKAN silent seperti Master) — urutan & teks lengkap di `relasi_ui-inventory.md` M-AGN-01. Live-verified: field kosong → "Masukkan Nama Perusahaan" |
| VAL-AGN-02 | Email/WA agen baru tidak boleh duplikat dengan data Relasi Agen manapun (lintas cabang). | P729 | **Sebagian terverifikasi**: cek unik ADA (email → "Email sudah Terdaftar", WA → "Nomor sudah Terdaftar", via flag server `attr("ada")`), tapi SCOPE lintas-cabang/lintas-kota TIDAK bisa dipastikan dari source client (Q-RA-02 tetap terbuka, butuh akun Cabang kota lain) |
| VAL-AGN-03 | Kombinasi komisi (rute, jenis tiket, golongan tiket, kelas/kondisi kendaraan) yang duplikat pada satu agen ditolak dengan alert "Komisi sudah ada di database". | P736 | **SEBAGIAN BERBEDA dari rule**: fungsi duplikat terverifikasi (AJAX `/partner/saveIncludeKomisi`), TAPI teks aktual adalah **"Komisi yang Anda inputkan sudah ada di database"** (native `alert()`, bukan zemPopover), bukan persis "Komisi sudah ada di database" — lihat FND-RL-01. Skenario assertion sebaiknya pakai partial match |
| VAL-AGN-04 | Filter daftar Relasi Agen menyaring baris sesuai input; Reset mengembalikan daftar penuh. | — | Field filter terkonfirmasi ADA (`nama_perusahaan`, `penanggung_jawab`, `telp`, `select#status`: Pilih Status/Aktif/Tidak Aktif) — belum dites fungsional narrowing-nya secara live (beda dari VAL-PEL-06 yang sudah dites), tapi struktur field sudah pasti |

## AC — kriteria penerimaan utama

| ID | Kriteria | REQ |
|---|---|---|
| AC-PEL-01 | Tambah Pelanggan dengan field wajib kosong (kecuali Keterangan) menampilkan alert required per-field dan tidak menyimpan data. | REQ-PEL-03 |
| AC-PEL-02 | Pelanggan `AUTOTEST-<tgl>-` tanpa centang "Pembayaran bisa TOP" hanya tersedia sebagai opsi metode Tunai (tidak muncul di TOP) saat dipilih di Jual Tiket. | REQ-PEL-08 |
| AC-PEL-03 | Pelanggan `AUTOTEST-<tgl>-` dengan centang "Pembayaran bisa TOP" tersedia di kedua metode TOP dan Tunai saat dipilih di Jual Tiket. | REQ-PEL-09 |
| AC-PEL-04 | Diskon pelanggan `AUTOTEST-<tgl>-` yang cocok rute+atribut tiket otomatis mengurangi total harga di halaman pembayaran; diskon yang tidak cocok tidak diterapkan. | REQ-PEL-13, REQ-PEL-14 |
| AC-PEL-05 | Kombinasi diskon duplikat (Golongan Tiket, Mulai Berlaku/rute, Kondisi Kendaraan — pola Master Harga) pada satu pelanggan ditolak/ditandai sesuai perilaku `master_analysis.md` REQ-018/019/020. | REQ-PEL-15 |
| AC-PEL-06 | Diskon persen >100% ditolak saat Simpan. | REQ-PEL-19 |
| AC-PEL-07 | Jenis Tiket = Bagasi otomatis mengunci Kelas/Kondisi Kendaraan = "Bagasi" (disabled) pada form Tambah Diskon. | REQ-PEL-17 |
| AC-AGN-01 | **Operator Pusat TIDAK memiliki aksi Tambah pada Relasi Agen (hanya akses lihat); Operator Cabang MEMILIKI aksi Tambah.** | REQ-AGN-01 |
| AC-AGN-02 | Agen `AUTOTEST-<tgl>-` dengan email/WA yang sudah dipakai agen lain (data Cabang Pare-Pare sendiri) ditolak saat Simpan. | REQ-AGN-03 |
| AC-AGN-03 | Agen `AUTOTEST-<tgl>-` yang dibuat Cabang Pare-Pare muncul di akun Cabang Pare-Pare sendiri dan di akun Pusat (view). Verifikasi silang-kota (muncul di Cabang lain sekota) DITANDAI TIDAK BISA DIUJI PENUH — hanya 1 akun Cabang tersedia. | REQ-AGN-04 |
| AC-AGN-04 | Notifikasi login/welcome HANYA terkirim bila status agen Aktif saat pembuatan pertama; agen berstatus Tidak Aktif tidak menerima notifikasi apapun; reaktivasi tidak memicu ulang welcome email "Selamat Datang di RORO". WAJIB memakai kontak test dari `config/env.md`. | REQ-AGN-05, REQ-AGN-06, REQ-AGN-07 |
| AC-AGN-05 | Komisi agen dengan kombinasi (rute, jenis tiket, golongan tiket, kelas/kondisi kendaraan) duplikat menampilkan alert persis "Komisi sudah ada di database" dan tidak tersimpan. | REQ-AGN-10 |
| AC-AGN-06 | Komisi agen `AUTOTEST-<tgl>-` yang dibuat Cabang Pare-Pare dapat dilihat/di-setting oleh Cabang lain sekota. DITANDAI TIDAK BISA DIUJI PENUH — sama keterbatasan seperti AC-AGN-03. | REQ-AGN-11 |

## Ketidakjelasan (Q-xx)

| ID | Hal | Dampak |
|---|---|---|
| Q-RP-01 | (= Q-12 di `module-map-from-rules.md`) P715–716 menyatakan diskon dibatasi rute/atribut tiket, tetapi contoh perhitungan P723 memakai TOTAL HARGA ORDER. Belum eksplisit basis diskon untuk order campuran (sebagian tiket dalam satu order cocok kriteria diskon, sebagian tidak). | Skenario REQ-PEL-20 hanya diuji dengan order yang SELURUH isinya cocok kriteria diskon (kasus sederhana/tidak ambigu); order campuran TIDAK dijadikan dasar pass/fail sampai diklarifikasi. |
| Q-RP-02 | P713 menyebut field "Lama pembayaran" seolah field yang sudah ada pada Pelanggan, tetapi field ini TIDAK ada dalam daftar field form Tambah Pelanggan di P705. Lokasi/kemunculan field ini (mungkin kondisional saat "Pembayaran bisa TOP" dicentang, mungkin field terpisah di halaman lain) tidak dijelaskan. | Jangan menebak nama/selector field ini sebelum harvest UI menemukannya; REQ-PEL-10 dan efek lintas modul ke OP-15 baru bisa disusun konkret setelah field ditemukan. |
| Q-RP-03 | P724: email/WA Relasi Pelanggan "bisa digunakan juga" di menu Petugas Scan — tidak jelas apakah ini sekadar klarifikasi TIDAK ADA validasi unique lintas dua form (nilai sama boleh dipakai di keduanya tanpa konflik), atau ada mekanisme fungsional lain (mis. auto-suggest/reuse data). | Skenario terkait tidak menguji "integrasi fungsional" antara dua menu ini sampai maknanya jelas dari UI; cukup dicatat sebagai observasi bila relevan. |
| Q-RP-04 | P707 menyebut "data pelanggan yang lama" (sebelum field Jenis Identitas/Nomor Identitas/Kota-Kab ditambahkan) tampil kosong/strip. Belum diketahui apakah environment demo (`config/env.md`) punya data pelanggan pre-existing semacam ini. | REQ-PEL-04 mungkin TIDAK BISA diverifikasi sama sekali bila seluruh data pelanggan di environment demo sudah dibuat setelah fitur ini ada — dicatat sebagai gap cakupan, bukan diasumsikan lulus/gagal. |
| Q-RA-01 | P728 ("field required wajib diisi") tidak menyatakan pola pesan error pada form Agen — berbeda dari Pelanggan yang eksplisit menyebut "alert required di masing-masing field" (P706). Bisa jadi pola sama (per-field) atau pola silent seperti Master (FND-M-01). | VAL-AGN-01 dan AC terkait wajib diverifikasi UI dulu sebelum menulis assertion pesan error spesifik; jangan menyamakan otomatis dengan pola Pelanggan. |
| Q-RA-02 | P729 menyatakan validasi unique email/WA agen berskala lintas-cabang/lintas-kota ("baik dari cabang terkait atau cabang kota lain"), padahal visibilitas data agen dibatasi per kota (P730, P741–742) — cabang di kota lain seharusnya tidak melihat data itu. Mekanisme validasi (server-side global vs sesuatu yang lain) tidak dijelaskan. | Skenario REQ-AGN-03 diuji dulu dengan data milik Cabang Pare-Pare sendiri (aman dipastikan); klaim "berlaku lintas SEMUA kota" tidak divalidasi tanpa akun cabang kota lain, dicatat sebagai gap cakupan. |
| Q-RA-03 | P735 (komisi agen dipakai penjualan tiket Agen Pusat & Sub User Agen) — verifikasi efek penuh memerlukan portal `/agen` (AG-05 Jual Tiket Agen, bagian AGEN P852–1066), yang merupakan portal terpisah dari OP-17 (portal Operator `/partner`). | REQ-AGN-09/AC-AGN terkait dibatasi pada verifikasi field-level di OP-17; efek transaksi nyata dicatat sebagai referensi cross-portal untuk saat modul AG-05 dipetakan/diuji terpisah, bukan bagian wajib dokumen ini. |
| Q-RA-04 | P703–724 (Relasi Pelanggan) TIDAK menyatakan pembatasan Pusat vs Cabang sama sekali — berbeda dari Relasi Agen yang eksplisit di P727. Belum jelas apakah Pusat punya akses Tambah Pelanggan yang sama dengan Cabang, atau turut dibatasi hanya-lihat seperti pola Relasi Agen. | Jangan mengasumsikan salah satu arah (sama akses ATAU dibatasi) tanpa verifikasi UI; skenario Tambah Pelanggan wajib dicoba pada akun Pusat (#2) DAN Cabang (#3) secara terpisah saat harvest, ditandai PERLU VERIFIKASI UI. |

## Perbedaan hak Pusat vs Cabang (ringkasan eksplisit — TERVERIFIKASI LIVE 27 Sep 2026)

| Submodul | Pusat | Cabang |
|---|---|---|
| Relasi Pelanggan (Tambah/Edit/Hapus, Tambah Diskon) | **TERVERIFIKASI: SAMA PERSIS dengan Cabang** — Tambah/Edit/Hapus/Tambah Diskon semua tersedia; melihat 58 dari 58 data (tidak difilter kota). Q-RA-04 TERJAWAB: TIDAK dibatasi hanya-lihat seperti Relasi Agen (lihat `relasi_ui-inventory.md` FND-RL-08) | **TERVERIFIKASI: identik dengan Pusat** — akses & jumlah data yang sama persis |
| Relasi Agen (Tambah/Edit Agen, Tambah Komisi) | **TERVERIFIKASI: HANYA Lihat (view)** — tidak ada tombol Tambah/Edit/Hapus/Tambah Komisi di UI, DAN akses URL langsung ke `/partner/tambahagen`, `/partner/editagen/<id>`, `/partner/tambahkomisiagen/<id>` diblokir server (redirect `/partner/dashboard` + alert akses ditolak) — P727 terkonfirmasi penuh di level UI maupun server (lihat FND-RL-07) | **TERVERIFIKASI: Lihat + Tambah + Kelola** — tombol Tambah Agen, Edit Agen, Hapus Agen, Tambah Komisi semua tersedia dan bisa diakses |
| Visibilitas data Agen/Komisi lintas Cabang | **TERVERIFIKASI**: melihat SEMUA agen (3 dari 3 data, lintas kota) | **TERVERIFIKASI**: hanya melihat agen sekota sendiri (1 dari 1 data, Kota Parepare saja) — konsisten P730/P737/P741, meski verifikasi silang-KOTA LAIN tetap tidak bisa dituntaskan (masih perlu akun Cabang kota lain, lihat keterbatasan akun uji di atas) |

Baris **Relasi Agen** adalah pembatasan hak Pusat vs Cabang yang paling eksplisit di P702–737,
searah dengan pola yang sudah dicatat `module-map-from-rules.md` ("Relasi Agen hanya melihat,
tidak menambah (P727)" untuk Pusat; "Membuat agen dan mengatur komisi (P727–737)... untuk
Cabang") — **kini terverifikasi penuh lewat eksplorasi live, lihat `relasi_ui-inventory.md`**.
Baris **Relasi Pelanggan** justru TIDAK punya pernyataan eksplisit serupa di rule — dan harvest
UI mengonfirmasi dugaan itu benar: aksesnya **SIMETRIS PENUH**, bukan dibatasi seperti Relasi
Agen (Q-RA-04 tertutup, lihat FND-RL-08 di `relasi_ui-inventory.md`).

## Ringkasan tumpang tindih dengan modul yang sudah dipetakan

- **OP-11 Master** (`scenario/master/master_analysis.md`): P718 secara eksplisit menyatakan
  "aturan tambah diskon pelanggan sama seperti master Harga" — REQ-PEL-15 di sini **tidak**
  mengulang logika larangan kombinasi duplikat (Golongan Tiket, Mulai Berlaku, Kondisi
  Kendaraan) yang sudah dianalisis sebagai REQ-016/018/019/020 di `master_analysis.md`. Saat
  scenario-writing, aturan detail duplikat-kombinasi untuk diskon pelanggan harus dirujuk ke
  REQ Master tersebut, bukan ditulis ulang sebagai REQ baru.
- **OP-12 Kuota & Jadwal** (`scenario/kuota-jadwal/kuota-jadwal_analysis.md`): tidak ada
  tumpang-tindih substansi; polanya hanya dipakai sebagai referensi gaya/struktur dokumen
  (keterbatasan "hanya 1 akun Cabang" untuk uji visibilitas sekota/lintas-cabang adalah pola
  yang sama, dicatat ulang di sini karena relevan, bukan duplikasi konten).
- **OP-21 Pengaturan User** (belum ada analysis doc terpisah, hanya module-map P818–849):
  "Hak Akses Agen dan Sub User Agen" yang dipantau operator (list/detail saja, P841/846) adalah
  fitur BERBEDA dari Relasi Agen (OP-17) — yang pertama mengatur hak akses/izin modul untuk
  akun agen, yang kedua mengatur data bisnis/komersial agen (identitas, komisi, saldo). Jangan
  disamakan sebagai modul yang sama saat scenario-writing kedua modul.
- **OP-13 Jual Tiket** (belum dipetakan sebagai analysis doc, P578–666): REQ-PEL-01/07/08/09/13/14
  (metode pembayaran TOP/Tunai dan penerapan diskon otomatis saat transaksi) hanya
  bisa diverifikasi EFEK PENUHnya di modul itu. Saat OP-13 dipetakan nanti, REQ terkait
  pemakaian Relasi Pelanggan sebaiknya dirujuk balik ke REQ-PEL di atas untuk field asalnya,
  bukan didefinisikan ulang dari nol.
- **OP-15 Daftar Piutang** (belum dipetakan sebagai analysis doc, P693–701): field "Lama
  Pembayaran" (REQ-PEL-10, Q-RP-02) adalah sumber data untuk perhitungan tempo piutang di
  modul tsb — dicatat sebagai dependency untuk saat OP-15 dipetakan, bukan duplikasi konten.
- **OP-18 Saldo Agen** (belum dipetakan sebagai analysis doc, P738–760): secara XML modul ini
  langsung melanjutkan P726–737 tanpa jeda topik (P738 = judul "Saldo Agen") — entitas Agen
  yang dibuat di OP-17 adalah PRASYARAT data untuk OP-18 (topup saldo, riwayat saldo). Pola
  pembatasan Pusat-view-only/Cabang-manage yang sama juga berlaku di OP-18 (P739–740, sudah
  dicatat di `module-map-from-rules.md`) — bukan aturan baru, tapi kelanjutan pola yang sama.
- **AD-16/AD-17 Daftar Relasi (Administrator, portal `/adminprahu`, P1987–2014)**: kode OP-16
  dan AD-16 sama-sama tentang "Relasi Pelanggan", tetapi ini modul terpisah untuk portal
  Administrator (Admin bisa tambah/edit/hapus/detail pelanggan SELURUH operator; AD-17 Relasi
  Agen Admin hanya lihat). Tidak relevan untuk pengujian portal Operator (`/partner`) yang jadi
  cakupan dokumen ini — dicatat sebagai referensi saja, hindari kebingungan penomoran saat
  modul Administrator dipetakan terpisah nanti.

## Perlu Verifikasi UI (ringkasan) — SUDAH DIHARVEST 27 Sep 2026

Harvest UI read-only sudah dijalankan (login Pusat #2 + Cabang Pare-Pare #3), hasil lengkap di
`scenario/relasi/relasi_ui-inventory.md`. Status poin-poin di bawah ini (SEMUA TERJAWAB,
disimpan untuk jejak riwayat pertanyaan — bukan lagi item terbuka):

- ~~Apakah Operator Pusat benar-benar tidak punya tombol/akses Tambah pada Relasi Pelanggan~~ →
  **TERJAWAB: Pusat SAMA PERSIS dengan Cabang** (Q-RA-04 tertutup, FND-RL-08).
- ~~Pola pesan error form Tambah/Edit Agen~~ → **TERJAWAB: identik pola per-field Pelanggan**
  (Q-RA-01 tertutup, lihat VAL-AGN-01).
- ~~Lokasi dan kondisi kemunculan field "Lama Pembayaran"~~ → **TERJAWAB: satu form yang sama,
  di bawah checkbox TOP, disabled sampai dicentang** (Q-RP-02 tertutup, lihat VAL-PEL-03).
- ~~Apakah environment demo punya data pelanggan lama~~ → **TERJAWAB: ADA** (contoh "CV Karya
  Bersama" id 3701, Q-RP-04 tertutup, FND-RL-05).
- ~~Teks/selector alert required Pelanggan dan alert duplikat email/WA Agen~~ → **TERJAWAB
  PENUH**, lihat VAL-PEL-01/02 dan VAL-AGN-01/02 di atas serta tabel M-xx di
  `relasi_ui-inventory.md`.
- ~~Field filter daftar Relasi Pelanggan dan Relasi Agen~~ → **TERJAWAB: field terkonfirmasi
  ada di kedua submodul**; VAL-PEL-06 sudah dites fungsional (narrowing 58→1), VAL-AGN-04 baru
  terkonfirmasi struktur field (belum dites narrowing live).
- ~~Constraint client-side diskon persen maksimal 100%~~ → **TERJAWAB: dibatasi client-side via
  Inputmask + keyup/keypress handler** (VAL-PEL-04).

Sisa gap yang MASIH terbuka (butuh sumber daya di luar cakupan sesi harvest ini, BUKAN gagal
harvest):

- **Q-RA-02** (scope validasi unik email/WA Agen — lintas-kota beneran atau cuma per-cabang):
  butuh akun Operator Cabang di kota lain, tidak tersedia di `config/env.md`.
- **Q-RA-03** (efek komisi agen saat transaksi nyata) dan **REQ-PEL-01/07-09/13-14** (efek
  metode bayar/diskon pelanggan saat transaksi nyata): butuh pengujian cross-module di OP-13
  Jual Tiket dan portal `/agen`, di luar cakupan submodul OP-16/OP-17 murni.
- Teks alert duplikat Diskon Pelanggan ("Tidak bisa! Diskon sudah ditambahkan") belum
  dibandingkan langsung dengan teks alert duplikat Master Harga untuk memastikan konsistensi
  penuh REQ-PEL-15 di level pesan (bukan cuma logika).
