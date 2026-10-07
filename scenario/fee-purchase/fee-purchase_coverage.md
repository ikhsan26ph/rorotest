# Cakupan

26 kasus: 9 metode, 4 peran daftar/detail, 10 jenis laporan, pemulihan Finance, invoice pending, dan saldo.

Run `20261007-063745` membuat sembilan order baru pada jadwal 2321. Seluruh Jumlah dan Processing Fee pada sembilan channel publik diubah lalu dibaca ulang. Dasar persentase berasal dari komponen order aktual: harga Rp265.500 + pass Rp44.500.

Tujuh instruksi berhasil; nilai gateway awal, biaya pada halaman pembayaran, dan card detail sesuai fee uji. Timeout awal Mandiri/BCA/BNI diperiksa ulang pada order yang sama dengan konfigurasi uji aktif; hasil di `active-retry.json`. Dua retail gagal HTTP500; quote read-only keduanya benar, tidak berarti instruksi gateway berhasil.

Daftar empat peran memuat sembilan kode dengan kolom Harga Tiket Rp310.000. Kolom ini subtotal; tidak disamakan dengan total bayar termasuk fee. Tiga peran admin/operator tidak menyediakan link detail untuk order pending.

Sepuluh jenis laporan dari menu masing-masing Admin Prahu/Pusat/Cabang diamati, termasuk periode, header, kode order, dan detail trip yang tersedia. Laporan pemakaian saldo tiga peran dibandingkan dengan ledger per kode: tujuh debit Rp3.983, dua retail tanpa debit. Laporan lainnya belum memiliki transaksi lunas/agen/kendaraan/asuransi/pembatalan dari run ini; akses halaman tidak dianggap rekonsiliasi nominal.

Setelah Finance dipulihkan, ketujuh halaman pembayaran menampilkan fee terbaru berbeda dari snapshot instruksi/card. Bukti di `pending-ready.json` dan screenshot per metode; tidak memakai pembacaan provisional sebelum DOM siap.

Pelunasan tidak dilakukan: konfirmasi dummy untuk run ini belum diterima. Semua konfigurasi Finance kembali snapshot awal. Sembilan booking masih pending; tidak ditemukan pembatalan langsung sebelum batas bayar. Kode/jadwal/expiry dan status cleanup ada di `results/_test-data__fee-purchase__20261007-063745.md`.

## Triage run 20261007-063745

| SCN | Klasifikasi | Rujukan (REQ/FND) | Severity | Analisis singkat | Rekomendasi |
|---|---|---|---|---|---|
| SCN-0007 | BUG (probable) | REQ-FP-001, FND-FP-01 | major | Alfamart pada order X9135557 mengembalikan HTTP500 ApiException; quote benar tetapi instruksi tidak terbentuk. Response pertama dan screenshot state tersimpan. | Periksa exception/backend gateway untuk kode ini; retest satu order setelah diperbaiki. |
| SCN-0008 | BUG (probable) | REQ-FP-001, FND-FP-01 | major | Indomaret pada order M9135565 mengembalikan HTTP500 ApiException; tidak ada instruksi berhasil. | Periksa exception/backend gateway untuk kode ini. |
| SCN-0025 | BUG (probable) | REQ-FP-005, FND-FP-03 | major | Tujuh payment pending memakai fee Finance terbaru; card/instruksi awal menyimpan fee uji. QRIS11800 vs10640; total321800 vs320640. | Gunakan snapshot fee order/invoice yang sama pada detail, payment, dan proses bayar; retest setelah perubahan konfigurasi. |
| SCN-0001–0003; laporan retry | TEST ISSUE | REQ-FP-002/003 | — | Timeout navigasi/lookup awal dan pembacaan terlalu dini. Baca ulang tiga card dengan konfigurasi aktif sesuai; report retry menunggu selesai tanpa menaikkan limit100. Bukti awal tetap disimpan. | Gunakan readiness DOM/handler/lookup dan batas waktu sesuai respons; jangan mengulang booking untuk timeout baca. |
| SCN-0014–0019,0021–0023 | NEED RECHECK | REQ-FP-003 | — | Belum ada transaksi lunas/fixture agen/kendaraan/asuransi/pembatalan run. Akses laporan tidak membuktikan konsistensi angka. | Setelah dummy terkonfirmasi, sediakan transaksi terkait dan cocokkan per kode serta komponen yang sama. |

Ringkasan klasifikasi: 3 verdict BUG probable, 1 kelompok TEST ISSUE dipulihkan, 9 verdict NEED RECHECK/prasyarat. Tidak menganggap timeout klik popup retail sebagai akar HTTP500; response backend terukur terpisah.

Hasil final run20261007-063745:26skenario =14passed,3failed,9blocked. Semua30halaman laporan berhasil diamati setelah retry delapan halaman; sembilan rekonsiliasi finansial tetapblocked, bukan pass akses. Workbook reports/fee-purchase__20261007-063745.xlsx dan matriks9metode CSV tersedia.
