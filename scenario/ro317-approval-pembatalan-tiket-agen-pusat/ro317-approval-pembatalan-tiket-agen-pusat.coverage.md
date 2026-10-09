# Coverage — ro317-approval-pembatalan-tiket-agen-pusat

Review dilakukan atas tiga artefak dari disk; hasil ini memvalidasi rancangan skenario, bukan eksekusi aplikasi TMS/Playwright.

## Ringkasan

| Kategori | Jumlah |
|---|---:|
| positive | 58 |
| negative | 55 |
| edge | 42 |
| stress | 15 |
| **Total** | **170** |

- 30/30 requirement memiliki minimal satu positive dan satu negative.
- 6/6 layar tercakup; 66/66 target UI penting tersentuh melalui action atau assertion.
- Edge + stress: 57 skenario; profil/batas data eksplisit dalam JSON.
- Semua ID unik, judul unik, summary sesuai hitungan; empat artefak lengkap.

## Requirements Traceability Matrix

| REQ | Deskripsi | Scenario IDs |
|---|---|---|
| REQ-001 | Pengajuan Cabang dan Agen wajib diputuskan Pusat; Cabang kehilangan hak approval Agen. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-001, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-002, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-001, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-002 |
| REQ-002 | Menu bernama Master Denda Pembatalan; Pusat dapat setting, Cabang hanya membaca. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-003, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-004, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-003, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-004 |
| REQ-003 | Cabang dan Agen menggunakan master dan persentase denda yang sama untuk kondisi identik. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-005, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-005 |
| REQ-004 | Aturan waktu mendukung H-/H+, Hari/Jam; denda berdasarkan selisih pengajuan terhadap keberangkatan. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-006, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-007, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-008, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-009, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-006, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-001, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-002, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-003, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-004, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-005, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-006, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-007, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-008, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-017, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-018 |
| REQ-005 | Default H-3=25%, H-2=50%, H-1=75%; Pusat dapat mengubah nilai default. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-010, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-007 |
| REQ-006 | Sebelum batas terjauh, H-4/H-5/dst memakai H-3; setelah batas terjauh, H+4/H+5/dst memakai H+3. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-011, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-012, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-008, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-009, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-010, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-011, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-012, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-013, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-014, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-015, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-016 |
| REQ-007 | Kalkulasi dilakukan pada waktu pembuatan dan menyimpan nilai/persentase, bukan waktu approval. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-013, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-009 |
| REQ-008 | Perubahan master hanya berlaku untuk pengajuan baru; pengajuan lama/Menunggu mempertahankan snapshot. Konflik dengan Master 13 dicatat pada A01. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-014, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-015, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-010, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-041, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-011 |
| REQ-009 | Persen maksimal 100%; validasi nilai, nama dan range mengikuti desain pendukung. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-016, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-011, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-012, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-013, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-014, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-015, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-016, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-019, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-020, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-021, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-022 |
| REQ-010 | Cabang memakai Ajukan Pembatalan; Agen mengirim pengajuan ke Pusat; alasan opsional. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-017, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-018, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-056, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-017, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-029, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-010 |
| REQ-011 | Pengajuan sukses berstatus Menunggu Approval, masuk antrean Pusat; tiket tetap aktif dan refund belum diproses. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-019, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-018, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-002 |
| REQ-012 | Satu tiket tidak boleh memiliki dua pengajuan Menunggu; tiket tersebut dikeluarkan dari pilihan ID Tiket. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-020, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-019, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-001 |
| REQ-013 | Setelah Ditolak/Dibatalkan, pengajuan baru diperbolehkan jika tiket masih eligible; menghitung denda dengan master dan waktu terbaru. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-021, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-022, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-020 |
| REQ-014 | Pilihan tiket mengikuti eligibility existing: jadwal, kepemilikan, tiket aktif dan belum boarding; tanggal pencarian wajib, maksimal 30 hari menurut desain. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-023, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-021, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-022, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-023, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-024, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-025, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-026, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-027, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-028, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-023, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-024, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-025, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-026, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-027 |
| REQ-015 | Cabang/Agen dapat menarik pengajuan miliknya sendiri hanya ketika Menunggu; setelahnya tiket aktif, status Dibatalkan. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-024, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-025, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-054, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-029, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-030, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-031, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-032, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-005 |
| REQ-016 | Menu Pembatalan Tiket Pusat memproses antrean Cabang maupun Agen dengan status Menunggu. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-026, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-027, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-033 |
| REQ-017 | Detail menampilkan tiket, pengaju/unit, harga, denda, estimasi refund, alasan dan histori yang sesuai pengajuan. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-028, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-034, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-008 |
| REQ-018 | Histori detail tidak menampilkan langkah Tiket Diterbitkan, tetapi tetap mencatat pengajuan/keputusan/penarikan. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-029, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-035 |
| REQ-019 | Approve hanya oleh Pusat saat Menunggu; mengubah menjadi Disetujui, membatalkan tiket dan memproses refund hasil kalkulasi. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-030, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-031, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-052, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-036, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-037 |
| REQ-020 | Disetujui final: tidak dapat diubah, ditolak, ditarik, atau di-approve ulang; tidak ada refund ganda. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-032, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-038, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-003 |
| REQ-021 | Reject hanya oleh Pusat saat Menunggu; Ditolak, tiket tetap aktif; alasan penolakan terlihat pengaju. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-033, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-034, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-053, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-039, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-040, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-004 |
| REQ-022 | Ditolak final pada pengajuan tersebut; tidak bisa diubah/di-approve; pembatalan berikutnya memakai pengajuan baru. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-035, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-041 |
| REQ-023 | Pusat boleh membatalkan tiket milik Cabang langsung, tanpa approval tambahan; denda/refund berlaku dan histori menyebut Pusat. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-036, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-057, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-042, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-043, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-006 |
| REQ-024 | Cabang/Agen melihat pengajuan sendiri beserta status; Cabang memantau pengajuan Agen read-only dalam lingkupnya. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-037, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-038, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-039, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-044, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-013 |
| REQ-025 | Daftar mendukung tab status, filter ID/tanggal/pengaju, Reset, ukuran halaman dan empty state tanpa salah menampilkan data. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-040, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-041, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-042, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-043, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-044, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-045, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-045, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-036, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-037, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-007 |
| REQ-026 | Konfirmasi kirim/approve/reject/penarikan/direct serta Batal/Kembali mencegah perubahan sebelum konfirmasi; loading mencegah kirim ganda. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-046, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-055, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-046, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-047, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-048, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-049, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-050, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-038 |
| REQ-027 | Alasan Penolakan wajib non-whitespace dan ditampilkan sebagai teks aman; alasan pembatalan/keterangan tetap opsional. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-047, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-051, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-052, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-028, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-009 |
| REQ-028 | Ringkasan finansial konsisten: denda master, komponen harga/diskon/pass/komisi existing dan refund; pengguna tidak dapat menimpa denda master. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-048, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-049, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-053, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-030, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-031, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-032, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-033, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-034, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-035 |
| REQ-029 | Ganti Jadwal/Ubah Pencarian membersihkan tiket dan kalkulasi lama sehingga tidak mengirim data lintas jadwal. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-050, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-051, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-054, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-015 |
| REQ-030 | Kegagalan jaringan, timeout, sesi dan balapan keputusan menjaga satu transisi final serta satu efek tiket/refund. | RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-058, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-055, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-039, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-040, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-042, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-012, RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-014 |

