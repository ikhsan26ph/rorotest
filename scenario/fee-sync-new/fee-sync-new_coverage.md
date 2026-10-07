# Cakupan

Sembilan order baru, satu/metode sesuai koreksi eksplisit pengguna. Per kode: Finance saat pembuatan, gateway/fee awal, detail sebelum, pembayaran reload, detail sesudah, Finance sesudah. Tidak mengubah Finance atau menyelesaikan pembayaran. Retail tanpa instruksi/fee dibandingkan dicatat blocked. Kuota dikonsumsi; kode/jadwal/expiry/cleanup dicatat results. Tidak menggunakan hasil order sebelumnya sebagai verdict order baru.

## Hasil order baru — 2026-10-07, run 20261007-072556

Koreksi eksplisit pengguna: wajib menggunakan order baru. Sembilan booking baru dibuat, masing-masing satu savebooking dan satu metode. Enam booking awal dipertahankan; retry hanya untuk metode yang belum memiliki booking. Gangguan sebelum booking Alfamart (savebookingCount0), halaman Finance, dan login sempat timeout. Diagnosis setelahnya HTTP200 pada kedua login. Semua bukti awal dipertahankan; tidak mengatribusikan timeout sebagai bug nominal.

Tujuh metode sinkron: fee awal, detail sebelum, payment reload, detail sesudah sama. Pembayaran memiliki dua lokasi teks Biaya Admin (rincian dan card harga); seluruh pasangan nominal keduanya diperiksa pada load awal dan reload, semuanya sama. Kode/label visible terverifikasi; subtotal tidak dibandingkan sebagai fee.

| Metode | Kode baru | Fee detail | Fee payment reload | Verdict |
|---|---|---:|---:|---|
| Bank Mandiri | Z9135811 | 12000 | 12000 | passed |
| Bank BCA | C9135817 | 12000 | 12000 | passed |
| Bank BNI | K9135823 | 17000 | 17000 | passed |
| Bank BRI | A9135828 | 12000 | 12000 | passed |
| OVO | S9135832 | 19220 | 19220 | passed |
| DANA | T9135838 | 10850 | 10850 | passed |
| Alfamart | E9135877 | tidak tampil | tidak tampil | blocked |
| Indomaret | W9135882 | tidak tampil | tidak tampil | blocked |
| QRIS | I9135888 | 10640 | 10640 | passed |

BNI aktual Jumlah12000+Processing Fee5000=17000. QRIS2%×310000+4440=10640; detail/payment order baru I9135888 sama10640. Flat/persen berasal dari Finance snapshot sebelum/sesudah masing-masing order, tidak memakai nilai run sebelumnya. Seluruh12baris Finance sama antara awal/akhir; tidak diubah oleh run.

Alfamart E9135877 dan Indomaret W9135882 mengembalikan HTTP500 ApiException pada inisialisasi gateway order baru. Fee detail/payment tidak tampil; perbandingan blocked, bukan0 atau passed. Screenshot gateway dan response tercatat.

Hasil9skenario:7passed,0failed,2blocked. Tidak ada pelunasan/otorisasi wallet/simulator. Sembilan booking ada pada daftar User Umum; tidak ditemukan kontrol pembatalan langsung di daftar/detail. Cleanup masihpending dan kuota/saldo tidak diklaim pulih. Catatan results/_test-data__fee-sync-new__20261007-072556.md; Excel reports/fee-sync-new__20261007-072556.xlsx; CSV reports/fee-sync-new-matrix__20261007-072556.csv. Hasil berlaku untuk order baru dengan snapshot Finance saat pemeriksaan, tidak menghapus bukti mismatch pending setelah perubahan Finance pada run terdahulu.

## Triage

| SCN | Klasifikasi | Rujukan (REQ/FND) | Severity | Analisis singkat | Rekomendasi |
|---|---|---|---|---|---|
| SCN-0007 | NEED RECHECK; gateway BUG probable terulang | REQ-FS-001 / FND-FP-01 | major (gateway) | Order baru E9135877 HTTP500 ApiException; fee tidak tampil, perbandingan blocked. | Periksa backend/gateway untuk kode ini, lalu validasi fee pada instruksi berhasil. |
| SCN-0008 | NEED RECHECK; gateway BUG probable terulang | REQ-FS-001 / FND-FP-01 | major (gateway) | Order baru W9135882 HTTP500 ApiException; tidak menyimpulkan nilai0. | Perbaiki inisialisasi gateway, lalu bandingkan kedua halaman kode sama. |
| Persiapan SCN-0007–0009 | TEST ISSUE / kendala akses dipulihkan | REQ-FS-001 | — | Persiapan Alfamart belum savebooking; snapshot/login Finance timeout. Diagnosis HTTP200; retry metode tanpa booking berhasil. | Pertahankan single-save guard dan bukti attempts; retry hanya bila belum ada booking. |
| Validasi label | TEST ISSUE dipulihkan | REQ-FS-001 | — | Validasi awal mengharapkan satu label Biaya Admin, tetapi rendered payment mempunyai dua. Nilai kedua lokasi sama. | Verifikasi semua nominal label yang tampil, bukan mengharuskan cardinality1. |

Ringkasan: 2perbandingan NEED RECHECK dengan bukti kegagalan gateway, 2kelompok kendala eksekusi/validasi dipulihkan; 0bug selisih fee pada tujuh order baru yang berhasil.
