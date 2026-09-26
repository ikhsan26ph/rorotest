# Eksplorasi Operator Pusat dan Cabang / Sub User

Run mulai 24 September 2026 WIB, dilanjutkan 26 September 2026 WIB. Host: https://jn-rorodemo.prahu-hub.com. Footer UI: 20250211 v1.5.2 — Jembatan Nusantara. Sumber pembanding: Rule RORO v1.5.0.

## Status dan cakupan

- **Operator Pusat:** login berhasil, 44 route utama/submenu dibuka dan diambil screenshot. Tenant PT. JEMBATAN NUSANTARA.
- **Cabang / Sub User Cabang:** login berhasil, 45 route utama/submenu dibuka dan diambil screenshot. Nama user Ikhsan Pare, jenis Cabang, kota Parepare, bagian Penjualan, hak akses Akses IK. Identitas dikonfirmasi dari daftar dan detail Sub User milik pusat serta halaman profil setelah login cabang.
- **Sub User Pusat: blocked untuk login langsung.** Belum ada kredensial akun tersebut di config/env.md. Form pengelolaan sub user sudah diperiksa, tetapi itu bukan verifikasi sesi Sub User Pusat.
- Semua route utama yang tercatat di tabel mengembalikan HTTP 200. Ini membuktikan halaman dapat dibuka, bukan seluruh fungsi bisnis berhasil.
- Read-only: hanya login/logout, navigasi, pemeriksaan DOM dan screenshot; tidak submit data bisnis, booking, cetak tiket, pembayaran, topup, pembatalan, atau perubahan setting.
- Apps JN Member, Master Member/Aksi Member, dan Admin SS dikecualikan. Label membership yang terlihat tidak diikuti.
- Tidak ada folder skenario per modul atau *_scenarios.json di scenario/. DOCX rule bukan skenario siap eksekusi. Semua modul belum siap test detail; eksplorasi/smoke read-only dapat dilakukan.

## Cara membaca bukti

Tabel memuat kontrol dan tautan yang ditemukan pada DOM halaman, termasuk filter/dropdown yang awalnya tertutup. Tidak semua elemen DOM terlihat atau dapat digunakan. Perbedaan visibilitas yang sudah diperiksa langsung dijelaskan pada bagian pembatasan akses. Kontrol Simpan pada halaman profil cabang tersembunyi, dan Setting denda cabang dibatasi lewat tooltip.

Screenshot tersimpan terpisah per akun. Laporan hanya mencatat metadata halaman; data penumpang, password, token, cookie, dan storage sesi tidak disalin ke laporan. Screenshot merupakan bukti lokal tampilan dan dapat memuat data yang terlihat pada aplikasi.

## Struktur navigasi yang ditemukan

- Header: identitas akun/perusahaan dan Keluar; Saldo Operator → Riwayat Saldo; Top-up Saldo.
- Dashboard → statistik channel, jadwal, penumpang, kendaraan, bagasi penumpang, bagasi kendaraan, tiket gratis, tiket pekerja (rincian tahunan).
- Laporan → Penjualan (Harian), Pendapatan Penumpang, Pendapatan Kendaraan, Rekap Pendapatan, Pembatalan Tiket, Rekap Asuransi, Pemakaian Saldo.
- Manifest; Daftar Order.
- Terminal → Konter Tiket, Data Kendaraan.
- Pembatalan Tiket → Penjualan Cabang, Penjualan Agen, Rekap Pembatalan.
- Laporan Agen → Penjualan (Harian), Rekap Penjualan, Pembatalan Tiket.
- Daftar Piutang; Persetujuan Tiket; Cetak Tiket; Jual Tiket; Kuota & Jadwal.
- Daftar Relasi → Relasi Pelanggan, Relasi Agen.
- Saldo Agen → menu aksi riwayat saldo, riwayat topup; cabang juga Top Up Saldo.
- Voucher → menu aksi detail, edit, pemakaian jika tersedia data.
- Pengaturan User → Hak Akses, Sub User, Petugas Scan, Hak Akses Agen, Sub User Agen.
- Master → Kelas, Golongan, Kapal, Trayek, Harga, Tarif Pass Pelabuhan, Asuransi, Crew, Denda Pembatalan, Informasi.
- Akun Saya → profil operator atau profil sub user sesuai akun.

## Peta Operator Pusat

