# language: en
Feature: ro316-penyesuaian-setting-komisi-agen
  Pengaturan komisi general per rute oleh Kantor Pusat dengan akses Cabang read-only.

  @positive @priority-high @REQ-001 @screen-master-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-001
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-001 — Pusat membuka menu Master Komisi Agen
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "User login Kantor Pusat." terpenuhi
    And user berada di halaman "master-komisi-agen"
    When user mengklik tombol "Master"
    And user mengklik tautan "Master Komisi Agen"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "visible"

  @positive @priority-high @REQ-001 @screen-master-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-002
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-002 — Cabang membuka menu dan detail rute
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "User login Kantor Cabang; konfigurasi 5% tersedia." terpenuhi
    And user berada di halaman "master-komisi-agen"
    When user mengklik tombol "Master"
    And user mengklik tautan "Master Komisi Agen"
    And user mengklik tombol "Lihat komisi rute"
    Then sistem memverifikasi elemen "Komisi Rute" dengan hasil "visible"
    And sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: kombinasi fixture 5,00%"

  @negative @priority-high @REQ-001 @screen-master-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-001
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-001 — Tanpa sesi tidak dapat membuka master komisi
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "User belum login; cookie dan token sesi kosong." terpenuhi
    And user berada di halaman "master-komisi-agen"
    Then sistem memverifikasi elemen "Akses Master Komisi Agen" dengan hasil "ditolak; data konfigurasi tidak terlihat; login diminta"

  @positive @priority-high @REQ-002 @screen-master-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-003
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-003 — Semua rute sistem tampil termasuk arah balik dan tanpa setting
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; master berisi 8 rute sesuai contoh HTML; filter Semua." terpenuhi
    And user berada di halaman "master-komisi-agen"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "set-equals: seluruh 8 rute master; termasuk Balikpapan → Mamuju tanpa tergantung aktif trayek"

  @negative @priority-high @REQ-002 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-002
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-002 — Rute tidak terdaftar tidak dapat dibuka sebagai setting komisi
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; alias detail menunjuk ID rute tidak dikenal." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    Then sistem memverifikasi elemen "Akses Detail Rute" dengan hasil "not-found; tidak ada form aktif atau record baru"

  @positive @priority-high @REQ-003 @screen-master-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-004
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-004 — Tiga status rute sesuai konfigurasi dan aktivasi komisi
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Fixture rute R1 belum punya konfigurasi; R2 aktif berisi 5%; R3 nonaktif berisi 3,50%." terpenuhi
    And user berada di halaman "master-komisi-agen"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "R1=Belum Disetting; R2=Aktif; R3=Tidak Aktif; jumlah komisi sesuai fixture"

  @negative @priority-high @REQ-003 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003 — Simpan gagal tidak mengubah rute Belum Disetting menjadi Aktif
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; rute belum disetting; intercept save mengembalikan 500." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "5,00"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Status Rute" dengan hasil "Belum Disetting"
    And sistem memverifikasi elemen "Daftar Komisi" dengan hasil "count=0"
    And sistem memverifikasi elemen "Feedback" dengan hasil "error; sukses tidak ditampilkan"

  @positive @priority-high @REQ-004 @screen-transaksi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005 — Dua agen dari cabang berbeda memakai konfigurasi general yang sama
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Agen A; Agen A/B boleh menjual kombinasi fixture; master aktif 5%; transaksi B disiapkan harness setelah commit." terpenuhi
    And user berada di halaman "transaksi-agen"
    When user memilih opsi "Balikpapan → Parepare" pada field "Rute"
    And user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengklik tombol "Buat Transaksi"
    Then sistem memverifikasi elemen "Komisi Agen" dengan hasil "A=50000; B=50000; kedua snapshot persentase=5,00%"

  @negative @priority-high @REQ-004 @screen-transaksi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-004
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-004 — Agen tidak dapat menjual rute di luar haknya untuk memperoleh komisi
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Agen C; agen C tidak berhak menjual rute fixture; harness mencoba payload rute tersebut." terpenuhi
    And user berada di halaman "transaksi-agen"
    Then sistem memverifikasi elemen "Rute" dengan hasil "opsi rute fixture tidak tersedia"
    And sistem memverifikasi elemen "Hasil Probe Hak Jual" dengan hasil "transaksi ditolak; transaksi dan komisi tidak terbentuk"

  @positive @priority-high @REQ-005 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-006
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-006 — Pusat menambah kombinasi kendaraan lengkap
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi kendaraan car/Kosong belum tersedia; modal dibuka dari detail rute." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Kendaraan" pada field "Jenis Tiket"
    And user memilih opsi "Gol. III-A (Sedan, Jeep, Pick-up)" pada field "Golongan Tiket"
    And user memilih opsi "Kosong" pada field "Kelas / Kondisi Kendaraan"
    And user mengisi field "% Komisi" dengan "3,50"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: Kendaraan; Gol. III-A (Sedan, Jeep, Pick-up); Kosong; 3,50%"
    And sistem memverifikasi elemen "Feedback" dengan hasil "Komisi ditambahkan. Berlaku untuk transaksi baru."

  @negative @priority-high @REQ-005 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-005
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-005 — Form tanpa field wajib tidak dapat disimpan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; modal tambah kosong." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    Then sistem memverifikasi elemen "Rute" dengan hasil "equals: Balikpapan → Parepare"
    And sistem memverifikasi elemen "Simpan Komisi" dengan hasil "disabled"
    And sistem memverifikasi elemen "Daftar Komisi" dengan hasil "unchanged"

  @negative @priority-high @REQ-005 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-006
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-006 — Cabang ditolak server ketika mencoba Tambah Komisi
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "User login Kantor Cabang; harness telah mencoba mutasi langsung memakai sesi Cabang sebelum verifikasi UI." terpenuhi
    And prasyarat "Fixture sebelum/sesudah tersedia pada panel hasil harness." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    Then sistem memverifikasi elemen "Hasil Probe Otorisasi" dengan hasil "status=403; operasi Tambah Komisi ditolak; konfigurasi, status dan snapshot transaksi tidak berubah"

  @positive @priority-high @REQ-006 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-007
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-007 — Jenis tiket menggunakan opsi master sistem
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; master jenis memuat Penumpang dan Kendaraan." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    Then sistem memverifikasi elemen "Jenis Tiket" dengan hasil "options-equal: Pilih Jenis Tiket, Penumpang, Kendaraan"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    Then sistem memverifikasi elemen "Golongan Tiket" dengan hasil "options-equal: Pilih Golongan Tiket, Ekonomi Lesehan Dewasa, Ekonomi Lesehan Anak"

  @negative @priority-high @REQ-006 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-007
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-007 — Jenis tiket di luar master ditolak
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; harness submit payload jenis tidak terdaftar; form tidak menyediakan opsi tersebut." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    Then sistem memverifikasi elemen "Jenis Tiket" dengan hasil "excludes-option: Jenis Tidak Dikenal"
    And sistem memverifikasi elemen "Hasil Probe Validasi" dengan hasil "invalid jenis tiket; konfigurasi baru tidak tersimpan"

  @positive @priority-high @REQ-007 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-008
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-008 — Ganti jenis mereset golongan dan kondisi sebelumnya
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; form sebelumnya Kendaraan car/Kosong." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    Then sistem memverifikasi elemen "Golongan Tiket" dengan hasil "value=empty; opsi hanya golongan Penumpang"
    And sistem memverifikasi elemen "Kelas / Kondisi Kendaraan" dengan hasil "disabled-or-absent; nilai kondisi=null"
    And sistem memverifikasi elemen "Simpan Komisi" dengan hasil "disabled"

  @negative @priority-high @REQ-007 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-008
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-008 — Golongan kendaraan pada jenis Penumpang ditolak
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; harness mengirim kombinasi Penumpang dengan golongan car." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    Then sistem memverifikasi elemen "Golongan Tiket" dengan hasil "excludes-option: Gol. III-A (Sedan, Jeep, Pick-up)"
    And sistem memverifikasi elemen "Hasil Probe Validasi" dengan hasil "jenis/golongan tidak sesuai; tidak tersimpan"

  @negative @priority-high @REQ-007 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-009
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-009 — Jenis terisi namun Golongan kosong tidak dapat disimpan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; konfigurasi target belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user mengisi field "% Komisi" dengan "5,00"
    Then sistem memverifikasi elemen "Simpan Komisi" dengan hasil "disabled"

  @positive @priority-high @REQ-008 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-009
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-009 — Penumpang menyimpan kondisi null tanpa dropdown kendaraan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi Penumpang belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "5,00"
    Then sistem memverifikasi elemen "Kelas / Kondisi Kendaraan" dengan hasil "disabled-or-absent; — (khusus Kendaraan)"
    When user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: Penumpang; Ekonomi Lesehan Dewasa; kelas=—; 5,00%"

  @negative @priority-high @REQ-008 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-010
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-010 — Kendaraan tanpa kondisi tidak dapat disimpan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Kendaraan" pada field "Jenis Tiket"
    And user memilih opsi "Gol. III-A (Sedan, Jeep, Pick-up)" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "3,50"
    Then sistem memverifikasi elemen "Simpan Komisi" dengan hasil "disabled"

  @negative @priority-high @REQ-008 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-011
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-011 — Kondisi di luar master jenis tiket ditolak server
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; probe kendaraan dengan kondisi Tidak Dikenal disiapkan harness." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    Then sistem memverifikasi elemen "Kelas / Kondisi Kendaraan" dengan hasil "excludes-option: Tidak Dikenal"
    And sistem memverifikasi elemen "Hasil Probe Validasi" dengan hasil "invalid kondisi; tidak tersimpan"

  @positive @priority-high @REQ-009 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-010
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-010 — Persentase desimal valid tampil dalam format dua angka desimal
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "7,50"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: 7,50%"

  @negative @priority-high @REQ-009 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-012
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-012 — Persentase kosong tidak dapat disimpan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; seluruh field kombinasi valid dan belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan ""
    Then sistem memverifikasi elemen "Simpan Komisi" dengan hasil "disabled"
    And sistem memverifikasi elemen "Validasi Persentase" dengan hasil "wajib diisi"

  @negative @priority-high @REQ-009 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-013
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-013 — Persentase negatif tidak dapat disimpan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; seluruh field kombinasi valid dan belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "-0,01"
    Then sistem memverifikasi elemen "Simpan Komisi" dengan hasil "disabled"
    And sistem memverifikasi elemen "Validasi Persentase" dengan hasil "Format tidak valid. Gunakan angka dengan maksimal 2 desimal, contoh 3,50."

  @negative @priority-high @REQ-009 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-014
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-014 — Persentase huruf tidak dapat disimpan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; seluruh field kombinasi valid dan belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "abc"
    Then sistem memverifikasi elemen "Simpan Komisi" dengan hasil "disabled"
    And sistem memverifikasi elemen "Validasi Persentase" dengan hasil "Format tidak valid. Gunakan angka dengan maksimal 2 desimal, contoh 3,50."

  @negative @priority-high @REQ-009 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-015
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-015 — Persentase notasi ilmiah tidak dapat disimpan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; seluruh field kombinasi valid dan belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "1e2"
    Then sistem memverifikasi elemen "Simpan Komisi" dengan hasil "disabled"
    And sistem memverifikasi elemen "Validasi Persentase" dengan hasil "Format tidak valid. Gunakan angka dengan maksimal 2 desimal, contoh 3,50."

  @negative @priority-high @REQ-009 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-016
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-016 — Persentase simbol persen tidak dapat disimpan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; seluruh field kombinasi valid dan belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "5%"
    Then sistem memverifikasi elemen "Simpan Komisi" dengan hasil "disabled"
    And sistem memverifikasi elemen "Validasi Persentase" dengan hasil "Format tidak valid. Gunakan angka dengan maksimal 2 desimal, contoh 3,50."

  @negative @priority-high @REQ-009 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-017
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-017 — Persentase tiga desimal tidak dapat disimpan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; seluruh field kombinasi valid dan belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "3,501"
    Then sistem memverifikasi elemen "Simpan Komisi" dengan hasil "disabled"
    And sistem memverifikasi elemen "Validasi Persentase" dengan hasil "Format tidak valid. Gunakan angka dengan maksimal 2 desimal, contoh 3,50."

  @negative @priority-high @REQ-009 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-018
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-018 — Persentase separator campuran tidak dapat disimpan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; seluruh field kombinasi valid dan belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "3,5.0"
    Then sistem memverifikasi elemen "Simpan Komisi" dengan hasil "disabled"
    And sistem memverifikasi elemen "Validasi Persentase" dengan hasil "Format tidak valid. Gunakan angka dengan maksimal 2 desimal, contoh 3,50."

  @negative @priority-high @REQ-009 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-019
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-019 — Persentase NaN tidak dapat disimpan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; seluruh field kombinasi valid dan belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "NaN"
    Then sistem memverifikasi elemen "Simpan Komisi" dengan hasil "disabled"
    And sistem memverifikasi elemen "Validasi Persentase" dengan hasil "Format tidak valid. Gunakan angka dengan maksimal 2 desimal, contoh 3,50."

  @positive @priority-high @REQ-010 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-011
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-011 — Batas maksimum 100% dapat disimpan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "100,00"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: 100,00%"

  @negative @priority-high @REQ-010 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-020
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-020 — Persentase 100,01% ditolak
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "100,01"
    Then sistem memverifikasi elemen "Simpan Komisi" dengan hasil "disabled"
    And sistem memverifikasi elemen "Validasi Persentase" dengan hasil "Nilai maksimal 100,00%."

  @positive @priority-high @REQ-011 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-012
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-012 — Tautan duplikat membuka edit record existing
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi fixture sudah tersimpan 5%; modal tambah menggunakan kombinasi sama." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "7,50"
    Then sistem memverifikasi elemen "Peringatan Duplikat" dengan hasil "Kombinasi ini sudah memiliki komisi 5,00%"
    When user mengklik tautan "Edit baris yang ada"
    Then sistem memverifikasi elemen "Edit Komisi Agen" dengan hasil "visible"
    And sistem memverifikasi elemen "% Komisi" dengan hasil "value=5,00"

  @negative @priority-high @REQ-011 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-021
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-021 — Tambah kombinasi sama dengan persentase berbeda ditolak
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi fixture sudah memiliki satu record 5%." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "7,50"
    Then sistem memverifikasi elemen "Simpan Komisi" dengan hasil "disabled"
    And sistem memverifikasi elemen "Jumlah Record Kombinasi" dengan hasil "equals: 1"

  @positive @priority-high @REQ-012 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-013
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-013 — Konfigurasi baru berlaku pada transaksi semua agen yang sesuai
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; belum ada setting; T0 sebelum tambah komisi=0; harness menyiapkan penjualan A/B sesudah save." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "5,00"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Hasil Transaksi Fixture" dengan hasil "T0=0; T1 agen A=50000; T2 agen B=50000; snapshot baru 5%"

  @negative @priority-high @REQ-012 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-022
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-022 — Simpan batal tidak berlaku pada transaksi baru
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; belum ada setting; penjualan sesudah Batal dijalankan harness." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "5,00"
    And user mengklik tombol "Batal"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "count=0"
    And sistem memverifikasi elemen "Hasil Transaksi Fixture" dengan hasil "transaksi baru komisi=0; konfigurasi batal tidak dipakai"

  @positive @priority-high @REQ-013 @screen-edit-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-014
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-014 — Pusat mengedit persentase existing
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; record existing 5% dimuat dari tombol Edit komisi." terpenuhi
    And user berada di halaman "edit-komisi-agen"
    When user mengisi field "% Komisi" dengan "7,50"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: kombinasi sama; 7,50%; jumlah record tetap 1"
    And sistem memverifikasi elemen "Feedback" dengan hasil "Komisi diperbarui. Berlaku untuk transaksi baru."

  @negative @priority-high @REQ-013 @screen-edit-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-023
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-023 — Cabang ditolak server ketika mencoba Edit Komisi
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "User login Kantor Cabang; harness telah mencoba mutasi langsung memakai sesi Cabang sebelum verifikasi UI." terpenuhi
    And prasyarat "Fixture sebelum/sesudah tersedia pada panel hasil harness." terpenuhi
    And user berada di halaman "edit-komisi-agen"
    Then sistem memverifikasi elemen "Hasil Probe Otorisasi" dengan hasil "status=403; operasi Edit Komisi ditolak; konfigurasi, status dan snapshot transaksi tidak berubah"

  @negative @priority-high @REQ-013 @screen-edit-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-024
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-024 — Edit persentase invalid tidak menimpa existing
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; record existing 5%." terpenuhi
    And user berada di halaman "edit-komisi-agen"
    When user mengisi field "% Komisi" dengan "101"
    Then sistem memverifikasi elemen "Simpan Komisi" dengan hasil "disabled"
    And sistem memverifikasi elemen "Validasi Persentase" dengan hasil "Nilai maksimal 100,00%."
    When user mengklik tombol "Batal"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: 5,00%"

  @positive @priority-high @REQ-014 @screen-edit-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-015
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-015 — Edit record sendiri tidak dianggap duplikat
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; hanya satu record untuk kombinasi fixture." terpenuhi
    And user berada di halaman "edit-komisi-agen"
    When user mengisi field "% Komisi" dengan "6,00"
    Then sistem memverifikasi elemen "Simpan Komisi" dengan hasil "enabled"
    When user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Jumlah Record Kombinasi" dengan hasil "equals: 1"

  @negative @priority-high @REQ-014 @screen-edit-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-025
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-025 — Edit kunci menjadi kombinasi record lain ditolak
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; Dewasa dan Anak sama-sama ada; harness mencoba mengedit Dewasa menjadi Anak, karena rute/kunci dapat read-only." terpenuhi
    And user berada di halaman "edit-komisi-agen"
    Then sistem memverifikasi elemen "Hasil Probe Validasi" dengan hasil "edit duplikat ditolak; dua record semula tetap; persentase tidak berubah"

  @positive @priority-high @REQ-015 @screen-edit-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-016
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-016 — Edit memisahkan komisi transaksi sebelum dan sesudah commit
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; T0 terbentuk 5% sebelum edit; harness membentuk T2 setelah respons save sukses." terpenuhi
    And user berada di halaman "edit-komisi-agen"
    When user mengisi field "% Komisi" dengan "7,50"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Hasil Transaksi Fixture" dengan hasil "T0 snapshot 5%=50000; T2 snapshot 7,50%=75000"

  @negative @priority-high @REQ-015 @screen-detail-transaksi @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-026
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-026 — Pembayaran tiket lama setelah edit tidak memakai persentase baru
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; T0 terbentuk pada 5% belum dibayar; konfigurasi telah diubah 7,50%; harness membayar T0 sesudah edit." terpenuhi
    And user berada di halaman "detail-transaksi"
    Then sistem memverifikasi elemen "Komisi Agen" dengan hasil "equals: 50000"
    And sistem memverifikasi elemen "Persentase Komisi" dengan hasil "equals: 5,00%"

  @positive @priority-high @REQ-016 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-017
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-017 — Hapus hanya konfigurasi yang dipilih
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; Dewasa 5% dan Anak 4% sama-sama tersimpan." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Hapus komisi"
    Then sistem memverifikasi elemen "Hapus Komisi" dengan hasil "contains: Balikpapan → Parepare; Ekonomi Lesehan Dewasa; 5,00%; agen terdampak"
    When user mengklik tombol "Hapus Komisi"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "absent: Dewasa; contains: Anak 4,00%"

  @negative @priority-high @REQ-016 @screen-hapus-komisi @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-027
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-027 — Cabang ditolak server ketika mencoba Hapus Komisi
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "User login Kantor Cabang; harness telah mencoba mutasi langsung memakai sesi Cabang sebelum verifikasi UI." terpenuhi
    And prasyarat "Fixture sebelum/sesudah tersedia pada panel hasil harness." terpenuhi
    And user berada di halaman "hapus-komisi"
    Then sistem memverifikasi elemen "Hasil Probe Otorisasi" dengan hasil "status=403; operasi Hapus Komisi ditolak; konfigurasi, status dan snapshot transaksi tidak berubah"

  @positive @priority-high @REQ-017 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-018
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-018 — Kombinasi terhapus menjadi belum disetting dan dapat ditambah lagi
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; rute aktif hanya berisi Dewasa 5%." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Hapus komisi"
    And user mengklik tombol "Hapus Komisi"
    Then sistem memverifikasi elemen "Status" dengan hasil "Belum Disetting"
    When user mengklik tombol "Tambah Komisi"
    And user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "4,00"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: Dewasa 4,00%; jumlah=1"

  @negative @priority-high @REQ-017 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-028
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-028 — Hapus gagal tidak membuat kombinasi menjadi belum disetting
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; intercept delete gagal 500; existing Dewasa 5%." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Hapus komisi"
    And user mengklik tombol "Hapus Komisi"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: Dewasa 5,00%"
    And sistem memverifikasi elemen "Status" dengan hasil "Aktif"
    And sistem memverifikasi elemen "Feedback" dengan hasil "error; tidak ada sukses palsu"

  @positive @priority-high @REQ-018 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-019
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-019 — Hapus mempertahankan snapshot transaksi historis
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; transaksi T0 sebelumnya komisi 50000; harness membaca ulang T0 setelah delete." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Hapus komisi"
    And user mengklik tombol "Hapus Komisi"
    Then sistem memverifikasi elemen "Hasil Transaksi Fixture" dengan hasil "T0 tetap 50000 dan snapshot 5%; transaksi baru=0"

  @negative @priority-high @REQ-018 @screen-detail-transaksi @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-029
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-029 — Pembayaran transaksi lama sesudah hapus tidak menghasilkan komisi nol
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; T0 terbentuk 5%; setting terhapus; pembayaran T0 diselesaikan harness." terpenuhi
    And user berada di halaman "detail-transaksi"
    Then sistem memverifikasi elemen "Komisi Agen" dengan hasil "equals: 50000"
    And sistem memverifikasi elemen "Persentase Komisi" dengan hasil "equals: 5,00%"

  @positive @priority-high @REQ-019 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-020
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-020 — Pusat menonaktifkan rute terpilih tanpa memengaruhi rute lain
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; rute fixture dan arah balik sama-sama Aktif." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Nonaktifkan Komisi"
    And user mengisi field "Alasan" dengan "Penundaan operasional"
    And user mengklik tombol "Nonaktifkan"
    Then sistem memverifikasi elemen "Status" dengan hasil "Tidak Aktif"
    And sistem memverifikasi elemen "Status Rute Lain" dengan hasil "arah balik tetap Aktif"

  @negative @priority-high @REQ-019 @screen-nonaktifkan-komisi @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-030
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-030 — Cabang ditolak server ketika mencoba Nonaktifkan Komisi
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "User login Kantor Cabang; harness telah mencoba mutasi langsung memakai sesi Cabang sebelum verifikasi UI." terpenuhi
    And prasyarat "Fixture sebelum/sesudah tersedia pada panel hasil harness." terpenuhi
    And user berada di halaman "nonaktifkan-komisi"
    Then sistem memverifikasi elemen "Hasil Probe Otorisasi" dengan hasil "status=403; operasi Nonaktifkan Komisi ditolak; konfigurasi, status dan snapshot transaksi tidak berubah"

  @negative @priority-high @REQ-019 @screen-nonaktifkan-komisi @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-031
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-031 — Alasan nonaktif whitespace tidak dapat dikonfirmasi
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; modal nonaktif terbuka untuk rute Aktif." terpenuhi
    And user berada di halaman "nonaktifkan-komisi"
    When user mengisi field "Alasan" dengan "   "
    Then sistem memverifikasi elemen "Nonaktifkan" dengan hasil "disabled"
    And sistem memverifikasi elemen "Status Rute" dengan hasil "Aktif"

  @positive @priority-high @REQ-020 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-021
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-021 — Nonaktif mempertahankan konfigurasi dan membuat transaksi baru nol
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; existing 5%, T0 komisi 50000; harness menjual sesudah nonaktif." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Nonaktifkan Komisi"
    And user mengisi field "Alasan" dengan "Evaluasi komisi"
    And user mengklik tombol "Nonaktifkan"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: existing 5,00%; count unchanged"
    And sistem memverifikasi elemen "Hasil Transaksi Fixture" dengan hasil "T0=50000; T1 baru=0"

  @negative @priority-high @REQ-020 @screen-transaksi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-032
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-032 — Setting nonaktif tidak bocor ke transaksi baru dari cache agen
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Agen A; halaman jual sudah terbuka saat aktif 5%; Pusat telah commit nonaktif sebelum submit." terpenuhi
    And user berada di halaman "transaksi-agen"
    When user memilih opsi "Balikpapan → Parepare" pada field "Rute"
    And user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengklik tombol "Buat Transaksi"
    Then sistem memverifikasi elemen "Komisi Agen" dengan hasil "equals: 0; nilai cache 5% tidak dipakai"

  @positive @priority-high @REQ-021 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-022
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-022 — Aktifkan kembali memakai setting existing untuk transaksi baru
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; rute nonaktif menyimpan 5%; T0 selama nonaktif=0; Tlama sebelum nonaktif=50000." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Aktifkan Komisi"
    Then sistem memverifikasi elemen "Aktifkan Komisi" dengan hasil "contains: alasan sebelumnya; transaksi masa nonaktif tidak dihitung ulang"
    When user mengklik tombol "Aktifkan"
    Then sistem memverifikasi elemen "Status" dengan hasil "Aktif"
    And sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: 5,00%; count unchanged"
    And sistem memverifikasi elemen "Hasil Transaksi Fixture" dengan hasil "Tbaru=50000; T0 tetap 0; Tlama tetap 50000"

  @negative @priority-high @REQ-021 @screen-aktifkan-komisi @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-033
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-033 — Cabang ditolak server ketika mencoba Aktifkan Komisi
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "User login Kantor Cabang; harness telah mencoba mutasi langsung memakai sesi Cabang sebelum verifikasi UI." terpenuhi
    And prasyarat "Fixture sebelum/sesudah tersedia pada panel hasil harness." terpenuhi
    And user berada di halaman "aktifkan-komisi"
    Then sistem memverifikasi elemen "Hasil Probe Otorisasi" dengan hasil "status=403; operasi Aktifkan Komisi ditolak; konfigurasi, status dan snapshot transaksi tidak berubah"

  @negative @priority-high @REQ-021 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-034
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-034 — Batal aktifkan tidak menggunakan setting pada transaksi baru
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; rute nonaktif berisi 5%; harness menjual sesudah Batal." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Aktifkan Komisi"
    And user mengklik tombol "Batal"
    Then sistem memverifikasi elemen "Status" dengan hasil "Tidak Aktif"
    And sistem memverifikasi elemen "Hasil Transaksi Fixture" dengan hasil "transaksi baru=0"

  @positive @priority-high @REQ-022 @screen-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-023
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-023 — Cabang melihat detail tanpa semua tombol mutasi
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Kantor Cabang; rute aktif berisi konfigurasi Pusat 5%." terpenuhi
    And user berada di halaman "komisi-rute"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: 5,00%"
    And sistem memverifikasi elemen "Tambah Komisi" dengan hasil "hidden"
    And sistem memverifikasi elemen "Edit komisi" dengan hasil "hidden"
    And sistem memverifikasi elemen "Hapus komisi" dengan hasil "hidden"
    And sistem memverifikasi elemen "Nonaktifkan Komisi" dengan hasil "hidden"
    And sistem memverifikasi elemen "Aktifkan Komisi" dengan hasil "hidden"

  @negative @priority-high @REQ-022 @screen-edit-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-035
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-035 — Cabang tidak dapat membuka URL form edit Pusat
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Kantor Cabang; navigate alias form edit langsung dengan record ID valid." terpenuhi
    And user berada di halaman "edit-komisi-agen"
    Then sistem memverifikasi elemen "Akses Form Edit" dengan hasil "ditolak; form editable tidak terlihat; existing tetap 5%"

  @positive @priority-high @REQ-023 @screen-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-024
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-024 — Cabang memuat konfigurasi Pusat sesudah edit committed
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Cabang; harness Pusat mengedit 5% menjadi 7,50% dan menunggu commit sebelum halaman detail di-fetch." terpenuhi
    And user berada di halaman "komisi-rute"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: 7,50%; persis data Pusat"
    And sistem memverifikasi elemen "Status" dengan hasil "Aktif"

  @negative @priority-high @REQ-023 @screen-transaksi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-036
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-036 — Cache Cabang tidak membuat nilai lama berlaku pada transaksi baru
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Agen A di Cabang; UI pernah memuat 5%; Pusat commit 7,50% sebelum submit." terpenuhi
    And user berada di halaman "transaksi-agen"
    When user memilih opsi "Balikpapan → Parepare" pada field "Rute"
    And user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengklik tombol "Buat Transaksi"
    Then sistem memverifikasi elemen "Komisi Agen" dengan hasil "equals: 75000; snapshot=7,50%"

  @positive @priority-high @REQ-024 @screen-detail-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-025
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-025 — Detail Agen Pusat menghilangkan seluruh UI Komisi Agen
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; agen legacy punya komisi per agen." terpenuhi
    And user berada di halaman "detail-agen"
    Then sistem memverifikasi elemen "Nama Perusahaan Agen" dengan hasil "visible"
    And sistem memverifikasi elemen "Komisi Agen" dengan hasil "tab/section/list/table hidden"
    And sistem memverifikasi elemen "Tambah Komisi" dengan hasil "hidden"
    And sistem memverifikasi elemen "Edit Komisi Agen" dengan hasil "hidden"
    And sistem memverifikasi elemen "Hapus Komisi" dengan hasil "hidden"

  @negative @priority-high @REQ-024 @screen-detail-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-037
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-037 — URL lama Komisi Agen tidak membuka editor per agen
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; alias navigate menunjuk URL lama komisi per agen." terpenuhi
    And user berada di halaman "detail-agen"
    Then sistem memverifikasi elemen "Akses Komisi Per Agen" dengan hasil "gone-or-forbidden; editor/list/action komisi tidak tersedia"

  @positive @priority-high @REQ-025 @screen-transaksi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-026
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-026 — Master menggantikan nilai legacy berbeda milik masing-masing agen
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Agen A; legacy A=9%, B=12%; master aktif 5%; harness transaksi B sesudah commit master." terpenuhi
    And user berada di halaman "transaksi-agen"
    When user memilih opsi "Balikpapan → Parepare" pada field "Rute"
    And user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengklik tombol "Buat Transaksi"
    Then sistem memverifikasi elemen "Komisi Agen" dengan hasil "A=50000; B=50000; snapshot 5% untuk keduanya"

  @negative @priority-high @REQ-025 @screen-detail-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-038
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-038 — Endpoint legacy tidak dapat menyimpan override per agen
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; harness mencoba menyimpan komisi Agen A=12% melalui endpoint legacy." terpenuhi
    And user berada di halaman "detail-agen"
    Then sistem memverifikasi elemen "Hasil Probe Legacy" dengan hasil "mutasi ditolak/gone; tidak ada override baru; master dan transaksi baru tetap 5%"

  @positive @priority-high @REQ-026 @screen-master-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-027
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-027 — Filter rute menggabungkan teks status dan tanggal inklusif
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; fixture rute berisi data tanggal 2026-09-12; filter awal Semua." terpenuhi
    And user berada di halaman "master-komisi-agen"
    When user mengklik tombol "Filter"
    And user mengisi field "Rute" dengan "balikpapan"
    And user memilih opsi "Aktif" pada field "Status"
    And user mengisi field "Tanggal Awal" dengan "2026-09-12"
    And user mengisi field "Tanggal Akhir" dengan "2026-09-12"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "set-equals: rute cocok ketiga filter; tanggal batas termasuk"

  @positive @priority-high @REQ-026 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-028
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-028 — Filter detail menggabungkan jenis golongan kondisi dan persen
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; car Kosong=3,50%; car Isi Muatan=2,50%; Dewasa=5%." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Filter"
    And user memilih opsi "Kendaraan" pada field "Jenis Tiket"
    And user mengisi field "Golongan Tiket" dengan "III-A"
    And user memilih opsi "Kosong" pada field "Kelas / Kondisi Kendaraan"
    And user mengisi field "Komisi Minimum" dengan "3.50"
    And user mengisi field "Komisi Maksimum" dengan "3.50"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "only: car Kosong 3,50%"

  @negative @priority-high @REQ-026 @screen-master-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-039
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-039 — Pencarian rute tanpa kecocokan menampilkan empty tanpa baris lama
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; rute ZZZ Tidak Ada tidak tersedia." terpenuhi
    And user berada di halaman "master-komisi-agen"
    When user mengklik tombol "Filter"
    And user mengisi field "Rute" dengan "ZZZ Tidak Ada"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "count=0; Tidak Ada Data yang tersedia"

  @negative @priority-high @REQ-026 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-040
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-040 — Rentang persen terbalik tidak menghasilkan hasil yang salah
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; panel Filter terbuka; konfigurasi 5%." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengisi field "Komisi Minimum" dengan "10"
    And user mengisi field "Komisi Maksimum" dengan "1"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "empty-or-range-error; tidak menampilkan data di luar rentang"

  @positive @priority-high @REQ-027 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-029
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-029 — Edit dan hapus dibuka dari aksi baris dengan identitas yang benar
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; dua baris berbeda tersedia; rowScope menunjuk Dewasa 5%." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Edit komisi"
    Then sistem memverifikasi elemen "Edit Komisi Agen" dengan hasil "visible; Rute dan jenis/golongan sesuai rowScope"
    When user mengklik tombol "Batal"
    And user mengklik tombol "Hapus komisi"
    Then sistem memverifikasi elemen "Hapus Komisi" dengan hasil "dialog berisi kombinasi rowScope, 5,00%, agen terdampak dan dampak transaksi"
    When user mengklik tombol "Batal"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "unchanged"

  @negative @priority-high @REQ-027 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-041
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-041 — Simpan timeout tidak memberi sukses palsu dan retry tidak menggandakan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi belum ada; harness menunda respons pertama sesudah commit sampai timeout; retry memakai request identik." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "5,00"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Feedback" dengan hasil "timeout atau error yang dapat dipulihkan; tidak ada sukses sebelum konfirmasi"
    When user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Jumlah Record Kombinasi" dengan hasil "equals: 1; retry sukses atau duplikat yang menjelaskan existing"

  @positive @priority-high @REQ-028 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-030
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-030 — Estimasi valid mengikuti tarif golongan dan persentase
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi Dewasa belum ada; tarif fixture Rp485000." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "5,00"
    Then sistem memverifikasi elemen "Estimasi komisi pada tarif berjalan" dengan hasil "equals: Rp 24.250 dari tarif Rp 485.000 per penumpang"

  @negative @priority-high @REQ-028 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-042
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-042 — Nilai invalid tidak menampilkan estimasi valid sebelumnya
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "5,00"
    Then sistem memverifikasi elemen "Estimasi komisi pada tarif berjalan" dengan hasil "visible"
    When user mengisi field "% Komisi" dengan "abc"
    Then sistem memverifikasi elemen "Estimasi komisi pada tarif berjalan" dengan hasil "hidden"
    And sistem memverifikasi elemen "Simpan Komisi" dengan hasil "disabled"

  @negative @priority-high @REQ-009 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-043
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-043 — Server menolak persentase negatif walau validasi UI dilewati
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; harness submit langsung payload persen -0.01 untuk kombinasi belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    Then sistem memverifikasi elemen "Hasil Probe Validasi" dengan hasil "invalid persentase negatif; tidak ada konfigurasi baru"

  @negative @priority-high @REQ-010 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-044
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-044 — Server menolak persentase di atas seratus walau validasi UI dilewati
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; harness submit langsung payload persen 100.01 untuk kombinasi belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    Then sistem memverifikasi elemen "Hasil Probe Validasi" dengan hasil "invalid persentase >100; tidak ada konfigurasi baru"

  @negative @priority-high @REQ-011 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-045
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-045 — Server tidak memakai agen atau cabang sebagai pembeda kunci duplikat
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi fixture sudah ada; harness mengirim kunci sama dengan agen/cabang berbeda." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    Then sistem memverifikasi elemen "Hasil Probe Validasi" dengan hasil "duplikat atau dimensi agen/cabang ditolak; global count kombinasi=1"

  @positive @priority-high @REQ-004 @screen-transaksi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-031
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-031 — Transaksi kendaraan menggunakan komisi sesuai kondisi yang terjual
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Agen A; car Kosong 3,50% dan Isi Muatan 2,50%; basis masing-masing Rp1000000; harness transaksi kondisi Isi Muatan." terpenuhi
    And user berada di halaman "transaksi-agen"
    When user memilih opsi "Balikpapan → Parepare" pada field "Rute"
    And user memilih opsi "Kendaraan" pada field "Jenis Tiket"
    And user memilih opsi "Gol. III-A (Sedan, Jeep, Pick-up)" pada field "Golongan Tiket"
    And user memilih opsi "Kosong" pada field "Kelas / Kondisi Kendaraan"
    And user mengklik tombol "Buat Transaksi"
    Then sistem memverifikasi elemen "Komisi Agen" dengan hasil "Kosong=35000; Isi Muatan=25000; snapshot sesuai masing-masing kondisi"

  @negative @priority-high @REQ-020 @screen-detail-transaksi @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-046
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-046 — Pembayaran transaksi lama sesudah nonaktif tetap memakai snapshot aktif
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; T0 terbentuk saat aktif 5%; Pusat sudah nonaktif; pembayaran T0 diselesaikan harness." terpenuhi
    And user berada di halaman "detail-transaksi"
    Then sistem memverifikasi elemen "Komisi Agen" dengan hasil "equals: 50000"
    And sistem memverifikasi elemen "Persentase Komisi" dengan hasil "equals: 5,00%"

  @negative @priority-high @REQ-021 @screen-transaksi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-047
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-047 — Cache nol saat nonaktif tidak dipakai sesudah aktivasi committed
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Agen A; form jual memuat komisi 0 saat nonaktif; Pusat commit aktif kembali 5% sebelum submit." terpenuhi
    And user berada di halaman "transaksi-agen"
    When user memilih opsi "Balikpapan → Parepare" pada field "Rute"
    And user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengklik tombol "Buat Transaksi"
    Then sistem memverifikasi elemen "Komisi Agen" dengan hasil "equals: 50000; snapshot 5%; nilai cache nol tidak dipakai"

  @edge @priority-high @REQ-009 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-001
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-001 — Batas atau normalisasi persen '0,01'
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "0,01"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: 0,01%"

  @edge @priority-high @REQ-010 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-002
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-002 — Batas atau normalisasi persen '99,99'
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "99,99"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: 99,99%"

  @edge @priority-high @REQ-009 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-003
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-003 — Batas atau normalisasi persen '7.50'
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "7.50"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: 7,50%"

  @edge @priority-high @REQ-009 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-004
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-004 — Batas atau normalisasi persen ' 7,50 '
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan " 7,50 "
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: 7,50%"

  @edge @priority-high @REQ-028 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-005
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-005 — Konfirmasi 0% menyimpan record aktif tanpa komisi transaksi
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi belum ada; harness transaksi baru setelah konfirmasi." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "0,00"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Konfirmasi Komisi 0%" dengan hasil "visible; seluruh agen tidak menerima komisi"
    When user mengklik tombol "Ya, Simpan 0%"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: 0,00%; count=1"
    And sistem memverifikasi elemen "Status" dengan hasil "Aktif"
    And sistem memverifikasi elemen "Hasil Transaksi Fixture" dengan hasil "transaksi baru=0"

  @edge @priority-high @REQ-028 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-006
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-006 — Kembali dari konfirmasi nol mempertahankan form tanpa menyimpan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; kombinasi belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "0"
    And user mengklik tombol "Simpan Komisi"
    And user mengklik tombol "Kembali"
    Then sistem memverifikasi elemen "% Komisi" dengan hasil "value=0"
    And sistem memverifikasi elemen "Jumlah Record Kombinasi" dengan hasil "equals: 0"

  @edge @priority-high @REQ-028 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-007
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-007 — Estimasi kendaraan dibulatkan ke rupiah menurut prototipe
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; car Kosong belum ada; tarif Rp2343750." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Kendaraan" pada field "Jenis Tiket"
    And user memilih opsi "Gol. III-A (Sedan, Jeep, Pick-up)" pada field "Golongan Tiket"
    And user memilih opsi "Kosong" pada field "Kelas / Kondisi Kendaraan"
    And user mengisi field "% Komisi" dengan "3,50"
    Then sistem memverifikasi elemen "Estimasi komisi pada tarif berjalan" dengan hasil "equals: Rp 82.031 dari tarif Rp 2.343.750 per unit"

  @edge @priority-high @REQ-011 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-008
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-008 — Arah balik adalah kombinasi berbeda yang boleh ditambah
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; forward Dewasa 5% ada; modal dibuka pada arah balik tanpa setting." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "4,00"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "reverse Dewasa=4%; forward tetap 5%"

  @edge @priority-high @REQ-011 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-009
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-009 — Kondisi Kosong dan Isi Muatan boleh punya persen berbeda
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; car Kosong=3,50% ada; car Isi Muatan belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Kendaraan" pada field "Jenis Tiket"
    And user memilih opsi "Gol. III-A (Sedan, Jeep, Pick-up)" pada field "Golongan Tiket"
    And user memilih opsi "Isi Muatan" pada field "Kelas / Kondisi Kendaraan"
    And user mengisi field "% Komisi" dengan "2,50"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "Kosong=3,50%; Isi Muatan=2,50%; keduanya tersimpan"

  @edge @priority-high @REQ-011 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-010
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-010 — Null dan nilai kosong kondisi Penumpang tidak menggandakan kunci
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; existing Penumpang kelas null; harness mencoba payload kondisi string kosong." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    Then sistem memverifikasi elemen "Hasil Probe Validasi" dengan hasil "null/empty dinormalisasi atau empty ditolak; jumlah kombinasi tetap 1"

  @edge @priority-high @REQ-011 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-011
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-011 — Klik simpan dua kali tidak membuat dua record
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; konfigurasi belum ada; harness menjalankan double click cepat tombol Simpan." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "5,00"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Jumlah Record Kombinasi" dengan hasil "equals: 1"

  @edge @priority-high @REQ-011 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-012
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-012 — Dua sesi membuat kunci yang sama secara bersamaan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat sesi A; sesi B disiapkan harness dengan kunci sama; barrier sebelum kedua submit." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "5,00"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Hasil Race" dengan hasil "satu create sukses; satu duplikat/konflik; record count=1"

  @edge @priority-high @REQ-014 @screen-edit-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-013
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-013 — Dua edit bersamaan tidak menulis record parsial
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat A; existing 5%; B akan mengedit menjadi 6%; barrier sebelum save A/B." terpenuhi
    And user berada di halaman "edit-komisi-agen"
    When user mengisi field "% Komisi" dengan "7,50"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Hasil Race" dengan hasil "hasil committed utuh 6% atau 7,50%; revision/conflict atau serialisasi teramati; count=1"

  @edge @priority-high @REQ-015 @screen-edit-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-014
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-014 — Transaksi tepat sekitar commit memakai versi yang sesuai urutan server
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; harness menjadwalkan dua transaksi pada barrier commit." terpenuhi
    And user berada di halaman "edit-komisi-agen"
    When user mengisi field "% Komisi" dengan "7,50"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Hasil Race" dengan hasil "transaksi sebelum commit=50000; sesudah commit=75000; tidak ada snapshot campuran"

  @edge @priority-high @REQ-016 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-015
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-015 — Hapus dan edit record sama secara bersamaan memberi hasil konsisten
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat A; Pusat B mengedit record sama pada barrier delete." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Hapus komisi"
    And user mengklik tombol "Hapus Komisi"
    Then sistem memverifikasi elemen "Hasil Race" dengan hasil "record terhapus atau edit serialized sebelum delete; tidak ada record hantu, duplikat atau perubahan kombinasi lain"

  @edge @priority-high @REQ-017 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-016
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-016 — Hapus satu baris menyisakan rute Aktif selama konfigurasi lain ada
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; Dewasa dan Anak sama-sama tersedia pada rute aktif." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Hapus komisi"
    And user mengklik tombol "Hapus Komisi"
    Then sistem memverifikasi elemen "Status" dengan hasil "Aktif"
    And sistem memverifikasi elemen "Jumlah Komisi" dengan hasil "equals: 1"

  @edge @priority-high @REQ-020 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-017
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-017 — Nonaktifkan rute yang belum punya konfigurasi
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; rute berstatus Belum Disetting, count=0." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Nonaktifkan Komisi"
    And user mengisi field "Alasan" dengan "Menunggu pengaturan"
    And user mengklik tombol "Nonaktifkan"
    Then sistem memverifikasi elemen "Status" dengan hasil "Tidak Aktif"
    And sistem memverifikasi elemen "Jumlah Komisi" dengan hasil "equals: 0"

  @edge @priority-high @REQ-021 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-018
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-018 — Aktifkan rute kosong kembali ke Belum Disetting
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; rute nonaktif count=0." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Aktifkan Komisi"
    And user mengklik tombol "Aktifkan"
    Then sistem memverifikasi elemen "Status" dengan hasil "Belum Disetting"
    And sistem memverifikasi elemen "Daftar Komisi" dengan hasil "count=0"

  @edge @priority-high @REQ-020 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-019
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-019 — Tambah setting ketika rute nonaktif tidak langsung memberlakukan komisi
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; rute nonaktif belum punya kombinasi fixture; HTML mengizinkan Tambah; transaksi sesudah save disiapkan harness." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "5,00"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Status Rute" dengan hasil "Tidak Aktif"
    And sistem memverifikasi elemen "Daftar Komisi" dengan hasil "contains: 5,00%"
    And sistem memverifikasi elemen "Hasil Transaksi Fixture" dengan hasil "transaksi baru=0 sampai Pusat mengaktifkan rute"

  @edge @priority-high @REQ-025 @screen-transaksi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-020
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-020 — Legacy tidak menjadi fallback saat master belum disetting
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Agen A; legacy komisi A=9%; master belum disetting." terpenuhi
    And user berada di halaman "transaksi-agen"
    When user memilih opsi "Balikpapan → Parepare" pada field "Rute"
    And user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengklik tombol "Buat Transaksi"
    Then sistem memverifikasi elemen "Komisi Agen" dengan hasil "equals: 0; snapshot tidak memakai 9%"

  @edge @priority-high @REQ-025 @screen-transaksi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-021
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-021 — Legacy tidak menjadi fallback saat master nonaktif
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Agen A; legacy A=9%; master 5% nonaktif." terpenuhi
    And user berada di halaman "transaksi-agen"
    When user memilih opsi "Balikpapan → Parepare" pada field "Rute"
    And user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengklik tombol "Buat Transaksi"
    Then sistem memverifikasi elemen "Komisi Agen" dengan hasil "equals: 0; tidak memakai legacy atau master nonaktif"

  @edge @priority-high @REQ-025 @screen-transaksi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-022
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-022 — Master 0% tidak digantikan legacy bernilai positif
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Agen A; legacy A=9%; master aktif tersimpan 0%." terpenuhi
    And user berada di halaman "transaksi-agen"
    When user memilih opsi "Balikpapan → Parepare" pada field "Rute"
    And user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengklik tombol "Buat Transaksi"
    Then sistem memverifikasi elemen "Komisi Agen" dengan hasil "equals: 0; snapshot master=0%"

  @edge @priority-high @REQ-024 @screen-detail-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-023
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-023 — Detail Agen Cabang juga menghilangkan tab dan tabel komisi
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Cabang; agen legacy punya komisi." terpenuhi
    And user berada di halaman "detail-agen"
    Then sistem memverifikasi elemen "Nama Perusahaan Agen" dengan hasil "visible"
    And sistem memverifikasi elemen "Komisi Agen" dengan hasil "tab/section/list/table hidden"
    And sistem memverifikasi elemen "Tambah Komisi" dengan hasil "hidden"

  @edge @priority-high @REQ-026 @screen-master-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-024
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-024 — Master kosong menampilkan empty state dan pagination nol
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; fixture tidak memiliki rute." terpenuhi
    And user berada di halaman "master-komisi-agen"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "count=0; Tidak Ada Data yang tersedia"
    And sistem memverifikasi elemen "Pagination" dengan hasil "from=0; to=0; total=0"

  @edge @priority-high @REQ-026 @screen-master-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-025
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-025 — Tanggal tanpa konfigurasi tidak cocok filter tanggal
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; rute tanpa setting mempunyai Terakhir Diubah=—." terpenuhi
    And user berada di halaman "master-komisi-agen"
    When user mengklik tombol "Filter"
    And user mengisi field "Tanggal Awal" dengan "2026-09-01"
    And user mengisi field "Tanggal Akhir" dengan "2026-09-30"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "excludes: rute dengan Terakhir Diubah=—"

  @edge @priority-high @REQ-026 @screen-master-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-026
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-026 — Rentang tanggal terbalik memberi empty atau error yang jelas
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; panel Filter dibuka." terpenuhi
    And user berada di halaman "master-komisi-agen"
    When user mengisi field "Tanggal Awal" dengan "2026-09-30"
    And user mengisi field "Tanggal Akhir" dengan "2026-09-01"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "empty-or-range-error; tidak ada hasil tanggal di luar rentang"

  @edge @priority-high @REQ-026 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-027
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-027 — Filter Tanpa Kelas hanya mencakup komisi Penumpang
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; data Penumpang null dan Kendaraan Kosong tersedia." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Filter"
    And user memilih opsi "Tanpa Kelas" pada field "Kelas / Kondisi Kendaraan"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "only: Penumpang kelas null"

  @edge @priority-high @REQ-026 @screen-master-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-028
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-028 — Karakter khusus pada pencarian diperlakukan sebagai teks
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; rute normal tersedia; pencarian tidak cocok." terpenuhi
    And user berada di halaman "master-komisi-agen"
    When user mengklik tombol "Filter"
    And user mengisi field "Rute" dengan "<script>alert(1)</script>' OR 1=1 --"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "empty; tidak ada script dieksekusi atau seluruh data bocor"

  @edge @priority-high @REQ-026 @screen-master-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-029
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-029 — Page size dan halaman berikutnya tidak kehilangan atau menggandakan rute
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; fixture berisi 51 rute unik; default halaman pertama." terpenuhi
    And user berada di halaman "master-komisi-agen"
    When user memilih opsi "10" pada field "Jumlah Data"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "count=10"
    When user mengklik tombol "Halaman Berikutnya"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "rute 11–20; tidak overlap halaman pertama"
    When user memilih opsi "20" pada field "Jumlah Data"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "jumlah <=20; total=51"
    When user memilih opsi "50" pada field "Jumlah Data"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "jumlah <=50; total=51"

  @edge @priority-high @REQ-026 @screen-master-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-030
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-030 — Sort rute dan tanggal hanya mengubah urutan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; fixture label dan tanggal tidak berurutan." terpenuhi
    And user berada di halaman "master-komisi-agen"
    When user mengklik tombol "Urutkan Rute"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "ascending label rute; set tetap"
    When user mengklik tombol "Urutkan Terakhir Diubah"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "ascending tanggal dengan null konsisten; set tetap"

  @edge @priority-high @REQ-026 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-031
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-031 — Sort jenis dan persen mempertahankan kombinasi serta nilai
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; fixture lebih dari satu jenis dan persen berbeda." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Urutkan Jenis Tiket"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "ascending jenis; set kombinasi tetap"
    When user mengklik tombol "Urutkan Komisi"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "ascending numerik 2,50 < 5,00 < 10,00; bukan urut string"

  @edge @priority-high @REQ-026 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-032
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-032 — Kembali dan breadcrumb menuju daftar tanpa menulis konfigurasi
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; detail rute sudah dibuka." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Kembali"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "visible"
    When user mengklik tombol "Setting komisi rute"
    And user mengklik tautan "Master Komisi Agen"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "visible; konfigurasi unchanged"

  @edge @priority-high @REQ-026 @screen-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-033
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-033 — Cabang dapat memakai filter detail tanpa hak tulis
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Cabang; tersedia Penumpang dan Kendaraan." terpenuhi
    And user berada di halaman "komisi-rute"
    When user mengklik tombol "Filter"
    And user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user mengisi field "Golongan Tiket" dengan "Dewasa"
    And user memilih opsi "Tanpa Kelas" pada field "Kelas / Kondisi Kendaraan"
    And user mengisi field "Komisi Minimum" dengan "5"
    And user mengisi field "Komisi Maksimum" dengan "5"
    Then sistem memverifikasi elemen "Daftar Komisi" dengan hasil "only: Dewasa 5%"
    When user mengklik tombol "Kembali"
    Then sistem memverifikasi elemen "Daftar Rute" dengan hasil "visible"

  @edge @priority-high @REQ-027 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-034
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-034 — Pembatalan tambah-komisi-agen melalui Tutup
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; dialog sesuai screen terbuka dan konfigurasi sebelum direkam." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user mengklik tombol "Tutup"
    Then sistem memverifikasi elemen "Konfigurasi Fixture" dengan hasil "unchanged; tidak ada mutasi atau transaksi baru akibat penutupan"

  @edge @priority-high @REQ-027 @screen-edit-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-035
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-035 — Pembatalan edit-komisi-agen melalui Tutup
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; dialog sesuai screen terbuka dan konfigurasi sebelum direkam." terpenuhi
    And user berada di halaman "edit-komisi-agen"
    When user mengklik tombol "Tutup"
    Then sistem memverifikasi elemen "Konfigurasi Fixture" dengan hasil "unchanged; tidak ada mutasi atau transaksi baru akibat penutupan"

  @edge @priority-high @REQ-027 @screen-hapus-komisi @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-036
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-036 — Pembatalan hapus-komisi melalui Tutup
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; dialog sesuai screen terbuka dan konfigurasi sebelum direkam." terpenuhi
    And user berada di halaman "hapus-komisi"
    When user mengklik tombol "Tutup"
    Then sistem memverifikasi elemen "Konfigurasi Fixture" dengan hasil "unchanged; tidak ada mutasi atau transaksi baru akibat penutupan"

  @edge @priority-high @REQ-027 @screen-nonaktifkan-komisi @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-037
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-037 — Pembatalan nonaktifkan-komisi melalui Batal
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; dialog sesuai screen terbuka dan konfigurasi sebelum direkam." terpenuhi
    And user berada di halaman "nonaktifkan-komisi"
    When user mengklik tombol "Batal"
    Then sistem memverifikasi elemen "Konfigurasi Fixture" dengan hasil "unchanged; tidak ada mutasi atau transaksi baru akibat penutupan"

  @edge @priority-high @REQ-027 @screen-aktifkan-komisi @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-038
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-038 — Pembatalan aktifkan-komisi melalui Tutup
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; dialog sesuai screen terbuka dan konfigurasi sebelum direkam." terpenuhi
    And user berada di halaman "aktifkan-komisi"
    When user mengklik tombol "Tutup"
    Then sistem memverifikasi elemen "Konfigurasi Fixture" dengan hasil "unchanged; tidak ada mutasi atau transaksi baru akibat penutupan"

  @edge @priority-high @REQ-028 @screen-konfirmasi-komisi-nol @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-039
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-039 — Pembatalan konfirmasi-komisi-nol melalui Tutup
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; dialog sesuai screen terbuka dan konfigurasi sebelum direkam." terpenuhi
    And user berada di halaman "konfirmasi-komisi-nol"
    When user mengklik tombol "Tutup"
    Then sistem memverifikasi elemen "Konfigurasi Fixture" dengan hasil "unchanged; tidak ada mutasi atau transaksi baru akibat penutupan"

  @edge @priority-high @REQ-023 @screen-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-040
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-040 — Cabang melihat tambah hapus nonaktif dan aktif setelah fetch baru
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Cabang; harness melakukan empat mutasi Pusat satu per satu dan menangkap hasil fetch Cabang sesudah setiap commit." terpenuhi
    And user berada di halaman "komisi-rute"
    Then sistem memverifikasi elemen "Hasil Sinkronisasi" dengan hasil "tambah terlihat; hapus hilang; nonaktif=Tidak Aktif; aktif=Aktif; setiap snapshot sama dengan Pusat"

  @edge @priority-high @REQ-004 @screen-transaksi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-041
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-041 — Rute sama dengan golongan berbeda tidak mengambil komisi tetangga
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Agen A; Dewasa 5% ada tetapi Anak belum disetting." terpenuhi
    And user berada di halaman "transaksi-agen"
    When user memilih opsi "Balikpapan → Parepare" pada field "Rute"
    And user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Anak" pada field "Golongan Tiket"
    And user mengklik tombol "Buat Transaksi"
    Then sistem memverifikasi elemen "Komisi Agen" dengan hasil "equals: 0; tidak memakai Dewasa 5%"

  @stress @priority-medium @REQ-002 @screen-master-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-001
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-001 — Daftar seluruh 10000 rute dapat ditelusuri tanpa kehilangan data
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; harness seed 10000 rute; scan seluruh halaman sesudah navigate." terpenuhi
    And user berada di halaman "master-komisi-agen"
    Then sistem memverifikasi elemen "Hasil Beban" dengan hasil "unique route IDs=10000; total pagination=10000; tidak hilang/duplikat; latency dicatat"

  @stress @priority-medium @REQ-026 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-002
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-002 — Filter 50000 konfigurasi menjaga hasil dan respons yang dapat dipulihkan
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; seed 50000 kombinasi legal dari master fixture yang diperluas; 100 pencarian selama 60 detik lewat harness." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Filter"
    And user mengisi field "Golongan Tiket" dengan "Gol. III-A"
    Then sistem memverifikasi elemen "Hasil Beban" dengan hasil "semua hasil cocok filter oracle; tidak bocor lintas rute; latensi/error dicatat; tidak ada mutasi"

  @stress @priority-medium @REQ-022 @screen-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-003
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-003 — Seratus sesi Cabang membaca bersamaan tanpa memperoleh hak tulis
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Cabang; 100 sesi Cabang disiapkan harness, durasi 60 detik; konfigurasi master tetap." terpenuhi
    And user berada di halaman "komisi-rute"
    Then sistem memverifikasi elemen "Hasil Beban" dengan hasil "100 sesi membaca data committed; mutasi semua ditolak; checksum konfigurasi tetap"

  @stress @priority-high @REQ-011 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-004
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-004 — Dua puluh penulis bersamaan untuk satu kombinasi tetap menyimpan satu record
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; 20 sesi barrier membuat kunci sama; konfigurasi awal belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "5,00"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Hasil Beban" dengan hasil "tepat satu create sukses; 19 duplikat/konflik; persisted key count=1"

  @stress @priority-high @REQ-014 @screen-edit-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-005
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-005 — Edit paralel tetap menghasilkan revisi utuh dan kunci unik
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; 20 sesi mengedit 100 kombinasi; 60 detik; semua input valid." terpenuhi
    And user berada di halaman "edit-komisi-agen"
    When user mengisi field "% Komisi" dengan "7,50"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Hasil Beban" dengan hasil "setiap snapshot utuh; kunci unik; konflik atau serialisasi teramati; tidak ada silent overwrite di luar urutan yang diakui"

  @stress @priority-high @REQ-015 @screen-edit-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-006
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-006 — Seribu transaksi selama perubahan persen mempertahankan snapshot temporal
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; 1000 transaksi Agen A/B disiapkan pada barrier sebelum/sesudah commit." terpenuhi
    And user berada di halaman "edit-komisi-agen"
    When user mengisi field "% Komisi" dengan "7,50"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Hasil Beban" dengan hasil "1000 transaksi masing-masing cocok versi server: sebelum=50000, sesudah=75000; historis unchanged"

  @stress @priority-high @REQ-018 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-007
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-007 — Penghapusan tidak mengubah seribu transaksi historis
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; 1000 transaksi historis tersimpan snapshot 5%; checksum sebelum tersedia." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Hapus komisi"
    And user mengklik tombol "Hapus Komisi"
    Then sistem memverifikasi elemen "Hasil Beban" dengan hasil "checksum 1000 snapshot sama; konfigurasi terpilih terhapus; transaksi baru=0"

  @stress @priority-high @REQ-020 @screen-setting-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-008
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-008 — Nonaktif dan aktif berulang saat penjualan tetap konsisten
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; harness 20 siklus status dan 1000 transaksi; status final aktif; data configuration checksum direkam." terpenuhi
    And user berada di halaman "setting-komisi-rute"
    When user mengklik tombol "Nonaktifkan Komisi"
    And user mengisi field "Alasan" dengan "Uji beban terisolasi"
    And user mengklik tombol "Nonaktifkan"
    Then sistem memverifikasi elemen "Hasil Beban" dengan hasil "setiap transaksi memakai status committed; aktif=5%, nonaktif=0%; checksum konfigurasi tetap; tidak ada hitung ulang"

  @stress @priority-high @REQ-023 @screen-komisi-rute @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-009
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-009 — Sinkronisasi banyak Cabang mengikuti perubahan Pusat di bawah beban
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Cabang; 100 sesi baca; Pusat melakukan 20 edit dalam 60 detik; fetch akhir sesudah commit terakhir." terpenuhi
    And user berada di halaman "komisi-rute"
    Then sistem memverifikasi elemen "Hasil Beban" dengan hasil "seluruh fetch akhir sama dengan revisi terakhir Pusat; transaksi baru memakai revisi committed; error/latensi tercatat"

  @stress @priority-medium @REQ-009 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-010
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-010 — Payload persen sepanjang 10000 karakter ditolak tanpa merusak form
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; semua field lain valid; kombinasi belum ada." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999"
    Then sistem memverifikasi elemen "Simpan Komisi" dengan hasil "disabled"
    And sistem memverifikasi elemen "Validasi Persentase" dengan hasil "invalid; form tetap dapat dipulihkan"
    When user mengisi field "% Komisi" dengan "5,00"
    Then sistem memverifikasi elemen "Simpan Komisi" dengan hasil "enabled"

  @stress @priority-medium @REQ-027 @screen-nonaktifkan-komisi @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-011
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-011 — Alasan nonaktif panjang tidak menyebabkan perubahan parsial
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; rute aktif; payload 10000 karakter; limit bisnis tidak ditentukan." terpenuhi
    And user berada di halaman "nonaktifkan-komisi"
    When user mengisi field "Alasan" dengan "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    And user mengklik tombol "Nonaktifkan"
    Then sistem memverifikasi elemen "Hasil Beban" dengan hasil "diterima utuh dengan status Tidak Aktif atau ditolak jelas dengan status Aktif; tidak parsial; tidak hang"

  @stress @priority-high @REQ-027 @screen-tambah-komisi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-012
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-012 — Respons save lambat dan retry bersamaan tetap unik
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Pusat; harness 20 retry request sama sesudah respons timeout pada save committed." terpenuhi
    And user berada di halaman "tambah-komisi-agen"
    When user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengisi field "% Komisi" dengan "5,00"
    And user mengklik tombol "Simpan Komisi"
    Then sistem memverifikasi elemen "Hasil Beban" dengan hasil "record count=1; tidak ada sukses palsu atau mutasi ganda; retry/reload memulihkan state"

  @stress @priority-high @REQ-025 @screen-transaksi-agen @id-RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-013
  Scenario: RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-013 — Migrasi sumber komisi pada 1000 agen mengabaikan seluruh legacy
    Given prasyarat "Fixture uji terisolasi telah disiapkan; alias URL dan selector sudah dipetakan ke aplikasi." terpenuhi
    And prasyarat "Login Agen A; 1000 agen legacy berpersen beragam berhak menjual kombinasi; master 5%; harness membuat satu transaksi per agen." terpenuhi
    And user berada di halaman "transaksi-agen"
    When user memilih opsi "Balikpapan → Parepare" pada field "Rute"
    And user memilih opsi "Penumpang" pada field "Jenis Tiket"
    And user memilih opsi "Ekonomi Lesehan Dewasa" pada field "Golongan Tiket"
    And user mengklik tombol "Buat Transaksi"
    Then sistem memverifikasi elemen "Hasil Beban" dengan hasil "1000 transaksi snapshot master 5%, komisi=50000 per transaksi; tidak ada override legacy"
