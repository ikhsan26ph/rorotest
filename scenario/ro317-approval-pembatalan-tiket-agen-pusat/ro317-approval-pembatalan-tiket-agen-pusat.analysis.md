# Analysis — ro317-approval-pembatalan-tiket-agen-pusat

## Requirements

Sumber utama: `inputs/ro317-approval-pembatalan-tiket-agen-pusat/spec.txt`. Sumber pendukung: `extras/desain-ro-1-5-4-approval-pembatalan.html`, template HTML dan logika prototipe dibaca secara statis; bukan implementasi produksi.

| REQ | Deskripsi / acceptance criteria | Sumber |
|---|---|---|
| REQ-001 | Pengajuan Cabang dan Agen wajib diputuskan Pusat; Cabang kehilangan hak approval Agen. | General 1–2; sisi Cabang/Agen 2–5 |
| REQ-002 | Menu bernama Master Denda Pembatalan; Pusat dapat setting, Cabang hanya membaca. | Master 1–3 |
| REQ-003 | Cabang dan Agen menggunakan master dan persentase denda yang sama untuk kondisi identik. | General 4 |
| REQ-004 | Aturan waktu mendukung H-/H+, Hari/Jam; denda berdasarkan selisih pengajuan terhadap keberangkatan. | Master 4–5 |
| REQ-005 | Default H-3=25%, H-2=50%, H-1=75%; Pusat dapat mengubah nilai default. | Master 6–7 |
| REQ-006 | Sebelum batas terjauh, H-4/H-5/dst memakai H-3; setelah batas terjauh, H+4/H+5/dst memakai H+3. | Master 8–9 |
| REQ-007 | Kalkulasi dilakukan pada waktu pembuatan dan menyimpan nilai/persentase, bukan waktu approval. | Master 10–11 |
| REQ-008 | Perubahan master hanya berlaku untuk pengajuan baru; pengajuan lama/Menunggu mempertahankan snapshot. Konflik dengan Master 13 dicatat pada A01. | Master 12–13; teks HTML snapshot |
| REQ-009 | Persen maksimal 100%; validasi nilai, nama dan range mengikuti desain pendukung. | Master 14; HTML dendaErr |
| REQ-010 | Cabang memakai Ajukan Pembatalan; Agen mengirim pengajuan ke Pusat; alasan opsional. | Pengajuan 1–4 |
| REQ-011 | Pengajuan sukses berstatus Menunggu Approval, masuk antrean Pusat; tiket tetap aktif dan refund belum diproses. | Pengajuan 5 |
| REQ-012 | Satu tiket tidak boleh memiliki dua pengajuan Menunggu; tiket tersebut dikeluarkan dari pilihan ID Tiket. | Pengajuan 6–7 |
| REQ-013 | Setelah Ditolak/Dibatalkan, pengajuan baru diperbolehkan jika tiket masih eligible; menghitung denda dengan master dan waktu terbaru. | Pengajuan 8–9; Reject 4–5 |
| REQ-014 | Pilihan tiket mengikuti eligibility existing: jadwal, kepemilikan, tiket aktif dan belum boarding; tanggal pencarian wajib, maksimal 30 hari menurut desain. | Pengajuan 9; HTML ajError/date range |
| REQ-015 | Cabang/Agen dapat menarik pengajuan miliknya sendiri hanya ketika Menunggu; setelahnya tiket aktif, status Dibatalkan. | Pembatalan Pengajuan 1–4 |
| REQ-016 | Menu Pembatalan Tiket Pusat memproses antrean Cabang maupun Agen dengan status Menunggu. | Pusat 1–2 |
| REQ-017 | Detail menampilkan tiket, pengaju/unit, harga, denda, estimasi refund, alasan dan histori yang sesuai pengajuan. | Pusat 3 |
| REQ-018 | Histori detail tidak menampilkan langkah Tiket Diterbitkan, tetapi tetap mencatat pengajuan/keputusan/penarikan. | Take Note; HTML history |
| REQ-019 | Approve hanya oleh Pusat saat Menunggu; mengubah menjadi Disetujui, membatalkan tiket dan memproses refund hasil kalkulasi. | Pusat 4–6; Approve 1–2 |
| REQ-020 | Disetujui final: tidak dapat diubah, ditolak, ditarik, atau di-approve ulang; tidak ada refund ganda. | Approve 3; Pusat 6 |
| REQ-021 | Reject hanya oleh Pusat saat Menunggu; Ditolak, tiket tetap aktif; alasan penolakan terlihat pengaju. | Reject 1–2 |
| REQ-022 | Ditolak final pada pengajuan tersebut; tidak bisa diubah/di-approve; pembatalan berikutnya memakai pengajuan baru. | Reject 3–5 |
| REQ-023 | Pusat boleh membatalkan tiket milik Cabang langsung, tanpa approval tambahan; denda/refund berlaku dan histori menyebut Pusat. | General 3; Pembatalan Langsung 1–3 |
| REQ-024 | Cabang/Agen melihat pengajuan sendiri beserta status; Cabang memantau pengajuan Agen read-only dalam lingkupnya. | Sisi Cabang/Agen 1–5 |
| REQ-025 | Daftar mendukung tab status, filter ID/tanggal/pengaju, Reset, ukuran halaman dan empty state tanpa salah menampilkan data. | HTML daftar/filter/tabs |
| REQ-026 | Konfirmasi kirim/approve/reject/penarikan/direct serta Batal/Kembali mencegah perubahan sebelum konfirmasi; loading mencegah kirim ganda. | HTML modal/sending |
| REQ-027 | Alasan Penolakan wajib non-whitespace dan ditampilkan sebagai teks aman; alasan pembatalan/keterangan tetap opsional. | HTML reason/rejectDisabled; Pengajuan 4 |
| REQ-028 | Ringkasan finansial konsisten: denda master, komponen harga/diskon/pass/komisi existing dan refund; pengguna tidak dapat menimpa denda master. | General 4; Pengajuan 3; HTML calc |
| REQ-029 | Ganti Jadwal/Ubah Pencarian membersihkan tiket dan kalkulasi lama sehingga tidak mengirim data lintas jadwal. | HTML gantiJadwal/ubahPencarian |
| REQ-030 | Kegagalan jaringan, timeout, sesi dan balapan keputusan menjaga satu transisi final serta satu efek tiket/refund. | Invarian REQ-011/012/015/019/020/021; kebutuhan edge/stress |

