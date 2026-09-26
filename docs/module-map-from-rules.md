# Pembagian modul per pengguna — Rule RORO 1.5.0

Sumber: `scenario/Dokumen Rule RORO v1.5.0 v19042025.docx`.
Tanggal kajian: 24 September 2026.

Dokumen ini memetakan aturan tertulis, bukan hasil eksplorasi aplikasi atau hasil pengujian. Nama dan pengelompokan modul mengikuti judul serta isi sumber. Kode OP, AG, UM, SC, dan AD adalah pengenal kajian ini, bukan nama menu aplikasi. Akses yang tidak dijelaskan tidak dianggap otomatis tersedia.

Rujukan `P<n>` adalah indeks paragraf XML DOCX, mulai 0, termasuk paragraf kosong dan paragraf di tabel, dalam urutan `word/document.xml//w:p`. Ini bukan nomor halaman. Judul bagian ikut dicantumkan agar sumber dapat dicari langsung dalam Word.

## Cakupan

- Termasuk: Operator Pusat, Cabang, Sub User Pusat/Cabang, Agen Pusat, Sub User Agen, Pembeli Umum, Petugas Scanner, Administrator, dan Sub User Administrator.
- Dikecualikan sesuai instruksi pengguna: Apps JN Member dan Admin SS, beserta fungsi yang terkait membership (Master Member, Aksi Member, Setting Template Reward, poin, level, reward, dan voucher khusus member).
- Voucher General, validasi pengguna web, dan fungsi penjualan umum tetap dipetakan. Ketergantungan terhadap membership/Admin SS tidak dijadikan modul aktif dalam kajian ini.
- Administrator adalah bagian terpisah dari Admin SS dalam sumber: ADMINISTRATOR mulai P1531; Admin SS mulai P2094.
- Sumber menggabungkan Operator Pusat/Cabang. Karena itu modul bersama dipetakan sekali, lalu batas pengguna dijelaskan secara eksplisit; tidak dibuat matriks izin lengkap yang tidak tersedia di sumber.

## 1. Operator Pusat dan Cabang

Sumber utama: bagian OPERATOR PUSAT / CABANG, P7–851.

