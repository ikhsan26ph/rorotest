Feature: Pembatasan order User Umum dan pengaturan kontak cabang — RO320

  # Bahasa keyword Gherkin: English; isi scenario: Indonesia.
  # preconditions/testData direalisasikan melalui fixture TMS; URL dan testid adalah usulan.
  # Nilai expect berupa oracle semantik, kecuali pesan yang dinyatakan persis.

  @positive @priority-high @REQ-001 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-001 — Transaksi Kantor Cabang tetap dapat dibuat ketika kuota publik penuh
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Kantor Cabang, channel kantor cabang; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Transaksi Kantor Cabang berhasil tanpa validasi batas User Umum; C publik tetap 2." pada elemen "isi-data / Kuota Rute"

  @positive @priority-high @REQ-001 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-002 — Transaksi Agen tetap dapat dibuat ketika kuota publik penuh
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Agen, channel agen; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Transaksi Agen berhasil tanpa validasi batas User Umum; C publik tetap 2." pada elemen "isi-data / Kuota Rute"

  @negative @priority-high @REQ-001 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-001 — User Umum tidak dapat menyamar sebagai channel Agen melalui request
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Request order publik diintersepsi dan field channel diganti Agen; sesi tetap User Umum."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    Then sistem menampilkan "Permintaan manipulasi ditolak; tidak ada order baru" pada elemen "cari-jadwal / Pesan Batas"

  @positive @priority-high @REQ-002 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-003 — Kuota user lain tidak membatasi user yang berbeda
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "U-B telah memiliki C=2 pada R-BPN-PAP; U-A masih C=0."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Order baru masuk Isi Data dan tepat satu reservasi ditambahkan." pada elemen "isi-data / Kuota Rute"

  @positive @priority-high @REQ-002 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-004 — Kuota penuh pada satu rute tidak memblokir rute lain
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute SBY → KPG; C=0, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "U-A penuh di R-BPN-PAP; rute sekarang R-SBY-KPG mempunyai C=0."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Order baru masuk Isi Data dan tepat satu reservasi ditambahkan." pada elemen "isi-data / Kuota Rute"

  @negative @priority-high @REQ-002 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-002 — Mengganti jadwal kapal pada trayek yang sama tidak melewati batas
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal alternatif memiliki ID berbeda namun ID rute kanonik tetap R-BPN-PAP."
    Then sistem menampilkan "disabled karena kuota penuh" pada elemen "cari-jadwal / Pilih"
    And sistem menampilkan "Order baru ditolak; tidak masuk Isi Data, tidak membuat order/reservasi baru; pesan batas tampil." pada elemen "cari-jadwal / Pesan Batas"

  @negative @priority-high @REQ-002 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-003 — ID user lain pada request tidak melewati kuota pemilik sesi
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Harness mengirim request order dengan userId U-B; sesi autentik tetap U-A yang penuh."
    Then sistem menampilkan "Request userId palsu ditolak; kuota U-A tetap penuh" pada elemen "cari-jadwal / Pesan Batas"

  @positive @priority-high @REQ-003 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-005 — Pembelian arah pulang tersedia ketika arah pergi sudah penuh
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute PAP → BPN; C=0, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Pergi BPN → PAP C=2; arah sekarang PAP → BPN C=0."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Order baru masuk Isi Data dan tepat satu reservasi ditambahkan." pada elemen "isi-data / Kuota Rute"

  @positive @priority-high @REQ-003 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-006 — Pulang pergi memakai satu slot pada masing-masing arah
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Fixture memiliki reservasi pulang PAP → BPN dan akan membuat pergi BPN → PAP."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Reservasi pergi bertambah satu; reservasi pulang tetap satu; tidak dijumlahkan ke satu rute." pada elemen "isi-data / Kuota Rute"

  @negative @priority-high @REQ-003 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-004 — Arah pergi yang penuh tidak lolos karena arah pulang masih kosong
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "PAP → BPN masih kosong; permintaan saat ini BPN → PAP."
    Then sistem menampilkan "disabled karena kuota penuh" pada elemen "cari-jadwal / Pilih"
    And sistem menampilkan "Order baru ditolak; tidak masuk Isi Data, tidak membuat order/reservasi baru; pesan batas tampil." pada elemen "cari-jadwal / Pesan Batas"

  @positive @priority-high @REQ-004 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-007 — Default dua mengizinkan order kedua pada rute yang sama
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=1, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Order baru masuk Isi Data dan tepat satu reservasi ditambahkan." pada elemen "isi-data / Kuota Rute"

  @negative @priority-high @REQ-004 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-005 — Default dua menolak order ketiga pada rute yang sama
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    Then sistem menampilkan "disabled karena kuota penuh" pada elemen "cari-jadwal / Pilih"
    And sistem menampilkan "Order baru ditolak; tidak masuk Isi Data, tidak membuat order/reservasi baru; pesan batas tampil." pada elemen "cari-jadwal / Pesan Batas"

  @positive @priority-high @REQ-004 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-008 — Batas tiga yang disimpan menggantikan default dua
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user mengisi field "batas-order / Batas Order Selesai per Rute" dengan "3"
    And user mengklik tombol atau link "batas-order / Simpan Pengaturan"
    Then sistem menampilkan "Menampilkan selisih nilai lama dan nilai baru" pada elemen "konfirmasi-pengaturan / Ringkasan Perubahan"
    When user mengklik tombol atau link "konfirmasi-pengaturan / Simpan"
    Then sistem menampilkan "Setting menjadi 3; user dengan C=2,R=0 boleh reservasi order ketiga; setelah total mencapai 3 order berikutnya ditolak." pada elemen "batas-order / Simpan Pengaturan"

  @positive @priority-high @REQ-005 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-009 — Pembayaran hari kemarin tidak dihitung meskipun kurang dari 24 jam
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-08T00:01:00+07:00."
    And kondisi uji "Dua order dibayar 07/10/2026 23:59 WIB; jam sekarang 08/10/2026 00:01 WIB."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Order baru masuk Isi Data dan tepat satu reservasi ditambahkan." pada elemen "isi-data / Kuota Rute"

  @negative @priority-high @REQ-005 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-006 — Mengubah jam perangkat atau tanggal keberangkatan tidak mereset kuota
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Klien memakai 09/10/2026; server tetap 08/10/2026; tanggal berangkat bulan berikutnya."
    When user mengklik tombol atau link "cari-jadwal / Ubah Pencarian"
    And user mengisi field "cari-jadwal / Tanggal Berangkat" dengan "2026-11-08"
    Then sistem menampilkan "disabled; kuota tetap dihitung dari hari WIB server" pada elemen "cari-jadwal / Pilih"
    And sistem menampilkan "Batas tetap tercapai meskipun tanggal keberangkatan berubah" pada elemen "cari-jadwal / Pesan Batas"

  @positive @priority-high @REQ-006 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-010 — Satu pending tidak menambah penghitung selesai dan masih menyisakan satu slot
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=1; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "C tetap 0; R berubah dari 1 ke 2; order kedua diterima tanpa dianggap sudah dibayar." pada elemen "isi-data / Kuota Rute"

  @negative @priority-high @REQ-006 @screen-detail-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-007 — Pembayaran gagal tidak mengubah order menjadi selesai
    Given user berada di halaman "Detail Order"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=1; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Order O-1 Menunggu Pembayaran dengan reservasi sah; gateway mengembalikan kegagalan."
    When user mengklik tombol atau link "detail-order / Bayar Sekarang"
    Then sistem menampilkan "Tetap Menunggu Pembayaran; C=0,R=1; tiket belum terbit" pada elemen "detail-order / Status Order"

  @positive @priority-high @REQ-006 @screen-detail-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-011 — Pembayaran sukses mengganti reservasi menjadi kuota selesai tepat sekali
    Given user berada di halaman "Detail Order"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=1; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "O-1 memiliki reservasi sah."
    When user mengklik tombol atau link "detail-order / Bayar Sekarang"
    Then sistem menampilkan "Order Selesai; C=1,R=0; total slot terpakai tetap 1" pada elemen "detail-order / Status Order"

  @positive @priority-high @REQ-007 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-012 — Order rombongan sepuluh tiket hanya menggunakan satu slot
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "10"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "10 tiket dalam satu order; satu reservasi, bukan sepuluh" pada elemen "isi-data / Ringkasan Order"

  @negative @priority-high @REQ-007 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-008 — Dua order masing-masing satu tiket tetap menghabiskan batas dua
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "O-1 dan O-2 masing-masing hanya satu penumpang."
    Then sistem menampilkan "disabled karena kuota penuh" pada elemen "cari-jadwal / Pilih"
    And sistem menampilkan "Order baru ditolak; tidak masuk Isi Data, tidak membuat order/reservasi baru; pesan batas tampil." pada elemen "cari-jadwal / Pesan Batas"

  @positive @priority-high @REQ-008 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-013 — Kuota hari sama kembali setelah order selesai menjadi Dibatalkan
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=1, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Semula C=2; O-2 dibayar hari ini dan kini efektif Dibatalkan."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "C menjadi 1 setelah pembatalan/refund efektif; order pengganti dapat dibuat." pada elemen "isi-data / Kuota Rute"

  @positive @priority-high @REQ-008 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-014 — Kuota hari sama kembali setelah order selesai menjadi Refund Selesai
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=1, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Semula C=2; O-2 dibayar hari ini dan kini efektif Refund Selesai."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "C menjadi 1 setelah pembatalan/refund efektif; order pengganti dapat dibuat." pada elemen "isi-data / Kuota Rute"

  @negative @priority-high @REQ-008 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-009 — Order selesai tanpa pembatalan efektif tidak mendapat kuota kembali
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "User baru membuka permintaan refund, belum selesai disetujui; status O-2 masih Selesai."
    Then sistem menampilkan "disabled karena kuota penuh" pada elemen "cari-jadwal / Pilih"
    And sistem menampilkan "C tetap 2; tidak ada kuota kembali hanya karena refund diminta." pada elemen "cari-jadwal / Pesan Batas"

  @positive @priority-high @REQ-009 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-015 — Masuk Isi Data langsung menahan slot sebelum pembayaran
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Timestamp expiry reservasi aktif O-1" pada elemen "isi-data / Kursi ditahan sampai"
    And sistem menampilkan "Sisa satu slot setelah reservasi O-1" pada elemen "isi-data / Kuota Rute"

  @negative @priority-high @REQ-009 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-010 — Tab ketiga ditolak ketika dua tab sudah berada di Isi Data
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=2; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "R=2 berasal dari Isi Data, belum ada order dibayar."
    Then sistem menampilkan "disabled karena kuota penuh" pada elemen "cari-jadwal / Pilih"
    And sistem menampilkan "Order ketiga ditolak; C tetap 0,R tetap 2; tidak harus menunggu status Menunggu Pembayaran." pada elemen "cari-jadwal / Pesan Batas"

  @negative @priority-high @REQ-010 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-011 — Dua Menunggu Pembayaran memblokir order ketiga
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=2; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "O-1 dan O-2 Menunggu Pembayaran, expiry di masa depan."
    Then sistem menampilkan "disabled karena kuota penuh" pada elemen "cari-jadwal / Pilih"
    And sistem menampilkan "Order baru ditolak; tidak masuk Isi Data, tidak membuat order/reservasi baru; pesan batas tampil." pada elemen "cari-jadwal / Pesan Batas"

  @positive @priority-high @REQ-010 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-016 — Expired satu pending membebaskan satu slot untuk order pengganti
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=1; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Semula O-1/O-2 pending; O-1 telah expired efektif, O-2 masih aktif."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Order pengganti diterima; O-1 tetap Expired; R naik dari 1 ke 2, C tetap 0." pada elemen "isi-data / Kuota Rute"

  @positive @priority-high @REQ-011 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-017 — Memilih jadwal memakai data terbaru ketika slot tersedia
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    Then sistem menampilkan "Tabel pilihan tiket tampil karena C+R<L" pada elemen "cari-jadwal / Jumlah Tiket"

  @negative @priority-high @REQ-011 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-012 — Pemilihan jadwal yang baru penuh menolak meskipun badge lama masih sisa
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "UI awal menampilkan C=1; fixture menyelesaikan order dari tab lain sebelum klik Pilih."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    Then sistem menampilkan "Pesan batas dari pembacaan server terbaru, tabel tiket tidak dibuka" pada elemen "cari-jadwal / Pesan Batas"

  @positive @priority-high @REQ-012 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-018 — Next step memakai refund terbaru dan mengizinkan slot yang baru bebas
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=1, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Setelah Pilih sempat lolos pada C=1, tab lain membayar sehingga C=2, lalu refund satu order efektif sebelum Pesan; UI sempat menunjukkan penuh."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Pesan membaca C terbaru 1 setelah refund dan atomik membuat R=1; tidak memakai cache C=2." pada elemen "isi-data / Kuota Rute"

  @negative @priority-high @REQ-012 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-013 — Pesan menolak ketika tab lain memakai slot setelah memilih jadwal
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=1, R=1; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Pilih sudah lolos ketika C=1,R=0; sebelum Pesan, tab B membuat satu reservasi."
    When user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Kuota terbaru penuh; tetap di Cari Jadwal" pada elemen "cari-jadwal / Pesan Batas"

  @positive @priority-high @REQ-013 @screen-detail-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-019 — Pembayaran satu pending tidak membatalkan pending lain yang sah
    Given user berada di halaman "Detail Order"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=2; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "O-1/O-2 sama-sama memiliki reservasi sah; bayar O-1."
    When user mengklik tombol atau link "detail-order / Bayar Sekarang"
    Then sistem menampilkan "O-1 Selesai; O-2 Menunggu Pembayaran, C=1,R=1" pada elemen "detail-order / Status Order"

  @negative @priority-high @REQ-013 @screen-daftar-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-014 — Penolakan order baru tidak mengubah pending lama menjadi Dibatalkan Sistem
    Given user berada di halaman "Daftar Order"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=2; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Permintaan order baru dari tab lain ditolak; O-1/O-2 masih sah."
    When user mengklik tombol atau link "daftar-order / Info Order"
    Then sistem menampilkan "O-1 dan O-2 Menunggu Pembayaran; tidak ada Dibatalkan Sistem karena kuota" pada elemen "daftar-order / Tabel Order"

  @positive @priority-high @REQ-014 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-020 — Pesan default tampil persis saat batas tercapai
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    Then sistem menampilkan "Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat" pada elemen "cari-jadwal / Pesan Batas"
    And sistem menampilkan "disabled" pada elemen "cari-jadwal / Pilih"

  @negative @priority-high @REQ-014 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-015 — Halaman lama tidak memakai pesan default setelah pesan kustom disimpan
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Kantor Pusat baru menyimpan pesan kustom dan halaman user direfresh."
    Then sistem menampilkan "Kuota rute hari ini habis. Hubungi cabang." pada elemen "cari-jadwal / Pesan Batas"

  @positive @priority-high @REQ-015 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-021 — Kontak asal dan tujuan berasal dari rute Surabaya Kupang
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute SBY → KPG; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    When user mengklik tombol atau link "cari-jadwal / Hubungi Kantor Cabang"
    Then sistem menampilkan "Kontak OP-A pelabuhan SBY" pada elemen "hubungi-cabang / Kontak Asal"
    And sistem menampilkan "Kontak OP-A pelabuhan KPG" pada elemen "hubungi-cabang / Kontak Tujuan"

  @negative @priority-high @REQ-015 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-016 — Kontak dari pencarian sebelumnya tidak tertukar setelah rute dibalik
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute PAP → BPN; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Sebelumnya rute BPN→PAP; pencarian sekarang PAP→BPN."
    When user mengklik tombol atau link "cari-jadwal / Ubah Pencarian"
    And user memilih opsi "PAP" pada "cari-jadwal / Kota Asal"
    And user memilih opsi "BPN" pada "cari-jadwal / Kota Tujuan"
    And user mengklik tombol atau link "cari-jadwal / Hubungi Kantor Cabang"
    Then sistem menampilkan "PAP sebagai asal" pada elemen "hubungi-cabang / Kontak Asal"
    And sistem menampilkan "BPN sebagai tujuan" pada elemen "hubungi-cabang / Kontak Tujuan"

  @positive @priority-high @REQ-016 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-022 — Seluruh kombinasi user rute mulai nol selesai pada hari baru
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-09T00:00:00+07:00."
    And kondisi uji "Fixture U-A/U-B dan dua rute masing-masing C=2 kemarin; sekarang 00:00 WIB."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "C hari baru 0 pada semua empat kombinasi; masing-masing dapat membuat order baru." pada elemen "isi-data / Kuota Rute"

  @negative @priority-high @REQ-016 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-017 — Reset hari tidak membuka pembelian sebelum tepat tengah malam
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T23:59:59.999+07:00."
    And kondisi uji "Jam server 08/10/2026 23:59:59.999 WIB."
    Then sistem menampilkan "disabled karena kuota penuh" pada elemen "cari-jadwal / Pilih"
    And sistem menampilkan "Order baru ditolak; tidak masuk Isi Data, tidak membuat order/reservasi baru; pesan batas tampil." pada elemen "cari-jadwal / Pesan Batas"

  @positive @priority-high @REQ-017 @screen-pengaturan-sistem
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-023 — Admin mengakses kedua submenu Pengaturan Sistem
    Given user berada di halaman "Pengaturan Sistem"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin aktif."
    When user mengklik tombol atau link "pengaturan-sistem / Pengaturan Sistem"
    And user mengklik tombol atau link "pengaturan-sistem / Batas Order User Umum"
    Then sistem menampilkan "Form dapat dibaca" pada elemen "batas-order / Batas Order Selesai per Rute"
    When user membuka halaman "Pengaturan Sistem"
    And user mengklik tombol atau link "pengaturan-sistem / Kontak Kantor Cabang"
    Then sistem menampilkan "Daftar operator aktif tampil" pada elemen "operator-aktif / Daftar Operator"

  @positive @priority-high @REQ-017 @screen-pengaturan-sistem
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-024 — Kantor Pusat mengakses kedua submenu Pengaturan Sistem
    Given user berada di halaman "Pengaturan Sistem"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Kantor Pusat aktif."
    When user mengklik tombol atau link "pengaturan-sistem / Pengaturan Sistem"
    And user mengklik tombol atau link "pengaturan-sistem / Batas Order User Umum"
    Then sistem menampilkan "Form dapat dibaca" pada elemen "batas-order / Batas Order Selesai per Rute"
    When user membuka halaman "Pengaturan Sistem"
    And user mengklik tombol atau link "pengaturan-sistem / Kontak Kantor Cabang"
    Then sistem menampilkan "Daftar operator aktif tampil" pada elemen "operator-aktif / Daftar Operator"

  @negative @priority-high @REQ-017 @screen-pengaturan-sistem
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-018 — User Umum ditolak membaca dan mengubah setting melalui akses langsung
    Given user berada di halaman "Pengaturan Sistem"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum; harness mencoba deep link dan request setting/kontak."
    When user membuka halaman "Batas Order User Umum"
    Then sistem menampilkan "Akses ditolak; data setting tidak bocor" pada elemen "batas-order / Batas Order Selesai per Rute"
    When user membuka halaman "Kontak Kantor Cabang"
    Then sistem menampilkan "Akses ditolak; perubahan tidak tersimpan" pada elemen "kontak-cabang / Tabel Pelabuhan"

  @negative @priority-high @REQ-017 @screen-pengaturan-sistem
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-019 — Kantor Cabang ditolak membaca dan mengubah setting melalui akses langsung
    Given user berada di halaman "Pengaturan Sistem"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Kantor Cabang; harness mencoba deep link dan request setting/kontak."
    When user membuka halaman "Batas Order User Umum"
    Then sistem menampilkan "Akses ditolak; data setting tidak bocor" pada elemen "batas-order / Batas Order Selesai per Rute"
    When user membuka halaman "Kontak Kantor Cabang"
    Then sistem menampilkan "Akses ditolak; perubahan tidak tersimpan" pada elemen "kontak-cabang / Tabel Pelabuhan"

  @negative @priority-high @REQ-017 @screen-pengaturan-sistem
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-020 — Agen ditolak membaca dan mengubah setting melalui akses langsung
    Given user berada di halaman "Pengaturan Sistem"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Agen; harness mencoba deep link dan request setting/kontak."
    When user membuka halaman "Batas Order User Umum"
    Then sistem menampilkan "Akses ditolak; data setting tidak bocor" pada elemen "batas-order / Batas Order Selesai per Rute"
    When user membuka halaman "Kontak Kantor Cabang"
    Then sistem menampilkan "Akses ditolak; perubahan tidak tersimpan" pada elemen "kontak-cabang / Tabel Pelabuhan"

  @negative @priority-high @REQ-017 @screen-pengaturan-sistem
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-021 — Tanpa Sesi ditolak membaca dan mengubah setting melalui akses langsung
    Given user berada di halaman "Pengaturan Sistem"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Tanpa Sesi; harness mencoba deep link dan request setting/kontak."
    When user membuka halaman "Batas Order User Umum"
    Then sistem menampilkan "Akses ditolak; data setting tidak bocor" pada elemen "batas-order / Batas Order Selesai per Rute"
    When user membuka halaman "Kontak Kantor Cabang"
    Then sistem menampilkan "Akses ditolak; perubahan tidak tersimpan" pada elemen "kontak-cabang / Tabel Pelabuhan"

  @positive @priority-high @REQ-017 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-025 — Kantor Pusat dapat menyimpan setting batas dan kontak operator
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Kantor Pusat; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "OP-A aktif; BPN memiliki kontak valid yang siap diedit."
    When user mengisi field "batas-order / Batas Order Selesai per Rute" dengan "4"
    And user mengklik tombol atau link "batas-order / Simpan Pengaturan"
    And user mengklik tombol atau link "konfirmasi-pengaturan / Simpan"
    Then sistem menampilkan "Nilai 4 tersimpan" pada elemen "batas-order / Batas Order Selesai per Rute"
    When user membuka halaman "Operator Aktif"
    And user mengklik tombol atau link "operator-aktif / Pilih Operator"
    And user mengklik tombol atau link "kontak-cabang / Ubah kontak"
    And user mengisi field "ubah-kontak / No. WhatsApp" dengan "081234567890"
    And user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "WA OP-A/BPN diperbarui oleh Kantor Pusat" pada elemen "kontak-cabang / Tabel Pelabuhan"

  @positive @priority-high @REQ-018 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-026 — Integer lima diterima sebagai batas order
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user mengisi field "batas-order / Batas Order Selesai per Rute" dengan "5"
    And user mengklik tombol atau link "batas-order / Simpan Pengaturan"
    Then sistem menampilkan "Menampilkan selisih nilai lama dan nilai baru" pada elemen "konfirmasi-pengaturan / Ringkasan Perubahan"
    When user mengklik tombol atau link "konfirmasi-pengaturan / Simpan"
    Then sistem menampilkan "Perubahan tersimpan dan histori mencatat actor serta waktu." pada elemen "batas-order / Simpan Pengaturan"

  @negative @priority-high @REQ-018 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-022 — Batas kosong ditolak tanpa mengganti nilai lama
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user mengisi field "batas-order / Batas Order Selesai per Rute" dengan ""
    Then sistem menampilkan "Invalid: Isi angka 1–10." pada elemen "batas-order / Batas Order Selesai per Rute"
    And sistem menampilkan "disabled; setting tersimpan tetap 2" pada elemen "batas-order / Simpan Pengaturan"

  @negative @priority-high @REQ-018 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-023 — Batas nol ditolak tanpa mengganti nilai lama
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user mengisi field "batas-order / Batas Order Selesai per Rute" dengan "0"
    Then sistem menampilkan "Invalid: Isi angka 1–10." pada elemen "batas-order / Batas Order Selesai per Rute"
    And sistem menampilkan "disabled; setting tersimpan tetap 2" pada elemen "batas-order / Simpan Pengaturan"

  @negative @priority-high @REQ-018 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-024 — Batas negatif ditolak tanpa mengganti nilai lama
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user mengisi field "batas-order / Batas Order Selesai per Rute" dengan "-1"
    Then sistem menampilkan "Invalid: Isi angka 1–10." pada elemen "batas-order / Batas Order Selesai per Rute"
    And sistem menampilkan "disabled; setting tersimpan tetap 2" pada elemen "batas-order / Simpan Pengaturan"

  @negative @priority-high @REQ-018 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-025 — Batas di atas sepuluh ditolak tanpa mengganti nilai lama
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user mengisi field "batas-order / Batas Order Selesai per Rute" dengan "11"
    Then sistem menampilkan "Invalid: Isi angka 1–10." pada elemen "batas-order / Batas Order Selesai per Rute"
    And sistem menampilkan "disabled; setting tersimpan tetap 2" pada elemen "batas-order / Simpan Pengaturan"

  @negative @priority-high @REQ-018 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-026 — Batas pecahan ditolak tanpa mengganti nilai lama
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user mengisi field "batas-order / Batas Order Selesai per Rute" dengan "1.5"
    Then sistem menampilkan "Invalid: Isi angka 1–10." pada elemen "batas-order / Batas Order Selesai per Rute"
    And sistem menampilkan "disabled; setting tersimpan tetap 2" pada elemen "batas-order / Simpan Pengaturan"

  @negative @priority-high @REQ-018 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-027 — Batas nonangka ditolak tanpa mengganti nilai lama
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user mengisi field "batas-order / Batas Order Selesai per Rute" dengan "abc"
    Then sistem menampilkan "Invalid: Isi angka 1–10." pada elemen "batas-order / Batas Order Selesai per Rute"
    And sistem menampilkan "disabled; setting tersimpan tetap 2" pada elemen "batas-order / Simpan Pengaturan"

  @positive @priority-high @REQ-019 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-027 — Nonaktif memungkinkan publik membuat order walau penggunaan melewati batas
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user memilih opsi "Nonaktif" pada "batas-order / Status Pembatasan"
    And user mengklik tombol atau link "batas-order / Simpan Pengaturan"
    Then sistem menampilkan "Menampilkan selisih nilai lama dan nilai baru" pada elemen "konfirmasi-pengaturan / Ringkasan Perubahan"
    When user mengklik tombol atau link "konfirmasi-pengaturan / Simpan"
    Then sistem menampilkan "Status Nonaktif tersimpan; user dengan C=20 tetap boleh order; badge TANPA BATAS." pada elemen "batas-order / Simpan Pengaturan"

  @negative @priority-high @REQ-019 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-028 — Status tak dikenal tidak menonaktifkan batas melalui request
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    Then sistem menampilkan "Request status invalid ditolak" pada elemen "batas-order / Status Pembatasan"
    And sistem menampilkan "Setting tetap Aktif" pada elemen "batas-order / Simpan Pengaturan"

  @positive @priority-high @REQ-019 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-028 — Aktivasi kembali memperhitungkan order yang selesai selama Nonaktif
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Nonaktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Override fixture: status lama Nonaktif; U-A memiliki C=3 hari ini."
    When user memilih opsi "Aktif" pada "batas-order / Status Pembatasan"
    And user mengklik tombol atau link "batas-order / Simpan Pengaturan"
    Then sistem menampilkan "Menampilkan selisih nilai lama dan nilai baru" pada elemen "konfirmasi-pengaturan / Ringkasan Perubahan"
    When user mengklik tombol atau link "konfirmasi-pengaturan / Simpan"
    Then sistem menampilkan "Status Aktif tersimpan; admission baru U-A ditolak karena C=3≥2; order lama tetap sah." pada elemen "batas-order / Simpan Pengaturan"

  @positive @priority-high @REQ-020 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-029 — Pesan kustom tersimpan dan muncul pada rute yang penuh
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user mengisi field "batas-order / Pesan Saat Batas Tercapai" dengan "Pembelian hari ini penuh. Hubungi cabang asal atau tujuan."
    And user mengklik tombol atau link "batas-order / Simpan Pengaturan"
    Then sistem menampilkan "Menampilkan selisih nilai lama dan nilai baru" pada elemen "konfirmasi-pengaturan / Ringkasan Perubahan"
    When user mengklik tombol atau link "konfirmasi-pengaturan / Simpan"
    Then sistem menampilkan "Pesan kustom tersimpan, reload mempertahankan teks dan user penuh membaca teks yang sama." pada elemen "batas-order / Simpan Pengaturan"

  @negative @priority-high @REQ-020 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-029 — Pesan kosong tidak dapat disimpan
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user mengisi field "batas-order / Pesan Saat Batas Tercapai" dengan ""
    Then sistem menampilkan "disabled karena pesan nonkosong wajib" pada elemen "batas-order / Simpan Pengaturan"

  @negative @priority-high @REQ-020 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-030 — Pesan hanya spasi tidak dapat disimpan
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user mengisi field "batas-order / Pesan Saat Batas Tercapai" dengan "   "
    Then sistem menampilkan "disabled karena pesan nonkosong wajib" pada elemen "batas-order / Simpan Pengaturan"

  @positive @priority-high @REQ-021 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-030 — Histori mencatat batas status pesan actor dan waktu server
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user mengisi field "batas-order / Batas Order Selesai per Rute" dengan "4"
    And user memilih opsi "Nonaktif" pada "batas-order / Status Pembatasan"
    And user mengisi field "batas-order / Pesan Saat Batas Tercapai" dengan "Hubungi cabang untuk tambahan order."
    And user mengklik tombol atau link "batas-order / Simpan Pengaturan"
    And user mengklik tombol atau link "konfirmasi-pengaturan / Simpan"
    And user mengklik tombol atau link "batas-order / Lihat Riwayat Perubahan"
    Then sistem menampilkan "Satu entri: batas 2→4, Aktif→Nonaktif, pesan berubah, Admin A dan 08/10/2026 12:00 WIB" pada elemen "riwayat-perubahan / Tabel Riwayat"
    When user mengklik tombol atau link "riwayat-perubahan / Tutup"
    Then sistem menampilkan "Waktu dan user penonaktifan sesuai histori" pada elemen "batas-order / Info Nonaktif"

  @negative @priority-high @REQ-021 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-031 — Pembatalan konfirmasi tidak membuat histori perubahan
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user mengisi field "batas-order / Batas Order Selesai per Rute" dengan "4"
    And user mengklik tombol atau link "batas-order / Simpan Pengaturan"
    And user mengklik tombol atau link "konfirmasi-pengaturan / Batal"
    And user mengklik tombol atau link "batas-order / Lihat Riwayat Perubahan"
    Then sistem menampilkan "Tidak ada entri baru; setting tersimpan tetap 2" pada elemen "riwayat-perubahan / Tabel Riwayat"

  @positive @priority-high @REQ-022 @screen-operator-aktif
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-031 — Admin memilih operator aktif sebelum daftar kontak pelabuhan
    Given user berada di halaman "Operator Aktif"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "OP-A dan OP-B aktif; OP-X nonaktif."
    Then sistem menampilkan "Hanya OP-A dan OP-B" pada elemen "operator-aktif / Daftar Operator"
    When user mengklik tombol atau link "operator-aktif / Pilih Operator"
    Then sistem menampilkan "Pelabuhan Master Trayek milik OP-A" pada elemen "kontak-cabang / Tabel Pelabuhan"

  @negative @priority-high @REQ-022 @screen-operator-aktif
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-032 — Operator nonaktif tidak dapat dipilih melalui ID request
    Given user berada di halaman "Operator Aktif"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "OP-X nonaktif; sesi Admin."
    Then sistem menampilkan "OP-X tidak ada" pada elemen "operator-aktif / Daftar Operator"
    When user membuka halaman "Kontak Kantor Cabang"
    Then sistem menampilkan "ID OP-X ditolak dan kontak tidak diubah" pada elemen "kontak-cabang / Tabel Pelabuhan"

  @positive @priority-high @REQ-023 @screen-kontak-cabang
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-032 — Daftar pelabuhan berasal dari asal tujuan Master Trayek
    Given user berada di halaman "Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "OP-A dipilih; Master Trayek memuat BPN,PAP,SBY sebagai asal/tujuan; BPN muncul di beberapa trayek."
    Then sistem menampilkan "BPN,PAP,SBY tersedia sesuai Master Trayek tanpa duplikasi pelabuhan" pada elemen "kontak-cabang / Tabel Pelabuhan"
    When user mengklik tombol atau link "kontak-cabang / Ubah kontak"
    Then sistem menampilkan "ID/nama pelabuhan Master Trayek readonly" pada elemen "ubah-kontak / Pelabuhan"

  @negative @priority-high @REQ-023 @screen-kontak-cabang
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-033 — Pelabuhan manual yang tidak ada di Master Trayek ditolak
    Given user berada di halaman "Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A; port X-FAKE tidak ada di Master Trayek."
    Then sistem menampilkan "Tidak menyediakan buat pelabuhan manual" pada elemen "kontak-cabang / Tabel Pelabuhan"
    When user mengklik tombol atau link "kontak-cabang / Ubah kontak"
    Then sistem menampilkan "Request port X-FAKE ditolak" pada elemen "ubah-kontak / Pelabuhan"

  @positive @priority-high @REQ-024 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-033 — Perubahan kontak tersimpan hanya untuk operator pelabuhan terpilih
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / No. WhatsApp" dengan "081234567890"
    And user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "OP-A/BPN menggunakan WA baru setelah reload; OP-A/PAP dan OP-B/BPN tetap baseline." pada elemen "kontak-cabang / Tabel Pelabuhan"

  @negative @priority-high @REQ-024 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-034 — ID kontak milik operator lain tidak dapat ditimpa dari form OP-A
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / No. WhatsApp" dengan "081234567890"
    And user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "Mutasi OP-B/BPN dari konteks OP-A ditolak" pada elemen "kontak-cabang / Tabel Pelabuhan"

  @positive @priority-high @REQ-025 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-034 — WhatsApp valid berawalan 08 dan dua belas digit disimpan
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / No. WhatsApp" dengan "081234567890"
    And user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "Kontak operator OP-A pelabuhan BPN tersimpan dan dapat dibaca ulang." pada elemen "kontak-cabang / Tabel Pelabuhan"

  @negative @priority-high @REQ-025 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-035 — Nomor WhatsApp kosong ditolak
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / No. WhatsApp" dengan ""
    Then sistem menampilkan "Nomor wajib literal digit, awalan 08, panjang 10–13" pada elemen "ubah-kontak / Validasi Kontak"
    And sistem menampilkan "disabled; WA lama tidak berubah" pada elemen "ubah-kontak / Simpan"

  @negative @priority-high @REQ-025 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-036 — Nomor WhatsApp awalan selain 08 ditolak
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / No. WhatsApp" dengan "071234567890"
    Then sistem menampilkan "Nomor wajib literal digit, awalan 08, panjang 10–13" pada elemen "ubah-kontak / Validasi Kontak"
    And sistem menampilkan "disabled; WA lama tidak berubah" pada elemen "ubah-kontak / Simpan"

  @negative @priority-high @REQ-025 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-037 — Nomor WhatsApp sembilan digit ditolak
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / No. WhatsApp" dengan "081234567"
    Then sistem menampilkan "Nomor wajib literal digit, awalan 08, panjang 10–13" pada elemen "ubah-kontak / Validasi Kontak"
    And sistem menampilkan "disabled; WA lama tidak berubah" pada elemen "ubah-kontak / Simpan"

  @negative @priority-high @REQ-025 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-038 — Nomor WhatsApp empat belas digit ditolak
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / No. WhatsApp" dengan "08123456789012"
    Then sistem menampilkan "Nomor wajib literal digit, awalan 08, panjang 10–13" pada elemen "ubah-kontak / Validasi Kontak"
    And sistem menampilkan "disabled; WA lama tidak berubah" pada elemen "ubah-kontak / Simpan"

  @negative @priority-high @REQ-025 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-039 — Nomor WhatsApp huruf ditolak
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / No. WhatsApp" dengan "08abc4567890"
    Then sistem menampilkan "Nomor wajib literal digit, awalan 08, panjang 10–13" pada elemen "ubah-kontak / Validasi Kontak"
    And sistem menampilkan "disabled; WA lama tidak berubah" pada elemen "ubah-kontak / Simpan"

  @negative @priority-high @REQ-025 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-040 — Nomor WhatsApp format +62 ditolak
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / No. WhatsApp" dengan "+6281234567890"
    Then sistem menampilkan "Nomor wajib literal digit, awalan 08, panjang 10–13" pada elemen "ubah-kontak / Validasi Kontak"
    And sistem menampilkan "disabled; WA lama tidak berubah" pada elemen "ubah-kontak / Simpan"

  @negative @priority-high @REQ-025 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-041 — Nomor WhatsApp pemisah spasi ditolak
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / No. WhatsApp" dengan "08 1234567890"
    Then sistem menampilkan "Nomor wajib literal digit, awalan 08, panjang 10–13" pada elemen "ubah-kontak / Validasi Kontak"
    And sistem menampilkan "disabled; WA lama tidak berubah" pada elemen "ubah-kontak / Simpan"

  @positive @priority-high @REQ-026 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-035 — Email kontak valid tersimpan dan terbaca ulang
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / Email Cabang" dengan "cabang.bpn@example.test"
    And user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "Kontak operator OP-A pelabuhan BPN tersimpan dan dapat dibaca ulang." pada elemen "kontak-cabang / Tabel Pelabuhan"

  @negative @priority-high @REQ-026 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-042 — Email cabang tanpa @ ditolak
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / Email Cabang" dengan "cabang.example.test"
    Then sistem menampilkan "Email wajib berformat email" pada elemen "ubah-kontak / Validasi Kontak"
    And sistem menampilkan "disabled; email lama tetap" pada elemen "ubah-kontak / Simpan"

  @negative @priority-high @REQ-026 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-043 — Email cabang tanpa domain ditolak
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / Email Cabang" dengan "cabang@"
    Then sistem menampilkan "Email wajib berformat email" pada elemen "ubah-kontak / Validasi Kontak"
    And sistem menampilkan "disabled; email lama tetap" pada elemen "ubah-kontak / Simpan"

  @negative @priority-high @REQ-026 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-044 — Email cabang kosong ditolak
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / Email Cabang" dengan ""
    Then sistem menampilkan "Email wajib berformat email" pada elemen "ubah-kontak / Validasi Kontak"
    And sistem menampilkan "disabled; email lama tetap" pada elemen "ubah-kontak / Simpan"

  @positive @priority-high @REQ-027 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-036 — Alamat lengkap tersimpan dan ditampilkan di kontak publik
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / Alamat" dengan "Pelabuhan Kariangau, Jl. Mulawarman No. 10, Balikpapan"
    And user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "Alamat baru tersimpan dan muncul pada kontak asal BPN." pada elemen "kontak-cabang / Tabel Pelabuhan"

  @negative @priority-high @REQ-027 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-045 — Alamat kosong tidak dapat disimpan
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / Alamat" dengan ""
    Then sistem menampilkan "disabled karena alamat wajib" pada elemen "ubah-kontak / Simpan"

  @negative @priority-high @REQ-027 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-046 — Alamat spasi tidak dapat disimpan
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / Alamat" dengan "   "
    Then sistem menampilkan "disabled karena alamat wajib" pada elemen "ubah-kontak / Simpan"

  @positive @priority-high @REQ-028 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-037 — Pilih Semua menyimpan tujuh hari operasional
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengklik tombol atau link "ubah-kontak / Pilih Semua"
    Then sistem menampilkan "dipilih" pada elemen "ubah-kontak / Senin"
    And sistem menampilkan "dipilih" pada elemen "ubah-kontak / Selasa"
    And sistem menampilkan "dipilih" pada elemen "ubah-kontak / Rabu"
    And sistem menampilkan "dipilih" pada elemen "ubah-kontak / Kamis"
    And sistem menampilkan "dipilih" pada elemen "ubah-kontak / Jumat"
    And sistem menampilkan "dipilih" pada elemen "ubah-kontak / Sabtu"
    And sistem menampilkan "dipilih" pada elemen "ubah-kontak / Minggu"
    When user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "Hari Senin–Minggu tersimpan" pada elemen "kontak-cabang / Tabel Pelabuhan"

  @negative @priority-high @REQ-028 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-047 — Tidak memilih hari menolak simpan
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Fixture hari operasional kosong."
    Then sistem menampilkan "Pilih minimal 1 hari operasional." pada elemen "ubah-kontak / Validasi Kontak"
    And sistem menampilkan "disabled" pada elemen "ubah-kontak / Simpan"

  @positive @priority-high @REQ-029 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-038 — Jam delapan hingga tujuh belas disimpan dan preview sesuai
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user memilih opsi "08:00" pada "ubah-kontak / Jam Buka"
    And user memilih opsi "17:00" pada "ubah-kontak / Jam Tutup"
    Then sistem menampilkan "Senin–Sabtu, 08.00–17.00 WITA" pada elemen "ubah-kontak / Preview Jam"
    When user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "Jam valid tersimpan dan preview memakai hari/zona pelabuhan." pada elemen "ubah-kontak / Simpan"

  @negative @priority-high @REQ-029 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-048 — Jam operasional tutup sebelum buka ditolak
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user memilih opsi "17:00" pada "ubah-kontak / Jam Buka"
    And user memilih opsi "08:00" pada "ubah-kontak / Jam Tutup"
    Then sistem menampilkan "disabled karena jam invalid" pada elemen "ubah-kontak / Simpan"

  @negative @priority-high @REQ-029 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-049 — Jam operasional tutup sama dengan buka ditolak
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user memilih opsi "08:00" pada "ubah-kontak / Jam Buka"
    And user memilih opsi "08:00" pada "ubah-kontak / Jam Tutup"
    Then sistem menampilkan "disabled karena jam invalid" pada elemen "ubah-kontak / Simpan"

  @negative @priority-high @REQ-029 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-050 — Jam operasional jam buka kosong ditolak
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user memilih opsi "" pada "ubah-kontak / Jam Buka"
    And user memilih opsi "17:00" pada "ubah-kontak / Jam Tutup"
    Then sistem menampilkan "disabled karena jam invalid" pada elemen "ubah-kontak / Simpan"

  @negative @priority-high @REQ-029 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-051 — Jam operasional jam tutup kosong ditolak
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user memilih opsi "08:00" pada "ubah-kontak / Jam Buka"
    And user memilih opsi "" pada "ubah-kontak / Jam Tutup"
    Then sistem menampilkan "disabled karena jam invalid" pada elemen "ubah-kontak / Simpan"

  @positive @priority-high @REQ-029 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-039 — Buka 24 Jam membebaskan field jam pada hari dipilih
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mencentang checkbox "ubah-kontak / Buka 24 Jam"
    Then sistem menampilkan "Senin–Sabtu, 24 Jam WITA" pada elemen "ubah-kontak / Preview Jam"
    When user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "Mode h24 tersimpan; tidak membutuhkan jam buka/tutup; hari tetap wajib." pada elemen "ubah-kontak / Simpan"

  @positive @priority-high @REQ-030 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-040 — Zona WITA pelabuhan ditampilkan tanpa mengubah reset WIB
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    Then sistem menampilkan "WITA" pada elemen "ubah-kontak / Zona Waktu"
    And sistem menampilkan "08.00–17.00 WITA" pada elemen "ubah-kontak / Preview Jam"
    When user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "Kontak BPN menggunakan WITA; reset pembelian tetap 00:00 WIB/01:00 WITA." pada elemen "ubah-kontak / Simpan"

  @negative @priority-high @REQ-030 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-052 — Klien tidak dapat mengganti zona master pelabuhan melalui form kontak
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    Then sistem menampilkan "readonly WITA" pada elemen "ubah-kontak / Zona Waktu"
    When user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "Zona master tetap WITA setelah mutasi WIB ditolak/diabaikan" pada elemen "kontak-cabang / Tabel Pelabuhan"

  @positive @priority-high @REQ-031 @screen-hubungi-cabang
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-041 — Dialog menampilkan dua kontak lengkap dan tautan WhatsApp sesuai cabang
    Given user berada di halaman "Hubungi Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "BPN→PAP penuh; dialog dibuka; WA asal 081254012233, tujuan 081355667788; kedua email/jam/alamat tersedia."
    Then sistem menampilkan "Nama/alamat/email/jam kontak BPN lengkap" pada elemen "hubungi-cabang / Kontak Asal"
    And sistem menampilkan "Nama/alamat/email/jam kontak PAP lengkap" pada elemen "hubungi-cabang / Kontak Tujuan"
    When user mengklik tombol atau link "hubungi-cabang / WhatsApp Asal"
    Then sistem menampilkan "href https://wa.me/6281254012233" pada elemen "hubungi-cabang / WhatsApp Asal"
    When user mengklik tombol atau link "hubungi-cabang / WhatsApp Tujuan"
    Then sistem menampilkan "href https://wa.me/6281355667788" pada elemen "hubungi-cabang / WhatsApp Tujuan"
    When user mengklik tombol atau link "hubungi-cabang / Tutup"
    Then sistem menampilkan "Asal dan tujuan tidak tertukar; link benar; Tutup kembali ke layar batas tanpa order baru." pada elemen "hubungi-cabang / Tutup"

  @negative @priority-high @REQ-031 @screen-hubungi-cabang
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-053 — Kontak tujuan belum disetting tidak memakai nomor cabang lain
    Given user berada di halaman "Hubungi Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Rute BPN→PAP; kontak PAP kosong; kontak BPN valid."
    Then sistem menampilkan "Kontak BPN tersedia" pada elemen "hubungi-cabang / Kontak Asal"
    And sistem menampilkan "Kontak PAP belum tersedia; tidak menampilkan nomor lain" pada elemen "hubungi-cabang / Kontak Tujuan"
    And sistem menampilkan "Tidak ada tautan aktif ke nomor kosong atau milik BPN" pada elemen "hubungi-cabang / WhatsApp Tujuan"

  @positive @priority-high @REQ-032 @screen-detail-tiket
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-042 — Tiket baru memakai kontak terbaru dari sumber Kontak Kantor Cabang
    Given user berada di halaman "Detail Tiket"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memperbarui OP-A/BPN; order O-1 sah baru selesai setelah perubahan; Master CS lama memiliki nomor berbeda."
    Then sistem menampilkan "Nomor/alamat/jam/email OP-A/BPN dan OP-A/PAP sesuai sumber kontak terbaru" pada elemen "detail-tiket / Kontak Tiket"
    When user mengklik tombol atau link "detail-tiket / Cetak Tiket"
    Then sistem menampilkan "PDF tiket baru memuat kontak terbaru" pada elemen "detail-tiket / Kontak Tiket"

  @negative @priority-high @REQ-032 @screen-detail-tiket
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-054 — Data Master CS usang tidak dipakai saat kontak baru tidak tersedia
    Given user berada di halaman "Detail Tiket"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "OP-A/PAP belum disetting; Master CS lama memiliki nomor; order sah siap cetak."
    Then sistem menampilkan "Kontak PAP belum tersedia, tidak fallback ke Master CS lama" pada elemen "detail-tiket / Kontak Tiket"
    When user mengklik tombol atau link "detail-tiket / Cetak Tiket"
    Then sistem menampilkan "Tiket tetap dapat dibuat tanpa nomor salah dari data lama" pada elemen "detail-tiket / Kontak Tiket"

  @positive @priority-high @REQ-033 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-043 — Konfirmasi menampilkan selisih dan Simpan menerapkannya
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user mengisi field "batas-order / Batas Order Selesai per Rute" dengan "6"
    And user mengklik tombol atau link "batas-order / Simpan Pengaturan"
    Then sistem menampilkan "Menampilkan selisih nilai lama dan nilai baru" pada elemen "konfirmasi-pengaturan / Ringkasan Perubahan"
    When user mengklik tombol atau link "konfirmasi-pengaturan / Simpan"
    Then sistem menampilkan "Konfirmasi menampilkan batas 2→6; Simpan menyimpan 6; reload mempertahankan 6." pada elemen "batas-order / Simpan Pengaturan"

  @negative @priority-high @REQ-033 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-055 — Form pristine tidak dapat menyimpan atau menambah histori
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    Then sistem menampilkan "disabled tanpa perubahan" pada elemen "batas-order / Simpan Pengaturan"

  @positive @priority-high @REQ-034 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-044 — Badge sisa menampilkan satu dari dua sesuai kapasitas tersedia
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=1, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    Then sistem menampilkan "SISA 1 DARI 2" pada elemen "cari-jadwal / Kuota Rute"
    And sistem menampilkan "Periode Perhitungan menggunakan WIB" pada elemen "cari-jadwal / Berlaku lagi"

  @negative @priority-high @REQ-034 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-056 — Badge penuh tidak menampilkan sisa satu dari cache
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    Then sistem menampilkan "BATAS TERCAPAI" pada elemen "cari-jadwal / Kuota Rute"
    And sistem menampilkan "09/10/2026 00:00 WIB (01:00 WITA)" pada elemen "cari-jadwal / Berlaku lagi"
    And sistem menampilkan "disabled" pada elemen "cari-jadwal / Pilih"

  @positive @priority-high @REQ-034 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-045 — Badge Nonaktif menampilkan TANPA BATAS
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Nonaktif, batas 2; user U-A, rute BPN → PAP; C=10, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    Then sistem menampilkan "TANPA BATAS" pada elemen "cari-jadwal / Kuota Rute"
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    Then sistem menampilkan "Tabel tiket dapat dipilih" pada elemen "cari-jadwal / Jumlah Tiket"

  @positive @priority-high @REQ-035 @screen-daftar-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-046 — Daftar dan detail konsisten untuk order sah dengan banyak tiket
    Given user berada di halaman "Daftar Order"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=1, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "O-1 Selesai memiliki 10 tiket; O-2 Menunggu Pembayaran, O-3 Expired."
    When user mengklik tombol atau link "daftar-order / Filter"
    And user memilih opsi "20" pada "daftar-order / Menampilkan Data"
    Then sistem menampilkan "O-1 Selesai 10 tiket, O-2 Menunggu Pembayaran, O-3 Expired" pada elemen "daftar-order / Tabel Order"
    When user mengklik tombol atau link "daftar-order / ID Order"
    Then sistem menampilkan "Detail O-1 terbuka dari link ID Order" pada elemen "detail-order / Data Order"
    When user mengklik tombol atau link "detail-order / Kembali"
    And user mengklik tombol atau link "daftar-order / Action Menu"
    And user mengklik tombol atau link "daftar-order / Detail Order"
    Then sistem menampilkan "O-1 jumlah 10 tiket dan waktu bayar sesuai record" pada elemen "detail-order / Data Order"
    When user mengklik tombol atau link "detail-order / Detail Tiket"
    And user membuka halaman "Detail Order"
    And user mengklik tombol atau link "detail-order / Kembali"
    Then sistem menampilkan "Status/tiket/tanggal konsisten, navigasi detail/tiket/kembali bekerja; tidak menggunakan status pembatalan kuota lama." pada elemen "detail-order / Kembali"

  @negative @priority-high @REQ-035 @screen-detail-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-057 — Order Expired tidak dapat dibayar atau menerbitkan tiket
    Given user berada di halaman "Detail Order"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "O-3 expired dan R sudah dilepas; deep link pembayaran/cetak dicoba."
    Then sistem menampilkan "hidden/disabled untuk Expired" pada elemen "detail-order / Bayar Sekarang"
    And sistem menampilkan "Waktu pembayaran telah berakhir" pada elemen "detail-order / Info Pembayaran"
    And sistem menampilkan "Tetap Expired, tidak ada tiket terbit" pada elemen "detail-order / Status Order"

  @edge @priority-high @REQ-018 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-001 — Batas minimum maksimum 1 diterima
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user mengisi field "batas-order / Batas Order Selesai per Rute" dengan "1"
    And user mengklik tombol atau link "batas-order / Simpan Pengaturan"
    Then sistem menampilkan "Menampilkan selisih nilai lama dan nilai baru" pada elemen "konfirmasi-pengaturan / Ringkasan Perubahan"
    When user mengklik tombol atau link "konfirmasi-pengaturan / Simpan"
    Then sistem menampilkan "Batas 1 tersimpan; tepat 1 slot diperbolehkan dan slot 2 ditolak." pada elemen "batas-order / Simpan Pengaturan"

  @edge @priority-high @REQ-018 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-002 — Batas minimum maksimum 10 diterima
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user mengisi field "batas-order / Batas Order Selesai per Rute" dengan "10"
    And user mengklik tombol atau link "batas-order / Simpan Pengaturan"
    Then sistem menampilkan "Menampilkan selisih nilai lama dan nilai baru" pada elemen "konfirmasi-pengaturan / Ringkasan Perubahan"
    When user mengklik tombol atau link "konfirmasi-pengaturan / Simpan"
    Then sistem menampilkan "Batas 10 tersimpan; tepat 10 slot diperbolehkan dan slot 11 ditolak." pada elemen "batas-order / Simpan Pengaturan"

  @edge @priority-high @REQ-004 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-003 — Batas satu mengizinkan hanya satu slot
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 1; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Satu reservasi dibuat; tab berikutnya diblokir meskipun C=0." pada elemen "isi-data / Kuota Rute"

  @edge @priority-high @REQ-004 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-004 — Batas sepuluh menolak slot kesebelas
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 10; user U-A, rute BPN → PAP; C=9, R=1; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    Then sistem menampilkan "disabled karena kuota penuh" pada elemen "cari-jadwal / Pilih"
    And sistem menampilkan "Order baru ditolak; tidak masuk Isi Data, tidak membuat order/reservasi baru; pesan batas tampil." pada elemen "cari-jadwal / Pesan Batas"

  @edge @priority-high @REQ-025 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-005 — WhatsApp tepat 10 digit diterima
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / No. WhatsApp" dengan "0812345678"
    And user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "WA 0812345678 disimpan lengkap tanpa kehilangan nol awal." pada elemen "kontak-cabang / Tabel Pelabuhan"

  @edge @priority-high @REQ-025 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-006 — WhatsApp tepat 13 digit diterima
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / No. WhatsApp" dengan "0812345678901"
    And user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "WA 0812345678901 disimpan lengkap tanpa kehilangan nol awal." pada elemen "kontak-cabang / Tabel Pelabuhan"

  @edge @priority-high @REQ-026 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-007 — Email plus tag dan subdomain valid diterima
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / Email Cabang" dengan "cabang+ops@sub.example.test"
    And user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "Email valid tersimpan tanpa menghapus + atau subdomain." pada elemen "kontak-cabang / Tabel Pelabuhan"

  @edge @priority-high @REQ-027 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-008 — Alamat Unicode dan tanda baca tampil sebagai teks
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / Alamat" dengan "Jl. Nusantara № 8, Blok A & B — Pelabuhan"
    And user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "Karakter Unicode/tanda baca tetap utuh dan tampil aman." pada elemen "kontak-cabang / Tabel Pelabuhan"

  @edge @priority-high @REQ-020 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-009 — Pesan mengandung markup tidak dieksekusi
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    When user mengisi field "batas-order / Pesan Saat Batas Tercapai" dengan "<b>Hubungi cabang</b> & tunggu esok"
    And user mengklik tombol atau link "batas-order / Simpan Pengaturan"
    Then sistem menampilkan "Menampilkan selisih nilai lama dan nilai baru" pada elemen "konfirmasi-pengaturan / Ringkasan Perubahan"
    When user mengklik tombol atau link "konfirmasi-pengaturan / Simpan"
    Then sistem menampilkan "Pesan disimpan/ditampilkan sebagai teks biasa; tidak membentuk elemen HTML aktif." pada elemen "batas-order / Simpan Pengaturan"

  @edge @priority-high @REQ-028 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-010 — Hanya hari Minggu dapat menjadi jadwal operasional
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Fixture semua hari tidak dipilih sebelum klik Minggu."
    When user mengklik tombol atau link "ubah-kontak / Minggu"
    Then sistem menampilkan "Minggu, 08.00–17.00 WITA" pada elemen "ubah-kontak / Preview Jam"
    When user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "Satu hari Minggu valid; hari lain tetap tidak dipilih." pada elemen "ubah-kontak / Simpan"

  @edge @priority-high @REQ-028 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-011 — Kombinasi hari tidak berurutan disimpan dalam urutan kalender
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Fixture Senin/Rabu/Jumat dipilih, hari lain tidak."
    Then sistem menampilkan "dipilih" pada elemen "ubah-kontak / Senin"
    And sistem menampilkan "dipilih" pada elemen "ubah-kontak / Rabu"
    And sistem menampilkan "dipilih" pada elemen "ubah-kontak / Jumat"
    When user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "Hari Senin,Rabu,Jumat sesuai pilihan" pada elemen "kontak-cabang / Tabel Pelabuhan"

  @edge @priority-high @REQ-029 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-012 — Slot jam terkecil tiga puluh menit diterima
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user memilih opsi "08:00" pada "ubah-kontak / Jam Buka"
    And user memilih opsi "08:30" pada "ubah-kontak / Jam Tutup"
    And user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "08:00–08:30 valid; tidak disyaratkan minimal satu jam." pada elemen "ubah-kontak / Simpan"

  @edge @priority-high @REQ-029 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-013 — Mematikan Buka 24 Jam kembali mewajibkan jam valid
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "h24 true dengan draft open/close kosong."
    When user menghapus centang checkbox "ubah-kontak / Buka 24 Jam"
    Then sistem menampilkan "disabled sampai jam valid diisi" pada elemen "ubah-kontak / Simpan"

  @edge @priority-high @REQ-005 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-014 — Pergantian hari WIB tepat 00:00:00.000 menerima pembelian
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-09T00:00:00.000+07:00."
    And kondisi uji "Dua order kemarin 23:59:59.999; jam sekarang tepat 00:00 hari berikutnya."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Order baru masuk Isi Data dan tepat satu reservasi ditambahkan." pada elemen "isi-data / Kuota Rute"

  @edge @priority-high @REQ-005 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-015 — Tengah malam WITA belum mereset kuota WIB
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T23:00:00+07:00."
    And kondisi uji "Jam lokal BPN 09/10 00:00 WITA = 08/10 23:00 WIB."
    Then sistem menampilkan "disabled karena kuota penuh" pada elemen "cari-jadwal / Pilih"
    And sistem menampilkan "Order baru ditolak; tidak masuk Isi Data, tidak membuat order/reservasi baru; pesan batas tampil." pada elemen "cari-jadwal / Pesan Batas"

  @edge @priority-high @REQ-030 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-016 — Pelabuhan WIT menampilkan jam lokal tetapi reset dua pagi lokal
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute SBY → AMB; C=0, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    Then sistem menampilkan "09/10/2026 00:00 WIB (02:00 WIT)" pada elemen "cari-jadwal / Berlaku lagi"

  @edge @priority-high @REQ-016 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-017 — Reservasi sebelum tengah malam tetap aktif setelah penghitung selesai reset
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=1; jam server 2026-10-09T00:00:00+07:00."
    And kondisi uji "O-1 dibuat 08/10 23:50 WIB, expiry 09/10 00:20; jam sekarang 09/10 00:00."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "C reset 0; R lama tetap 1; hanya satu slot baru dapat dibuat." pada elemen "isi-data / Kuota Rute"

  @edge @priority-high @REQ-006 @screen-detail-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-018 — Order dibuat kemarin dibayar hari ini menggunakan hari pembayaran
    Given user berada di halaman "Detail Order"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=1; jam server 2026-10-08T00:05:00+07:00."
    And kondisi uji "O-1 dibuat 23:50 kemarin, paidAt 00:05 hari ini."
    When user mengklik tombol atau link "detail-order / Bayar Sekarang"
    Then sistem menampilkan "Selesai; C hari ini 1, R=0" pada elemen "detail-order / Status Order"

  @edge @priority-high @REQ-008 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-019 — Refund kemarin tidak menambah kapasitas ekstra hari ini
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "O-kemarin dibayar kemarin dan refund hari ini; C hari ini sudah 0."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "C hari ini tetap 0, bukan -1; satu order baru membuat R=1." pada elemen "isi-data / Kuota Rute"

  @edge @priority-high @REQ-008 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-020 — Callback refund duplikat membebaskan penggunaan satu kali
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=1, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Semula C=2; callback refund O-2 dikirim dua kali."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "C akhir tepat 1, bukan 0/negatif; refund audit tidak menggandakan pelepasan." pada elemen "isi-data / Kuota Rute"

  @edge @priority-high @REQ-006 @screen-detail-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-021 — Callback pembayaran sukses berulang menghitung satu order sekali
    Given user berada di halaman "Detail Order"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=1; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Gateway mengirim callback sukses O-1 dua kali."
    When user mengklik tombol atau link "detail-order / Bayar Sekarang"
    Then sistem menampilkan "O-1 Selesai satu kali; C=1,R=0" pada elemen "detail-order / Status Order"

  @edge @priority-high @REQ-009 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-022 — Double click Pesan tidak membuat dua reservasi
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Satu order dan satu reservasi untuk idempotency key yang sama" pada elemen "isi-data / Ringkasan Order"

  @edge @priority-high @REQ-002 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-023 — Login user sama pada perangkat lain tetap memakai kuota yang sama
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "U-A sudah penuh melalui perangkat A dan login ulang di perangkat B."
    Then sistem menampilkan "disabled karena kuota penuh" pada elemen "cari-jadwal / Pilih"
    And sistem menampilkan "Kuota terikat U-A bukan perangkat/session ID; perangkat B tetap ditolak." pada elemen "cari-jadwal / Pesan Batas"

  @edge @priority-high @REQ-009 @screen-isi-data
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-024 — Batal dari Isi Data membebaskan reservasi yang belum menjadi order pending
    Given user berada di halaman "Isi Data"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=1; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Reservasi draft O-1 aktif; belum lanjut pembayaran."
    When user mengklik tombol atau link "isi-data / Batal"
    Then sistem menampilkan "SISA 2 DARI 2 setelah pelepasan draft" pada elemen "cari-jadwal / Kuota Rute"

  @edge @priority-high @REQ-010 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-025 — Expired tepat pada timestamp batas melepaskan satu reservasi
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=1; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Semula R=2; O-1 expiry tepat 12:00 sekarang dan O-2 masih valid."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengisi field "cari-jadwal / Jumlah Tiket" dengan "1"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "O-1 Expired pada >=expiry; satu order pengganti diterima; pelepasan tepat satu kali." pada elemen "isi-data / Kuota Rute"

  @edge @priority-high @REQ-010 @screen-detail-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-026 — Pembayaran bersamaan expiry memilih satu status terminal yang konsisten
    Given user berada di halaman "Detail Order"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=1; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Callback sukses dan job expiry O-1 berjalan paralel pada expiry."
    When user mengklik tombol atau link "detail-order / Bayar Sekarang"
    Then sistem menampilkan "Satu hasil terminal konsisten sesuai urutan commit" pada elemen "detail-order / Status Order"

  @edge @priority-high @REQ-004 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-027 — Menurunkan batas tidak membatalkan pembayaran atau reservasi sah
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "U-A memiliki C=1,R=1 sebelum L turun dari 2 ke 1."
    When user mengisi field "batas-order / Batas Order Selesai per Rute" dengan "1"
    And user mengklik tombol atau link "batas-order / Simpan Pengaturan"
    Then sistem menampilkan "Menampilkan selisih nilai lama dan nilai baru" pada elemen "konfirmasi-pengaturan / Ringkasan Perubahan"
    When user mengklik tombol atau link "konfirmasi-pengaturan / Simpan"
    Then sistem menampilkan "Admission baru ditolak; order selesai tetap sah; reservasi lama boleh dibayar; tidak ada Dibatalkan Sistem." pada elemen "batas-order / Simpan Pengaturan"

  @edge @priority-high @REQ-019 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-028 — Nonaktif di antara Pilih dan Pesan memakai setting terbaru
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "User sudah membuka tabel jadwal; C=2 sebelum Pesan."
    When user memilih opsi "Nonaktif" pada "batas-order / Status Pembatasan"
    And user mengklik tombol atau link "batas-order / Simpan Pengaturan"
    Then sistem menampilkan "Menampilkan selisih nilai lama dan nilai baru" pada elemen "konfirmasi-pengaturan / Ringkasan Perubahan"
    When user mengklik tombol atau link "konfirmasi-pengaturan / Simpan"
    Then sistem menampilkan "Pesan membaca Nonaktif terbaru dan menerima order meskipun C=2." pada elemen "batas-order / Simpan Pengaturan"

  @edge @priority-high @REQ-024 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-029 — Batal edit kontak menjaga data publik lama
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Operator/pelabuhan lain memiliki kontak berbeda untuk memeriksa isolasi."
    When user mengisi field "ubah-kontak / No. WhatsApp" dengan "081234567890"
    And user mengklik tombol atau link "ubah-kontak / Batal"
    Then sistem menampilkan "WA tetap 081254012233" pada elemen "kontak-cabang / Tabel Pelabuhan"

  @edge @priority-high @REQ-022 @screen-operator-aktif
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-030 — Daftar operator kosong tidak membuka kontak operator sembarang
    Given user berada di halaman "Operator Aktif"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Tidak ada operator aktif; OP-X nonaktif tetap memiliki data historis."
    Then sistem menampilkan "State kosong tanpa operator nonaktif atau data lintas operator" pada elemen "operator-aktif / Daftar Operator"

  @edge @priority-high @REQ-023 @screen-kontak-cabang
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-031 — Operator tanpa trayek menampilkan daftar pelabuhan kosong
    Given user berada di halaman "Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "OP-A aktif namun belum memiliki Master Trayek."
    When user mengklik tombol atau link "kontak-cabang / Filter"
    And user memilih opsi "10" pada "kontak-cabang / Menampilkan Data"
    Then sistem menampilkan "Kosong; tidak ada pelabuhan buatan/manual" pada elemen "kontak-cabang / Tabel Pelabuhan"

  @edge @priority-high @REQ-024 @screen-kontak-cabang
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-032 — Pelabuhan belum disetting diberi indikator lalu dapat diisi
    Given user berada di halaman "Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "OP-A/PAP ada di Master Trayek tetapi belum memiliki kontak."
    Then sistem menampilkan "Indikator terlihat untuk PAP" pada elemen "kontak-cabang / Belum Disetting"
    When user mengklik tombol atau link "kontak-cabang / Ubah kontak"
    And user mengisi field "ubah-kontak / Alamat" dengan "Pelabuhan Parepare"
    And user mengisi field "ubah-kontak / No. WhatsApp" dengan "081355667788"
    And user mengisi field "ubah-kontak / Email Cabang" dengan "pap@example.test"
    And user mengklik tombol atau link "ubah-kontak / Pilih Semua"
    And user mencentang checkbox "ubah-kontak / Buka 24 Jam"
    And user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "PAP memiliki kontak lengkap; Belum Disetting hilang" pada elemen "kontak-cabang / Tabel Pelabuhan"

  @edge @priority-high @REQ-034 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-033 — Sisa nol akibat reservasi tidak menampilkan dua slot tersedia
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=2; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    Then sistem menampilkan "BATAS TERCAPAI karena dua reservasi; penghitung selesai C=0" pada elemen "cari-jadwal / Kuota Rute"

  @negative @priority-high @REQ-011 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-058 — Gagal membaca kuota tidak membuat order tanpa validasi
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Layanan pembacaan kuota gagal sementara; C aktual tidak diketahui UI."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    Then sistem menampilkan "Error sementara; tidak membuat order/reservasi" pada elemen "cari-jadwal / Pesan Batas"

  @negative @priority-high @REQ-033 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-059 — Gagal simpan setting menjaga data lama dan menampilkan error
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Persistensi setting gagal saat konfirmasi."
    When user mengisi field "batas-order / Batas Order Selesai per Rute" dengan "5"
    And user mengklik tombol atau link "batas-order / Simpan Pengaturan"
    And user mengklik tombol atau link "konfirmasi-pengaturan / Simpan"
    Then sistem menampilkan "Error penyimpanan, draft dapat dicoba ulang" pada elemen "batas-order / Simpan Pengaturan"

  @negative @priority-high @REQ-024 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-NEG-060 — Gagal simpan kontak tidak menulis sebagian field
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "Persistensi gagal setelah validasi."
    When user mengisi field "ubah-kontak / No. WhatsApp" dengan "081234567890"
    And user mengisi field "ubah-kontak / Alamat" dengan "Alamat baru"
    And user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "Gagal simpan, data tersimpan tetap baseline" pada elemen "ubah-kontak / Validasi Kontak"

  @stress @priority-high @REQ-009 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-001 — Seratus tab memperebutkan satu slot terakhir secara serentak
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=1, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Harness menjalankan 100 sesi/tab user U-A, rute yang sama, barrier pada Pesan."
    When user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Tepat 1 admission sukses dan 99 penolakan; C=1,R=1" pada elemen "isi-data / Ringkasan Order"

  @stress @priority-high @REQ-012 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-002 — Seribu request next step memakai pengecekan atomik terbaru
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "1000 request dalam 10 gelombang; state berubah oleh payment/expiry di antaranya."
    When user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Pada setiap commit aktif, admission memenuhi C+R≤L" pada elemen "cari-jadwal / Kuota Rute"

  @stress @priority-high @REQ-002 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-003 — Lima ratus user pada sepuluh rute memiliki kuota terisolasi
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "500 user × 10 rute × 3 permintaan, L=2 per pasangan; tidak ada payment/expiry selama load."
    When user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Tiap pasangan 2 sukses dan 1 ditolak; total 10000 admission sah" pada elemen "cari-jadwal / Kuota Rute"

  @stress @priority-high @REQ-003 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-004 — Permintaan pergi pulang paralel mempertahankan kuota masing-masing arah
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "100 request pergi dan 100 request pulang dari user sama, tanpa payment/expiry."
    When user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Dua admission per arah; total empat reservasi" pada elemen "cari-jadwal / Kuota Rute"

  @stress @priority-high @REQ-006 @screen-detail-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-005 — Seribu callback pembayaran duplikat tidak menggandakan kuota tiket atau debit
    Given user berada di halaman "Detail Order"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=1; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "1000 callback O-1 sukses dikirim dengan concurrency 100."
    When user mengklik tombol atau link "detail-order / Bayar Sekarang"
    Then sistem menampilkan "Satu Order Selesai, C=1,R=0; satu tiket order terbit" pada elemen "detail-order / Status Order"

  @stress @priority-high @REQ-008 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-006 — Lima ratus callback refund expiry berulang tidak menurunkan kuota negatif
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=1, R=1; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "C awal 2,R awal 2; satu paid order refund dan satu pending expired; masing-masing event diulang 500 kali."
    Then sistem menampilkan "C akhir 1,R akhir 1, bukan negatif" pada elemen "cari-jadwal / Kuota Rute"

  @stress @priority-high @REQ-016 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-007 — Reset WIB serentak pada lima ribu kombinasi user rute
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-09T00:00:00+07:00."
    And kondisi uji "500 user ×10 rute penuh sebelum tengah malam; 1000 admission tepat sesudah reset, pasangan berbeda."
    When user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "C baru nol pada 5000 pasangan; 1000 admission setelah reset sah" pada elemen "cari-jadwal / Kuota Rute"

  @stress @priority-high @REQ-001 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-008 — Channel Cabang Agen tetap dapat membeli saat publik penuh di bawah load
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "100 transaksi Cabang,100 Agen,100 publik pada user/rute yang sama."
    When user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "200 channel exempt diterima; 100 publik ditolak" pada elemen "cari-jadwal / Kuota Rute"

  @stress @priority-high @REQ-019 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-009 — Nonaktif tidak membatasi seratus order publik sah
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Nonaktif, batas 2; user U-A, rute BPN → PAP; C=50, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "100 order berbeda dibuat/dibayar tanpa pembatasan lain."
    When user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "TANPA BATAS; 100 order diterima" pada elemen "cari-jadwal / Kuota Rute"

  @stress @priority-high @REQ-021 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-010 — Seratus perubahan setting konkuren memiliki histori dan state atomik
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "100 perubahan valid oleh dua actor; setiap request mengubah limit serta pesan unik agar draft dirty; hasil sukses atau konflik ditentukan commit server."
    When user mengisi field "batas-order / Batas Order Selesai per Rute" dengan "3"
    And user mengisi field "batas-order / Pesan Saat Batas Tercapai" dengan "Pesan uji commit 001"
    And user mengklik tombol atau link "batas-order / Simpan Pengaturan"
    And user mengklik tombol atau link "konfirmasi-pengaturan / Simpan"
    And user mengklik tombol atau link "batas-order / Lihat Riwayat Perubahan"
    Then sistem menampilkan "Setiap commit sukses punya actor/time/nilai yang utuh; konflik tidak punya histori sukses" pada elemen "riwayat-perubahan / Tabel Riwayat"

  @stress @priority-high @REQ-024 @screen-ubah-kontak
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-011 — Lima ratus kontak lintas operator tidak saling menimpa
    Given user berada di halaman "Ubah Kontak Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Admin memilih OP-A dari operator aktif dan membuka Ubah kontak BPN; kontak baseline valid."
    And kondisi uji "10 operator ×50 port, setiap kontak memakai nomor/alamat unik; perubahan 500 kontak secara paralel."
    When user mengisi field "ubah-kontak / No. WhatsApp" dengan "0810000000001"
    And user mengisi field "ubah-kontak / Alamat" dengan "Alamat OP-01 PORT-01"
    And user mengklik tombol atau link "ubah-kontak / Simpan"
    Then sistem menampilkan "500 kontak sesuai key operator+port setelah reload" pada elemen "kontak-cabang / Tabel Pelabuhan"

  @stress @priority-high @REQ-020 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-012 — Pesan panjang sepuluh ribu karakter tidak menyebabkan truncation diam-diam
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Payload 10000 karakter; maksimum produk belum dispesifikasikan. Harness menekan Simpan pada konfirmasi hanya jika validasi awal mengizinkan; jika ditolak sebelum dialog, verifikasi error eksplisit."
    When user mengisi field "batas-order / Pesan Saat Batas Tercapai" dengan "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    And user mengklik tombol atau link "batas-order / Simpan Pengaturan"
    Then sistem menampilkan "Simpan utuh jika diizinkan, atau tolak dengan validasi panjang eksplisit tanpa mengubah pesan lama" pada elemen "batas-order / Pesan Saat Batas Tercapai"

  @stress @priority-high @REQ-011 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-013 — Kuota lambat dan timeout tidak memicu admission ganda saat retry
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "100 request diinjeksi delay 5 detik; separuh timeout klien dan retry key yang sama."
    When user mengklik tombol atau link "cari-jadwal / Pilih"
    And user mengklik tombol atau link "cari-jadwal / Pesan"
    Then sistem menampilkan "Tidak lebih dari dua reservasi; retry tidak menggandakan order" pada elemen "cari-jadwal / Kuota Rute"

  @stress @priority-high @REQ-031 @screen-hubungi-cabang
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-014 — Seribu buka dialog kontak selama kontak diperbarui tidak mencampur operator
    Given user berada di halaman "Hubungi Kantor Cabang"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "1000 pembacaan dialog untuk 10 operator dan 50 rute; update kontak berlangsung paralel."
    Then sistem menampilkan "Asal selalu sesuai operator/port pencarian" pada elemen "hubungi-cabang / Kontak Asal"
    And sistem menampilkan "Tujuan selalu sesuai operator/port pencarian" pada elemen "hubungi-cabang / Kontak Tujuan"
    When user mengklik tombol atau link "hubungi-cabang / Tutup"
    Then sistem menampilkan "Setiap field kontak milik key yang benar, tanpa cache silang; reload akhirnya membaca update terbaru." pada elemen "hubungi-cabang / Tutup"

  @stress @priority-high @REQ-035 @screen-daftar-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-STR-015 — Daftar order seribu record dapat dibuka tanpa mengubah kuota
    Given user berada di halaman "Daftar Order"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=2, R=0; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "1000 record historis dengan status campuran; dua Selesai hari ini pada rute yang dipilih."
    When user memilih opsi "50" pada "daftar-order / Menampilkan Data"
    And user mengklik tombol atau link "daftar-order / Filter"
    Then sistem menampilkan "Record sesuai filter/pagination; status dan jumlah tiket utuh" pada elemen "daftar-order / Tabel Order"
    When user mengklik tombol atau link "daftar-order / Data Tiket"
    Then sistem menampilkan "Pembacaan/pagination tidak memutasi C/R; order historis tidak dihitung sebagai order hari ini." pada elemen "daftar-order / Data Tiket"

  @edge @priority-high @REQ-034 @screen-batas-order
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-EDG-034 — Periode dan tabel penolakan tampil tanpa mengubah setting
    Given user berada di halaman "Batas Order User Umum"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi Admin; setting lama Aktif, batas 2, pesan Batas pembelian pada trayek ini sudah tercapai, silakan hubungi Kantor Cabang terdekat; baseline histori disimpan."
    And kondisi uji "Tidak ada perubahan setting lain selama scenario."
    Then sistem menampilkan "Per hari kalender (reset 00:00 WIB)" pada elemen "batas-order / Periode Perhitungan"
    And sistem menampilkan "Kolom Tanggal,Rute,Jumlah Penolakan,User Unik terlihat" pada elemen "batas-order / Order Ditolak 7 Hari"

  @positive @priority-high @REQ-009 @screen-isi-data
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-047 — Isi data pembeli dan lanjut pembayaran mempertahankan satu reservasi
    Given user berada di halaman "Isi Data"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=1; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "O-1 mempunyai reservasi sah; data penumpang/kendaraan eksisting valid."
    When user mengisi field "isi-data / Nama Pembeli" dengan "Pengguna Uji"
    And user mengisi field "isi-data / Email Pembeli" dengan "user@example.test"
    And user mengisi field "isi-data / Nomor HP" dengan "081234567890"
    And user mengklik tombol atau link "isi-data / Lanjutkan Pembayaran"
    Then sistem menampilkan "Menunggu Pembayaran; C=0,R=1" pada elemen "detail-order / Status Order"

  @positive @priority-high @REQ-035 @screen-cari-jadwal
  Scenario: RO320-PEMBATASAN-ORDER-UNTUK-USER-UMUM-POS-048 — Navigasi menu Daftar Order dan Bayar Sekarang membuka order pending sah
    Given user berada di halaman "Cari Jadwal"
    And kondisi uji "Data uji terisolasi; sesi dan jam server disiapkan oleh harness TMS, bukan kontrol PROTOTIPE."
    And kondisi uji "Sesi User Umum, channel online-publik; setting Aktif, batas 2; user U-A, rute BPN → PAP; C=0, R=1; jam server 2026-10-08T12:00:00+07:00."
    And kondisi uji "Jadwal tersedia dan data pembeli valid; tidak ada batas lain yang menghalangi."
    When user mengklik tombol atau link "cari-jadwal / Daftar Order"
    And user mengklik tombol atau link "daftar-order / Bayar Sekarang"
    Then sistem menampilkan "Pembayaran order pending berreservasi sah tersedia" pada elemen "detail-order / Status Order"

