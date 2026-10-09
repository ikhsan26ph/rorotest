# Coverage — ro320-pembatasan-order-untuk-user-umum

Validasi artefak scenario selesai; ini bukan hasil eksekusi pengujian aplikasi TMS. Sumber dibaca dari spec dan HTML pendukung, tanpa PNG.

| Kategori | Jumlah |
|---|---:|
| positive | 48 |
| negative | 60 |
| edge | 34 |
| stress | 15 |
| **Total** | **157** |

## Requirements Traceability Matrix

Setiap REQ memiliki minimal satu positive dan satu negative. ID lengkap dicantumkan agar bisa dicari langsung di `.feature`/JSON.

| REQ | Deskripsi | Positive / Negative / Edge / Stress | Scenario IDs |
|---|---|---|---|
| REQ-001 | Batas berlaku hanya pada transaksi User Umum/online publik; pembelian Kantor Cabang dan Agen tetap diizinkan meskipun kuota publik penuh. Channel ditentukan identitas transaksi tepercaya. | 2 / 1 / 0 / 1 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-001<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-002<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-001<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-008 |
| REQ-002 | Penggunaan kuota terisolasi per identitas User + Rute; user lain atau rute lain tidak terpengaruh. | 2 / 2 / 1 / 1 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-003<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-004<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-002<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-003<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-023<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-003 |
| REQ-003 | Arah rute dihitung terpisah; pulang-pergi diperiksa pada masing-masing arah. | 2 / 1 / 0 / 1 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-005<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-006<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-004<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-004 |
| REQ-004 | Default maksimal 2 order selesai per user/rute/hari; batas tersimpan menggantikan default pada keputusan baru. | 2 / 1 / 3 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-007<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-005<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-008<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-003<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-004<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-027 |
| REQ-005 | Periode hari kalender WIB, berganti tepat 00:00 WIB; bukan rolling 24 jam atau tanggal keberangkatan. | 1 / 1 / 2 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-009<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-006<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-014<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-015 |
| REQ-006 | Hanya Selesai/sudah dibayar memakai kuota selesai; Belum Dibayar tidak menambah penghitung selesai. | 2 / 1 / 2 / 1 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-010<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-007<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-011<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-018<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-021<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-005 |
| REQ-007 | Satu order dihitung sekali berapa pun jumlah penumpang/tiket/kendaraannya. | 1 / 1 / 0 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-012<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-008 |
| REQ-008 | Order selesai yang kemudian dibatalkan/refund tidak lagi memakai kuota hari terkait; callback berulang tidak membebaskan slot dua kali. | 2 / 1 / 2 / 1 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-013<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-014<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-009<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-019<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-020<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-006 |
| REQ-009 | Slot direservasi secara atomik saat masuk Isi Data dan ditahan sampai Menunggu Pembayaran, lalu berubah menjadi penggunaan selesai saat dibayar. Tidak boleh melebihi batas dengan tab paralel. | 2 / 1 / 2 / 1 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-015<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-010<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-022<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-024<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-001<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-047 |
| REQ-010 | Banyak order belum dibayar diperbolehkan selama slot tersedia; dua Menunggu Pembayaran pada batas 2 memblokir order baru sampai expired membebaskan reservasi. | 1 / 1 / 2 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-011<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-016<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-025<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-026 |
| REQ-011 | Memilih jadwal memeriksa kuota terbaru; kuota tercapai menghentikan pemilihan/pembuatan order pada rute itu. | 1 / 2 / 0 / 1 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-017<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-012<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-058<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-013 |
| REQ-012 | Sebelum next step, periksa ulang jumlah selesai terbaru dan reservasi; perubahan antar pengecekan wajib terdeteksi. | 1 / 1 / 0 / 1 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-018<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-013<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-002 |
| REQ-013 | Pembatasan dari Isi Data menghapus mekanisme Dibatalkan Sistem karena kuota; pembayaran order dengan reservasi sah tidak membatalkan order pending lain. Expired tetap status terpisah. | 1 / 1 / 0 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-019<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-014 |
| REQ-014 | Saat penuh tampilkan pesan default persis atau pesan konfigurasi terbaru, blokir order baru tanpa mengalihkan ke Isi Data. | 1 / 1 / 0 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-020<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-015 |
| REQ-015 | Informasi batas menyediakan kontak asal dan tujuan yang sesuai rute dipilih, bukan kontak statis Balikpapan/Parepare. | 1 / 1 / 0 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-021<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-016 |
| REQ-016 | Hari berikutnya penghitung selesai mulai 0 pada semua user/rute; pembelian dapat dilanjutkan, dengan reservasi belum expired tetap dipertimbangkan. | 1 / 1 / 1 / 1 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-022<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-017<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-017<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-007 |
| REQ-017 | Menu Pengaturan Sistem, Batas Order User Umum dan Kontak Kantor Cabang hanya dapat dibaca/diubah Admin atau Kantor Pusat, termasuk akses langsung. | 3 / 4 / 0 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-023<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-024<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-018<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-019<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-020<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-021<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-025 |
| REQ-018 | Batas wajib bilangan bulat 1–10; tolak kosong, pecahan, nonangka, nilai di luar range tanpa mengubah setting lama. | 1 / 6 / 2 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-026<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-022<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-023<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-024<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-025<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-026<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-027<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-001<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-002 |
| REQ-019 | Status hanya Aktif/Nonaktif. Nonaktif membebaskan pembatasan jumlah order publik; Aktif kembali menerapkan batas berdasarkan data terkini. | 2 / 1 / 1 / 1 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-027<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-028<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-028<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-028<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-009 |
| REQ-020 | Pesan batas dapat diubah, mempunyai default; kosong/whitespace ditolak menurut desain, teks diperlakukan sebagai konten biasa. | 1 / 2 / 1 / 1 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-029<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-029<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-030<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-009<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-012 |
| REQ-021 | Setiap perubahan setting menyimpan nilai berubah, user dan tanggal/waktu; perubahan batal/gagal tidak menghasilkan histori perubahan sukses. | 1 / 1 / 0 / 1 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-030<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-031<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-010 |
| REQ-022 | Admin pertama-tama melihat daftar operator aktif lalu mengatur kontak di operator terpilih; operator nonaktif tidak tersedia dalam daftar. | 1 / 1 / 1 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-031<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-032<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-030 |
| REQ-023 | Pelabuhan hanya berasal dari Master Trayek asal/tujuan; tidak bisa membuat pelabuhan manual dari menu kontak. | 1 / 1 / 1 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-032<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-033<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-031 |
| REQ-024 | Kontak disimpan per operator + pelabuhan; perubahan satu kontak tidak menimpa operator/pelabuhan lain dan bertahan setelah reload. | 1 / 2 / 2 / 1 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-033<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-034<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-029<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-032<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-060<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-011 |
| REQ-025 | Telepon/WhatsApp wajib, diawali 08 dan panjang 10–13 digit; menolak nilai selain digit sesuai spesifikasi. | 1 / 7 / 2 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-034<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-035<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-036<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-037<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-038<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-039<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-040<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-041<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-005<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-006 |
| REQ-026 | Kontak menyimpan email berformat email; email invalid ditolak. Field ini perlu ditambahkan pada implementasi walaupun tidak terlihat di template. | 1 / 3 / 1 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-035<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-042<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-043<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-044<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-007 |
| REQ-027 | Alamat cabang wajib nonkosong; perubahan dapat disimpan/dibatalkan, hasil tampil ke user. | 1 / 2 / 1 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-036<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-045<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-046<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-008 |
| REQ-028 | Minimal satu hari operasional; Pilih Semua mengaktifkan tujuh hari, kombinasi hari tersimpan konsisten. | 1 / 1 / 2 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-037<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-047<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-010<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-011 |
| REQ-029 | Jam buka/tutup wajib dan tutup setelah buka pada hari yang sama, kecuali Buka 24 Jam; preview mengikuti mode terpilih. | 2 / 4 / 2 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-038<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-048<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-049<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-050<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-051<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-039<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-012<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-013 |
| REQ-030 | Zona waktu jam kontak mengikuti lokasi pelabuhan; zona WIB/WITA/WIT tidak mengubah reset kuota yang tetap WIB. | 1 / 1 / 1 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-040<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-052<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-016 |
| REQ-031 | Dialog Hubungi Kantor Cabang menampilkan nama, alamat, WhatsApp, jam, dan email asal/tujuan; tautan WhatsApp menuju nomor cabang yang benar; Tutup hanya menutup dialog. | 1 / 1 / 0 / 1 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-041<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-053<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-014 |
| REQ-032 | Kontak pada tiket mengambil sumber kontak cabang yang sama; Master CS eksisting di admin dihapus/digantikan tanpa ketergantungan data lama. | 1 / 1 / 0 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-042<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-054 |
| REQ-033 | Simpan Pengaturan menampilkan konfirmasi perubahan; Simpan menerapkan perubahan, Batal mempertahankan data tersimpan; field invalid atau tidak berubah menonaktifkan simpan. | 1 / 2 / 0 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-043<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-055<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-059 |
| REQ-034 | UI menampilkan SISA n DARI L / BATAS TERCAPAI / TANPA BATAS dan waktu berlaku lagi sesuai rute, status dan kondisi slot terkini. | 2 / 1 / 2 / 0 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-044<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-056<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-045<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-033<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-034 |
| REQ-035 | Daftar Order dan Detail Order konsisten menampilkan status, jumlah tiket, tanggal order/bayar, info pembayaran; pembayaran/cetak tiket order sah tetap tersedia tanpa status pembatalan kuota usang. | 2 / 1 / 0 / 1 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-046<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-057<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-015<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-048 |

