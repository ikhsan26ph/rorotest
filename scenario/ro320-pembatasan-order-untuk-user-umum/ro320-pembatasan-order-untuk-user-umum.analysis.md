# Analysis — ro320-pembatasan-order-untuk-user-umum

## Requirements

Sumber utama: `inputs/ro320-pembatasan-order-untuk-user-umum/spec.txt`. Konteks pendukung: `extras/desain-ro-1-5-4-batas-order-user-umum.html`, bundle HTML yang template JSON-nya dibaca sebagai teks tanpa menjalankan JavaScript. Tidak ada PNG. Label, pesan, validasi jam, dialog konfirmasi, dan histori diturunkan dari template; aturan bisnis spesifikasi mengatasi konflik prototipe. Tidak ada aplikasi pemesanan TMS aktual di repository ini.

| REQ | Deskripsi dan acceptance criteria | Sumber |
|---|---|---|
| REQ-001 | Batas berlaku hanya pada transaksi User Umum/online publik; pembelian Kantor Cabang dan Agen tetap diizinkan meskipun kuota publik penuh. Channel ditentukan identitas transaksi tepercaya. | General Rules 1–2 |
| REQ-002 | Penggunaan kuota terisolasi per identitas User + Rute; user lain atau rute lain tidak terpengaruh. | General Rules 3 |
| REQ-003 | Arah rute dihitung terpisah; pulang-pergi diperiksa pada masing-masing arah. | General Rules 4–5 |
| REQ-004 | Default maksimal 2 order selesai per user/rute/hari; batas tersimpan menggantikan default pada keputusan baru. | Perhitungan 1; Pengaturan Batas 1–2 |
| REQ-005 | Periode hari kalender WIB, berganti tepat 00:00 WIB; bukan rolling 24 jam atau tanggal keberangkatan. | Perhitungan 2–3 |
| REQ-006 | Hanya Selesai/sudah dibayar memakai kuota selesai; Belum Dibayar tidak menambah penghitung selesai. | Perhitungan 4–5; Order Belum Dibayar 1 |
| REQ-007 | Satu order dihitung sekali berapa pun jumlah penumpang/tiket/kendaraannya. | Perhitungan 6 |
| REQ-008 | Order selesai yang kemudian dibatalkan/refund tidak lagi memakai kuota hari terkait; callback berulang tidak membebaskan slot dua kali. | Perhitungan 7 |
| REQ-009 | Slot direservasi secara atomik saat masuk Isi Data dan ditahan sampai Menunggu Pembayaran, lalu berubah menjadi penggunaan selesai saat dibayar. Tidak boleh melebihi batas dengan tab paralel. | Pengecekan 4; asumsi A01/A04 |
| REQ-010 | Banyak order belum dibayar diperbolehkan selama slot tersedia; dua Menunggu Pembayaran pada batas 2 memblokir order baru sampai expired membebaskan reservasi. | Pengecekan 5; Order Belum Dibayar 2 |
| REQ-011 | Memilih jadwal memeriksa kuota terbaru; kuota tercapai menghentikan pemilihan/pembuatan order pada rute itu. | Pengecekan 1–3 |
| REQ-012 | Sebelum next step, periksa ulang jumlah selesai terbaru dan reservasi; perubahan antar pengecekan wajib terdeteksi. | Pengecekan 1–4 |
| REQ-013 | Pembatasan dari Isi Data menghapus mekanisme Dibatalkan Sistem karena kuota; pembayaran order dengan reservasi sah tidak membatalkan order pending lain. Expired tetap status terpisah. | Order Belum Dibayar 3 |
| REQ-014 | Saat penuh tampilkan pesan default persis atau pesan konfigurasi terbaru, blokir order baru tanpa mengalihkan ke Isi Data. | Kondisi Batas 1–2; Pengaturan Batas 6 |
| REQ-015 | Informasi batas menyediakan kontak asal dan tujuan yang sesuai rute dipilih, bukan kontak statis Balikpapan/Parepare. | Kondisi Batas 3; Kontak 6–7 |
| REQ-016 | Hari berikutnya penghitung selesai mulai 0 pada semua user/rute; pembelian dapat dilanjutkan, dengan reservasi belum expired tetap dipertimbangkan. | Perhitungan 8; Kondisi Batas 4; A04 |
| REQ-017 | Menu Pengaturan Sistem, Batas Order User Umum dan Kontak Kantor Cabang hanya dapat dibaca/diubah Admin atau Kantor Pusat, termasuk akses langsung. | Pengaturan Sistem 1–2 |
| REQ-018 | Batas wajib bilangan bulat 1–10; tolak kosong, pecahan, nonangka, nilai di luar range tanpa mengubah setting lama. | Pengaturan Batas 3; template limitBad |
| REQ-019 | Status hanya Aktif/Nonaktif. Nonaktif membebaskan pembatasan jumlah order publik; Aktif kembali menerapkan batas berdasarkan data terkini. | Pengaturan Batas 4–5 |
| REQ-020 | Pesan batas dapat diubah, mempunyai default; kosong/whitespace ditolak menurut desain, teks diperlakukan sebagai konten biasa. | Pengaturan Batas 6; template msgBad |
| REQ-021 | Setiap perubahan setting menyimpan nilai berubah, user dan tanggal/waktu; perubahan batal/gagal tidak menghasilkan histori perubahan sukses. | Pengaturan Batas 7; template hist |
| REQ-022 | Admin pertama-tama melihat daftar operator aktif lalu mengatur kontak di operator terpilih; operator nonaktif tidak tersedia dalam daftar. | Kontak tambahan list operator |
| REQ-023 | Pelabuhan hanya berasal dari Master Trayek asal/tujuan; tidak bisa membuat pelabuhan manual dari menu kontak. | Kontak 1–3 |
| REQ-024 | Kontak disimpan per operator + pelabuhan; perubahan satu kontak tidak menimpa operator/pelabuhan lain dan bertahan setelah reload. | Kontak operator; A07 |
| REQ-025 | Telepon/WhatsApp wajib, diawali 08 dan panjang 10–13 digit; menolak nilai selain digit sesuai spesifikasi. | Kontak validasi WhatsApp; A08 |
| REQ-026 | Kontak menyimpan email berformat email; email invalid ditolak. Field ini perlu ditambahkan pada implementasi walaupun tidak terlihat di template. | Kontak data minimal dan validasi email; A09 |
| REQ-027 | Alamat cabang wajib nonkosong; perubahan dapat disimpan/dibatalkan, hasil tampil ke user. | Kontak data minimal; template pf.off |
| REQ-028 | Minimal satu hari operasional; Pilih Semua mengaktifkan tujuh hari, kombinasi hari tersimpan konsisten. | Kontak jam sesuai desain; template pd |
| REQ-029 | Jam buka/tutup wajib dan tutup setelah buka pada hari yang sama, kecuali Buka 24 Jam; preview mengikuti mode terpilih. | template timeBad, h24, off |
| REQ-030 | Zona waktu jam kontak mengikuti lokasi pelabuhan; zona WIB/WITA/WIT tidak mengubah reset kuota yang tetap WIB. | template edBr.tz; Perhitungan 2 |
| REQ-031 | Dialog Hubungi Kantor Cabang menampilkan nama, alamat, WhatsApp, jam, dan email asal/tujuan; tautan WhatsApp menuju nomor cabang yang benar; Tutup hanya menutup dialog. | Kontak 4,6–7; template cabs; A09 |
| REQ-032 | Kontak pada tiket mengambil sumber kontak cabang yang sama; Master CS eksisting di admin dihapus/digantikan tanpa ketergantungan data lama. | Kontak 8; A10 |
| REQ-033 | Simpan Pengaturan menampilkan konfirmasi perubahan; Simpan menerapkan perubahan, Batal mempertahankan data tersimpan; field invalid atau tidak berubah menonaktifkan simpan. | template dirty, mSave, diff |
| REQ-034 | UI menampilkan SISA n DARI L / BATAS TERCAPAI / TANPA BATAS dan waktu berlaku lagi sesuai rute, status dan kondisi slot terkini. | template quota; A01/A04/A11 |
| REQ-035 | Daftar Order dan Detail Order konsisten menampilkan status, jumlah tiket, tanggal order/bayar, info pembayaran; pembayaran/cetak tiket order sah tetap tersedia tanpa status pembatalan kuota usang. | template Daftar/Detail Order; spesifikasi improve |