## Distribusi per requirement

| REQ | Positive | Negative | Edge | Stress |
|---|---:|---:|---:|---:|
| REQ-001 | 2 | 2 | 0 | 0 |
| REQ-002 | 2 | 2 | 0 | 0 |
| REQ-003 | 1 | 1 | 0 | 0 |
| REQ-004 | 4 | 1 | 10 | 0 |
| REQ-005 | 1 | 1 | 0 | 0 |
| REQ-006 | 2 | 1 | 8 | 0 |
| REQ-007 | 1 | 1 | 0 | 0 |
| REQ-008 | 2 | 1 | 1 | 1 |
| REQ-009 | 1 | 6 | 4 | 0 |
| REQ-010 | 3 | 1 | 1 | 1 |
| REQ-011 | 1 | 1 | 0 | 1 |
| REQ-012 | 1 | 1 | 0 | 1 |
| REQ-013 | 2 | 1 | 0 | 0 |
| REQ-014 | 1 | 8 | 5 | 0 |
| REQ-015 | 3 | 4 | 0 | 1 |
| REQ-016 | 2 | 1 | 0 | 0 |
| REQ-017 | 1 | 1 | 0 | 1 |
| REQ-018 | 1 | 1 | 0 | 0 |
| REQ-019 | 3 | 2 | 0 | 0 |
| REQ-020 | 1 | 1 | 0 | 1 |
| REQ-021 | 3 | 2 | 0 | 1 |
| REQ-022 | 1 | 1 | 0 | 0 |
| REQ-023 | 2 | 2 | 0 | 1 |
| REQ-024 | 3 | 1 | 0 | 1 |
| REQ-025 | 6 | 1 | 2 | 1 |
| REQ-026 | 2 | 5 | 1 | 0 |
| REQ-027 | 1 | 2 | 1 | 1 |
| REQ-028 | 2 | 1 | 6 | 0 |
| REQ-029 | 2 | 1 | 0 | 1 |
| REQ-030 | 1 | 1 | 3 | 2 |