| # | Modul | Route | Jenis Halaman | Aksi Utama | Ada Dokumen Skenario? | Catatan |
|---|---|---|---|---|---|---|
| 1 | DASHBOARD | `/partner/Dashboard` | Dashboard | Lihat Statistik Penjualan Per Channel Tahun 2026; Lihat Semua Jadwal Tahun 2026; Lihat Semua Penjualan Penumpang Tahun 2026; Lihat Semua Penjualan Kendaraan Tahun 2026; Lihat Semua Penjualan Bagasi Penumpang Tahun 2026; Lihat Semua Penjualan Bagasi Kendaraan Tahun 2026; Lihat Semua Pemberian Tiket Gratis Tahun 2026; Lihat Semua Pemberian Tiket Pekerja Tahun 2026 | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/Dashboard.png) |
| 2 | Penjualan (Harian) | `/partner/laporanpenjualanharian` | Tabel/list | Filter; Reset; Export Excel | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/laporanpenjualanharian.png) |
| 3 | Pendapatan Penumpang | `/partner/laporanPendapatanPenumpang` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/laporanPendapatanPenumpang.png) |
| 4 | Pendapatan Kendaraan | `/partner/laporanrincianpendapatankendaraan` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/laporanrincianpendapatankendaraan.png) |
| 5 | Rekap Pendapatan | `/partner/laporanpendapatanpertrip` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/laporanpendapatanpertrip.png) |
| 6 | Pembatalan Tiket | `/partner/laporanpembatalantiket` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/laporanpembatalantiket.png) |
| 7 | Rekap Asuransi | `/partner/laporanrekapasuransi` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/laporanrekapasuransi.png) |
| 8 | Pemakaian Saldo | `/partner/laporanpemakaiansaldo` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/laporanpemakaiansaldo.png) |
| 9 | MANIFEST | `/partner/manifestkapal` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/manifestkapal.png) |
| 10 | DAFTAR ORDER | `/partner/daftarpenjualan` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/daftarpenjualan.png) |
| 11 | Konter Tiket | `/partner/boarding` | Form | Ubah Pencarian; Ganti Jadwal; Ajukan Boarding Pass | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/boarding.png) |
| 12 | Data Kendaraan | `/partner/data_kendaraan_show` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/data_kendaraan_show.png) |
| 13 | Penjualan Cabang | `/partner/pembatalantiket` | Tabel/list | Filter; Buat Pembatalan; Reset; tautan detail; tautan edit | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/pembatalantiket.png) |
| 14 | Penjualan Agen | `/partner/pembatalantiketagen` | Tabel/list | Filter; Reset; tautan detail | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/pembatalantiketagen.png) |
| 15 | Rekap Pembatalan | `/partner/rekappembatalantiket` | Tabel/list | Filter; Reset; tautan detail | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/rekappembatalantiket.png) |
| 16 | Penjualan (Harian) | `/partner/laporanpenjualanharianagen` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/laporanpenjualanharianagen.png) |
| 17 | Rekap Penjualan | `/partner/laporanrekappenjualanagen` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/laporanrekappenjualanagen.png) |
| 18 | Pembatalan Tiket | `/partner/laporanpembatalantiketagen` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/laporanpembatalantiketagen.png) |
| 19 | DAFTAR PIUTANG | `/partner/daftarpiutang` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/daftarpiutang.png) |
| 20 | PERSETUJUAN TIKET | `/partner/persetujuantiket` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/persetujuantiket.png) |
| 21 | Relasi Pelanggan | `/partner/pelanggan` | Tabel/list | Filter; Tambah Pelanggan; Reset; tautan detail | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/pelanggan.png) |
| 22 | Relasi Agen | `/partner/agen` | Tabel/list | Filter; Reset; tautan detail | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/agen.png) |
| 23 | SALDO AGEN | `/partner/agen_show` | Tabel/list | Filter; Reset; Action Menu; Riwayat Saldo; Riwayat Topup | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/agen_show.png) |
| 24 | VOUCHER | `/partner/voucher` | Tabel/list | Filter; Tambah Voucher; Reset; Action Menu; Detail Voucher; Edit Voucher; Pemakaian Voucher | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/voucher.png) |
| 25 | Hak Akses | `/partner/hakAkses` | Tabel/list | Filter; Tambah Hak Akses; Reset; tautan detail; tautan edit | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/hakAkses.png) |
| 26 | Sub User | `/partner/subUser` | Tabel/list | Filter; Tambah Sub User; Reset; tautan detail; tautan edit | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/subUser.png) |
| 27 | Petugas Scan | `/partner/petugasscan` | Tabel/list | Filter; Tambah Petugas Scan; Download Scanner; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/petugasscan.png) |
| 28 | Hak Akses Agen | `/partner/hakAksesagen` | Tabel/list | Filter; Tambah Hak Akses; Reset; tautan detail | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/hakAksesagen.png) |
| 29 | Sub User Agen | `/partner/subuseragen` | Tabel/list | Filter; Reset; tautan detail | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/subuseragen.png) |
| 30 | 1. Master Kelas | `/partner/masterkelasnew` | Tabel/list | Filter; Tambah Kelas; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/masterkelasnew.png) |
| 31 | 2. Master Golongan | `/partner/mastergolongan` | Tabel/list | Filter; Tambah Golongan; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/mastergolongan.png) |
| 32 | 3. Master Kapal | `/partner/mkapal` | Tabel/list | Filter; Tambah Kapal; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/mkapal.png) |
| 33 | 4. Master Trayek | `/partner/DaftarTrayek` | Tabel/list | Filter; Buat Trayek; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/DaftarTrayek.png) |
| 34 | 5. Master Harga | `/partner/masterharga` | Tabel/list | Filter; Buat Harga; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/masterharga.png) |
| 35 | 6. Tarif Pass Pelabuhan | `/partner/tarifpass` | Tabel/list | Filter; Buat Harga; Reset; tautan detail; tautan edit | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/tarifpass.png) |
| 36 | 7. Master Asuransi | `/partner/masterasuransi` | Tabel/list | Filter; Reset; tautan detail | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/masterasuransi.png) |
| 37 | 8. Master Crew | `/partner/MasterCrew` | Tabel/list | Filter; Tambah Crew; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/MasterCrew.png) |
| 38 | 9. Denda Pembatalan | `/partner/masterdenda` | Tabel/list | Setting | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/masterdenda.png) |
| 39 | 10. Master Informasi | `/partner/informasi_show` | Tabel/list | Filter; Tambah Informasi; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/informasi_show.png) |
| 40 | AKUN SAYA | `/partner/profil` | Detail | Edit Akun Saya; Belum Upload Logo | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/profil.png) |
| 41 | KUOTA & JADWAL | `/partner/masterjadwal` | Tabel/list | Filter; Buat Jadwal; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/masterjadwal.png) |
| 42 | Riwayat Saldo Operator | `/partner/riwayatsaldo` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/riwayatsaldo.png) |
| 43 | Topup Saldo | `/partner/isi_saldo` | Form | Saldo; Lihat Detail; Lanjutkan Pembayaran | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/isi_saldo.png) |
| 44 | Cetak Tiket | `/home/directprint` | Tabel/list | Filter; Reset; Download E-Tiket; Cetak | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/directprint.png) |

