# Coverage — ro313-cetak-tiket-langsung

Review tanggal 8 Oktober 2026 (Asia/Jakarta). Sumber: analysis.md, feature, scenarios.json pada folder ini. ID ringkas pada tabel memakai prefix `RO313-CETAK-TIKET-LANGSUNG-`.

## Ringkasan

| Kategori | Jumlah |
|---|---:|
| positive | 24 |
| negative | 38 |
| edge | 31 |
| stress | 13 |
| **Total** | **106** |

Seluruh 14 requirement memiliki minimal satu positive dan satu negative. Layar cetak-e-tiket ter-cover; popup PDF dan adapter print merupakan konteks dokumen pada layar yang sama. REQ-012 merupakan requirement turunan spec; REQ-013 dan REQ-014 berasal dari desain dan asumsi perilaku.

## Requirements Traceability Matrix

| REQ | Deskripsi | Scenario IDs |
|---|---|---|
| REQ-001 | Menu sidebar Cetak Tiket membuka halaman Cetak E-Tiket secara langsung. | POS-001, NEG-001, NEG-002, EDG-001 |
| REQ-002 | Daftar berbentuk tabel dengan delapan kolom yang ditetapkan. | POS-002, POS-003, NEG-003, NEG-004, EDG-002, STR-001, STR-012 |
| REQ-003 | Hanya order berstatus selesai ditampilkan. | POS-004, NEG-005, NEG-006, NEG-007, EDG-003, EDG-004, STR-002 |
| REQ-004 | Pembelian lewat cabang mensyaratkan konfirmasi cetak e-tiket. | POS-005, POS-006, NEG-008, NEG-009, EDG-005, STR-003 |
| REQ-005 | Baris otomatis hilang setelah melewati H+3 waktu keberangkatan kapal. | POS-007, NEG-010, NEG-011, EDG-006, EDG-007, EDG-008, EDG-009, EDG-010, EDG-011, STR-004 |
| REQ-006 | Cetak Tiket pada baris langsung memanggil fitur print tiket order tersebut. | POS-008, POS-009, NEG-012, NEG-013, NEG-014, NEG-015, EDG-012, EDG-013, EDG-014, STR-005 |
| REQ-007 | Download pada baris membuka PDF tiket di tab baru. | POS-010, POS-011, NEG-016, NEG-017, NEG-018, NEG-019, NEG-020, EDG-015, EDG-016, STR-006 |
| REQ-008 | Filter ID Order menggunakan text field. | POS-012, POS-013, NEG-021, NEG-022, NEG-023, EDG-017, EDG-018, STR-007 |
| REQ-009 | Filter Rute menggunakan dropdown rute yang tersedia. | POS-014, POS-015, NEG-024, NEG-025, EDG-019, EDG-020, STR-008 |
| REQ-010 | Filter tanggal berangkat menerima tanggal dan waktu DD/MM/YYYY hh:mm. | POS-016, POS-017, NEG-026, NEG-027, NEG-028, NEG-029, NEG-030, NEG-031, EDG-021, EDG-022, EDG-023, EDG-024, STR-009 |
| REQ-011 | Filter Nama Pembeli menggunakan text field. | POS-018, POS-019, NEG-032, NEG-033, EDG-025, EDG-026, EDG-027, STR-010 |
| REQ-012 | Filter yang digunakan bersamaan tetap bekerja pada daftar yang memenuhi syarat. | POS-020, POS-021, NEG-034, NEG-035, EDG-028, STR-011 |
| REQ-013 | Ukuran halaman, nomor halaman, dan ringkasan jumlah data sesuai hasil eligible/filter. | POS-022, POS-023, NEG-036, NEG-037, EDG-029, EDG-030 |
| REQ-014 | Tombol Filter menyediakan akses ke empat kontrol filter. | POS-024, NEG-038, EDG-031, STR-013 |

## Coverage elemen UI

| Elemen | Scenario IDs contoh |
|---|---|
| Menu Cetak Tiket | POS-001 |
| Judul Cetak E-Tiket | POS-001, EDG-001 |
| Breadcrumb Cetak Tiket | POS-001 |
| Informasi masa cetak | POS-001 |
| Filter | EDG-002, NEG-011, EDG-012, EDG-015 |
| Panel Filter | POS-024, EDG-031, STR-013 |
| ID Order | NEG-011, EDG-012, POS-012, POS-013 |
| Rute | POS-014, POS-015, NEG-024, NEG-025 |
| Tanggal berangkat | POS-016, POS-017, NEG-026, NEG-027 |
| Nama Pembeli | EDG-015, POS-018, POS-019, NEG-032 |
| Ukuran halaman | POS-022 |
| Tabel e-tiket | NEG-001, EDG-001, NEG-003, EDG-002 |
| Ringkasan data | POS-022, POS-023, NEG-036, NEG-037 |
| Halaman 1 | POS-022, NEG-037, EDG-030 |
| Halaman 2 | POS-023, NEG-037, EDG-029, EDG-030 |
| Kolom ID Order | POS-002 |
| Kolom Nama Pembeli | POS-002 |
| Kolom Rute | POS-002 |
| Kolom Kapal | POS-002 |
| Kolom Berangkat | POS-002 |
| Kolom Jml Tiket | POS-002 |
| Kolom Total (Rp) | POS-002 |
| Kolom Aksi | POS-002 |
| Baris order (scope ID Order) | POS-002, POS-003, NEG-004 |
| Cetak Tiket (scope ID Order) | POS-002, POS-004, EDG-011, POS-008 |
| Download (scope ID Order) | POS-002, POS-005, EDG-011, POS-010 |
| Badge masa cetak (scope ID Order) | EDG-008, EDG-011 |

