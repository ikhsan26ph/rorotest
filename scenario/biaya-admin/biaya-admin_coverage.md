# Cakupan

30 skenario: snapshot, 9 metode aktual (Bank Mandiri/BCA/BNI/BRI, QRIS, OVO, DANA, Alfamart, Indomaret) untuk quote backend dan renderer, empat role, sepuluh laporan operator, saldo, pemulihan, dan instruksi gateway semua metode. Laporan Admin Prahu mengikuti menu aktual.

Quote diuji tanpa memanggil gateway: fungsi showva mengonsumsi getFeeAdmin. Pemilihan metode via ajaxfaspay juga memanggil potongkomisisaldouser; tahap instruksi gateway dan debit awal dijalankan atas izin eksplisit pengguna; pelunasan pembayaran tetap menunggu konfirmasi dummy. Quote passed tidak membuktikan gateway atau laporan pascapembayaran passed.

SCN-0028 memeriksa 20 transaksi historis dan 19 transisi sisa saldo secara read-only. Ini terpisah dari SCN-0025 yang memeriksa debit aktual order baru pada tahap instruksi bayar.

REQ-009 → SCN-0029 (invoice pending setelah pemulihan). REQ-010 → SCN-0030 (recovery gateway). Total 30 skenario.

REQ-011 dikaji pada smoke ulang read-only: SMOKE-user-qris-detail (fee snapshot saat penerbitan), SMOKE-user-qris-payment (konsistensi dua card), dan SMOKE-user-qris-default-detail (kasus screenshot6200 memerlukan kode order yang sama). Fee11000 pada order uji3%+1700 tidak dianggap bukti Processing Fee hilang. Tidak membuat booking baru untuk menutup gap fixture dalam smoke.
