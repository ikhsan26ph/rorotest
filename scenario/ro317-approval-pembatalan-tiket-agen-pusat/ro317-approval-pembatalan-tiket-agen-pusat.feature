Feature: Approval pembatalan tiket Agen dan Cabang oleh Kantor Pusat
  Spesifikasi RO317 dengan snapshot denda dan empat status pengajuan.
  Fixture/clock/fault/paralel mengikuti testData JSON dan Assumptions Log analysis.

  @positive @priority-high @REQ-001 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-001 — Pengajuan Cabang diarahkan ke approval Pusat
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible milik unit; belum memiliki pengajuan."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "Permintaan penumpang"
    And user mengklik tombol "Ajukan Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Toast" dengan kondisi "pengajuan terkirim ke Kantor Pusat"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Menunggu Approval"
    And sistem memverifikasi elemen "Status Tiket" dengan kondisi "aktif"
    And sistem memverifikasi elemen "Status Refund" dengan kondisi "belum diproses"

  @positive @priority-high @REQ-001 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-002 — Pengajuan Agen diarahkan ke approval Pusat
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible milik unit; belum memiliki pengajuan."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "Permintaan penumpang"
    And user mengklik tombol "Batalkan Tiket"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Toast" dengan kondisi "pengajuan terkirim ke Kantor Pusat"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Menunggu Approval"
    And sistem memverifikasi elemen "Status Tiket" dengan kondisi "aktif"
    And sistem memverifikasi elemen "Status Refund" dengan kondisi "belum diproses"

  @positive @priority-high @REQ-002 @screen-master-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-003 — Pusat membuka menu baru dan mengedit master
    Given user berada di halaman "Master Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Master V1 tersedia."
    When user mengklik tombol "Master Denda Pembatalan"
    Then sistem memverifikasi elemen "Tabel Denda" dengan kondisi "H-3=25%; H-2=50%; H-1=75%"
    When user mengklik tombol "Setting"
    And user mengisi field "Denda" dengan "30"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Toast" dengan kondisi "master tersimpan"
    And sistem memverifikasi elemen "Tabel Denda" dengan kondisi "H-3=30%"

  @positive @priority-high @REQ-002 @screen-master-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-004 — Cabang membaca master tanpa kontrol setting
    Given user berada di halaman "Master Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Master V1 tersedia."
    When user mengklik tombol "Master Denda Pembatalan"
    Then sistem memverifikasi elemen "Tabel Denda" dengan kondisi "H-3=25%; H-2=50%; H-1=75%"
    And sistem memverifikasi elemen "Setting" dengan kondisi "tidak terlihat"
    And sistem memverifikasi elemen "Keterangan Snapshot" dengan kondisi "perubahan berlaku untuk pengajuan baru"

  @positive @priority-high @REQ-003 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-005 — Denda kedua kanal identik pada harga dan waktu sama
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Dua sesi Cabang/Agen; tiket berbeda, harga/waktu/rule identik."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "Cabang denda Rp100.000 / 25%"
    When user berada di halaman "Buat Pembatalan Tiket" dengan konteks "sesi Agen"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-TA0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "Agen denda Rp100.000 / 25%; sama dengan Cabang"

  @positive @priority-high @REQ-004 @screen-edit-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-006 — Pusat menyimpan rule H-3 Hari
    Given user berada di halaman "Edit Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Modal rule dibuka melalui Setting; rule tidak overlap setelah update."
    When user mengisi field "Jenis Denda" dengan "Rule H-3 Hari"
    And user memilih opsi "H-" pada field "Arah Waktu"
    And user mengisi field "Range Waktu" dengan "3"
    And user memilih opsi "Hari" pada field "Satuan Waktu"
    And user memilih opsi "Persen" pada field "Tipe Denda"
    And user mengisi field "Denda" dengan "25"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Tabel Denda" dengan kondisi "nama dan range H-3 Hari; denda 25% tersimpan"

  @positive @priority-high @REQ-004 @screen-edit-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-007 — Pusat menyimpan rule H-72 Jam
    Given user berada di halaman "Edit Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Modal rule dibuka melalui Setting; rule tidak overlap setelah update."
    When user mengisi field "Jenis Denda" dengan "Rule H-72 Jam"
    And user memilih opsi "H-" pada field "Arah Waktu"
    And user mengisi field "Range Waktu" dengan "72"
    And user memilih opsi "Jam" pada field "Satuan Waktu"
    And user memilih opsi "Persen" pada field "Tipe Denda"
    And user mengisi field "Denda" dengan "25"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Tabel Denda" dengan kondisi "nama dan range H-72 Jam; denda 25% tersimpan"

  @positive @priority-high @REQ-004 @screen-edit-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-008 — Pusat menyimpan rule H+3 Hari
    Given user berada di halaman "Edit Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Modal rule dibuka melalui Setting; rule tidak overlap setelah update."
    When user mengisi field "Jenis Denda" dengan "Rule H+3 Hari"
    And user memilih opsi "H+" pada field "Arah Waktu"
    And user mengisi field "Range Waktu" dengan "3"
    And user memilih opsi "Hari" pada field "Satuan Waktu"
    And user memilih opsi "Persen" pada field "Tipe Denda"
    And user mengisi field "Denda" dengan "25"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Tabel Denda" dengan kondisi "nama dan range H+3 Hari; denda 25% tersimpan"

  @positive @priority-high @REQ-004 @screen-edit-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-009 — Pusat menyimpan rule H+72 Jam
    Given user berada di halaman "Edit Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Modal rule dibuka melalui Setting; rule tidak overlap setelah update."
    When user mengisi field "Jenis Denda" dengan "Rule H+72 Jam"
    And user memilih opsi "H+" pada field "Arah Waktu"
    And user mengisi field "Range Waktu" dengan "72"
    And user memilih opsi "Jam" pada field "Satuan Waktu"
    And user memilih opsi "Persen" pada field "Tipe Denda"
    And user mengisi field "Denda" dengan "25"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Tabel Denda" dengan kondisi "nama dan range H+72 Jam; denda 25% tersimpan"

  @positive @priority-high @REQ-005 @screen-master-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-010 — Default baru tepat dan nilai dapat diubah Pusat
    Given user berada di halaman "Master Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Master belum diubah sejak inisialisasi."
    And sistem memverifikasi elemen "Tabel Denda" dengan kondisi "H-3=25%; H-2=50%; H-1=75%"
    When user mengklik tombol "Setting"
    And user mengisi field "Denda" dengan "40"
    And user mengklik tombol "Simpan"
    And user berada di halaman "Master Denda Pembatalan" dengan konteks "reload"
    Then sistem memverifikasi elemen "Tabel Denda" dengan kondisi "H-3=40%; H-2=50%; H-1=75%; perubahan persisten"

  @positive @priority-high @REQ-006 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-011 — Fallback batas terjauh untuk H-5
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture tiket eligible pada waktu uji; master arah terkait lengkap."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 25% = Rp100,000; memakai rule terjauh, bukan nol"

  @positive @priority-high @REQ-006 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-012 — Fallback batas terjauh untuk H+5
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture tiket eligible pada waktu uji; master arah terkait lengkap."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 60% = Rp240,000; memakai rule terjauh, bukan nol"

  @positive @priority-high @REQ-007 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-013 — Pembuatan menyimpan snapshot 25 persen sebelum approval terlambat
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Pengajuan dibuat H-3, kemudian fixture memajukan jam approval ke H-1."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "Permintaan penumpang"
    And user mengklik tombol "Ajukan Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    And user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks "sesi Pusat; jam approvalAt"
    Then sistem memverifikasi elemen "Keterangan Snapshot" dengan kondisi "25% dikunci saat pengajuan"
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "Setujui Pembatalan; tiket QA-T0001-001; refund Rp300.000"
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda Rp100.000; refund Rp300.000"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "snapshot 25%, Rp100.000, waktu pengajuan H-3"

  @positive @priority-high @REQ-008 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-014 — Master baru tidak mengubah pengajuan Menunggu
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Menunggu dengan V1 25%; master sekarang V2 60%."
    And sistem memverifikasi elemen "Keterangan Snapshot" dengan kondisi "nilai dikunci saat diajukan"
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "Setujui Pembatalan; tiket QA-T0001-001; refund Rp300.000"
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "25%; denda Rp100.000; refund Rp300.000"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "refund memakai snapshot V1"

  @positive @priority-high @REQ-008 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-015 — Pengajuan baru memakai versi master terbaru
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible; master V2 H-3=60%."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "Permintaan penumpang"
    And user mengklik tombol "Batalkan Tiket"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 60% = Rp240.000; refund Rp160.000"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Menunggu Approval"

  @positive @priority-high @REQ-009 @screen-edit-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-016 — Persentase valid 75 tersimpan
    Given user berada di halaman "Edit Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Modal edit rule terbuka."
    When user mengisi field "Denda" dengan "75"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Tabel Denda" dengan kondisi "rule terpilih 75%"
    And sistem memverifikasi elemen "Validasi Denda" dengan kondisi "tidak terlihat"

  @positive @priority-high @REQ-010 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-017 — Kantor Cabang mengirim tanpa alasan pembatalan
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible; alasan tidak required."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan ""
    And user mengklik tombol "Ajukan Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Menunggu Approval"
    And sistem memverifikasi elemen "Detail Pengajuan" dengan kondisi "alasan kosong diterima"
    And sistem memverifikasi elemen "Toast" dengan kondisi "pengajuan terkirim"

  @positive @priority-high @REQ-010 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-018 — Agen mengirim tanpa alasan pembatalan
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible; alasan tidak required."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan ""
    And user mengklik tombol "Batalkan Tiket"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Menunggu Approval"
    And sistem memverifikasi elemen "Detail Pengajuan" dengan kondisi "alasan kosong diterima"
    And sistem memverifikasi elemen "Toast" dengan kondisi "pengajuan terkirim"

  @positive @priority-high @REQ-011 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-019 — Pengajuan sukses tampil di antrean dengan tiket aktif
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket aktif, belum ada pengajuan."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "Permintaan penumpang"
    And user mengklik tombol "Ajukan Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    And user berada di halaman "Pembatalan Tiket" dengan konteks "sesi Kantor Pusat"
    And user mengklik tombol "Penjualan Cabang"
    And user mengklik tombol "Menunggu Approval"
    Then sistem memverifikasi elemen "Tabel Pengajuan" dengan kondisi "pengajuan baru muncul sekali di Menunggu"
    And sistem memverifikasi elemen "Status Tiket" dengan kondisi "aktif"
    And sistem memverifikasi elemen "Status Refund" dengan kondisi "belum diproses"

  @positive @priority-high @REQ-012 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-020 — Pilihan tiket hanya memuat tiket tanpa pengajuan Menunggu
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-T0001-001 Menunggu; QA-T0002-001 eligible tanpa pengajuan."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0002-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "ID Tiket" dengan kondisi "QA-T0001-001 tidak ada; QA-T0002-001 terpilih"
    And sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "kalkulasi QA-T0002-001"

  @positive @priority-high @REQ-013 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-021 — Pengajuan baru setelah Approval Ditolak menghitung ulang
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Pengajuan lama Approval Ditolak, snapshot 25%; tiket masih eligible; sekarang H-2 dan master V2 H-2=60%."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "Permintaan penumpang"
    And user mengklik tombol "Ajukan Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "pengajuan baru Menunggu Approval; ID baru berbeda"
    And sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda Rp240.000; refund Rp160.000"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "pengajuan lama tetap Approval Ditolak / 25%; snapshot baru V2 60%"

  @positive @priority-high @REQ-013 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-022 — Pengajuan baru setelah Pengajuan Dibatalkan menghitung ulang
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Pengajuan lama Pengajuan Dibatalkan, snapshot 25%; tiket masih eligible; sekarang H-2 dan master V2 H-2=60%."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "Permintaan penumpang"
    And user mengklik tombol "Ajukan Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "pengajuan baru Menunggu Approval; ID baru berbeda"
    And sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda Rp240.000; refund Rp160.000"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "pengajuan lama tetap Pengajuan Dibatalkan / 25%; snapshot baru V2 60%"

  @positive @priority-high @REQ-014 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-023 — Pilihan jadwal dan tiket eligible menampilkan pembeli penumpang
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket dibayar/aktif/milik unit/belum boarding; fixture buyer=QA Pembeli."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-21"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Detail Jadwal" dengan kondisi "QA-J01; Balikpapan–Parepare; departureAt WITA"
    And sistem memverifikasi elemen "Detail Pembeli Tiket" dengan kondisi "QA Pembeli; identitas/kontak/metode bayar sesuai fixture"
    And sistem memverifikasi elemen "Detail Penumpang" dengan kondisi "QA Penumpang; ID QA-T0001-001; Belum Check in"
    And sistem memverifikasi elemen "Ajukan Pembatalan" dengan kondisi "enabled"

  @positive @priority-high @REQ-015 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-024 — Kantor Cabang menarik pengajuan Menunggu sendiri
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 milik user/unit; Menunggu."
    When user mengklik tombol "Batalkan Pengajuan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "Batalkan Pengajuan; tiket tetap aktif"
    When user mengklik tombol "Batalkan Pengajuan"
    Then sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Pengajuan Dibatalkan"
    And sistem memverifikasi elemen "Status Tiket" dengan kondisi "aktif"
    And sistem memverifikasi elemen "Status Refund" dengan kondisi "belum diproses"
    And sistem memverifikasi elemen "Riwayat" dengan kondisi "Pengajuan dibatalkan pengaju dengan aktor/waktu benar"

  @positive @priority-high @REQ-015 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-025 — Agen menarik pengajuan Menunggu sendiri
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 milik user/unit; Menunggu."
    When user mengklik tombol "Batalkan Pengajuan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "Batalkan Pengajuan; tiket tetap aktif"
    When user mengklik tombol "Batalkan Pengajuan"
    Then sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Pengajuan Dibatalkan"
    And sistem memverifikasi elemen "Status Tiket" dengan kondisi "aktif"
    And sistem memverifikasi elemen "Status Refund" dengan kondisi "belum diproses"
    And sistem memverifikasi elemen "Riwayat" dengan kondisi "Pengajuan dibatalkan pengaju dengan aktor/waktu benar"

  @positive @priority-high @REQ-016 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-026 — Pusat membaca antrean Menunggu dari Cabang
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Dua pengajuan Cabang: satu Menunggu, satu Disetujui."
    When user mengklik tombol "Penjualan Cabang"
    And user mengklik tombol "Menunggu Approval"
    And user mengklik tombol "Lihat detail"
    Then sistem memverifikasi elemen "Detail Pengajuan" dengan kondisi "ID QA-P0001; kanal Cabang"
    And sistem memverifikasi elemen "Setujui Pembatalan" dengan kondisi "terlihat"
    And sistem memverifikasi elemen "Tolak" dengan kondisi "terlihat"

  @positive @priority-high @REQ-016 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-027 — Pusat membaca antrean Menunggu dari Agen
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Dua pengajuan Agen: satu Menunggu, satu Disetujui."
    When user mengklik tombol "Penjualan Agen"
    And user mengklik tombol "Menunggu Approval"
    And user mengklik tombol "Lihat detail"
    Then sistem memverifikasi elemen "Detail Pengajuan" dengan kondisi "ID QA-P0001; kanal Agen"
    And sistem memverifikasi elemen "Setujui Pembatalan" dengan kondisi "terlihat"
    And sistem memverifikasi elemen "Tolak" dengan kondisi "terlihat"

  @positive @priority-high @REQ-017 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-028 — Detail memuat seluruh data approval dan nilai snapshot
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Menunggu; data berbeda jelas dari QA-P0002."
    And sistem memverifikasi elemen "Detail Jadwal" dengan kondisi "rute, kapal/voyage, waktu WITA sesuai QA-J01"
    When user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks "reload untuk memverifikasi state"
    Then sistem memverifikasi elemen "Detail Pengajuan" dengan kondisi "QA-P0001; QA-T0001-001; pengaju QA Cabang / CB-BPN-01; alasan Permintaan penumpang"
    And sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "harga Rp400.000; denda 25% Rp100.000; estimasi refund Rp300.000"
    And sistem memverifikasi elemen "Riwayat" dengan kondisi "pengajuan QA-P0001 beserta aktor dan waktu"

  @positive @priority-high @REQ-018 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-029 — Histori menyimpan keputusan tanpa langkah penerbitan tiket
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Pengajuan sudah Disetujui; histori backend memiliki pengajuan, approval dan event penerbitan."
    And sistem memverifikasi elemen "Riwayat" dengan kondisi "pengajuan dikirim dan approval disetujui; aktor/waktu benar"
    When user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks "reload untuk memverifikasi state"
    Then sistem memverifikasi elemen "Riwayat" dengan kondisi "tidak memuat Tiket Diterbitkan; pengajuan/approval tidak terhapus"

  @positive @priority-high @REQ-019 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-030 — Pusat menyetujui Cabang dan memproses refund snapshot
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Cabang Menunggu; denda Rp100.000."
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "Setujui Pembatalan; tiket QA-T0001-001; refund Rp300.000"
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Approval Disetujui"
    And sistem memverifikasi elemen "Status Tiket" dengan kondisi "dibatalkan"
    And sistem memverifikasi elemen "Status Refund" dengan kondisi "Rp300.000 ke unit pemilik sekali"
    And sistem memverifikasi elemen "Riwayat" dengan kondisi "approval oleh Kantor Pusat; waktu benar"

  @positive @priority-high @REQ-019 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-031 — Pusat menyetujui Agen dan memproses refund snapshot
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Agen Menunggu; denda Rp100.000."
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "Setujui Pembatalan; tiket QA-T0001-001; refund Rp300.000"
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Approval Disetujui"
    And sistem memverifikasi elemen "Status Tiket" dengan kondisi "dibatalkan"
    And sistem memverifikasi elemen "Status Refund" dengan kondisi "Rp300.000 ke unit pemilik sekali"
    And sistem memverifikasi elemen "Riwayat" dengan kondisi "approval oleh Kantor Pusat; waktu benar"

  @positive @priority-high @REQ-020 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-032 — Pengajuan Disetujui tetap final setelah reload
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 sudah Disetujui; tiket batal; satu refund Rp300.000."
    When user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks "reload"
    Then sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Approval Disetujui"
    And sistem memverifikasi elemen "Setujui Pembatalan" dengan kondisi "tidak terlihat"
    And sistem memverifikasi elemen "Tolak" dengan kondisi "tidak terlihat"
    And sistem memverifikasi elemen "Batalkan Pengajuan" dengan kondisi "tidak terlihat"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "satu approval dan satu refund; nilai immutable"

  @positive @priority-high @REQ-021 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-033 — Pusat menolak Cabang dan pengaju melihat alasannya
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Menunggu."
    When user mengklik tombol "Tolak"
    And user mengisi field "Alasan Penolakan" dengan "Dokumen pendukung tidak dilampirkan"
    And user mengklik tombol "Tolak Pengajuan"
    And user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks "sesi Kantor Cabang"
    Then sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Approval Ditolak"
    And sistem memverifikasi elemen "Status Tiket" dengan kondisi "aktif"
    And sistem memverifikasi elemen "Status Refund" dengan kondisi "belum diproses"
    And sistem memverifikasi elemen "Banner Alasan Penolakan" dengan kondisi "Dokumen pendukung tidak dilampirkan"

  @positive @priority-high @REQ-021 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-034 — Pusat menolak Agen dan pengaju melihat alasannya
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Menunggu."
    When user mengklik tombol "Tolak"
    And user mengisi field "Alasan Penolakan" dengan "Dokumen pendukung tidak dilampirkan"
    And user mengklik tombol "Tolak Pengajuan"
    And user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks "sesi Agen"
    Then sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Approval Ditolak"
    And sistem memverifikasi elemen "Status Tiket" dengan kondisi "aktif"
    And sistem memverifikasi elemen "Status Refund" dengan kondisi "belum diproses"
    And sistem memverifikasi elemen "Banner Alasan Penolakan" dengan kondisi "Dokumen pendukung tidak dilampirkan"

  @positive @priority-high @REQ-022 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-035 — Pengajuan Ditolak tetap final setelah reload
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 sudah Ditolak; alasan Tidak eligible."
    When user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks "reload"
    Then sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Approval Ditolak"
    And sistem memverifikasi elemen "Setujui Pembatalan" dengan kondisi "tidak terlihat"
    And sistem memverifikasi elemen "Tolak" dengan kondisi "tidak terlihat"
    And sistem memverifikasi elemen "Riwayat" dengan kondisi "satu reject; alasan Tidak eligible persisten"

  @positive @priority-high @REQ-023 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-036 — Pusat membatalkan tiket Cabang langsung
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible milik Cabang tanpa pengajuan Menunggu."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengklik tombol "Batalkan Tiket"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "tiket QA-T0001-001; refund Rp300.000"
    When user mengklik tombol "Batalkan Tiket"
    Then sistem memverifikasi elemen "Status Tiket" dengan kondisi "dibatalkan langsung"
    And sistem memverifikasi elemen "Status Refund" dengan kondisi "Rp300.000 diproses sekali ke Cabang"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "tidak ada tahap Menunggu Approval tambahan"
    And sistem memverifikasi elemen "Riwayat" dengan kondisi "Tiket dibatalkan langsung oleh Kantor Pusat"

  @positive @priority-high @REQ-024 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-037 — Kantor Cabang melihat semua status pengajuan miliknya
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture unit sendiri memiliki empat pengajuan pada empat status."
    When user mengklik tombol "Semua"
    And user mengklik tombol "Lihat detail"
    And user mengklik tombol "Kembali"
    Then sistem memverifikasi elemen "Tabel Pengajuan" dengan kondisi "empat pengajuan unit sendiri; status sesuai fixture"
    And sistem memverifikasi elemen "Setujui pembatalan" dengan kondisi "tidak terlihat"
    And sistem memverifikasi elemen "Tolak pengajuan" dengan kondisi "tidak terlihat"

  @positive @priority-high @REQ-024 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-038 — Agen melihat semua status pengajuan miliknya
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture unit sendiri memiliki empat pengajuan pada empat status."
    When user mengklik tombol "Semua"
    And user mengklik tombol "Lihat detail"
    And user mengklik tombol "Kembali"
    Then sistem memverifikasi elemen "Tabel Pengajuan" dengan kondisi "empat pengajuan unit sendiri; status sesuai fixture"
    And sistem memverifikasi elemen "Setujui pembatalan" dengan kondisi "tidak terlihat"
    And sistem memverifikasi elemen "Tolak pengajuan" dengan kondisi "tidak terlihat"

  @positive @priority-high @REQ-024 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-039 — Cabang memantau pengajuan Agen dalam lingkup secara read-only
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 dari Agen terkait CB-BPN-01."
    When user mengklik tombol "Penjualan Agen"
    And user mengklik tombol "Lihat detail"
    Then sistem memverifikasi elemen "Keterangan Read-only" dengan kondisi "approval Agen diputuskan Pusat"
    And sistem memverifikasi elemen "Detail Pengajuan" dengan kondisi "pengajuan Agen dalam lingkup"
    And sistem memverifikasi elemen "Setujui Pembatalan" dengan kondisi "tidak terlihat"
    And sistem memverifikasi elemen "Tolak" dengan kondisi "tidak terlihat"
    And sistem memverifikasi elemen "Batalkan Pengajuan" dengan kondisi "tidak terlihat"

  @positive @priority-medium @REQ-025 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-040 — Filter ID pengaju tanggal dan Reset bekerja bersama
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Dataset 45 baris; hanya QA-P0001 cocok dengan seluruh filter."
    When user mengklik tombol "Filter"
    And user mengisi field "ID Pengajuan / ID Tiket" dengan "QA-P0001"
    And user mengisi field "Tanggal Pengajuan" dengan "2026-10-17"
    And user mengisi field "Pengaju" dengan "QA Cabang"
    And user mengklik tombol "Filter"
    Then sistem memverifikasi elemen "Tabel Pengajuan" dengan kondisi "tepat QA-P0001"
    When user mengklik tombol "Filter"
    And user mengklik tombol "Reset"
    And user memilih opsi "50" pada field "Ukuran Halaman"
    Then sistem memverifikasi elemen "Tabel Pengajuan" dengan kondisi "45 baris tanpa filter; tidak ada duplikasi"
    And sistem memverifikasi elemen "ID Pengajuan / ID Tiket" dengan kondisi "kosong"
    And sistem memverifikasi elemen "Tanggal Pengajuan" dengan kondisi "kosong"
    And sistem memverifikasi elemen "Pengaju" dengan kondisi "kosong"

  @positive @priority-medium @REQ-025 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-041 — Tab Semua memfilter status yang sesuai
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture empat pengajuan: tepat satu per status."
    When user mengklik tombol "Semua"
    Then sistem memverifikasi elemen "Tabel Pengajuan" dengan kondisi "hanya seluruh status; jumlah tepat 4"

  @positive @priority-medium @REQ-025 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-042 — Tab Menunggu Approval memfilter status yang sesuai
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture empat pengajuan: tepat satu per status."
    When user mengklik tombol "Menunggu Approval"
    Then sistem memverifikasi elemen "Tabel Pengajuan" dengan kondisi "hanya Menunggu Approval; jumlah tepat 1"

  @positive @priority-medium @REQ-025 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-043 — Tab Disetujui memfilter status yang sesuai
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture empat pengajuan: tepat satu per status."
    When user mengklik tombol "Disetujui"
    Then sistem memverifikasi elemen "Tabel Pengajuan" dengan kondisi "hanya Approval Disetujui; jumlah tepat 1"

  @positive @priority-medium @REQ-025 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-044 — Tab Ditolak memfilter status yang sesuai
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture empat pengajuan: tepat satu per status."
    When user mengklik tombol "Ditolak"
    Then sistem memverifikasi elemen "Tabel Pengajuan" dengan kondisi "hanya Approval Ditolak; jumlah tepat 1"

  @positive @priority-medium @REQ-025 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-045 — Tab Dibatalkan memfilter status yang sesuai
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture empat pengajuan: tepat satu per status."
    When user mengklik tombol "Dibatalkan"
    Then sistem memverifikasi elemen "Tabel Pengajuan" dengan kondisi "hanya Pengajuan Dibatalkan; jumlah tepat 1"

  @positive @priority-high @REQ-026 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-046 — Konfirmasi kirim dapat ditutup lalu dibuka ulang sebelum submit
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Form valid; belum ada pengajuan."
    When user mengklik tombol "Ajukan Pembatalan"
    And user mengklik tombol "Kembali"
    Then sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol pengajuan sebelum konfirmasi"
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "Permintaan penumpang"
    And user mengklik tombol "Ajukan Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "tertutup"
    And sistem memverifikasi elemen "Toast" dengan kondisi "sukses kirim"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "satu Menunggu Approval"

  @positive @priority-high @REQ-027 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-047 — Alasan penolakan valid disimpan dan ditrim
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Menunggu."
    When user mengklik tombol "Tolak"
    And user mengisi field "Alasan Penolakan" dengan "  Dokumen tidak sesuai  "
    And user mengklik tombol "Tolak Pengajuan"
    Then sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Approval Ditolak"
    And sistem memverifikasi elemen "Banner Alasan Penolakan" dengan kondisi "Dokumen tidak sesuai; spasi luar dihapus"
    And sistem memverifikasi elemen "Riwayat" dengan kondisi "alasan yang sama"

  @positive @priority-high @REQ-028 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-048 — Kalkulasi tipe Persen konsisten dengan refund
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture harga bayar Rp400.000; komisi/pass/diskon terpisah nol."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "harga 400000; denda 100000; refund 300000; harga=denda+refund"
    And sistem memverifikasi elemen "Denda" dengan kondisi "tidak dapat di-override pengguna"

  @positive @priority-high @REQ-028 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-049 — Kalkulasi tipe Rupiah konsisten dengan refund
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture harga bayar Rp400.000; komisi/pass/diskon terpisah nol."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "harga 400000; denda 50000; refund 350000; harga=denda+refund"
    And sistem memverifikasi elemen "Denda" dengan kondisi "tidak dapat di-override pengguna"

  @positive @priority-high @REQ-029 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-050 — Ganti Jadwal mereset tiket dan kalkulasi lama
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-J01/QA-T0001-001 dipilih; kalkulasi ada."
    When user mengklik tombol "Ganti Jadwal"
    Then sistem memverifikasi elemen "ID Tiket" dengan kondisi "kosong"
    And sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "kalkulasi lama tidak aktif"
    And sistem memverifikasi elemen "Ajukan Pembatalan" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Pilih Jadwal Kapal" dengan kondisi "kosong"

  @positive @priority-high @REQ-029 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-051 — Ubah Pencarian mereset tiket dan kalkulasi lama
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-J01/QA-T0001-001 dipilih; kalkulasi ada."
    When user mengklik tombol "Ubah Pencarian"
    Then sistem memverifikasi elemen "ID Tiket" dengan kondisi "kosong"
    And sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "kalkulasi lama tidak aktif"
    And sistem memverifikasi elemen "Ajukan Pembatalan" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Pilih Jadwal Kapal" dengan kondisi "QA-J01 tetap terpilih"

  @positive @priority-high @REQ-019 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-052 — Aksi row approve hanya memproses ID row terpilih
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 dan QA-P0002 Menunggu; tombol di-scope pada row QA-P0001."
    When user mengklik tombol "Setujui pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "QA-P0001; bukan QA-P0002"
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "QA-P0001 Approval Disetujui; QA-P0002 tetap Menunggu"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "hanya QA-P0001 mengalami efek tindakan"

  @positive @priority-high @REQ-021 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-053 — Aksi row reject hanya memproses ID row terpilih
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 dan QA-P0002 Menunggu; tombol di-scope pada row QA-P0001."
    When user mengklik tombol "Tolak pengajuan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "QA-P0001; bukan QA-P0002"
    When user mengisi field "Alasan Penolakan" dengan "Dokumen kurang"
    And user mengklik tombol "Tolak Pengajuan"
    Then sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "QA-P0001 Approval Ditolak; QA-P0002 tetap Menunggu"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "hanya QA-P0001 mengalami efek tindakan"

  @positive @priority-high @REQ-015 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-054 — Aksi row withdraw hanya memproses ID row terpilih
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 dan QA-P0002 Menunggu; tombol di-scope pada row QA-P0001."
    When user mengklik tombol "Batalkan pengajuan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "QA-P0001; bukan QA-P0002"
    When user mengklik tombol "Batalkan Pengajuan"
    Then sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "QA-P0001 Pengajuan Dibatalkan; QA-P0002 tetap Menunggu"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "hanya QA-P0001 mengalami efek tindakan"

  @positive @priority-high @REQ-026 @screen-edit-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-055 — Batal edit master tidak menyimpan perubahan
    Given user berada di halaman "Edit Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Modal Setting H-3 terbuka dengan 25%."
    When user mengisi field "Jenis Denda" dengan "Nama belum disimpan"
    And user mengisi field "Denda" dengan "60"
    And user mengklik tombol "Batal"
    And user berada di halaman "Master Denda Pembatalan" dengan konteks "reload"
    Then sistem memverifikasi elemen "Tabel Denda" dengan kondisi "H-3 lama 25%; nama lama; versi master tidak berubah"

  @positive @priority-medium @REQ-010 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-056 — Agen membuka form dari Buat Pembatalan
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "User di daftar pengajuan sendiri."
    When user mengklik tombol "Pengajuan Pembatalan"
    And user mengklik tombol "Buat Pembatalan"
    Then sistem memverifikasi elemen "Buat Pembatalan Tiket" dengan kondisi "halaman form pengajuan terbuka"
    And sistem memverifikasi elemen "Pilih Jadwal Kapal" dengan kondisi "terlihat"
    And sistem memverifikasi elemen "ID Tiket" dengan kondisi "belum terpilih"

  @positive @priority-high @REQ-023 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-057 — Pusat membuka form direct hanya pada kanal Cabang
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "User di menu Pembatalan Tiket."
    When user mengklik tombol "Penjualan Cabang"
    And user mengklik tombol "Buat Pembatalan"
    Then sistem memverifikasi elemen "Buat Pembatalan Tiket" dengan kondisi "form direct terbuka"
    And sistem memverifikasi elemen "Batalkan Tiket" dengan kondisi "tersedia sebagai konteks direct; disabled sebelum tiket dipilih"

  @positive @priority-high @REQ-030 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-POS-058 — Recovery response hilang menemukan satu pengajuan yang sudah committed
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fault injection sekali: backend commit kirim berhasil, respons hilang; fixture menyediakan reload status."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "Permintaan penumpang"
    And user mengklik tombol "Ajukan Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    And user berada di halaman "Pembatalan Tiket" dengan konteks "reload setelah timeout"
    And user mengklik tombol "Semua"
    Then sistem memverifikasi elemen "Tabel Pengajuan" dengan kondisi "satu pengajuan QA-T0001-001"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "satu snapshot; tiket aktif; nol refund"
    And sistem memverifikasi elemen "Hasil Recovery" dengan kondisi "retry/reload tidak membuat pengajuan kedua"

  @negative @priority-high @REQ-001 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-001 — Kantor Cabang tidak bisa mengakses route approval
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Menunggu; request dalam lingkup baca."
    When user berada di halaman "Aksi Approval Terlindungi" dengan konteks "intent approve QA-P0001"
    Then sistem memverifikasi elemen "Error Akses" dengan kondisi "aksi approve/reject ditolak oleh otorisasi"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Menunggu Approval"
    And sistem memverifikasi elemen "Status Tiket" dengan kondisi "aktif"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol keputusan dan nol refund"

  @negative @priority-high @REQ-001 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-002 — Agen tidak bisa mengakses route approval
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Menunggu; request dalam lingkup baca."
    When user berada di halaman "Aksi Approval Terlindungi" dengan konteks "intent approve QA-P0001"
    Then sistem memverifikasi elemen "Error Akses" dengan kondisi "aksi approve/reject ditolak oleh otorisasi"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Menunggu Approval"
    And sistem memverifikasi elemen "Status Tiket" dengan kondisi "aktif"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol keputusan dan nol refund"

  @negative @priority-high @REQ-002 @screen-master-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-003 — Kantor Cabang tidak dapat mengakses edit master langsung
    Given user berada di halaman "Master Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Master V1 25%; role tidak memiliki izin setting."
    When user berada di halaman "Edit Denda Pembatalan" dengan konteks "route langsung rule H-3"
    Then sistem memverifikasi elemen "Error Akses" dengan kondisi "edit master ditolak"
    And sistem memverifikasi elemen "Tabel Denda" dengan kondisi "V1 H-3 tetap 25%"

  @negative @priority-high @REQ-002 @screen-master-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-004 — Agen tidak dapat mengakses edit master langsung
    Given user berada di halaman "Master Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Master V1 25%; role tidak memiliki izin setting."
    When user berada di halaman "Edit Denda Pembatalan" dengan konteks "route langsung rule H-3"
    Then sistem memverifikasi elemen "Error Akses" dengan kondisi "edit master ditolak"
    And sistem memverifikasi elemen "Tabel Denda" dengan kondisi "V1 H-3 tetap 25%"

  @negative @priority-high @REQ-003 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-005 — Denda Agen tidak boleh memakai persentase seed lama
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Master V2 H-3=50%; fixture Agen memiliki legacy percent 2%."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda Rp200.000 / 50%; tidak memakai 2% atau tambahan seed Rp1.000"

  @negative @priority-high @REQ-004 @screen-edit-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-006 — Range waktu negatif ditolak
    Given user berada di halaman "Edit Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Modal edit terbuka; master H-3 valid."
    When user mengisi field "Range Waktu" dengan "-1"
    Then sistem memverifikasi elemen "Validasi Denda" dengan kondisi "Range waktu tidak valid."
    And sistem memverifikasi elemen "Simpan" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Tabel Denda" dengan kondisi "master lama tidak berubah"

  @negative @priority-high @REQ-005 @screen-master-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-007 — Cabang tidak dapat mengganti default melalui route edit
    Given user berada di halaman "Master Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Master baru default V1."
    When user berada di halaman "Edit Denda Pembatalan" dengan konteks "route edit H-1"
    Then sistem memverifikasi elemen "Error Akses" dengan kondisi "setting default ditolak"
    And sistem memverifikasi elemen "Tabel Denda" dengan kondisi "H-3=25%; H-2=50%; H-1=75% tetap"

  @negative @priority-high @REQ-006 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-008 — Pengajuan jauh sebelum keberangkatan tidak jatuh ke denda nol
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Master V1; H-100; tiket tetap eligible."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 25% Rp100.000; bukan 0/null/error rule tidak ditemukan"

  @negative @priority-high @REQ-007 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-009 — Payload lama tidak boleh menentukan waktu snapshot sebelum kirim
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Preview H-3; fixture clock berubah menjadi H-2 tepat sebelum konfirmasi; master V1."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "Permintaan penumpang"
    And user mengklik tombol "Ajukan Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "snapshot dibuat pada submissionAt H-2=50%; denda Rp200.000; refund Rp200.000"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "waktu preview tidak mengganti waktu pembuatan"

  @negative @priority-high @REQ-008 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-010 — Snapshot Ditolak tidak berubah setelah master diperbarui
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Ditolak snapshot 25%; master V2 75%."
    When user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks "reload"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "snapshot lama denda Rp100.000; tidak Rp300.000"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Approval Ditolak"

  @negative @priority-high @REQ-009 @screen-edit-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-011 — Persentase 101 ditolak
    Given user berada di halaman "Edit Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Modal edit master terbuka; Persen terpilih."
    When user mengisi field "Denda" dengan "101"
    Then sistem memverifikasi elemen "Validasi Denda" dengan kondisi "Persentase maksimal 100%."
    And sistem memverifikasi elemen "Simpan" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Tabel Denda" dengan kondisi "master lama tetap"

  @negative @priority-medium @REQ-009 @screen-edit-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-012 — Validasi Denda menolak '-1'
    Given user berada di halaman "Edit Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Modal edit terbuka; field lainnya valid."
    When user mengisi field "Denda" dengan "-1"
    Then sistem memverifikasi elemen "Validasi Denda" dengan kondisi "Masukkan nilai denda yang valid."
    And sistem memverifikasi elemen "Simpan" dengan kondisi "disabled"

  @negative @priority-medium @REQ-009 @screen-edit-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-013 — Validasi Denda menolak 'abc'
    Given user berada di halaman "Edit Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Modal edit terbuka; field lainnya valid."
    When user mengisi field "Denda" dengan "abc"
    Then sistem memverifikasi elemen "Validasi Denda" dengan kondisi "Masukkan nilai denda yang valid."
    And sistem memverifikasi elemen "Simpan" dengan kondisi "disabled"

  @negative @priority-medium @REQ-009 @screen-edit-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-014 — Validasi Denda menolak ''
    Given user berada di halaman "Edit Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Modal edit terbuka; field lainnya valid."
    When user mengisi field "Denda" dengan ""
    Then sistem memverifikasi elemen "Validasi Denda" dengan kondisi "Masukkan nilai denda yang valid."
    And sistem memverifikasi elemen "Simpan" dengan kondisi "disabled"

  @negative @priority-medium @REQ-009 @screen-edit-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-015 — Validasi Jenis Denda menolak '   '
    Given user berada di halaman "Edit Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Modal edit terbuka; field lainnya valid."
    When user mengisi field "Jenis Denda" dengan "   "
    Then sistem memverifikasi elemen "Validasi Denda" dengan kondisi "Nama denda wajib diisi."
    And sistem memverifikasi elemen "Simpan" dengan kondisi "disabled"

  @negative @priority-medium @REQ-009 @screen-edit-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-016 — Validasi Range Waktu menolak 'abc'
    Given user berada di halaman "Edit Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Modal edit terbuka; field lainnya valid."
    When user mengisi field "Range Waktu" dengan "abc"
    Then sistem memverifikasi elemen "Validasi Denda" dengan kondisi "Range waktu tidak valid."
    And sistem memverifikasi elemen "Simpan" dengan kondisi "disabled"

  @negative @priority-high @REQ-010 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-017 — Cabang tidak memiliki label pembatalan langsung
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Unit memiliki tiket eligible."
    When user mengklik tombol "Penjualan Cabang"
    Then sistem memverifikasi elemen "Ajukan Pembatalan" dengan kondisi "terlihat"
    And sistem memverifikasi elemen "Batalkan Tiket" dengan kondisi "tidak terlihat sebagai aksi direct Cabang"
    And sistem memverifikasi elemen "Buat Pembatalan" dengan kondisi "label lama Cabang tidak ditampilkan"

  @negative @priority-high @REQ-011 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-018 — Submit gagal sebelum commit tidak membuat Menunggu semu
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fault submit gagal sebelum commit; tiket eligible."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "Permintaan penumpang"
    And user mengklik tombol "Batalkan Tiket"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Error Sistem" dengan kondisi "pengajuan gagal; dapat mencoba ulang"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "tidak tercipta"
    And sistem memverifikasi elemen "Status Tiket" dengan kondisi "aktif"
    And sistem memverifikasi elemen "Status Refund" dengan kondisi "belum diproses"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol pengajuan baru"

  @negative @priority-high @REQ-012 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-019 — Halaman stale tidak boleh mengirim pengajuan kedua
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Form memuat tiket saat belum Menunggu; sesi lain membuat pengajuan sebelum klik kirim."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "Permintaan penumpang"
    And user mengklik tombol "Ajukan Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Error Sistem" dengan kondisi "sudah ada pengajuan Menunggu; tidak membuat pengajuan kedua"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "tepat satu pengajuan Menunggu untuk QA-T0001-001"

  @negative @priority-high @REQ-013 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-020 — Pengajuan ulang setelah Ditolak diblokir jika tiket sudah boarding
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-POLD Ditolak; tiket kini boarding, tidak eligible."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    Then sistem memverifikasi elemen "ID Tiket" dengan kondisi "QA-T0001-001 tidak dapat dipilih"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "tidak ada pengajuan ulang"

  @negative @priority-high @REQ-014 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-021 — Tiket sudah boarding tidak eligible untuk dipilih
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-T0001-001 sudah boarding; eligibility existing fixture diketahui."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    Then sistem memverifikasi elemen "ID Tiket" dengan kondisi "QA-T0001-001 tidak dapat dipilih; sebab sudah boarding"
    And sistem memverifikasi elemen "Ajukan Pembatalan" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol pengajuan"

  @negative @priority-high @REQ-014 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-022 — Tiket sudah dibatalkan tidak eligible untuk dipilih
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-T0001-001 sudah dibatalkan; eligibility existing fixture diketahui."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    Then sistem memverifikasi elemen "ID Tiket" dengan kondisi "QA-T0001-001 tidak dapat dipilih; sebab sudah dibatalkan"
    And sistem memverifikasi elemen "Ajukan Pembatalan" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol pengajuan"

  @negative @priority-high @REQ-014 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-023 — Tiket belum dibayar tidak eligible untuk dipilih
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-T0001-001 belum dibayar; eligibility existing fixture diketahui."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    Then sistem memverifikasi elemen "ID Tiket" dengan kondisi "QA-T0001-001 tidak dapat dipilih; sebab belum dibayar"
    And sistem memverifikasi elemen "Ajukan Pembatalan" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol pengajuan"

  @negative @priority-high @REQ-014 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-024 — Tiket milik unit lain tidak eligible untuk dipilih
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-T0001-001 milik unit lain; eligibility existing fixture diketahui."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    Then sistem memverifikasi elemen "ID Tiket" dengan kondisi "QA-T0001-001 tidak dapat dipilih; sebab milik unit lain"
    And sistem memverifikasi elemen "Ajukan Pembatalan" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol pengajuan"

  @negative @priority-high @REQ-014 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-025 — Tiket berbeda jadwal tidak eligible untuk dipilih
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-T0001-001 berbeda jadwal; eligibility existing fixture diketahui."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    Then sistem memverifikasi elemen "ID Tiket" dengan kondisi "QA-T0001-001 tidak dapat dipilih; sebab berbeda jadwal"
    And sistem memverifikasi elemen "Ajukan Pembatalan" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol pengajuan"

  @negative @priority-high @REQ-014 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-026 — Form tidak dapat dikirim tanpa Pilih Jadwal Kapal
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tanggal pencarian valid; field wajib yang diuji belum dipilih."
    When user berada di halaman "Buat Pembatalan Tiket" dengan konteks "reload untuk memverifikasi state"
    Then sistem memverifikasi elemen "Batalkan Tiket" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol pengajuan"

  @negative @priority-high @REQ-014 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-027 — Form tidak dapat dikirim tanpa ID Tiket
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tanggal pencarian valid; field wajib yang diuji belum dipilih."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    Then sistem memverifikasi elemen "Batalkan Tiket" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol pengajuan"

  @negative @priority-high @REQ-014 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-028 — Lookup tiket stale menampilkan error jika tiket sudah boarding
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Pilihan tiket memuat QA-T0001-001 saat eligible; boarding terjadi sebelum lookup detail."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Validasi Tiket" dengan kondisi "Tiket sudah digunakan untuk boarding dan tidak dapat dibatalkan."
    And sistem memverifikasi elemen "Ajukan Pembatalan" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol pengajuan"

  @negative @priority-high @REQ-015 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-029 — Pengaju tidak dapat menarik pengajuan Approval Disetujui
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 milik sendiri berstatus Approval Disetujui."
    When user berada di halaman "Aksi Penarikan Terlindungi" dengan konteks "intent withdraw QA-P0001"
    Then sistem memverifikasi elemen "Error Akses" dengan kondisi "penarikan tidak diizinkan pada status final"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Approval Disetujui"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "tidak ada penarikan baru"

  @negative @priority-high @REQ-015 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-030 — Pengaju tidak dapat menarik pengajuan Approval Ditolak
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 milik sendiri berstatus Approval Ditolak."
    When user berada di halaman "Aksi Penarikan Terlindungi" dengan konteks "intent withdraw QA-P0001"
    Then sistem memverifikasi elemen "Error Akses" dengan kondisi "penarikan tidak diizinkan pada status final"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Approval Ditolak"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "tidak ada penarikan baru"

  @negative @priority-high @REQ-015 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-031 — Pengaju tidak dapat menarik pengajuan Pengajuan Dibatalkan
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 milik sendiri berstatus Pengajuan Dibatalkan."
    When user berada di halaman "Aksi Penarikan Terlindungi" dengan konteks "intent withdraw QA-P0001"
    Then sistem memverifikasi elemen "Error Akses" dengan kondisi "penarikan tidak diizinkan pada status final"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Pengajuan Dibatalkan"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "tidak ada penarikan baru"

  @negative @priority-high @REQ-015 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-032 — Agen tidak dapat menarik pengajuan Agen lain
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Menunggu milik AG-BPN-02; user AG-BPN-01."
    When user berada di halaman "Aksi Penarikan Terlindungi" dengan konteks "intent withdraw QA-P0001"
    Then sistem memverifikasi elemen "Error Akses" dengan kondisi "akses pengajuan/penarikan milik unit lain ditolak"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "QA-P0001 tetap Menunggu; tidak ada mutasi"

  @negative @priority-high @REQ-016 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-033 — Antrean Menunggu tidak menyertakan pengajuan yang sudah final
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Dataset hanya tiga pengajuan: Disetujui, Ditolak, Dibatalkan."
    When user mengklik tombol "Penjualan Agen"
    And user mengklik tombol "Menunggu Approval"
    Then sistem memverifikasi elemen "Empty State" dengan kondisi "Tidak ada pengajuan yang menunggu"
    And sistem memverifikasi elemen "Tabel Pengajuan" dengan kondisi "tidak ada baris final pada antrean"

  @negative @priority-high @REQ-017 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-034 — Detail lintas unit tidak membocorkan data tiket atau finansial
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0002 milik AG-BPN-02; user AG-BPN-01."
    When user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks "route langsung QA-P0002"
    Then sistem memverifikasi elemen "Error Akses" dengan kondisi "pengajuan unit lain tidak dapat dibaca"
    And sistem memverifikasi elemen "Detail Pengajuan" dengan kondisi "data QA-P0002 tidak terlihat"
    And sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "data QA-P0002 tidak terlihat"

  @negative @priority-high @REQ-018 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-035 — Event Tiket Diterbitkan tidak kembali muncul setelah reload
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Menunggu; backend histori masih memiliki event penerbitan lama."
    When user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks "reload"
    Then sistem memverifikasi elemen "Riwayat" dengan kondisi "Tiket Diterbitkan tidak terlihat; Pengajuan dikirim tetap terlihat"

  @negative @priority-high @REQ-019 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-036 — Pusat tidak dapat approve pengajuan Approval Ditolak
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Approval Ditolak; tiket aktif."
    When user berada di halaman "Aksi Approval Terlindungi" dengan konteks "intent approve QA-P0001"
    Then sistem memverifikasi elemen "Error Akses" dengan kondisi "approve ditolak karena bukan Menunggu"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Approval Ditolak"
    And sistem memverifikasi elemen "Status Tiket" dengan kondisi "aktif"
    And sistem memverifikasi elemen "Status Refund" dengan kondisi "belum diproses"

  @negative @priority-high @REQ-019 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-037 — Pusat tidak dapat approve pengajuan Pengajuan Dibatalkan
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Pengajuan Dibatalkan; tiket aktif."
    When user berada di halaman "Aksi Approval Terlindungi" dengan konteks "intent approve QA-P0001"
    Then sistem memverifikasi elemen "Error Akses" dengan kondisi "approve ditolak karena bukan Menunggu"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Pengajuan Dibatalkan"
    And sistem memverifikasi elemen "Status Tiket" dengan kondisi "aktif"
    And sistem memverifikasi elemen "Status Refund" dengan kondisi "belum diproses"

  @negative @priority-high @REQ-020 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-038 — Replay approval Disetujui tidak menggandakan refund
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Disetujui; sesi stale masih memuat tombol approve; satu refund Rp300.000."
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "Setujui Pembatalan; tiket QA-T0001-001; refund Rp300.000"
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Error Sistem" dengan kondisi "pengajuan sudah diproses atau hasil idempoten yang sama"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Approval Disetujui"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "tepat satu refund Rp300.000; satu approval"

  @negative @priority-high @REQ-021 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-039 — Pusat tidak dapat reject pengajuan Approval Disetujui
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Approval Disetujui; snapshot tersimpan."
    When user berada di halaman "Aksi Reject Terlindungi" dengan konteks "intent reject QA-P0001"
    Then sistem memverifikasi elemen "Error Akses" dengan kondisi "reject ditolak karena bukan Menunggu"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Approval Disetujui"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "tidak ada reject baru"

  @negative @priority-high @REQ-021 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-040 — Pusat tidak dapat reject pengajuan Pengajuan Dibatalkan
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Pengajuan Dibatalkan; snapshot tersimpan."
    When user berada di halaman "Aksi Reject Terlindungi" dengan konteks "intent reject QA-P0001"
    Then sistem memverifikasi elemen "Error Akses" dengan kondisi "reject ditolak karena bukan Menunggu"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Pengajuan Dibatalkan"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "tidak ada reject baru"

  @negative @priority-high @REQ-022 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-041 — Replay reject tidak menimpa alasan penolakan final
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Ditolak alasan Awal; form reject stale masih terbuka."
    When user mengklik tombol "Tolak"
    And user mengisi field "Alasan Penolakan" dengan "Alasan pengganti"
    And user mengklik tombol "Tolak Pengajuan"
    Then sistem memverifikasi elemen "Error Sistem" dengan kondisi "pengajuan sudah diproses; reject kedua ditolak"
    And sistem memverifikasi elemen "Banner Alasan Penolakan" dengan kondisi "Awal; tidak menjadi Alasan pengganti"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "tepat satu reject"

  @negative @priority-high @REQ-023 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-042 — Kantor Cabang tidak dapat melakukan pembatalan langsung
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible; role tidak boleh bypass approval."
    When user berada di halaman "Pembatalan Langsung Terlindungi" dengan konteks "intent direct QA-T0001-001"
    Then sistem memverifikasi elemen "Error Akses" dengan kondisi "direct cancellation ditolak"
    And sistem memverifikasi elemen "Status Tiket" dengan kondisi "aktif"
    And sistem memverifikasi elemen "Status Refund" dengan kondisi "belum diproses"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol direct cancellation"

  @negative @priority-high @REQ-023 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-043 — Agen tidak dapat melakukan pembatalan langsung
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible; role tidak boleh bypass approval."
    When user berada di halaman "Pembatalan Langsung Terlindungi" dengan konteks "intent direct QA-T0001-001"
    Then sistem memverifikasi elemen "Error Akses" dengan kondisi "direct cancellation ditolak"
    And sistem memverifikasi elemen "Status Tiket" dengan kondisi "aktif"
    And sistem memverifikasi elemen "Status Refund" dengan kondisi "belum diproses"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol direct cancellation"

  @negative @priority-high @REQ-024 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-044 — Cabang tidak dapat memutus atau menarik pengajuan Agen
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Agen terkait Cabang; Menunggu."
    When user mengklik tombol "Penjualan Agen"
    And user mengklik tombol "Lihat detail"
    Then sistem memverifikasi elemen "Setujui Pembatalan" dengan kondisi "tidak terlihat"
    And sistem memverifikasi elemen "Tolak" dengan kondisi "tidak terlihat"
    And sistem memverifikasi elemen "Batalkan Pengajuan" dengan kondisi "tidak terlihat"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "status Agen tetap Menunggu"

  @negative @priority-medium @REQ-025 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-045 — Pencarian ID yang tidak ada menampilkan empty tanpa data lama
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Daftar semula berisi pengajuan."
    When user mengklik tombol "Filter"
    And user mengisi field "ID Pengajuan / ID Tiket" dengan "QA-NOT-FOUND"
    And user mengklik tombol "Filter"
    Then sistem memverifikasi elemen "Empty State" dengan kondisi "Tidak Ada Data yang tersedia"
    And sistem memverifikasi elemen "Tabel Pengajuan" dengan kondisi "nol baris; data sebelumnya tidak tertinggal"

  @negative @priority-high @REQ-026 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-046 — Menutup konfirmasi kirim tidak mengubah data
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Form valid atau pengajuan Menunggu sesuai op; modal belum dikonfirmasi."
    When user mengklik tombol "Ajukan Pembatalan"
    And user mengklik tombol "Kembali"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "tertutup"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol pengajuan baru; tiket aktif"

  @negative @priority-high @REQ-026 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-047 — Menutup konfirmasi approve tidak mengubah data
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Form valid atau pengajuan Menunggu sesuai op; modal belum dikonfirmasi."
    When user mengklik tombol "Setujui Pembatalan"
    And user mengklik tombol "Batal"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "tertutup"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "Menunggu; tiket aktif; nol refund"

  @negative @priority-high @REQ-026 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-048 — Menutup konfirmasi reject tidak mengubah data
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Form valid atau pengajuan Menunggu sesuai op; modal belum dikonfirmasi."
    When user mengklik tombol "Tolak"
    And user mengisi field "Alasan Penolakan" dengan "Tidak sesuai"
    And user mengklik tombol "Batal"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "tertutup"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "Menunggu; alasan penolakan tidak tersimpan"

  @negative @priority-high @REQ-026 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-049 — Menutup konfirmasi penarikan tidak mengubah data
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Form valid atau pengajuan Menunggu sesuai op; modal belum dikonfirmasi."
    When user mengklik tombol "Batalkan Pengajuan"
    And user mengklik tombol "Kembali"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "tertutup"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "Menunggu; tiket aktif"

  @negative @priority-high @REQ-026 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-050 — Menutup konfirmasi direct tidak mengubah data
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Form valid atau pengajuan Menunggu sesuai op; modal belum dikonfirmasi."
    When user mengklik tombol "Batalkan Tiket"
    And user mengklik tombol "Kembali"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "tertutup"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "tiket aktif; nol pembatalan langsung; nol refund"

  @negative @priority-high @REQ-027 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-051 — Reject diblokir untuk alasan kosong
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Menunggu."
    When user mengklik tombol "Tolak"
    And user mengisi field "Alasan Penolakan" dengan ""
    Then sistem memverifikasi elemen "Tolak Pengajuan" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Menunggu Approval"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol reject"

  @negative @priority-high @REQ-027 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-052 — Reject diblokir untuk alasan whitespace
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Menunggu."
    When user mengklik tombol "Tolak"
    And user mengisi field "Alasan Penolakan" dengan "   "
    Then sistem memverifikasi elemen "Tolak Pengajuan" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Menunggu Approval"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol reject"

  @negative @priority-high @REQ-028 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-053 — Kalkulasi tidak menerima override manual denda
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Master 25%; harga Rp400.000; field desain lama pernah editable."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Denda" dengan kondisi "readonly atau tidak ada field input editable"
    And sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda tetap Rp100.000 dan refund Rp300.000"

  @negative @priority-high @REQ-029 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-054 — Pergantian jadwal tidak membawa tiket dari jadwal lama
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-J01/QA-T0001-001 terpilih; QA-J02 memiliki tiket berbeda."
    When user mengklik tombol "Ganti Jadwal"
    And user memilih opsi "QA-J02" pada field "Pilih Jadwal Kapal"
    Then sistem memverifikasi elemen "ID Tiket" dengan kondisi "QA-T0001-001 tidak ada pada QA-J02; belum terpilih"
    And sistem memverifikasi elemen "Batalkan Tiket" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "tidak menampilkan kalkulasi tiket QA-J01"

  @negative @priority-high @REQ-030 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-NEG-055 — Approve gagal di layanan refund tidak melaporkan sukses penuh
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Menunggu; fixture layanan refund gagal sebelum efek ke saldo."
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "Setujui Pembatalan; tiket QA-T0001-001; refund Rp300.000"
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Error Sistem" dengan kondisi "gagal atau pending recovery; tidak mengklaim refund selesai"
    And sistem memverifikasi elemen "Status Refund" dengan kondisi "tidak ada transfer sukses"
    And sistem memverifikasi elemen "Hasil Recovery" dengan kondisi "keadaan atomik atau recovery tercatat; retry tidak menggandakan efek"

  @edge @priority-high @REQ-004 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-001 — Batas kalkulasi sebelum H-3 satu detik
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible; jam dibekukan; master V1 tiga interval menurut A05."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 25% = 100000; refund 300000; tepat satu rule"

  @edge @priority-high @REQ-004 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-002 — Batas kalkulasi tepat H-3
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible; jam dibekukan; master V1 tiga interval menurut A05."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 25% = 100000; refund 300000; tepat satu rule"

  @edge @priority-high @REQ-004 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-003 — Batas kalkulasi setelah H-3 satu detik
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible; jam dibekukan; master V1 tiga interval menurut A05."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 50% = 200000; refund 200000; tepat satu rule"

  @edge @priority-high @REQ-004 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-004 — Batas kalkulasi sebelum H-2 satu detik
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible; jam dibekukan; master V1 tiga interval menurut A05."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 50% = 200000; refund 200000; tepat satu rule"

  @edge @priority-high @REQ-004 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-005 — Batas kalkulasi tepat H-2
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible; jam dibekukan; master V1 tiga interval menurut A05."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 50% = 200000; refund 200000; tepat satu rule"

  @edge @priority-high @REQ-004 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-006 — Batas kalkulasi setelah H-2 satu detik
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible; jam dibekukan; master V1 tiga interval menurut A05."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 75% = 300000; refund 100000; tepat satu rule"

  @edge @priority-high @REQ-004 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-007 — Batas kalkulasi tepat H-1
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible; jam dibekukan; master V1 tiga interval menurut A05."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 75% = 300000; refund 100000; tepat satu rule"

  @edge @priority-high @REQ-004 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-008 — Batas kalkulasi sebelum keberangkatan satu detik
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible; jam dibekukan; master V1 tiga interval menurut A05."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 75% = 300000; refund 100000; tepat satu rule"

  @edge @priority-high @REQ-006 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-009 — Batas setelah kapal berangkat tepat keberangkatan
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture existing mengizinkan tiket belum boarding pascakeberangkatan; master H+ khusus bukan default."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 20% = 80000; refund 320000; bukan rule H-"

  @edge @priority-high @REQ-006 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-010 — Batas setelah kapal berangkat tepat H+1
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture existing mengizinkan tiket belum boarding pascakeberangkatan; master H+ khusus bukan default."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 20% = 80000; refund 320000; bukan rule H-"

  @edge @priority-high @REQ-006 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-011 — Batas setelah kapal berangkat setelah H+1 satu detik
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture existing mengizinkan tiket belum boarding pascakeberangkatan; master H+ khusus bukan default."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 40% = 160000; refund 240000; bukan rule H-"

  @edge @priority-high @REQ-006 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-012 — Batas setelah kapal berangkat tepat H+2
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture existing mengizinkan tiket belum boarding pascakeberangkatan; master H+ khusus bukan default."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 40% = 160000; refund 240000; bukan rule H-"

  @edge @priority-high @REQ-006 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-013 — Batas setelah kapal berangkat setelah H+2 satu detik
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture existing mengizinkan tiket belum boarding pascakeberangkatan; master H+ khusus bukan default."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 60% = 240000; refund 160000; bukan rule H-"

  @edge @priority-high @REQ-006 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-014 — Batas setelah kapal berangkat tepat H+3
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture existing mengizinkan tiket belum boarding pascakeberangkatan; master H+ khusus bukan default."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 60% = 240000; refund 160000; bukan rule H-"

  @edge @priority-high @REQ-006 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-015 — Batas setelah kapal berangkat setelah H+3 satu detik
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture existing mengizinkan tiket belum boarding pascakeberangkatan; master H+ khusus bukan default."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 60% = 240000; refund 160000; bukan rule H-"

  @edge @priority-high @REQ-006 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-016 — Batas setelah kapal berangkat H+10 fallback
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture existing mengizinkan tiket belum boarding pascakeberangkatan; master H+ khusus bukan default."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 60% = 240000; refund 160000; bukan rule H-"

  @edge @priority-high @REQ-004 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-017 — Browser WIB dan jadwal WITA menghasilkan delta yang sama
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Jadwal 20 Okt 15:00 WITA; pengajuan 17 Okt 14:00 WIB = H-3; browser Asia/Jakarta."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Detail Jadwal" dengan kondisi "15:00 WITA"
    And sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "25% Rp100.000; tidak bergeser satu jam ke 50%"

  @edge @priority-high @REQ-004 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-018 — Rule Jam 72 dan Hari 3 ekuivalen pada instant yang sama
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture dua profil master terpisah setara: Hari 3/2/1 dan Jam 72/48/24."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "profil Hari 25%"
    When user berada di halaman "Buat Pembatalan Tiket" dengan konteks "fixture profil Jam"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "profil Jam 25%; sama Rp100.000"

  @edge @priority-high @REQ-009 @screen-edit-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-019 — Persentase batas 0 diterima dan refund konsisten
    Given user berada di halaman "Edit Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Modal edit Persen; field lainnya valid."
    When user mengisi field "Denda" dengan "0"
    And user mengklik tombol "Simpan"
    And user berada di halaman "Buat Pembatalan Tiket" dengan konteks "sesi Cabang setelah update"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Tabel Denda" dengan kondisi "rule 0% tersimpan"
    And sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 0; refund 400000; tidak negatif"

  @edge @priority-high @REQ-009 @screen-edit-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-020 — Persentase batas 100 diterima dan refund konsisten
    Given user berada di halaman "Edit Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Modal edit Persen; field lainnya valid."
    When user mengisi field "Denda" dengan "100"
    And user mengklik tombol "Simpan"
    And user berada di halaman "Buat Pembatalan Tiket" dengan konteks "sesi Cabang setelah update"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Tabel Denda" dengan kondisi "rule 100% tersimpan"
    And sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 400000; refund 0; tidak negatif"

  @edge @priority-high @REQ-009 @screen-edit-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-021 — Persentase 100 koma 01 melewati batas maksimum
    Given user berada di halaman "Edit Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tipe Persen; format desimal Indonesia."
    When user mengisi field "Denda" dengan "100,01"
    Then sistem memverifikasi elemen "Validasi Denda" dengan kondisi "Persentase maksimal 100%."
    And sistem memverifikasi elemen "Simpan" dengan kondisi "disabled"

  @edge @priority-high @REQ-009 @screen-edit-denda
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-022 — Desimal lokal 25 koma 5 tidak diubah menjadi 255
    Given user berada di halaman "Edit Denda Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Presisi desimal diizinkan fixture existing; tipe Persen."
    When user mengisi field "Denda" dengan "25,5"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Tabel Denda" dengan kondisi "25,5% tersimpan; tidak 255% atau 25%"

  @edge @priority-high @REQ-014 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-023 — Rentang pencarian tepat 30 hari diterima
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Jadwal tersedia pada awal/akhir range."
    When user mengisi field "Tanggal Awal" dengan "2026-10-01"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-31"
    Then sistem memverifikasi elemen "Pilih Jadwal Kapal" dengan kondisi "jadwal dalam rentang tersedia"
    And sistem memverifikasi elemen "Validasi Tanggal" dengan kondisi "tidak terlihat"

  @edge @priority-high @REQ-014 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-024 — Rentang tanggal 31 hari tidak melanjutkan pencarian
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Field jadwal/tiket belum dipilih."
    When user mengisi field "Tanggal Awal" dengan "2026-10-01"
    And user mengisi field "Tanggal Akhir" dengan "2026-11-01"
    Then sistem memverifikasi elemen "Validasi Tanggal" dengan kondisi "range wajib valid dan maksimal 30 hari"
    And sistem memverifikasi elemen "Batalkan Tiket" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol pengajuan"

  @edge @priority-high @REQ-014 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-025 — Rentang tanggal tanggal terbalik tidak melanjutkan pencarian
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Field jadwal/tiket belum dipilih."
    When user mengisi field "Tanggal Awal" dengan "2026-10-31"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-01"
    Then sistem memverifikasi elemen "Validasi Tanggal" dengan kondisi "range wajib valid dan maksimal 30 hari"
    And sistem memverifikasi elemen "Batalkan Tiket" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol pengajuan"

  @edge @priority-high @REQ-014 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-026 — Rentang tanggal tanggal awal kosong tidak melanjutkan pencarian
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Field jadwal/tiket belum dipilih."
    When user mengisi field "Tanggal Awal" dengan ""
    And user mengisi field "Tanggal Akhir" dengan "2026-10-31"
    Then sistem memverifikasi elemen "Validasi Tanggal" dengan kondisi "range wajib valid dan maksimal 30 hari"
    And sistem memverifikasi elemen "Batalkan Tiket" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol pengajuan"

  @edge @priority-high @REQ-014 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-027 — Boarding pass tercetak menampilkan warning tanpa dianggap boarding
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible; boarding pass sudah cetak; belum digunakan boarding."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Peringatan Boarding Pass" dengan kondisi "Boarding pass sudah dicetak; pastikan dokumen ditarik"
    And sistem memverifikasi elemen "Detail Penumpang" dengan kondisi "Belum Check in"
    And sistem memverifikasi elemen "Ajukan Pembatalan" dengan kondisi "enabled sesuai eligibility existing"

  @edge @priority-high @REQ-027 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-028 — Alasan penolakan berisi HTML ditampilkan sebagai teks aman
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Menunggu; instrumen mendeteksi eksekusi script."
    When user mengklik tombol "Tolak"
    And user mengisi field "Alasan Penolakan" dengan "<img src=x onerror=alert(1)> & \"dokumen\""
    And user mengklik tombol "Tolak Pengajuan"
    Then sistem memverifikasi elemen "Banner Alasan Penolakan" dengan kondisi "teks literal <img src=x onerror=alert(1)> & \"dokumen\""
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "tidak ada eksekusi script/alert; alasan tidak merusak halaman"

  @edge @priority-high @REQ-010 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-029 — Keterangan Unicode dan baris baru tetap utuh
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible; field opsional."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "Penumpang sakit — izin dokter 🛳\nJadwal berubah"
    And user mengklik tombol "Batalkan Tiket"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Detail Pengajuan" dengan kondisi "keterangan Unicode dan newline dipertahankan sebagai teks"
    And sistem memverifikasi elemen "Status Pengajuan" dengan kondisi "Menunggu Approval"

  @edge @priority-high @REQ-028 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-030 — Pembulatan harga tidak habis dibagi empat konsisten dengan refund
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Harga Rp400.003, denda 25%; pembulatan half up fixture A08."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda Rp100.001; refund Rp300.002; total Rp400.003"

  @edge @priority-high @REQ-028 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-031 — Harga nol tidak menghasilkan NaN atau refund negatif
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture existing mengizinkan tiket paid nol; eligible; komponen nol."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "harga Rp0; denda Rp0; refund Rp0; tidak NaN/Infinity"

  @edge @priority-high @REQ-028 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-032 — Denda Rupiah melebihi harga dibatasi nilai pembayaran
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture kebijakan existing cap sesuai HTML; harga Rp400.000; nominal rule Rp500.000."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda Rp400.000; refund Rp0; bukan negatif"

  @edge @priority-high @REQ-028 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-033 — Komisi dan pass existing tidak dikenakan dua kali pada refund Agen
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture existing tervalidasi: bayar Rp400.000 sudah termasuk pass Rp37.500, komisi Rp7.250 dikurangkan sekali dari refund; dasar denda harga bayar."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "harga dasar 362500; pass 37500; total 400000; denda 100000; komisi 7250; potongan 107250; refund 292750"

  @edge @priority-high @REQ-028 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-034 — Kapal tidak berangkat memakai pengecualian existing yang disahkan
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture existing secara eksplisit mengesahkan denda 0 untuk Kapal Tidak Berangkat."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user memilih opsi "Kapal Tidak Berangkat" pada field "Pilih Pembatalan"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda 0%; Rp0; refund Rp400.000"

  @edge @priority-high @REQ-028 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-035 — Tiket sebelum cetak memakai pengecualian existing yang disahkan
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Fixture existing mengesahkan denda sebelum cetak Rp0; tiket belum dicetak; komisi nol."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    Then sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "denda Rp0; refund Rp400.000"

  @edge @priority-medium @REQ-025 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-036 — Filter Agen dengan nama khusus tidak rusak atau membuka unit lain
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 pengaju PT. A&B Nusantara; dataset lintas unit terpisah."
    When user mengklik tombol "Penjualan Agen"
    And user mengklik tombol "Filter"
    And user mengisi field "Pengaju / Nama Agen" dengan "PT. A&B Nusantara"
    And user mengklik tombol "Filter"
    And user memilih opsi "20" pada field "Ukuran Halaman"
    Then sistem memverifikasi elemen "Tabel Pengajuan" dengan kondisi "hanya baris cocok; ampersand literal; maksimum 20 baris"

  @edge @priority-medium @REQ-025 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-037 — Status Menunggu kosong menghapus badge jumlah lama
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Antrean semula berisi satu Menunggu; fixture sesi lain menyelesaikannya sebelum reload."
    When user mengklik tombol "Menunggu Approval"
    And user berada di halaman "Pembatalan Tiket" dengan konteks "reload"
    Then sistem memverifikasi elemen "Empty State" dengan kondisi "Tidak ada pengajuan yang menunggu"
    And sistem memverifikasi elemen "Menunggu Approval" dengan kondisi "badge tidak menampilkan jumlah 1 lama"

  @edge @priority-high @REQ-026 @screen-konfirmasi
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-038 — Klik ganda kirim saat loading membuat satu pengajuan
    Given user berada di halaman "Konfirmasi Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Form valid; modal kirim terbuka; respons ditunda 2 detik."
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Loading" dengan kondisi "Mengirim…"
    And sistem memverifikasi elemen "Kirim Pengajuan" dengan kondisi "disabled selama proses"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "tepat satu pengajuan baru; satu snapshot"
    And sistem memverifikasi elemen "Toast" dengan kondisi "satu hasil sukses atau hasil idempoten"

  @edge @priority-high @REQ-030 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-039 — Approve dan penarikan serentak menghasilkan satu pemenang
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Dua sesi Pusat/pengaju pada Menunggu; barrier sebelum konfirmasi."
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "Setujui Pembatalan; tiket QA-T0001-001; refund Rp300.000"
    When user mengklik tombol "Setujui Pembatalan"
    And user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks "sesi pengaju serentak"
    And user mengklik tombol "Batalkan Pengajuan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "Batalkan Pengajuan; tiket tetap aktif"
    When user mengklik tombol "Batalkan Pengajuan"
    Then sistem memverifikasi elemen "Hasil Paralel" dengan kondisi "tepat satu: Disetujui+tiket batal+refund sekali ATAU Dibatalkan+tiket aktif+refund nol"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "satu transisi final; pihak kalah ditolak"

  @edge @priority-high @REQ-030 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-040 — Approve dan reject serentak menghasilkan satu keputusan final
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Dua sesi Pusat pada pengajuan Menunggu; barrier sebelum konfirmasi."
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "Setujui Pembatalan; tiket QA-T0001-001; refund Rp300.000"
    When user mengklik tombol "Setujui Pembatalan"
    And user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks "sesi Pusat kedua serentak"
    And user mengklik tombol "Tolak"
    And user mengisi field "Alasan Penolakan" dengan "Dokumen pendukung tidak dilampirkan"
    And user mengklik tombol "Tolak Pengajuan"
    Then sistem memverifikasi elemen "Hasil Paralel" dengan kondisi "Disetujui dengan refund sekali ATAU Ditolak dengan tiket aktif/refund nol"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "satu keputusan final; tidak ada approved+rejected bersamaan"

  @edge @priority-high @REQ-008 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-041 — Perubahan master serentak dengan submit menyimpan satu versi utuh
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Sesi Cabang submit H-3 bersamaan Pusat mengubah V1 25% menjadi V2 50%."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "Permintaan penumpang"
    And user mengklik tombol "Ajukan Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "snapshot utuh V1 25%/100000/300000 ATAU V2 50%/200000/200000; tidak campur"
    And sistem memverifikasi elemen "Keterangan Snapshot" dengan kondisi "versi terpilih dikunci dan tidak berubah kemudian"

  @edge @priority-high @REQ-030 @screen-konfirmasi
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-EDG-042 — Sesi kedaluwarsa saat konfirmasi tidak mengubah tiket
    Given user berada di halaman "Konfirmasi Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Modal approve terbuka; sesi expired tepat sebelum konfirmasi."
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Error Akses" dengan kondisi "sesi kedaluwarsa; perlu autentikasi"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "Menunggu tetap; tiket aktif; nol refund"

  @stress @priority-high @REQ-012 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-001 — Seratus sesi mengajukan tiket yang sama
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "100 sesi pemilik sah menyiapkan form tiket sama sebelum barrier."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "Permintaan penumpang"
    And user mengklik tombol "Ajukan Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Hasil Paralel" dengan kondisi "tepat satu pengajuan Menunggu; 99 hasil duplikat/idempoten"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "satu snapshot; tiket aktif; nol refund"

  @stress @priority-high @REQ-011 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-002 — Seribu pengajuan tiket berbeda tidak saling menukar data
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "1.000 tiket eligible unik terbagi 100 sesi/unit; fixture ID dan pemilik berbeda."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "Permintaan penumpang"
    And user mengklik tombol "Batalkan Tiket"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Hasil Paralel" dengan kondisi "1000 pengajuan unik Menunggu; tiket aktif; refund nol"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "ticketId/owner/snapshot tiap pengajuan sesuai; nol silang unit"

  @stress @priority-high @REQ-020 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-003 — Seratus approval paralel pada pengajuan sama tidak menggandakan refund
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "100 sesi Pusat membuka QA-P0001 Menunggu."
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "Setujui Pembatalan; tiket QA-T0001-001; refund Rp300.000"
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Hasil Paralel" dengan kondisi "satu Disetujui; sisanya idempoten/ditolak"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "satu refund Rp300.000; satu pembatalan tiket; satu event approval"

  @stress @priority-high @REQ-021 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-004 — Seratus reject paralel menjaga satu alasan final
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "100 sesi Pusat memakai alasan berbeda pada QA-P0001."
    When user mengklik tombol "Tolak"
    And user mengisi field "Alasan Penolakan" dengan "Alasan sesi {index}"
    And user mengklik tombol "Tolak Pengajuan"
    Then sistem memverifikasi elemen "Hasil Paralel" dengan kondisi "satu Ditolak; alasan pemenang konsisten di pengaju/histori"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "satu reject; tiket aktif; nol refund"

  @stress @priority-high @REQ-015 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-005 — Seratus penarikan paralel menghasilkan satu Dibatalkan
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "100 sesi pemilik AG-BPN-01 membuka pengajuan sama Menunggu."
    When user mengklik tombol "Batalkan Pengajuan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "Batalkan Pengajuan; tiket tetap aktif"
    When user mengklik tombol "Batalkan Pengajuan"
    Then sistem memverifikasi elemen "Hasil Paralel" dengan kondisi "satu Dibatalkan; lainnya ditolak/idempoten"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "satu event penarikan; tiket aktif; nol refund"

  @stress @priority-high @REQ-023 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-006 — Pembatalan langsung berulang pada tiket Cabang tidak menggandakan efek
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "100 sesi Pusat menyiapkan tiket Cabang sama eligible."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengklik tombol "Batalkan Tiket"
    And user mengklik tombol "Batalkan Tiket"
    Then sistem memverifikasi elemen "Hasil Paralel" dengan kondisi "tiket dibatalkan satu kali tanpa antrean approval"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "satu refund Rp300.000 dan satu histori direct oleh Pusat"

  @stress @priority-medium @REQ-025 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-007 — Sepuluh ribu baris daftar tetap terfilter dan dibatasi halaman
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "10.000 pengajuan; tiap ID/status/pemilik diketahui; 123 cocok filter nama."
    When user mengklik tombol "Penjualan Agen"
    And user mengklik tombol "Semua"
    And user memilih opsi "100" pada field "Ukuran Halaman"
    And user mengklik tombol "Filter"
    And user mengisi field "Pengaju / Nama Agen" dengan "QA Load Agen"
    And user mengklik tombol "Filter"
    Then sistem memverifikasi elemen "Tabel Pengajuan" dengan kondisi "100 baris maksimum halaman pertama; total cocok 123; tidak duplikasi"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "filter tidak mengubah status/finansial"

  @stress @priority-medium @REQ-017 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-008 — Histori seribu event tetap terkait pengajuan dan tanpa penerbitan
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 memiliki 1.000 event fixture unik, termasuk event penerbitan yang perlu disaring."
    And sistem memverifikasi elemen "Riwayat" dengan kondisi "event pengajuan/keputusan milik QA-P0001 terbaca"
    When user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks "reload untuk memverifikasi state"
    Then sistem memverifikasi elemen "Riwayat" dengan kondisi "tidak ada event pengajuan lain atau Tiket Diterbitkan; nilai snapshot tetap"
    And sistem memverifikasi elemen "Detail Pengajuan" dengan kondisi "data pengajuan tetap konsisten setelah histori besar"

  @stress @priority-high @REQ-027 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-009 — Alasan penolakan sepuluh ribu karakter tidak merusak integritas
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "QA-P0001 Menunggu; batas panjang produksi belum ditentukan."
    When user mengklik tombol "Tolak"
    And user mengisi field "Alasan Penolakan" dengan "QA-LONG-TEXT-10000"
    And user mengklik tombol "Tolak Pengajuan"
    Then sistem memverifikasi elemen "Hasil Recovery" dengan kondisi "teks diterima utuh dengan satu reject ATAU ditolak eksplisit tanpa mutasi; tidak silent truncate"
    And sistem memverifikasi elemen "Status Tiket" dengan kondisi "aktif"
    And sistem memverifikasi elemen "Status Refund" dengan kondisi "belum diproses"

  @stress @priority-high @REQ-010 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-010 — Keterangan panjang pada submit tidak mengubah denda atau pemilik
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Tiket eligible; batas field belum diketahui."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "QA-LONG-TEXT-10000"
    And user mengklik tombol "Batalkan Tiket"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Hasil Recovery" dengan kondisi "keterangan diterima utuh ATAU validasi eksplisit tanpa pengajuan baru; tidak terpotong diam-diam"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "tidak mengubah denda, pemilik atau menggandakan pengajuan"

  @stress @priority-high @REQ-008 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-011 — Perubahan master berulang bersamaan seribu submit menjaga versi snapshot
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Cabang; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "Pusat membuat 100 versi master; 100 sesi mengirim 1.000 tiket eligible berbeda."
    When user mengisi field "Tanggal Awal" dengan "2026-10-20"
    And user mengisi field "Tanggal Akhir" dengan "2026-10-20"
    And user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user memilih opsi "QA-T0001-001" pada field "ID Tiket"
    And user mengisi field "Keterangan Batal Tiket" dengan "Permintaan penumpang"
    And user mengklik tombol "Ajukan Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "terlihat; konfirmasi untuk QA-T0001-001"
    When user mengklik tombol "Kirim Pengajuan"
    Then sistem memverifikasi elemen "Hasil Paralel" dengan kondisi "1000 snapshot memakai satu versi valid masing-masing"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "tidak campur persen/nominal/refund antar versi; snapshot tidak berubah setelah update berikutnya"

  @stress @priority-high @REQ-030 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-012 — Timeout dan retry approval massal tidak menghasilkan refund ganda
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "100 pengajuan Menunggu; tiap respons pertama hilang setelah commit; retry 3 kali per pengajuan."
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "Setujui Pembatalan; tiket QA-T0001-001; refund Rp300.000"
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Hasil Recovery" dengan kondisi "seluruh hasil dapat direkonsiliasi; tidak stuck tanpa status pemulihan"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "maksimum satu approval/refund per pengajuan; total sukses sesuai ledger"

  @stress @priority-high @REQ-024 @screen-daftar-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-013 — Banyak sesi lintas unit tidak membocorkan status atau finansial
    Given user berada di halaman "Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "100 sesi Agen dari 100 unit; masing-masing memiliki 10 pengajuan."
    When user mengklik tombol "Pengajuan Pembatalan"
    And user mengklik tombol "Semua"
    And user mengklik tombol "Lihat detail"
    Then sistem memverifikasi elemen "Hasil Paralel" dengan kondisi "setiap sesi hanya data unitnya; Cabang monitoring hanya Agen terkait"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "nol kebocoran identitas/denda/refund/alasan lintas unit"

  @stress @priority-high @REQ-030 @screen-detail-pengajuan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-014 — Gelombang approve dan reject campuran menjaga konsistensi setiap tiket
    Given user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Kantor Pusat; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "1.000 pengajuan; 100 sesi; dua keputusan berkompetisi per pengajuan."
    When user mengklik tombol "Setujui Pembatalan"
    Then sistem memverifikasi elemen "Dialog Aktif" dengan kondisi "Setujui Pembatalan; tiket QA-T0001-001; refund Rp300.000"
    When user mengklik tombol "Setujui Pembatalan"
    And user berada di halaman "Detail Pengajuan Pembatalan" dengan konteks "sesi pesaing"
    And user mengklik tombol "Tolak"
    And user mengisi field "Alasan Penolakan" dengan "Dokumen pendukung tidak dilampirkan"
    And user mengklik tombol "Tolak Pengajuan"
    Then sistem memverifikasi elemen "Hasil Paralel" dengan kondisi "setiap pengajuan tepat satu Disetujui atau Ditolak"
    And sistem memverifikasi elemen "Audit Transaksi" dengan kondisi "refund hanya untuk Disetujui tepat sekali; Ditolak tetap aktif/nol refund"

  @stress @priority-high @REQ-029 @screen-ajukan-pembatalan
  Scenario: RO317-APPROVAL-PEMBATALAN-TIKET-AGEN-PUSAT-STR-015 — Pergantian jadwal cepat tidak menampilkan hasil respons lama
    Given user berada di halaman "Buat Pembatalan Tiket" dengan konteks ""
    And user memiliki kondisi "User terautentikasi sebagai Agen; fixture terisolasi sesuai testData."
    And user memiliki kondisi "Jam server dibekukan pada submissionAt; jadwal memakai instant departureAt."
    And user memiliki kondisi "100 perubahan jadwal dengan respons lookup disusun urutan terbalik."
    When user memilih opsi "QA-J01" pada field "Pilih Jadwal Kapal"
    And user mengklik tombol "Ganti Jadwal"
    And user memilih opsi "QA-J02" pada field "Pilih Jadwal Kapal"
    And user mengklik tombol "Ubah Pencarian"
    Then sistem memverifikasi elemen "ID Tiket" dengan kondisi "pilihan hanya terkait jadwal aktif terakhir; tidak terpilih otomatis"
    And sistem memverifikasi elemen "Ringkasan Finansial" dengan kondisi "tidak memuat hasil respons stale"
    And sistem memverifikasi elemen "Batalkan Tiket" dengan kondisi "disabled sampai tiket terakhir valid dipilih"