### Aktor dan hak akses

| Aktor | Akses |
|---|---|
| Kantor Pusat | Setting master, membaca pengajuan Cabang/Agen, approve/reject Menunggu, pembatalan langsung tiket Cabang. |
| Kantor Cabang | Master read-only, membuat/menarik pengajuan sendiri, memantau Agen dalam lingkup existing; tanpa approve/reject. |
| Agen | Membuat/membaca/menarik pengajuan sendiri; tanpa approve/reject atau setting master. |

### Validasi dan alur

Tanggal keberangkatan, jadwal dan ID Tiket wajib sebelum mengirim. Alasan Pembatalan / Keterangan Batal Tiket opsional. Nama/Jenis Denda tidak kosong, range numerik >=0, nilai denda numerik >=0, tipe Persen <=100; format desimal lokal dibedakan dari pemisah ribuan. Alasan Penolakan tidak kosong setelah trim. Batas panjang, batas nominal Rupiah dan presisi produksi belum ditentukan.

Alur: Cabang/Agen pilih jadwal+tiket → kalkulasi/snapshot → konfirmasi → Menunggu → Pusat menyetujui (tiket batal/refund), menolak (tiket aktif), atau pengaju menarik (tiket aktif). Pengajuan Ditolak/Dibatalkan boleh diikuti pengajuan baru yang eligible. Pusat dapat memilih tiket Cabang → kalkulasi → konfirmasi → tiket langsung batal.

