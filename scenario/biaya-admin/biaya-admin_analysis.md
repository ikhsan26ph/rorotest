# Analisis biaya admin

Sumber: instruksi pengguna 7 Oktober 2026; bukan perubahan kode aplikasi.

- REQ-001: Sumber nilai adalah Finance; cakupan channel adalah yang tampil di User Umum.
- REQ-002: OVO, DANA, QRIS memakai persentase dari harga + tarif pass, lalu Processing Fee flat ditambah sekali per transaksi.
- REQ-003: Channel lain memakai Jumlah flat + Processing Fee.
- REQ-004: Buka seluruh halaman empat role; bedakan keberhasilan akses dengan bukti perhitungan.
- REQ-005: Rekonsiliasi semua laporan yang tersedia menurut kontribusi order uji, status transaksi dan definisi kolom. Tidak otomatis menganggap fee sebagai pendapatan operator.
- REQ-006: Validasi potongan saldo awal membutuhkan nilai awal, debit ledger, dan nilai akhir pada order uji sampai instruksi pembayaran. Pelunasan atau penggunaan saldo sebagai pembayaran akhir tetap menunggu konfirmasi dummy.
- REQ-007: Snapshot/pulihkan konfigurasi serta catat dan bersihkan booking milik run.

Pembulatan rupiah belum ditetapkan pengguna. Gunakan nominal yang menghasilkan rupiah bulat untuk uji utama, dan laporkan perilaku pecahan secara terpisah tanpa menebak aturan. Izin pembayaran dummy untuk kasus lama tidak berlaku otomatis untuk pelunasan transaksi baru. Instruksi pembayaran dan debit awal termasuk izin eksplisit pengguna untuk pemeriksaan metode dan saldo.

- REQ-008: Aritmetika saldo historis harus cocok antara saldo sebelumnya, debit/kredit dan sisa saldo.

Rule RORO v1.5.0 (dokumen di scenario/, paragraf hasil ekstraksi 72–78): potongan saldo user umum memakai %komisi RORO × harga tiket tanpa tarif pass; pecahan dibulatkan ke atas. Ini berbeda dengan dasar persentase biaya admin terbaru dari pengguna (harga + tarif pass). Fee admin/Processing Fee tidak otomatis dimasukkan sebagai dasar potongan saldo. Pemakaian Saldo menurut rule tercatat setelah pemesanan dan dikeluarkan ketika order expired; jangan mengasumsikan laporan ini hanya transaksi lunas.

- REQ-009: Invoice yang sudah diterbitkan harus konsisten dengan nominal gateway ketika konfigurasi global berubah.
- REQ-010: Kegagalan gateway tidak boleh mengunci pemilihan metode alternatif pada order.

- REQ-011 (klarifikasi pengguna7 Oktober2026): nominal biaya admin pada card transaksi detail order harus termasuk Jumlah + Processing Fee, konsisten dengan halaman pembayaran. Total310000 dengan keterangan belum termasuk admin fee dianggap subtotal; tidak dinyatakan bug hanya karena belum mencakup fee.

Saat retest read-only, bedakan order yang dibuat pada konfigurasi default2%+4440 dari order lama yang dibuat memakai konfigurasi uji3%+1700. Selisih detail/payment setelah konfigurasi berubah tidak cukup untuk menyimpulkan Processing Fee hilang pada card. Nominal fee yang disimpan ketika penerbitan harus ikut diperiksa.
