Feature: ro315-lock-device-agen-dan-sub-agen
  Lock device Agen dan Sub Agen berdasarkan status server dan proses Kantor Pusat.
  Aturan extras bersifat provisional; lihat analysis.md dan testData.provisional.

  @positive @priority-high @REQ-001 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-001 — Agen terdaftar mengikuti pemeriksaan device
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen memiliki device A Aktif."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Dashboard" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "visible", "description": "Dashboard tampil sesudah pemeriksaan perangkat"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "serverInvariant", "description": "Device check dilakukan setelah auth berhasil", "deviceCheck": true}

  @negative @priority-high @REQ-001 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-001 — Cache role lain tidak membebaskan Agen dari lock device
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen memakai device B belum terdaftar; client menyimpan role Kantor Cabang dari sesi sebelumnya."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Judul Verifikasi" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "visible", "description": "Role server Agen/Sub Agen tetap memicu Verifikasi walau cache role lain"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}

  @positive @priority-high @REQ-003 @screen-dashboard
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-002 — Agen Aktif membuka fitur Jual Tiket
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen terautentikasi pada device A Aktif."
    When user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    And user mengklik tombol "Jual Tiket" pada konteks "utama" di layar "dashboard"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "visible", "description": "Fitur Jual Tiket dapat diakses", "feature": "Jual Tiket"}

  @negative @priority-high @REQ-003 @screen-dashboard
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-002 — Agen Menunggu gagal membuka URL fitur langsung
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen terautentikasi tetapi device A Menunggu."
    When user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "URL halaman utama tidak memberi akses", "serverAccess": "denied"}
    And user berada di halaman "dashboard" pada konteks "utama" melalui "route:jual-tiket"
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "URL fitur Jual Tiket juga menolak akses", "serverAccess": "denied"}

  @positive @priority-high @REQ-004 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-003 — Login Agen belum terdaftar menampilkan layar yang benar
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Device A Agen belum terdaftar; fixture status server sesuai kondisi."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Judul Verifikasi" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "visible", "description": "Layar verifikasi-perangkat tampil sesuai status belum terdaftar"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}

  @negative @priority-high @REQ-004 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-003 — Agen belum terdaftar tidak lolos melalui bookmark Dashboard
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen telah login pada device A belum terdaftar."
    When user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Bookmark tidak membuka Dashboard bagi device belum terdaftar", "serverAccess": "denied"}
    And sistem memverifikasi elemen "Judul Verifikasi" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "visible", "description": "User tetap diarahkan ke verifikasi-perangkat"}

  @positive @priority-high @REQ-005 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-004 — Login Agen Menunggu menampilkan layar yang benar
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Device A Agen Menunggu; fixture status server sesuai kondisi."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "visible", "description": "Layar menunggu-persetujuan tampil sesuai status Menunggu"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}

  @negative @priority-high @REQ-005 @screen-menunggu-persetujuan
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-004 — Agen Menunggu tidak lolos melalui bookmark Dashboard
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen telah login pada device A Menunggu."
    When user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Bookmark tidak membuka Dashboard bagi device Menunggu", "serverAccess": "denied"}
    And sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "visible", "description": "User tetap diarahkan ke menunggu-persetujuan"}

  @positive @priority-high @REQ-006 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-005 — Login Agen Ditolak menampilkan layar yang benar
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Device A Agen Ditolak; fixture status server sesuai kondisi."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "perangkat-ditolak" memenuhi {"matcher": "visible", "description": "Layar perangkat-ditolak tampil sesuai status Ditolak"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}

  @negative @priority-high @REQ-006 @screen-perangkat-ditolak
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-005 — Agen Ditolak tidak lolos melalui bookmark Dashboard
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen telah login pada device A Ditolak."
    When user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Bookmark tidak membuka Dashboard bagi device Ditolak", "serverAccess": "denied"}
    And sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "perangkat-ditolak" memenuhi {"matcher": "visible", "description": "User tetap diarahkan ke perangkat-ditolak"}

  @positive @priority-high @REQ-007 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-006 — Login Agen Dicabut menampilkan layar yang benar
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Device A Agen Dicabut; fixture status server sesuai kondisi."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "perangkat-dicabut" memenuhi {"matcher": "visible", "description": "Layar perangkat-dicabut tampil sesuai status Dicabut"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}

  @negative @priority-high @REQ-007 @screen-perangkat-dicabut
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-006 — Agen Dicabut tidak lolos melalui bookmark Dashboard
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen telah login pada device A Dicabut."
    When user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Bookmark tidak membuka Dashboard bagi device Dicabut", "serverAccess": "denied"}
    And sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "perangkat-dicabut" memenuhi {"matcher": "visible", "description": "User tetap diarahkan ke perangkat-dicabut"}

  @positive @priority-high @REQ-001 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-007 — Sub Agen terdaftar mengikuti pemeriksaan device
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Sub Agen memiliki device A Aktif."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "subagen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Dashboard" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "visible", "description": "Dashboard tampil sesudah pemeriksaan perangkat"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "serverInvariant", "description": "Device check dilakukan setelah auth berhasil", "deviceCheck": true}

  @negative @priority-high @REQ-001 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-007 — Cache role lain tidak membebaskan Sub Agen dari lock device
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Sub Agen memakai device B belum terdaftar; client menyimpan role Kantor Cabang dari sesi sebelumnya."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "subagen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Judul Verifikasi" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "visible", "description": "Role server Agen/Sub Agen tetap memicu Verifikasi walau cache role lain"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}

  @positive @priority-high @REQ-003 @screen-dashboard
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-008 — Sub Agen Aktif membuka fitur Jual Tiket
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Sub Agen terautentikasi pada device A Aktif."
    When user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    And user mengklik tombol "Jual Tiket" pada konteks "utama" di layar "dashboard"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "visible", "description": "Fitur Jual Tiket dapat diakses", "feature": "Jual Tiket"}

  @negative @priority-high @REQ-003 @screen-dashboard
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-008 — Sub Agen Menunggu gagal membuka URL fitur langsung
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Sub Agen terautentikasi tetapi device A Menunggu."
    When user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "URL halaman utama tidak memberi akses", "serverAccess": "denied"}
    And user berada di halaman "dashboard" pada konteks "utama" melalui "route:jual-tiket"
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "URL fitur Jual Tiket juga menolak akses", "serverAccess": "denied"}

  @positive @priority-high @REQ-004 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-009 — Login Sub Agen belum terdaftar menampilkan layar yang benar
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Device A Sub Agen belum terdaftar; fixture status server sesuai kondisi."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "subagen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Judul Verifikasi" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "visible", "description": "Layar verifikasi-perangkat tampil sesuai status belum terdaftar"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}

  @negative @priority-high @REQ-004 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-009 — Sub Agen belum terdaftar tidak lolos melalui bookmark Dashboard
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Sub Agen telah login pada device A belum terdaftar."
    When user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Bookmark tidak membuka Dashboard bagi device belum terdaftar", "serverAccess": "denied"}
    And sistem memverifikasi elemen "Judul Verifikasi" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "visible", "description": "User tetap diarahkan ke verifikasi-perangkat"}

  @positive @priority-high @REQ-005 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-010 — Login Sub Agen Menunggu menampilkan layar yang benar
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Device A Sub Agen Menunggu; fixture status server sesuai kondisi."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "subagen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "visible", "description": "Layar menunggu-persetujuan tampil sesuai status Menunggu"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}

  @negative @priority-high @REQ-005 @screen-menunggu-persetujuan
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-010 — Sub Agen Menunggu tidak lolos melalui bookmark Dashboard
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Sub Agen telah login pada device A Menunggu."
    When user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Bookmark tidak membuka Dashboard bagi device Menunggu", "serverAccess": "denied"}
    And sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "visible", "description": "User tetap diarahkan ke menunggu-persetujuan"}

  @positive @priority-high @REQ-006 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-011 — Login Sub Agen Ditolak menampilkan layar yang benar
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Device A Sub Agen Ditolak; fixture status server sesuai kondisi."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "subagen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "perangkat-ditolak" memenuhi {"matcher": "visible", "description": "Layar perangkat-ditolak tampil sesuai status Ditolak"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}

  @negative @priority-high @REQ-006 @screen-perangkat-ditolak
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-011 — Sub Agen Ditolak tidak lolos melalui bookmark Dashboard
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Sub Agen telah login pada device A Ditolak."
    When user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Bookmark tidak membuka Dashboard bagi device Ditolak", "serverAccess": "denied"}
    And sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "perangkat-ditolak" memenuhi {"matcher": "visible", "description": "User tetap diarahkan ke perangkat-ditolak"}

  @positive @priority-high @REQ-007 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-012 — Login Sub Agen Dicabut menampilkan layar yang benar
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Device A Sub Agen Dicabut; fixture status server sesuai kondisi."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "subagen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "perangkat-dicabut" memenuhi {"matcher": "visible", "description": "Layar perangkat-dicabut tampil sesuai status Dicabut"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}

  @negative @priority-high @REQ-007 @screen-perangkat-dicabut
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-012 — Sub Agen Dicabut tidak lolos melalui bookmark Dashboard
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Sub Agen telah login pada device A Dicabut."
    When user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Bookmark tidak membuka Dashboard bagi device Dicabut", "serverAccess": "denied"}
    And sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "perangkat-dicabut" memenuhi {"matcher": "visible", "description": "User tetap diarahkan ke perangkat-dicabut"}

  @positive @priority-high @REQ-001 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-013 — Role Kantor Cabang melewati device check sesuai login existing
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Kantor Cabang mempunyai akses existing, device belum terdaftar."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "cabang01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Dashboard" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "visible", "description": "Halaman existing tampil"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "serverInvariant", "description": "Device check tidak dijalankan untuk role lain", "deviceCheck": false}

  @negative @priority-high @REQ-001 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-013 — Gangguan layanan device tidak mengunci role selain Agen/Sub Agen
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Kantor Cabang valid; layanan device gagal jika dipanggil."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "cabang01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Dashboard" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "visible", "description": "Login existing tetap berhasil"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "serverInvariant", "description": "Tidak ada panggilan device check yang menghambat role lain", "deviceCheck": false}

  @positive @priority-high @REQ-002 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-014 — Autentikasi sukses mendahului pembacaan status device
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Kredensial Agen benar dan device A Aktif."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Dashboard" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "visible", "description": "Login sukses"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "serverInvariant", "description": "Urutan trace auth.success sebelum device.check", "eventOrder": ["auth.success", "device.check"]}

  @negative @priority-high @REQ-002 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-014 — Login password salah tidak memulai pemeriksaan device
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Device A Aktif; credential input sengaja invalid."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "salah123" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Login" pada konteks "utama" di layar "login" memenuhi {"matcher": "visible", "description": "User tetap di login dan validasi existing menolak input"}
    And sistem memverifikasi elemen "Login" pada konteks "utama" di layar "login" memenuhi {"matcher": "serverInvariant", "description": "Tidak ada device check, request registrasi atau sesi sah", "deviceCheck": false, "newRequests": 0, "authenticated": false}
    And sistem memverifikasi elemen "Error Login" pada konteks "utama" di layar "login" memenuhi {"matcher": "visible", "description": "Kesalahan credential existing diinformasikan tanpa data status perangkat"}

  @negative @priority-high @REQ-002 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-015 — Login email kosong tidak memulai pemeriksaan device
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Device A Aktif; credential input sengaja invalid."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Login" pada konteks "utama" di layar "login" memenuhi {"matcher": "visible", "description": "User tetap di login dan validasi existing menolak input"}
    And sistem memverifikasi elemen "Login" pada konteks "utama" di layar "login" memenuhi {"matcher": "serverInvariant", "description": "Tidak ada device check, request registrasi atau sesi sah", "deviceCheck": false, "newRequests": 0, "authenticated": false}

  @negative @priority-high @REQ-002 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-016 — Login password kosong tidak memulai pemeriksaan device
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Device A Aktif; credential input sengaja invalid."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Login" pada konteks "utama" di layar "login" memenuhi {"matcher": "visible", "description": "User tetap di login dan validasi existing menolak input"}
    And sistem memverifikasi elemen "Login" pada konteks "utama" di layar "login" memenuhi {"matcher": "serverInvariant", "description": "Tidak ada device check, request registrasi atau sesi sah", "deviceCheck": false, "newRequests": 0, "authenticated": false}

  @negative @priority-high @REQ-002 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-017 — Login format email invalid tidak memulai pemeriksaan device
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Device A Aktif; credential input sengaja invalid."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "bukan-email" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Login" pada konteks "utama" di layar "login" memenuhi {"matcher": "visible", "description": "User tetap di login dan validasi existing menolak input"}
    And sistem memverifikasi elemen "Login" pada konteks "utama" di layar "login" memenuhi {"matcher": "serverInvariant", "description": "Tidak ada device check, request registrasi atau sesi sah", "deviceCheck": false, "newRequests": 0, "authenticated": false}

  @positive @priority-high @REQ-008 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-015 — Browser kedua pada device sama membutuhkan approval sendiri
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Akun Agen telah Aktif pada device A Chromium; konteks utama memakai Firefox di device A."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Judul Verifikasi" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "visible", "description": "Firefox diperlakukan sebagai perangkat baru"}

  @negative @priority-high @REQ-008 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-018 — Approval akun Agen tidak diwariskan ke akun Sub Agen pada browser sama
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Token device A Aktif milik Agen; login Sub Agen belum memiliki device."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "subagen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Judul Verifikasi" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "visible", "description": "Sub Agen wajib verifikasi sendiri"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}

  @positive @priority-high @REQ-009 @screen-menunggu-persetujuan
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-016 — Approval terbaru membuka akses walaupun status cache masih Menunggu
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen Menunggu pada konteks utama, Kantor Pusat berizin pada konteks pusat."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    And user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    Then sistem memverifikasi elemen "Dashboard" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "visible", "description": "Status server Aktif mengizinkan Dashboard tanpa memakai cache Menunggu"}

  @negative @priority-high @REQ-009 @screen-dashboard
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-019 — Pencabutan menolak fitur pada sesi aktif sebelum grace period prototipe
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen sudah login Aktif; Kantor Pusat melihat request A Aktif."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Cabut Perangkat" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Alasan" dengan "Perangkat lama diganti" pada konteks "pusat" di layar "cabut-perangkat"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "cabut-perangkat"
    And user mengklik tombol "Jual Tiket" pada konteks "utama" di layar "dashboard"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Request fitur setelah commit Dicabut ditolak langsung", "serverAccess": "denied"}
    And sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "perangkat-dicabut" memenuhi {"matcher": "visible", "description": "Sesi menampilkan Dicabut"}

  @positive @priority-high @REQ-010 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-017 — Verifikasi hanya tampil setelah Agen autentikasi perangkat baru
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen memakai device A belum terdaftar."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Identitas Akun" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "visible", "description": "Identitas sesuai akun Agen terautentikasi"}
    And sistem memverifikasi elemen "Informasi Perangkat" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "visible", "description": "Browser dan perangkat sesuai konteks fixture"}
    And sistem memverifikasi elemen "Lokasi Perkiraan" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "visible", "description": "Lokasi hanya informasi dan bukan validasi izin"}
    And sistem memverifikasi elemen "Info Browser Baru" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "visible", "description": "Informasi hapus data browser dan incognito tampil"}

  @negative @priority-high @REQ-010 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-020 — URL Verifikasi tanpa sesi tidak menampilkan kode atau identitas
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Tidak ada sesi autentikasi."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    Then sistem memverifikasi elemen "Kode Perangkat" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "hidden", "description": "Kode registrasi tidak dibocorkan"}
    And sistem memverifikasi elemen "Identitas Akun" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "hidden", "description": "Data akun tidak dibocorkan"}
    And sistem memverifikasi elemen "Login" pada konteks "utama" di layar "login" memenuhi {"matcher": "visible", "description": "User diarahkan ke login"}

  @positive @priority-high @REQ-011 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-018 — Dua pasangan perangkat baru memperoleh kode berbeda
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Dua konteks perangkat A dan B untuk akun Agen yang sama telah autentikasi."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user berada di halaman "verifikasi-perangkat" pada konteks "sesi-lain" melalui "route:verifikasi-perangkat"
    Then sistem memverifikasi elemen "Kode Perangkat" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "serverInvariant", "description": "Kode A dan B berbeda serta masing-masing terikat pada perangkatnya", "uniqueAcrossContexts": true}

  @negative @priority-high @REQ-011 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-021 — Kode tidak dikenal tidak mengaktifkan request lain
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu; dialog Setujui dibuka Kantor Pusat."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "String Code" dengan "ZZZZ-9999" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Error Kode" pada konteks "pusat" di layar "registrasi-device" memenuhi {"matcher": "visible", "description": "Kode tidak ditemukan ditampilkan"}
    And sistem memverifikasi elemen "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device" memenuhi {"matcher": "disabled", "description": "Konfirmasi disabled untuk kode tidak dikenal"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Tidak ada request yang berubah menjadi Aktif", "activeChanges": 0}

  @positive @priority-high @REQ-012 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-019 — Kirim berhasil dengan Nama Perangkat kosong
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen terautentikasi dan perangkat belum terdaftar."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "" pada konteks "utama" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "visible", "description": "Request menjadi Menunggu"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Nama tersimpan sesuai input tanpa kewajiban field", "deviceName": "", "newRequests": 1}

  @positive @priority-high @REQ-012 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-020 — Kirim berhasil dengan Nama Perangkat diisi
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen terautentikasi dan perangkat belum terdaftar."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "COM-ADM-001" pada konteks "utama" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "visible", "description": "Request menjadi Menunggu"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Nama tersimpan sesuai input tanpa kewajiban field", "deviceName": "COM-ADM-001", "newRequests": 1}

  @negative @priority-high @REQ-012 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-022 — Tidak boleh menampilkan wajib isi saat Nama Perangkat kosong
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Sub Agen perangkat baru sudah autentikasi."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "" pada konteks "utama" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Kirim" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "enabled", "description": "Tombol Kirim enabled walaupun nama kosong"}
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    And sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "visible", "description": "Nama kosong tidak menahan pengiriman"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Tidak ada kegagalan validation required pada Nama Perangkat", "fieldRequired": false}

  @positive @priority-high @REQ-013 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-021 — Payload pengajuan membawa seluruh data minimum dari sesi
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Device A belum terdaftar; clock fixture telah dipasang."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "COM-ADM-001" pada konteks "utama" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Waktu Permintaan" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "timestamps", "description": "Info waktu pada verifikasi sesuai konteks, bukan pengganti timestamp server", "serverTimeAuthoritative": true}
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Request memuat akun, kode, device/browser, nama dan timestamp server", "requiredFields": ["accountId", "code", "device", "browser", "deviceName", "requestedAt"]}
    And sistem memverifikasi elemen "Waktu Permintaan" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "visible", "description": "Tanggal dan waktu pengiriman tampil"}

  @negative @priority-high @REQ-013 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-023 — Gagal jaringan pengiriman tidak menghasilkan Menunggu palsu
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request registrasi ditolak jaringan sebelum commit."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "COM-ADM-001" pada konteks "utama" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Error Pengiriman" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "visible", "description": "Pengiriman gagal diinformasikan"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Tidak ada request berhasil dan akses tetap ditolak", "newRequests": 0}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}

  @positive @priority-high @REQ-014 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-022 — Request berhasil langsung berstatus Menunggu di kedua sisi
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen perangkat baru; pusat berada pada daftar request."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "COM-ADM-001" pada konteks "utama" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "visible", "description": "Status Menunggu di Agen"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Request baru Menunggu tampil Kantor Pusat", "status": "Menunggu"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}

  @negative @priority-high @REQ-014 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-024 — Respons Kirim berhasil tidak memberikan akses sebelum approval
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Perangkat baru; respons submit sukses tersedia."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "COM-ADM-001" pada konteks "utama" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    And user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Sukses pengiriman bukan approval", "serverAccess": "denied"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Status tetap Menunggu, tidak otomatis Aktif", "status": "Menunggu"}

  @positive @priority-high @REQ-015 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-023 — Login ulang Menunggu menjaga request dan kode lama
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu sudah tersimpan sebelum sesi ditutup."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Kode Permintaan" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "text", "description": "Kode request lama tetap 7K4M-92QD", "text": "7K4M-92QD"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Tetap satu request untuk akun/device/browser", "requestCount": 1, "requestId": "request-A"}
    And user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And sistem memverifikasi elemen "Data Kode" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "text", "description": "String Code pada daftar sama dengan kode halaman Agen", "text": "7K4M-92QD"}

  @negative @priority-high @REQ-015 @screen-menunggu-persetujuan
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-025 — Reload berulang tidak menggandakan request Menunggu
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu sudah ada; Agen terautentikasi."
    When user berada di halaman "menunggu-persetujuan" pada konteks "utama" melalui "route:menunggu-persetujuan"
    And user berada di halaman "menunggu-persetujuan" pada konteks "utama" melalui "route:menunggu-persetujuan"
    And user berada di halaman "menunggu-persetujuan" pada konteks "utama" melalui "route:menunggu-persetujuan"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Reload tidak membuat request baru", "requestCount": 1}
    And sistem memverifikasi elemen "Kode Permintaan" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "text", "description": "Kode tetap sama", "text": "7K4M-92QD"}

  @positive @priority-high @REQ-016 @screen-menunggu-persetujuan
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-024 — Halaman Menunggu otomatis mengikuti Setujui tanpa klik Periksa Status
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen pada halaman Menunggu dan pusat berizin; mekanisme pembaruan nyata aktif."
    When user berada di halaman "menunggu-persetujuan" pada konteks "utama" melalui "route:menunggu-persetujuan"
    And user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Pesan Persetujuan" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "visibleOrRedirect", "description": "Persetujuan terdeteksi otomatis tanpa reload/klik", "alternativeScreen": "dashboard"}
    And sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "serverInvariant", "description": "Status terakhir Aktif di client/server", "status": "Aktif"}

  @negative @priority-high @REQ-016 @screen-menunggu-persetujuan
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-026 — Halaman Menunggu otomatis mengikuti Tolak tanpa membuka Dashboard
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Halaman Menunggu terbuka; request A belum diproses."
    When user berada di halaman "menunggu-persetujuan" pada konteks "utama" melalui "route:menunggu-persetujuan"
    And user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Tolak" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Alasan" dengan "Perangkat tidak dikenali" pada konteks "pusat" di layar "tolak-permintaan"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "tolak-permintaan"
    Then sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "perangkat-ditolak" memenuhi {"matcher": "visibleOrInline", "description": "Penolakan otomatis terlihat tanpa reload", "alternativeScreen": "menunggu-persetujuan"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}
    And sistem memverifikasi elemen "Alasan Proses" pada konteks "utama" di layar "perangkat-ditolak" memenuhi {"matcher": "text", "description": "Alasan penolakan pusat ditampilkan", "text": "Perangkat tidak dikenali"}

  @positive @priority-medium @REQ-017 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-025 — Kantor Pusat membuka Manajemen Device dari Daftar Relasi
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "User Kantor Pusat sudah login dengan izin pengelolaan."
    When user berada di halaman "dashboard" pada konteks "pusat" melalui "route:dashboard"
    And user mengklik tombol "Daftar Relasi" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Manajemen Device" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "visible", "description": "Daftar request dan histori tampil"}

  @negative @priority-high @REQ-017 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-027 — Agen tidak mendapatkan menu atau akses langsung Manajemen Device
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen perangkat Aktif login tetapi tanpa izin pengelolaan."
    When user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    Then sistem memverifikasi elemen "Manajemen Device" pada konteks "utama" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Menu pengelolaan tidak tersedia bagi Agen"}
    And user berada di halaman "manajemen-device" pada konteks "utama" melalui "route:manajemen-device"
    And sistem memverifikasi elemen "Tabel Device" pada konteks "utama" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "URL pengelolaan tidak membocorkan daftar device"}

  @positive @priority-medium @REQ-018 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-026 — Daftar dan detail mempertahankan seluruh histori per akun
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Akun Agen memiliki request Aktif, Ditolak dan Dicabut serta histori lengkap."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Tab Semua" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "visible", "description": "Semua perangkat akun termasuk histori lama tampil"}
    And user mengklik tombol "Lihat Detail" pada konteks "pusat" di layar "manajemen-device"
    And sistem memverifikasi elemen "Riwayat" pada konteks "pusat" di layar "detail-perangkat" memenuhi {"matcher": "visible", "description": "Riwayat registrasi dan perubahan status lengkap"}
    And user mengklik tombol "Tutup" pada konteks "pusat" di layar "detail-perangkat"

  @negative @priority-high @REQ-018 @screen-detail-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-028 — Histori akun lain tidak tercampur pada detail request
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Akun Agen A dan B mempunyai kode/nama perangkat mirip namun request berbeda."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Lihat Detail" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Riwayat" pada konteks "pusat" di layar "detail-perangkat" memenuhi {"matcher": "serverInvariant", "description": "Detail hanya memuat histori request A, tanpa histori request B", "belongsTo": "request-A", "excludesRequest": "request-B"}

  @positive @priority-medium @REQ-019 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-027 — Label Agen dan Sub Agen sesuai pemilik masing-masing
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Daftar berisi request Agen A dan Sub Agen S."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Tab Semua" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Data Akun" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "rowValues", "description": "Baris A berlabel Agen, baris S berlabel Sub Agen", "values": {"request-A": "Agen", "request-S": "Sub Agen"}}

  @negative @priority-high @REQ-019 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-029 — Label Sub Agen tidak berubah menjadi Agen setelah approval
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A milik Sub Agen Menunggu."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Data Akun" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "text", "description": "Label tetap Sub Agen setelah status menjadi Aktif", "text": "Sub Agen"}

  @positive @priority-medium @REQ-020 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-028 — Cabang tiap Agen dan Sub Agen ditampilkan
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request Agen Balikpapan dan Sub Agen Surabaya tersedia."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Tab Semua" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Data Akun" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "rowValues", "description": "Cabang tiap akun sesuai master relasi", "values": {"request-A": "Cabang Balikpapan", "request-S": "Cabang Surabaya"}}

  @negative @priority-medium @REQ-020 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-030 — Filter berganti akun tidak menampilkan cabang akun sebelumnya
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Dua akun berbeda cabang tersedia."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Filter" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Nama Agen / Sub Agen" dengan "Sub Agen Dua" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Data Akun" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "rowValues", "description": "Hasil akun kedua tidak mewarisi cabang akun pertama", "values": {"request-S": "Cabang Surabaya"}, "excludedText": "Cabang Balikpapan"}

  @positive @priority-medium @REQ-021 @screen-detail-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-029 — Relasi Agen induk Sub Agen diketahui pada daftar dan detail
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A milik Sub Agen dengan parent agen-001."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    Then sistem memverifikasi elemen "Data Akun" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "text", "description": "Agen induk tersedia pada data Sub Agen", "text": "Agen Satu"}
    And user mengklik tombol "Lihat Detail" pada konteks "pusat" di layar "manajemen-device"
    And sistem memverifikasi elemen "Detail Akun" pada konteks "pusat" di layar "detail-perangkat" memenuhi {"matcher": "text", "description": "Detail relasi menampilkan Agen Satu", "text": "Agen Satu"}

  @negative @priority-medium @REQ-021 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-031 — Sub Agen dengan nama sama tidak tertukar Agen induknya
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Dua Sub Agen bernama sama terkait Agen induk berbeda dan ID berbeda."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    Then sistem memverifikasi elemen "Data Akun" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "rowValues", "description": "Relasi berdasarkan ID akun, bukan kesamaan nama", "values": {"request-A": "Agen Satu", "request-S": "Agen Dua"}}

  @positive @priority-medium @REQ-022 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-030 — Informasi nama jenis perangkat dan browser tersaji
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A berlabel COM-ADM-001, device desktop, browser Chromium."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    Then sistem memverifikasi elemen "Data Perangkat" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "containsFields", "description": "Nama, jenis desktop dan Chromium tampil", "fields": ["COM-ADM-001", "Desktop", "Chromium"]}
    And user mengklik tombol "Lihat Detail" pada konteks "pusat" di layar "manajemen-device"
    And sistem memverifikasi elemen "Detail Perangkat" pada konteks "pusat" di layar "detail-perangkat" memenuhi {"matcher": "containsFields", "description": "Detail sesuai data perangkat", "fields": ["COM-ADM-001", "Desktop", "Chromium"]}

  @negative @priority-medium @REQ-022 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-032 — Nama opsional kosong tidak menghilangkan jenis atau browser
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A memiliki nama null, perangkat Mobile dan browser Safari."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    Then sistem memverifikasi elemen "Data Perangkat" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "containsFields", "description": "Mobile dan Safari tetap tampil tanpa undefined/null sebagai nama", "fields": ["Mobile", "Safari"], "excludedText": ["undefined", "null"]}

  @positive @priority-high @REQ-023 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-031 — Timestamp permintaan dan proses memuat tanggal serta waktu
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu dibuat 08/10/2026 09:58 WIB; approval pukul 10:00 WIB."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Data Waktu" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "timestamps", "description": "Permintaan dan approval memuat tanggal dan waktu yang benar", "requestedAt": "2026-10-08T02:58:00Z", "processedAt": "2026-10-08T03:00:00Z"}
    And user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Lihat Detail" pada konteks "pusat" di layar "manajemen-device"
    And sistem memverifikasi elemen "Detail Waktu" pada konteks "pusat" di layar "detail-perangkat" memenuhi {"matcher": "timestamps", "description": "Waktu di detail konsisten dengan daftar", "requestedAt": "2026-10-08T02:58:00Z", "processedAt": "2026-10-08T03:00:00Z"}

  @negative @priority-high @REQ-023 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-033 — Request belum diproses tidak memiliki waktu approval palsu
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu tanpa processedAt."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    Then sistem memverifikasi elemen "Data Waktu" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Waktu permintaan ada; approval kosong/placeholder tanpa tanggal rekaan", "processedAt": null, "requestedAtPresent": true}

  @positive @priority-high @REQ-024 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-032 — Nama dan email pemroses sesuai petugas pusat kedua
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Petugas Pusat Dua memproses request, bukan petugas default prototipe."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Data Pemroses" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "containsFields", "description": "Diproses Oleh memuat nama/email petugas aktual", "fields": ["Petugas Pusat Dua", "pusat02@example.test"]}

  @negative @priority-high @REQ-024 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-034 — Request Menunggu tidak menampilkan pemroses palsu
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request belum pernah diproses Kantor Pusat."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    Then sistem memverifikasi elemen "Data Pemroses" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Nama/email pemroses kosong atau placeholder, bukan user login terakhir", "processor": null}

  @positive @priority-high @REQ-025 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-033 — Kantor Pusat menyetujui Agen dan akses perangkat dibuka
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Agen Menunggu; kedua konteks autentikasi."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    And user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Dashboard" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "visible", "description": "Perangkat yang disetujui masuk Dashboard"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Status, timestamp, nama dan email approval tersimpan", "status": "Aktif", "processedAtPresent": true, "processor": "pusat-001"}

  @positive @priority-high @REQ-025 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-034 — Kantor Pusat menyetujui Sub Agen dan akses perangkat dibuka
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Sub Agen Menunggu; kedua konteks autentikasi."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    And user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "subagen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Dashboard" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "visible", "description": "Perangkat yang disetujui masuk Dashboard"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Status, timestamp, nama dan email approval tersimpan", "status": "Aktif", "processedAtPresent": true, "processor": "pusat-001"}

  @negative @priority-high @REQ-025 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-035 — Approval gagal sebelum commit tidak membuka akses
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu; proses approval mengalami error server sebelum commit."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Status tetap Menunggu dan audit approval sukses tidak dibuat", "status": "Menunggu", "successfulApprovals": 0}
    And user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Approval gagal tidak membuka Dashboard", "serverAccess": "denied"}

  @positive @priority-high @REQ-026 @screen-tolak-permintaan
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-035 — Kantor Pusat menolak Menunggu dan menyimpan histori
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu; alasan nonblank tersedia."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Tolak" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Alasan" dengan "Perangkat tidak dikenali" pada konteks "pusat" di layar "tolak-permintaan"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "tolak-permintaan"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Status menjadi Ditolak dan histori penolakan tercatat", "status": "Ditolak", "historyEvent": "Permintaan ditolak"}
    And sistem memverifikasi elemen "Waktu Proses" pada konteks "utama" di layar "perangkat-ditolak" memenuhi {"matcher": "visible", "description": "Tanggal dan waktu penolakan tampil"}
    And sistem memverifikasi elemen "Diproses Oleh" pada konteks "utama" di layar "perangkat-ditolak" memenuhi {"matcher": "visible", "description": "Nama/email pemroses penolakan tampil"}
    And sistem memverifikasi elemen "Bantuan" pada konteks "utama" di layar "perangkat-ditolak" memenuhi {"matcher": "visible", "description": "Panduan bantuan tersedia tanpa menguji nomor placeholder"}

  @negative @priority-high @REQ-026 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-036 — Menunggu tidak menawarkan Cabut atau Aktifkan Kembali
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Baris request A berstatus Menunggu."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    Then sistem memverifikasi elemen "Setujui" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "visible", "description": "Setujui tersedia"}
    And sistem memverifikasi elemen "Tolak" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "visible", "description": "Tolak tersedia"}
    And sistem memverifikasi elemen "Cabut Perangkat" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Cabut tidak tersedia"}
    And sistem memverifikasi elemen "Aktifkan Kembali" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Reaktivasi tidak tersedia"}

  @positive @priority-high @REQ-027 @screen-detail-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-036 — Cabut Aktif dari detail menghasilkan Dicabut dan histori
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Aktif; pusat membuka detail perangkat."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Lihat Detail" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Dialog Detail" pada konteks "pusat" di layar "detail-perangkat" memenuhi {"matcher": "visible", "description": "Detail tersedia"}
    And user mengklik tombol "Cabut Perangkat" pada konteks "pusat" di layar "detail-perangkat"
    And user mengisi field "Alasan" dengan "Perangkat hilang" pada konteks "pusat" di layar "cabut-perangkat"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "cabut-perangkat"
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Device Dicabut dan histori lama tetap ada", "status": "Dicabut", "historyEvent": "Perangkat dicabut"}
    And sistem memverifikasi elemen "Waktu Proses" pada konteks "utama" di layar "perangkat-dicabut" memenuhi {"matcher": "visible", "description": "Waktu pencabutan tampil"}
    And sistem memverifikasi elemen "Diproses Oleh" pada konteks "utama" di layar "perangkat-dicabut" memenuhi {"matcher": "visible", "description": "Nama/email pencabut tampil"}
    And sistem memverifikasi elemen "Alasan Proses" pada konteks "utama" di layar "perangkat-dicabut" memenuhi {"matcher": "text", "description": "Alasan pencabutan tampil sesuai histori", "text": "Perangkat hilang"}
    And sistem memverifikasi elemen "Bantuan" pada konteks "utama" di layar "perangkat-dicabut" memenuhi {"matcher": "visible", "description": "Panduan menghubungi Kantor Pusat tersedia"}

  @negative @priority-high @REQ-027 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-037 — Aktif tidak menawarkan Setujui Tolak atau reaktivasi
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Aktif."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    Then sistem memverifikasi elemen "Setujui" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Aksi Setujui tidak tersedia untuk Aktif"}
    And sistem memverifikasi elemen "Tolak" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Aksi Tolak tidak tersedia untuk Aktif"}
    And sistem memverifikasi elemen "Aktifkan Kembali" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Aksi Aktifkan Kembali tidak tersedia untuk Aktif"}

  @positive @priority-medium @REQ-028 @screen-detail-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-037 — Ditolak hanya menyediakan Lihat Detail dan histori tetap ada
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Ditolak dengan alasan tersimpan."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Lihat Detail" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Riwayat" pada konteks "pusat" di layar "detail-perangkat" memenuhi {"matcher": "visible", "description": "Registrasi dan alasan penolakan tetap ada"}
    And user mengklik tombol "Tutup" pada konteks "pusat" di layar "detail-perangkat"
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Record request Ditolak tidak dihapus", "status": "Ditolak", "requestCount": 1}

  @negative @priority-high @REQ-028 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-038 — Ditolak tidak dapat disetujui dicabut atau diaktifkan kembali
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Ditolak."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    Then sistem memverifikasi elemen "Setujui" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Aksi Setujui tidak tersedia untuk Ditolak"}
    And sistem memverifikasi elemen "Tolak" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Aksi Tolak tidak tersedia untuk Ditolak"}
    And sistem memverifikasi elemen "Cabut Perangkat" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Aksi Cabut Perangkat tidak tersedia untuk Ditolak"}
    And sistem memverifikasi elemen "Aktifkan Kembali" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Aksi Aktifkan Kembali tidak tersedia untuk Ditolak"}

  @positive @priority-high @REQ-029 @screen-detail-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-038 — Dicabut menawarkan detail dan Aktifkan Kembali tanpa penghapusan
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Dicabut mempunyai histori approval dan cabut."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    Then sistem memverifikasi elemen "Aktifkan Kembali" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "visible", "description": "Aksi reaktivasi tersedia"}
    And user mengklik tombol "Lihat Detail" pada konteks "pusat" di layar "manajemen-device"
    And sistem memverifikasi elemen "Aktifkan Kembali" pada konteks "pusat" di layar "detail-perangkat" memenuhi {"matcher": "visible", "description": "Aksi reaktivasi juga tersedia dari detail"}
    And sistem memverifikasi elemen "Riwayat" pada konteks "pusat" di layar "detail-perangkat" memenuhi {"matcher": "visible", "description": "Histori sebelum pencabutan tetap ada"}
    And user mengklik tombol "Tutup" pada konteks "pusat" di layar "detail-perangkat"

  @negative @priority-high @REQ-029 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-039 — Dicabut tidak menawarkan Setujui Tolak atau Cabut lagi
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Dicabut."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    Then sistem memverifikasi elemen "Setujui" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Aksi Setujui tidak tersedia untuk Dicabut"}
    And sistem memverifikasi elemen "Tolak" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Aksi Tolak tidak tersedia untuk Dicabut"}
    And sistem memverifikasi elemen "Cabut Perangkat" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Aksi Cabut Perangkat tidak tersedia untuk Dicabut"}

  @positive @priority-high @REQ-030 @screen-aktifkan-kembali
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-039 — Reaktivasi Agen memakai perangkat dan kode yang sama
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Agen Dicabut; akun punya kurang dari dua perangkat Aktif."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Aktifkan Kembali" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "aktifkan-kembali"
    Then sistem memverifikasi elemen "Notifikasi" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "visible", "description": "Notifikasi sukses reaktivasi muncul sesudah commit"}
    And user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    And sistem memverifikasi elemen "Dashboard" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "visible", "description": "Perangkat yang sama kembali dapat dipakai"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Request dan kode tetap, histori reaktivasi ditambah", "status": "Aktif", "requestCount": 1, "code": "7K4M-92QD", "historyEvent": "Perangkat diaktifkan kembali"}

  @positive @priority-high @REQ-030 @screen-aktifkan-kembali
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-040 — Reaktivasi Sub Agen memakai perangkat dan kode yang sama
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Sub Agen Dicabut; akun punya kurang dari dua perangkat Aktif."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Aktifkan Kembali" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "aktifkan-kembali"
    And user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "subagen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Dashboard" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "visible", "description": "Perangkat yang sama kembali dapat dipakai"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Request dan kode tetap, histori reaktivasi ditambah", "status": "Aktif", "requestCount": 1, "code": "7K4M-92QD", "historyEvent": "Perangkat diaktifkan kembali"}

  @negative @priority-high @REQ-030 @screen-aktifkan-kembali
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-040 — Reaktivasi gagal tidak memberi akses atau menghapus histori cabut
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Dicabut; reaktivasi gagal sebelum commit."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Aktifkan Kembali" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "aktifkan-kembali"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Status tetap Dicabut, histori cabut masih ada", "status": "Dicabut", "historyEvent": "Perangkat dicabut"}
    And user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}

  @positive @priority-high @REQ-031 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-041 — Pergantian perangkat mencabut lama lalu menyetujui yang baru
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Akun Agen mempunyai device lama Aktif request A; utama device B baru; pusat memilih A."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Cabut Perangkat" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Alasan" dengan "Perangkat lama diganti" pada konteks "pusat" di layar "cabut-perangkat"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "cabut-perangkat"
    And user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "COM-ADM-NEW" pada konteks "utama" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    And user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Tab Menunggu" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    And user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    Then sistem memverifikasi elemen "Dashboard" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "visible", "description": "Perangkat B masuk setelah approval"}
    And user berada di halaman "dashboard" pada konteks "sesi-lain" melalui "route:dashboard"
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "sesi-lain" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Perangkat lama A tetap ditolak", "serverAccess": "denied"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Histori A Dicabut dan B Aktif sama-sama tersimpan", "statuses": {"request-A": "Dicabut", "request-B": "Aktif"}}

  @negative @priority-high @REQ-031 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-041 — Mencabut perangkat lama tidak otomatis menyetujui perangkat baru
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Device lama A Aktif; konteks utama device B baru."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Cabut Perangkat" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Alasan" dengan "Perangkat lama diganti" pada konteks "pusat" di layar "cabut-perangkat"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "cabut-perangkat"
    And user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Judul Verifikasi" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "visible", "description": "Device baru tetap harus verifikasi"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Hanya device lama menjadi Dicabut; baru tidak mendapat approval", "statuses": {"request-A": "Dicabut"}, "newApprovals": 0}

  @positive @priority-high @REQ-032 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-042 — Approval Sub Agen berhasil hanya lewat user Kantor Pusat
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Sub Agen Menunggu; pusat memiliki izin dan induk tidak."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Pemroses Sub Agen adalah Kantor Pusat", "status": "Aktif", "processor": "pusat-001"}

  @negative @priority-high @REQ-032 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-042 — Agen induk tidak berwenang Setujui perangkat Sub Agen
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen induk login Aktif; request Sub Agen berstatus Menunggu; fixture mengirim percobaan operasi sebagai induk saat navigasi."
    When user berada di halaman "manajemen-device" pada konteks "utama" melalui "route:manajemen-device"
    Then sistem memverifikasi elemen "Setujui" pada konteks "utama" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Kontrol Setujui tidak tersedia bagi Agen induk"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Percobaan Setujui sebagai induk ditolak server tanpa mutasi", "status": "Menunggu", "unauthorizedOperation": "Setujui", "authorized": false, "historyChanges": 0}

  @negative @priority-high @REQ-032 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-043 — Agen induk tidak berwenang Tolak perangkat Sub Agen
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen induk login Aktif; request Sub Agen berstatus Menunggu; fixture mengirim percobaan operasi sebagai induk saat navigasi."
    When user berada di halaman "manajemen-device" pada konteks "utama" melalui "route:manajemen-device"
    Then sistem memverifikasi elemen "Tolak" pada konteks "utama" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Kontrol Tolak tidak tersedia bagi Agen induk"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Percobaan Tolak sebagai induk ditolak server tanpa mutasi", "status": "Menunggu", "unauthorizedOperation": "Tolak", "authorized": false, "historyChanges": 0}

  @negative @priority-high @REQ-032 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-044 — Agen induk tidak berwenang Cabut Perangkat perangkat Sub Agen
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen induk login Aktif; request Sub Agen berstatus Aktif; fixture mengirim percobaan operasi sebagai induk saat navigasi."
    When user berada di halaman "manajemen-device" pada konteks "utama" melalui "route:manajemen-device"
    Then sistem memverifikasi elemen "Cabut Perangkat" pada konteks "utama" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Kontrol Cabut Perangkat tidak tersedia bagi Agen induk"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Percobaan Cabut Perangkat sebagai induk ditolak server tanpa mutasi", "status": "Aktif", "unauthorizedOperation": "Cabut Perangkat", "authorized": false, "historyChanges": 0}

  @negative @priority-high @REQ-032 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-045 — Agen induk tidak berwenang Aktifkan Kembali perangkat Sub Agen
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen induk login Aktif; request Sub Agen berstatus Dicabut; fixture mengirim percobaan operasi sebagai induk saat navigasi."
    When user berada di halaman "manajemen-device" pada konteks "utama" melalui "route:manajemen-device"
    Then sistem memverifikasi elemen "Aktifkan Kembali" pada konteks "utama" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Kontrol Aktifkan Kembali tidak tersedia bagi Agen induk"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Percobaan Aktifkan Kembali sebagai induk ditolak server tanpa mutasi", "status": "Dicabut", "unauthorizedOperation": "Aktifkan Kembali", "authorized": false, "historyChanges": 0}

  @positive @priority-medium @REQ-033 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-043 — Kode lowercase tanpa strip dinormalisasi dan lookup tepat
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu berkode 7K4M-92QD."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "String Code" dengan "7k4m92qd" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "String Code" pada konteks "pusat" di layar "registrasi-device" memenuhi {"matcher": "value", "description": "Field menjadi 7K4M-92QD", "value": "7K4M-92QD"}
    And sistem memverifikasi elemen "Hasil Lookup" pada konteks "pusat" di layar "registrasi-device" memenuhi {"matcher": "visible", "description": "Lookup menampilkan akun dan perangkat request A"}
    And sistem memverifikasi elemen "Dialog Registrasi" pada konteks "pusat" di layar "registrasi-device" memenuhi {"matcher": "visible", "description": "Dialog registrasi tersedia dengan judul sesuai"}

  @negative @priority-high @REQ-033 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-046 — Kode kosong menahan konfirmasi registrasi
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu; pusat membuka registrasi."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "String Code" dengan "" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device" memenuhi {"matcher": "disabled", "description": "Konfirmasi registrasi disabled"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Tidak ada approval dengan kode invalid", "status": "Menunggu", "successfulApprovals": 0}

  @negative @priority-high @REQ-033 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-047 — Kode 7 karakter menahan konfirmasi registrasi
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu; pusat membuka registrasi."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "String Code" dengan "7K4M-92Q" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device" memenuhi {"matcher": "disabled", "description": "Konfirmasi registrasi disabled"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Tidak ada approval dengan kode invalid", "status": "Menunggu", "successfulApprovals": 0}

  @negative @priority-high @REQ-033 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-048 — Kode tidak dikenal menahan konfirmasi registrasi
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu; pusat membuka registrasi."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "String Code" dengan "ZZZZ-9999" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device" memenuhi {"matcher": "disabled", "description": "Konfirmasi registrasi disabled"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Tidak ada approval dengan kode invalid", "status": "Menunggu", "successfulApprovals": 0}

  @positive @priority-medium @REQ-034 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-044 — Nama 30 karakter diterima dan dipertahankan
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Perangkat baru; panjang nama tepat 30 karakter ASCII."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" pada konteks "utama" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Informasi Perangkat" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "text", "description": "Nama 30 karakter ditampilkan utuh", "text": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Nama 30 karakter tersimpan utuh", "deviceName": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"}

  @negative @priority-medium @REQ-034 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-049 — Nama 31 karakter tidak tersimpan melewati maxlength prototipe
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Perangkat baru; input nama ASCII 31 karakter."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" pada konteks "utama" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Nama Perangkat" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "valueLength", "description": "Input membatasi nama maksimal 30 karakter", "max": 30}
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Nama tersimpan tidak melampaui 30 karakter", "maxDeviceNameLength": 30}

  @positive @priority-high @REQ-035 @screen-tolak-permintaan
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-045 — Alasan penolakan nonblank tersimpan dan ditampilkan ke Agen
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Tolak" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Alasan" dengan "Tidak sesuai perangkat operasional" pada konteks "pusat" di layar "tolak-permintaan"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "tolak-permintaan"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Alasan masuk histori penolakan", "reason": "Tidak sesuai perangkat operasional"}
    And sistem memverifikasi elemen "Alasan Proses" pada konteks "utama" di layar "perangkat-ditolak" memenuhi {"matcher": "text", "description": "Alasan yang sama tampil ke Agen", "text": "Tidak sesuai perangkat operasional"}

  @positive @priority-high @REQ-035 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-046 — Catatan approval kosong tetap mengizinkan approval
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu; catatan dibiarkan kosong."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Catatan" dengan "" pada konteks "pusat" di layar "registrasi-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Approval sukses dengan catatan kosong", "status": "Aktif", "note": ""}

  @negative @priority-high @REQ-035 @screen-tolak-permintaan
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-050 — Alasan whitespace menahan konfirmasi Tolak
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu; alasan hanya whitespace."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Tolak" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Alasan" dengan "   " pada konteks "pusat" di layar "tolak-permintaan"
    Then sistem memverifikasi elemen "Konfirmasi" pada konteks "pusat" di layar "tolak-permintaan" memenuhi {"matcher": "disabled", "description": "Konfirmasi disabled untuk alasan blank setelah trim"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Status dan histori tidak berubah", "status": "Menunggu", "historyChanges": 0}
    And sistem memverifikasi elemen "Dialog Proses" pada konteks "pusat" di layar "tolak-permintaan" memenuhi {"matcher": "visible", "description": "Judul dialog penolakan sesuai aksi"}

  @negative @priority-high @REQ-035 @screen-cabut-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-051 — Alasan whitespace menahan konfirmasi Cabut Perangkat
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Aktif; alasan hanya whitespace."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Cabut Perangkat" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Alasan" dengan "   " pada konteks "pusat" di layar "cabut-perangkat"
    Then sistem memverifikasi elemen "Konfirmasi" pada konteks "pusat" di layar "cabut-perangkat" memenuhi {"matcher": "disabled", "description": "Konfirmasi disabled untuk alasan blank setelah trim"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Status dan histori tidak berubah", "status": "Aktif", "historyChanges": 0}
    And sistem memverifikasi elemen "Dialog Proses" pada konteks "pusat" di layar "cabut-perangkat" memenuhi {"matcher": "visible", "description": "Judul dialog pencabutan sesuai aksi"}

  @positive @priority-medium @REQ-036 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-047 — Kombinasi seluruh filter menghasilkan request yang sesuai
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Data memuat request A Aktif dan data pembanding yang berbeda di setiap filter."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Filter" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Nama Agen / Sub Agen" dengan "Agen Satu" pada konteks "pusat" di layar "manajemen-device"
    And user memilih opsi "Agen" pada dropdown "Jenis Akun" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "String Code" dengan "7k4m" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Perangkat" dengan "Chromium" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Tanggal Permintaan" dengan "2026-10-08" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Tanggal Approval" dengan "2026-10-08" pada konteks "pusat" di layar "manajemen-device"
    And user memilih opsi "Petugas Pusat Satu" pada dropdown "Diproses Oleh" pada konteks "pusat" di layar "manajemen-device"
    And user memilih opsi "AKTIF" pada dropdown "Status" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "rows", "description": "Hanya request A yang cocok seluruh kondisi", "requestIds": ["request-A"]}

  @negative @priority-medium @REQ-036 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-052 — Filter tidak cocok menampilkan empty tanpa data akun lain
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Daftar perangkat ada namun tidak ada nama TakAdaAkun."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Filter" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Nama Agen / Sub Agen" dengan "TakAdaAkun" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Empty State" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "visible", "description": "Tidak Ada Data yang tersedia tampil"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "rows", "description": "Tidak ada baris data request", "requestIds": []}

  @positive @priority-medium @REQ-037 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-048 — Semua tab memuat status sesuai dan jumlah Menunggu akurat
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Data berisi dua Menunggu dan masing-masing satu Aktif/Ditolak/Dicabut."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Tab Semua" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Data Status" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "rowsStatus", "description": "Tab Semua hanya menampilkan cakupan statusnya", "status": "Semua"}
    And user mengklik tombol "Tab Menunggu" pada konteks "pusat" di layar "manajemen-device"
    And sistem memverifikasi elemen "Data Status" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "rowsStatus", "description": "Tab Menunggu hanya menampilkan cakupan statusnya", "status": "Menunggu"}
    And user mengklik tombol "Tab Aktif" pada konteks "pusat" di layar "manajemen-device"
    And sistem memverifikasi elemen "Data Status" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "rowsStatus", "description": "Tab Aktif hanya menampilkan cakupan statusnya", "status": "Aktif"}
    And user mengklik tombol "Tab Ditolak" pada konteks "pusat" di layar "manajemen-device"
    And sistem memverifikasi elemen "Data Status" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "rowsStatus", "description": "Tab Ditolak hanya menampilkan cakupan statusnya", "status": "Ditolak"}
    And user mengklik tombol "Tab Dicabut" pada konteks "pusat" di layar "manajemen-device"
    And sistem memverifikasi elemen "Data Status" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "rowsStatus", "description": "Tab Dicabut hanya menampilkan cakupan statusnya", "status": "Dicabut"}
    And sistem memverifikasi elemen "Jumlah Menunggu" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "text", "description": "Badge jumlah Menunggu = 2", "text": "2"}

  @negative @priority-medium @REQ-037 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-053 — Tab tanpa record tidak memakai baris tab sebelumnya
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Data hanya Menunggu; tidak ada device Ditolak."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Tab Menunggu" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Tab Ditolak" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Empty State" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "visible", "description": "Empty state muncul pada tab Ditolak"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "rows", "description": "Tidak ada baris Menunggu tertinggal", "requestIds": []}

  @positive @priority-high @REQ-038 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-049 — Perangkat kedua disetujui tanpa mencabut perangkat pertama
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Akun memiliki satu Aktif dan request A Menunggu."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Tepat dua perangkat Aktif, perangkat pertama tetap Aktif", "activeCount": 2, "oldStatus": "Aktif"}

  @negative @priority-high @REQ-038 @screen-batas-perangkat-aktif
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-054 — Perangkat ketiga tidak disetujui tanpa pilihan pencabutan
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Akun memiliki dua Aktif dan request A Menunggu."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Pilih Perangkat Dicabut" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Dialog Batas" pada konteks "pusat" di layar "batas-perangkat-aktif" memenuhi {"matcher": "visible", "description": "Dialog batas muncul"}
    And sistem memverifikasi elemen "Konfirmasi" pada konteks "pusat" di layar "batas-perangkat-aktif" memenuhi {"matcher": "disabled", "description": "Konfirmasi disabled sebelum memilih perangkat"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Tetap dua Aktif; request baru masih Menunggu", "activeCount": 2, "status": "Menunggu"}

  @positive @priority-low @REQ-039 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-050 — Toggle password menampilkan lalu menyembunyikan input tanpa mutasi
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "User belum login; input password tersedia."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Toggle Kata Sandi" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Kata Sandi" pada konteks "utama" di layar "login" memenuhi {"matcher": "inputType", "description": "Tipe input text dan nilai password tetap", "inputType": "text", "value": "fixture:validPassword"}
    And user mengklik tombol "Toggle Kata Sandi" pada konteks "utama" di layar "login"
    And sistem memverifikasi elemen "Kata Sandi" pada konteks "utama" di layar "login" memenuhi {"matcher": "inputType", "description": "Tipe kembali password tanpa mengganti nilai", "inputType": "password", "value": "fixture:validPassword"}

  @negative @priority-high @REQ-039 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-055 — Keluar dari verifikasi mengakhiri sesi dan menolak tombol Back
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen terautentikasi pada perangkat baru."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengklik tombol "Keluar" pada konteks "utama" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Login" pada konteks "utama" di layar "login" memenuhi {"matcher": "visible", "description": "Login tampil setelah Keluar"}
    And user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And sistem memverifikasi elemen "Kode Perangkat" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "hidden", "description": "Kode tidak tampil sesudah logout"}
    And user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}

  @edge @priority-high @REQ-008 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-001 — Browser sama pada perangkat fisik berbeda tetap dianggap baru
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Akun memiliki device A Chromium Aktif; utama device B Chromium."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Judul Verifikasi" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "visible", "description": "Device fisik B harus didaftarkan sendiri"}

  @edge @priority-high @REQ-008 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-002 — Incognito tidak menggunakan approval browser reguler
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Akun Aktif pada browser reguler; utama konteks incognito baru."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Judul Verifikasi" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "visible", "description": "Incognito memerlukan identitas dan request baru"}

  @edge @priority-high @REQ-008 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-003 — Hapus data browser menghasilkan verifikasi baru
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Fixture membersihkan storage/token browser A yang sebelumnya Aktif."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Judul Verifikasi" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "visible", "description": "Tanpa token lama device teridentifikasi baru"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Histori perangkat lama tetap tersimpan", "historicalRecordRetained": true}

  @edge @priority-high @REQ-015 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-004 — Dua tab mengirim bersamaan hanya membuat satu request
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Tab utama dan sesi-lain pada akun/device/browser sama belum terdaftar; fixture barrier submit."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "COM-ADM-001" pada konteks "utama" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "sesi-lain" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Kedua pengiriman bersamaan dipetakan ke satu request dan satu kode", "requestCount": 1, "uniqueCodeCount": 1}

  @edge @priority-high @REQ-015 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-005 — Respons submit hilang setelah commit lalu retry tetap satu request
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Pengiriman pertama commit tetapi respons timeout; retry dari konteks sama."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "COM-ADM-001" pada konteks "utama" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    And user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Retry mempertahankan request yang sudah commit", "requestCount": 1, "uniqueCodeCount": 1}

  @edge @priority-high @REQ-015 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-006 — Login ulang Ditolak dan Dicabut menjaga histori request lama
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Fixture menjalankan dua kasus status Ditolak/Dicabut pada request A yang sama per reset."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Login tidak membuat request baru atau mengganti kode histori", "requestCount": 1, "code": "7K4M-92QD"}

  @edge @priority-high @REQ-011 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-007 — Nama sama pada dua device tidak membuat kode sama
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Device A dan B mempunyai nama COM-ADM-001 pada akun sama."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "COM-ADM-001" pada konteks "utama" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    And user berada di halaman "verifikasi-perangkat" pada konteks "sesi-lain" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "COM-ADM-001" pada konteks "sesi-lain" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "sesi-lain" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Dua request memiliki kode unik walau nama sama", "requestCount": 2, "uniqueCodeCount": 2}

  @edge @priority-medium @REQ-012 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-008 — Nama Unicode dan tanda kutip tersimpan sebagai teks
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Perangkat baru; nama di bawah 30 karakter."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "电脑 \"Agen\" — Café" pada konteks "utama" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Nama Unicode dan tanda kutip tidak rusak", "deviceName": "电脑 \"Agen\" — Café"}

  @edge @priority-high @REQ-012 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-009 — Payload HTML dalam nama tidak dijalankan
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Perangkat baru; marker XSS diperiksa fixture, payload panjang 23."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "<img src=x onerror=x()>" pada konteks "utama" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Nama ditampilkan sebagai teks aman tanpa eksekusi script", "xssExecuted": false}
    And sistem memverifikasi elemen "Informasi Perangkat" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "noInjectedElement", "description": "Tidak ada elemen img dari nama input", "selector": "img[src=x]"}

  @edge @priority-medium @REQ-034 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-010 — Nama 0 1 29 dan 30 karakter memenuhi batas opsional
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Fixture mereset perangkat baru untuk setiap kasus panjang ASCII."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "fixture:deviceName" pada konteks "utama" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Nama tiap boundary tersimpan sesuai input", "deviceName": "fixture:deviceName"}

  @edge @priority-medium @REQ-033 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-011 — Kode panjang dan tanda nonalfanumerik dinormalisasi aman
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu; input mengandung tanda dan suffix berlebih."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "String Code" dengan "7k4m-92qd!!!suffix" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "String Code" pada konteks "pusat" di layar "registrasi-device" memenuhi {"matcher": "value", "description": "Field hasil normalisasi hanya 8 alfanumerik dengan strip", "value": "7K4M-92QD"}
    And sistem memverifikasi elemen "Hasil Lookup" pada konteks "pusat" di layar "registrasi-device" memenuhi {"matcher": "visible", "description": "Lookup tetap mengacu request A"}

  @edge @priority-high @REQ-033 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-012 — Lookup kode request Aktif tidak dapat memberi approval ulang
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Dialog dibuka untuk request Menunggu lain lalu diisi kode request A Aktif."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "String Code" dengan "7K4M-92QD" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Error Kode" pada konteks "pusat" di layar "registrasi-device" memenuhi {"matcher": "visible", "description": "Error kode sudah aktif/tidak berlaku untuk Aktif"}
    And sistem memverifikasi elemen "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device" memenuhi {"matcher": "disabled", "description": "Konfirmasi disabled"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Status request A tidak berubah", "status": "Aktif"}

  @edge @priority-high @REQ-033 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-013 — Lookup kode request Ditolak tidak dapat memberi approval ulang
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Dialog dibuka untuk request Menunggu lain lalu diisi kode request A Ditolak."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "String Code" dengan "7K4M-92QD" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Error Kode" pada konteks "pusat" di layar "registrasi-device" memenuhi {"matcher": "visible", "description": "Error kode sudah aktif/tidak berlaku untuk Ditolak"}
    And sistem memverifikasi elemen "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device" memenuhi {"matcher": "disabled", "description": "Konfirmasi disabled"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Status request A tidak berubah", "status": "Ditolak"}

  @edge @priority-high @REQ-033 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-014 — Lookup kode request Dicabut tidak dapat memberi approval ulang
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Dialog dibuka untuk request Menunggu lain lalu diisi kode request A Dicabut."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "String Code" dengan "7K4M-92QD" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Error Kode" pada konteks "pusat" di layar "registrasi-device" memenuhi {"matcher": "visible", "description": "Error kode sudah aktif/tidak berlaku untuk Dicabut"}
    And sistem memverifikasi elemen "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device" memenuhi {"matcher": "disabled", "description": "Konfirmasi disabled"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Status request A tidak berubah", "status": "Dicabut"}

  @edge @priority-high @REQ-026 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-015 — Setujui dan Tolak bersamaan hanya satu keputusan sah
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Dua pusat berizin membuka request A Menunggu; fixture barrier commit."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    And user berada di halaman "manajemen-device" pada konteks "sesi-lain" melalui "route:manajemen-device"
    And user mengklik tombol "Tolak" pada konteks "sesi-lain" di layar "manajemen-device"
    And user mengisi field "Alasan" dengan "Perangkat tidak dikenali" pada konteks "sesi-lain" di layar "tolak-permintaan"
    And user mengklik tombol "Konfirmasi" pada konteks "sesi-lain" di layar "tolak-permintaan"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Satu transisi menang; operasi terlambat ditolak tanpa menimpa keputusan", "finalStatusIn": ["Aktif", "Ditolak"], "successfulTransitions": 1, "decisionHistoryCount": 1}

  @edge @priority-high @REQ-025 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-016 — Dua pusat menyetujui request sama tidak menggandakan histori
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Dua pusat membuka request A Menunggu; approval paralel disinkronisasi."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    And user berada di halaman "manajemen-device" pada konteks "sesi-lain" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "sesi-lain" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "sesi-lain" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Aktif hanya mempunyai satu histori approval yang berhasil", "status": "Aktif", "successfulApprovals": 1}

  @edge @priority-high @REQ-009 @screen-dashboard
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-017 — Cabut saat fitur dimuat menolak operasi sesudah commit
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Aktif; respons fitur ditunda sampai pencabutan commit."
    When user mengklik tombol "Jual Tiket" pada konteks "utama" di layar "dashboard"
    And user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Cabut Perangkat" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Alasan" dengan "Perangkat lama diganti" pada konteks "pusat" di layar "cabut-perangkat"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "cabut-perangkat"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Operasi belum commit yang dievaluasi sesudah pencabutan ditolak", "serverAccess": "denied"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Status akhir Dicabut, tidak ada transaksi terlindungi sesudah revoke", "status": "Dicabut", "successfulWritesAfterRevoke": 0}

  @edge @priority-high @REQ-016 @screen-menunggu-persetujuan
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-018 — Pembaruan terlambat Menunggu tidak menimpa status Aktif terbaru
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Respons status Menunggu versi lama ditunda; approval baru sudah commit."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "serverInvariant", "description": "Respons lama tidak mengembalikan status Menunggu", "status": "Aktif", "ignoreOlderVersion": true}

  @edge @priority-high @REQ-016 @screen-perangkat-dicabut
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-019 — Reaktivasi saat layar Dicabut terbuka diperbarui otomatis
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Agen berada pada layar Dicabut; pusat siap reaktivasi."
    When user berada di halaman "perangkat-dicabut" pada konteks "utama" melalui "route:perangkat-dicabut"
    And user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Aktifkan Kembali" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "aktifkan-kembali"
    Then sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "perangkat-dicabut" memenuhi {"matcher": "serverInvariant", "description": "Status Aktif terbaru terdeteksi tanpa reload manual", "status": "Aktif"}

  @edge @priority-medium @REQ-023 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-020 — Timestamp lintas tengah malam dan zona mempertahankan instant
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Permintaan 23:59:59 WIB, approval setelah pergantian hari; fixture waktu server."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Data Waktu" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "timestamps", "description": "Tanggal/waktu benar meskipun pergantian hari dan zona tampilan", "requestedAt": "2026-10-07T16:59:59Z", "processedAt": "2026-10-07T17:00:01Z"}

  @edge @priority-high @REQ-024 @screen-aktifkan-kembali
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-021 — Reaktivasi petugas berbeda tidak menimpa aktor histori sebelumnya
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Approval/cabut dilakukan petugas 1; reaktivasi dilakukan petugas 2."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Aktifkan Kembali" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "aktifkan-kembali"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Pemroses terbaru petugas 2; event approval/cabut tetap petugas 1", "processor": "pusat-002", "historicalActorsPreserved": true}

  @edge @priority-medium @REQ-035 @screen-cabut-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-022 — Alasan satu karakter setelah trim diperbolehkan
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request Aktif; alasan mengandung spasi tepi dan satu huruf."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Cabut Perangkat" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Alasan" dengan " X " pada konteks "pusat" di layar "cabut-perangkat"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "cabut-perangkat"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Status Dicabut dan alasan tersimpan X", "status": "Dicabut", "reason": "X"}

  @edge @priority-medium @REQ-035 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-023 — Catatan approval tersimpan pada histori tanpa menjadi required
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Catatan" dengan "Dikonfirmasi via telepon" pada konteks "pusat" di layar "registrasi-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Catatan approval tersimpan sebagai teks", "note": "Dikonfirmasi via telepon"}

  @edge @priority-medium @REQ-035 @screen-aktifkan-kembali
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-024 — Catatan reaktivasi kosong maupun terisi tidak mengubah identitas
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Fixture mereset Dicabut untuk kasus catatan kosong/terisi."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Aktifkan Kembali" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Catatan" dengan "fixture:note" pada konteks "pusat" di layar "aktifkan-kembali"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "aktifkan-kembali"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Status Aktif, catatan sesuai input dan kode tetap", "status": "Aktif", "note": "fixture:note", "code": "7K4M-92QD"}

  @edge @priority-medium @REQ-036 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-025 — Reset mengosongkan semua filter dan memulihkan tab saat ini
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Seluruh filter terisi, tab Aktif dipilih."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Filter" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Reset" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "filterReset", "description": "Filter kembali default dan daftar mengikuti tab Aktif", "allFieldsDefault": true, "tab": "Aktif"}

  @edge @priority-medium @REQ-036 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-026 — Filter status berpindah ke Semua dan tidak terpotong tab lama
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Tab Menunggu aktif; data Aktif tersedia."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Tab Menunggu" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Filter" pada konteks "pusat" di layar "manajemen-device"
    And user memilih opsi "AKTIF" pada dropdown "Status" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Data Status" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "rowsStatus", "description": "Tab Semua aktif dengan hasil hanya Aktif", "status": "Aktif", "selectedTab": "Semua"}

  @edge @priority-medium @REQ-036 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-027 — Filter Jenis Akun Sub Agen hanya memuat Sub Agen
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Daftar berisi Agen dan Sub Agen."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Tab Semua" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Filter" pada konteks "pusat" di layar "manajemen-device"
    And user memilih opsi "Sub Agen" pada dropdown "Jenis Akun" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Data Akun" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "rowsAccountType", "description": "Hasil hanya Sub Agen tanpa Agen induk sebagai pemilik", "type": "Sub Agen"}

  @edge @priority-medium @REQ-037 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-028 — Ukuran 10 20 50 dan halaman berikutnya tidak melewatkan histori
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Fixture menyediakan 51 request dengan ID unik; pagination implementasi nyata terhubung."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Tab Semua" pada konteks "pusat" di layar "manajemen-device"
    And user memilih opsi "10" pada dropdown "Ukuran Halaman" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "rowCount", "description": "Halaman pertama berisi 10 request", "count": 10}
    And user mengklik tombol "Halaman Berikutnya" pada konteks "pusat" di layar "manajemen-device"
    And sistem memverifikasi elemen "Pagination" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "pagination", "description": "Halaman kedua tanpa duplikat halaman pertama", "page": 2, "disjointFromPage": 1}
    And user memilih opsi "20" pada dropdown "Ukuran Halaman" pada konteks "pusat" di layar "manajemen-device"
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "rowCount", "description": "Ukuran halaman 20 berlaku", "max": 20}
    And user memilih opsi "50" pada dropdown "Ukuran Halaman" pada konteks "pusat" di layar "manajemen-device"
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "rowCount", "description": "Ukuran halaman 50 berlaku", "max": 50}

  @edge @priority-high @REQ-038 @screen-batas-perangkat-aktif
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-029 — Penggantian saat dua Aktif mencabut hanya radio terpilih
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Akun mempunyai dua Aktif dan request A Menunggu."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Pilih Perangkat Dicabut" pada konteks "pusat" di layar "registrasi-device"
    And user memilih kontrol "Perangkat Lama" pada konteks "pusat" di layar "batas-perangkat-aktif"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "batas-perangkat-aktif"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Satu perangkat lama Dicabut, yang lain tetap Aktif, baru Aktif", "activeCount": 2, "revokedDevice": "device-old-1", "untouchedDevice": "device-old-2", "status": "Aktif"}

  @edge @priority-high @REQ-038 @screen-aktifkan-kembali
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-030 — Reaktivasi saat dua perangkat Aktif ditahan sampai slot tersedia
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Dicabut; dua perangkat lain Aktif."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Aktifkan Kembali" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Peringatan Batas" pada konteks "pusat" di layar "aktifkan-kembali" memenuhi {"matcher": "visible", "description": "Peringatan batas dua perangkat tampil"}
    And sistem memverifikasi elemen "Konfirmasi" pada konteks "pusat" di layar "aktifkan-kembali" memenuhi {"matcher": "disabled", "description": "Konfirmasi disabled pada kapasitas penuh"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Request tetap Dicabut dan dua Aktif tidak berubah", "status": "Dicabut", "activeCount": 2}
    And sistem memverifikasi elemen "Dialog Reaktivasi" pada konteks "pusat" di layar "aktifkan-kembali" memenuhi {"matcher": "visible", "description": "Dialog reaktivasi terbuka dengan informasi perangkat"}

  @edge @priority-high @REQ-038 @screen-batas-perangkat-aktif
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-031 — Batal penggantian tidak mencabut atau mendaftarkan perangkat
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Dua Aktif dan request A Menunggu."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Pilih Perangkat Dicabut" pada konteks "pusat" di layar "registrasi-device"
    And user memilih kontrol "Perangkat Lama" pada konteks "pusat" di layar "batas-perangkat-aktif"
    And user mengklik tombol "Batal" pada konteks "pusat" di layar "batas-perangkat-aktif"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Batal tidak menimbulkan mutasi status/histori", "activeCount": 2, "status": "Menunggu", "historyChanges": 0}

  @edge @priority-medium @REQ-039 @screen-menunggu-persetujuan
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-032 — Periksa Status Menunggu tidak membuka Dashboard
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A masih Menunggu di server."
    When user berada di halaman "menunggu-persetujuan" pada konteks "utama" melalui "route:menunggu-persetujuan"
    And user mengklik tombol "Periksa Status" pada konteks "utama" di layar "menunggu-persetujuan"
    Then sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "visible", "description": "Status tetap Menunggu"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Konten terlindungi tidak ditampilkan", "serverAccess": "denied"}
    And sistem memverifikasi elemen "Bantuan" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "visible", "description": "Teks bantuan tersedia tanpa menganggap nomor placeholder valid"}

  @edge @priority-medium @REQ-039 @screen-menunggu-persetujuan
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-033 — Masuk ke Dashboard setelah approval memeriksa status server
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request baru saja Aktif dan tombol Masuk ke Dashboard tersedia."
    When user berada di halaman "menunggu-persetujuan" pada konteks "utama" melalui "route:menunggu-persetujuan"
    And user mengklik tombol "Masuk ke Dashboard" pada konteks "utama" di layar "menunggu-persetujuan"
    Then sistem memverifikasi elemen "Dashboard" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "visible", "description": "Dashboard tampil bila server masih Aktif"}

  @edge @priority-high @REQ-039 @screen-menunggu-persetujuan
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-034 — Tombol Dashboard yang basi tidak melewati pencabutan baru
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Client menampilkan tombol Dashboard dari status Aktif; pusat mencabut sebelum klik."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Cabut Perangkat" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Alasan" dengan "Perangkat lama diganti" pada konteks "pusat" di layar "cabut-perangkat"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "cabut-perangkat"
    And user mengklik tombol "Masuk ke Dashboard" pada konteks "utama" di layar "menunggu-persetujuan"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Klik tombol lama wajib memeriksa server terbaru", "serverAccess": "denied"}

  @edge @priority-medium @REQ-039 @screen-perangkat-dicabut
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-035 — Periksa Status Dicabut tidak meregistrasi ulang
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Dicabut."
    When user berada di halaman "perangkat-dicabut" pada konteks "utama" melalui "route:perangkat-dicabut"
    And user mengklik tombol "Periksa Status" pada konteks "utama" di layar "perangkat-dicabut"
    Then sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "perangkat-dicabut" memenuhi {"matcher": "visible", "description": "Status tetap Dicabut"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Tidak ada request atau kode baru akibat pengecekan", "requestCount": 1, "code": "7K4M-92QD"}

  @edge @priority-medium @REQ-039 @screen-menunggu-persetujuan
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-036 — Kirim Ulang Kode hanya mengulang notifikasi request Menunggu
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu; kode yang tersimpan 7K4M-92QD."
    When user berada di halaman "menunggu-persetujuan" pada konteks "utama" melalui "route:menunggu-persetujuan"
    And user mengklik tombol "Kirim Ulang Kode" pada konteks "utama" di layar "menunggu-persetujuan"
    Then sistem memverifikasi elemen "Kode Permintaan" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "text", "description": "Kode tetap 7K4M-92QD", "text": "7K4M-92QD"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Request tetap satu dan status tetap Menunggu", "requestCount": 1, "status": "Menunggu"}

  @edge @priority-medium @REQ-039 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-037 — Batal dialog registrasi-device menjaga status dan histori
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu; dialog dibuka tanpa konfirmasi."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Batal" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Batal menutup dialog tanpa perubahan status atau histori", "status": "Menunggu", "historyChanges": 0}

  @edge @priority-medium @REQ-039 @screen-tolak-permintaan
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-038 — Batal dialog tolak-permintaan menjaga status dan histori
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu; dialog dibuka tanpa konfirmasi."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Tolak" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Batal" pada konteks "pusat" di layar "tolak-permintaan"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Batal menutup dialog tanpa perubahan status atau histori", "status": "Menunggu", "historyChanges": 0}

  @edge @priority-medium @REQ-039 @screen-cabut-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-039 — Batal dialog cabut-perangkat menjaga status dan histori
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Aktif; dialog dibuka tanpa konfirmasi."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Cabut Perangkat" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Batal" pada konteks "pusat" di layar "cabut-perangkat"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Batal menutup dialog tanpa perubahan status atau histori", "status": "Aktif", "historyChanges": 0}

  @edge @priority-medium @REQ-039 @screen-aktifkan-kembali
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-040 — Batal dialog aktifkan-kembali menjaga status dan histori
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Dicabut; dialog dibuka tanpa konfirmasi."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Aktifkan Kembali" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Batal" pada konteks "pusat" di layar "aktifkan-kembali"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Batal menutup dialog tanpa perubahan status atau histori", "status": "Dicabut", "historyChanges": 0}

  @edge @priority-high @REQ-027 @screen-cabut-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-041 — Cabut berulang dari dua pusat tidak menggandakan histori
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Aktif; dua pusat menekan cabut secara paralel."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Cabut Perangkat" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Alasan" dengan "Perangkat lama diganti" pada konteks "pusat" di layar "cabut-perangkat"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "cabut-perangkat"
    And user berada di halaman "manajemen-device" pada konteks "sesi-lain" melalui "route:manajemen-device"
    And user mengklik tombol "Cabut Perangkat" pada konteks "sesi-lain" di layar "manajemen-device"
    And user mengisi field "Alasan" dengan "Perangkat lama diganti" pada konteks "sesi-lain" di layar "cabut-perangkat"
    And user mengklik tombol "Konfirmasi" pada konteks "sesi-lain" di layar "cabut-perangkat"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Status Dicabut dengan tepat satu transisi pencabutan", "status": "Dicabut", "revocationEvents": 1}

  @edge @priority-high @REQ-030 @screen-detail-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-042 — Aktifkan Kembali dari detail menggunakan request yang sama
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Dicabut; kurang dari dua Aktif."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Lihat Detail" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Aktifkan Kembali" pada konteks "pusat" di layar "detail-perangkat"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "aktifkan-kembali"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Request A menjadi Aktif tanpa kode baru", "status": "Aktif", "requestId": "request-A", "code": "7K4M-92QD"}

  @stress @priority-high @REQ-002 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-001 — 200 login invalid paralel tidak memanggil device check
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "200 konteks Agen memakai credential invalid; fixture mengulangi rangkaian login."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "salah123" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Login" pada konteks "utama" di layar "login" memenuhi {"matcher": "serverInvariant", "description": "Semua sesi invalid tetap tanpa akses", "authenticatedSessions": 0, "deviceChecks": 0}

  @stress @priority-high @REQ-003 @screen-login
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-002 — 200 login Aktif paralel menjaga isolasi akun dan perangkat
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "200 akun Agen/Sub Agen dengan perangkat Aktif masing-masing."
    When user berada di halaman "login" pada konteks "utama" melalui "route:login"
    And user mengisi field "Email" dengan "agen01@example.test" pada konteks "utama" di layar "login"
    And user mengisi field "Kata Sandi" dengan "fixture:validPassword" pada konteks "utama" di layar "login"
    And user mengklik tombol "Login" pada konteks "utama" di layar "login"
    Then sistem memverifikasi elemen "Dashboard" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "visible", "description": "Sesi valid masuk ke akun masing-masing"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Tidak ada silang identitas atau akses dari device nonaktif", "crossAccountSessions": 0, "unauthorizedAccesses": 0}

  @stress @priority-high @REQ-011 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-003 — 100 registrasi perangkat berbeda menghasilkan kode unik
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "100 identitas device/browser baru telah autentikasi."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "COM-ADM-001" pada konteks "utama" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Seluruh request berhasil memiliki kode unik atau gagal aman tanpa collision", "uniqueCodesEqualSuccessfulRequests": true}

  @stress @priority-high @REQ-015 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-004 — 100 pengiriman identitas sama tetap satu request
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "100 tab satu akun/device/browser; barrier submit bersamaan."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "COM-ADM-001" pada konteks "utama" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "100 submit tidak menggandakan request", "requestCount": 1, "uniqueCodeCount": 1}

  @stress @priority-high @REQ-009 @screen-dashboard
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-005 — Cabut 100 sesi aktif menolak semua operasi berikutnya
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "100 sesi sah dari pasangan perangkat A; pusat melakukan satu pencabutan."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Cabut Perangkat" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Alasan" dengan "Perangkat lama diganti" pada konteks "pusat" di layar "cabut-perangkat"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "cabut-perangkat"
    And user mengklik tombol "Jual Tiket" pada konteks "utama" di layar "dashboard"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Seluruh 100 sesi menolak request terlindungi setelah revoke", "serverAccess": "denied"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Tidak ada write sesudah pencabutan commit", "successfulWritesAfterRevoke": 0}

  @stress @priority-high @REQ-016 @screen-menunggu-persetujuan
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-006 — 200 halaman Menunggu mengikuti perubahan status massal
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "200 request Menunggu, masing-masing 100 Agen/Sub Agen; pusat memproses approval."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Status Perangkat" pada konteks "utama" di layar "menunggu-persetujuan" memenuhi {"matcher": "serverInvariant", "description": "Setiap client mengikuti status request sendiri tanpa silang data", "statusMatchesOwnServerRequest": true}

  @stress @priority-high @REQ-018 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-007 — 10000 histori tetap dapat ditelusuri tanpa kehilangan data
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "10000 record histori tersebar 1000 akun; pusat memilih satu request."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Lihat Detail" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Riwayat" pada konteks "pusat" di layar "detail-perangkat" memenuhi {"matcher": "serverInvariant", "description": "Detail tidak mencampur atau menghilangkan histori request terpilih", "historyComplete": true}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Jumlah record tersimpan tetap 10000", "storedRecordCount": 10000}

  @stress @priority-high @REQ-036 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-008 — 100 perubahan filter paralel menjaga hasil setiap pusat
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "100 sesi pusat memilih filter berbeda di daftar 10000 request."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Filter" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Nama Agen / Sub Agen" dengan "fixture:filterAccount" pada konteks "pusat" di layar "manajemen-device"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Hasil setiap sesi sesuai filter terakhirnya tanpa bocor ke sesi lain", "matchesOwnFilter": true}

  @stress @priority-high @REQ-038 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-009 — Approval paralel tidak melampaui batas dua Aktif
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Akun punya satu Aktif dan 20 Menunggu pada device berbeda; pusat approve bersamaan."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Tidak pernah lebih dari dua Aktif tanpa pencabutan sah", "maxActiveCount": 2, "atomicLimitEnforcement": true}

  @stress @priority-high @REQ-030 @screen-aktifkan-kembali
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-010 — 20 reaktivasi paralel menjaga jumlah Aktif dan histori
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Satu akun mempunyai 20 Dicabut dan satu Aktif; pusat reaktivasi bersamaan."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Aktifkan Kembali" pada konteks "pusat" di layar "manajemen-device"
    And user mengklik tombol "Konfirmasi" pada konteks "pusat" di layar "aktifkan-kembali"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Reaktivasi memeriksa kapasitas terbaru dan tidak memberi approval ganda", "maxActiveCount": 2, "duplicateReactivationEvents": 0}

  @stress @priority-high @REQ-035 @screen-registrasi-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-011 — Catatan 100000 karakter gagal aman atau tersimpan utuh
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Request A Menunggu; fixture membuat teks catatan panjang tanpa aturan max resmi."
    When user berada di halaman "manajemen-device" pada konteks "pusat" melalui "route:manajemen-device"
    And user mengklik tombol "Setujui" pada konteks "pusat" di layar "manajemen-device"
    And user mengisi field "Catatan" dengan "fixture:longNote" pada konteks "pusat" di layar "registrasi-device"
    And user mengklik tombol "Daftarkan Perangkat" pada konteks "pusat" di layar "registrasi-device"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Input panjang memberi validasi eksplisit atau commit utuh, tanpa status/audit parsial", "allowedOutcomes": ["explicitValidationNoMutation", "completeApprovalAndNote"], "partialCommit": false}

  @stress @priority-high @REQ-034 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-012 — Paste nama 100000 karakter tidak melewati batas UI
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "Perangkat baru; fixture menyediakan payload nama panjang."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "fixture:longDeviceName" pada konteks "utama" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Nama Perangkat" pada konteks "utama" di layar "verifikasi-perangkat" memenuhi {"matcher": "valueLength", "description": "Input tetap membatasi 30 karakter", "max": 30}
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Nama tersimpan maksimal 30 dan UI tetap terkendali", "maxDeviceNameLength": 30}

  @stress @priority-high @REQ-013 @screen-verifikasi-perangkat
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-013 — Timeout dan retry massal tidak menggandakan request
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "100 device berbeda mengirim; respons pertama hilang setelah commit lalu fixture retry."
    When user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengisi field "Nama Perangkat" dengan "COM-ADM-001" pada konteks "utama" di layar "verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    And user berada di halaman "verifikasi-perangkat" pada konteks "utama" melalui "route:verifikasi-perangkat"
    And user mengklik tombol "Kirim" pada konteks "utama" di layar "verifikasi-perangkat"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Setiap identitas memiliki satu request walau respons timeout", "maxRequestsPerIdentity": 1, "uniqueCodesEqualSuccessfulRequests": true}

  @stress @priority-high @REQ-032 @screen-manajemen-device
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-014 — 100 operasi induk tanpa izin tidak mengubah device Sub Agen
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "100 sesi Agen induk mencoba empat operasi terhadap Sub Agen melalui endpoint existing fixture."
    When user berada di halaman "manajemen-device" pada konteks "utama" melalui "route:manajemen-device"
    Then sistem memverifikasi elemen "Tabel Device" pada konteks "utama" di layar "manajemen-device" memenuhi {"matcher": "hidden", "description": "Daftar tidak dibuka kepada induk"}
    And sistem memverifikasi elemen "Tabel Device" pada konteks "pusat" di layar "manajemen-device" memenuhi {"matcher": "serverInvariant", "description": "Semua operasi tanpa izin ditolak tanpa perubahan status/histori", "unauthorizedSuccesses": 0, "historyChanges": 0}

  @stress @priority-high @REQ-009 @screen-dashboard
  Scenario: RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-015 — Layanan status gagal tidak memberi akses berdasarkan cache Aktif
    Given kondisi uji "Fixture di-reset per scenario; route dan selector dipetakan ke aplikasi RORO uji; kredensial valid berasal dari fixture."
    And kondisi uji "100 sesi memiliki cache Aktif; server status tidak tersedia pada pemeriksaan akses."
    When user berada di halaman "dashboard" pada konteks "utama" melalui "route:dashboard"
    Then sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "hidden", "description": "Status gagal dibaca tidak menyebabkan fail-open", "serverAccess": "denied"}
    And sistem memverifikasi elemen "Halaman Terlindungi" pada konteks "utama" di layar "dashboard" memenuhi {"matcher": "serverInvariant", "description": "Server tidak mengizinkan akses dari cache ketika status tak dapat diverifikasi", "unauthorizedAccesses": 0}