Status kanonis: Menunggu Approval / Approval Disetujui / Approval Ditolak / Pengajuan Dibatalkan. Label tabel prototipe memakai MENUNGGU / DISETUJUI / DITOLAK / DIBATALKAN; keduanya dipetakan ke status yang sama.

## UI Inventory

Inventaris dibaca dari template HTML extras dan konteks spec (A02). State yang tertulis dalam logika bukan bukti state produksi. `role/name` dan `testid` berikut adalah usulan; field tanpa association ARIA harus memakai label yang diverifikasi atau testid. Selector tabel di-scope ke ID pengajuan, konfirmasi di-scope ke dialog aktif.

### master-denda — Master Denda Pembatalan

| Elemen / label | Jenis / state | role / name | testid usulan |
|---|---|---|---|
| Master Denda Pembatalan | Menu, judul dan keterangan master bersama | link / Master Denda Pembatalan | master-denda-menu |
| Tabel Denda | Nama Denda, Range Waktu, Denda, Aksi | table / Master Denda Pembatalan | master-denda-table |
| Setting | Tombol per rule; hanya Pusat | button / Setting | master-denda-setting |
| Keterangan Snapshot | Pengajuan baru saja; Menunggu tetap memakai snapshot | note / Keterangan Snapshot | snapshot-note |

### edit-denda — Edit Denda Pembatalan

| Elemen / label | Jenis / state | role / name | testid usulan |
|---|---|---|---|
| Jenis Denda | TextInput; placeholder Masukkan Nama Denda; nama rule wajib | textbox / Jenis Denda | denda-name |
| Arah Waktu | Select H-/H+ dalam Range Waktu | combobox / Arah Waktu | denda-direction |
| Range Waktu | input numeric, >=0 | textbox / Range Waktu | denda-range |
| Satuan Waktu | Select Hari/Jam dalam Range Waktu | combobox / Satuan Waktu | denda-unit |
| Tipe Denda | Select Rupiah/Persen dalam Denda | combobox / Tipe Denda | denda-type |
| Denda | input decimal | textbox / Denda | denda-value |
| Validasi Denda | Nama denda wajib diisi.; Masukkan nilai denda yang valid.; Persentase maksimal 100%.; Range waktu tidak valid. | alert / Validasi Denda | denda-error |
| Batal / Simpan | Simpan disabled ketika invalid | button / Batal; button / Simpan | denda-cancel; denda-save |

### daftar-pengajuan — Pembatalan Tiket / Pembatalan Tiket Agen

| Elemen / label | Jenis / state | role / name | testid usulan |
|---|---|---|---|
| Penjualan Cabang / Penjualan Agen / Pengajuan Pembatalan | Menu kanal dan halaman per role | link / label menu | channel-cabang; channel-agen; my-requests |
| Ajukan Pembatalan | Cabang; HTML menulis Buat Pembatalan (A03) | button / Ajukan Pembatalan | new-request |
| Buat Pembatalan | Agen/Pusat sesuai konteks; Pusat hanya Cabang | button / Buat Pembatalan | new-cancellation |
| Filter / Reset | Panel filter, apply dan reset | button / Filter; button / Reset | request-filter; request-filter-reset |
| ID Pengajuan / ID Tiket | textbox; Masukkan ID | textbox / ID Pengajuan / ID Tiket | request-id-filter |
| Tanggal Pengajuan | textbox; Masukkan Tanggal, wiring belum lengkap | textbox / Tanggal Pengajuan | request-date-filter |
| Pengaju / Pengaju / Nama Agen | textbox; Masukkan Nama | textbox / Pengaju (Cabang); textbox / Pengaju / Nama Agen (Agen) | request-owner-filter |
| Ukuran Halaman | Select 20/50/100; association belum diketahui | combobox / Ukuran Halaman | request-page-size |
| Semua / Menunggu Approval / Disetujui / Ditolak / Dibatalkan | Tombol tab; badge jumlah Menunggu | button / label tab | request-tab-all; request-tab-waiting; request-tab-approved; request-tab-rejected; request-tab-withdrawn |
| Tabel Pengajuan | ID Pembatalan, Tanggal Pembatalan, ID Tiket, Golongan, Jenis, User/unit, Denda/Jumlah Potongan, Total Dikembalikan, Status, Aksi | table / Pengajuan Pembatalan | requests-table |
| Lihat detail | ActionButton icon eye; title Lihat detail | button / Lihat detail | request-view |
| Setujui pembatalan / Tolak pengajuan | ActionButton row; Pusat + Menunggu | button / Setujui pembatalan; button / Tolak pengajuan | request-approve-row; request-reject-row |
| Batalkan pengajuan | ActionButton row; pengaju sendiri + Menunggu | button / Batalkan pengajuan | request-withdraw-row |
| Empty State | Tidak Ada Data yang tersedia / Tidak ada pengajuan yang menunggu… | status / Empty State | request-empty |
| Keterangan Read-only | Cabang memantau Agen; keputusan Pusat | note / Keterangan Read-only | request-readonly-note |