## Cakupan layar

| Screen | Jumlah scenario bertag |
|---|---:|
| ajukan-pembatalan | 78 |
| master-denda | 6 |
| edit-denda | 17 |
| detail-pengajuan | 43 |
| daftar-pengajuan | 24 |
| konfirmasi | 2 |

Tag screen menunjukkan layar awal/utama; steps boleh menuju detail, dialog, menu lain atau sesi lain.

## Cakupan UI

Alias POS/NEG/EDG/STR-NNN di bawah memakai prefiks penuh `RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-` dari JSON. Cakupan dihitung dari target langkah; assertion ketidakhadiran adalah cakupan akses yang sah. Nama elemen pada desain dan nama usulan ARIA dibedakan dalam analysis.

| Target penting | Contoh scenario |
|---|---|
| Master Denda Pembatalan | POS-003, POS-004, POS-010, POS-055 |
| Tabel Denda | POS-003, POS-004, POS-006, POS-007 |
| Setting | POS-003, POS-004, POS-010 |
| Keterangan Snapshot | POS-004, POS-013, POS-014, EDG-041 |
| Jenis Denda | POS-006, POS-007, POS-008, POS-009 |
| Arah Waktu | POS-006, POS-007, POS-008, POS-009 |
| Range Waktu | POS-006, POS-007, POS-008, POS-009 |
| Satuan Waktu | POS-006, POS-007, POS-008, POS-009 |
| Tipe Denda | POS-006, POS-007, POS-008, POS-009 |
| Denda | POS-003, POS-006, POS-007, POS-008 |
| Validasi Denda | POS-016, NEG-006, NEG-011, NEG-012 |
| Simpan | POS-003, POS-006, POS-007, POS-008 |
| Batal | POS-055, NEG-047, NEG-048 |
| Penjualan Cabang | POS-019, POS-026, POS-057, NEG-017 |
| Penjualan Agen | POS-027, POS-039, NEG-033, NEG-044 |
| Pengajuan Pembatalan | POS-056, STR-013 |
| Ajukan Pembatalan | POS-001, POS-013, POS-017, POS-019 |
| Buat Pembatalan | POS-056, POS-057, NEG-017 |
| Filter | POS-040, NEG-045, EDG-036, STR-007 |
| Reset | POS-040 |
| ID Pengajuan / ID Tiket | POS-040, NEG-045 |
| Tanggal Pengajuan | POS-040 |
| Pengaju | POS-040 |
| Pengaju / Nama Agen | EDG-036, STR-007 |
| Ukuran Halaman | POS-040, EDG-036, STR-007 |
| Semua | POS-037, POS-038, POS-041, POS-058 |
| Menunggu Approval | POS-019, POS-026, POS-027, POS-042 |
| Disetujui | POS-043 |
| Ditolak | POS-044 |
| Dibatalkan | POS-045 |
| Tabel Pengajuan | POS-019, POS-037, POS-038, POS-040 |
| Lihat detail | POS-026, POS-027, POS-037, POS-038 |
| Setujui pembatalan | POS-037, POS-038, POS-052 |
| Tolak pengajuan | POS-037, POS-038, POS-053 |
| Batalkan pengajuan | POS-054 |
| Empty State | NEG-033, NEG-045, EDG-037 |
| Keterangan Read-only | POS-039 |
| Tanggal Awal | POS-001, POS-002, POS-013, POS-015 |
| Tanggal Akhir | POS-001, POS-002, POS-013, POS-015 |
| Pilih Jadwal Kapal | POS-001, POS-002, POS-005, POS-011 |
| Detail Jadwal | POS-023, POS-028, EDG-017 |
| Pilih Pembatalan | EDG-034 |
| ID Tiket | POS-001, POS-002, POS-005, POS-011 |
| Ganti Jadwal | POS-050, NEG-054, STR-015 |
| Ubah Pencarian | POS-051, STR-015 |
| Validasi Tiket | NEG-028 |
| Peringatan Boarding Pass | EDG-027 |
| Detail Pembeli Tiket | POS-023 |
| Detail Penumpang | POS-023, EDG-027 |
| Ringkasan Finansial | POS-005, POS-011, POS-012, POS-013 |
| Keterangan Batal Tiket | POS-001, POS-002, POS-013, POS-015 |
| Batalkan Tiket | POS-002, POS-015, POS-018, POS-036 |
| Detail Pengajuan | POS-017, POS-018, POS-026, POS-027 |
| Status Pengajuan | POS-001, POS-002, POS-015, POS-017 |
| Setujui Pembatalan | POS-013, POS-014, POS-026, POS-027 |
| Tolak | POS-026, POS-027, POS-032, POS-033 |
| Batalkan Pengajuan | POS-024, POS-025, POS-032, POS-039 |
| Banner Alasan Penolakan | POS-033, POS-034, POS-047, NEG-041 |
| Riwayat | POS-024, POS-025, POS-028, POS-029 |
| Kembali | POS-037, POS-038, POS-046, NEG-046 |
| Dialog Aktif | POS-001, POS-002, POS-013, POS-014 |
| Kirim Pengajuan | POS-001, POS-002, POS-013, POS-015 |
| Alasan Penolakan | POS-033, POS-034, POS-047, POS-053 |
| Tolak Pengajuan | POS-033, POS-034, POS-047, POS-053 |
| Toast | POS-001, POS-002, POS-003, POS-017 |
| Loading | EDG-038 |