### Aktor dan hak akses

| Aktor | Pembelian | Pengaturan |
|---|---|---|
| User Umum | Online publik dengan batas User + Rute | Tidak dapat membaca/menulis kedua submenu |
| Kantor Cabang | Channel Cabang tidak dibatasi aturan ini | Tidak diizinkan; menuCabang di prototipe berkonflik dengan spec |
| Agen | Channel Agen tidak dibatasi aturan ini | Tidak diizinkan |
| Admin, Kantor Pusat | Pembelian mengikuti channel transaksi yang sebenarnya | Dapat membaca dan mengubah kedua submenu dan kontak operator |
| Tanpa sesi | Tidak dapat mengubah setting atau memakai identitas user lain | Akses langsung ditolak; perilaku login spesifik tidak ditentukan |

### Aturan validasi

| Field/kondisi | Valid | Invalid/pesan |
|---|---|---|
| Batas Order Selesai per Rute | Integer 1–10; default 2 | kosong, 0, -1, 11, 1.5, abc; `Isi angka 1–10.` dari template |
| Status Pembatasan | Aktif / Nonaktif | Nilai lain ditolak; jangan fallback diam-diam |
| Pesan Saat Batas Tercapai | Nonkosong setelah trim | kosong/spasi ditolak; detail pesan error belum ditentukan |
| No. WhatsApp | `^08[0-9]{8,11}$` | `No. WhatsApp wajib diisi.`, `No. WhatsApp harus diawali 08.`, `No. WhatsApp harus 10–13 digit.`; nonangka perlu validasi tambahan |
| Email cabang | Alamat email valid seperti `cabang.bpn@example.test` | kosong/format invalid ditolak menurut A09; pesan belum ditentukan |
| Alamat | Nonkosong setelah trim | kosong/spasi menonaktifkan simpan |
| Hari Operasional | Satu atau lebih dari Senin–Minggu | `Pilih minimal 1 hari operasional.` |
| Jam Operasional | buka < tutup, atau Buka 24 Jam | kosong / tutup ≤ buka; `Jam tutup harus setelah jam buka.` |