| Kode | Modul | Submodul / cakupan tertulis | Rujukan |
|---|---|---|---|
| OP-01 | Registrasi | Email, OTP, kelengkapan registrasi, registrasi terkirim | Registrasi, P8–33 |
| OP-02 | Login dan pemulihan kata sandi | Login, lupa kata sandi, OTP, kata sandi baru | Login, P34–60 |
| OP-03 | Riwayat Saldo Operator | Potongan penjualan, pengembalian, topup, transaksi umum kedaluwarsa | P61–80 |
| OP-04 | Topup Saldo Deposit | Topup mandiri melalui Virtual Account, saldo dan tiga transaksi terakhir | P82–84 |
| OP-05 | Dashboard | Statistik per channel/per jadwal; penjualan penumpang, kendaraan, bagasi penumpang/kendaraan; tiket pekerja dan gratis | P85–201 |
| OP-06 | Laporan | Penjualan harian, rincian penumpang, rincian kendaraan, pendapatan per trip, pemakaian saldo, pembatalan tiket | P202–288 |
| OP-07 | Voucher General | Pembuatan, perubahan, penghapusan bersyarat, periode, kuota, pembagian diskon, pemakaian dan filter | Voucher, P289–322; bagian membership dikecualikan |
| OP-08 | Manifest | Daftar/detail, ringkasan, status boarding, export Excel, kirim ke Pelindo | P323–338 |
| OP-09 | Terminal — Konter Tiket | Pilih jadwal, pencarian tiket, cetak boarding pass, konfirmasi cetak, pemeriksaan Pelindo | P454–470 |
| OP-10 | Terminal — Data Kendaraan | Penjualan kendaraan belum/sudah bayar, muatan, nomor polisi/rangka, pengecualian tiket batal/kedaluwarsa | P471–479 |
| OP-11 | Master | Kelas, Golongan, Kapal, Trayek, Harga/riwayat harga, Tarif Pass Pelabuhan, Crew, Denda Pembatalan, Informasi | P480–551 |
| OP-12 | Kuota dan Jadwal | Tambah/edit kuota, jadwal, crew list, kuota internal/eksternal, bonus kendaraan, tutup jadwal, kirim jadwal ke Pelindo | P552–577 |
| OP-13 | Jual Tiket | Cari rute, isi/edit pesanan, tambah tiket, pembayaran Tunai/TOP/Pekerja/Gratis, voucher, e-tiket, batal order | P578–666; khusus Cabang/Sub User Cabang |
| OP-14 | Daftar Penjualan | Cakupan penjualan lintas cabang/agen, status pesanan, dokumen tiket, penanggung jawab pembayaran, dampak pembatalan | P667–692 |
| OP-15 | Daftar Piutang | Pesanan TOP, jatuh tempo, penandaan lunas satu kali, kwitansi, dampak pembatalan | P693–701 |
| OP-16 | Daftar Relasi — Pelanggan | Data pelanggan, opsi TOP, tempo pembayaran, diskon berdasarkan rute/atribut tiket | P702–724 |
| OP-17 | Daftar Relasi — Agen | Pembuatan/aktivasi agen, notifikasi, komisi agen, pembatasan kota cabang | P726–737 |
| OP-18 | Saldo Agen | Topup, riwayat saldo, riwayat topup, identitas cabang yang melakukan topup | P738–760 |
| OP-19 | Persetujuan Tiket | Pengajuan tiket gratis; keputusan setuju/tolak satu kali; cakupan pusat/cabang | P761–764, P648 |
| OP-20 | Pembatalan Tiket | Penjualan Cabang, validasi pembatalan Penjualan Agen, Rekap Pembatalan, bukti pembatalan | P765–816 |
| OP-21 | Pengaturan User | Hak Akses, Sub User, Petugas Scan, pemantauan Hak Akses Agen dan Sub User Agen | P818–849 |
| OP-22 | Akun Saya | Cabang hanya melihat; rincian kemampuan pusat tidak diuraikan dalam bagian ini | P850–851 |

### Perbedaan pengguna yang dinyatakan sumber

| Pengguna | Pembagian dan batas yang dapat dipastikan |
|---|---|
| Operator Pusat | Tidak menjual melalui Jual Tiket (P580). Mengatur denda pembatalan, sedangkan cabang hanya melihat (P540). Relasi Agen hanya melihat, tidak menambah (P727). Saldo Agen hanya melihat riwayat saldo/topup, tidak topup (P739). Dapat batal order pesanan cabang (P691). Informasi dari pusat ditampilkan ke seluruh agen dalam cakupannya (P547). |
| Cabang | Jual Tiket tersedia (P580). Membuat agen dan mengatur komisi (P727–737), melakukan topup saldo agen sekota (P740–746). Denda pembatalan master hanya melihat meskipun diberi hak setting (P540). Akun Saya hanya melihat (P851). |
| Sub User Pusat | Data mengikuti pusat; akses melalui pengaturan user. Tidak diasumsikan semua izin pusat otomatis diberikan (P819–830). Tidak termasuk pengguna yang diizinkan Jual Tiket pada P580. |
| Sub User Cabang | Jual Tiket disebut eksplisit (P580). Data mengikuti jenis user, konter, dan kota cabang; akses modul mengikuti pemberian hak akses (P819–830). |

Registrasi dan topup deposit ada dalam bagian gabungan operator, tetapi sumber tidak memberikan matriks izin terpisah untuk setiap jenis sub user. Jangan menganggap setiap akun cabang/sub user bisa registrasi mandiri atau topup deposit operator.

### Aturan lintas modul operator yang harus dipertahankan