## Validasi Gherkin dan JSON

- PASS parser resmi `gherkin-official` 42.0.1: seluruh Scenario valid secara sintaks.
- PASS pencocokan satu-ke-satu nama Scenario dan ID JSON, kategori/priority/REQ/screen bertag persis sama.
- PASS seluruh langkah Gherkin didekode kembali dan sama dengan `steps` JSON; Given kondisi sama dengan `preconditions`; assertion final sama dengan `expected`.
- PASS setiap Scenario memiliki Given/When/Then; assertion kondisi awal memakai And setelah Given, setiap aksi setelah assertion memakai When kembali.
- PASS field skema, action enum, nilai string, selectorHints role/name/testid untuk semua target dan summary hitungan aktual.
- PASS keempat kategori, seluruh REQ minimal positive+negative, seluruh layar dan target penting.

## Review duplikat dan overlap

- Duplikat exact (preconditions + steps + testData): 0. Duplikat yang dibuang: 0.
- Kasus submit yang semula hanya mengulang konfirmasi diubah menjadi tutup/buka ulang modal sebelum submit; oracle konfirmasi sekarang berbeda dari routing atau antrean.
- Kasus kanal Cabang/Agen dipertahankan karena hak akses dan pemilik berbeda; varian status final dipertahankan karena transisi/efek berbeda.
- Default/master read-only, snapshot lama/baru, batas satu detik, replay, dua sesi dan beban 100 sesi memiliki trigger dan oracle berbeda; kesamaan beberapa steps tidak dianggap duplikat.