Jual Tiket pada pusat tampil sebagai label tanpa href; dispatch klik tidak berpindah dari halaman semula. Karena tidak ada route aktif dari menu tersebut, tidak dimasukkan sebagai halaman pusat yang berhasil dibuka.

## Peta Cabang / Sub User Cabang Parepare

| # | Modul | Route | Jenis Halaman | Aksi Utama | Ada Dokumen Skenario? | Catatan |
|---|---|---|---|---|---|---|
| 1 | Riwayat Saldo Operator | `/partner/riwayatsaldo` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/riwayatsaldo.png) |
| 2 | TOP-UP SALDO | `/partner/isi_saldo` | Form | Saldo; Lihat Detail; Lanjutkan Pembayaran | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/isi_saldo.png) |
| 3 | DASHBOARD | `/partner/Dashboard` | Dashboard | Lihat Statistik Penjualan Per Channel Tahun 2026; Lihat Semua Jadwal Tahun 2026; Lihat Semua Penjualan Penumpang Tahun 2026; Lihat Semua Penjualan Kendaraan Tahun 2026; Lihat Semua Penjualan Bagasi Penumpang Tahun 2026; Lihat Semua Penjualan Bagasi Kendaraan Tahun 2026; Lihat Semua Pemberian Tiket Gratis Tahun 2026; Lihat Semua Pemberian Tiket Pekerja Tahun 2026 | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/Dashboard.png) |
| 4 | Penjualan (Harian) | `/partner/laporanpenjualanharian` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/laporanpenjualanharian.png) |
| 5 | Pendapatan Penumpang | `/partner/laporanPendapatanPenumpang` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/laporanPendapatanPenumpang.png) |
| 6 | Pendapatan Kendaraan | `/partner/laporanrincianpendapatankendaraan` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/laporanrincianpendapatankendaraan.png) |
| 7 | Rekap Pendapatan | `/partner/laporanpendapatanpertrip` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/laporanpendapatanpertrip.png) |
| 8 | Pembatalan Tiket | `/partner/laporanpembatalantiket` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/laporanpembatalantiket.png) |
| 9 | Rekap Asuransi | `/partner/laporanrekapasuransi` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/laporanrekapasuransi.png) |
| 10 | Pemakaian Saldo | `/partner/laporanpemakaiansaldo` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/laporanpemakaiansaldo.png) |
| 11 | MANIFEST | `/partner/manifestkapal` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/manifestkapal.png) |
| 12 | DAFTAR ORDER | `/partner/daftarpenjualan` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/daftarpenjualan.png) |
| 13 | Konter Tiket | `/partner/boarding` | Form | Ubah Pencarian; Ganti Jadwal; Ajukan Boarding Pass | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/boarding.png) |
| 14 | Data Kendaraan | `/partner/data_kendaraan_show` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/data_kendaraan_show.png) |
| 15 | Penjualan Cabang | `/partner/pembatalantiket` | Tabel/list | Filter; Buat Pembatalan; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/pembatalantiket.png) |
| 16 | Penjualan Agen | `/partner/pembatalantiketagen` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/pembatalantiketagen.png) |
| 17 | Rekap Pembatalan | `/partner/rekappembatalantiket` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/rekappembatalantiket.png) |
| 18 | Penjualan (Harian) | `/partner/laporanpenjualanharianagen` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/laporanpenjualanharianagen.png) |
| 19 | Rekap Penjualan | `/partner/laporanrekappenjualanagen` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/laporanrekappenjualanagen.png) |
| 20 | Pembatalan Tiket | `/partner/laporanpembatalantiketagen` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/laporanpembatalantiketagen.png) |
| 21 | DAFTAR PIUTANG | `/partner/daftarpiutang` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/daftarpiutang.png) |
| 22 | PERSETUJUAN TIKET | `/partner/persetujuantiket` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/persetujuantiket.png) |
| 23 | CETAK TIKET | `/home/directprint` | Tabel/list | Filter; Reset; Download E-Tiket; Cetak | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/directprint.png) |
| 24 | JUAL TIKET | `/partner/jualtiket` | Form | Reset; Filter | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/2026&jenis=%&golongan_kendaraan=&kelas=%&kota_asal=&kota_tujuan=&Carijadwal=1&temppolasal=6.png) |
| 25 | KUOTA & JADWAL | `/partner/masterjadwal` | Tabel/list | Filter; Buat Jadwal; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/masterjadwal.png) |
| 26 | Relasi Pelanggan | `/partner/pelanggan` | Tabel/list | Filter; Tambah Pelanggan; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/pelanggan.png) |
| 27 | Relasi Agen | `/partner/agen` | Tabel/list | Filter; Tambah Agen; Reset; tautan detail | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/agen.png) |
| 28 | SALDO AGEN | `/partner/agen_show` | Tabel/list | Filter; Reset; Action Menu; Top Up Saldo; Riwayat Saldo; Riwayat Topup | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/agen_show.png) |
| 29 | VOUCHER | `/partner/voucher` | Tabel/list | Filter; Tambah Voucher; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/voucher.png) |
| 30 | Hak Akses | `/partner/hakAkses` | Tabel/list | Filter; Tambah Hak Akses; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/hakAkses.png) |
| 31 | Sub User | `/partner/subUser` | Tabel/list | Filter; Tambah Sub User; Reset; tautan detail; tautan edit | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/subUser.png) |
| 32 | Petugas Scan | `/partner/petugasscan` | Tabel/list | Filter; Tambah Petugas Scan; Download Scanner; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/petugasscan.png) |
| 33 | Hak Akses Agen | `/partner/hakAksesagen` | Tabel/list | Filter; Reset; tautan detail | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/hakAksesagen.png) |
| 34 | Sub User Agen | `/partner/subuseragen` | Tabel/list | Filter; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/subuseragen.png) |
| 35 | 1. Master Kelas | `/partner/masterkelasnew` | Tabel/list | Filter; Tambah Kelas; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/masterkelasnew.png) |
| 36 | 2. Master Golongan | `/partner/mastergolongan` | Tabel/list | Filter; Tambah Golongan; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/mastergolongan.png) |
| 37 | 3. Master Kapal | `/partner/mkapal` | Tabel/list | Filter; Tambah Kapal; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/mkapal.png) |
| 38 | 4. Master Trayek | `/partner/DaftarTrayek` | Tabel/list | Filter; Buat Trayek; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/DaftarTrayek.png) |
| 39 | 5. Master Harga | `/partner/masterharga` | Tabel/list | Filter; Buat Harga; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/masterharga.png) |
| 40 | 6. Tarif Pass Pelabuhan | `/partner/tarifpass` | Tabel/list | Filter; Buat Harga; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/tarifpass.png) |
| 41 | 7. Master Asuransi | `/partner/masterasuransi` | Tabel/list | Filter; Reset; tautan detail | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/masterasuransi.png) |
| 42 | 8. Master Crew | `/partner/MasterCrew` | Tabel/list | Filter; Tambah Crew; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/MasterCrew.png) |
| 43 | 9. Denda Pembatalan | `/partner/masterdenda` | Tabel/list | Setting | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/masterdenda.png) |
| 44 | 10. Master Informasi | `/partner/informasi_show` | Tabel/list | Filter; Tambah Informasi; Reset | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/informasi_show.png) |
| 45 | AKUN SAYA | `/partner/profilsubuser` | Form | Simpan | Belum | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/profilsubuser.png) |