### Model kuota dan alur

Untuk pembatasan aktif, `C(u,r,d)` adalah order selesai dibayar pada hari kalender WIB d yang belum dibatalkan/refund. `R(u,r)` adalah reservasi aktif Isi Data/Menunggu Pembayaran yang belum expired. Masuk Isi Data membutuhkan `C + R < L`, lalu reservasi bertambah tepat sekali. Pembayaran sukses mengubah satu R menjadi satu C secara atomik (bukan menambah keduanya); expired melepas satu R. Pembayaran gagal tidak menambah C. Penilaian `C + R` memisahkan penghitung order selesai dari ketersediaan slot sebagaimana A01.

Cari Jadwal → pilih jadwal (cek terbaru) → isi jumlah tiket → Pesan (cek ulang dan reservasi atomik) → Isi Data → Lanjutkan Pembayaran → Menunggu Pembayaran → pembayaran sukses → Order Selesai → Detail Tiket. Ketika penuh: tetap pada langkah sebelumnya → pesan batas → Hubungi Kantor Cabang → lihat dua kontak → WhatsApp/Tutup. Pulang-pergi memeriksa masing-masing arah; tidak dibuat aturan pembatalan keseluruhan perjalanan yang tidak tertulis.

Pengaturan Sistem → Batas Order User Umum → ubah batas/status/pesan → Simpan Pengaturan → tinjau selisih → Simpan/Batal → Lihat Riwayat Perubahan. Kontak Kantor Cabang → pilih operator aktif → daftar pelabuhan Master Trayek → Ubah kontak → validasi → Simpan/Batal → verifikasi di dialog publik/tiket.