- Pembatasan data tidak seragam: Dashboard/Daftar Penjualan mempertimbangkan penjual dan kota keberangkatan; Data Kendaraan tidak membedakan pusat/cabang; Laporan Pemakaian Saldo dibatasi hak akses, bukan kota (P92–108, P268, P472, P668–671).
- Kuota internal untuk cabang; cabang dapat memakai eksternal setelah internal habis. Agen/umum memakai eksternal dan tidak dapat melanjutkan ketika eksternal habis (P568–570, P586–589).
- Bonus kendaraan masuk perhitungan kuota bonus kendaraan; tidak mengambil kuota penumpang reguler pada tampilan pencarian (P571, P605). Bonus tampil sebagai Sopir/Kernet pada laporan dan manifest.
- Penjualan cabang/agen masuk statistik pada Konfirmasi Cetak E-Tiket; umum pada Pembelian Berhasil (P118–119). Jangan menyamakan seluruh tahap pengakuan transaksi.
- Tiket batal tetap tercatat pada laporan harian, tetapi hilang dari rincian penjualan dan rekap pendapatan per trip (P211, P238, P251, P264).
- Manifest mengecualikan bagasi; status berubah setelah cetak boarding pass dan setelah scan disinkronkan. Kirim manifest ke Pelindo memerlukan jadwal sudah dikirim dan ditutup (P324–338).
- Hak Akses Agen dan Sub User Agen pada operator hanya list/detail; tambah/edit/hapus milik Agen Pusat (P841, P846).

## 2. Agen Pusat dan Sub User Agen

Sumber utama: AGEN, P852–1066.

| Kode | Modul | Submodul / cakupan | Rujukan |
|---|---|---|---|
| AG-01 | Login dan pemulihan kata sandi | Tanpa registrasi mandiri, akun dibuat cabang; akun tidak aktif ditolak; lupa sandi dan OTP | P853–873 |
| AG-02 | Akun Saya | Login pertama diarahkan ke edit profil | P874–875 |
| AG-03 | Riwayat Saldo | Penjualan, topup, komisi, pembulatan, saldo bersama agen pusat/sub user | P876–889 |
| AG-04 | Dashboard | Jadwal tersedia dan informasi dari pusat/cabang | P890–896 |
| AG-05 | Jual Tiket | Pencarian, isi/edit pesanan, tambah tiket, pembayaran Tunai, e-tiket, batal order | P898–955 |
| AG-06 | Daftar Penjualan | Status, pembatasan kepemilikan pesanan, cetak/unduh dokumen, batal order | P956–975 |
| AG-07 | Pembatalan Tiket | Pengajuan pembatalan, denda, validasi cabang, rekap dan bukti pembatalan | P976–1009 |
| AG-08 | Laporan | Penjualan harian, rekap penjualan per trip, pembatalan tiket, export | P1010–1058 |
| AG-09 | Pengaturan User | Hak Akses dan Sub User; pengelolaan oleh Agen Pusat | P1059–1066, P841, P846 |

| Pengguna | Batas akses/data |
|---|---|
| Agen Pusat | Daftar penjualan, laporan harian, laporan pembatalan, dan rekap pembatalan mencakup dirinya dan sub user terkait. Dapat mengajukan pembatalan tiket dirinya/sub user dan batal order keduanya sesuai status. Tidak dapat melanjutkan pembayaran/konfirmasi e-tiket pesanan sub user. Mengelola hak akses dan sub user agen. |
| Sub User Agen | Daftar penjualan, laporan harian/pembatalan, pengajuan dan rekap pembatalan terbatas pada transaksi miliknya. Tidak diberi kemampuan pengelolaan user yang oleh sumber dikhususkan ke Agen Pusat. |

Rujukan pembeda: P964–973, P978–983, P1005–1008, P1013–1015, P1043–1048, P841/P846. Rekap penjualan menyebut cakupan Agen Pusat pada P1031, tetapi tidak merinci cakupan Sub User secara terpisah di subbagian tersebut.