## Coverage layar dan elemen

| Layar | Elemen tercakup | Contoh scenario |
|---|---:|---|
| Cari Jadwal (`cari-jadwal`) | 12/12 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-003<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-004<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-014 |
| Isi Data (`isi-data`) | 8/8 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-003<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-014<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-017 |
| Daftar Order (`daftar-order`) | 9/9 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-014<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-046<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-048 |
| Detail Order (`detail-order`) | 6/6 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-018<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-021<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-026 |
| Pengaturan Sistem (`pengaturan-sistem`) | 3/3 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-023<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-024 |
| Batas Order User Umum (`batas-order`) | 8/8 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-001<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-002<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-009 |
| Simpan Pengaturan (`konfirmasi-pengaturan`) | 3/3 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-001<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-002<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-009 |
| Riwayat Perubahan (`riwayat-perubahan`) | 2/2 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-031<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-030<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-010 |
| Operator Aktif (`operator-aktif`) | 2/2 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-030<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-032<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-023 |
| Kontak Kantor Cabang (`kontak-cabang`) | 5/5 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-005<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-006<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-007 |
| Ubah Kontak Kantor Cabang (`ubah-kontak`) | 20/20 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-005<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-006<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-007 |
| Hubungi Kantor Cabang (`hubungi-cabang`) | 5/5 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-016<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-053<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-021 |
| Detail Tiket (`detail-tiket`) | 2/2 | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-054<br>RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-042 |

