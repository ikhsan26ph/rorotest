# Inventaris UI biaya admin

- SCR-01: `/admin/Finance/`; tabel CHANNELS, JUMLAH, PROCESSING FEE (RP), LIMIT. Link edit didapat dari `a.edit-link` baris channel. Form: `#Form_ItemEditForm_jumlah`, `#Form_ItemEditForm_processing_fee`, `#Form_ItemEditForm_limit`, tombol Save. Verifikasi 7 Oktober 2026; label jumlah lower case di DOM.
- SCR-02: User `/home/pencarian`, `/home/inputpesanan/`, halaman pilih pembayaran dari redirect booking. Selector historis `.pilihbankbayar`, `.btn-ganti`, `.lanjutbayar`, `.clickdana`, `.bayarovo` perlu diverifikasi saat run.
- SCR-03: Menu empat role didapat dari DOM dan explore/module-map.md. Admin Prahu `/adminprahu` berbeda dari SilverStripe Finance `/admin/Finance/`.
- SCR-04: Sepuluh laporan operator sesuai scripts/explore_reports.js; laporan tambahan Admin Prahu didapat dari menu aktual.
- SCR-05: Riwayat saldo operator dan agen serta laporan Pemakaian Saldo. Jangan klik top-up/konfirmasi pembayaran sebelum konfirmasi dummy.

FND-01: Alfamart/Indomaret sebelumnya mengembalikan unsupported IDR payment methods; harus diverifikasi ulang, bukan diasumsikan masih gagal.
FND-02: Ganti metode setelah gagal gateway sebelumnya dapat terkunci DOUBLE_VA.

FND-03 / SCR-02: QRIS pending memanggil ulang getFeeAdmin saat reload. Bandingkan `.totalforqr` dan total ringkasan dengan amount penerbitan awal; jangan klik simulator.

FND-04 / SCR-02 (kandidat dari screenshot pengguna): card transaksi detail order menampilkan6200 pada konfigurasi QRIS2%+4440, sementara card harga pembayaran10640. Perlu kode order yang sama untuk reproduksi; jangan menyatakan kandidat ini terkonfirmasi dari order L9134606 karena order tersebut dibuat memakai konfigurasi uji3%+1700 dan card detail menyimpan11000.
