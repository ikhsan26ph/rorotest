# Coverage - ro318-perubahan-warna-dokumen-roro

## Ringkasan

| Kategori | Jumlah final |
|---|---:|
| positive | 18 |
| negative | 6 |
| edge | 0 |
| stress | 0 |
| **Total** | **24** |

Semua 7 requirement memiliki skenario pada seluruh dokumen/kanal yang relevan. Ini cakupan rancangan uji, bukan hasil eksekusi aplikasi. Ketiga dokumen dan keenam kombinasi dokumen-kanal tercakup. Cakupan elemen UI aktual belum dapat dihitung karena daftar elemen tidak diberikan.

**Status: validasi artefak lulus; kelengkapan workflow bersyarat; pengujian aplikasi belum dilakukan.** Seluruh 24 skenario berstatus `automationStatus: blocked`. Gap spesifikasi dan akses harus dilengkapi sebelum membuat assertion Playwright yang dapat dijalankan. Tidak ada skenario yang dilaporkan lulus terhadap aplikasi.

## Requirements Traceability Matrix

| REQ | Deskripsi | Positive | Negative | Scenario IDs |
|---|---|---:|---:|---|
| REQ-001 | Warna identitas E-Tiket menjadi biru | 2 | 2 | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-001`, `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-001`, `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-002`, `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-002` |
| REQ-002 | Warna identitas Kwitansi menjadi #002564 | 2 | 2 | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-003`, `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-003`, `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-004`, `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-004` |
| REQ-003 | Warna identitas Boarding Pass menjadi biru | 2 | 2 | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-005`, `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-005`, `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-006`, `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-006` |
| REQ-004 | Warna di luar elemen identitas tetap | 3 | 0 | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-007`, `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-008`, `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-009` |
| REQ-005 | Informasi tetap | 3 | 0 | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-010`, `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-011`, `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-012` |
| REQ-006 | Format tetap | 3 | 0 | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-013`, `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-014`, `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-015` |
| REQ-007 | Nilai data tetap | 3 | 0 | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-016`, `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-017`, `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-018` |

## Cakupan dokumen dan kanal

| Dokumen / tag layar | Tampilan | Cetakan | Aspek |
|---|---|---|---|
| E-Tiket / `e-tiket` | Tercakup | Tercakup | REQ-001, REQ-004 sampai REQ-007 |
| Kwitansi / `kwitansi` | Tercakup | Tercakup | REQ-002, REQ-004 sampai REQ-007 |
| Boarding Pass / `boarding-pass` | Tercakup | Tercakup | REQ-003, REQ-004 sampai REQ-007 |

Skenario perubahan warna dipisah per kanal karena kode/hasil tampilan tidak membuktikan cetakan. Skenario regresi REQ-004 sampai REQ-007 memuat dua langkah akses dan dua assertion, masing-masing untuk tampilan dan cetakan. Baseline wajib berasal dari dokumen/data sumber yang sama serta kanal yang sama.

## Gap

| Gap | Dampak pada skenario | Penanganan |
|---|---|---|
| GAP-001: biru E-Tiket dan Boarding Pass belum memiliki kode/referensi pasti | Positive REQ-001 dan REQ-003 belum memiliki oracle warna final | Minta referensi resmi; jangan menyamakan dengan Kwitansi. |
| GAP-002: pemetaan elemen identitas belum ada | Semua skenario | Konfirmasi target dan elemen di luar target per dokumen/kanal. |
| GAP-003: baseline lama dan fixture data sama belum ada | Negative warna lama dan seluruh pemeriksaan regresi | Sediakan baseline; kode hijau dan field tidak ditebak. |
| GAP-004: keluaran cetakan dan metode pembuktian warna belum diketahui | Semua skenario yang memeriksa cetakan | Tetapkan metode verifikasi warna serta media/artefak aktual; tidak mengasumsikan PDF/printer tertentu. |
| GAP-005: akses aplikasi dan locator belum ada | Semua skenario | Lengkapi mekanisme akses dan selector aktual sebelum codegen. |
| GAP-006: definisi format belum rinci | REQ-006 | Konfirmasi pembandingan dan bagian dinamis; toleransi tidak dibuat sendiri. |
| GAP-007: tidak ada fixture edge atau kriteria stress | Kategori edge dan stress kosong | Tidak menambah volume, timeout, atau kasus langka rekaan. |
| GAP-008: cakupan historis/non-RORO/template lain belum dinyatakan | Tidak ada skenario luar cakupan | Konfirmasi aturan sebelum membuat expected result. |
| GAP-009: inventaris informasi dan pemetaan data belum ada | REQ-005 dan REQ-007 | Gunakan field/konten aktual sesudah tersedia. |
| GAP-CAT-001: minimum positive + negative per REQ belum terpenuhi untuk REQ-004 sampai REQ-007 | Tidak ada negative terpisah setelah deduplikasi | Assertion negatif yang hanya membalik kalimat assertion positif telah digabung. Buat negative baru hanya bila ada kondisi dan oracle yang berbeda serta didukung bukti. |

Tidak ada requirement eksplisit yang hilang dari rancangan uji. Namun persyaratan distribusi workflow belum seluruhnya terpenuhi: REQ-004 sampai REQ-007 tidak memiliki negative independen; edge dan stress belum tersedia. Catatan ini sengaja tidak ditutup dengan asumsi atau penggandaan skenario.

## Hasil validasi

- Parser resmi `@cucumber/gherkin` berhasil membaca Feature dan 24 Scenario: 193 langkah Gherkin, tanpa error sintaks.
- ID Scenario pada nama dan tag cocok satu-ke-satu dengan ID JSON; category, priority, requirement, screen, dan title cocok.
- Semua prasyarat, target langkah, urutan Given/When/Then/And, serta nilai pemeriksaan cocok dengan JSON.
- JSON dapat diparse; field wajib tersedia; action mengikuti enum proyek; `summary` cocok dengan jumlah aktual.
- `expected` cocok dengan langkah `expect`: total 36 assertion rancangan uji, mencakup tampilan/cetakan secara terpisah.
- Semua 7 REQ dan 3 label layar tercakup. Kode `#002564` tidak diterapkan pada skenario E-Tiket atau Boarding Pass.
- `source` menunjuk spec aktual; designs dan extras kosong. `selectorHints` kosong; tidak ada role, testid, URL, field, atau pesan error rekaan.
- Semua skenario memiliki status blocked dan daftar dependensi; tidak ada klaim eksekusi Playwright atau hasil uji aplikasi.
- Tidak ada duplikat persis berdasarkan requirement, layar, kanal, dan langkah setelah deduplikasi. Review semantik dijelaskan di bawah.

