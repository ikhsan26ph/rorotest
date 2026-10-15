Feature: RO323 Notifikasi Sistem, Setting Global dan Preferensi Personal
  Fixture transaksi, clock, katalog existing, fault, dan sesi dijalankan sebelum scenario.
  Selector baris di-scope ke eventId/recordId/accountId dari metadata JSON.
  Expect bernilai tidak terlihat/count 0/disabled dipetakan ke assertion Playwright yang sesuai.

  @positive @priority-high @REQ-008 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-001 | Top Up Saldo Berhasil: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture top-up operator/cabang berhasil sudah commit; eventId topup-p-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Top Up Saldo Berhasil untuk TU-CBG-001" dengan kondisi "{\"body\": \"Top up saldo Cabang Balikpapan sebesar Rp5.000.000 berhasil. Saldo saat ini Rp12.450.000.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Top Up Saldo Berhasil\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Riwayat Saldo > TU-CBG-001\", \"recordId\": \"TU-CBG-001\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-008 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-001 | Top Up Saldo Berhasil: top-up operator/cabang gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture top-up operator/cabang gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Top Up Saldo Berhasil untuk TU-CBG-001" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"topup-p-failed\"}"

  @negative @priority-high @REQ-008 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-002 | Top Up Saldo Berhasil: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture top-up operator/cabang berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Top Up Saldo Berhasil untuk TU-CBG-001" dengan kondisi "{\"count\": 0, \"eventId\": \"topup-p-global\"}"

  @negative @priority-high @REQ-008 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-003 | Top Up Saldo Berhasil: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture top-up operator/cabang berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Top Up Saldo Berhasil untuk TU-CBG-001" dengan kondisi "{\"count\": 0, \"eventId\": \"topup-p-personal\"}"

  @positive @priority-high @REQ-009 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-002 | Top Up Saldo Agen Berhasil: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture Cabang berhasil top-up Agen sudah commit; eventId topup-c-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Top Up Saldo Agen Berhasil untuk TU-AGN-001" dengan kondisi "{\"body\": \"Top up saldo PT. Agen RORO Balikpapan sebesar Rp5.000.000 berhasil. Saldo agen saat ini Rp12.450.000.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Top Up Saldo Agen Berhasil\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Riwayat Saldo > TU-AGN-001\", \"recordId\": \"TU-AGN-001\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-009 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-004 | Top Up Saldo Agen Berhasil: top-up Agen dibatalkan sebelum berhasil, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture top-up Agen dibatalkan sebelum berhasil; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Top Up Saldo Agen Berhasil untuk TU-AGN-001" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"topup-c-failed\"}"

  @negative @priority-high @REQ-009 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-005 | Top Up Saldo Agen Berhasil: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture Cabang berhasil top-up Agen sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Top Up Saldo Agen Berhasil untuk TU-AGN-001" dengan kondisi "{\"count\": 0, \"eventId\": \"topup-c-global\"}"

  @negative @priority-high @REQ-009 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-006 | Top Up Saldo Agen Berhasil: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture Cabang berhasil top-up Agen sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Top Up Saldo Agen Berhasil untuk TU-AGN-001" dengan kondisi "{\"count\": 0, \"eventId\": \"topup-c-personal\"}"

  @positive @priority-high @REQ-010 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-003 | Saldo Berhasil Ditambahkan: pesan dan Detail untuk Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture saldo Agen berhasil ditambah Cabang sudah commit; eventId topup-a-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Saldo Berhasil Ditambahkan untuk TU-AGN-001" dengan kondisi "{\"body\": \"Saldo sebesar Rp5.000.000 telah ditambahkan oleh Cabang Balikpapan. Saldo Anda saat ini Rp12.450.000.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Saldo Berhasil Ditambahkan\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Riwayat Saldo > TU-AGN-001\", \"recordId\": \"TU-AGN-001\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-010 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-007 | Saldo Berhasil Ditambahkan: penambahan saldo Agen gagal, penerima Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture penambahan saldo Agen gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Saldo Berhasil Ditambahkan untuk TU-AGN-001" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"topup-a-failed\"}"

  @negative @priority-high @REQ-010 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-008 | Saldo Berhasil Ditambahkan: ditekan ketika global OFF
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture saldo Agen berhasil ditambah Cabang sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Saldo Berhasil Ditambahkan untuk TU-AGN-001" dengan kondisi "{\"count\": 0, \"eventId\": \"topup-a-global\"}"

  @negative @priority-high @REQ-010 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-009 | Saldo Berhasil Ditambahkan: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture saldo Agen berhasil ditambah Cabang sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Saldo Berhasil Ditambahkan untuk TU-AGN-001" dengan kondisi "{\"count\": 0, \"eventId\": \"topup-a-personal\"}"

  @positive @priority-high @REQ-011 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-004 | Pengajuan Tiket Gratis: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan tiket gratis berhasil dibuat sudah commit; eventId free-request-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Tiket Gratis untuk G8902260" dengan kondisi "{\"body\": \"Pengajuan tiket gratis untuk order G8902260 telah masuk dan menunggu persetujuan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Tiket Gratis\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Persetujuan Tiket > Detail G8902260\", \"recordId\": \"G8902260\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-011 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-010 | Pengajuan Tiket Gratis: pengajuan tiket gratis gagal dibuat, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan tiket gratis gagal dibuat; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Tiket Gratis untuk G8902260" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"free-request-failed\"}"

  @positive @priority-high @REQ-011 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-005 | Pengajuan Tiket Gratis: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan tiket gratis berhasil dibuat sudah commit; eventId free-request-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Tiket Gratis untuk G8902260" dengan kondisi "{\"body\": \"Pengajuan tiket gratis untuk order G8902260 telah masuk dan menunggu persetujuan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Tiket Gratis\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Persetujuan Tiket > Detail G8902260\", \"recordId\": \"G8902260\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-011 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-011 | Pengajuan Tiket Gratis: pengajuan tiket gratis gagal dibuat, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan tiket gratis gagal dibuat; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Tiket Gratis untuk G8902260" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"free-request-failed\"}"

  @negative @priority-high @REQ-011 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-012 | Pengajuan Tiket Gratis: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan tiket gratis berhasil dibuat sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Tiket Gratis untuk G8902260" dengan kondisi "{\"count\": 0, \"eventId\": \"free-request-global\"}"

  @negative @priority-high @REQ-011 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-013 | Pengajuan Tiket Gratis: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan tiket gratis berhasil dibuat sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Tiket Gratis untuk G8902260" dengan kondisi "{\"count\": 0, \"eventId\": \"free-request-personal\"}"

  @positive @priority-high @REQ-012 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-006 | Tiket Gratis Disetujui Cabang: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture approval Cabang berhasil sudah commit; eventId free-c-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Tiket Gratis Disetujui Cabang untuk G8902260" dengan kondisi "{\"body\": \"Pengajuan tiket gratis untuk order G8902260 telah disetujui Cabang Balikpapan dan menunggu persetujuan Kantor Pusat.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Tiket Gratis Disetujui Cabang\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Persetujuan Tiket > Detail G8902260\", \"recordId\": \"G8902260\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-012 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-014 | Tiket Gratis Disetujui Cabang: approval Cabang gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture approval Cabang gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Tiket Gratis Disetujui Cabang untuk G8902260" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"free-c-failed\"}"

  @positive @priority-high @REQ-012 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-007 | Tiket Gratis Disetujui Cabang: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture approval Cabang berhasil sudah commit; eventId free-c-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Tiket Gratis Disetujui Cabang untuk G8902260" dengan kondisi "{\"body\": \"Pengajuan tiket gratis untuk order G8902260 telah disetujui Cabang Balikpapan dan menunggu persetujuan Kantor Pusat.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Tiket Gratis Disetujui Cabang\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Persetujuan Tiket > Detail G8902260\", \"recordId\": \"G8902260\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-012 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-015 | Tiket Gratis Disetujui Cabang: approval Cabang gagal, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture approval Cabang gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Tiket Gratis Disetujui Cabang untuk G8902260" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"free-c-failed\"}"

  @negative @priority-high @REQ-012 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-016 | Tiket Gratis Disetujui Cabang: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture approval Cabang berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Tiket Gratis Disetujui Cabang untuk G8902260" dengan kondisi "{\"count\": 0, \"eventId\": \"free-c-global\"}"

  @negative @priority-high @REQ-012 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-017 | Tiket Gratis Disetujui Cabang: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture approval Cabang berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Tiket Gratis Disetujui Cabang untuk G8902260" dengan kondisi "{\"count\": 0, \"eventId\": \"free-c-personal\"}"

  @positive @priority-high @REQ-013 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-008 | Tiket Gratis Disetujui Pusat: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture approval Pusat berhasil sudah commit; eventId free-p-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Tiket Gratis Disetujui Pusat untuk G8902260" dengan kondisi "{\"body\": \"Pengajuan tiket gratis untuk order G8902260 telah disetujui Kantor Pusat, dan menunggu persetujuan Kantor Cabang.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Tiket Gratis Disetujui Pusat\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Persetujuan Tiket > Detail G8902260\", \"recordId\": \"G8902260\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-013 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-018 | Tiket Gratis Disetujui Pusat: approval Pusat gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture approval Pusat gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Tiket Gratis Disetujui Pusat untuk G8902260" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"free-p-failed\"}"

  @positive @priority-high @REQ-013 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-009 | Tiket Gratis Disetujui Pusat: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture approval Pusat berhasil sudah commit; eventId free-p-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Tiket Gratis Disetujui Pusat untuk G8902260" dengan kondisi "{\"body\": \"Pengajuan tiket gratis untuk order G8902260 telah disetujui Kantor Pusat, dan menunggu persetujuan Kantor Cabang.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Tiket Gratis Disetujui Pusat\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Persetujuan Tiket > Detail G8902260\", \"recordId\": \"G8902260\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-013 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-019 | Tiket Gratis Disetujui Pusat: approval Pusat gagal, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture approval Pusat gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Tiket Gratis Disetujui Pusat untuk G8902260" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"free-p-failed\"}"

  @negative @priority-high @REQ-013 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-020 | Tiket Gratis Disetujui Pusat: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture approval Pusat berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Tiket Gratis Disetujui Pusat untuk G8902260" dengan kondisi "{\"count\": 0, \"eventId\": \"free-p-global\"}"

  @negative @priority-high @REQ-013 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-021 | Tiket Gratis Disetujui Pusat: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture approval Pusat berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Tiket Gratis Disetujui Pusat untuk G8902260" dengan kondisi "{\"count\": 0, \"eventId\": \"free-p-personal\"}"

  @positive @priority-high @REQ-014 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-010 | Transaksi Pembayaran TOP: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture order TOP berhasil dibuat sudah commit; eventId top-create-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Transaksi Pembayaran TOP untuk T8810921" dengan kondisi "{\"body\": \"Order T8810921 milik CV. Borneo Makmur menggunakan pembayaran TOP dengan jatuh tempo 14 hari.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Transaksi Pembayaran TOP\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Daftar Piutang > Detail Piutang T8810921\", \"recordId\": \"T8810921\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-014 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-022 | Transaksi Pembayaran TOP: order TOP gagal dibuat, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture order TOP gagal dibuat; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Transaksi Pembayaran TOP untuk T8810921" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"top-create-failed\"}"

  @positive @priority-high @REQ-014 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-011 | Transaksi Pembayaran TOP: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture order TOP berhasil dibuat sudah commit; eventId top-create-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Transaksi Pembayaran TOP untuk T8810921" dengan kondisi "{\"body\": \"Order T8810921 milik CV. Borneo Makmur menggunakan pembayaran TOP dengan jatuh tempo 14 hari.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Transaksi Pembayaran TOP\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Daftar Piutang > Detail Piutang T8810921\", \"recordId\": \"T8810921\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-014 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-023 | Transaksi Pembayaran TOP: order TOP gagal dibuat, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture order TOP gagal dibuat; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Transaksi Pembayaran TOP untuk T8810921" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"top-create-failed\"}"

  @negative @priority-high @REQ-014 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-024 | Transaksi Pembayaran TOP: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture order TOP berhasil dibuat sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Transaksi Pembayaran TOP untuk T8810921" dengan kondisi "{\"count\": 0, \"eventId\": \"top-create-global\"}"

  @negative @priority-high @REQ-014 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-025 | Transaksi Pembayaran TOP: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture order TOP berhasil dibuat sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Transaksi Pembayaran TOP untuk T8810921" dengan kondisi "{\"count\": 0, \"eventId\": \"top-create-personal\"}"

  @positive @priority-high @REQ-015 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-012 | Piutang TOP Telah Lunas: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture piutang TOP ditandai lunas sudah commit; eventId top-paid-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Telah Lunas untuk T8799310" dengan kondisi "{\"body\": \"Piutang TOP order T8799310 milik PT. Sinar Samudra Logistik telah ditandai lunas.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Piutang TOP Telah Lunas\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Daftar Piutang > Detail Piutang T8799310\", \"recordId\": \"T8799310\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-015 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-026 | Piutang TOP Telah Lunas: penandaan lunas gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture penandaan lunas gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Telah Lunas untuk T8799310" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"top-paid-failed\"}"

  @positive @priority-high @REQ-015 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-013 | Piutang TOP Telah Lunas: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture piutang TOP ditandai lunas sudah commit; eventId top-paid-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Telah Lunas untuk T8799310" dengan kondisi "{\"body\": \"Piutang TOP order T8799310 milik PT. Sinar Samudra Logistik telah ditandai lunas.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Piutang TOP Telah Lunas\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Daftar Piutang > Detail Piutang T8799310\", \"recordId\": \"T8799310\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-015 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-027 | Piutang TOP Telah Lunas: penandaan lunas gagal, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture penandaan lunas gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Telah Lunas untuk T8799310" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"top-paid-failed\"}"

  @negative @priority-high @REQ-015 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-028 | Piutang TOP Telah Lunas: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture piutang TOP ditandai lunas sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Telah Lunas untuk T8799310" dengan kondisi "{\"count\": 0, \"eventId\": \"top-paid-global\"}"

  @negative @priority-high @REQ-015 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-029 | Piutang TOP Telah Lunas: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture piutang TOP ditandai lunas sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Telah Lunas untuk T8799310" dengan kondisi "{\"count\": 0, \"eventId\": \"top-paid-personal\"}"

  @positive @priority-high @REQ-016 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-014 | Piutang TOP Jatuh Tempo H-3: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture job tanggal H-3 untuk piutang belum lunas sudah commit; eventId top-h3-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Jatuh Tempo H-3 untuk T8810921" dengan kondisi "{\"body\": \"Piutang TOP CV. Borneo Makmur order T8810921 sebesar Rp7.250.000 jatuh tempo pada 01 Okt 2026.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Piutang TOP Jatuh Tempo H-3\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Daftar Piutang > Detail Piutang T8810921\", \"recordId\": \"T8810921\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-016 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-030 | Piutang TOP Jatuh Tempo H-3: job pada H-4 sehingga belum H-3, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture job pada H-4 sehingga belum H-3; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Jatuh Tempo H-3 untuk T8810921" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"top-h3-failed\"}"

  @positive @priority-high @REQ-016 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-015 | Piutang TOP Jatuh Tempo H-3: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture job tanggal H-3 untuk piutang belum lunas sudah commit; eventId top-h3-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Jatuh Tempo H-3 untuk T8810921" dengan kondisi "{\"body\": \"Piutang TOP CV. Borneo Makmur order T8810921 sebesar Rp7.250.000 jatuh tempo pada 01 Okt 2026.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Piutang TOP Jatuh Tempo H-3\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Daftar Piutang > Detail Piutang T8810921\", \"recordId\": \"T8810921\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-016 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-031 | Piutang TOP Jatuh Tempo H-3: job pada H-4 sehingga belum H-3, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture job pada H-4 sehingga belum H-3; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Jatuh Tempo H-3 untuk T8810921" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"top-h3-failed\"}"

  @negative @priority-high @REQ-016 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-032 | Piutang TOP Jatuh Tempo H-3: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture job tanggal H-3 untuk piutang belum lunas sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Jatuh Tempo H-3 untuk T8810921" dengan kondisi "{\"count\": 0, \"eventId\": \"top-h3-global\"}"

  @negative @priority-high @REQ-016 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-033 | Piutang TOP Jatuh Tempo H-3: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture job tanggal H-3 untuk piutang belum lunas sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Jatuh Tempo H-3 untuk T8810921" dengan kondisi "{\"count\": 0, \"eventId\": \"top-h3-personal\"}"

  @positive @priority-high @REQ-017 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-016 | Piutang TOP Jatuh Tempo Hari Ini: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture job pada tanggal jatuh tempo piutang belum lunas sudah commit; eventId top-h0-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Jatuh Tempo Hari Ini untuk T8812044" dengan kondisi "{\"body\": \"Piutang TOP PT. Sinar Samudra Logistik order T8812044 sebesar Rp18.450.000 jatuh tempo hari ini.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Piutang TOP Jatuh Tempo Hari Ini\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Daftar Piutang > Detail Piutang T8812044\", \"recordId\": \"T8812044\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-017 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-034 | Piutang TOP Jatuh Tempo Hari Ini: job pada H-1 sehingga belum jatuh tempo hari ini, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture job pada H-1 sehingga belum jatuh tempo hari ini; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Jatuh Tempo Hari Ini untuk T8812044" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"top-h0-failed\"}"

  @positive @priority-high @REQ-017 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-017 | Piutang TOP Jatuh Tempo Hari Ini: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture job pada tanggal jatuh tempo piutang belum lunas sudah commit; eventId top-h0-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Jatuh Tempo Hari Ini untuk T8812044" dengan kondisi "{\"body\": \"Piutang TOP PT. Sinar Samudra Logistik order T8812044 sebesar Rp18.450.000 jatuh tempo hari ini.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Piutang TOP Jatuh Tempo Hari Ini\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Daftar Piutang > Detail Piutang T8812044\", \"recordId\": \"T8812044\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-017 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-035 | Piutang TOP Jatuh Tempo Hari Ini: job pada H-1 sehingga belum jatuh tempo hari ini, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture job pada H-1 sehingga belum jatuh tempo hari ini; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Jatuh Tempo Hari Ini untuk T8812044" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"top-h0-failed\"}"

  @negative @priority-high @REQ-017 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-036 | Piutang TOP Jatuh Tempo Hari Ini: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture job pada tanggal jatuh tempo piutang belum lunas sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Jatuh Tempo Hari Ini untuk T8812044" dengan kondisi "{\"count\": 0, \"eventId\": \"top-h0-global\"}"

  @negative @priority-high @REQ-017 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-037 | Piutang TOP Jatuh Tempo Hari Ini: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture job pada tanggal jatuh tempo piutang belum lunas sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Piutang TOP Jatuh Tempo Hari Ini untuk T8812044" dengan kondisi "{\"count\": 0, \"eventId\": \"top-h0-personal\"}"

  @positive @priority-high @REQ-018 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-018 | Pembayaran Berhasil: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pembayaran order berhasil sudah commit; eventId payment-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembayaran Berhasil untuk V8987400" dengan kondisi "{\"body\": \"Pembayaran order V8987400 sebesar Rp505.000 berhasil. E-tiket sudah dapat diproses.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pembayaran Berhasil\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Detail Order V8987400\", \"recordId\": \"V8987400\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-018 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-038 | Pembayaran Berhasil: pembayaran order gagal/expired, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pembayaran order gagal/expired; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembayaran Berhasil untuk V8987400" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"payment-failed\"}"

  @positive @priority-high @REQ-018 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-019 | Pembayaran Berhasil: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pembayaran order berhasil sudah commit; eventId payment-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembayaran Berhasil untuk V8987400" dengan kondisi "{\"body\": \"Pembayaran order V8987400 sebesar Rp505.000 berhasil. E-tiket sudah dapat diproses.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pembayaran Berhasil\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Detail Order V8987400\", \"recordId\": \"V8987400\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-018 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-039 | Pembayaran Berhasil: pembayaran order gagal/expired, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pembayaran order gagal/expired; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembayaran Berhasil untuk V8987400" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"payment-failed\"}"

  @positive @priority-high @REQ-018 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-020 | Pembayaran Berhasil: pesan dan Detail untuk Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture pembayaran order berhasil sudah commit; eventId payment-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembayaran Berhasil untuk V8987400" dengan kondisi "{\"body\": \"Pembayaran order V8987400 sebesar Rp505.000 berhasil. E-tiket sudah dapat diproses.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pembayaran Berhasil\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Detail Order V8987400\", \"recordId\": \"V8987400\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-018 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-040 | Pembayaran Berhasil: pembayaran order gagal/expired, penerima Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture pembayaran order gagal/expired; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembayaran Berhasil untuk V8987400" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"payment-failed\"}"

  @positive @priority-high @REQ-018 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-021 | Pembayaran Berhasil: pesan dan Detail untuk User Umum
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Fixture pembayaran order berhasil sudah commit; eventId payment-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembayaran Berhasil untuk V8987400" dengan kondisi "{\"body\": \"Pembayaran order V8987400 sebesar Rp505.000 berhasil. E-tiket Anda sudah tersedia.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pembayaran Berhasil\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Detail Order V8987400\", \"recordId\": \"V8987400\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-018 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-041 | Pembayaran Berhasil: pembayaran order gagal/expired, penerima User Umum
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Fixture pembayaran order gagal/expired; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembayaran Berhasil untuk V8987400" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"payment-failed\"}"

  @negative @priority-high @REQ-018 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-042 | Pembayaran Berhasil: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pembayaran order berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembayaran Berhasil untuk V8987400" dengan kondisi "{\"count\": 0, \"eventId\": \"payment-global\"}"

  @negative @priority-high @REQ-018 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-043 | Pembayaran Berhasil: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pembayaran order berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembayaran Berhasil untuk V8987400" dengan kondisi "{\"count\": 0, \"eventId\": \"payment-personal\"}"

  @positive @priority-high @REQ-019 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-022 | Pengingat Keberangkatan: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture job H-1 jadwal tiket milik penerima sudah commit; eventId departure-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengingat Keberangkatan untuk V8987400" dengan kondisi "{\"body\": \"KM. SWARNA BAHTERA voyage 09.26 (13) Balikpapan (BPN) → Parepare (PAP) berangkat besok, 01 Okt 2026 15:00 WITA.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengingat Keberangkatan\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Detail Order V8987400\", \"recordId\": \"V8987400\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-019 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-044 | Pengingat Keberangkatan: job H-2 sehingga belum H-1, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture job H-2 sehingga belum H-1; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengingat Keberangkatan untuk V8987400" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"departure-failed\"}"

  @positive @priority-high @REQ-019 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-023 | Pengingat Keberangkatan: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture job H-1 jadwal tiket milik penerima sudah commit; eventId departure-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengingat Keberangkatan untuk V8987400" dengan kondisi "{\"body\": \"KM. SWARNA BAHTERA voyage 09.26 (13) Balikpapan (BPN) → Parepare (PAP) berangkat besok, 01 Okt 2026 15:00 WITA.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengingat Keberangkatan\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Detail Order V8987400\", \"recordId\": \"V8987400\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-019 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-045 | Pengingat Keberangkatan: job H-2 sehingga belum H-1, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture job H-2 sehingga belum H-1; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengingat Keberangkatan untuk V8987400" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"departure-failed\"}"

  @positive @priority-high @REQ-019 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-024 | Pengingat Keberangkatan: pesan dan Detail untuk Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture job H-1 jadwal tiket milik penerima sudah commit; eventId departure-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengingat Keberangkatan untuk V8987400" dengan kondisi "{\"body\": \"KM. SWARNA BAHTERA voyage 09.26 (13) Balikpapan (BPN) → Parepare (PAP) berangkat besok, 01 Okt 2026 15:00 WITA.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengingat Keberangkatan\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Detail Order V8987400\", \"recordId\": \"V8987400\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-019 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-046 | Pengingat Keberangkatan: job H-2 sehingga belum H-1, penerima Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture job H-2 sehingga belum H-1; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengingat Keberangkatan untuk V8987400" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"departure-failed\"}"

  @positive @priority-high @REQ-019 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-025 | Pengingat Keberangkatan: pesan dan Detail untuk User Umum
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Fixture job H-1 jadwal tiket milik penerima sudah commit; eventId departure-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengingat Keberangkatan untuk V8987400" dengan kondisi "{\"body\": \"KM. SWARNA BAHTERA voyage 09.26 (13) Balikpapan (BPN) → Parepare (PAP) berangkat besok, 01 Okt 2026 15:00 WITA.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengingat Keberangkatan\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Detail Order V8987400\", \"recordId\": \"V8987400\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-019 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-047 | Pengingat Keberangkatan: job H-2 sehingga belum H-1, penerima User Umum
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Fixture job H-2 sehingga belum H-1; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengingat Keberangkatan untuk V8987400" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"departure-failed\"}"

  @negative @priority-high @REQ-019 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-048 | Pengingat Keberangkatan: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture job H-1 jadwal tiket milik penerima sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengingat Keberangkatan untuk V8987400" dengan kondisi "{\"count\": 0, \"eventId\": \"departure-global\"}"

  @negative @priority-high @REQ-019 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-049 | Pengingat Keberangkatan: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture job H-1 jadwal tiket milik penerima sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengingat Keberangkatan untuk V8987400" dengan kondisi "{\"count\": 0, \"eventId\": \"departure-personal\"}"

  @positive @priority-high @REQ-020 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-026 | Pengajuan Device Baru: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan device berhasil sudah commit; eventId device-new-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Device Baru untuk COM-ADM-003" dengan kondisi "{\"body\": \"PT. Agen RORO Balikpapan - Bapak Abdul Dulman mengajukan perangkat baru Galaxy A52s 5G · Google Chrome (COM-ADM-003). Menunggu persetujuan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Device Baru\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Manajemen Device > Detail/Approval Device COM-ADM-003\", \"recordId\": \"COM-ADM-003\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-020 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-050 | Pengajuan Device Baru: pengajuan device gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan device gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Device Baru untuk COM-ADM-003" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"device-new-failed\"}"

  @positive @priority-high @REQ-020 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-027 | Pengajuan Device Baru: pesan dan Detail untuk Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan device berhasil sudah commit; eventId device-new-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Device Baru untuk COM-ADM-003" dengan kondisi "{\"body\": \"Pengajuan perangkat Galaxy A52s 5G · Google Chrome (COM-ADM-003) berhasil dikirim dan menunggu persetujuan Kantor Pusat.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Device Baru\"}"
    And sistem memverifikasi elemen "Detail" dengan kondisi "disabled"
    When user mengklik tombol "Baca notifikasi"
    Then sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-020 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-051 | Pengajuan Device Baru: pengajuan device gagal, penerima Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan device gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Device Baru untuk COM-ADM-003" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"device-new-failed\"}"

  @negative @priority-high @REQ-020 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-052 | Pengajuan Device Baru: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan device berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Device Baru untuk COM-ADM-003" dengan kondisi "{\"count\": 0, \"eventId\": \"device-new-global\"}"

  @negative @priority-high @REQ-020 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-053 | Pengajuan Device Baru: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan device berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Device Baru untuk COM-ADM-003" dengan kondisi "{\"count\": 0, \"eventId\": \"device-new-personal\"}"

  @positive @priority-high @REQ-021 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-028 | Pengajuan Device Disetujui: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture approval device Pusat berhasil sudah commit; eventId device-approved-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Device Disetujui untuk COM-ADM-003" dengan kondisi "{\"body\": \"Perangkat Galaxy A52s 5G · Google Chrome (COM-ADM-003) milik PT. Agen RORO Balikpapan - Bapak Abdul Dulman telah disetujui.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Device Disetujui\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Manajemen Device > Detail/Approval Device COM-ADM-003\", \"recordId\": \"COM-ADM-003\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-021 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-054 | Pengajuan Device Disetujui: approval device gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture approval device gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Device Disetujui untuk COM-ADM-003" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"device-approved-failed\"}"

  @positive @priority-high @REQ-021 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-029 | Pengajuan Device Disetujui: pesan dan Detail untuk Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture approval device Pusat berhasil sudah commit; eventId device-approved-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Device Disetujui untuk COM-ADM-003" dengan kondisi "{\"body\": \"Perangkat Galaxy A52s 5G · Google Chrome (COM-ADM-003) telah disetujui Kantor Pusat.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Device Disetujui\"}"
    And sistem memverifikasi elemen "Detail" dengan kondisi "disabled"
    When user mengklik tombol "Baca notifikasi"
    Then sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-021 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-055 | Pengajuan Device Disetujui: approval device gagal, penerima Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture approval device gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Device Disetujui untuk COM-ADM-003" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"device-approved-failed\"}"

  @negative @priority-high @REQ-021 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-056 | Pengajuan Device Disetujui: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture approval device Pusat berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Device Disetujui untuk COM-ADM-003" dengan kondisi "{\"count\": 0, \"eventId\": \"device-approved-global\"}"

  @negative @priority-high @REQ-021 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-057 | Pengajuan Device Disetujui: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture approval device Pusat berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Device Disetujui untuk COM-ADM-003" dengan kondisi "{\"count\": 0, \"eventId\": \"device-approved-personal\"}"

  @positive @priority-high @REQ-022 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-030 | Pencabutan Approval Device: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pencabutan approval device berhasil sudah commit; eventId device-revoked-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pencabutan Approval Device untuk COM-ADM-003" dengan kondisi "{\"body\": \"Approval perangkat Galaxy A52s 5G · Google Chrome (COM-ADM-003) milik PT. Agen RORO Balikpapan - Bapak Abdul Dulman telah dicabut.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pencabutan Approval Device\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Manajemen Device > Detail/Approval Device COM-ADM-003\", \"recordId\": \"COM-ADM-003\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-022 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-058 | Pencabutan Approval Device: pencabutan approval device gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pencabutan approval device gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pencabutan Approval Device untuk COM-ADM-003" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"device-revoked-failed\"}"

  @positive @priority-high @REQ-022 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-031 | Pencabutan Approval Device: pesan dan Detail untuk Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture pencabutan approval device berhasil sudah commit; eventId device-revoked-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pencabutan Approval Device untuk COM-ADM-003" dengan kondisi "{\"body\": \"Persetujuan perangkat Galaxy A52s 5G · Google Chrome (COM-ADM-003) telah dicabut oleh Kantor Pusat.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pencabutan Approval Device\"}"
    And sistem memverifikasi elemen "Detail" dengan kondisi "disabled"
    When user mengklik tombol "Baca notifikasi"
    Then sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-022 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-059 | Pencabutan Approval Device: pencabutan approval device gagal, penerima Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture pencabutan approval device gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pencabutan Approval Device untuk COM-ADM-003" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"device-revoked-failed\"}"

  @negative @priority-high @REQ-022 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-060 | Pencabutan Approval Device: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pencabutan approval device berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pencabutan Approval Device untuk COM-ADM-003" dengan kondisi "{\"count\": 0, \"eventId\": \"device-revoked-global\"}"

  @negative @priority-high @REQ-022 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-061 | Pencabutan Approval Device: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pencabutan approval device berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pencabutan Approval Device untuk COM-ADM-003" dengan kondisi "{\"count\": 0, \"eventId\": \"device-revoked-personal\"}"

  @positive @priority-high @REQ-023 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-032 | Pengajuan Pembatalan: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan pembatalan tiket berhasil sudah commit; eventId cancel-request-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Pembatalan untuk C6845054-001" dengan kondisi "{\"body\": \"Terdapat pengajuan pembatalan tiket C6845054-001 dari PT. Agen RORO Balikpapan. Menunggu persetujuan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Pembatalan\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Pembatalan Tiket > Detail/Validasi Pembatalan C6845054-001\", \"recordId\": \"C6845054-001\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-023 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-062 | Pengajuan Pembatalan: pengajuan pembatalan gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan pembatalan gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Pembatalan untuk C6845054-001" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"cancel-request-failed\"}"

  @positive @priority-high @REQ-023 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-033 | Pengajuan Pembatalan: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan pembatalan tiket berhasil sudah commit; eventId cancel-request-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Pembatalan untuk C6845054-001" dengan kondisi "{\"body\": \"Terdapat pengajuan pembatalan tiket C6845054-001 dari PT. Agen RORO Balikpapan. Menunggu persetujuan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Pembatalan\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Pembatalan Tiket > Detail/Validasi Pembatalan C6845054-001\", \"recordId\": \"C6845054-001\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-023 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-063 | Pengajuan Pembatalan: pengajuan pembatalan gagal, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan pembatalan gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Pembatalan untuk C6845054-001" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"cancel-request-failed\"}"

  @positive @priority-high @REQ-023 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-034 | Pengajuan Pembatalan: pesan dan Detail untuk Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan pembatalan tiket berhasil sudah commit; eventId cancel-request-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Pembatalan untuk C6845054-001" dengan kondisi "{\"body\": \"Pengajuan pembatalan tiket C6845054-001 berhasil dikirim dan menunggu persetujuan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Pembatalan\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Pembatalan Tiket > Detail Pembatalan C6845054-001\", \"recordId\": \"C6845054-001\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-023 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-064 | Pengajuan Pembatalan: pengajuan pembatalan gagal, penerima Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan pembatalan gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Pembatalan untuk C6845054-001" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"cancel-request-failed\"}"

  @negative @priority-high @REQ-023 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-065 | Pengajuan Pembatalan: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan pembatalan tiket berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Pembatalan untuk C6845054-001" dengan kondisi "{\"count\": 0, \"eventId\": \"cancel-request-global\"}"

  @negative @priority-high @REQ-023 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-066 | Pengajuan Pembatalan: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan pembatalan tiket berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Pembatalan untuk C6845054-001" dengan kondisi "{\"count\": 0, \"eventId\": \"cancel-request-personal\"}"

  @positive @priority-high @REQ-024 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-035 | Pembatalan Disetujui: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pembatalan disetujui sudah commit; eventId cancel-approved-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembatalan Disetujui untuk H8937453-005" dengan kondisi "{\"body\": \"Pembatalan tiket H8937453-005 telah disetujui. Denda sebesar Rp126.250 dikenakan sesuai ketentuan pembatalan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pembatalan Disetujui\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Pembatalan Tiket > Detail Pembatalan H8937453-005\", \"recordId\": \"H8937453-005\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-024 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-067 | Pembatalan Disetujui: approval pembatalan gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture approval pembatalan gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembatalan Disetujui untuk H8937453-005" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"cancel-approved-failed\"}"

  @positive @priority-high @REQ-024 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-036 | Pembatalan Disetujui: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pembatalan disetujui sudah commit; eventId cancel-approved-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembatalan Disetujui untuk H8937453-005" dengan kondisi "{\"body\": \"Pembatalan tiket H8937453-005 telah disetujui. Denda sebesar Rp126.250 dikenakan sesuai ketentuan pembatalan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pembatalan Disetujui\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Pembatalan Tiket > Detail Pembatalan H8937453-005\", \"recordId\": \"H8937453-005\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-024 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-068 | Pembatalan Disetujui: approval pembatalan gagal, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture approval pembatalan gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembatalan Disetujui untuk H8937453-005" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"cancel-approved-failed\"}"

  @positive @priority-high @REQ-024 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-037 | Pembatalan Disetujui: pesan dan Detail untuk Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture pembatalan disetujui sudah commit; eventId cancel-approved-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembatalan Disetujui untuk H8937453-005" dengan kondisi "{\"body\": \"Pembatalan tiket H8937453-005 telah disetujui. Denda sebesar Rp126.250 dikenakan sesuai ketentuan pembatalan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pembatalan Disetujui\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Pembatalan Tiket > Detail Pembatalan H8937453-005\", \"recordId\": \"H8937453-005\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-024 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-069 | Pembatalan Disetujui: approval pembatalan gagal, penerima Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture approval pembatalan gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembatalan Disetujui untuk H8937453-005" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"cancel-approved-failed\"}"

  @negative @priority-high @REQ-024 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-070 | Pembatalan Disetujui: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pembatalan disetujui sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembatalan Disetujui untuk H8937453-005" dengan kondisi "{\"count\": 0, \"eventId\": \"cancel-approved-global\"}"

  @negative @priority-high @REQ-024 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-071 | Pembatalan Disetujui: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pembatalan disetujui sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembatalan Disetujui untuk H8937453-005" dengan kondisi "{\"count\": 0, \"eventId\": \"cancel-approved-personal\"}"

  @positive @priority-high @REQ-025 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-038 | Pembatalan Ditolak: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pembatalan ditolak sudah commit; eventId cancel-rejected-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembatalan Ditolak untuk G8902260-001" dengan kondisi "{\"body\": \"Pembatalan tiket G8902260-001 ditolak. Alasan: Dokumen pendukung tidak dilampirkan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pembatalan Ditolak\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Pembatalan Tiket > Detail Pembatalan G8902260-001\", \"recordId\": \"G8902260-001\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-025 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-072 | Pembatalan Ditolak: penolakan pembatalan gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture penolakan pembatalan gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembatalan Ditolak untuk G8902260-001" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"cancel-rejected-failed\"}"

  @positive @priority-high @REQ-025 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-039 | Pembatalan Ditolak: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pembatalan ditolak sudah commit; eventId cancel-rejected-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembatalan Ditolak untuk G8902260-001" dengan kondisi "{\"body\": \"Pembatalan tiket G8902260-001 ditolak. Alasan: Dokumen pendukung tidak dilampirkan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pembatalan Ditolak\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Pembatalan Tiket > Detail Pembatalan G8902260-001\", \"recordId\": \"G8902260-001\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-025 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-073 | Pembatalan Ditolak: penolakan pembatalan gagal, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture penolakan pembatalan gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembatalan Ditolak untuk G8902260-001" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"cancel-rejected-failed\"}"

  @positive @priority-high @REQ-025 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-040 | Pembatalan Ditolak: pesan dan Detail untuk Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture pembatalan ditolak sudah commit; eventId cancel-rejected-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembatalan Ditolak untuk G8902260-001" dengan kondisi "{\"body\": \"Pembatalan tiket G8902260-001 ditolak. Alasan: Dokumen pendukung tidak dilampirkan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pembatalan Ditolak\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Pembatalan Tiket > Detail Pembatalan G8902260-001\", \"recordId\": \"G8902260-001\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-025 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-074 | Pembatalan Ditolak: penolakan pembatalan gagal, penerima Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Fixture penolakan pembatalan gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembatalan Ditolak untuk G8902260-001" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"cancel-rejected-failed\"}"

  @negative @priority-high @REQ-025 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-075 | Pembatalan Ditolak: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pembatalan ditolak sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembatalan Ditolak untuk G8902260-001" dengan kondisi "{\"count\": 0, \"eventId\": \"cancel-rejected-global\"}"

  @negative @priority-high @REQ-025 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-076 | Pembatalan Ditolak: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pembatalan ditolak sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pembatalan Ditolak untuk G8902260-001" dengan kondisi "{\"count\": 0, \"eventId\": \"cancel-rejected-personal\"}"

  @positive @priority-high @REQ-026 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-041 | Pengajuan Kuota: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture Cabang berhasil mengajukan kuota sudah commit; eventId quota-request-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Kuota untuk Q-216" dengan kondisi "{\"body\": \"Cabang Balikpapan mengajukan kuota KM. SWARNA BAHTERA voyage V-216 (Balikpapan → Parepare). Menunggu persetujuan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Kuota\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Kuota & Jadwal > Detail Pengajuan Q-216\", \"recordId\": \"Q-216\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-026 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-077 | Pengajuan Kuota: pengajuan kuota gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan kuota gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Kuota untuk Q-216" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"quota-request-failed\"}"

  @positive @priority-high @REQ-026 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-042 | Pengajuan Kuota: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture Cabang berhasil mengajukan kuota sudah commit; eventId quota-request-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Kuota untuk Q-216" dengan kondisi "{\"body\": \"Pengajuan kuota KM. SWARNA BAHTERA voyage V-216 (Balikpapan → Parepare) berhasil dikirim dan menunggu persetujuan Kantor Pusat.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Kuota\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Kuota & Jadwal > Detail Kuota Q-216\", \"recordId\": \"Q-216\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-026 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-078 | Pengajuan Kuota: pengajuan kuota gagal, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan kuota gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Kuota untuk Q-216" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"quota-request-failed\"}"

  @negative @priority-high @REQ-026 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-079 | Pengajuan Kuota: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture Cabang berhasil mengajukan kuota sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Kuota untuk Q-216" dengan kondisi "{\"count\": 0, \"eventId\": \"quota-request-global\"}"

  @negative @priority-high @REQ-026 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-080 | Pengajuan Kuota: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture Cabang berhasil mengajukan kuota sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Kuota untuk Q-216" dengan kondisi "{\"count\": 0, \"eventId\": \"quota-request-personal\"}"

  @positive @priority-high @REQ-027 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-043 | Kuota Disetujui: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan kuota disetujui Pusat sudah commit; eventId quota-approved-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Kuota Disetujui untuk Q-216" dengan kondisi "{\"body\": \"Pengajuan kuota KM. SWARNA BAHTERA voyage V-216 (Balikpapan → Parepare) telah disetujui Kantor Pusat. Setting jadwal keberangkatan sudah dapat dilanjutkan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Kuota Disetujui\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Kuota & Jadwal > Detail Pengajuan Q-216\", \"recordId\": \"Q-216\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-027 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-081 | Kuota Disetujui: approval kuota gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture approval kuota gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Kuota Disetujui untuk Q-216" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"quota-approved-failed\"}"

  @positive @priority-high @REQ-027 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-044 | Kuota Disetujui: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan kuota disetujui Pusat sudah commit; eventId quota-approved-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Kuota Disetujui untuk Q-216" dengan kondisi "{\"body\": \"Pengajuan kuota KM. SWARNA BAHTERA voyage V-216 (Balikpapan → Parepare) telah disetujui Kantor Pusat. Setting jadwal keberangkatan sudah dapat dilanjutkan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Kuota Disetujui\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Kuota & Jadwal > Detail Kuota Q-216\", \"recordId\": \"Q-216\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-027 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-082 | Kuota Disetujui: approval kuota gagal, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture approval kuota gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Kuota Disetujui untuk Q-216" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"quota-approved-failed\"}"

  @negative @priority-high @REQ-027 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-083 | Kuota Disetujui: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan kuota disetujui Pusat sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Kuota Disetujui untuk Q-216" dengan kondisi "{\"count\": 0, \"eventId\": \"quota-approved-global\"}"

  @negative @priority-high @REQ-027 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-084 | Kuota Disetujui: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan kuota disetujui Pusat sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Kuota Disetujui untuk Q-216" dengan kondisi "{\"count\": 0, \"eventId\": \"quota-approved-personal\"}"

  @positive @priority-high @REQ-028 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-045 | Kuota Ditolak: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan kuota ditolak Pusat sudah commit; eventId quota-rejected-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Kuota Ditolak untuk Q-216" dengan kondisi "{\"body\": \"Pengajuan kuota KM. SWARNA BAHTERA voyage V-216 (Balikpapan → Parepare) ditolak. Alasan: Kuota Gol. IV-B melebihi kapasitas dek kendaraan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Kuota Ditolak\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Kuota & Jadwal > Detail Pengajuan Q-216\", \"recordId\": \"Q-216\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-028 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-085 | Kuota Ditolak: penolakan kuota gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture penolakan kuota gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Kuota Ditolak untuk Q-216" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"quota-rejected-failed\"}"

  @positive @priority-high @REQ-028 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-046 | Kuota Ditolak: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan kuota ditolak Pusat sudah commit; eventId quota-rejected-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Kuota Ditolak untuk Q-216" dengan kondisi "{\"body\": \"Pengajuan kuota KM. SWARNA BAHTERA voyage V-216 (Balikpapan → Parepare) ditolak. Alasan: Kuota Gol. IV-B melebihi kapasitas dek kendaraan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Kuota Ditolak\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Kuota & Jadwal > Detail Kuota Q-216\", \"recordId\": \"Q-216\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-028 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-086 | Kuota Ditolak: penolakan kuota gagal, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture penolakan kuota gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Kuota Ditolak untuk Q-216" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"quota-rejected-failed\"}"

  @negative @priority-high @REQ-028 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-087 | Kuota Ditolak: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan kuota ditolak Pusat sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Kuota Ditolak untuk Q-216" dengan kondisi "{\"count\": 0, \"eventId\": \"quota-rejected-global\"}"

  @negative @priority-high @REQ-028 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-088 | Kuota Ditolak: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan kuota ditolak Pusat sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Kuota Ditolak untuk Q-216" dengan kondisi "{\"count\": 0, \"eventId\": \"quota-rejected-personal\"}"

  @positive @priority-high @REQ-029 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-047 | Pengajuan Member: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pendaftaran JN Member berhasil sudah commit; eventId member-request-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Member untuk REG-0012872" dengan kondisi "{\"body\": \"Rizwandy Rajab mengajukan pendaftaran JN Member. Menunggu proses validasi.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Member\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Validasi Member > Detail Member REG-0012872\", \"recordId\": \"REG-0012872\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-029 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-089 | Pengajuan Member: pendaftaran JN Member gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pendaftaran JN Member gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Member untuk REG-0012872" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"member-request-failed\"}"

  @positive @priority-high @REQ-029 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-048 | Pengajuan Member: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pendaftaran JN Member berhasil sudah commit; eventId member-request-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Member untuk REG-0012872" dengan kondisi "{\"body\": \"Rizwandy Rajab mengajukan pendaftaran JN Member. Menunggu proses validasi.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Member\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Validasi Member > Detail Member REG-0012872\", \"recordId\": \"REG-0012872\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-029 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-090 | Pengajuan Member: pendaftaran JN Member gagal, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pendaftaran JN Member gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Member untuk REG-0012872" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"member-request-failed\"}"

  @negative @priority-high @REQ-029 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-091 | Pengajuan Member: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pendaftaran JN Member berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Member untuk REG-0012872" dengan kondisi "{\"count\": 0, \"eventId\": \"member-request-global\"}"

  @negative @priority-high @REQ-029 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-092 | Pengajuan Member: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pendaftaran JN Member berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Member untuk REG-0012872" dengan kondisi "{\"count\": 0, \"eventId\": \"member-request-personal\"}"

  @positive @priority-high @REQ-030 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-049 | Member Disetujui: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pendaftaran member disetujui sudah commit; eventId member-approved-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Member Disetujui untuk REG-0012871" dengan kondisi "{\"body\": \"Pendaftaran JN Member Muh Aprisal disetujui. Nomor member JN-0012871.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Member Disetujui\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Validasi Member > Detail Member REG-0012871\", \"recordId\": \"REG-0012871\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-030 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-093 | Member Disetujui: approval pendaftaran gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture approval pendaftaran gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Member Disetujui untuk REG-0012871" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"member-approved-failed\"}"

  @positive @priority-high @REQ-030 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-050 | Member Disetujui: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pendaftaran member disetujui sudah commit; eventId member-approved-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Member Disetujui untuk REG-0012871" dengan kondisi "{\"body\": \"Pendaftaran JN Member Muh Aprisal disetujui. Nomor member JN-0012871.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Member Disetujui\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Validasi Member > Detail Member REG-0012871\", \"recordId\": \"REG-0012871\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-030 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-094 | Member Disetujui: approval pendaftaran gagal, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture approval pendaftaran gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Member Disetujui untuk REG-0012871" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"member-approved-failed\"}"

  @negative @priority-high @REQ-030 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-095 | Member Disetujui: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pendaftaran member disetujui sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Member Disetujui untuk REG-0012871" dengan kondisi "{\"count\": 0, \"eventId\": \"member-approved-global\"}"

  @negative @priority-high @REQ-030 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-096 | Member Disetujui: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pendaftaran member disetujui sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Member Disetujui untuk REG-0012871" dengan kondisi "{\"count\": 0, \"eventId\": \"member-approved-personal\"}"

  @positive @priority-high @REQ-031 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-051 | Member Ditolak: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pendaftaran member ditolak sudah commit; eventId member-rejected-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Member Ditolak untuk REG-0012874" dengan kondisi "{\"body\": \"Pendaftaran JN Member Yudi Kustanto ditolak. Alasan: Foto KTP tidak terbaca.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Member Ditolak\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Validasi Member > Detail Member REG-0012874\", \"recordId\": \"REG-0012874\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-031 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-097 | Member Ditolak: penolakan pendaftaran gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture penolakan pendaftaran gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Member Ditolak untuk REG-0012874" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"member-rejected-failed\"}"

  @positive @priority-high @REQ-031 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-052 | Member Ditolak: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pendaftaran member ditolak sudah commit; eventId member-rejected-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Member Ditolak untuk REG-0012874" dengan kondisi "{\"body\": \"Pendaftaran JN Member Yudi Kustanto ditolak. Alasan: Foto KTP tidak terbaca.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Member Ditolak\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Validasi Member > Detail Member REG-0012874\", \"recordId\": \"REG-0012874\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-031 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-098 | Member Ditolak: penolakan pendaftaran gagal, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture penolakan pendaftaran gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Member Ditolak untuk REG-0012874" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"member-rejected-failed\"}"

  @negative @priority-high @REQ-031 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-099 | Member Ditolak: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pendaftaran member ditolak sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Member Ditolak untuk REG-0012874" dengan kondisi "{\"count\": 0, \"eventId\": \"member-rejected-global\"}"

  @negative @priority-high @REQ-031 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-100 | Member Ditolak: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pendaftaran member ditolak sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Member Ditolak untuk REG-0012874" dengan kondisi "{\"count\": 0, \"eventId\": \"member-rejected-personal\"}"

  @positive @priority-high @REQ-032 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-053 | Verifikasi Ulang Member: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan ulang setelah ditolak berstatus Waiting Verifikasi sudah commit; eventId member-reverify-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Verifikasi Ulang Member untuk REG-0012873" dengan kondisi "{\"body\": \"Pengajuan ulang JN Member Damayanti Sukma telah masuk dan berstatus Menunggu Verifikasi.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Verifikasi Ulang Member\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Validasi Member > Detail Member REG-0012873\", \"recordId\": \"REG-0012873\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-032 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-101 | Verifikasi Ulang Member: pengajuan ulang gagal sehingga tetap Ditolak, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan ulang gagal sehingga tetap Ditolak; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Verifikasi Ulang Member untuk REG-0012873" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"member-reverify-failed\"}"

  @positive @priority-high @REQ-032 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-054 | Verifikasi Ulang Member: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan ulang setelah ditolak berstatus Waiting Verifikasi sudah commit; eventId member-reverify-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Verifikasi Ulang Member untuk REG-0012873" dengan kondisi "{\"body\": \"Pengajuan ulang JN Member Damayanti Sukma telah masuk dan berstatus Menunggu Verifikasi.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Verifikasi Ulang Member\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Validasi Member > Detail Member REG-0012873\", \"recordId\": \"REG-0012873\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-032 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-102 | Verifikasi Ulang Member: pengajuan ulang gagal sehingga tetap Ditolak, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan ulang gagal sehingga tetap Ditolak; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Verifikasi Ulang Member untuk REG-0012873" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"member-reverify-failed\"}"

  @negative @priority-high @REQ-032 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-103 | Verifikasi Ulang Member: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan ulang setelah ditolak berstatus Waiting Verifikasi sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Verifikasi Ulang Member untuk REG-0012873" dengan kondisi "{\"count\": 0, \"eventId\": \"member-reverify-global\"}"

  @negative @priority-high @REQ-032 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-104 | Verifikasi Ulang Member: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan ulang setelah ditolak berstatus Waiting Verifikasi sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Verifikasi Ulang Member untuk REG-0012873" dengan kondisi "{\"count\": 0, \"eventId\": \"member-reverify-personal\"}"

  @positive @priority-high @REQ-033 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-055 | Pengajuan Reward Masuk: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture Member mengajukan penukaran reward berhasil sudah commit; eventId reward-request-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Masuk untuk RW-001201" dengan kondisi "{\"body\": \"Nabila Putri mengajukan penukaran reward Voucher Tiket Rp50.000 (1.200 poin). Menunggu persetujuan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Reward Masuk\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Persetujuan Reward > Detail/Validasi RW-001201\", \"recordId\": \"RW-001201\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-033 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-105 | Pengajuan Reward Masuk: pengajuan reward gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan reward gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Masuk untuk RW-001201" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"reward-request-failed\"}"

  @positive @priority-high @REQ-033 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-056 | Pengajuan Reward Masuk: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture Member mengajukan penukaran reward berhasil sudah commit; eventId reward-request-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Masuk untuk RW-001201" dengan kondisi "{\"body\": \"Nabila Putri mengajukan penukaran reward Voucher Tiket Rp50.000 (1.200 poin). Menunggu persetujuan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Reward Masuk\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Persetujuan Reward > Detail/Validasi RW-001201\", \"recordId\": \"RW-001201\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-033 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-106 | Pengajuan Reward Masuk: pengajuan reward gagal, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan reward gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Masuk untuk RW-001201" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"reward-request-failed\"}"

  @negative @priority-high @REQ-033 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-107 | Pengajuan Reward Masuk: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture Member mengajukan penukaran reward berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Masuk untuk RW-001201" dengan kondisi "{\"count\": 0, \"eventId\": \"reward-request-global\"}"

  @negative @priority-high @REQ-033 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-108 | Pengajuan Reward Masuk: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture Member mengajukan penukaran reward berhasil sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Masuk untuk RW-001201" dengan kondisi "{\"count\": 0, \"eventId\": \"reward-request-personal\"}"

  @positive @priority-high @REQ-034 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-057 | Pengajuan Reward Diterima: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan reward disetujui sudah commit; eventId reward-approved-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Diterima untuk RW-001200" dengan kondisi "{\"body\": \"Pengajuan reward Voucher Tiket Rp50.000 atas nama Nabila Putri telah disetujui.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Reward Diterima\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Persetujuan Reward > Detail RW-001200\", \"recordId\": \"RW-001200\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-034 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-109 | Pengajuan Reward Diterima: approval reward gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture approval reward gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Diterima untuk RW-001200" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"reward-approved-failed\"}"

  @positive @priority-high @REQ-034 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-058 | Pengajuan Reward Diterima: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan reward disetujui sudah commit; eventId reward-approved-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Diterima untuk RW-001200" dengan kondisi "{\"body\": \"Pengajuan reward Voucher Tiket Rp50.000 atas nama Nabila Putri telah disetujui.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Reward Diterima\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Persetujuan Reward > Detail RW-001200\", \"recordId\": \"RW-001200\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-034 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-110 | Pengajuan Reward Diterima: approval reward gagal, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture approval reward gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Diterima untuk RW-001200" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"reward-approved-failed\"}"

  @positive @priority-high @REQ-034 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-059 | Pengajuan Reward Diterima: pesan dan Detail untuk Member
    Given prasyarat "User login sebagai Member; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan reward disetujui sudah commit; eventId reward-approved-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Diterima untuk RW-001200" dengan kondisi "{\"body\": \"Pengajuan reward Voucher Tiket Rp50.000 Anda telah disetujui. Lihat detail reward untuk informasi selanjutnya.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Reward Diterima\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Reward Milik Saya > Detail Reward RW-001200\", \"recordId\": \"RW-001200\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-034 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-111 | Pengajuan Reward Diterima: approval reward gagal, penerima Member
    Given prasyarat "User login sebagai Member; accountId sesuai testData.actor."
    And prasyarat "Fixture approval reward gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Diterima untuk RW-001200" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"reward-approved-failed\"}"

  @negative @priority-high @REQ-034 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-112 | Pengajuan Reward Diterima: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan reward disetujui sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Diterima untuk RW-001200" dengan kondisi "{\"count\": 0, \"eventId\": \"reward-approved-global\"}"

  @negative @priority-high @REQ-034 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-113 | Pengajuan Reward Diterima: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan reward disetujui sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Diterima untuk RW-001200" dengan kondisi "{\"count\": 0, \"eventId\": \"reward-approved-personal\"}"

  @positive @priority-high @REQ-035 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-060 | Pengajuan Reward Ditolak: pesan dan Detail untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan reward ditolak sudah commit; eventId reward-rejected-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Ditolak untuk RW-001200" dengan kondisi "{\"body\": \"Pengajuan reward Voucher Tiket Rp50.000 atas nama Nabila Putri ditolak. Alasan: Stok reward habis.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Reward Ditolak\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Persetujuan Reward > Detail RW-001200\", \"recordId\": \"RW-001200\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-035 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-114 | Pengajuan Reward Ditolak: penolakan reward gagal, penerima Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture penolakan reward gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Ditolak untuk RW-001200" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"reward-rejected-failed\"}"

  @positive @priority-high @REQ-035 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-061 | Pengajuan Reward Ditolak: pesan dan Detail untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan reward ditolak sudah commit; eventId reward-rejected-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Ditolak untuk RW-001200" dengan kondisi "{\"body\": \"Pengajuan reward Voucher Tiket Rp50.000 atas nama Nabila Putri ditolak. Alasan: Stok reward habis.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Reward Ditolak\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Persetujuan Reward > Detail RW-001200\", \"recordId\": \"RW-001200\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-035 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-115 | Pengajuan Reward Ditolak: penolakan reward gagal, penerima Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Fixture penolakan reward gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Ditolak untuk RW-001200" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"reward-rejected-failed\"}"

  @positive @priority-high @REQ-035 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-062 | Pengajuan Reward Ditolak: pesan dan Detail untuk Member
    Given prasyarat "User login sebagai Member; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan reward ditolak sudah commit; eventId reward-rejected-success."
    And prasyarat "Setting global dan preferensi Push ON; transaksi terkait akun, role dan akses sah."
    And prasyarat "Notifikasi event baru unread; Detail locator di-scope pada baris record terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Ditolak untuk RW-001200" dengan kondisi "{\"body\": \"Pengajuan reward Voucher Tiket Rp50.000 ditolak. Alasan: Stok reward habis. Poin telah dikembalikan.\", \"dateTime\": \"waktu commit/job fixture aktual\", \"read\": false, \"title\": \"Pengajuan Reward Ditolak\"}"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "{\"destination\": \"Reward Milik Saya > Detail Reward RW-001200\", \"recordId\": \"RW-001200\"}"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk notifikasi ini"

  @negative @priority-high @REQ-035 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-116 | Pengajuan Reward Ditolak: penolakan reward gagal, penerima Member
    Given prasyarat "User login sebagai Member; accountId sesuai testData.actor."
    And prasyarat "Fixture penolakan reward gagal; proses/job selesai dan tidak ada event sukses."
    And prasyarat "Setting global dan preferensi Push ON; history lain dipertahankan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Ditolak untuk RW-001200" dengan kondisi "{\"accountId\": \"sesuai actor\", \"count\": 0, \"eventId\": \"reward-rejected-failed\"}"

  @negative @priority-high @REQ-035 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-117 | Pengajuan Reward Ditolak: ditekan ketika global OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan reward ditolak sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Ditolak untuk RW-001200" dengan kondisi "{\"count\": 0, \"eventId\": \"reward-rejected-global\"}"

  @negative @priority-high @REQ-035 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-118 | Pengajuan Reward Ditolak: ditekan ketika personal OFF
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture pengajuan reward ditolak sukses dan dispatcher selesai."
    And prasyarat "Global jenis ini OFF untuk kasus global, atau global ON dan preferensi Push akun ini OFF untuk kasus personal."
    And prasyarat "Jenis lain ON; role/akses/ownership sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi Pengajuan Reward Ditolak untuk RW-001200" dengan kondisi "{\"count\": 0, \"eventId\": \"reward-rejected-personal\"}"

  @positive @priority-high @REQ-012 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-063 | Approval kedua free-c: E-tiket siap untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Order G8902259 telah disetujui pihak lain terlebih dahulu."
    And prasyarat "Approval pihak pada kasus ini berhasil commit; global dan preferensi ON."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Isi notifikasi" dengan kondisi "Pengajuan tiket gratis untuk order G8902259 telah disetujui Cabang Balikpapan. E-tiket sudah dapat diproses."
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "Persetujuan Tiket > Detail G8902259"

  @positive @priority-high @REQ-012 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-064 | Approval kedua free-c: E-tiket siap untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Order G8902259 telah disetujui pihak lain terlebih dahulu."
    And prasyarat "Approval pihak pada kasus ini berhasil commit; global dan preferensi ON."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Isi notifikasi" dengan kondisi "Pengajuan tiket gratis untuk order G8902259 telah disetujui Cabang Balikpapan. E-tiket sudah dapat diproses."
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "Persetujuan Tiket > Detail G8902259"

  @positive @priority-high @REQ-013 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-065 | Approval kedua free-p: E-tiket siap untuk Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Order G8902259 telah disetujui pihak lain terlebih dahulu."
    And prasyarat "Approval pihak pada kasus ini berhasil commit; global dan preferensi ON."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Isi notifikasi" dengan kondisi "Pengajuan tiket gratis untuk order G8902259 telah disetujui Kantor Pusat. E-tiket sudah dapat diproses."
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "Persetujuan Tiket > Detail G8902259"

  @positive @priority-high @REQ-013 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-066 | Approval kedua free-p: E-tiket siap untuk Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Order G8902259 telah disetujui pihak lain terlebih dahulu."
    And prasyarat "Approval pihak pada kasus ini berhasil commit; global dan preferensi ON."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Isi notifikasi" dengan kondisi "Pengajuan tiket gratis untuk order G8902259 telah disetujui Kantor Pusat. E-tiket sudah dapat diproses."
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "Persetujuan Tiket > Detail G8902259"

  @positive @priority-high @REQ-023 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-067 | Cabang sebagai pengaju menerima pesan pengaju dan Detail Pembatalan
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Cabang Balikpapan mengajukan C6845040-001, Pusat menjadi approver; commit sukses."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Isi notifikasi" dengan kondisi "Pengajuan pembatalan tiket C6845040-001 berhasil dikirim dan menunggu persetujuan."
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "Pembatalan Tiket > Detail Pembatalan C6845040-001"

  @positive @priority-high @REQ-001 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-068 | Amplop pesan menampilkan semua informasi aktual
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Pembayaran sukses fixture PAY-ENV; body dan clock diketahui."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "{\"body\": \"Pembayaran order V8987400 sebesar Rp505.000 berhasil. E-tiket Anda sudah tersedia.\", \"dateTime\": \"2026-09-30T09:12:00+07:00\", \"title\": \"Pembayaran Berhasil\"}"
    And sistem memverifikasi elemen "Detail" dengan kondisi "enabled"

  @negative @priority-high @REQ-001 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-119 | Payload sumber kehilangan ID tidak mengarahkan ke record sembarang
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fault fixture event tanpa recordId, resolver tidak bisa menentukan halaman; dispatcher selesai."
    And prasyarat "Robustness A12; teks penanganan error belum ditentukan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Detail" dengan kondisi "tidak ada navigasi aktif ke record sembarang"
    And sistem memverifikasi elemen "Isi notifikasi" dengan kondisi "tidak memuat undefined, null atau [ID Order]"

  @positive @priority-high @REQ-002 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-069 | Penerima empat role terikat pada transaksi terkait
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture PAY-ROLE mempunyai 1 akun terkait tiap role Pusat/Cabang/Agen/User Umum dan akun kontrol tidak terkait."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "salinan untuk akun Pusat terkait dengan isi operator"

  @negative @priority-high @REQ-002 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-120 | Akun ber-role benar tetapi cabang lain tidak menerima event
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Pengajuan Kuota Q-OTHER terkait Cabang Banjarmasin, akun ini Cabang Balikpapan."
    And prasyarat "Job sukses; global/personal ON dan daftar history kosong untuk Q-OTHER."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "{\"countForRecord\": 0, \"recordId\": \"Q-OTHER\"}"

  @positive @priority-high @REQ-003 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-070 | Buka isi menandai satu pesan read tanpa membuka Detail
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "N-READ-01 dan N-READ-02 unread milik akun; scope Baca notifikasi ke N-READ-01."
    And user berada di halaman "Notifikasi"
    When user mengklik tombol "Baca notifikasi"
    Then sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "N-READ-01 tidak tampil; N-READ-02 tetap unread"

  @negative @priority-high @REQ-003 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-121 | Seleksi checkbox tidak menandai notifikasi dibaca
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "N-READ-CHECK belum dibaca."
    And user berada di halaman "Notifikasi"
    When user mengaktifkan checkbox "Pilih notifikasi"
    Then sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "N-READ-CHECK tetap unread"

  @positive @priority-high @REQ-004 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-071 | Detail dengan permission sah membuka record tepat
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Notifikasi pengajuan gratis G-AUTH valid; akses Persetujuan Tiket diberikan."
    And user berada di halaman "Notifikasi"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "Persetujuan Tiket > Detail G-AUTH"

  @negative @priority-high @REQ-004 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-122 | Permission dicabut sebelum klik Detail dan URL langsung ditolak
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Pesan G-DENY sudah tersedia; permission detail dicabut setelah pesan dibuat."
    And user berada di halaman "Notifikasi"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "akses ditolak tanpa data G-DENY"
    When user membuka halaman "Persetujuan Tiket > Detail G-DENY"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "akses ditolak tanpa data G-DENY"

  @positive @priority-high @REQ-005 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-072 | Dua pengajuan tiket gratis dipisahkan per ID Order
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "G-ONE dan G-TWO diajukan satu per satu; dua event sukses berbeda."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "dua pesan dengan ID G-ONE dan G-TWO"
    When user mengklik tombol "Detail"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "Persetujuan Tiket > Detail G-ONE"

  @negative @priority-high @REQ-005 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-123 | Approval gagal order kedua tidak membuat pesan approval order pertama
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "G-ONE sudah approved; attempt G-TWO gagal validasi dan tidak commit."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "tidak ada pesan approval baru untuk G-TWO atau G-ONE"

  @positive @priority-high @REQ-006 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-073 | History device revoked tetap dapat dibaca setelah login dari device sah lain
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Approval COM-HISTORY dicabut; akun login dari perangkat lain yang masih sah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "Pencabutan Approval Device COM-HISTORY tetap tersedia"
    And sistem memverifikasi elemen "Detail" dengan kondisi "disabled"
    When user mengklik tombol "Baca notifikasi"
    Then sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat untuk COM-HISTORY"

  @negative @priority-high @REQ-006 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-124 | Detail Device Agen disabled tidak membuat navigasi atau read otomatis
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Pesan COM-DISABLED unread; tidak membuka isi; semua status device Agen diuji fixture."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Detail" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tetap terlihat"

  @positive @priority-high @REQ-007 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-074 | Nominal berbeda dari contoh prototipe ditampilkan dari transaksi baru
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Top-up TU-ACTUAL nominal 7654321, saldo akhir 98765432 oleh Cabang Parepare berhasil."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Isi notifikasi" dengan kondisi "Saldo sebesar Rp7.654.321 telah ditambahkan oleh Cabang Parepare. Saldo Anda saat ini Rp98.765.432."

  @negative @priority-high @REQ-007 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-125 | Cache record sebelumnya tidak mencemari body event baru
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Cache order V8987400 nominal 505000 diisi dahulu."
    And prasyarat "Pembayaran V-NEW nominal 252500 sukses; sumber aktual V-NEW."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Isi notifikasi" dengan kondisi "Pembayaran order V-NEW sebesar Rp252.500 berhasil. E-tiket Anda sudah tersedia."

  @positive @priority-high @REQ-036 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-075 | Admin Utama membuka menu dan halaman global
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Akun Admin Utama Prahu memiliki izin setting global."
    And user berada di halaman "Setting Notifikasi"
    When user mengklik tombol "Setting Notifikasi"
    Then sistem memverifikasi elemen "Section notifikasi" dengan kondisi "empat section terlihat"

  @negative @priority-high @REQ-036 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-126 | Kantor Pusat ditolak pada menu dan URL Setting global
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Akun tidak mempunyai hak Admin Utama Prahu."
    And user berada di halaman "Setting Notifikasi"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Setting Notifikasi" dengan kondisi "menu tidak terlihat"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "akses ditolak tanpa data setting global"

  @negative @priority-high @REQ-036 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-127 | Kantor Cabang ditolak pada menu dan URL Setting global
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Akun tidak mempunyai hak Admin Utama Prahu."
    And user berada di halaman "Setting Notifikasi"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Setting Notifikasi" dengan kondisi "menu tidak terlihat"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "akses ditolak tanpa data setting global"

  @negative @priority-high @REQ-036 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-128 | Agen ditolak pada menu dan URL Setting global
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Akun tidak mempunyai hak Admin Utama Prahu."
    And user berada di halaman "Setting Notifikasi"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Setting Notifikasi" dengan kondisi "menu tidak terlihat"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "akses ditolak tanpa data setting global"

  @negative @priority-high @REQ-036 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-129 | User Umum ditolak pada menu dan URL Setting global
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Akun tidak mempunyai hak Admin Utama Prahu."
    And user berada di halaman "Setting Notifikasi"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Setting Notifikasi" dengan kondisi "menu tidak terlihat"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "akses ditolak tanpa data setting global"

  @negative @priority-high @REQ-036 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-130 | Member ditolak pada menu dan URL Setting global
    Given prasyarat "User login sebagai Member; accountId sesuai testData.actor."
    And prasyarat "Akun tidak mempunyai hak Admin Utama Prahu."
    And user berada di halaman "Setting Notifikasi"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Setting Notifikasi" dengan kondisi "menu tidak terlihat"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "akses ditolak tanpa data setting global"

  @negative @priority-high @REQ-036 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-131 | Admin Prahu lain ditolak pada menu dan URL Setting global
    Given prasyarat "User login sebagai Admin Prahu lain; accountId sesuai testData.actor."
    And prasyarat "Akun tidak mempunyai hak Admin Utama Prahu."
    And user berada di halaman "Setting Notifikasi"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Setting Notifikasi" dengan kondisi "menu tidak terlihat"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "akses ditolak tanpa data setting global"

  @positive @priority-high @REQ-037 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-076 | Global ON dan preferensi ON membuka pilihan dan memungkinkan kiriman
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Pembayaran Berhasil Web sebelumnya OFF; transaksi belum dieksekusi."
    And user berada di halaman "Setting Notifikasi"
    When user mengaktifkan checkbox "Pembayaran Berhasil"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Informasi hasil simpan" dengan kondisi "sukses"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "tersedia untuk akun terkait"

  @negative @priority-high @REQ-037 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-132 | Global OFF menang atas preferensi ON seluruh role
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Global payment OFF sudah disimpan; akun Pusat/Cabang/Agen/Umum punya preferensi Push ON."
    And prasyarat "PAY-GLOBAL-OFF berhasil dan dispatcher selesai."
    And user berada di halaman "Setting Notifikasi"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Pembayaran Berhasil" dengan kondisi "toggle OFF tersimpan"

  @positive @priority-high @REQ-038 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-077 | Expand dan collapse keempat section menjaga nilai dan counter
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Fixture counts section diketahui; tidak ada draft."
    And user berada di halaman "Setting Notifikasi"
    When user mengklik tombol "Notifikasi Email"
    And user mengklik tombol "Notifikasi WhatsApp"
    And user mengklik tombol "Push Notifikasi JN Member"
    And user mengklik tombol "Push Notifikasi Sistem Web"
    Then sistem memverifikasi elemen "Counter section" dengan kondisi "sesuai fixture aktif/total"
    When user mengklik tombol "Notifikasi Email"
    Then sistem memverifikasi elemen "Notifikasi Email" dengan kondisi "collapsed tanpa mengubah setting"

  @negative @priority-high @REQ-038 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-133 | Collapse tidak menyimpan draft yang belum disimpan
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Email existing active 10/12; item pertama ON."
    And user berada di halaman "Setting Notifikasi"
    When user mengklik tombol "Notifikasi Email"
    And user menonaktifkan checkbox "Email jenis existing pertama"
    And user mengklik tombol "Notifikasi Email"
    And user mengklik tombol "Notifikasi Email"
    Then sistem memverifikasi elemen "Counter section" dengan kondisi "draft Email 9/12; committed tetap 10/12"

  @positive @priority-high @REQ-039 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-078 | Simpan setting efektif dan load ulang memakai nilai terakhir
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Setting payment Push OFF tersimpan."
    And user berada di halaman "Setting Notifikasi"
    When user mengaktifkan checkbox "Pembayaran Berhasil"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Informasi hasil simpan" dengan kondisi "pengaturan notifikasi berhasil disimpan"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Pembayaran Berhasil" dengan kondisi "ON tersimpan"

  @negative @priority-high @REQ-039 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-134 | Simpan global gagal mempertahankan nilai committed
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Payment OFF tersimpan; fault save 500 satu kali."
    And user berada di halaman "Setting Notifikasi"
    When user mengaktifkan checkbox "Pembayaran Berhasil"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Informasi hasil simpan" dengan kondisi "error tanpa sukses"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Pembayaran Berhasil" dengan kondisi "OFF tersimpan"

  @positive @priority-high @REQ-040 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-079 | Batal memulihkan toggle dan counter global
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Payment OFF, TOP ON tersimpan."
    And user berada di halaman "Setting Notifikasi"
    When user mengaktifkan checkbox "Pembayaran Berhasil"
    And user menonaktifkan checkbox "Piutang TOP Telah Lunas"
    And user mengklik tombol "Batal"
    Then sistem memverifikasi elemen "Pembayaran Berhasil" dengan kondisi "OFF"
    And sistem memverifikasi elemen "Piutang TOP Telah Lunas" dengan kondisi "ON"
    And sistem memverifikasi elemen "Perubahan belum disimpan" dengan kondisi "jika ditampilkan jumlah 0"

  @negative @priority-high @REQ-040 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-135 | Tidak ada perubahan global tidak menghasilkan mutasi saat tombol bersih
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Halaman baru dibuka tanpa edit."
    And user berada di halaman "Setting Notifikasi"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Batal" dengan kondisi "disabled atau enabled tanpa perubahan jika ditekan"
    And sistem memverifikasi elemen "Simpan" dengan kondisi "disabled atau no-op jika ditekan"

  @positive @priority-high @REQ-041 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-080 | Kelompok dan toggle Email existing mengikuti katalog
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Katalog existing disetujui berisi 4 kelompok dan sebuah jenis Email yang OFF."
    And user berada di halaman "Setting Notifikasi"
    When user mengklik tombol "Notifikasi Email"
    Then sistem memverifikasi elemen "Kelompok penerima Email" dengan kondisi "User Online; Operator; Pembeli Via Gerai; Pembeli Via Agen"
    When user mengaktifkan checkbox "Email jenis existing pertama"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Toggle Email" dengan kondisi "ON sesuai jenis/penerima"

  @negative @priority-high @REQ-041 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-136 | Email OFF tidak terkirim meskipun preferensi user ON
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Email existing pertama global OFF tersimpan; personal Email ON; trigger existing sukses."
    And user berada di halaman "Setting Notifikasi"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Toggle Email" dengan kondisi "OFF"

  @positive @priority-high @REQ-042 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-081 | WhatsApp baru default OFF, setting terakhir ON tetap dimuat
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Fixture fresh tanpa setting tersimpan: semua WA OFF; kemudian fixture akun deployment dengan setting WA jenis pertama ON."
    And user berada di halaman "Setting Notifikasi"
    When user mengklik tombol "Notifikasi WhatsApp"
    Then sistem memverifikasi elemen "Kelompok penerima WhatsApp" dengan kondisi "User Online; Pembeli Via Gerai; Pembeli Via Agen"
    And sistem memverifikasi elemen "Toggle WhatsApp" dengan kondisi "fresh OFF; fixture stored ON memuat ON"

  @negative @priority-high @REQ-042 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-137 | Jenis tanpa dukungan WhatsApp tidak ditawarkan atau dapat diaktifkan
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Katalog email-only existing tidak mendukung WhatsApp."
    And user berada di halaman "Setting Notifikasi"
    When user mengklik tombol "Notifikasi WhatsApp"
    Then sistem memverifikasi elemen "WhatsApp jenis email-only" dengan kondisi "tidak terlihat"

  @positive @priority-high @REQ-043 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-082 | Toggle aplikasi JN Member ON menggunakan rule existing
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Push JN Member aplikasi OFF tersimpan; Web JN Member mempunyai konfigurasi terpisah."
    And user berada di halaman "Setting Notifikasi"
    When user mengaktifkan checkbox "Push Notifikasi JN Member"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Toggle Push JN Member" dengan kondisi "ON"

  @negative @priority-high @REQ-043 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-138 | Push JN Member aplikasi OFF menghapus pilihan dan mencegah kiriman
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Aplikasi JN Member OFF tersimpan; personal ON; trigger existing sukses."
    And user berada di halaman "Setting Notifikasi"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Toggle Push JN Member" dengan kondisi "OFF"

  @positive @priority-high @REQ-044 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-083 | Sembilan kategori Web memuat jenis, trigger, penerima dan counter
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Fixture katalog Web lengkap dari matriks spec; semua jenis ON."
    And user berada di halaman "Setting Notifikasi"
    When user mengklik tombol "Push Notifikasi Sistem Web"
    Then sistem memverifikasi elemen "Kategori Push Web" dengan kondisi "[\"Top Up Saldo\", \"Persetujuan Tiket Gratis\", \"TOP\", \"Order & Keberangkatan\", \"Manajemen Device\", \"Pembatalan Tiket\", \"Kuota & Jadwal\", \"JN Member\", \"Reward Member\"]"
    And sistem memverifikasi elemen "Counter section" dengan kondisi "jumlah jenis aktif sama total, semua metadata sesuai matriks"

  @negative @priority-high @REQ-044 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-139 | Metadata penerima Web tidak meluas karena pengaturan global
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Device hanya Pusat/Agen; kuota hanya Pusat/Cabang; katalog fixture sah."
    And user berada di halaman "Setting Notifikasi"
    When user mengklik tombol "Push Notifikasi Sistem Web"
    Then sistem memverifikasi elemen "Kategori Push Web" dengan kondisi "Device tidak memasukkan Cabang/User Umum; Kuota tidak memasukkan Agen"

  @positive @priority-high @REQ-045 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-084 | Semua TOP dan toggle satu jenis hanya mempengaruhi scope terkait
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "TOP 4 jenis OFF; pembayaran ON."
    And user berada di halaman "Setting Notifikasi"
    When user mengaktifkan checkbox "Semua TOP"
    Then sistem memverifikasi elemen "Kategori Push Web" dengan kondisi "TOP 4/4"
    When user menonaktifkan checkbox "Piutang TOP Telah Lunas"
    Then sistem memverifikasi elemen "Kategori Push Web" dengan kondisi "TOP 3/4; 3 jenis lain ON; pembayaran tetap ON"
    When user mengklik tombol "Simpan"
    Then sistem memenuhi hasil "[\"Semua mengaktifkan empat TOP; satu jenis OFF hanya mengubah jenis tersebut; scope kategori lain tetap.\"]"

  @negative @priority-high @REQ-045 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-140 | Mematikan Semua TOP tidak mematikan Order dan tidak mengubah penerima
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "TOP 4/4 dan Order & Keberangkatan 2/2 tersimpan."
    And user berada di halaman "Setting Notifikasi"
    When user menonaktifkan checkbox "Semua TOP"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Kategori Push Web" dengan kondisi "TOP 0/4; Order & Keberangkatan 2/2"

  @positive @priority-high @REQ-046 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-085 | Admin Prahu memakai label baru di menu Setting
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Admin login; menu lama sebelumnya Validasi Akun."
    And user berada di halaman "Preferensi Notifikasi"
    When user mengklik tombol "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "Preferensi Notifikasi dari menu Setting"

  @negative @priority-high @REQ-046 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-141 | Label dan lokasi admin lama tidak menjadi menu personal aktif
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Deployment fitur baru selesai."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Preference Notif" dengan kondisi "tidak menjadi menu aktif di Validasi Akun"
    And sistem memverifikasi elemen "Preferensi Notifikasi" dengan kondisi "satu menu aktif di Setting"

  @positive @priority-high @REQ-047 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-086 | User pertama menyimpan tanpa mengubah user kedua
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "User umum-001 dan umum-002 memiliki Push pembayaran ON."
    And user berada di halaman "Preferensi Notifikasi"
    When user menonaktifkan checkbox "Push Pembayaran Berhasil"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "OFF untuk umum-001"

  @negative @priority-high @REQ-047 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-142 | Pemalsuan accountId saat simpan preferensi ditolak
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "User umum-001 login; payload save fixture menyasar umum-002."
    And user berada di halaman "Preferensi Notifikasi"
    When user menonaktifkan checkbox "Push Pembayaran Berhasil"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Informasi hasil simpan" dengan kondisi "ditolak tanpa mutasi umum-002"

  @positive @priority-high @REQ-048 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-087 | Pilihan adalah irisan global, role, permission dan channel tersedia
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "TOP dan Order global ON; Kuota OFF; permission TOP ada; Device tidak termasuk role Cabang."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Kategori preferensi" dengan kondisi "TOP dan Order tersedia; Kuota dan Device tidak tersedia"

  @negative @priority-high @REQ-048 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-143 | Request pemaksaan channel global OFF tidak membuat preferensi efektif
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Push payment global OFF; Email payment ON."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "tidak dapat dipilih"
    And sistem memverifikasi elemen "Email Pembayaran Berhasil" dengan kondisi "tetap tersedia"

  @positive @priority-high @REQ-049 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-088 | Tidak ada pilihan global menampilkan empty Preferensi persis
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Semua jenis/channel eligible User Umum global OFF."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Preferensi kosong" dengan kondisi "Belum ada notifikasi yang tersedia."
    And sistem memverifikasi elemen "Kategori preferensi" dengan kondisi "tidak ada kategori dengan pilihan aktif"

  @negative @priority-high @REQ-049 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-144 | Empty tidak muncul ketika satu channel eligible masih tersedia
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Hanya Email pembayaran global ON dan eligible; personal Email OFF."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Preferensi kosong" dengan kondisi "tidak terlihat"
    And sistem memverifikasi elemen "Email Pembayaran Berhasil" dengan kondisi "tersedia dan OFF"

  @positive @priority-high @REQ-050 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-089 | Simpan preferensi memperbarui tanggal dan mempertahankan informasi akun
    Given prasyarat "User login sebagai Member; accountId sesuai testData.actor."
    And prasyarat "Push payment ON tersimpan; account info tersedia, registerAt diketahui; clock simpan dibekukan."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Informasi akun" dengan kondisi "Nama Lengkap dan Tanggal Register sesuai fixture"
    When user menonaktifkan checkbox "Push Pembayaran Berhasil"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Tanggal Setting Terakhir" dengan kondisi "2026-10-08T10:00:00+07:00"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "OFF tersimpan"

  @negative @priority-high @REQ-050 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-145 | Simpan preferensi timeout tidak memberikan sukses palsu
    Given prasyarat "User login sebagai Member; accountId sesuai testData.actor."
    And prasyarat "Fault timeout sebelum commit; Push payment ON tersimpan; lastSettingAt awal diketahui."
    And user berada di halaman "Preferensi Notifikasi"
    When user menonaktifkan checkbox "Push Pembayaran Berhasil"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Informasi hasil simpan" dengan kondisi "gagal tanpa sukses"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "ON tersimpan"
    And sistem memverifikasi elemen "Tanggal Setting Terakhir" dengan kondisi "tetap nilai awal"

  @positive @priority-high @REQ-051 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-090 | Batal mengembalikan channel dan counter personal
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Email ON, WA OFF, Push ON tersimpan untuk payment."
    And user berada di halaman "Preferensi Notifikasi"
    When user menonaktifkan checkbox "Email Pembayaran Berhasil"
    And user mengaktifkan checkbox "WhatsApp Pembayaran Berhasil"
    And user mengklik tombol "Batal"
    Then sistem memverifikasi elemen "Email Pembayaran Berhasil" dengan kondisi "ON"
    And sistem memverifikasi elemen "WhatsApp Pembayaran Berhasil" dengan kondisi "OFF"
    And sistem memverifikasi elemen "Counter preferensi" dengan kondisi "2/3"

  @negative @priority-high @REQ-051 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-146 | Batal tidak mengaktifkan channel yang sudah dimatikan global
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Awal Email/Push ON; user membuat draft Email OFF; admin mematikan Push sebelum Batal."
    And user berada di halaman "Preferensi Notifikasi"
    When user menonaktifkan checkbox "Email Pembayaran Berhasil"
    And user mengklik tombol "Batal"
    Then sistem memverifikasi elemen "Email Pembayaran Berhasil" dengan kondisi "ON dari nilai committed"
    And sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "tidak tersedia setelah refresh global"

  @positive @priority-high @REQ-052 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-091 | Semua memilih semua pasangan channel yang tersedia di kategori
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Order category memiliki payment Email/WA/Push dan reminder Push, semua OFF."
    And user berada di halaman "Preferensi Notifikasi"
    When user mengaktifkan checkbox "Semua Order & Keberangkatan"
    Then sistem memverifikasi elemen "Counter preferensi" dengan kondisi "4/4"
    When user menonaktifkan checkbox "WhatsApp Pembayaran Berhasil"
    Then sistem memverifikasi elemen "Counter preferensi" dengan kondisi "3/4"

  @negative @priority-high @REQ-052 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-147 | Semua tidak menyentuh pasangan yang tersembunyi karena global OFF
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Payment Email dan Push tersedia; WA global OFF dengan preferensi historis OFF."
    And user berada di halaman "Preferensi Notifikasi"
    When user mengaktifkan checkbox "Semua Order & Keberangkatan"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Counter preferensi" dengan kondisi "2/2"

  @positive @priority-high @REQ-053 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-092 | Hanya Push ON mengirim Push dan menghentikan Email serta WhatsApp
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Payment mendukung tiga channel global ON; personal awal semua ON."
    And user berada di halaman "Preferensi Notifikasi"
    When user menonaktifkan checkbox "Email Pembayaran Berhasil"
    And user menonaktifkan checkbox "WhatsApp Pembayaran Berhasil"
    And user mengaktifkan checkbox "Push Pembayaran Berhasil"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Counter preferensi" dengan kondisi "1/3"

  @negative @priority-high @REQ-053 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-148 | Mematikan Push tidak mematikan Email atau WhatsApp yang masih ON
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Global ketiga channel ON; personal semua ON."
    And user berada di halaman "Preferensi Notifikasi"
    When user menonaktifkan checkbox "Push Pembayaran Berhasil"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Email Pembayaran Berhasil" dengan kondisi "ON"
    And sistem memverifikasi elemen "WhatsApp Pembayaran Berhasil" dengan kondisi "ON"

  @positive @priority-high @REQ-054 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-093 | Preferensi Kantor Pusat memuat seluruh daftar Push eligible
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Semua Push global ON; permission setiap jenis eligible diberikan; fixture katalog existing lengkap."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Kategori preferensi" dengan kondisi "[\"Top Up Saldo\", \"Persetujuan Tiket Gratis\", \"TOP\", \"Order & Keberangkatan\", \"Manajemen Device\", \"Pembatalan Tiket\", \"Kuota & Jadwal\", \"JN Member\", \"Reward Member\"]"

  @negative @priority-high @REQ-054 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-149 | Preferensi Kantor Pusat menolak jenis di luar haknya
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Permission Device dicabut meskipun role Pusat dan global ON."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Kategori preferensi" dengan kondisi "{\"notVisible\": [\"Manajemen Device\"]}"

  @positive @priority-high @REQ-055 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-094 | Preferensi Kantor Cabang memuat seluruh daftar Push eligible
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Semua Push global ON; permission setiap jenis eligible diberikan; fixture katalog existing lengkap."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Kategori preferensi" dengan kondisi "[\"Top Up Saldo\", \"Persetujuan Tiket Gratis\", \"TOP\", \"Order & Keberangkatan\", \"Pembatalan Tiket\", \"Kuota & Jadwal\", \"JN Member\", \"Reward Member\"]"

  @negative @priority-high @REQ-055 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-150 | Preferensi Kantor Cabang menolak jenis di luar haknya
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Role Cabang; semua global ON."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Kategori preferensi" dengan kondisi "{\"notVisible\": [\"Manajemen Device\"]}"

  @positive @priority-high @REQ-056 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-095 | Preferensi Agen memuat seluruh daftar Push eligible
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Semua Push global ON; permission setiap jenis eligible diberikan; fixture katalog existing lengkap."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Kategori preferensi" dengan kondisi "[\"Top Up Saldo\", \"Order & Keberangkatan\", \"Manajemen Device\", \"Pembatalan Tiket\"]"

  @negative @priority-high @REQ-056 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-151 | Preferensi Agen menolak jenis di luar haknya
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Role Agen; semua global ON."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Kategori preferensi" dengan kondisi "{\"notVisible\": [\"Persetujuan Tiket Gratis\", \"TOP\", \"Kuota & Jadwal\", \"JN Member\", \"Reward Member\"]}"

  @positive @priority-high @REQ-057 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-096 | Preferensi User Umum memuat seluruh daftar Push eligible
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Semua Push global ON; permission setiap jenis eligible diberikan; fixture katalog existing lengkap."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Kategori preferensi" dengan kondisi "[\"Order & Keberangkatan\"]"

  @negative @priority-high @REQ-057 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-152 | Preferensi User Umum menolak jenis di luar haknya
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Akun umum tanpa status Member; semua global ON."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Kategori preferensi" dengan kondisi "{\"notVisible\": [\"Reward Member\", \"Manajemen Device\", \"TOP\"]}"

  @positive @priority-high @REQ-057 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-097 | Preferensi Member memuat seluruh daftar Push eligible
    Given prasyarat "User login sebagai Member; accountId sesuai testData.actor."
    And prasyarat "Semua Push global ON; permission setiap jenis eligible diberikan; fixture katalog existing lengkap."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Kategori preferensi" dengan kondisi "[\"Order & Keberangkatan\", \"Reward Member\"]"

  @negative @priority-high @REQ-057 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-153 | Preferensi Member menolak jenis di luar haknya
    Given prasyarat "User login sebagai Member; accountId sesuai testData.actor."
    And prasyarat "Member tidak menjadi approver reward; semua global ON."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Kategori preferensi" dengan kondisi "{\"notVisible\": [\"Pengajuan Reward Masuk\", \"TOP\", \"Manajemen Device\"]}"

  @positive @priority-high @REQ-058 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-098 | Migrasi menambahkan Push tanpa mereset Email/WA tersimpan
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Snapshot sebelum migrasi: Email payment OFF, WA payment ON; deployment Push default ON."
    And prasyarat "Fixture migrasi fitur baru selesai."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Email Pembayaran Berhasil" dengan kondisi "OFF"
    And sistem memverifikasi elemen "WhatsApp Pembayaran Berhasil" dengan kondisi "ON"
    And sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "ON bila global eligible"

  @negative @priority-high @REQ-058 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-154 | Migrasi ulang tidak mereset pilihan Push/Email/WA user
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Migrasi pertama selesai dan user menyimpan semua channel OFF."
    And prasyarat "Fixture migrasi dijalankan ulang secara idempotent."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Email Pembayaran Berhasil" dengan kondisi "OFF"
    And sistem memverifikasi elemen "WhatsApp Pembayaran Berhasil" dengan kondisi "OFF"
    And sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "OFF"

  @positive @priority-high @REQ-059 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-099 | Global OFF lalu ON mengembalikan preferensi terakhir tanpa menghapus histori
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Push payment personal OFF tersimpan; admin mematikan global lalu mengaktifkannya kembali."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "kembali tersedia dalam kondisi OFF"

  @negative @priority-high @REQ-059 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-155 | Save preferensi lain saat jenis disembunyikan tidak menghapus config tersembunyi
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Push payment personal OFF tersimpan, lalu global OFF; Email reminder eligible ON."
    And user berada di halaman "Preferensi Notifikasi"
    When user menonaktifkan checkbox "Email Pengingat Keberangkatan"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "tetap tidak tersedia"

  @positive @priority-high @REQ-060 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-100 | Preferensi permanen setelah logout login dan browser lain
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Push payment OFF tersimpan; user logout dan login kembali dengan browser baru dari fixture."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "OFF tersimpan"

  @negative @priority-high @REQ-060 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-156 | Draft tidak disimpan tidak bertahan pada sesi baru
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Push payment ON tersimpan; sesi pertama draft OFF tetapi tidak Simpan; user logout/login fixture."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "ON nilai committed"

  @positive @priority-high @REQ-061 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-101 | Bell membuka Notifikasi dan menunjukkan unread milik akun
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Akun punya 2 unread dan 1 read; bell di header."
    And user berada di halaman "Notifikasi"
    When user mengklik tombol "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "pesan akun terlihat"
    And sistem memverifikasi elemen "Notifikasi" dengan kondisi "dot unread terlihat"

  @negative @priority-high @REQ-061 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-157 | Unread akun lain tidak menyalakan indikator bell akun ini
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Akun ini 0 unread; akun lain 20 unread."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Notifikasi" dengan kondisi "dot unread tidak terlihat"

  @positive @priority-high @REQ-062 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-102 | Filter kategori dan status memakai irisan hasil
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture 2 TOP unread, 1 TOP read, 3 Order unread."
    And user berada di halaman "Notifikasi"
    When user memilih field "Status baca" dengan "Belum Dibaca"
    And user memilih field "Kategori" dengan "TOP"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "tepat 2 TOP unread"
    When user memilih field "Status baca" dengan "Sudah Dibaca"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "tepat 1 TOP read"

  @negative @priority-high @REQ-062 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-158 | Pilihan kategori tidak milik role tidak menampilkan data role lain
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Agen tidak punya TOP; URL/query filter TOP dipaksakan lewat fixture."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Kategori" dengan kondisi "TOP tidak ditawarkan"
    And sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "tidak ada TOP milik role lain"

  @positive @priority-high @REQ-063 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-103 | Checkbox individu dan Pilih Semua menghitung seleksi hasil filter
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Filter TOP menampilkan 3 item; kategori lain 2 item tersembunyi."
    And user berada di halaman "Notifikasi"
    When user mengaktifkan checkbox "Pilih notifikasi"
    Then sistem memverifikasi elemen "Jumlah dipilih" dengan kondisi "1 dipilih"
    When user mengaktifkan checkbox "Pilih Semua"
    Then sistem memverifikasi elemen "Jumlah dipilih" dengan kondisi "3 dipilih"
    When user menonaktifkan checkbox "Pilih notifikasi"
    Then sistem memverifikasi elemen "Jumlah dipilih" dengan kondisi "2 dipilih"
    When user menonaktifkan checkbox "Pilih Semua"
    Then sistem memverifikasi elemen "Jumlah dipilih" dengan kondisi "0 dipilih atau indikator tidak terlihat"

  @negative @priority-high @REQ-063 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-159 | Mengganti filter mengosongkan seleksi lama
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Filter TOP memiliki 3 item; seleksi aktif."
    And user berada di halaman "Notifikasi"
    When user mengaktifkan checkbox "Pilih Semua"
    And user memilih field "Kategori" dengan "Order"
    Then sistem memverifikasi elemen "Jumlah dipilih" dengan kondisi "0 dipilih atau tidak terlihat"
    And sistem memverifikasi elemen "Hapus Notifikasi" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Tandai Sudah Dibaca" dengan kondisi "disabled"

  @positive @priority-high @REQ-064 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-104 | Hapus seleksi akun sendiri menjaga salinan akun lain
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "N-D1/N-D2 dipilih di akun ini; salinan event N-D1 ada untuk Cabang; N-D3 tidak dipilih."
    And user berada di halaman "Notifikasi"
    When user mengaktifkan checkbox "Pilih Semua"
    And user mengklik tombol "Hapus Notifikasi"
    Then sistem memverifikasi elemen "Informasi aksi" dengan kondisi "2 notifikasi dihapus."
    And sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "N-D1/N-D2 hilang dari akun ini; N-D3 tetap di luar filter"

  @negative @priority-high @REQ-064 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-160 | Hapus tanpa seleksi disabled dan tidak memutasi data
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Daftar 3 item tanpa seleksi."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Hapus Notifikasi" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "tetap 3 item"

  @positive @priority-high @REQ-065 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-105 | Bulk read menandai seleksi dan mengisolasi akun lain
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Filter memiliki 2 unread yang dipilih; 1 unread tersembunyi; salinan Cabang tetap unread."
    And user berada di halaman "Notifikasi"
    When user mengaktifkan checkbox "Pilih Semua"
    And user mengklik tombol "Tandai Sudah Dibaca"
    Then sistem memverifikasi elemen "Informasi aksi" dengan kondisi "2 notifikasi ditandai dibaca."
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "dua seleksi read; item tersembunyi dan Cabang tetap unread"

  @negative @priority-high @REQ-065 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-161 | Bulk read tanpa seleksi disabled tidak menandai semua
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Ada 5 unread tanpa seleksi."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Tandai Sudah Dibaca" dengan kondisi "disabled"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "kelima item tetap unread"

  @positive @priority-high @REQ-066 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-106 | Daftar akun tanpa notifikasi menampilkan empty yang benar
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Akun tidak mempunyai notifikasi."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar kosong" dengan kondisi "Tidak ada notifikasi yang tersedia."
    And sistem memverifikasi elemen "Pilih Semua" dengan kondisi "unchecked dan tidak memilih item"
    And sistem memverifikasi elemen "Hapus Notifikasi" dengan kondisi "disabled"

  @negative @priority-high @REQ-066 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-162 | Filter tanpa hasil tidak menghapus history atau membuat empty global palsu
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "History punya 3 TOP read; filter Belum Dibaca tidak cocok."
    And user berada di halaman "Notifikasi"
    When user memilih field "Status baca" dengan "Belum Dibaca"
    Then sistem memverifikasi elemen "Daftar kosong" dengan kondisi "terlihat"
    When user memilih field "Status baca" dengan "Semua"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "3 TOP read kembali terlihat"
    And sistem memverifikasi elemen "Daftar kosong" dengan kondisi "tidak terlihat"

  @positive @priority-high @REQ-067 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-107 | Page size 10 20 50 dan halaman berikutnya tidak kehilangan item
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Fixture 51 notifikasi ID unik milik akun; filter Semua."
    And user berada di halaman "Notifikasi"
    When user memilih field "Menampilkan Data" dengan "10"
    Then sistem memverifikasi elemen "Pagination" dengan kondisi "1-10 dari 51"
    When user mengklik tombol "Selanjutnya"
    Then sistem memverifikasi elemen "Pagination" dengan kondisi "11-20 dari 51"
    When user mengklik tombol "Sebelumnya"
    And user memilih field "Menampilkan Data" dengan "20"
    Then sistem memverifikasi elemen "Pagination" dengan kondisi "1-20 dari 51"
    When user memilih field "Menampilkan Data" dengan "50"
    Then sistem memverifikasi elemen "Pagination" dengan kondisi "1-50 dari 51"

  @negative @priority-high @REQ-067 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-163 | Pagination tidak boleh maju melewati halaman terakhir
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Total 9 notifikasi dengan page size 10."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Pagination" dengan kondisi "1-9 dari 9; Selanjutnya disabled atau tidak menavigasi keluar range"

  @negative @priority-high @REQ-036 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-164 | Payload save global dari non-Admin Utama ditolak
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Adapter fixture mengirim request save global sebagai Cabang; tidak ada kontrol Simpan global pada UI."
    And prasyarat "Request pemaksaan selesai sebelum membuka halaman."
    And user berada di halaman "Setting Notifikasi"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "akses global ditolak"

  @negative @priority-high @REQ-039 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-165 | Draft ON sebelum Simpan tidak membuka pengiriman atau pilihan
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Payment global OFF tersimpan; personal ON."
    And prasyarat "Adapter dispatch PAY-DRAFT setelah edit UI tetapi sebelum Simpan, tunggu selesai."
    And user berada di halaman "Setting Notifikasi"
    When user mengaktifkan checkbox "Pembayaran Berhasil"
    Then sistem memverifikasi elemen "Pembayaran Berhasil" dengan kondisi "draft ON"
    And sistem memverifikasi elemen "Informasi hasil simpan" dengan kondisi "belum ada sukses"

  @positive @priority-high @REQ-042 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-108 | WhatsApp ON berhasil disimpan dan memakai trigger existing
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Jenis WA existing pertama OFF tersimpan; personal WA penerima ON."
    And user berada di halaman "Setting Notifikasi"
    When user mengaktifkan checkbox "WhatsApp jenis existing pertama"
    And user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Toggle WhatsApp" dengan kondisi "ON tersimpan"

  @negative @priority-high @REQ-042 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-166 | WhatsApp OFF menghentikan kiriman meskipun preferensi ON
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Jenis WA existing global OFF tersimpan; preferensi ON; trigger existing sukses dan dispatcher selesai."
    And user berada di halaman "Setting Notifikasi"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Toggle WhatsApp" dengan kondisi "OFF tersimpan"

  @positive @priority-high @REQ-046 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-109 | Menu Preferensi Notifikasi dapat dibuka Kantor Pusat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Jenis akun aktif dan mempunyai setidaknya satu jenis eligible."
    And user berada di halaman "Preferensi Notifikasi"
    When user mengklik tombol "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "Preferensi Notifikasi untuk akun sendiri"

  @positive @priority-high @REQ-046 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-110 | Menu Preferensi Notifikasi dapat dibuka Kantor Cabang
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Jenis akun aktif dan mempunyai setidaknya satu jenis eligible."
    And user berada di halaman "Preferensi Notifikasi"
    When user mengklik tombol "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "Preferensi Notifikasi untuk akun sendiri"

  @positive @priority-high @REQ-046 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-111 | Menu Preferensi Notifikasi dapat dibuka Agen
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Jenis akun aktif dan mempunyai setidaknya satu jenis eligible."
    And user berada di halaman "Preferensi Notifikasi"
    When user mengklik tombol "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "Preferensi Notifikasi untuk akun sendiri"

  @positive @priority-high @REQ-046 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-112 | Menu Preferensi Notifikasi dapat dibuka User Umum
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Jenis akun aktif dan mempunyai setidaknya satu jenis eligible."
    And user berada di halaman "Preferensi Notifikasi"
    When user mengklik tombol "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "Preferensi Notifikasi untuk akun sendiri"

  @positive @priority-high @REQ-046 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-POS-113 | Menu Preferensi Notifikasi dapat dibuka Member
    Given prasyarat "User login sebagai Member; accountId sesuai testData.actor."
    And prasyarat "Jenis akun aktif dan mempunyai setidaknya satu jenis eligible."
    And user berada di halaman "Preferensi Notifikasi"
    When user mengklik tombol "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Halaman tujuan" dengan kondisi "Preferensi Notifikasi untuk akun sendiri"

  @negative @priority-high @REQ-050 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-167 | Draft personal OFF tanpa Simpan tetap memakai preferensi committed ON
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Push payment ON tersimpan."
    And prasyarat "Adapter dispatch PAY-PERSONAL-DRAFT sesudah edit sebelum Simpan."
    And user berada di halaman "Preferensi Notifikasi"
    When user menonaktifkan checkbox "Push Pembayaran Berhasil"
    Then sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "draft OFF"

  @negative @priority-high @REQ-048 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-168 | Hak akses dicabut setelah halaman dibuka tidak dapat dipulihkan lewat save lama
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "TOP global ON; user membuka preferensi; permission TOP kemudian dicabut."
    And prasyarat "Adapter mencoba simpan payload TOP ON lama sesudah revocation."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Kategori preferensi" dengan kondisi "TOP tidak ditawarkan"

  @negative @priority-high @REQ-064 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-169 | Server gagal hapus tidak menghilangkan item atau memberi toast sukses
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Dua item dipilih; fault delete 500 sebelum commit."
    And user berada di halaman "Notifikasi"
    When user mengaktifkan checkbox "Pilih Semua"
    And user mengklik tombol "Hapus Notifikasi"
    Then sistem memverifikasi elemen "Informasi aksi" dengan kondisi "error tanpa sukses"
    And sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "dua item tetap ada"

  @negative @priority-high @REQ-065 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-170 | Server gagal bulk read mempertahankan unread
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Dua unread; fault markRead 500 sebelum commit."
    And user berada di halaman "Notifikasi"
    When user mengaktifkan checkbox "Pilih Semua"
    And user mengklik tombol "Tandai Sudah Dibaca"
    Then sistem memverifikasi elemen "Informasi aksi" dengan kondisi "error tanpa sukses"
    And sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "kedua item masih unread setelah reload"

  @negative @priority-high @REQ-064 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-171 | Pemalsuan notificationId akun lain tidak menghapus salinannya
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Adapter request delete membawa notificationId milik agen-002 sebagai agen-001; request selesai."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "history agen-001 tetap sesuai snapshot"

  @negative @priority-high @REQ-002 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-172 | Global ON tidak mengirim ketika permission penerima tidak ada
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Kuota Q-NOPERM terkait Pusat tetapi user tidak mempunyai permission Kuota; event sukses dan dispatcher selesai."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "tidak ada Q-NOPERM"

  @negative @priority-high @REQ-002 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-NEG-173 | User Umum non-Member tidak menerima hasil reward Member lain
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Reward RW-OTHER ditolak untuk Member member-002; akun umum-001 non-Member."
    And prasyarat "Global/personal ON; dispatcher selesai."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "tidak ada hasil reward RW-OTHER"

  @edge @priority-medium @REQ-003 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-001 | Membuka pesan read berulang tetap idempotent
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "N-ALREADY read sebelum pengujian."
    And user berada di halaman "Notifikasi"
    When user mengklik tombol "Baca notifikasi"
    And user mengklik tombol "Baca notifikasi"
    Then sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak terlihat"

  @edge @priority-medium @REQ-007 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-002 | Nama dan alasan mengandung karakter khusus tetap teks aman
    Given prasyarat "User login sebagai Member; accountId sesuai testData.actor."
    And prasyarat "Reward ditolak dengan nama/label/ alasan Unicode dan markup literal dari fixture."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Isi notifikasi" dengan kondisi "teks Unicode dan <script> literal tidak dieksekusi"

  @edge @priority-medium @REQ-007 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-003 | Denda nol yang sah tetap berasal dari transaksi
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Pembatalan tiket T-ZERO disetujui dengan denda aktual 0."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Isi notifikasi" dengan kondisi "Pembatalan tiket T-ZERO telah disetujui. Denda sebesar Rp0 dikenakan sesuai ketentuan pembatalan."

  @edge @priority-medium @REQ-016 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-004 | Batas tanggal H-3 lintas bulan memakai kalender bisnis
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Due date 2026-11-01, clock 2026-10-29 00:00 WIB; job selesai; belum lunas."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "H-3 terkirim tepat tanggal 29 Okt"

  @edge @priority-medium @REQ-016 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-005 | Satu detik sebelum H-3 belum menghasilkan reminder
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Due 2026-11-01; clock 2026-10-28 23:59:59 WIB; job selesai."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "tidak ada H-3 untuk event fixture"

  @edge @priority-medium @REQ-017 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-006 | Piutang yang sudah lunas pada tanggal H tidak diingatkan
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Piutang ditandai lunas sebelum job due date; job selesai."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "tidak ada H-0 pada piutang lunas"

  @edge @priority-medium @REQ-017 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-007 | H-0 lintas tahun pada tanggal jatuh tempo aktual
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Due 2027-01-01, clock 2027-01-01 00:00 WIB; belum lunas."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "Piutang TOP Jatuh Tempo Hari Ini untuk record TOP-YEAR"

  @edge @priority-medium @REQ-019 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-008 | H-1 memakai tanggal WITA saat tanggal UTC berbeda
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Berangkat 2026-10-01 00:15 WITA; clock 2026-09-30 00:05 WITA; job selesai."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "Pengingat Keberangkatan untuk perjalanan besok 01 Okt 00:15 WITA"

  @edge @priority-medium @REQ-019 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-009 | Jadwal ulang menggunakan jadwal terbaru sebelum job
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Jadwal awal 1 Okt diubah 3 Okt; job dijalankan 30 Sep dan 2 Okt pada fixture terpisah."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "30 Sep tidak ada reminder; 2 Okt reminder untuk 3 Okt"

  @edge @priority-medium @REQ-012 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-010 | Approval Cabang dan Pusat hampir bersamaan memakai status saat commit
    Given prasyarat "User login sebagai Kantor Cabang; accountId sesuai testData.actor."
    And prasyarat "Dua approval order G-RACE dieksekusi dengan barrier commit terkendali."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Isi notifikasi" dengan kondisi "sesuai status pihak lain saat masing-masing commit"

  @edge @priority-medium @REQ-040 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-011 | Toggle bolak balik ke nilai semula menghasilkan draft bersih
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Payment OFF tersimpan; indikator dirty opsional."
    And user berada di halaman "Setting Notifikasi"
    When user mengaktifkan checkbox "Pembayaran Berhasil"
    And user menonaktifkan checkbox "Pembayaran Berhasil"
    Then sistem memverifikasi elemen "Perubahan belum disimpan" dengan kondisi "jika tampil 0"

  @edge @priority-medium @REQ-038 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-012 | Section dengan 0 aktif tetap dapat dibuka
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Semua WA OFF; katalog 6 jenis."
    And user berada di halaman "Setting Notifikasi"
    When user mengklik tombol "Notifikasi WhatsApp"
    Then sistem memverifikasi elemen "Counter section" dengan kondisi "0 dari 6 notifikasi aktif"
    And sistem memverifikasi elemen "Toggle WhatsApp" dengan kondisi "semua OFF"

  @edge @priority-medium @REQ-050 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-013 | Akun baru mengikuti aktif hanya pada channel eligible
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Tidak ada preferensi user tersimpan; global Email ON, WA OFF, Push default deployment ON."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Email Pembayaran Berhasil" dengan kondisi "ON"
    And sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "ON"
    And sistem memverifikasi elemen "WhatsApp Pembayaran Berhasil" dengan kondisi "tidak tersedia"

  @edge @priority-medium @REQ-050 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-014 | Push default deployment OFF tidak mereset Email aktif
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Akun baru; default Push deployment OFF, global semua ON."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Email Pembayaran Berhasil" dengan kondisi "ON"
    And sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "OFF"

  @edge @priority-medium @REQ-052 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-015 | Kategori dengan satu pilihan Semua menghasilkan 1/1 atau 0/1
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "Hanya Push saldo tersedia."
    And user berada di halaman "Preferensi Notifikasi"
    When user mengaktifkan checkbox "Semua Top Up Saldo"
    Then sistem memverifikasi elemen "Counter preferensi" dengan kondisi "1/1"
    When user menonaktifkan checkbox "Semua Top Up Saldo"
    Then sistem memverifikasi elemen "Counter preferensi" dengan kondisi "0/1"

  @edge @priority-medium @REQ-048 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-016 | Global OFF terakhir menghilangkan kategori setelah refresh
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Hanya Push payment tersedia; halaman dibuka, kemudian admin OFF global."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Preferensi kosong" dengan kondisi "Belum ada notifikasi yang tersedia."

  @edge @priority-medium @REQ-059 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-017 | Preferensi tersembunyi ON dipulihkan saat global ON kembali
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Personal Push payment ON; global OFF lalu ON; tidak ada perubahan personal."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "ON saat tersedia kembali"

  @edge @priority-medium @REQ-060 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-018 | Global setting tersimpan tetap efektif di sesi admin lain
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Admin A menyimpan Payment OFF; logout; Admin B Utama login browser lain."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Pembayaran Berhasil" dengan kondisi "OFF tersimpan"

  @edge @priority-medium @REQ-065 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-019 | Seleksi campuran read/unread tidak mengembalikan pesan read menjadi unread
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Dua selected item: satu read, satu unread; filter Semua."
    And user berada di halaman "Notifikasi"
    When user mengaktifkan checkbox "Pilih Semua"
    And user mengklik tombol "Tandai Sudah Dibaca"
    Then sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "tidak ada pada kedua selected"

  @edge @priority-medium @REQ-064 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-020 | Menghapus item terakhir memperbarui empty dan bell
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "Satu notifikasi unread milik akun."
    And user berada di halaman "Notifikasi"
    When user mengaktifkan checkbox "Pilih Semua"
    And user mengklik tombol "Hapus Notifikasi"
    Then sistem memverifikasi elemen "Daftar kosong" dengan kondisi "Tidak ada notifikasi yang tersedia."
    And sistem memverifikasi elemen "Notifikasi" dengan kondisi "dot unread tidak terlihat"

  @edge @priority-medium @REQ-067 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-021 | Jumlah tepat 10 dan 11 melintasi batas halaman
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Dua fixture terpisah total 10 dan 11; size 10."
    And user berada di halaman "Notifikasi"
    When user memilih field "Menampilkan Data" dengan "10"
    Then sistem memverifikasi elemen "Pagination" dengan kondisi "total 10: satu halaman; total 11: dua halaman dengan terakhir 1 item"

  @edge @priority-medium @REQ-006 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-EDG-022 | Revoked device history tetap ada setelah preferensi Device OFF
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "History revoked sudah ada; preferensi device dimatikan sesudah event."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "history revoked tetap tampil"
    And sistem memverifikasi elemen "Detail" dengan kondisi "disabled"

  @stress @priority-high @REQ-002 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-STR-001 | 10000 event lintas role tetap terisolasi
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "Load fixture 10000 event unik untuk 100 akun, role/cabang/owner bervariasi; queue drain selesai."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "ID dan body akun ini sama dengan oracle fixture"

  @stress @priority-high @REQ-037 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-STR-002 | Beban event saat sebagian jenis global OFF tidak melewati gate
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Load 10000 event berbagai jenis; TOP global OFF; Order ON; dispatcher selesai."
    And user berada di halaman "Setting Notifikasi"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Kategori Push Web" dengan kondisi "TOP OFF tersimpan; Order ON"

  @stress @priority-high @REQ-039 @screen-setting-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-STR-003 | Dua admin menyimpan global bersamaan menghasilkan konfigurasi committed konsisten
    Given prasyarat "User login sebagai Admin Utama Prahu; accountId sesuai testData.actor."
    And prasyarat "Dua sesi Admin Utama; save konflik dengan barrier; satu payload TOP OFF, satu ON."
    And user berada di halaman "Setting Notifikasi"
    When user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Informasi hasil simpan" dengan kondisi "hasil sukses atau conflict eksplisit"
    When user membuka halaman "Setting Notifikasi"
    Then sistem memverifikasi elemen "Kategori Push Web" dengan kondisi "satu konfigurasi committed valid, tanpa nilai campuran akibat write parsial"

  @stress @priority-high @REQ-047 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-STR-004 | 100 akun menyimpan preferensi paralel tanpa saling menimpa
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "100 sesi akun berbeda melakukan 20 save per akun; oracle last successful commit per account."
    And user berada di halaman "Preferensi Notifikasi"
    When user mengklik tombol "Simpan"
    Then sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "nilai terakhir akun ini sesuai oracle"

  @stress @priority-high @REQ-050 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-STR-005 | Retry setelah timeout pascacommit tidak kehilangan preferensi
    Given prasyarat "User login sebagai Member; accountId sesuai testData.actor."
    And prasyarat "100 request save; injeksi respons timeout setelah commit, retry payload sama dengan fixture adapter."
    And user berada di halaman "Preferensi Notifikasi"
    When user mengklik tombol "Simpan"
    And user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "nilai committed benar"

  @stress @priority-high @REQ-067 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-STR-006 | Daftar 10000 item dapat dipaginasi dan difilter dengan set ID tepat
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "10000 notifikasi akun ini; oracle ID per status/kategori; size 50."
    And user berada di halaman "Notifikasi"
    When user memilih field "Menampilkan Data" dengan "50"
    And user memilih field "Kategori" dengan "TOP"
    And user memilih field "Status baca" dengan "Belum Dibaca"
    Then sistem memverifikasi elemen "Pagination" dengan kondisi "range/total sesuai oracle TOP unread"
    And sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "50 item pertama dari hasil, ID tanpa duplikasi"

  @stress @priority-high @REQ-065 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-STR-007 | Bulk read hasil filter besar tidak menandai akun lain
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "1000 selected hasil filter dan 100 unread tidak selected; salinan Cabang belum dibaca."
    And user berada di halaman "Notifikasi"
    When user mengaktifkan checkbox "Pilih Semua"
    And user mengklik tombol "Tandai Sudah Dibaca"
    Then sistem memverifikasi elemen "Penanda belum dibaca" dengan kondisi "1000 selected read; 100 unselected dan salinan akun lain tetap unread"

  @stress @priority-high @REQ-064 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-STR-008 | Bulk hapus 1000 hasil filter menjaga transaksi dan salinan akun lain
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "1000 selected hasil filter; 100 tidak selected; record bisnis tetap ada."
    And user berada di halaman "Notifikasi"
    When user mengaktifkan checkbox "Pilih Semua"
    And user mengklik tombol "Hapus Notifikasi"
    Then sistem memverifikasi elemen "Informasi aksi" dengan kondisi "1000 notifikasi dihapus."

  @stress @priority-high @REQ-019 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-STR-009 | Job H-1 untuk 10000 tiket memakai ownership dan jadwal tiap voyage
    Given prasyarat "User login sebagai User Umum; accountId sesuai testData.actor."
    And prasyarat "10000 tiket lintas zona/jadwal, 100 akun; job tanggal fixture selesai."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "set reminder milik akun ini tepat H-1 jadwal aktual"

  @stress @priority-high @REQ-016 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-STR-010 | Retry job H-3 satu pesan per piutang tanggal dan penerima
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "10000 piutang due H-3; fixture job diulang 3 kali dengan kunci event bisnis sama."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Daftar notifikasi" dengan kondisi "tepat satu pesan per recordId+dueDate+accountId"

  @stress @priority-high @REQ-007 @screen-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-STR-011 | Payload panjang tetap aman dan tidak memotong identitas/rute record
    Given prasyarat "User login sebagai Kantor Pusat; accountId sesuai testData.actor."
    And prasyarat "100 pesan dengan nama/alasan Unicode 10000 karakter; panjang legal implementasi belum ditentukan."
    And user berada di halaman "Notifikasi"
    When user membuka halaman "Notifikasi"
    Then sistem memverifikasi elemen "Isi notifikasi" dengan kondisi "aman, dapat dibaca atau ada kebijakan truncation eksplisit"
    And sistem memverifikasi elemen "Detail" dengan kondisi "tetap recordId benar"

  @stress @priority-high @REQ-060 @screen-preferensi-notifikasi
  Scenario: RO323-NOTIFIKASI-SISTEM-STR-012 | Restart layanan fixture tidak menghapus konfigurasi committed
    Given prasyarat "User login sebagai Agen; accountId sesuai testData.actor."
    And prasyarat "100 akun punya konfigurasi berbeda, admin global tersimpan; fixture service restarted setelah semua save commit."
    And user berada di halaman "Preferensi Notifikasi"
    When user membuka halaman "Preferensi Notifikasi"
    Then sistem memverifikasi elemen "Push Pembayaran Berhasil" dengan kondisi "nilai akun tetap sesuai snapshot"