Route Jual Tiket dibuka menggunakan query lengkap dari href menu, bukan URL tebakan. Tabel menampilkan pathname saja agar tidak mengabadikan filter tanggal sebagai konfigurasi permanen.

## Perbedaan akses yang diamati

| Area | Operator Pusat | Cabang / Sub User Cabang Parepare |
|---|---|---|
| Login | Portal /partner; sesudah login menampilkan Akun Saya, kemudian profil /partner/profil | Portal /partner; redirect /partner/profilsubuser |
| Jual Tiket | Label tanpa href; klik tidak menavigasi | Href aktif /partner/jualtiket dengan parameter pencarian; halaman berhasil dibuka |
| Relasi Agen | Daftar/detail, tanpa Tambah Agen | Tambah Agen tersedia; form dibuka tanpa disimpan |
| Saldo Agen | Riwayat Saldo/Riwayat Topup | Tambahan Top Up Saldo di menu aksi; tidak dijalankan |
| Topup Saldo Operator | Form dapat dibuka | Form juga dapat dibuka untuk Akses IK; bukan klaim semua cabang boleh topup |
| Denda Pembatalan | Kontrol Setting ditemukan | Kontrol Setting terlihat tetapi tooltip menyatakan Hanya bisa dilakukan oleh kantor pusat; klik tidak membuka form |
| Akun Saya | Detail dengan tautan Edit Akun Saya; form edit dapat dibuka | Profil Sub User; Simpan tersembunyi, Jenis User disabled. Tidak disimpulkan bisa menyimpan berdasarkan field DOM |
| Pengaturan User | Daftar dan form tambah hak akses/sub user tersedia | Daftar serta form tambah hak akses/sub user dapat dibuka oleh Akses IK; tidak menguji penyimpanan |
| Hak Akses Agen | DOM memuat tautan Tambah Hak Akses ke portal /agen; perlu pemeriksaan visibilitas, bukan bukti izin | Tidak ditemukan tautan tambah pada halaman akun cabang |