## UI Inventory

Inventaris dibaca dari template HTML dan spesifikasi, tanpa PNG atau render browser. Seluruh `testid` dan ARIA yang tidak eksplisit adalah usulan. Label Email Cabang, Operator Aktif dan aksi tiket berasal dari spec. Role `spinbutton` wajib dipakai untuk field batas numerik; aksi JSON `fill` mengikuti role elemen, bukan selalu textbox. Dua tautan WhatsApp memerlukan scope region asal/tujuan atau testid unik.

### Cari Jadwal (`cari-jadwal`)

| Elemen/label | Role + name | Usulan data-testid | Bukti/catatan |
|---|---|---|---|
| Kota Asal | `combobox` + Kota Asal | `cari-jadwal-asal` | spec; template menampilkan readonly, kontrol pencarian aktual diasumsikan |
| Kota Tujuan | `combobox` + Kota Tujuan | `cari-jadwal-tujuan` | spec; template readonly |
| Tanggal Berangkat | `textbox` + Tanggal Berangkat | `cari-jadwal-tanggal` | template label; kontrol aktual diasumsikan |
| Ubah Pencarian | `button` + Ubah Pencarian | `cari-jadwal-ubah-pencarian` | template |
| Pilih | `button` + Pilih | `cari-jadwal-pilih-jadwal` | template; disabled jika penuh |
| Jumlah Tiket | `textbox` + Jumlah Tiket Ekonomi Dewasa | `cari-jadwal-jumlah-tiket` | template input numeric tanpa label; label diusulkan per golongan/kelas |
| Pesan | `button` + Pesan | `cari-jadwal-pesan` | template; disabled jika jumlah tiket nol |
| Kuota Rute | `status` + Kuota rute | `cari-jadwal-kuota` | template quota; ARIA diusulkan |
| Pesan Batas | `alert` + Pesan batas pembelian | `cari-jadwal-pesan-batas` | template; role diusulkan |
| Berlaku lagi | `status` + Berlaku lagi | `cari-jadwal-reset` | template; timestamp harus dinamis |
| Hubungi Kantor Cabang | `button` + Hubungi Kantor Cabang | `cari-jadwal-hubungi` | template |
| Daftar Order | `link` + Daftar Order | `cari-jadwal-daftar-order` | template menu |

### Isi Data (`isi-data`)

| Elemen/label | Role + name | Usulan data-testid | Bukti/catatan |
|---|---|---|---|
| Nama Pembeli | `textbox` + Nama Pembeli | `isi-data-nama` | template wajib |
| Email Pembeli | `textbox` + Email | `isi-data-email` | template |
| Nomor HP | `textbox` + Nomor HP | `isi-data-hp` | template wajib |
| Ringkasan Order | `region` + Ringkasan order | `isi-data-ringkasan` | template; role diusulkan |
| Kuota Rute | `status` + Jatah pembelian rute ini | `isi-data-kuota` | template |
| Kursi ditahan sampai | `status` + Kursi ditahan sampai | `isi-data-reservasi-expiry` | template |
| Lanjutkan Pembayaran | `button` + Lanjutkan Pembayaran | `isi-data-lanjutkan` | template |
| Batal | `button` + Batal | `isi-data-batal` | template |

### Daftar Order (`daftar-order`)