Aturan khusus: saldo deposit dipakai bersama (P889); tidak ada pilihan Relasi Pelanggan (P917); pembayaran hanya Tunai (P929); setelah Sudah Bayar tidak dapat edit/batal order (P942). Pengajuan pembatalan hanya buat/detail, bukan edit/hapus, dan memerlukan validasi cabang (P978, P1000–1003). Tiket batal tidak mengurangi laporan penjualan harian maupun rekap penjualan agen (P1024, P1040).

## 3. Pembeli Umum

Sumber utama: PEMBELI UMUM, P1067–1187.

| Kode | Modul | Submodul / cakupan | Rujukan |
|---|---|---|---|
| UM-01 | Registrasi | Email atau WhatsApp, normalisasi nomor 0/62, OTP, kelengkapan akun, captcha | P1068–1105 |
| UM-02 | Login dan pemulihan kata sandi | Email/WA dan sandi, Google, lupa sandi, captcha, OTP, sandi baru | P1106–1132 |
| UM-03 | Order Tiket — Cari Jadwal | Cari sebelum/setelah login, wajib login untuk pesan, detail filter, PP lintas operator, batas 10 tiket | P1133–1153 |
| UM-04 | Order Tiket — Isi Data | Pembeli, penumpang/kendaraan, data dewasa, hapus tiket, minimum tiket tiap arah, submit order | P1154–1166 |
| UM-05 | Order Tiket — Pembayaran | Detail pembayaran, countdown, ketentuan OVO/DANA/Alfamart; voucher dan ganti metode disembunyikan | P1167–1176 |
| UM-06 | Daftar Pembelian | Memilih/Menunggu Pembayaran, kedaluwarsa, pembatalan seluruh/sebagian tiket, E-Bagasi, pengembalian saldo operator | P1179–1187 |

- Akun langsung aktif setelah registrasi (P1108); OTP registrasi/reset berlaku 5 menit, berbeda dari operator/agen yang tertulis 1 menit.
- Akun Saya disebut sebagai tujuan login pertama (P1109), tetapi tidak mempunyai uraian modul tersendiri pada bagian pengguna umum. Tidak ditambahkan sebagai modul CRUD profil.
- Pembatalan di Daftar Pembelian adalah aturan tampilan/dampak pembatalan. Sumber tidak menetapkan modul pengajuan refund atau pembatalan mandiri Pembeli Umum.
- Submit ke pembayaran memotong saldo operator; pesanan kedaluwarsa mengembalikan saldo dan menghilangkan data pemakaian saldo terkait (P1164–1166, P1187).

## 4. Petugas Scanner / Apps Scanner

Sumber: APPS SCANNER, P1188–1200; Pengaturan User → Petugas Scan, P835–839.
Pembagian di bawah adalah kelompok fungsi dari paragraf sumber; bukan klaim bahwa ada enam menu dengan nama persis ini.

| Kode | Kelompok fungsi | Aturan |
|---|---|---|
| SC-01 | Akun dan hak akses | Akun dari partner pusat, akses check-in/boarding atau salah satu, perubahan hak akses real time, akun tidak aktif tidak dapat login |
| SC-02 | Download jadwal | Download sebelum scan, pembatasan waktu jadwal dan pelabuhan penugasan |
| SC-03 | Scan Check-in | Memerlukan internet; sesuai pelabuhan tugas; scan ulang memberi Sudah Check In |
| SC-04 | Scan Boarding | Dapat offline; scan ulang memberi Sudah discan |
| SC-05 | Sinkronisasi | Upload scan ke manifest; sinkronisasi scan terdahulu dilakukan sebelum download/sinkron berikutnya |
| SC-06 | Validasi tiket batal | Tiket yang sudah dicetak tetapi dibatalkan ditolak ketika check-in/boarding |