Seluruh 85 elemen inventory disentuh oleh langkah action/expect. Label/selector usulan tetap memerlukan adaptasi pada implementasi aktual.

| Elemen | Contoh ID |
|---|---|
| cari-jadwal / Kota Asal | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-016 |
| cari-jadwal / Kota Tujuan | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-016 |
| cari-jadwal / Tanggal Berangkat | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-006 |
| cari-jadwal / Ubah Pencarian | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-006 |
| cari-jadwal / Pilih | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-001 |
| cari-jadwal / Jumlah Tiket | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-001 |
| cari-jadwal / Pesan | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-001 |
| cari-jadwal / Kuota Rute | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-044 |
| cari-jadwal / Pesan Batas | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-001 |
| cari-jadwal / Berlaku lagi | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-044 |
| cari-jadwal / Hubungi Kantor Cabang | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-021 |
| cari-jadwal / Daftar Order | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-048 |
| isi-data / Nama Pembeli | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-047 |
| isi-data / Email Pembeli | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-047 |
| isi-data / Nomor HP | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-047 |
| isi-data / Ringkasan Order | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-012 |
| isi-data / Kuota Rute | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-001 |
| isi-data / Kursi ditahan sampai | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-015 |
| isi-data / Lanjutkan Pembayaran | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-047 |
| isi-data / Batal | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-024 |
| daftar-order / Filter | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-046 |
| daftar-order / Menampilkan Data | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-046 |
| daftar-order / Tabel Order | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-014 |
| daftar-order / ID Order | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-046 |
| daftar-order / Info Order | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-014 |
| daftar-order / Data Tiket | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-015 |
| daftar-order / Action Menu | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-046 |
| daftar-order / Bayar Sekarang | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-048 |
| daftar-order / Detail Order | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-046 |
| detail-order / Status Order | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-007 |
| detail-order / Data Order | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-046 |
| detail-order / Info Pembayaran | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-057 |
| detail-order / Bayar Sekarang | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-007 |
| detail-order / Detail Tiket | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-046 |
| detail-order / Kembali | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-046 |
| pengaturan-sistem / Pengaturan Sistem | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-023 |
| pengaturan-sistem / Batas Order User Umum | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-023 |
| pengaturan-sistem / Kontak Kantor Cabang | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-023 |
| batas-order / Batas Order Selesai per Rute | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-008 |
| batas-order / Periode Perhitungan | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-034 |
| batas-order / Status Pembatasan | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-027 |
| batas-order / Pesan Saat Batas Tercapai | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-029 |
| batas-order / Simpan Pengaturan | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-008 |
| batas-order / Lihat Riwayat Perubahan | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-030 |
| batas-order / Info Nonaktif | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-030 |
| batas-order / Order Ditolak 7 Hari | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-034 |
| konfirmasi-pengaturan / Ringkasan Perubahan | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-008 |
| konfirmasi-pengaturan / Simpan | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-008 |
| konfirmasi-pengaturan / Batal | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-031 |
| riwayat-perubahan / Tabel Riwayat | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-030 |
| riwayat-perubahan / Tutup | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-030 |
| operator-aktif / Daftar Operator | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-023 |
| operator-aktif / Pilih Operator | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-025 |
| kontak-cabang / Filter | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-031 |
| kontak-cabang / Menampilkan Data | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-031 |
| kontak-cabang / Tabel Pelabuhan | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-018 |
| kontak-cabang / Ubah kontak | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-025 |
| kontak-cabang / Belum Disetting | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-032 |
| ubah-kontak / Pelabuhan | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-032 |
| ubah-kontak / Alamat | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-036 |
| ubah-kontak / No. WhatsApp | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-025 |
| ubah-kontak / Email Cabang | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-035 |
| ubah-kontak / Senin | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-037 |
| ubah-kontak / Selasa | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-037 |
| ubah-kontak / Rabu | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-037 |
| ubah-kontak / Kamis | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-037 |
| ubah-kontak / Jumat | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-037 |
| ubah-kontak / Sabtu | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-037 |
| ubah-kontak / Minggu | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-037 |
| ubah-kontak / Pilih Semua | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-037 |
| ubah-kontak / Buka 24 Jam | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-039 |
| ubah-kontak / Jam Buka | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-038 |
| ubah-kontak / Jam Tutup | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-038 |
| ubah-kontak / Zona Waktu | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-040 |
| ubah-kontak / Preview Jam | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-038 |
| ubah-kontak / Validasi Kontak | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-035 |
| ubah-kontak / Simpan | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-025 |
| ubah-kontak / Batal | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-029 |
| hubungi-cabang / Kontak Asal | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-021 |
| hubungi-cabang / Kontak Tujuan | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-021 |
| hubungi-cabang / WhatsApp Asal | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-041 |
| hubungi-cabang / WhatsApp Tujuan | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-041 |
| hubungi-cabang / Tutup | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-041 |
| detail-tiket / Kontak Tiket | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-042 |
| detail-tiket / Cetak Tiket | RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-042 |