| Elemen/label | Role + name | Usulan data-testid | Bukti/catatan |
|---|---|---|---|
| Filter | `button` + Filter | `daftar-order-filter` | template |
| Menampilkan Data | `combobox` + Menampilkan Data | `daftar-order-page-size` | template pageSizes |
| Tabel Order | `table` + Daftar order | `daftar-order-tabel` | template; ARIA diusulkan |
| ID Order | `link` + ID Order | `daftar-order-id-order` | template; ID konkret sesuai testData |
| Info Order | `button` + Info Order | `daftar-order-info` | template |
| Data Tiket | `button` + Data Tiket | `daftar-order-data-tiket` | template |
| Action Menu | `button` + Action Menu | `daftar-order-action-menu` | template |
| Bayar Sekarang | `button` + Bayar Sekarang | `daftar-order-bayar` | template; perilaku tombol prototype lama tidak menjadi oracle |
| Detail Order | `button` + Detail Order | `daftar-order-detail` | template |

### Detail Order (`detail-order`)

| Elemen/label | Role + name | Usulan data-testid | Bukti/catatan |
|---|---|---|---|
| Status Order | `status` + Status order | `detail-order-status` | template |
| Data Order | `region` + DATA ORDER | `detail-order-data` | template |
| Info Pembayaran | `status` + Informasi pembayaran | `detail-order-info` | template |
| Bayar Sekarang | `button` + Bayar Sekarang | `detail-order-bayar` | template |
| Detail Tiket | `button` + Detail Tiket | `detail-order-tiket` | template |
| Kembali | `button` + Kembali | `detail-order-kembali` | template |

### Pengaturan Sistem (`pengaturan-sistem`)

| Elemen/label | Role + name | Usulan data-testid | Bukti/catatan |
|---|---|---|---|
| Pengaturan Sistem | `link` + Pengaturan Sistem | `pengaturan-sistem-menu` | spec dan template |
| Batas Order User Umum | `link` + Batas Order User Umum | `pengaturan-sistem-batas` | spec dan template |
| Kontak Kantor Cabang | `link` + Kontak Kantor Cabang | `pengaturan-sistem-kontak` | spec dan template |

### Batas Order User Umum (`batas-order`)

| Elemen/label | Role + name | Usulan data-testid | Bukti/catatan |
|---|---|---|---|
| Batas Order Selesai per Rute | `spinbutton` + Batas Order Selesai per Rute | `batas-order-limit` | template type number min 1 max 10 |
| Periode Perhitungan | `status` + Periode Perhitungan | `batas-order-periode` | template readonly |
| Status Pembatasan | `combobox` + Status Pembatasan | `batas-order-status` | template custom dropdown; select adapter mungkin diperlukan |
| Pesan Saat Batas Tercapai | `textbox` + Pesan Saat Batas Tercapai | `batas-order-pesan` | template textarea wajib |
| Simpan Pengaturan | `button` + Simpan Pengaturan | `batas-order-simpan` | template disabled jika unchanged/invalid |
| Lihat Riwayat Perubahan | `button` + Lihat Riwayat Perubahan | `batas-order-riwayat` | template |
| Info Nonaktif | `region` + Status Pembatasan NONAKTIF | `batas-order-nonaktif` | template tanggal/user penonaktifan |
| Order Ditolak 7 Hari | `table` + ORDER DITOLAK KARENA BATAS — 7 HARI TERAKHIR | `batas-order-penolakan` | template; laporan tambahan bukan requirement bisnis baru |

### Simpan Pengaturan (`konfirmasi-pengaturan`)

| Elemen/label | Role + name | Usulan data-testid | Bukti/catatan |
|---|---|---|---|
| Ringkasan Perubahan | `region` + Perubahan pengaturan | `konfirmasi-pengaturan-diff` | template diff |
| Simpan | `button` + Simpan | `konfirmasi-pengaturan-simpan` | template |
| Batal | `button` + Batal | `konfirmasi-pengaturan-batal` | template |

