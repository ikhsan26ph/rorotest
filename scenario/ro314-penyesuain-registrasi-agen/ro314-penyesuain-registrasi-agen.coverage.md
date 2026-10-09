# Coverage — ro314-penyesuain-registrasi-agen

## Ringkasan

| Kategori | Jumlah | Makna |
|---|---:|---|
| positive | 6 | Penghapusan UI, edit valid bersyarat, preservasi deposit valid bersyarat. |
| negative | 5 | Regresi terhadap perilaku terlarang: validasi jaminan tertinggal, bocoran nominal lama, kontrol lama muncul kembali; penolakan deposit memakai baseline invalid. |
| edge | 6 | Fixture historis nol/kosong dan kombinasi record lama dengan simpan edit. |
| stress | 0 | Tidak ada kontrak load/performance; tidak membuat kriteria lulus karangan. |
| **Total** | **17** | Semua adalah spesifikasi uji, bukan hasil eksekusi aplikasi. |

Kategori negative untuk perubahan penghapusan mencakup pengecekan perilaku yang dilarang requirement, meskipun input registrasinya valid. Ini bukan cakupan lengkap invalid input, error handling, atau autorisasi: aturan itu tidak tersedia. Pemenuhan jumlah positive/negative bukan bukti kelengkapan fungsi.

Lima requirement mempunyai minimal satu positive dan satu negative menurut definisi di atas. Empat halaman eksplisit tercakup; `deposit-agen` hanya konteks mekanisme yang nama layarnya belum diketahui.

## Requirements Traceability Matrix

| REQ | Deskripsi | Scenario IDs | Batas cakupan |
|---|---|---|---|
| REQ-001 | Hapus field dan kewajiban input jaminan saat registrasi | `RO314-PENYESUAIN-REGISTRASI-AGEN-POS-001`, `RO314-PENYESUAIN-REGISTRASI-AGEN-NEG-001` | Pemetaan UI belum tersedia; fixture/operasi baseline bersyarat sesuai skenario. |
| REQ-002 | Hapus informasi/nominal jaminan pada Detail Agen | `RO314-PENYESUAIN-REGISTRASI-AGEN-POS-002`, `RO314-PENYESUAIN-REGISTRASI-AGEN-NEG-002`, `RO314-PENYESUAIN-REGISTRASI-AGEN-EDG-001`, `RO314-PENYESUAIN-REGISTRASI-AGEN-EDG-004` | Pemetaan UI belum tersedia; fixture/operasi baseline bersyarat sesuai skenario. |
| REQ-003 | Hapus field dan kemampuan menambah/mengubah jaminan pada Edit Agen | `RO314-PENYESUAIN-REGISTRASI-AGEN-POS-003`, `RO314-PENYESUAIN-REGISTRASI-AGEN-POS-004`, `RO314-PENYESUAIN-REGISTRASI-AGEN-NEG-003`, `RO314-PENYESUAIN-REGISTRASI-AGEN-EDG-003`, `RO314-PENYESUAIN-REGISTRASI-AGEN-EDG-006` | Pemetaan UI belum tersedia; fixture/operasi baseline bersyarat sesuai skenario. |
| REQ-004 | Hapus informasi/nominal jaminan pada Akun Saya | `RO314-PENYESUAIN-REGISTRASI-AGEN-POS-005`, `RO314-PENYESUAIN-REGISTRASI-AGEN-NEG-004`, `RO314-PENYESUAIN-REGISTRASI-AGEN-EDG-002`, `RO314-PENYESUAIN-REGISTRASI-AGEN-EDG-005` | Pemetaan UI belum tersedia; fixture/operasi baseline bersyarat sesuai skenario. |
| REQ-005 | Pertahankan mekanisme Deposit Agen menurut baseline | `RO314-PENYESUAIN-REGISTRASI-AGEN-POS-006`, `RO314-PENYESUAIN-REGISTRASI-AGEN-NEG-005` | Oracle dan tindakan deposit menunggu baseline. |

