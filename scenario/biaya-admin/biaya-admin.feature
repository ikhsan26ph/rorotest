Feature: Perhitungan biaya admin dan rekonsiliasi transaksi

  Scenario: SCN-0001: Snapshot konfigurasi awal Finance
    Given akun dan prasyarat skenario tersedia
    When Baca semua channel, Jumlah, Processing Fee dan Limit; simpan nilai awal sebelum mengubah.
    Then Snapshot lengkap tanpa kredensial; konfigurasi dapat dipulihkan.

  Scenario: SCN-0002: Perhitungan biaya admin Bank BNI sebelum dan sesudah perubahan
    Given akun dan prasyarat skenario tersedia
    When Pastikan Bank BNI tampil di user umum.
    And Ubah Jumlah dan Processing Fee channel terkait; pertahankan tipe persen OVO/DANA/QRIS dan Limit.
    And Gunakan harga dan tarif pass order uji; cocokkan fee dari aplikasi dengan rumus independen.
    And Periksa quote backend dan renderer showva bawaan aplikasi; cocokkan biaya serta total ringkasan. Instruksi gateway aktual diuji dalam skenario terpisah.
    Then OVO/DANA/QRIS: fee=(harga+tarif pass)*Jumlah/100+Processing Fee.
    And Channel flat: fee=Jumlah+Processing Fee.
    And Total pembayaran=harga+tarif pass+fee, dengan komponen lain dicatat terpisah.

  Scenario: SCN-0003: Perhitungan biaya admin Bank BRI sebelum dan sesudah perubahan
    Given akun dan prasyarat skenario tersedia
    When Pastikan Bank BRI tampil di user umum.
    And Ubah Jumlah dan Processing Fee channel terkait; pertahankan tipe persen OVO/DANA/QRIS dan Limit.
    And Gunakan harga dan tarif pass order uji; cocokkan fee dari aplikasi dengan rumus independen.
    And Periksa quote backend dan renderer showva bawaan aplikasi; cocokkan biaya serta total ringkasan. Instruksi gateway aktual diuji dalam skenario terpisah.
    Then OVO/DANA/QRIS: fee=(harga+tarif pass)*Jumlah/100+Processing Fee.
    And Channel flat: fee=Jumlah+Processing Fee.
    And Total pembayaran=harga+tarif pass+fee, dengan komponen lain dicatat terpisah.

  Scenario: SCN-0004: Perhitungan biaya admin Bank Mandiri sebelum dan sesudah perubahan
    Given akun dan prasyarat skenario tersedia
    When Pastikan Bank Mandiri tampil di user umum.
    And Ubah Jumlah dan Processing Fee channel terkait; pertahankan tipe persen OVO/DANA/QRIS dan Limit.
    And Gunakan harga dan tarif pass order uji; cocokkan fee dari aplikasi dengan rumus independen.
    And Periksa quote backend dan renderer showva bawaan aplikasi; cocokkan biaya serta total ringkasan. Instruksi gateway aktual diuji dalam skenario terpisah.
    Then OVO/DANA/QRIS: fee=(harga+tarif pass)*Jumlah/100+Processing Fee.
    And Channel flat: fee=Jumlah+Processing Fee.
    And Total pembayaran=harga+tarif pass+fee, dengan komponen lain dicatat terpisah.

  Scenario: SCN-0005: Perhitungan biaya admin Bank BCA sebelum dan sesudah perubahan
    Given akun dan prasyarat skenario tersedia
    When Pastikan Bank BCA tampil di user umum.
    And Ubah Jumlah dan Processing Fee channel terkait; pertahankan tipe persen OVO/DANA/QRIS dan Limit.
    And Gunakan harga dan tarif pass order uji; cocokkan fee dari aplikasi dengan rumus independen.
    And Periksa quote backend dan renderer showva bawaan aplikasi; cocokkan biaya serta total ringkasan. Instruksi gateway aktual diuji dalam skenario terpisah.
    Then OVO/DANA/QRIS: fee=(harga+tarif pass)*Jumlah/100+Processing Fee.
    And Channel flat: fee=Jumlah+Processing Fee.
    And Total pembayaran=harga+tarif pass+fee, dengan komponen lain dicatat terpisah.

  Scenario: SCN-0006: Perhitungan biaya admin Alfamart sebelum dan sesudah perubahan
    Given akun dan prasyarat skenario tersedia
    When Pastikan Alfamart tampil di user umum.
    And Ubah Jumlah dan Processing Fee channel terkait; pertahankan tipe persen OVO/DANA/QRIS dan Limit.
    And Gunakan harga dan tarif pass order uji; cocokkan fee dari aplikasi dengan rumus independen.
    And Periksa quote backend dan renderer showva bawaan aplikasi; cocokkan biaya serta total ringkasan. Instruksi gateway aktual diuji dalam skenario terpisah.
    Then OVO/DANA/QRIS: fee=(harga+tarif pass)*Jumlah/100+Processing Fee.
    And Channel flat: fee=Jumlah+Processing Fee.
    And Total pembayaran=harga+tarif pass+fee, dengan komponen lain dicatat terpisah.

  Scenario: SCN-0007: Perhitungan biaya admin OVO sebelum dan sesudah perubahan
    Given akun dan prasyarat skenario tersedia
    When Pastikan OVO tampil di user umum.
    And Ubah Jumlah dan Processing Fee channel terkait; pertahankan tipe persen OVO/DANA/QRIS dan Limit.
    And Gunakan harga dan tarif pass order uji; cocokkan fee dari aplikasi dengan rumus independen.
    And Periksa quote backend dan renderer showva bawaan aplikasi; cocokkan biaya serta total ringkasan. Instruksi gateway aktual diuji dalam skenario terpisah.
    Then OVO/DANA/QRIS: fee=(harga+tarif pass)*Jumlah/100+Processing Fee.
    And Channel flat: fee=Jumlah+Processing Fee.
    And Total pembayaran=harga+tarif pass+fee, dengan komponen lain dicatat terpisah.

  Scenario: SCN-0008: Perhitungan biaya admin DANA sebelum dan sesudah perubahan
    Given akun dan prasyarat skenario tersedia
    When Pastikan DANA tampil di user umum.
    And Ubah Jumlah dan Processing Fee channel terkait; pertahankan tipe persen OVO/DANA/QRIS dan Limit.
    And Gunakan harga dan tarif pass order uji; cocokkan fee dari aplikasi dengan rumus independen.
    And Periksa quote backend dan renderer showva bawaan aplikasi; cocokkan biaya serta total ringkasan. Instruksi gateway aktual diuji dalam skenario terpisah.
    Then OVO/DANA/QRIS: fee=(harga+tarif pass)*Jumlah/100+Processing Fee.
    And Channel flat: fee=Jumlah+Processing Fee.
    And Total pembayaran=harga+tarif pass+fee, dengan komponen lain dicatat terpisah.

  Scenario: SCN-0009: Perhitungan biaya admin QRIS sebelum dan sesudah perubahan
    Given akun dan prasyarat skenario tersedia
    When Pastikan QRIS tampil di user umum.
    And Ubah Jumlah dan Processing Fee channel terkait; pertahankan tipe persen OVO/DANA/QRIS dan Limit.
    And Gunakan harga dan tarif pass order uji; cocokkan fee dari aplikasi dengan rumus independen.
    And Periksa quote backend dan renderer showva bawaan aplikasi; cocokkan biaya serta total ringkasan. Instruksi gateway aktual diuji dalam skenario terpisah.
    Then OVO/DANA/QRIS: fee=(harga+tarif pass)*Jumlah/100+Processing Fee.
    And Channel flat: fee=Jumlah+Processing Fee.
    And Total pembayaran=harga+tarif pass+fee, dengan komponen lain dicatat terpisah.

  Scenario: SCN-0010: Perhitungan biaya admin Indomaret sebelum dan sesudah perubahan
    Given akun dan prasyarat skenario tersedia
    When Pastikan Indomaret tampil di user umum.
    And Ubah Jumlah dan Processing Fee channel terkait; pertahankan tipe persen OVO/DANA/QRIS dan Limit.
    And Gunakan harga dan tarif pass order uji; cocokkan fee dari aplikasi dengan rumus independen.
    And Periksa quote backend dan renderer showva bawaan aplikasi; cocokkan biaya serta total ringkasan. Instruksi gateway aktual diuji dalam skenario terpisah.
    Then OVO/DANA/QRIS: fee=(harga+tarif pass)*Jumlah/100+Processing Fee.
    And Channel flat: fee=Jumlah+Processing Fee.
    And Total pembayaran=harga+tarif pass+fee, dengan komponen lain dicatat terpisah.

  Scenario: SCN-0011: Buka seluruh halaman menu User Umum dan telusuri biaya order uji
    Given akun dan prasyarat skenario tersedia
    When Login sebagai User Umum; buka seluruh halaman menu dan filter read-only.
    And Telusuri order uji di halaman yang berwenang; cocokan nilai harga/pass/fee/total.
    Then Hasil akses halaman dilaporkan terpisah dari validasi hitungan.
    And Hitungan dinyatakan passed hanya jika order uji dan komponen nilainya dapat dicocokkan; tanpa bukti diberi blocked.

  Scenario: SCN-0012: Buka seluruh halaman menu Admin Prahu dan telusuri biaya order uji
    Given akun dan prasyarat skenario tersedia
    When Login sebagai Admin Prahu; buka seluruh halaman menu dan filter read-only.
    And Telusuri order uji di halaman yang berwenang; cocokan nilai harga/pass/fee/total.
    Then Hasil akses halaman dilaporkan terpisah dari validasi hitungan.
    And Hitungan dinyatakan passed hanya jika order uji dan komponen nilainya dapat dicocokkan; tanpa bukti diberi blocked.

  Scenario: SCN-0013: Buka seluruh halaman menu Operator Pusat dan telusuri biaya order uji
    Given akun dan prasyarat skenario tersedia
    When Login sebagai Operator Pusat; buka seluruh halaman menu dan filter read-only.
    And Telusuri order uji di halaman yang berwenang; cocokan nilai harga/pass/fee/total.
    Then Hasil akses halaman dilaporkan terpisah dari validasi hitungan.
    And Hitungan dinyatakan passed hanya jika order uji dan komponen nilainya dapat dicocokkan; tanpa bukti diberi blocked.

  Scenario: SCN-0014: Buka seluruh halaman menu Operator Cabang dan telusuri biaya order uji
    Given akun dan prasyarat skenario tersedia
    When Login sebagai Operator Cabang; buka seluruh halaman menu dan filter read-only.
    And Telusuri order uji di halaman yang berwenang; cocokan nilai harga/pass/fee/total.
    Then Hasil akses halaman dilaporkan terpisah dari validasi hitungan.
    And Hitungan dinyatakan passed hanya jika order uji dan komponen nilainya dapat dicocokkan; tanpa bukti diberi blocked.

  Scenario: SCN-0015: Rekonsiliasi laporan Penjualan Harian
    Given akun dan prasyarat skenario tersedia
    When Buka laporan dari role yang berwenang dan filter periode order uji.
    And Cari kontribusi order uji dan bandingkan dengan komponen order serta status pembayarannya.
    And Pemakaian Saldo dapat diverifikasi setelah instruksi/debit awal; laporan yang memerlukan pelunasan menunggu konfirmasi dummy.
    Then Nilai pendapatan/fee/saldo konsisten dengan definisi kolom; opening halaman tidak dianggap bukti perhitungan.
    And Laporan yang memerlukan transaksi agen/asuransi/pembatalan diberi blocked jika prasyarat tidak tersedia; tidak menyentuh order milik pihak lain.

  Scenario: SCN-0016: Rekonsiliasi laporan Pendapatan Penumpang
    Given akun dan prasyarat skenario tersedia
    When Buka laporan dari role yang berwenang dan filter periode order uji.
    And Cari kontribusi order uji dan bandingkan dengan komponen order serta status pembayarannya.
    And Pemakaian Saldo dapat diverifikasi setelah instruksi/debit awal; laporan yang memerlukan pelunasan menunggu konfirmasi dummy.
    Then Nilai pendapatan/fee/saldo konsisten dengan definisi kolom; opening halaman tidak dianggap bukti perhitungan.
    And Laporan yang memerlukan transaksi agen/asuransi/pembatalan diberi blocked jika prasyarat tidak tersedia; tidak menyentuh order milik pihak lain.

  Scenario: SCN-0017: Rekonsiliasi laporan Pendapatan Kendaraan
    Given akun dan prasyarat skenario tersedia
    When Buka laporan dari role yang berwenang dan filter periode order uji.
    And Cari kontribusi order uji dan bandingkan dengan komponen order serta status pembayarannya.
    And Pemakaian Saldo dapat diverifikasi setelah instruksi/debit awal; laporan yang memerlukan pelunasan menunggu konfirmasi dummy.
    Then Nilai pendapatan/fee/saldo konsisten dengan definisi kolom; opening halaman tidak dianggap bukti perhitungan.
    And Laporan yang memerlukan transaksi agen/asuransi/pembatalan diberi blocked jika prasyarat tidak tersedia; tidak menyentuh order milik pihak lain.

  Scenario: SCN-0018: Rekonsiliasi laporan Rekap Pendapatan Per Trip
    Given akun dan prasyarat skenario tersedia
    When Buka laporan dari role yang berwenang dan filter periode order uji.
    And Cari kontribusi order uji dan bandingkan dengan komponen order serta status pembayarannya.
    And Pemakaian Saldo dapat diverifikasi setelah instruksi/debit awal; laporan yang memerlukan pelunasan menunggu konfirmasi dummy.
    Then Nilai pendapatan/fee/saldo konsisten dengan definisi kolom; opening halaman tidak dianggap bukti perhitungan.
    And Laporan yang memerlukan transaksi agen/asuransi/pembatalan diberi blocked jika prasyarat tidak tersedia; tidak menyentuh order milik pihak lain.

  Scenario: SCN-0019: Rekonsiliasi laporan Pembatalan Tiket
    Given akun dan prasyarat skenario tersedia
    When Buka laporan dari role yang berwenang dan filter periode order uji.
    And Cari kontribusi order uji dan bandingkan dengan komponen order serta status pembayarannya.
    And Pemakaian Saldo dapat diverifikasi setelah instruksi/debit awal; laporan yang memerlukan pelunasan menunggu konfirmasi dummy.
    Then Nilai pendapatan/fee/saldo konsisten dengan definisi kolom; opening halaman tidak dianggap bukti perhitungan.
    And Laporan yang memerlukan transaksi agen/asuransi/pembatalan diberi blocked jika prasyarat tidak tersedia; tidak menyentuh order milik pihak lain.

  Scenario: SCN-0020: Rekonsiliasi laporan Rekap Asuransi
    Given akun dan prasyarat skenario tersedia
    When Buka laporan dari role yang berwenang dan filter periode order uji.
    And Cari kontribusi order uji dan bandingkan dengan komponen order serta status pembayarannya.
    And Pemakaian Saldo dapat diverifikasi setelah instruksi/debit awal; laporan yang memerlukan pelunasan menunggu konfirmasi dummy.
    Then Nilai pendapatan/fee/saldo konsisten dengan definisi kolom; opening halaman tidak dianggap bukti perhitungan.
    And Laporan yang memerlukan transaksi agen/asuransi/pembatalan diberi blocked jika prasyarat tidak tersedia; tidak menyentuh order milik pihak lain.

  Scenario: SCN-0021: Rekonsiliasi laporan Pemakaian Saldo
    Given akun dan prasyarat skenario tersedia
    When Buka laporan dari role yang berwenang dan filter periode order uji.
    And Cari kontribusi order uji dan bandingkan dengan komponen order serta status pembayarannya.
    And Pemakaian Saldo dapat diverifikasi setelah instruksi/debit awal; laporan yang memerlukan pelunasan menunggu konfirmasi dummy.
    Then Nilai pendapatan/fee/saldo konsisten dengan definisi kolom; opening halaman tidak dianggap bukti perhitungan.
    And Laporan yang memerlukan transaksi agen/asuransi/pembatalan diberi blocked jika prasyarat tidak tersedia; tidak menyentuh order milik pihak lain.

  Scenario: SCN-0022: Rekonsiliasi laporan Penjualan Harian Agen
    Given akun dan prasyarat skenario tersedia
    When Buka laporan dari role yang berwenang dan filter periode order uji.
    And Cari kontribusi order uji dan bandingkan dengan komponen order serta status pembayarannya.
    And Pemakaian Saldo dapat diverifikasi setelah instruksi/debit awal; laporan yang memerlukan pelunasan menunggu konfirmasi dummy.
    Then Nilai pendapatan/fee/saldo konsisten dengan definisi kolom; opening halaman tidak dianggap bukti perhitungan.
    And Laporan yang memerlukan transaksi agen/asuransi/pembatalan diberi blocked jika prasyarat tidak tersedia; tidak menyentuh order milik pihak lain.

  Scenario: SCN-0023: Rekonsiliasi laporan Rekap Penjualan Agen
    Given akun dan prasyarat skenario tersedia
    When Buka laporan dari role yang berwenang dan filter periode order uji.
    And Cari kontribusi order uji dan bandingkan dengan komponen order serta status pembayarannya.
    And Pemakaian Saldo dapat diverifikasi setelah instruksi/debit awal; laporan yang memerlukan pelunasan menunggu konfirmasi dummy.
    Then Nilai pendapatan/fee/saldo konsisten dengan definisi kolom; opening halaman tidak dianggap bukti perhitungan.
    And Laporan yang memerlukan transaksi agen/asuransi/pembatalan diberi blocked jika prasyarat tidak tersedia; tidak menyentuh order milik pihak lain.

  Scenario: SCN-0024: Rekonsiliasi laporan Pembatalan Tiket Agen
    Given akun dan prasyarat skenario tersedia
    When Buka laporan dari role yang berwenang dan filter periode order uji.
    And Cari kontribusi order uji dan bandingkan dengan komponen order serta status pembayarannya.
    And Pemakaian Saldo dapat diverifikasi setelah instruksi/debit awal; laporan yang memerlukan pelunasan menunggu konfirmasi dummy.
    Then Nilai pendapatan/fee/saldo konsisten dengan definisi kolom; opening halaman tidak dianggap bukti perhitungan.
    And Laporan yang memerlukan transaksi agen/asuransi/pembatalan diberi blocked jika prasyarat tidak tersedia; tidak menyentuh order milik pihak lain.

  Scenario: SCN-0025: Rekonsiliasi potongan saldo awal operator untuk User Umum
    Given akun dan prasyarat skenario tersedia
    When Catat saldo awal dan riwayat.
    And Pada order uji, pilih metode sampai instruksi bayar untuk mencatat debit awal saldo operator. Pelunasan pembayaran dan penggunaan saldo sebagai pembayaran akhir hanya jika dikonfirmasi dummy.
    Then Delta saldo awal cocok dengan debit tujuh instruksi berhasil dan komisi tiket tanpa pass dibulatkan ke atas.
    And Metode gagal tidak menambah debit; pelunasan, refund dan penggunaan saldo akhir dibedakan dari debit awal.

  Scenario: SCN-0026: Pemulihan konfigurasi Finance dan pembersihan booking
    Given akun dan prasyarat skenario tersedia
    When Pulihkan semua Jumlah, Processing Fee dan Limit ke snapshot awal; baca ulang.
    And Catat kode booking/jadwal setiap order yang dibuat; batalkan order belum dibayar jika fitur tersedia.
    Then Seluruh konfigurasi identik snapshot awal.
    And Semua booking run tercatat dan status pembersihannya dijelaskan.

  Scenario: SCN-0027: Instruksi gateway seluruh metode dengan fee yang diubah
    Given akun dan prasyarat skenario tersedia
    When Gunakan izin eksplisit pengguna untuk pengujian fee dan potongan saldo. Pilih metode sampai instruksi bayar; jangan selesaikan pembayaran atau otorisasi wallet tanpa konfirmasi dummy.
    And Ubah fee tiap channel, pilih metode melalui UI biasa, cocokkan quote/instruksi/nominal gateway jika tersedia dan debit awal ledger, lalu pulihkan.
    Then Nominal gateway dan total ringkasan sama dengan subtotal+fee.
    And Semua metode aktual dievaluasi terpisah dari quote; error gateway dicatat dengan screenshot.

  Scenario: SCN-0028: Aritmetika saldo pada riwayat transaksi historis
    Given akun dan prasyarat skenario tersedia
    When Baca 20 transaksi terakhir pada Riwayat Saldo operator tanpa mengubah transaksi.
    And Untuk setiap pasangan berurutan, hitung saldo setelah transaksi lebih lama + debit/kredit transaksi lebih baru.
    Then Seluruh 19 transisi yang dapat dicocokkan sama dengan sisa saldo ditampilkan.
    And Hasil ini tidak dianggap bukti debit order baru atau pengaruh Processing Fee.

  Scenario: SCN-0029: Konsistensi invoice pending setelah konfigurasi Finance dipulihkan
    Given akun dan prasyarat skenario tersedia
    When Buat instruksi bayar dengan konfigurasi uji; catat amount gateway.
    And Pulihkan konfigurasi lalu buka ulang halaman bayar order yang sama tanpa pelunasan.
    Then Total invoice pending tetap konsisten dengan nominal instruksi gateway yang diterbitkan.

  Scenario: SCN-0030: Pemulihan pemilihan metode setelah gateway gagal
    Given akun dan prasyarat skenario tersedia
    When Setelah metode gagal menghasilkan instruksi, pilih alternatif pada order uji yang sama.
    And Bandingkan dengan metode alternatif pada order uji baru.
    Then Order gagal dapat memilih metode lain tanpa terkunci DOUBLE_VA.