## Form tambahan yang diperiksa tanpa submit

| Akun | Halaman | Route | Field / struktur | Bukti |
|---|---|---|---|---|
| Pusat | Tambah Sub User | `/partner/buatsubuser` | email, password, password_confirm, nama, wa, jenis_user, cabang_kota, bagian_staff, status_user, hak_akses[] | [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/buatsubuser.png) |
| Pusat | Tambah Hak Akses | `/partner/buathakakses` | nama_hak_akses, ket_hak_akses, check | [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/buathakakses.png) |
| Pusat | Tambah Pelanggan | `/partner/tambahpelanggan` | OperatorID, nama_perusahaan, penanggung_jawab, email_perusahaan, telp_perusahaan, jenis_identitas, nomor_identitas, kota | [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/tambahpelanggan.png) |
| Pusat | Buat Jadwal | `/partner/tambahjadwal` | trayek, kapal | [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/tambahjadwal.png) |
| Pusat | Tambah Voucher | `/partner/buatvoucher` | nama_operator, kode_voucher, tipe_diskon, nominal_potongan, maksimal_diskon, minimal_transaksi, jenis_voucher, mulai_berlaku, berakhir, kuota, status_voucher, berlaku_untuk[] | [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/buatvoucher.png) |
| Pusat | Edit Akun Saya | `/partner/editprofil` | email, nama_perusahaan, alamat, kota, telp, penanggung_jawab, jabatan, no_npwp, npwp, no_siup, siup, logo_perusahaan, bank[], nomor_rekening[], atas_nama[] | [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/editprofil.png) |
| Pusat | Detail Sub User Cabang Parepare | `/partner/detailsubuser/19533` | Detail sub user | [screenshot](../artifacts/screenshots/explore/20260924-operator-pusat/19533.png) |
| Cabang | Tambah Agen | `/partner/tambahagen` | nama_perusahaan, penanggung_jawab, email, password, password_confirm, telp, foto_logo, foto_identitas, foto_perjanjian, foto_dokumen, status, bank, nomor_rekening, atas_nama | [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/tambahagen.png) |
| Cabang | Tambah Hak Akses | `/partner/buathakakses` | nama_hak_akses, ket_hak_akses, check | [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/buathakakses.png) |
| Cabang | Tambah Sub User | `/partner/buatsubuser` | email, password, password_confirm, nama, wa, jenis_user, cabang_kota, bagian_staff, status_user, hak_akses[] | [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/buatsubuser.png) |

Pada Buat Jadwal ditemukan bagian kuota penumpang, kendaraan/bonus, bagasi, serta jadwal. Langkah setelah Simpan tidak diteruskan karena dapat membuat data. Pada Tambah Hak Akses ditemukan daftar checkbox per hak akses; tidak dicentang/disimpan. Data jenis user pada pengelolaan Sub User mencakup Kantor Pusat dan Kantor Cabang.

## Temuan dan batas verifikasi