## Deduplikasi

Draft awal berisi 36 skenario. Sebanyak 12 negative regresi dihapus karena pemeriksaannya ekuivalen dengan positive pada dokumen, kanal, baseline, dan aspek yang sama. Pemeriksaan larangan perubahan tetap tercakup dalam assertion yang dipertahankan.

| ID dihapus | Digabung ke | Alasan |
|---|---|---|
| `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-007` | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-007` | Membalik pernyataan aspek harus tetap tanpa kondisi uji atau oracle berbeda. |
| `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-008` | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-008` | Membalik pernyataan aspek harus tetap tanpa kondisi uji atau oracle berbeda. |
| `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-009` | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-009` | Membalik pernyataan aspek harus tetap tanpa kondisi uji atau oracle berbeda. |
| `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-010` | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-010` | Membalik pernyataan aspek harus tetap tanpa kondisi uji atau oracle berbeda. |
| `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-011` | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-011` | Membalik pernyataan aspek harus tetap tanpa kondisi uji atau oracle berbeda. |
| `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-012` | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-012` | Membalik pernyataan aspek harus tetap tanpa kondisi uji atau oracle berbeda. |
| `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-013` | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-013` | Membalik pernyataan aspek harus tetap tanpa kondisi uji atau oracle berbeda. |
| `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-014` | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-014` | Membalik pernyataan aspek harus tetap tanpa kondisi uji atau oracle berbeda. |
| `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-015` | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-015` | Membalik pernyataan aspek harus tetap tanpa kondisi uji atau oracle berbeda. |
| `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-016` | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-016` | Membalik pernyataan aspek harus tetap tanpa kondisi uji atau oracle berbeda. |
| `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-017` | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-017` | Membalik pernyataan aspek harus tetap tanpa kondisi uji atau oracle berbeda. |
| `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-018` | `RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-018` | Membalik pernyataan aspek harus tetap tanpa kondisi uji atau oracle berbeda. |

Enam negative warna lama dipertahankan sebagai pemeriksaan kegagalan migrasi spesifik: tidak ada hijau identitas lama yang tertinggal berdasarkan baseline. Positive memeriksa target biru baru. Keduanya memiliki overlap logis (target biru yang benar juga menyingkirkan hijau lama), sehingga pasangan ini bukan cakupan bisnis independen. Negative dipertahankan untuk menelusuri kegagalan warna lama dan memenuhi pasangan kategori REQ-001 sampai REQ-003; assertion dapat berbagi implementasi saat otomasi dibuat.

## Rekomendasi tindak lanjut

Prioritas pertama adalah mendapatkan referensi biru E-Tiket/Boarding Pass, pemetaan elemen, baseline/data uji, serta metode akses dan pembuktian cetakan. Lalu lengkapi definisi format dan pemetaan informasi/data untuk mengubah pemeriksaan semantik menjadi assertion konkret.

Tambahkan edge hanya setelah variasi/batas yang benar-benar didukung sistem dan fixture terkait tersedia. Tambahkan stress hanya setelah operasi yang diuji, volume, durasi, kriteria kelulusan, dan oracle integritas warna/data disepakati. Tidak ada angka beban atau timeout yang diusulkan sebagai requirement.

Jika negative independen diwajibkan bagi REQ-004 sampai REQ-007, diperlukan kondisi kegagalan yang terdefinisi dan berbeda dari pemeriksaan kesetaraan baseline. Jangan mengisi gap kategori dengan salinan assertion yang sama.

## Assumptions Log yang diteruskan

**Tidak ada asumsi perilaku sistem.** Desain dan extras tidak tersedia; rincian yang tidak diketahui tetap menjadi gap. Nama layar dan target JSON merupakan label analisis, bukan UI terverifikasi. Fixture/baseline/selector belum ada dan tidak diisi dengan nilai rekaan.