Sumber menjelaskan aplikasi scanner, bukan web scanner. Belum ada hasil pemeriksaan perangkat atau kemampuan otomasi aplikasi ini.

## 5. Administrator dan Sub User Administrator

Sumber utama: ADMINISTRATOR, P1531–2093, dengan pengecualian membership.

| Kode | Modul | Submodul / cakupan dan batas tertulis | Rujukan |
|---|---|---|---|
| AD-01 | Dashboard | Statistik channel/jadwal, penumpang/kendaraan/bagasi, pekerja/gratis; seluruh operator dan filter operator | P1532–1602 |
| AD-02 | Laporan | Penjualan harian, rincian pendapatan penumpang/kendaraan, rekap per trip, pemakaian saldo, pembatalan | P1603–1676 |
| AD-03 | Monitor Saldo | Saldo operator, topup, riwayat saldo/topup, potong saldo, riwayat potongan dan dokumen | P1677–1713 |
| AD-04 | Master Admin | Referensi Tarif Pass, Komisi Transaksi, S&K Operator, Nomor/Email CS per Cabang, Setting General | P1714–1739 |
| AD-05 | Validasi Akun | Validasi User Umum non-member dan Operator, detail/edit sesuai batas field, aktif/nonaktif | P1748–1773; aturan membership dikecualikan |
| AD-06 | Pengaturan Akun | Hak Akses administrator, hierarki akses, Sub User administrator | P1888–1912 |
| AD-07 | Manifest | Lihat, ringkasan, export Excel seluruh operator; tidak kirim ke Pelindo | P1913–1922 |
| AD-08 | Terminal — Konter Tiket | Cari tiket setelah memilih operator/jadwal; hanya melihat, tidak cetak boarding pass | P1923–1927 |
| AD-09 | Terminal — Data Kendaraan | Penjualan kendaraan per trip seluruh operator, belum/sudah bayar | P1928–1930 |
| AD-10 | Daftar Penjualan | Semua channel/operator, rincian, cetak/unduh E-Tiket/E-Bagasi/kwitansi; tidak membuka status pembayaran tertentu | P1931–1941 |
| AD-11 | Pembatalan Tiket | Penjualan Cabang/Agen hanya detail; rekap dan cetak bukti jika semua pembatalan diterima | P1942–1956 |
| AD-12 | Laporan Agen | Penjualan harian, rekap penjualan, pembatalan agen seluruh operator | P1957–1973 |
| AD-13 | Daftar Piutang | Lihat pesanan TOP dan Piutang/Lunas; bukan menandai lunas | P1974–1979 |
| AD-14 | Persetujuan Tiket | Lihat detail pengajuan gratis, download surat tugas; bukan persetujuan | P1980–1982 |
| AD-15 | Kuota dan Jadwal | Lihat jadwal, crew list, kuota internal/eksternal seluruh operator | P1983–1986 |
| AD-16 | Daftar Relasi — Pelanggan | Tambah/edit/hapus/detail pelanggan dan diskon seluruh operator | P1987–2011 |
| AD-17 | Daftar Relasi — Agen | Hanya lihat daftar/detail/komisi agen seluruh operator | P2012–2014 |
| AD-18 | Voucher General | Pengelolaan voucher, kuota, diskon, pemakaian dan filter; aturan member dikecualikan | P2015–2048 |
| AD-19 | Pengaturan User | Hanya lihat Hak Akses/Sub User operator, Petugas Scan, Hak Akses/Sub User Agen; download aplikasi scanner | P2049–2065 |
| AD-20 | Master Operator | Hanya lihat Kelas, Golongan, Kapal, Trayek, Harga/riwayat, Tarif Pass, Crew, Denda Pembatalan, Informasi | P2066–2093 |

