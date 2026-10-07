Feature: Sinkronisasi fee detail dan pembayaran

  Scenario: SCN-0001: Sinkronisasi biaya admin pembayaran dan detail order Bank Mandiri
    Given order baru dan konfigurasi Finance saat ini
    When detail lalu pembayaran lalu detail dibaca ulang
    Then nominal admin fee yang visible harus sama

  Scenario: SCN-0002: Sinkronisasi biaya admin pembayaran dan detail order Bank BCA
    Given order baru dan konfigurasi Finance saat ini
    When detail lalu pembayaran lalu detail dibaca ulang
    Then nominal admin fee yang visible harus sama

  Scenario: SCN-0003: Sinkronisasi biaya admin pembayaran dan detail order Bank BNI
    Given order baru dan konfigurasi Finance saat ini
    When detail lalu pembayaran lalu detail dibaca ulang
    Then nominal admin fee yang visible harus sama

  Scenario: SCN-0004: Sinkronisasi biaya admin pembayaran dan detail order Bank BRI
    Given order baru dan konfigurasi Finance saat ini
    When detail lalu pembayaran lalu detail dibaca ulang
    Then nominal admin fee yang visible harus sama

  Scenario: SCN-0005: Sinkronisasi biaya admin pembayaran dan detail order OVO
    Given order baru dan konfigurasi Finance saat ini
    When detail lalu pembayaran lalu detail dibaca ulang
    Then nominal admin fee yang visible harus sama

  Scenario: SCN-0006: Sinkronisasi biaya admin pembayaran dan detail order DANA
    Given order baru dan konfigurasi Finance saat ini
    When detail lalu pembayaran lalu detail dibaca ulang
    Then nominal admin fee yang visible harus sama

  Scenario: SCN-0007: Sinkronisasi biaya admin pembayaran dan detail order Alfamart
    Given order baru dan konfigurasi Finance saat ini
    When detail lalu pembayaran lalu detail dibaca ulang
    Then nominal admin fee yang visible harus sama

  Scenario: SCN-0008: Sinkronisasi biaya admin pembayaran dan detail order Indomaret
    Given order baru dan konfigurasi Finance saat ini
    When detail lalu pembayaran lalu detail dibaca ulang
    Then nominal admin fee yang visible harus sama

  Scenario: SCN-0009: Sinkronisasi biaya admin pembayaran dan detail order QRIS
    Given order baru dan konfigurasi Finance saat ini
    When detail lalu pembayaran lalu detail dibaca ulang
    Then nominal admin fee yang visible harus sama