### ajukan-pembatalan — Buat Pembatalan Tiket

| Elemen / label | Jenis / state | role / name | testid usulan |
|---|---|---|---|
| Tanggal Awal / Tanggal Akhir | Kontrol range tanggal; wajib, Maksimal 30 Hari; HTML contoh statis | textbox / Tanggal Awal; textbox / Tanggal Akhir | departure-date-start; departure-date-end |
| Pilih Jadwal Kapal | Select; Pilih Jadwal Rute \| Kapal; wajib | combobox / Pilih Jadwal Kapal | departure-schedule |
| Detail Jadwal | Rute, jam/zona, tanggal, kapal/voyage | region / Detail Jadwal | schedule-detail |
| Pilih Pembatalan | Select Batal Tiket / Kapal Tidak Berangkat | combobox / Pilih Pembatalan | cancellation-type |
| ID Tiket | Select; Masukkan ID Tiket; wajib | combobox / ID Tiket | cancellation-ticket |
| Ganti Jadwal / Ubah Pencarian | Mengosongkan pilihan dan kalkulasi terkait | button / Ganti Jadwal; button / Ubah Pencarian | change-schedule; change-search |
| Validasi Tiket | Tiket sudah digunakan untuk boarding dan tidak dapat dibatalkan. | alert / Validasi Tiket | ticket-error |
| Peringatan Boarding Pass | Boarding pass sudah dicetak… | status / Peringatan Boarding Pass | boarding-pass-warning |
| Detail Pembeli Tiket / Detail Penumpang | Nama, kontak, identitas, pembelian, pembayaran dan status boarding | region / label bagian | buyer-detail; passenger-detail |
| Denda / Ringkasan Finansial | Hasil kalkulasi, harga, komisi/pass/diskon, potongan dan refund; bukan override manual | region / Ringkasan Finansial | cancellation-financial-summary |
| Keterangan Batal Tiket | Input opsional; Masukkan Keterangan Batal Tiket (Bila Ada) | textbox / Keterangan Batal Tiket | cancellation-reason |
| Ajukan Pembatalan | Aksi Cabang yang disesuaikan dari HTML Batalkan Tiket | button / Ajukan Pembatalan | request-open-confirm |
| Batalkan Tiket | Agen membuka konfirmasi pengajuan; Pusat membuka konfirmasi direct | button / Batalkan Tiket | cancellation-open-confirm |

### detail-pengajuan — Detail Pengajuan Pembatalan