Administrator utama dapat membuat Sub User Administrator. Sub User Administrator tidak dapat membuat sub user lain; kemampuan modulnya sesuai hak akses yang diberikan. Satu sub user dapat memiliki beberapa hak akses dan akses sama dihitung sekali (P1906–1912). Jangan menyamakan Pengaturan Akun administrator dengan Pengaturan User operator/agen yang hanya dapat dipantau.

## 6. Ketidakjelasan yang tidak diselesaikan dengan asumsi

| ID | Bagian sumber | Hal yang perlu ditetapkan sebelum menjadi expected result |
|---|---|---|
| Q-01 | Agen → Pembayaran, P944–945; Voucher, P292/P2018 | Agen disebut dapat memakai voucher, lalu disebut fitur voucher disembunyikan. Voucher General disebut berlaku online, tetapi pembayaran umum juga menyembunyikan voucher (P1168). Tentukan kondisi/versi/channel yang berlaku. |
| Q-02 | Voucher, P301 dan P2027 | Tertulis minimal transaksi tidak boleh lebih besar daripada diskon flat/maksimal diskon persen. Kalimat dipertahankan apa adanya; jangan membalik pertidaksamaan berdasarkan kebiasaan bisnis. |
| Q-03 | Terminal → Konter Tiket, P456/P465 | Rentang awal hari ini sampai 7 hari ke depan, lalu ditambah H-1. Belum ada penegasan rentang final. |
| Q-04 | Jual Tiket Cabang P583; Agen P903 | Cabang menyebut H-1, agen H+1 apabila jadwal belum ditutup. Jangan menyamakan atau mengoreksi tanda tanpa klarifikasi. |
| Q-05 | Master Denda P524–539; Agen Pembatalan P989–992 | Master dapat mengatur waktu/nominal, sedangkan agen menuliskan 1 jam/Rp1.000, 6 jam/100%, 24 jam/50%. Belum dinyatakan apakah nilai tersebut contoh, default, atau aturan tetap. |
| Q-06 | Dashboard bagasi P162–164/P177–183; Administrator P1576/P1584 | Rumus bagasi memuat tarif pass, tetapi bagian lain menyatakan bagasi tidak memiliki tarif pass. Jangan menetapkan tarif tanpa penyelesaian perbedaan ini. |
| Q-07 | Persetujuan gratis P648/P763; status P677/P679 | Ada izin persetujuan cabang/pusat menurut hak akses, tetapi beberapa status hanya menyebut persetujuan pusat. Jangan menganggap harus dua tahap atau pusat saja. |
| Q-08 | Master Harga P508 | Tertulis menghapus baris tetap menghapus meski klik Batal. Perlu dipastikan apakah perilaku yang memang disyaratkan atau catatan masalah; belum dilabeli bug. |
| Q-09 | Laporan Agen → Rekap P1028–1029; Administrator P1964–1965 | Rekap agen disebut seluruh transaksi per trip, sedangkan admin menyebut transaksi harian. Belum disamakan periodenya. |
| Q-10 | Apps Scanner P1190–1191/P1199 | Disebut jadwal hari ini, H+1, dan hilang 24 jam dari jam keberangkatan. Batas kalender versus rolling 24 jam belum diperjelas. |
| Q-11 | Riwayat Saldo Agen P752–755/P881–884 | Tertulis tiga kategori ID transaksi, tetapi hanya dua yang dirinci. Tidak dibuat kategori ketiga sendiri. |
| Q-12 | Relasi Pelanggan P715–716/P723 | Diskon dibatasi rute/atribut tiket, tetapi contoh persen menggunakan total order. Basis diskon untuk order campuran belum eksplisit. |

Ketidakjelasan tersebut tidak menghalangi pembagian modul. Namun, bagian yang terdampak belum boleh menghasilkan verdict pengujian berdasarkan aturan yang dipilih sendiri. URL, selector, kredensial, akses akun aktual, dan implementasi UI belum diverifikasi dalam kajian dokumen ini.