### Riwayat Perubahan (`riwayat-perubahan`)

| Elemen/label | Role + name | Usulan data-testid | Bukti/catatan |
|---|---|---|---|
| Tabel Riwayat | `region` + Riwayat Perubahan | `riwayat-perubahan-histori` | template daftar text/at/by; region diusulkan |
| Tutup | `button` + Tutup | `riwayat-perubahan-tutup` | template |

### Operator Aktif (`operator-aktif`)

| Elemen/label | Role + name | Usulan data-testid | Bukti/catatan |
|---|---|---|---|
| Daftar Operator | `table` + Operator aktif | `operator-aktif-tabel` | spec; tidak ada di template |
| Pilih Operator | `button` + Pilih Operator | `operator-aktif-pilih` | usulan untuk navigasi operator dari spec |

### Kontak Kantor Cabang (`kontak-cabang`)

| Elemen/label | Role + name | Usulan data-testid | Bukti/catatan |
|---|---|---|---|
| Filter | `button` + Filter | `kontak-cabang-filter` | template |
| Menampilkan Data | `combobox` + Menampilkan Data | `kontak-cabang-page-size` | template |
| Tabel Pelabuhan | `table` + Kontak Kantor Cabang | `kontak-cabang-tabel` | template kolom pelabuhan/WA/jam/terakhir diubah/aksi |
| Ubah kontak | `button` + Ubah kontak | `kontak-cabang-ubah` | template ActionButton title |
| Belum Disetting | `status` + Belum Disetting | `kontak-cabang-belum` | template |

### Ubah Kontak Kantor Cabang (`ubah-kontak`)

| Elemen/label | Role + name | Usulan data-testid | Bukti/catatan |
|---|---|---|---|
| Pelabuhan | `heading` + Pelabuhan | `ubah-kontak-pelabuhan` | template edBr.pel readonly; nama konkret mengikuti fixture |
| Alamat | `textbox` + Alamat | `ubah-kontak-alamat` | template textarea wajib |
| No. WhatsApp | `textbox` + No. WhatsApp | `ubah-kontak-wa` | template placeholder Contoh: 081234567890 |
| Email Cabang | `textbox` + Email Cabang | `ubah-kontak-email` | spec; field/label usulan, absen dari template |
| Senin | `button` + Sen | `ubah-kontak-senin` | template toggle hari |
| Selasa | `button` + Sel | `ubah-kontak-selasa` | template toggle hari |
| Rabu | `button` + Rab | `ubah-kontak-rabu` | template toggle hari |
| Kamis | `button` + Kam | `ubah-kontak-kamis` | template toggle hari |
| Jumat | `button` + Jum | `ubah-kontak-jumat` | template toggle hari |
| Sabtu | `button` + Sab | `ubah-kontak-sabtu` | template toggle hari |
| Minggu | `button` + Min | `ubah-kontak-minggu` | template toggle hari |
| Pilih Semua | `button` + Pilih Semua | `ubah-kontak-semua` | template |
| Buka 24 Jam | `checkbox` + Buka 24 Jam | `ubah-kontak-24jam` | template checkbox |
| Jam Buka | `combobox` + Jam Buka | `ubah-kontak-buka` | template 48 opsi interval 30 menit; label diusulkan |
| Jam Tutup | `combobox` + Jam Tutup | `ubah-kontak-tutup-jam` | template 48 opsi interval 30 menit; label diusulkan |
| Zona Waktu | `status` + Zona waktu pelabuhan | `ubah-kontak-zona` | template readonly |
| Preview Jam | `status` + Tampil ke User Umum | `ubah-kontak-preview` | template |
| Validasi Kontak | `alert` + Validasi kontak | `ubah-kontak-validasi` | template pf.err; role diusulkan |
| Simpan | `button` + Simpan | `ubah-kontak-simpan` | template disabled jika invalid |
| Batal | `button` + Batal | `ubah-kontak-batal` | template |

