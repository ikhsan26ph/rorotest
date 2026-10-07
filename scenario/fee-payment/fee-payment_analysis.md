# Analisis

REQ-FPAY-001: Pengguna meminta lanjut sampai pembayaran selesai. Konfirmasi semua gateway dummy: jawaban “lanjut” langsung terhadap pertanyaan konfirmasi sandbox/dummy, dicatat shared/decisions.md. Hanya9kode run20261007-072556.
REQ-FPAY-002: Nominal paid harus cocok snapshot instruksi; verifikasi status positif, bukan menganggap tombol hilang sebagai lunas.

REQ-FPAY-003: Output setelah pembayaran (e-tiket/kwitansi) diperiksa sebagai bagian uji sisi user/allhalaman; e-tiket dari kontrol cetak harus tersedia. Temuan direct GET500 diverifikasi lewat click UI aktual untuk menghindari asumsi akses endpoint.
