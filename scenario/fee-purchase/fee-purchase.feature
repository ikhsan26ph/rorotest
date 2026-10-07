Feature: Pembelian baru dan konsistensi biaya

  Scenario: SCN-0001: Pembelian baru Bank Mandiri dan konsistensi biaya sebelum pemulihan
    Given akun dan prasyarat tersedia
    When Baca nilai Finance aktual, ubah Jumlah dan Processing Fee, baca ulang nilai tersimpan.
    And Buat satu order baru; ekstrak harga/pass/subtotal aktual. Pilih metode lewat UI sampai instruksi, tanpa pelunasan jika dummy belum dikonfirmasi.
    And Catat respons gateway, UI pembayaran, daftar order dan fee card detail tanpa menimpa quote sesudah instruksi.
    Then Fee sesuai rumus dan snapshot konfigurasi uji; total gateway/UI cocok subtotal+fee.
    And Fee detail order sama dengan fee instruksi pada order yang sama; keterangan subtotal dibaca sebelum membandingkan total.

  Scenario: SCN-0002: Pembelian baru Bank BCA dan konsistensi biaya sebelum pemulihan
    Given akun dan prasyarat tersedia
    When Baca nilai Finance aktual, ubah Jumlah dan Processing Fee, baca ulang nilai tersimpan.
    And Buat satu order baru; ekstrak harga/pass/subtotal aktual. Pilih metode lewat UI sampai instruksi, tanpa pelunasan jika dummy belum dikonfirmasi.
    And Catat respons gateway, UI pembayaran, daftar order dan fee card detail tanpa menimpa quote sesudah instruksi.
    Then Fee sesuai rumus dan snapshot konfigurasi uji; total gateway/UI cocok subtotal+fee.
    And Fee detail order sama dengan fee instruksi pada order yang sama; keterangan subtotal dibaca sebelum membandingkan total.

  Scenario: SCN-0003: Pembelian baru Bank BNI dan konsistensi biaya sebelum pemulihan
    Given akun dan prasyarat tersedia
    When Baca nilai Finance aktual, ubah Jumlah dan Processing Fee, baca ulang nilai tersimpan.
    And Buat satu order baru; ekstrak harga/pass/subtotal aktual. Pilih metode lewat UI sampai instruksi, tanpa pelunasan jika dummy belum dikonfirmasi.
    And Catat respons gateway, UI pembayaran, daftar order dan fee card detail tanpa menimpa quote sesudah instruksi.
    Then Fee sesuai rumus dan snapshot konfigurasi uji; total gateway/UI cocok subtotal+fee.
    And Fee detail order sama dengan fee instruksi pada order yang sama; keterangan subtotal dibaca sebelum membandingkan total.

  Scenario: SCN-0004: Pembelian baru Bank BRI dan konsistensi biaya sebelum pemulihan
    Given akun dan prasyarat tersedia
    When Baca nilai Finance aktual, ubah Jumlah dan Processing Fee, baca ulang nilai tersimpan.
    And Buat satu order baru; ekstrak harga/pass/subtotal aktual. Pilih metode lewat UI sampai instruksi, tanpa pelunasan jika dummy belum dikonfirmasi.
    And Catat respons gateway, UI pembayaran, daftar order dan fee card detail tanpa menimpa quote sesudah instruksi.
    Then Fee sesuai rumus dan snapshot konfigurasi uji; total gateway/UI cocok subtotal+fee.
    And Fee detail order sama dengan fee instruksi pada order yang sama; keterangan subtotal dibaca sebelum membandingkan total.

  Scenario: SCN-0005: Pembelian baru OVO dan konsistensi biaya sebelum pemulihan
    Given akun dan prasyarat tersedia
    When Baca nilai Finance aktual, ubah Jumlah dan Processing Fee, baca ulang nilai tersimpan.
    And Buat satu order baru; ekstrak harga/pass/subtotal aktual. Pilih metode lewat UI sampai instruksi, tanpa pelunasan jika dummy belum dikonfirmasi.
    And Catat respons gateway, UI pembayaran, daftar order dan fee card detail tanpa menimpa quote sesudah instruksi.
    Then Fee sesuai rumus dan snapshot konfigurasi uji; total gateway/UI cocok subtotal+fee.
    And Fee detail order sama dengan fee instruksi pada order yang sama; keterangan subtotal dibaca sebelum membandingkan total.

  Scenario: SCN-0006: Pembelian baru DANA dan konsistensi biaya sebelum pemulihan
    Given akun dan prasyarat tersedia
    When Baca nilai Finance aktual, ubah Jumlah dan Processing Fee, baca ulang nilai tersimpan.
    And Buat satu order baru; ekstrak harga/pass/subtotal aktual. Pilih metode lewat UI sampai instruksi, tanpa pelunasan jika dummy belum dikonfirmasi.
    And Catat respons gateway, UI pembayaran, daftar order dan fee card detail tanpa menimpa quote sesudah instruksi.
    Then Fee sesuai rumus dan snapshot konfigurasi uji; total gateway/UI cocok subtotal+fee.
    And Fee detail order sama dengan fee instruksi pada order yang sama; keterangan subtotal dibaca sebelum membandingkan total.

  Scenario: SCN-0007: Pembelian baru Alfamart dan konsistensi biaya sebelum pemulihan
    Given akun dan prasyarat tersedia
    When Baca nilai Finance aktual, ubah Jumlah dan Processing Fee, baca ulang nilai tersimpan.
    And Buat satu order baru; ekstrak harga/pass/subtotal aktual. Pilih metode lewat UI sampai instruksi, tanpa pelunasan jika dummy belum dikonfirmasi.
    And Catat respons gateway, UI pembayaran, daftar order dan fee card detail tanpa menimpa quote sesudah instruksi.
    Then Fee sesuai rumus dan snapshot konfigurasi uji; total gateway/UI cocok subtotal+fee.
    And Fee detail order sama dengan fee instruksi pada order yang sama; keterangan subtotal dibaca sebelum membandingkan total.

  Scenario: SCN-0008: Pembelian baru Indomaret dan konsistensi biaya sebelum pemulihan
    Given akun dan prasyarat tersedia
    When Baca nilai Finance aktual, ubah Jumlah dan Processing Fee, baca ulang nilai tersimpan.
    And Buat satu order baru; ekstrak harga/pass/subtotal aktual. Pilih metode lewat UI sampai instruksi, tanpa pelunasan jika dummy belum dikonfirmasi.
    And Catat respons gateway, UI pembayaran, daftar order dan fee card detail tanpa menimpa quote sesudah instruksi.
    Then Fee sesuai rumus dan snapshot konfigurasi uji; total gateway/UI cocok subtotal+fee.
    And Fee detail order sama dengan fee instruksi pada order yang sama; keterangan subtotal dibaca sebelum membandingkan total.

  Scenario: SCN-0009: Pembelian baru QRIS dan konsistensi biaya sebelum pemulihan
    Given akun dan prasyarat tersedia
    When Baca nilai Finance aktual, ubah Jumlah dan Processing Fee, baca ulang nilai tersimpan.
    And Buat satu order baru; ekstrak harga/pass/subtotal aktual. Pilih metode lewat UI sampai instruksi, tanpa pelunasan jika dummy belum dikonfirmasi.
    And Catat respons gateway, UI pembayaran, daftar order dan fee card detail tanpa menimpa quote sesudah instruksi.
    Then Fee sesuai rumus dan snapshot konfigurasi uji; total gateway/UI cocok subtotal+fee.
    And Fee detail order sama dengan fee instruksi pada order yang sama; keterangan subtotal dibaca sebelum membandingkan total.

  Scenario: SCN-0010: Nilai daftar dan detail order baru User Umum
    Given akun dan prasyarat tersedia
    When Cari semua kode order run pada daftar order; baca label dan nominal.
    And Buka detail dari tautan aktual bila tersedia; cocokkan komponen yang sama dengan snapshot order.
    Then Nominal yang memiliki definisi sama konsisten; kolom tidak tampil dicatat eksplisit dan tidak ditebak.

  Scenario: SCN-0011: Nilai daftar dan detail order baru Admin Prahu
    Given akun dan prasyarat tersedia
    When Cari semua kode order run pada daftar order; baca label dan nominal.
    And Buka detail dari tautan aktual bila tersedia; cocokkan komponen yang sama dengan snapshot order.
    Then Nominal yang memiliki definisi sama konsisten; kolom tidak tampil dicatat eksplisit dan tidak ditebak.

  Scenario: SCN-0012: Nilai daftar dan detail order baru Operator Pusat
    Given akun dan prasyarat tersedia
    When Cari semua kode order run pada daftar order; baca label dan nominal.
    And Buka detail dari tautan aktual bila tersedia; cocokkan komponen yang sama dengan snapshot order.
    Then Nominal yang memiliki definisi sama konsisten; kolom tidak tampil dicatat eksplisit dan tidak ditebak.

  Scenario: SCN-0013: Nilai daftar dan detail order baru Operator Cabang
    Given akun dan prasyarat tersedia
    When Cari semua kode order run pada daftar order; baca label dan nominal.
    And Buka detail dari tautan aktual bila tersedia; cocokkan komponen yang sama dengan snapshot order.
    Then Nominal yang memiliki definisi sama konsisten; kolom tidak tampil dicatat eksplisit dan tidak ditebak.

  Scenario: SCN-0014: Rekonsiliasi laporan Penjualan Harian
    Given akun dan prasyarat tersedia
    When Buka laporan dari tiga role dan catat header, periode serta kontribusi kode/jadwal run.
    And Bandingkan nilai yang memang memiliki definisi sama; gunakan detail laporan untuk mengidentifikasi kode order.
    Then Kontribusi aktual order cocok dengan komponen/saldo/status yang teramati.
    And Tanpa transaksi relevan/lunas atau kolom yang dapat dibandingkan, beri blocked beserta bukti.

  Scenario: SCN-0015: Rekonsiliasi laporan Pendapatan Penumpang
    Given akun dan prasyarat tersedia
    When Buka laporan dari tiga role dan catat header, periode serta kontribusi kode/jadwal run.
    And Bandingkan nilai yang memang memiliki definisi sama; gunakan detail laporan untuk mengidentifikasi kode order.
    Then Kontribusi aktual order cocok dengan komponen/saldo/status yang teramati.
    And Tanpa transaksi relevan/lunas atau kolom yang dapat dibandingkan, beri blocked beserta bukti.

  Scenario: SCN-0016: Rekonsiliasi laporan Pendapatan Kendaraan
    Given akun dan prasyarat tersedia
    When Buka laporan dari tiga role dan catat header, periode serta kontribusi kode/jadwal run.
    And Bandingkan nilai yang memang memiliki definisi sama; gunakan detail laporan untuk mengidentifikasi kode order.
    Then Kontribusi aktual order cocok dengan komponen/saldo/status yang teramati.
    And Tanpa transaksi relevan/lunas atau kolom yang dapat dibandingkan, beri blocked beserta bukti.

  Scenario: SCN-0017: Rekonsiliasi laporan Rekap Pendapatan Per Trip
    Given akun dan prasyarat tersedia
    When Buka laporan dari tiga role dan catat header, periode serta kontribusi kode/jadwal run.
    And Bandingkan nilai yang memang memiliki definisi sama; gunakan detail laporan untuk mengidentifikasi kode order.
    Then Kontribusi aktual order cocok dengan komponen/saldo/status yang teramati.
    And Tanpa transaksi relevan/lunas atau kolom yang dapat dibandingkan, beri blocked beserta bukti.

  Scenario: SCN-0018: Rekonsiliasi laporan Pembatalan Tiket
    Given akun dan prasyarat tersedia
    When Buka laporan dari tiga role dan catat header, periode serta kontribusi kode/jadwal run.
    And Bandingkan nilai yang memang memiliki definisi sama; gunakan detail laporan untuk mengidentifikasi kode order.
    Then Kontribusi aktual order cocok dengan komponen/saldo/status yang teramati.
    And Tanpa transaksi relevan/lunas atau kolom yang dapat dibandingkan, beri blocked beserta bukti.

  Scenario: SCN-0019: Rekonsiliasi laporan Rekap Asuransi
    Given akun dan prasyarat tersedia
    When Buka laporan dari tiga role dan catat header, periode serta kontribusi kode/jadwal run.
    And Bandingkan nilai yang memang memiliki definisi sama; gunakan detail laporan untuk mengidentifikasi kode order.
    Then Kontribusi aktual order cocok dengan komponen/saldo/status yang teramati.
    And Tanpa transaksi relevan/lunas atau kolom yang dapat dibandingkan, beri blocked beserta bukti.

  Scenario: SCN-0020: Rekonsiliasi laporan Pemakaian Saldo
    Given akun dan prasyarat tersedia
    When Buka laporan dari tiga role dan catat header, periode serta kontribusi kode/jadwal run.
    And Bandingkan nilai yang memang memiliki definisi sama; gunakan detail laporan untuk mengidentifikasi kode order.
    Then Kontribusi aktual order cocok dengan komponen/saldo/status yang teramati.
    And Tanpa transaksi relevan/lunas atau kolom yang dapat dibandingkan, beri blocked beserta bukti.

  Scenario: SCN-0021: Rekonsiliasi laporan Penjualan Harian Agen
    Given akun dan prasyarat tersedia
    When Buka laporan dari tiga role dan catat header, periode serta kontribusi kode/jadwal run.
    And Bandingkan nilai yang memang memiliki definisi sama; gunakan detail laporan untuk mengidentifikasi kode order.
    Then Kontribusi aktual order cocok dengan komponen/saldo/status yang teramati.
    And Tanpa transaksi relevan/lunas atau kolom yang dapat dibandingkan, beri blocked beserta bukti.

  Scenario: SCN-0022: Rekonsiliasi laporan Rekap Penjualan Agen
    Given akun dan prasyarat tersedia
    When Buka laporan dari tiga role dan catat header, periode serta kontribusi kode/jadwal run.
    And Bandingkan nilai yang memang memiliki definisi sama; gunakan detail laporan untuk mengidentifikasi kode order.
    Then Kontribusi aktual order cocok dengan komponen/saldo/status yang teramati.
    And Tanpa transaksi relevan/lunas atau kolom yang dapat dibandingkan, beri blocked beserta bukti.

  Scenario: SCN-0023: Rekonsiliasi laporan Pembatalan Tiket Agen
    Given akun dan prasyarat tersedia
    When Buka laporan dari tiga role dan catat header, periode serta kontribusi kode/jadwal run.
    And Bandingkan nilai yang memang memiliki definisi sama; gunakan detail laporan untuk mengidentifikasi kode order.
    Then Kontribusi aktual order cocok dengan komponen/saldo/status yang teramati.
    And Tanpa transaksi relevan/lunas atau kolom yang dapat dibandingkan, beri blocked beserta bukti.

  Scenario: SCN-0024: Snapshot dan pemulihan Finance serta pencatatan booking
    Given akun dan prasyarat tersedia
    When Ambil snapshot fresh semua12 channel.
    And Pulihkan perubahan; baca ulang seluruh nilai dan catat kode/jadwal/status cleanup semua order run.
    Then Konfigurasi kembali identik snapshot fresh, tanpa menimpa artefak run lama.

  Scenario: SCN-0025: Konsistensi invoice pending setelah pemulihan
    Given akun dan prasyarat tersedia
    When Setelah konfigurasi pulih, buka ulang detail dan payment order run yang sama.
    Then Fee/total order tetap konsisten dengan snapshot instruksi yang diterbitkan.

  Scenario: SCN-0026: Potongan saldo order baru
    Given akun dan prasyarat tersedia
    When Baca transaksi per kode pada ledger dan laporan Pemakaian Saldo.
    Then Debit/kredit order yang sama cocok pada ledger dan laporan; jangan mengatribusikan transaksi lain ke run.