| Elemen / label | Jenis / state | role / name | testid usulan |
|---|---|---|---|
| Detail Pengajuan / Detail Jadwal | ID tiket, penumpang, golongan, jadwal, pengaju/unit, tanggal, alasan, tujuan refund | region / Detail Pengajuan; region / Detail Jadwal | request-detail; schedule-detail |
| Status Pengajuan | Label status kanonis | status / Status Pengajuan | request-status |
| Harga Tiket / Denda / Estimasi Refund | Nilai snapshot | region / Ringkasan Finansial | request-financial-summary |
| Keterangan Snapshot | Nominal denda dikunci pada waktu pengajuan… | note / Keterangan Snapshot | snapshot-note |
| Setujui Pembatalan / Tolak | Pusat + Menunggu | button / Setujui Pembatalan; button / Tolak | request-approve; request-reject |
| Batalkan Pengajuan | Pengaju sendiri + Menunggu | button / Batalkan Pengajuan | request-withdraw |
| Banner Alasan Penolakan | Banner pengajuan Ditolak; terpisah dari textarea modal | alert / Alasan Penolakan | request-rejection-reason |
| Riwayat | Aksi, waktu, aktor, alasan; hapus Tiket Diterbitkan sesuai spec | region / Riwayat | request-history |
| Kembali | Tombol/breadcrumb kembali ke daftar | button / Kembali | request-back |

### konfirmasi — Dialog kirim / approve / reject / penarikan / direct

| Elemen / label | Jenis / state | role / name | testid usulan |
|---|---|---|---|
| Dialog Aktif | Batalkan Tiket / Setujui Pembatalan / Tolak Pengajuan Pembatalan / Batalkan Pengajuan | dialog / judul modal | cancellation-confirm-dialog |
| Kembali / Batal | Menutup modal tanpa mutasi | button / Kembali; button / Batal | confirm-back; confirm-cancel |
| Kirim Pengajuan / Batalkan Tiket | Konfirmasi pengajuan atau direct; disabled saat Mengirim…/Memproses… | button / label tindakan | confirm-submit |
| Setujui Pembatalan | Konfirmasi approve | button / Setujui Pembatalan | confirm-approve |
| Alasan Penolakan | textarea; wajib, placeholder Contoh: Dokumen pendukung tidak dilampirkan | textbox / Alasan Penolakan | reject-reason |
| Tolak Pengajuan | Disabled alasan trim kosong | button / Tolak Pengajuan | confirm-reject |
| Batalkan Pengajuan | Konfirmasi menarik pengajuan | button / Batalkan Pengajuan | confirm-withdraw |
| Toast / Loading | Pesan hasil dan Mengirim…/Memproses… | status / Toast; status / Loading | cancellation-toast; cancellation-loading |

State empty, invalid, read-only, disabled, loading, sukses, ditolak dan dibatalkan tercermin pada markup/logika pendukung. Error jaringan, session expired dan recovery finansial adalah state yang diperlukan skenario, belum didesain. Link lihat pengajuan duplikat punya markup kondisional tetapi `ajErrorLink` selalu kosong pada logika; tidak dianggap kontrol aktif produksi.

## Assumptions Log