## Cakupan layar dan elemen

| Layar/konteks | Skenario | Elemen/aspek |
|---|---|---|
| tambah-agen | POS-001, NEG-001 | Label/kontrol nominal dan validasi registrasi tanpa jaminan. |
| detail-agen | POS-002, NEG-002, EDG-001, EDG-004 | Bagian informasi, nilai historis tanpa label, nol, dan sisa placeholder data kosong. |
| edit-agen | POS-003, POS-004, NEG-003, EDG-003, EDG-006 | Kontrol tambah/ubah, record tanpa jaminan, legacy nonnol/nol, simpan tanpa jaminan. |
| akun-saya | POS-005, NEG-004, EDG-002, EDG-005 | Bagian informasi, nilai historis tanpa label, nol, dan sisa placeholder data kosong. |
| deposit-agen | POS-006, NEG-005 | Hasil valid dan penolakan invalid menurut baseline; UI belum terinventarisasi. |

ID singkat pada tabel ini memakai awalan `RO314-PENYESUAIN-REGISTRASI-AGEN-`.

## Hasil validasi artefak

- Sintaks Gherkin: **lulus** melalui parser resmi Cucumber `gherkin-official 42.0.1`; menghasilkan 17 scenario AST dan 17 pickle. Dependensi validator dipasang di direktori sementara, tidak mengubah dependency proyek.
- JSON dapat dibaca sebagai UTF-8; semua field wajib ada dan setiap action termasuk enum proyek.
- ID unik, pola ID/kategori benar, judul konsisten, tepat satu tag kategori/priority/REQ/screen sesuai JSON per skenario.
- 17 pasangan Gherkin–JSON cocok satu per satu; urutan dan teks seluruh Given/When/Then/And sesuai `gherkinSteps`.
- Semua precondition, langkah atomik, dan langkah baseline yang belum terurai memiliki referensi lengkap; tidak ada langkah yang diam-diam hilang pada metadata.
- `expected[]` sama persis dengan bagian Then/And hasil pada feature; summary sama dengan hitungan aktual.
- Tiap REQ memiliki positive dan negative; seluruh layar eksplisit tercakup. Stress dan kontrak invalid/otorisasi yang belum terdefinisi tetap gap.
- Setiap assertion absensi/ketidaktersediaan mempunyai jenis assertion eksplisit. Selector yang belum diketahui tetap null; tidak ada URL/tombol/pesan aplikasi buatan.
- Seluruh sourceRefs menunjuk baris spec yang sah; desain/extras kosong sesuai input. SHA-256 spec masih sama dengan sebelum penulisan feature/JSON.
- Keempat artefak menggunakan dokumen analisis yang sama. Tidak ada input yang ditulis ulang.

Validasi ini membuktikan konsistensi artefak. Tidak ada pengujian aplikasi TMS yang dijalankan; tidak ada klaim hasil UI, database, API, atau Deposit Agen sudah lulus.

## Duplikat dan tumpang tindih

- Duplikat ID/judul/payload penuh: **0**. Tidak ada skenario output yang dibuang.
- Pemeriksaan label dan kontrol pada form yang sama digabung menjadi satu skenario; tidak dihitung sebagai dua kasus mandiri.
- Kasus record tanpa jaminan, record lama nonnol, nol, dan kosong dipertahankan karena fixture dan risiko rendering berbeda. Ada assertion umum yang sama, tetapi bukan pengulangan fixture yang sama.
- Pengamatan field awal berbeda dari operasi simpan. POS-004 memakai record tanpa jaminan historis; EDG-006 memakai record historis berjaminan. Keduanya menguji jalur simpan dengan kondisi berbeda.
- Tidak membuat skenario pembatasan nominal jaminan, payload API, otorisasi gagal, atau verifikasi legal dengan expected yang belum didukung sumber.

## Kesiapan eksekusi dan ekstensi metadata