1. UI versi 1.5.2 berbeda dari dokumen 1.5.0: ada Rekap Asuransi, Master Asuransi, Cetak Tiket, serta Laporan Agen di operator. Nama Daftar Penjualan pada dokumen tampil sebagai Daftar Order. Ini gap dokumentasi, belum verdict bug.
2. Console Denda Pembatalan cabang mencatat logo-inverse.png 404, transform scale(NaN), null.addEventListener, inisialisasi smooth-scrollbar pada null, serta null.onchange. Konten tabel tetap tampil. Dampak fungsi bisnis belum diuji.
3. Satu kesalahan pengambilan metadata Kuota & Jadwal pusat terjadi karena dua elemen .app-main__inner. Pembacaan diulang dengan container pertama dan berhasil; ini masalah locator eksplorasi, bukan bug aplikasi.
4. Login cabang berhasil tetapi pengambilan DOM awal bertepatan redirect dan gagal dengan execution context destroyed. DOM dibaca ulang sesudah profil terlihat tanpa mengulang login.
5. Selector getByRole untuk Setting sempat timeout; pemeriksaan getByText dan atribut tooltip berhasil. Belum ada dasar menganggap dispatchEvent wajib untuk seluruh aplikasi atau storageState tidak bekerja. Hipotesis OMS belum terverifikasi.
6. Belum ada login Sub User Pusat. Belum diuji akses dengan konfigurasi hak akses lain, isolasi seluruh data kota, backend authorization, perhitungan saldo/kuota, atau validasi transaksi.
7. Tautan detail transaksi dan aksi baris dicatat jika tersedia; tidak semua record historis dibuka. Export, Cetak, Ajukan Boarding Pass, Kirim Pelindo, konfirmasi persetujuan/pembatalan tidak dieksekusi.

## Rincian dashboard tahunan (Cabang Parepare)

| Halaman | Route | Hasil eksplorasi |
|---|---|---|
| Lihat Statistik Penjualan Per Channel Tahun 2026 | `/partner/DashboardListPenjualanPerChannel` | HTTP 200 pada retry 26 September 2026; sangat lambat: ±43,5 detik cabang dan ±61,5 detik pusat. |
| Lihat Semua Jadwal Tahun 2026 | `/partner/DashboardListPenjualanPerJadwal` | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/DashboardListPenjualanPerJadwal.png) |
| Lihat Semua Penjualan Penumpang Tahun 2026 | `/partner/DashboardListPenjualanPenumpang` | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/DashboardListPenjualanPenumpang.png) |
| Lihat Semua Penjualan Kendaraan Tahun 2026 | `/partner/DashboardListPenjualanKendaraan` | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/DashboardListPenjualanKendaraan.png) |
| Lihat Semua Penjualan Bagasi Penumpang Tahun 2026 | `/partner/DashboardListPenjualanBagasiPenumpang` | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/DashboardListPenjualanBagasiPenumpang.png) |
| Lihat Semua Penjualan Bagasi Kendaraan Tahun 2026 | `/partner/DashboardListPenjualanBagasiKendaraan` | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/DashboardListPenjualanBagasiKendaraan.png) |
| Lihat Semua Pemberian Tiket Gratis Tahun 2026 | `/partner/getDetailTIketGratis` | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/getDetailTIketGratis.png) |
| Lihat Semua Pemberian Tiket Pekerja Tahun 2026 | `/partner/getDetailPekerja` | HTTP 200; [screenshot](../artifacts/screenshots/explore/20260924-operator-cabang/getDetailPekerja.png) |

Rincian per jadwal awalnya timeout 20 detik, lalu berhasil pada percobaan ulang. Pada verifikasi lanjutan 26 September 2026, seluruh delapan rincian dashboard berhasil dibuka untuk Operator Pusat dan Cabang dengan HTTP 200. Konten Per Jadwal saat itu menampilkan 265 jadwal untuk pusat dan 95 jadwal untuk cabang. Selain Per Channel, waktu buka berkisar ±4,8–14 detik. Bukti tersimpan di `artifacts/screenshots/explore/20260926-022038-remaining/`.

## Verifikasi lanjutan 26 September 2026

- Delapan rincian dashboard tahunan berhasil dibuka untuk Operator Pusat dan Operator Cabang: Per Channel, Per Jadwal, Penumpang, Kendaraan, Bagasi Penumpang, Bagasi Kendaraan, Tiket Gratis, dan Tiket Pekerja.
- Per Channel tetap menjadi halaman paling lambat: ±61,5 detik pusat dan ±43,5 detik cabang. Semua route memberi HTTP 200; ini temuan performa, bukan verdict fungsi bisnis.
- Route tersembunyi `/partner/riwayatsaldo` diuji langsung dalam sesi User Umum. Aplikasi mengalihkan ke `/home/pencarian` dan menampilkan pesan **Anda Tidak Memiliki Akses Ke Halaman Tersebut**. Route tersebut bukan fitur yang dapat digunakan User Umum.
- Tidak ada aksi tulis, submit form, perubahan data, download, pembayaran, atau pengiriman notifikasi pada run lanjutan ini.
- Akun Sub User Pusat tetap tidak tersedia di `config/env.md`; login role tersebut belum dapat diverifikasi.

## Eksplorasi detail kelompok Master — 26 September 2026

