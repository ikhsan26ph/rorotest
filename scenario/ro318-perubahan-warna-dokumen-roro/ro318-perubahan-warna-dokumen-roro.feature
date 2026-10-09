# language: en
# Teks langkah berbahasa Indonesia; keyword Gherkin mengikuti skema proyek.
# Semua skenario terblokir untuk otomasi sampai dependensi di JSON dipenuhi.
# Negative adalah pemeriksaan regresi yang dilarang spesifikasi, bukan input invalid rekaan.
# Tidak ada skenario edge/stress: tidak ada dasar fixture, batas, atau oracle yang diberikan.
Feature: Perubahan warna identitas dokumen RORO
  Warna identitas pada tampilan dan cetakan berubah sesuai spesifikasi.
  Informasi, format, data, dan warna di luar target harus tetap.

  # Automation: blocked; dependensi: GAP-001, GAP-002, GAP-005
  @positive @priority-high @REQ-001 @screen-e-tiket @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-001
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-001 - Warna identitas E-Tiket pada tampilan menjadi biru sesuai referensi yang disahkan; kode belum diberikan
    Given prasyarat pengujian "Tersedia dokumen E-Tiket untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Referensi warna biru E-Tiket sudah disahkan; spesifikasi belum memberi kode warna."
    When user mengakses keluaran "E-Tiket - tampilan"
    Then hasil "E-Tiket - tampilan" memenuhi pemeriksaan "semua elemen identitas yang terkonfirmasi menggunakan biru sesuai referensi yang disahkan; kode belum diberikan"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-005
  @negative @priority-high @REQ-001 @screen-e-tiket @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-001
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-001 - Tidak ada warna hijau identitas lama tersisa pada tampilan E-Tiket
    Given prasyarat pengujian "Tersedia dokumen E-Tiket untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    When user mengakses keluaran "E-Tiket - tampilan"
    Then hasil "E-Tiket - tampilan" memenuhi pemeriksaan "tidak ada elemen target yang masih memakai warna hijau identitas lama berdasarkan baseline; elemen hijau di luar target tidak termasuk pemeriksaan ini"

  # Automation: blocked; dependensi: GAP-001, GAP-002, GAP-004, GAP-005
  @positive @priority-high @REQ-001 @screen-e-tiket @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-002
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-002 - Warna identitas E-Tiket pada cetakan menjadi biru sesuai referensi yang disahkan; kode belum diberikan
    Given prasyarat pengujian "Tersedia dokumen E-Tiket untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Referensi warna biru E-Tiket sudah disahkan; spesifikasi belum memberi kode warna."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    When user mengakses keluaran "E-Tiket - cetakan"
    Then hasil "E-Tiket - cetakan" memenuhi pemeriksaan "semua elemen identitas yang terkonfirmasi menggunakan biru sesuai referensi yang disahkan; kode belum diberikan"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-004, GAP-005
  @negative @priority-high @REQ-001 @screen-e-tiket @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-002
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-002 - Tidak ada warna hijau identitas lama tersisa pada cetakan E-Tiket
    Given prasyarat pengujian "Tersedia dokumen E-Tiket untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    When user mengakses keluaran "E-Tiket - cetakan"
    Then hasil "E-Tiket - cetakan" memenuhi pemeriksaan "tidak ada elemen target yang masih memakai warna hijau identitas lama berdasarkan baseline; elemen hijau di luar target tidak termasuk pemeriksaan ini"

  # Automation: blocked; dependensi: GAP-002, GAP-005
  @positive @priority-high @REQ-002 @screen-kwitansi @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-003
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-003 - Warna identitas Kwitansi pada tampilan menjadi #002564
    Given prasyarat pengujian "Tersedia dokumen Kwitansi untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    When user mengakses keluaran "Kwitansi - tampilan"
    Then hasil "Kwitansi - tampilan" memenuhi pemeriksaan "semua elemen identitas yang terkonfirmasi menggunakan #002564"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-005
  @negative @priority-high @REQ-002 @screen-kwitansi @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-003
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-003 - Tidak ada warna hijau identitas lama tersisa pada tampilan Kwitansi
    Given prasyarat pengujian "Tersedia dokumen Kwitansi untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    When user mengakses keluaran "Kwitansi - tampilan"
    Then hasil "Kwitansi - tampilan" memenuhi pemeriksaan "tidak ada elemen target yang masih memakai warna hijau identitas lama berdasarkan baseline; elemen hijau di luar target tidak termasuk pemeriksaan ini"

  # Automation: blocked; dependensi: GAP-002, GAP-004, GAP-005
  @positive @priority-high @REQ-002 @screen-kwitansi @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-004
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-004 - Warna identitas Kwitansi pada cetakan menjadi #002564
    Given prasyarat pengujian "Tersedia dokumen Kwitansi untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    When user mengakses keluaran "Kwitansi - cetakan"
    Then hasil "Kwitansi - cetakan" memenuhi pemeriksaan "semua elemen identitas yang terkonfirmasi menggunakan #002564"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-004, GAP-005
  @negative @priority-high @REQ-002 @screen-kwitansi @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-004
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-004 - Tidak ada warna hijau identitas lama tersisa pada cetakan Kwitansi
    Given prasyarat pengujian "Tersedia dokumen Kwitansi untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    When user mengakses keluaran "Kwitansi - cetakan"
    Then hasil "Kwitansi - cetakan" memenuhi pemeriksaan "tidak ada elemen target yang masih memakai warna hijau identitas lama berdasarkan baseline; elemen hijau di luar target tidak termasuk pemeriksaan ini"

  # Automation: blocked; dependensi: GAP-001, GAP-002, GAP-005
  @positive @priority-high @REQ-003 @screen-boarding-pass @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-005
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-005 - Warna identitas Boarding Pass pada tampilan menjadi biru sesuai referensi yang disahkan; kode belum diberikan
    Given prasyarat pengujian "Tersedia dokumen Boarding Pass untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Referensi warna biru Boarding Pass sudah disahkan; spesifikasi belum memberi kode warna."
    When user mengakses keluaran "Boarding Pass - tampilan"
    Then hasil "Boarding Pass - tampilan" memenuhi pemeriksaan "semua elemen identitas yang terkonfirmasi menggunakan biru sesuai referensi yang disahkan; kode belum diberikan"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-005
  @negative @priority-high @REQ-003 @screen-boarding-pass @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-005
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-005 - Tidak ada warna hijau identitas lama tersisa pada tampilan Boarding Pass
    Given prasyarat pengujian "Tersedia dokumen Boarding Pass untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    When user mengakses keluaran "Boarding Pass - tampilan"
    Then hasil "Boarding Pass - tampilan" memenuhi pemeriksaan "tidak ada elemen target yang masih memakai warna hijau identitas lama berdasarkan baseline; elemen hijau di luar target tidak termasuk pemeriksaan ini"

  # Automation: blocked; dependensi: GAP-001, GAP-002, GAP-004, GAP-005
  @positive @priority-high @REQ-003 @screen-boarding-pass @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-006
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-006 - Warna identitas Boarding Pass pada cetakan menjadi biru sesuai referensi yang disahkan; kode belum diberikan
    Given prasyarat pengujian "Tersedia dokumen Boarding Pass untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Referensi warna biru Boarding Pass sudah disahkan; spesifikasi belum memberi kode warna."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    When user mengakses keluaran "Boarding Pass - cetakan"
    Then hasil "Boarding Pass - cetakan" memenuhi pemeriksaan "semua elemen identitas yang terkonfirmasi menggunakan biru sesuai referensi yang disahkan; kode belum diberikan"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-004, GAP-005
  @negative @priority-high @REQ-003 @screen-boarding-pass @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-006
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-NEG-006 - Tidak ada warna hijau identitas lama tersisa pada cetakan Boarding Pass
    Given prasyarat pengujian "Tersedia dokumen Boarding Pass untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    When user mengakses keluaran "Boarding Pass - cetakan"
    Then hasil "Boarding Pass - cetakan" memenuhi pemeriksaan "tidak ada elemen target yang masih memakai warna hijau identitas lama berdasarkan baseline; elemen hijau di luar target tidak termasuk pemeriksaan ini"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-004, GAP-005
  @positive @priority-high @REQ-004 @screen-e-tiket @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-007
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-007 - Warna di luar elemen identitas E-Tiket tetap pada tampilan dan cetakan
    Given prasyarat pengujian "Tersedia dokumen E-Tiket untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    When user mengakses keluaran "E-Tiket - tampilan"
    And user mengakses keluaran "E-Tiket - cetakan"
    Then hasil "E-Tiket - tampilan" memenuhi pemeriksaan "warna setiap elemen di luar daftar target tetap sama dengan baseline kanal yang sama"
    And hasil "E-Tiket - cetakan" memenuhi pemeriksaan "warna setiap elemen di luar daftar target tetap sama dengan baseline kanal yang sama"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-004, GAP-005
  @positive @priority-high @REQ-004 @screen-kwitansi @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-008
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-008 - Warna di luar elemen identitas Kwitansi tetap pada tampilan dan cetakan
    Given prasyarat pengujian "Tersedia dokumen Kwitansi untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    When user mengakses keluaran "Kwitansi - tampilan"
    And user mengakses keluaran "Kwitansi - cetakan"
    Then hasil "Kwitansi - tampilan" memenuhi pemeriksaan "warna setiap elemen di luar daftar target tetap sama dengan baseline kanal yang sama"
    And hasil "Kwitansi - cetakan" memenuhi pemeriksaan "warna setiap elemen di luar daftar target tetap sama dengan baseline kanal yang sama"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-004, GAP-005
  @positive @priority-high @REQ-004 @screen-boarding-pass @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-009
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-009 - Warna di luar elemen identitas Boarding Pass tetap pada tampilan dan cetakan
    Given prasyarat pengujian "Tersedia dokumen Boarding Pass untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    When user mengakses keluaran "Boarding Pass - tampilan"
    And user mengakses keluaran "Boarding Pass - cetakan"
    Then hasil "Boarding Pass - tampilan" memenuhi pemeriksaan "warna setiap elemen di luar daftar target tetap sama dengan baseline kanal yang sama"
    And hasil "Boarding Pass - cetakan" memenuhi pemeriksaan "warna setiap elemen di luar daftar target tetap sama dengan baseline kanal yang sama"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-004, GAP-005, GAP-009
  @positive @priority-high @REQ-005 @screen-e-tiket @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-010
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-010 - Informasi dokumen E-Tiket tetap pada tampilan dan cetakan
    Given prasyarat pengujian "Tersedia dokumen E-Tiket untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    And prasyarat pengujian "Inventaris informasi atau pemetaan nilai data dokumen sudah dikonfirmasi; tidak dibuat nama field sendiri."
    When user mengakses keluaran "E-Tiket - tampilan"
    And user mengakses keluaran "E-Tiket - cetakan"
    Then hasil "E-Tiket - tampilan" memenuhi pemeriksaan "seluruh informasi yang benar-benar ada pada baseline tetap tersedia dan sama"
    And hasil "E-Tiket - cetakan" memenuhi pemeriksaan "seluruh informasi yang benar-benar ada pada baseline tetap tersedia dan sama"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-004, GAP-005, GAP-009
  @positive @priority-high @REQ-005 @screen-kwitansi @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-011
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-011 - Informasi dokumen Kwitansi tetap pada tampilan dan cetakan
    Given prasyarat pengujian "Tersedia dokumen Kwitansi untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    And prasyarat pengujian "Inventaris informasi atau pemetaan nilai data dokumen sudah dikonfirmasi; tidak dibuat nama field sendiri."
    When user mengakses keluaran "Kwitansi - tampilan"
    And user mengakses keluaran "Kwitansi - cetakan"
    Then hasil "Kwitansi - tampilan" memenuhi pemeriksaan "seluruh informasi yang benar-benar ada pada baseline tetap tersedia dan sama"
    And hasil "Kwitansi - cetakan" memenuhi pemeriksaan "seluruh informasi yang benar-benar ada pada baseline tetap tersedia dan sama"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-004, GAP-005, GAP-009
  @positive @priority-high @REQ-005 @screen-boarding-pass @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-012
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-012 - Informasi dokumen Boarding Pass tetap pada tampilan dan cetakan
    Given prasyarat pengujian "Tersedia dokumen Boarding Pass untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    And prasyarat pengujian "Inventaris informasi atau pemetaan nilai data dokumen sudah dikonfirmasi; tidak dibuat nama field sendiri."
    When user mengakses keluaran "Boarding Pass - tampilan"
    And user mengakses keluaran "Boarding Pass - cetakan"
    Then hasil "Boarding Pass - tampilan" memenuhi pemeriksaan "seluruh informasi yang benar-benar ada pada baseline tetap tersedia dan sama"
    And hasil "Boarding Pass - cetakan" memenuhi pemeriksaan "seluruh informasi yang benar-benar ada pada baseline tetap tersedia dan sama"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-004, GAP-005, GAP-006
  @positive @priority-high @REQ-006 @screen-e-tiket @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-013
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-013 - Format dokumen E-Tiket tetap pada tampilan dan cetakan
    Given prasyarat pengujian "Tersedia dokumen E-Tiket untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    And prasyarat pengujian "Definisi format serta metode pembandingan baseline sudah dikonfirmasi; tidak dibuat toleransi atau pengecualian sendiri."
    When user mengakses keluaran "E-Tiket - tampilan"
    And user mengakses keluaran "E-Tiket - cetakan"
    Then hasil "E-Tiket - tampilan" memenuhi pemeriksaan "format tetap sesuai baseline berdasarkan definisi pembandingan yang dikonfirmasi, dengan perubahan warna identitas sebagai satu-satunya pengecualian dari spesifikasi"
    And hasil "E-Tiket - cetakan" memenuhi pemeriksaan "format tetap sesuai baseline berdasarkan definisi pembandingan yang dikonfirmasi, dengan perubahan warna identitas sebagai satu-satunya pengecualian dari spesifikasi"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-004, GAP-005, GAP-006
  @positive @priority-high @REQ-006 @screen-kwitansi @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-014
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-014 - Format dokumen Kwitansi tetap pada tampilan dan cetakan
    Given prasyarat pengujian "Tersedia dokumen Kwitansi untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    And prasyarat pengujian "Definisi format serta metode pembandingan baseline sudah dikonfirmasi; tidak dibuat toleransi atau pengecualian sendiri."
    When user mengakses keluaran "Kwitansi - tampilan"
    And user mengakses keluaran "Kwitansi - cetakan"
    Then hasil "Kwitansi - tampilan" memenuhi pemeriksaan "format tetap sesuai baseline berdasarkan definisi pembandingan yang dikonfirmasi, dengan perubahan warna identitas sebagai satu-satunya pengecualian dari spesifikasi"
    And hasil "Kwitansi - cetakan" memenuhi pemeriksaan "format tetap sesuai baseline berdasarkan definisi pembandingan yang dikonfirmasi, dengan perubahan warna identitas sebagai satu-satunya pengecualian dari spesifikasi"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-004, GAP-005, GAP-006
  @positive @priority-high @REQ-006 @screen-boarding-pass @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-015
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-015 - Format dokumen Boarding Pass tetap pada tampilan dan cetakan
    Given prasyarat pengujian "Tersedia dokumen Boarding Pass untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    And prasyarat pengujian "Definisi format serta metode pembandingan baseline sudah dikonfirmasi; tidak dibuat toleransi atau pengecualian sendiri."
    When user mengakses keluaran "Boarding Pass - tampilan"
    And user mengakses keluaran "Boarding Pass - cetakan"
    Then hasil "Boarding Pass - tampilan" memenuhi pemeriksaan "format tetap sesuai baseline berdasarkan definisi pembandingan yang dikonfirmasi, dengan perubahan warna identitas sebagai satu-satunya pengecualian dari spesifikasi"
    And hasil "Boarding Pass - cetakan" memenuhi pemeriksaan "format tetap sesuai baseline berdasarkan definisi pembandingan yang dikonfirmasi, dengan perubahan warna identitas sebagai satu-satunya pengecualian dari spesifikasi"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-004, GAP-005, GAP-009
  @positive @priority-high @REQ-007 @screen-e-tiket @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-016
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-016 - Nilai data dokumen E-Tiket tetap pada tampilan dan cetakan
    Given prasyarat pengujian "Tersedia dokumen E-Tiket untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    And prasyarat pengujian "Inventaris informasi atau pemetaan nilai data dokumen sudah dikonfirmasi; tidak dibuat nama field sendiri."
    When user mengakses keluaran "E-Tiket - tampilan"
    And user mengakses keluaran "E-Tiket - cetakan"
    Then hasil "E-Tiket - tampilan" memenuhi pemeriksaan "seluruh nilai data yang dipetakan identik dengan baseline untuk data sumber yang sama"
    And hasil "E-Tiket - cetakan" memenuhi pemeriksaan "seluruh nilai data yang dipetakan identik dengan baseline untuk data sumber yang sama"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-004, GAP-005, GAP-009
  @positive @priority-high @REQ-007 @screen-kwitansi @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-017
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-017 - Nilai data dokumen Kwitansi tetap pada tampilan dan cetakan
    Given prasyarat pengujian "Tersedia dokumen Kwitansi untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    And prasyarat pengujian "Inventaris informasi atau pemetaan nilai data dokumen sudah dikonfirmasi; tidak dibuat nama field sendiri."
    When user mengakses keluaran "Kwitansi - tampilan"
    And user mengakses keluaran "Kwitansi - cetakan"
    Then hasil "Kwitansi - tampilan" memenuhi pemeriksaan "seluruh nilai data yang dipetakan identik dengan baseline untuk data sumber yang sama"
    And hasil "Kwitansi - cetakan" memenuhi pemeriksaan "seluruh nilai data yang dipetakan identik dengan baseline untuk data sumber yang sama"

  # Automation: blocked; dependensi: GAP-002, GAP-003, GAP-004, GAP-005, GAP-009
  @positive @priority-high @REQ-007 @screen-boarding-pass @RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-018
  Scenario: RO318-PERUBAHAN-WARNA-DOKUMEN-RORO-POS-018 - Nilai data dokumen Boarding Pass tetap pada tampilan dan cetakan
    Given prasyarat pengujian "Tersedia dokumen Boarding Pass untuk cakupan RORO yang dapat diverifikasi dari sistem aktual; fixture belum diberikan."
    And prasyarat pengujian "Mekanisme akses keluaran dan elemen aktual sudah dipetakan; belum tersedia pada input."
    And prasyarat pengujian "Daftar elemen identitas dan elemen di luar target sudah dikonfirmasi per kanal; belum tersedia pada input."
    And prasyarat pengujian "Tersedia baseline sebelum perubahan serta dokumen sesudah perubahan dengan data sumber yang sama untuk setiap kanal yang diuji; baseline belum diberikan."
    And prasyarat pengujian "Metode memperoleh dan memverifikasi keluaran cetakan sudah ditetapkan; media, renderer, dan metode pembandingan belum diberikan."
    And prasyarat pengujian "Inventaris informasi atau pemetaan nilai data dokumen sudah dikonfirmasi; tidak dibuat nama field sendiri."
    When user mengakses keluaran "Boarding Pass - tampilan"
    And user mengakses keluaran "Boarding Pass - cetakan"
    Then hasil "Boarding Pass - tampilan" memenuhi pemeriksaan "seluruh nilai data yang dipetakan identik dengan baseline untuk data sumber yang sama"
    And hasil "Boarding Pass - cetakan" memenuhi pemeriksaan "seluruh nilai data yang dipetakan identik dengan baseline untuk data sumber yang sama"