### Hubungi Kantor Cabang (`hubungi-cabang`)

| Elemen/label | Role + name | Usulan data-testid | Bukti/catatan |
|---|---|---|---|
| Kontak Asal | `region` + KOTA ASAL | `hubungi-cabang-asal` | template cabs |
| Kontak Tujuan | `region` + KOTA TUJUAN | `hubungi-cabang-tujuan` | template cabs |
| WhatsApp Asal | `link` + WhatsApp | `hubungi-cabang-wa-asal` | template; scope region KOTA ASAL |
| WhatsApp Tujuan | `link` + WhatsApp | `hubungi-cabang-wa-tujuan` | template; scope region KOTA TUJUAN |
| Tutup | `button` + Tutup | `hubungi-cabang-tutup` | template |

### Detail Tiket (`detail-tiket`)

| Elemen/label | Role + name | Usulan data-testid | Bukti/catatan |
|---|---|---|---|
| Kontak Tiket | `region` + Kontak Kantor Cabang | `detail-tiket-kontak` | spec; halaman tiket lengkap tidak ada di template |
| Cetak Tiket | `button` + Cetak Tiket | `detail-tiket-cetak` | alur spec/template stepper; kontrol usulan |

### State dan konflik desain

- Cari Jadwal: sisa kuota, batas tercapai (Pilih disabled, pesan/kontak), Nonaktif (TANPA BATAS); Pesan disabled ketika jumlah tiket nol.
- Isi Data: reservasi aktif, ringkasan tiket, batas waktu kursi; field pembeli mengikuti alur eksisting, tidak dibuat aturan panjang/format baru.
- Pengaturan: pristine/dirty/invalid, modal konfirmasi, sukses, histori, metadata Nonaktif. Loading/gagal layanan tidak diperlihatkan desain; oracle pemulihan bersifat asumsi A15.
- Kontak: Belum Disetting, form invalid/valid, preview hari/jam/zona, mode Buka 24 Jam, sukses/batal. Tampilan email perlu ditambahkan sesuai spec.
- Daftar/Detail: Menunggu Pembayaran, Selesai, Expired; Dibatalkan Sistem karena batas dan instruksi refund tidak kembali dari prototipe harus dihapus sesuai spec.
- Tabel laporan penolakan 7 hari dibaca sebagai elemen tambahan dan diuji tampil aman; formula agregasi belum menjadi acceptance criterion karena spec tidak menjelaskannya.

Tidak menginventarisasi tombol kontrol PROTOTIPE (Role, Jatah hari ini, Saat bayar) sebagai kontrol produksi. Filter dan pagination yang terlihat diinventarisasi untuk smoke consistency, tanpa menciptakan aturan filter baru.

## Assumptions Log