| ID | Keputusan / keterbatasan |
|---|---|
| A01 | Konflik Master 12 vs 13: dipilih snapshot tetap untuk pengajuan lama/Menunggu karena Master 10–12 dan teks HTML mengunci nilai saat pengajuan. Master 13 tidak dijadikan oracle kalkulasi ulang. Perlu keputusan bisnis sebelum memakai hasil sebagai acceptance final. |
| A02 | Tidak ada PNG. HTML extras terbaca setelah mengekstrak template JSON bundler; inventaris berasal dari spec dan markup/logika HTML, tanpa klaim verifikasi visual/render produksi. Tidak ada extras biner. |
| A03 | Label Cabang Ajukan Pembatalan mengikuti spec; tombol HTML Buat Pembatalan/Batalkan Tiket dicatat sebagai mismatch desain. Label Agen/pusat mengikuti konteks tindakan dan modal. |
| A04 | Rumus denda Agen pada seed HTML berbeda dari master; diabaikan sebagai contoh prototipe yang bertentangan dengan spec. Denda diuji sama untuk kondisi identik. Komisi/pass existing belum dikonfirmasi; fixture inti menggunakan harga bayar Rp400.000, diskon/pass/komisi terpisah=0 sehingga refund=harga bayar−denda. Kasus komponen memerlukan fixture existing tervalidasi. |
| A05 | Batas waktu diasumsikan interval inklusif di titik rule dan beralih setelahnya: H-3 berlaku delta<=−72 jam; H-2 untuk (−72,−48]; H-1 untuk (−48,0). H+ diuji hanya pada fixture rule lengkap: H+1 [0,24], H+2 (24,48], H+3 >48 jam. Aturan tepat keberangkatan dan gap/overlap perlu konfirmasi; jangan mengarang rule H+ default. |
| A06 | Waktu dibandingkan sebagai instant dengan zona jadwal WITA (+08:00); bukan zona browser. Jam dibekukan pada fixture; tanggal contoh relatif terhadap jadwal, tidak bergantung tanggal host. |
| A07 | Eligibility existing tidak lengkap: tiket fixture dibayar, aktif, milik unit, sesuai jadwal dan belum boarding. Boarding diblokir sesuai HTML; boarding pass tercetak hanya warning. Akses Cabang ke Agen dibatasi hubungan unit existing, bukan semua Agen. |
| A08 | Nama denda/range/nilai nonnegatif dan alasan penolakan wajib mengikuti HTML. Batas panjang, pembulatan dan angka desimal belum ditetapkan; gunakan fixture bulat untuk oracle wajib, round half up Rupiah untuk edge sebagai asumsi eksplisit. |
| A09 | Filter tanggal, ukuran halaman dan kontrol rentang tanggal ada dalam HTML tetapi tidak sepenuhnya wired; skenario menguji perilaku yang diharapkan, bukan menganggap prototipe berfungsi. Maksimal 30 hari diasumsikan selisih tanggal akhir−awal<=30. |
| A10 | Selector role/name diusulkan dari markup/label; semua testid usulan dan association label harus diverifikasi di aplikasi. Tombol berulang di-scope ke row ID atau modal aktif. URL produksi belum ada; target navigate berupa nama layar/route intent untuk dipetakan codegen. |
| A11 | Jenis Kapal Tidak Berangkat, pengecualian denda sebelum cetak Rp0, komisi, kuota kursi, notifikasi dan target 1 jam hanya muncul pada HTML; belum menjadi aturan spec. Denda kapal batal/Rp0 sebelum cetak diuji bersyarat dengan fixture existing, SLA 1 jam tidak dijadikan ambang lulus. |
| A12 | Skenario stress memakai profil 100 sesi, 1.000 tiket/pengajuan, 10.000 baris dan teks 10.000 karakter sebagai data uji, bukan SLA. Lulus berdasarkan integritas, isolasi dan recovery; tidak ada ambang respons yang dikarang. Fixture paralel, gangguan jaringan, sesi kedaluwarsa dan audit/refund membutuhkan adapter lingkungan uji. |
| A13 | Invarian finansial diasumsikan atomik/idempoten atau melalui status recovery yang jelas: UI tidak boleh mengklaim refund berhasil ketika layanan gagal; retry tidak menggandakan refund. Cara transaksi/asinkron produksi belum diketahui. |
| A14 | Tidak dibuat kontrol Role/Page PROTOTIPE menjadi alur aplikasi produksi. Tidak mengeksekusi script HTML; hanya membaca sebagai data pendukung. |
| A15 | Kontrak codegen: `navigate.target` dipetakan ke URL/layar/dialog nyata; konteks sesi/clock dibaca dari value dan testData. `expect.value` adalah oracle semantik: tidak terlihat → not.toBeVisible, disabled → toBeDisabled, teks/nilai → assert isi dan nilai fixture. Target Audit Transaksi/Status Refund/Hasil Paralel/Hasil Recovery memerlukan adapter ledger/fixture, bukan elemen yang ditemukan pada desain. Beban, fault, parallelGroups dan sentinel QA-LONG-TEXT-10000 harus diekspansi runner; urutan steps menggambarkan tiap alur, barrier menjalankan konfirmasi bersamaan. `masterAfterRules` pada fallback H+ harus dinormalisasi menjadi rule H+ Hari pada fixture. Skenario ini spesifikasi siap diterjemahkan, bukan test Playwright yang sudah dijalankan. |
