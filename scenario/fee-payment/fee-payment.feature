Feature: Pelunasan dummy dengan nominal konsisten

  Scenario: SCN-0001: Pelunasan dummy order baru Bank Mandiri
    Given konfirmasi dummy dan order baru run20261007-072556
    When pembayaran diselesaikan pada checkout aktual
    Then status lunas dan nominal harus terverifikasi pada kode sama

  Scenario: SCN-0002: Pelunasan dummy order baru Bank BCA
    Given konfirmasi dummy dan order baru run20261007-072556
    When pembayaran diselesaikan pada checkout aktual
    Then status lunas dan nominal harus terverifikasi pada kode sama

  Scenario: SCN-0003: Pelunasan dummy order baru Bank BNI
    Given konfirmasi dummy dan order baru run20261007-072556
    When pembayaran diselesaikan pada checkout aktual
    Then status lunas dan nominal harus terverifikasi pada kode sama

  Scenario: SCN-0004: Pelunasan dummy order baru Bank BRI
    Given konfirmasi dummy dan order baru run20261007-072556
    When pembayaran diselesaikan pada checkout aktual
    Then status lunas dan nominal harus terverifikasi pada kode sama

  Scenario: SCN-0005: Pelunasan dummy order baru OVO
    Given konfirmasi dummy dan order baru run20261007-072556
    When pembayaran diselesaikan pada checkout aktual
    Then status lunas dan nominal harus terverifikasi pada kode sama

  Scenario: SCN-0006: Pelunasan dummy order baru DANA
    Given konfirmasi dummy dan order baru run20261007-072556
    When pembayaran diselesaikan pada checkout aktual
    Then status lunas dan nominal harus terverifikasi pada kode sama

  Scenario: SCN-0007: Pelunasan dummy order baru Alfamart
    Given konfirmasi dummy dan order baru run20261007-072556
    When pembayaran diselesaikan pada checkout aktual
    Then status lunas dan nominal harus terverifikasi pada kode sama

  Scenario: SCN-0008: Pelunasan dummy order baru Indomaret
    Given konfirmasi dummy dan order baru run20261007-072556
    When pembayaran diselesaikan pada checkout aktual
    Then status lunas dan nominal harus terverifikasi pada kode sama

  Scenario: SCN-0009: Pelunasan dummy order baru QRIS
    Given konfirmasi dummy dan order baru run20261007-072556
    When pembayaran diselesaikan pada checkout aktual
    Then status lunas dan nominal harus terverifikasi pada kode sama

  Scenario: SCN-0010: Cetak PDF e-tiket QRIS setelah lunas
    Given order terkait sudah memiliki status lunas positif
    When tombol Cetak E-Tiket aktual diklik dan unduhan disimpan
    Then file adalah PDF valid dengan kode booking yang sama

  Scenario: SCN-0011: Cetak PDF e-tiket OVO setelah lunas
    Given order terkait sudah memiliki status lunas positif
    When tombol Cetak E-Tiket aktual diklik dan unduhan disimpan
    Then file adalah PDF valid dengan kode booking yang sama