| ID | Asumsi/konflik dan dampak pada scenario |
|---|---|
| A01 | Spec menghitung hanya order selesai namun juga memblokir dua pending dan mulai Isi Data. Dipakai dua penghitung C dan R; pending tidak menambah C tetapi menahan R. Ini interpretasi, bukan aturan eksplisit tentang formula. |
| A02 | Konflik refund: template mengatakan refund tidak mengembalikan jatah hari sama; spec mengatakan order batal/refund tidak menggunakan kuota. Spec diprioritaskan: kuota kembali setelah pembatalan/refund efektif. Refund sebagian dan refund hanya diajukan belum didefinisikan; tidak diasumsikan melepaskan seluruh order. |
| A03 | Template membatalkan pending otomatis dan menampilkan Dibatalkan Sistem serta modal pembayaran ditolak; spec improve menghapus pembatalan kuota. Scenario menjaga reservasi sah dan menolak order baru, tidak memakai perilaku pembatalan lama. Penanganan penolakan pembayaran di race hanya digunakan bila reservasi tidak sah, tanpa penarikan dana. |
| A04 | Hari C mengikuti waktu pembayaran sukses server dalam WIB; tanggal keberangkatan/klien bukan acuan. Reservasi yang belum expired tidak otomatis dihapus pukul 00:00; C reset, R tetap hingga pembayaran/expired. Batal pada draft Isi Data diasumsikan segera melepas reservasi yang belum menjadi pending. TTL tidak disebut; fixture menggunakan 30 menit dan jam server terkontrol, bukan klaim durasi produk. Race pembayaran/expiry mengikuti satu hasil terminal berdasarkan urutan commit; settlement pembayaran terlambat perlu ditentukan produk. |
| A05 | Nonaktif melewati batas untuk order baru. Penurunan L/aktivasi tidak membatalkan order dibayar atau reservasi yang sudah sah; admission baru memakai setting terbaru, pending sah boleh dibayar. Spec tidak menjelaskan migrasi order saat setting berubah. |
| A06 | Identitas user/rute/channel ditentukan server; double click, callback dan pengecekan paralel idempotent/atomik. Cache stale, gangguan layanan dan manipulasi request diuji lewat fixture/intersepsi terkontrol; jangan mengarang endpoint produksi. |
| A07 | Kontak terikat operator + ID pelabuhan Master Trayek, bukan nama kota. Operator aktif diseleksi sebelum daftar pelabuhan. Operator tidak dimasukkan ke kunci kuota karena spec hanya menyebut User + Rute; ID rute/trayek kanonik dipakai agar jadwal berbeda tetap berbagi kuota. |
| A08 | WA wajib digit literal sesuai spec. Template menghapus non-digit sebelum validasi; input huruf, pemisah, +62 diperlakukan invalid agar aturan 08/10–13 digit tegas. Normalisasi tautan dari 08 menjadi 628 berlaku setelah validasi. |
| A09 | Email ada di spec tetapi tidak ada di modal/template. Diasumsikan wajib karena data kontak minimal menyertakan email; inventaris/selector email adalah usulan. Nama field/operator tambahan mengikuti spec, bukan hasil inspeksi visual PNG. |
| A10 | Penghapusan Master CS ditafsirkan migrasi sumber kontak dan hilangnya menu lama. Tiket baru menggunakan kontak terbaru; tidak diasumsikan PDF tiket lama berubah otomatis. Migrasi data historis tidak dirinci. |
| A11 | Tidak ada PNG dan tidak dilakukan render visual HTML. Inventaris berasal dari teks/atribut template dan spec. Badge sisa memakai slot tersedia C+R; indikator Terpakai boleh menunjukkan C dengan penjelasan R. Data tanggal/rute hardcoded prototype bukan oracle; periode dan kontak harus dinamis. |
| A12 | URL TMS, ARIA, testid, endpoint, format respons dan seed harness belum tersedia. SelectorHints adalah usulan; angka memakai spinbutton sesuai input number, dropdown custom perlu adapter select. Fixture preconditions/testData perlu direalisasikan pada aplikasi TMS, bukan server upload repository ini. |
| A13 | Volume stress 100/500/1000 request/sesi dan latensi injeksi 5 detik adalah parameter uji, bukan SLA. Oracle utama integritas kuota, konsistensi data dan pemulihan; belum ada batas waktu performa kelulusan. |
| A14 | Hari/jam/alamat wajib dan larangan jam lintas tengah malam mengikuti validasi template; Buka 24 Jam membebaskan field jam, bukan kewajiban memilih hari. Format email kompleks, panjang pesan/alamat maksimum dan kontak kosong fallback tidak dispesifikasikan; uji memastikan aman dan tidak memakai kontak rute lain. |
| A15 | Penolakan saat dependency kuota gagal diasumsikan sementara untuk menjaga integritas; pada channel exempt/Nonaktif evaluasi kuota tidak diperlukan. Gagal simpan menjaga data lama dan tidak menulis histori sukses. |