## Validasi Gherkin dan JSON

- Parser Gherkin resmi lokal (`gherkin-official`, parser tersedia dari pekerjaan RO316) berhasil membaca dan compiler membentuk 157 pickle scenario.
- Semua ID unik, penomoran per kategori berurutan, judul unik, dan empat tag cocok tepat dengan category/priority/requirement/screen JSON.
- Seluruh langkah dan preconditions direkonstruksi dari AST Gherkin dan dibandingkan tepat dengan JSON; termasuk navigate, fill, click, select, check, uncheck, expect.
- Semua scenario memiliki Given dan Then, assertion akhir, field JSON wajib, action yang diizinkan dan selectorHints role/name/testid untuk target UI.
- Summary dihitung ulang dan sama dengan jumlah aktual. Sumber input/extras ada; payload panjang diverifikasi 10000 karakter.
- Tidak ada duplikat exact setelah pembandingan setup/preconditions, langkah dan fixture (fixtureId unik dikeluarkan dari signature).

## Dedup dan perbaikan review

- Draf “Dua pending diizinkan selama kedua slot masih tersedia” digabung dengan kasus REQ-006 yang juga memeriksa C tetap nol dan R menjadi dua. REQ-010 tetap memiliki positive pelepasan slot lewat expired; tidak ada coverage hilang.
- Draf “Batal pada konfirmasi tidak menerapkan nilai draft” digabung dengan kasus REQ-021 pembatalan konfirmasi yang memeriksa setting dan histori tetap. REQ-033 tetap memiliki negative pristine dan gagal simpan.
- Positive next step diperjelas dengan perubahan refund antar Pilih dan Pesan sehingga berbeda dari happy path order kedua.
- Perbaikan konsistensi: preconditions mengambil role/channel/rute/jam/setting dari fixture yang telah dioverride; panjang payload 10000 karakter; semua scenario diakhiri expect.
- Kasus dengan field/kategori serupa dipertahankan ketika oracle berbeda: admission vs histori, C vs reservasi, pembacaan jadwal vs next step, callback duplikat vs expiry race.