- **17/17 belum siap untuk codegen/eksekusi Playwright langsung**: rute, locator, indikator data siap, atau baseline belum tersedia. 13 skenario memiliki dependency fixture GAP-05; 5 memiliki operasi baseline belum terurai. Kedua kelompok dapat tumpang tindih.
- `steps[]` hanya memuat action atomik yang dapat dinyatakan tanpa menebak. Lima operasi yang belum diketahui disimpan di `unresolvedSteps`; `gherkinSteps` merekam urutan lengkap dan titik penyisipannya.
- Jangan menjalankan codegen yang mengabaikan `automation.readiness`, `unresolvedSteps`, atau `steps[].assertion`. Mapping generik expect → toBeVisible akan membalik expected untuk field yang dihapus.
- Locator siap pakai dan action form atomik harus dilengkapi dari implementasi/baseline lalu feature/JSON divalidasi ulang. Ekstensi ini dijelaskan juga pada `metadataExtensions` di JSON.
- `fixtureRef`/`baselineRef` adalah pengenal kebutuhan bukti, bukan file yang sudah tersedia. Tidak ada nilai nominal literal yang dipaksakan sebagai batas atau aturan produk.

## Gap dan rekomendasi lanjutan

| Gap | Status dan langkah berikutnya |
|---|---|
| GAP-01 — Verifikasi legal | Belum ada requirement. Setelah definisi tersedia, baru tambahkan skenario dokumen/status/approval atau gating yang memang dikonfirmasi. |
| GAP-02, GAP-06, GAP-12 — Pemetaan UI | Ambil rute, DOM/locator lama dan baru, indikator data siap, serta bukti nominal terkait jaminan. Periksa label sekaligus kontrol/nilai untuk menghindari lulus palsu. |
| GAP-03 — Registrasi | Lengkapi field lain, data valid, prasyarat, tindakan submit, dan hasil berhasil untuk NEG-001. Jangan menciptakan tombol atau toast. |
| GAP-04 — Edit | Lengkapi field lain, data perubahan valid, operasi simpan, dan verifikasi hasil untuk POS-004/EDG-006. |
| GAP-05 — Fixture historis | Konfirmasi fixture nonnol/nol/kosong dan akun terkait. Jika suatu bentuk data tidak sah/tidak tersedia, tandai kasus tidak dapat dijalankan; jangan membuat aturan data baru. |
| GAP-07 — Deposit | Sediakan baseline valid/invalid dengan aktor, layar, tindakan, data, dan oracle. Dua skenario deposit saat ini masih kerangka bersyarat. |
| GAP-08 — Data/API lama | Tidak tercakup sampai kebijakan retensi/migrasi/API diberikan. Penghapusan UI tidak cukup untuk menuntut field database dihapus atau payload ditolak. |
| GAP-09 — Permukaan tambahan | Daftar/ekspor/laporan/aplikasi lain tidak dinyatakan. Tambahkan hanya setelah cakupannya dikonfirmasi. |
| GAP-10 — Otorisasi | Tidak ada aturan lintas cabang/akun/role. Tambahkan skenario penolakan hanya setelah matriks izin tersedia. |
| GAP-11 — Stress | **0 skenario**. Target beban, concurrency, durasi, dan oracle belum tersedia; distribusi stress yang diminta workflow belum terpenuhi demi mematuhi larangan asumsi pengguna. |

Tidak ada REQ eksplisit yang sama sekali tidak mendapat skenario. Namun penelusuran 5/5 adalah cakupan dokumen, bukan cakupan eksekusi atau kelengkapan baseline Deposit Agen.

## Assumptions Log — hasil review

**Tidak ada asumsi perilaku produk yang diadopsi.** Tidak ada desain atau extras; UI hanya diturunkan dari nama yang tertulis. Unknown dibiarkan null atau menjadi gap. Dataset historis dan baseline diperlakukan sebagai prasyarat bersyarat, bukan fakta implementasi. Verifikasi legal, kebijakan backend, dan ambang stress tetap belum ditetapkan.