Eksplorasi dilakukan pada Operator Pusat dan Operator Cabang Parepare. Semua halaman berikut berhasil dibuka dengan HTTP 200 tanpa mengisi atau menyimpan form.

| Modul | Halaman turunan yang diperiksa | Struktur utama yang ditemukan | Hasil akses |
|---|---|---|---|
| Master Kelas | `/partner/tambahkelas` | Nama Kelas, tambah baris input, Simpan; form POST `doSaveKelas` | Daftar dan form tambah terbuka pada Pusat dan Cabang |
| Master Golongan | `/partner/tambahgolongan` | Jenis tiket, nama golongan, golongan kendaraan, bonus tiket, kondisi kendaraan, status aktif | Daftar dan form tambah terbuka pada Pusat dan Cabang |
| Master Kapal | `/partner/tambahkapal` | Nama kapal, call sign, kapasitas penumpang, kelas yang tersedia | Daftar dan form tambah terbuka pada Pusat dan Cabang |
| Master Trayek | `/partner/mtrayek_tambah` | Nama trayek, daftar pelabuhan, asal, tujuan, konsumsi penumpang | Daftar dan form tambah terbuka pada Pusat dan Cabang |
| Master Harga | `/partner/tambahharga` | Trayek, rute, konsumsi penumpang; langkah lanjutan memakai tombol Tambahkan | Daftar dan form awal terbuka pada Pusat dan Cabang |
| Tarif Pass Pelabuhan | tambah, detail, dan edit | Tarif 3 kategori penumpang dan 12 kategori kendaraan; edit memiliki Simpan/Batal | Tambah, detail, dan edit terbuka pada Pusat dan Cabang |
| Master Asuransi | detail dan setting | Asuransi JR/JP untuk penumpang dan kendaraan; setting memiliki Simpan/Batal | Detail dan halaman setting terbuka pada Pusat dan Cabang |
| Master Crew | `/partner/tambahcrew` | Identitas awak, gender, tanggal lahir, buku/kode pelaut, jabatan, PKL, sign-on, kewarganegaraan, sertifikat | Daftar dan form tambah terbuka pada Pusat dan Cabang |
| Denda Pembatalan | daftar + kontrol Setting | Empat baris aturan; form mengarah ke `do_edit_denda_pembatalan` | Kontrol Setting tampil pada kedua role; tidak diklik karena dapat mengubah setting. Tooltip pembatasan Cabang dari run awal tetap berlaku |
| Master Informasi | `/partner/informasi_add` | Judul, berlaku sampai, isi informasi, Simpan/Batal | Daftar dan form tambah terbuka pada Pusat dan Cabang; daftar saat diperiksa tidak berisi data |

Temuan akses: akun Cabang dapat membuka langsung form tambah serta halaman edit/setting pada hampir seluruh kelompok Master yang diperiksa. Ini baru membuktikan route dan UI dapat dibuka; otorisasi penyimpanan tidak diuji dalam workflow explore. Bukti dan metadata run berada di `artifacts/explore/20260926-023405-master.json` serta screenshot terkait di `artifacts/screenshots/explore/20260926-023405-master/`.

## Eksplorasi detail Kuota & Jadwal — 26 September 2026

Eksplorasi dilakukan pada `/partner/masterjadwal` dan `/partner/tambahjadwal` untuk Operator Pusat dan Operator Cabang Parepare. Pilihan trayek dan kapal diubah hanya pada state form lokal untuk memunculkan bagian dinamis; tombol Simpan/Selesai tidak ditekan.

| Area | Hasil eksplorasi |
|---|---|
| Daftar jadwal | Tabel memuat tanggal buat, trayek, kapal, nomor voyage, kapasitas, status, rute, kelas/golongan/bagasi, kuota internal/eksternal, dan bonus tiket. Saat diperiksa, Pusat melihat 2.242 data dan Cabang Parepare 571 data. |
| Form awal | Trayek, kapal, call sign, nomor voyage, kapasitas penumpang, serta rute yang dilewati. Call sign dan kapasitas terisi dari kapal dan tampil disabled. |
| Lookup dinamis | Memanggil `getAlurRuteOld`, `getAlurRute`, `getKapalJadwal`, dan `getKuotaJadwal` setelah pilihan trayek/kapal berubah. Tidak ada request penyimpanan. |
| Tab Kuota | Distribusi kuota penumpang per kelas dan kendaraan per golongan, masing-masing memiliki Kuota Internal dan Kuota Eksternal; kendaraan juga memiliki Bonus Tiket. Pilihan contoh menampilkan 2 kelas dan 6 golongan. |
| Tab Jadwal | Status Jadwal, Pelabuhan Asal, Waktu Berangkat (`tgl_etd`), Pelabuhan Tujuan, dan Waktu Tiba (`tgl_eta`). Pilihan status yang terlihat: Jadwal Tampil dan Jadwal Tutup. |
| Tab Crew List | Menampilkan rute yang dilewati dan instruksi memastikan Crew List telah terisi; terdapat kontrol Selesai yang tidak ditekan. |
| Perbedaan role | Struktur daftar, form buat, tab, field, dan kontrol yang terlihat sama pada Pusat dan Cabang. Perbedaan data daftar menunjukkan pembatasan lingkup: Cabang hanya melihat subset jadwal Pusat. |