## Gap dan batas validasi

- **Gap cakupan requirement/elemen: tidak ada** dalam model analisis ini; 35/35 REQ punya positive dan negative; 13/13 layar dan 85/85 elemen tercakup.
- **Gap keputusan bisnis:** formula C+R, pending lintas tengah malam, paidAt sebagai hari perhitungan, reservasi sah saat L turun/Nonaktif diaktifkan, wajib email, normalisasi WA dan pelepasan draft saat Batal adalah interpretasi AUTO MODE. Rincian ada pada A01–A15 di analysis.
- **Konflik desain/spec:** refund kembali mengikuti spec; Dibatalkan Sistem karena kuota tidak dipakai; akses setting Kantor Cabang tidak diizinkan; list operator dan email diturunkan dari spec karena tidak terlihat di template.
- **Gap implementasi:** URL/endpoint/ARIA/testid/seed harness TMS belum tersedia. Native input number memakai spinbutton; custom dropdown perlu adapter; dua link WhatsApp perlu scope region/testid. Mutation request, callback, concurrency, clock dan invariant C/R dijalankan lewat harness, bukan tombol prototipe.
- **Gap eksekusi:** validasi ini memeriksa artefak, bukan menjalankan 157 test pada aplikasi TMS. Server upload input bukan aplikasi pemesanan. Pesan expect semantik harus dipetakan ke assertion teks/visibility/disabled/href/data sesuai oracle, bukan semuanya toBeVisible.
- **Gap performa:** stress punya volume dan kondisi beban konkret tetapi tidak menetapkan SLA yang tidak ada di spec. Panjang teks maksimum, wording error fallback kontak, refund sebagian dan strategi konflik setting perlu keputusan produk.
- Rekomendasi setelah keputusan produk tersedia: kunci oracle untuk reservasi lintas hari/perubahan setting dan refund sebagian, tentukan maksimum field/SLA, realisasikan seed/intersepsi lalu eksekusi suite Playwright. Tidak ada scenario tambahan wajib untuk REQ yang sudah diekstrak.