## Gap dan batas penggunaan

- Tidak ada gap cakupan requirement minimum, layar, atau target UI penting yang diinventarisasi.
- Konflik Master 12 vs 13 tetap menjadi gap keputusan bisnis (A01). Skenario menguji snapshot tetap; bila bisnis memilih rekalkulasi, REQ-007/008/013/028 dan skenario terkait perlu diselaraskan.
- Batas interval/timezone (A05/A06), eligibility/scope (A07), desimal/pembulatan/cap Rupiah (A08), filter/pagination (A09), serta pengecualian dan komponen existing (A04/A11) masih berdasarkan asumsi atau fixture bersyarat, bukan fakta produksi terverifikasi.
- Selector, URL, dialog/row scope, ledger audit, fault injection, sesi, clock dan beban paralel memerlukan adapter implementasi (A10/A12/A13/A15). Testid seluruhnya usulan. Tidak ada klaim test end-to-end atau performa aplikasi sudah lulus.
- Nilai teks QA-LONG-TEXT-10000 harus diekspansi tepat 10.000 karakter oleh runner; jangan mengirim sentinel literal. Jika batas produksi belum disepakati, oracle menerima utuh atau validasi eksplisit, bukan pemotongan diam-diam.

## Petunjuk codegen

- Jalankan scenario secara terisolasi; seed fixture dari preconditions + testData. requestId/ticketId contoh boleh di-remap unik asalkan target/expected mengikuti remapping.
- `navigate` menunjuk layar/route intent, tidak mengarang path HTTP; edit-denda dan konfirmasi diwujudkan dengan membuka modal yang benar.
- Gunakan selectorHints role/name, scope row ID atau dialog aktif, lalu testid usulan setelah dikonfirmasi. `click` dapat menunjuk link menu walau frasa Gherkin konsisten memakai tombol; ikuti role dari hint.
- Terjemahkan `expect.value` menjadi assertion isi/nilai/status/ketiadaan/disabled yang sesuai. Audit/Refund/Hasil Paralel/Hasil Recovery adalah oracle adapter, bukan elemen hasil pembacaan desain.
- `parallelGroups`/load/clockTransition/concurrentChange/fault menentukan orchestration; urutan steps adalah alur peserta, bukan instruksi menjalankan race secara serial. Jadwal H+ hanya dijalankan pada fixture eligibility pascakeberangkatan yang valid.

## Integritas artefak

| Artefak input review | SHA-256 |
|---|---|
| ro317-approval-pembatalan-tiket-agen-pusat.analysis.md | 19bb966ece5fc3a80a42cc7dba9423bb773167a3e1248cd86e30ed93bf8f3f68 |
| ro317-approval-pembatalan-tiket-agen-pusat.feature | efc53870d9c2c25f3e4f2446105c7cf43ac3bc9b14420a7c4c0deb1c6498b33c |
| ro317-approval-pembatalan-tiket-agen-pusat.scenarios.json | 84cb68c9f76ad1e681ac32d4ab281410576bec373c038d33fef76d4896bd9996 |