Form buat menampilkan tombol Simpan/Batal pada Kuota dan Jadwal. Akses UI ini belum membuktikan otorisasi backend untuk membuat atau mengubah jadwal karena tidak ada submit. Bukti dan metadata run berada di `artifacts/explore/20260926-024451-schedule-quota.json` serta screenshot terkait di `artifacts/screenshots/explore/20260926-024451-schedule-quota/`.

## Handoff

Gunakan route hasil UI ini untuk eksplorasi lanjut. Sebelum test detail, buat skenario per modul dari rule dan temuan UI, lalu harvest selector sesuai workflow. Seluruh gap dashboard untuk akun yang tersedia sudah ditutup. Sisa cakupan yang memerlukan input pengguna hanya akun Sub User Pusat di config/env.md. Tidak perlu membuat akun atau mengubah hak akses untuk menyelesaikan eksplorasi akun yang sudah tersedia.


## Portal User Umum (explore 2026-09-25)

- Login `/user/login`: `#username`, `#password`, tombol `#login1` → redirect `/home/pencarian`. Helper: `tests/helpers/user-session.js` (guard gagal 2x, `artifacts/.auth/login-failures-user.json`).
- Akun: pengirim.ph2021@gmail.com (nama profil Muhammad Nur Ikhsan, Surabaya). Nomor WhatsApp profil kosong (`-`).
- Menu: Order Tiket, Daftar Order, Akun Saya, Preference Notif. Link tersembunyi `/partner/riwayatsaldo` ada di DOM (tidak terlihat); verifikasi 26 September 2026 mengalihkan kembali ke `/home/pencarian` dengan pesan tidak memiliki akses.
- Eksplorasi read-only; POST yang terjadi hanya lookup (`getVehicle`, `searchbooking`, `searchpencarian`, `checkSchedule`) + `savetmpbooking` (keranjang sementara saat "Pesan", bukan order).

| # | Modul | Route | Jenis Halaman | Aksi Utama | Ada Dokumen Skenario? | Catatan |
|---|---|---|---|---|---|---|
| U1 | ORDER TIKET – Cari Jadwal | `/home/pencarian` | Form + hasil | Kota Asal/Tujuan (select2 `#kota_asal`/`#kota_tujuan`), `#tgl_berangkat`, Pilih Lebih Detail (`#jenis`, `#kelas`, `#golongan_kendaraan`, pulang-pergi `#checkbox1`/`#tgl_pulang`), `#Carijadwal`; hasil ±7 hari; `#btn_pilih<id>` → tabel jumlah `.masukkan-jumlah` + tombol `.pesannya<id>` | Belum | [screenshot](../artifacts/screenshots/explore/20260925-user-umum/home_pencarian.png) |
| U2 | Isi Data Order | `/home/inputpesanan/` (token di sesi) | Form | Data Pembeli (prefill profil; `#no_hp_pemesan` wajib), kendaraan (`muatan[]`, `nama_pemilik`, `nopol`, `kota_kend`), bonus Sopir/Kernet gol. III, penumpang per kategori, syarat `#exampleCustomCheckbox1266`, `#lanjut_bayar` | Belum | dibuka lewat Pesan (`savetmpbooking`) |
| U3 | DAFTAR ORDER | `/home/daftarpembelian` | List | Filter; Info Order; Data Tiket; Action Menu; detail `/home/detailpembelian/<id>` | Belum | 21 order lama, semua "Order Expired"; order OP-13 (operator/relasi) tidak muncul — wajar |
| U4 | AKUN SAYA | `/home/Profil_user_umum` | Detail | Edit Akun Saya | Belum | tidak diedit |
| U5 | PREFERENCE NOTIF | `/home/preferencenotif`, `/home/settingpreferencenotif` | Detail + form | Setting; Simpan/Batal | Belum | Email & WhatsApp: Notif Pemesanan/Pembayaran Berhasil; tidak disimpan |

Temuan: jadwal `AUTOTEST-20260925-PPBPN-01` (ID detail 2296 di portal user) hanya menawarkan **13 jenis** tiket ke user umum — Dewasa/Anak/Bayi (Ekonomi Lesehan & Lesehan (A)), Gol. II (4), Gol. III-A, III-A(A), III-B(A). Tidak tampil: Gol. IV–VII, Mobil Mewah/Perlakuan Khusus (III-B), bagasi penumpang/kendaraan (operator: 30 jenis). Harga user berbeda dengan operator (mis. Dewasa Ekonomi Lesehan Rp265.500). Perlu dicocokkan dengan dokumen rule — belum verdict.