## Validasi

- Parsing Gherkin memakai @cucumber/gherkin 42.0.1: 106 Scenario valid, dikompilasi menjadi 106 pickle tanpa error. Dependensi validator dipasang di direktori temporer, tanpa mengubah package.json repository.
- Given untuk prasyarat fixture, When untuk navigasi/aksi, Then/And untuk oracle: lulus pada semua scenario.
- Kesesuaian seluruh teks langkah, urutan, ID, judul, category, priority, requirement, screen antara AST Gherkin dan JSON: lulus.
- Schema field wajib, action enum, selector role/name/testid, sumber input, ID unik, summary aktual dan referensi asumsi: lulus.
- 21 anchor transisi/workload mengarah ke langkah yang ada.
- 89 pemeriksaan independen terhadap eligibility 72 jam, status/channel, hasil filter, pagination, serta identitas/jumlah dokumen cocok dengan fixture. Workload besar, respons fault, UI nyata, dialog OS dan isi PDF aktual memerlukan harness dan belum dieksekusi.
- Keempat kategori hadir; 31 edge mencakup waktu batas, timezone, kalender, Unicode, arah rute, reprint, race, dan pagination. 13 stress memakai profil beban/timeout/payload tanpa SLA rekaan.

## Duplikat

Duplikat exact setelah membandingkan langkah, expected, dan seluruh testData: 0; tidak ada yang dibuang. Review semantik mempertahankan perbedaan status pending/dibatalkan/gagal, jenis invalid tanggal, print vs PDF, dan sisi sebelum/tepat/sesudah H+3 karena masing-masing memeriksa kondisi berbeda. Cetak saat panel terbuka, cetak dengan cancel, dan cetak ulang memakai oracle/fixture perilaku berbeda.

## Gap dan batas eksekusi

- Tidak ada gap requirement positive/negative atau elemen penting UI RO313. Header akun, saldo, top-up, menu global lain dan fitur Daftar Order berada di luar cakupan modul.
- Konfirmasi aturan bisnis diperlukan untuk H+3 rolling 72 jam vs kalender, exact ID, substring nama, timezone, filter AND/minute, akses petugas, dan revalidasi dokumen. Asumsi tercatat A-02 sampai A-09; perubahan keputusan bisnis perlu regenerasi kasus terkait.
- Panel filter, trigger apply/debounce, input tanggal, accessible name ikon download, endpoint/URL halaman, dan opsi pagination belum terlihat pada desain/DOM. A-11 sampai A-13 harus dicocokkan pada codegen; data-testid hanya usulan.
- Badge diuji pada fixture state yang mendukung badge; ambang kemunculan belum diberikan (A-14), sehingga tidak ada assertion threshold umur rekaan.
- Codegen harus mengimplementasikan oracle testData.assertions. Assertion absence, exact row set, response status/MIME, no-side-effects, popup, print-call-count, serta transisi clock tidak cukup hanya toBeVisible().
- Stress membutuhkan generator seed, browser context paralel, loop, kontrol respons out-of-order/timeout dan pencatatan hasil. Fixture beban A-10 bukan ukuran kapasitas atau SLA yang sudah disepakati.
- Aplikasi web repository hanya mengunggah input, bukan aplikasi TMS Cetak E-Tiket. Hasil ini adalah desain uji yang divalidasi struktur/traceability dan konsistensi fixture; belum membuktikan fungsi aplikasi target lulus.

## Tindak lanjut untuk codegen

Petakan URL, endpoint, DOM, setup seed, autentikasi dan oracle adapter terlebih dahulu. Gunakan exact ID Order untuk scope baris agar Cetak/Download tidak memilih order lain. Bekukan jam backend dan browser bersama. Dengarkan popup sebelum klik Download, periksa respons PDF dan ekstrak isi melalui adapter; spy/stub print tanpa mengklaim otomatisasi dialog OS. Rekam pemberitahuan kegagalan sebelum reload pada scenario recovery.
