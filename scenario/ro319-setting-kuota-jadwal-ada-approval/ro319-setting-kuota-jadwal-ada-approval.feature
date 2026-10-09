# language: en
Feature: ro319-setting-kuota-jadwal-ada-approval
  Approval kuota Cabang oleh Pusat sebelum Jadwal dan Crew List.
  Fixture, role, fault injection, assertion state, dan asumsi tersedia pada JSON pendamping.

  @positive @priority-high @REQ-001 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-001 — Cabang menyelesaikan alur approval trước Jadwal và Crew
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto membuat voyage 214; sesi Kantor Pusat / Achmad Riyanto tersedia untuk approval"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "400"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan" dengan "0"
    And user mengisi field "Kuota Internal — Ekonomi Lesehan (A)" dengan "40"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan (A)" dengan "0"
    And user mengisi field "Kuota Internal — Sepeda Motor (CC<250) (II-A)" dengan "15"
    And user mengisi field "Kuota Eksternal — Sepeda Motor (CC<250) (II-A)" dengan "0"
    And user mengisi field "Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "15"
    And user mengisi field "Kuota Eksternal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Sedang Standart (IV-B)" dengan "8"
    And user mengisi field "Kuota Eksternal — Truck/Bus Sedang Standart (IV-B)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Besar Standart (V-B)" dengan "6"
    And user mengisi field "Kuota Eksternal — Truck/Bus Besar Standart (V-B)" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Penumpang 10.000" dengan "20"
    And user mengisi field "Kuota Eksternal — Bagasi Penumpang 10.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 300.000" dengan "5"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 300.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 1.000.000" dengan "2"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 1.000.000" dengan "0"
    And user mengklik tombol "Simpan & Ajukan"
    And user mengklik tombol "Ajukan ke Pusat"
    And user membuka halaman "Approval Kuota" dengan konteks "session:Pusat"
    And user mengklik tombol "Setujui kuota"
    And user mengklik tombol "Setujui Kuota"
    And user membuka halaman "Setting Kuota" dengan konteks "session:Cabang"
    And user mengklik tombol "Lanjut ke Jadwal"
    And user mengisi field "Waktu Berangkat" dengan "2026-10-10T12:00"
    And user mengisi field "Waktu Tiba" dengan "2026-10-11T08:00"
    And user mengklik tombol "Simpan"
    And user mengklik tombol "Masukkan Crew"
    And user mengklik tombol "Selesai"
    Then sistem memenuhi hasil "Urutan Kuota → Menunggu → Disetujui → Jadwal final → Crew final terpenuhi"
    And sistem memenuhi hasil "Voyage 214 berstatus Jadwal Tampil hanya setelah Selesai"

  @negative @priority-high @REQ-001 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-001 — Cabang tidak dapat melompati approval melalui tautan Jadwal
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota berstatus Menunggu"
    When user memeriksa elemen "Jadwal" dengan kondisi "locked; gate approval belum terpenuhi"
    And user memeriksa elemen "Crew List" dengan kondisi "locked; tidak ada data Jadwal/Crew baru"
    Then sistem memenuhi hasil "Jadwal dan Crew tetap terkunci meskipun route langsung dibuka"

  @positive @priority-high @REQ-002 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-002 — Pusat menyimpan kuota dan langsung membuka Jadwal
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; voyage sendiri belum memiliki kuota"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "400"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan" dengan "0"
    And user mengisi field "Kuota Internal — Ekonomi Lesehan (A)" dengan "40"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan (A)" dengan "0"
    And user mengisi field "Kuota Internal — Sepeda Motor (CC<250) (II-A)" dengan "15"
    And user mengisi field "Kuota Eksternal — Sepeda Motor (CC<250) (II-A)" dengan "0"
    And user mengisi field "Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "15"
    And user mengisi field "Kuota Eksternal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Sedang Standart (IV-B)" dengan "8"
    And user mengisi field "Kuota Eksternal — Truck/Bus Sedang Standart (IV-B)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Besar Standart (V-B)" dengan "6"
    And user mengisi field "Kuota Eksternal — Truck/Bus Besar Standart (V-B)" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Penumpang 10.000" dengan "20"
    And user mengisi field "Kuota Eksternal — Bagasi Penumpang 10.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 300.000" dengan "5"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 300.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 1.000.000" dengan "2"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 1.000.000" dengan "0"
    And user mengklik tombol "Simpan"
    And user mengklik tombol "Simpan"
    And user mengklik tombol "Lanjut ke Jadwal"
    And user memeriksa elemen "Jadwal" dengan kondisi "editable"
    And user membuka halaman "Approval Kuota"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "voyage 214 tidak menjadi pengajuan approval"
    Then sistem memenuhi hasil "Jadwal terbuka setelah kuota final"
    And sistem memenuhi hasil "Tidak ada pengajuan approval buatan Pusat"

  @negative @priority-high @REQ-002 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-002 — Kuota Pusat tidak lengkap tidak membuka Jadwal
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; seluruh isian awal kosong"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "10"
    And user memeriksa elemen "Simpan" dengan kondisi "disabled atau validasi field wajib"
    And user mengklik tombol "Jadwal"
    And user memeriksa elemen "Jadwal" dengan kondisi "locked"
    Then sistem memenuhi hasil "Final kuota tidak terjadi dan Jadwal tetap terkunci"

  @positive @priority-high @REQ-003 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-003 — Simpan Draft kuota parsial dan buka kembali
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; form kuota kosong"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "1"
    And user mengklik tombol "Simpan Draft"
    And user membuka halaman "Daftar Kuota & Jadwal"
    And user mengklik tombol "Edit"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "value=1"
    And user memeriksa elemen "Status" dengan kondisi "Isi Kuota"
    And user membuka halaman "Approval Kuota" dengan konteks "session:Pusat"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "voyage 214 absent"
    Then sistem memenuhi hasil "Nilai draft 1 persisten setelah buka kembali"
    And sistem memenuhi hasil "Belum ada pengajuan Pusat"

  @negative @priority-high @REQ-003 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-003 — Draft kuota seluruh isian kosong ditolak
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua 18 isian kosong"
    When user memeriksa elemen "Simpan Draft" dengan kondisi "disabled"
    And user memeriksa elemen "Status" dengan kondisi "tidak ada record draft persisten baru"
    Then sistem memenuhi hasil "Simpan Draft tidak menyimpan form tanpa satu pun data"

  @positive @priority-high @REQ-004 @screen-konfirmasi-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-004 — Pengajuan lengkap dikirim tepat satu kali ke Pusat
    Given user berada di halaman "Konfirmasi Pengajuan"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota lengkap valid sudah diisi; modal Simpan & Ajukan terbuka"
    When user memeriksa elemen "Total kuota" dengan kondisi "484 dari kapasitas 598"
    And user mengklik tombol "Ajukan ke Pusat"
    And user memeriksa elemen "Status Pengajuan" dengan kondisi "Menunggu"
    And user membuka halaman "Approval Kuota" dengan konteks "session:Pusat"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "tepat satu row voyage 214 dengan pembuat Suyanto"
    Then sistem memenuhi hasil "Pengajuan status Menunggu konsisten"
    And sistem memenuhi hasil "Semua nilai kuota sama antara form dan antrean"

  @negative @priority-high @REQ-004 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-004 — Simpan & Ajukan menolak satu field wajib kosong
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua isian valid kecuali V-B Eksternal kosong"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "400"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan" dengan "0"
    And user mengisi field "Kuota Internal — Ekonomi Lesehan (A)" dengan "40"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan (A)" dengan "0"
    And user mengisi field "Kuota Internal — Sepeda Motor (CC<250) (II-A)" dengan "15"
    And user mengisi field "Kuota Eksternal — Sepeda Motor (CC<250) (II-A)" dengan "0"
    And user mengisi field "Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "15"
    And user mengisi field "Kuota Eksternal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Sedang Standart (IV-B)" dengan "8"
    And user mengisi field "Kuota Eksternal — Truck/Bus Sedang Standart (IV-B)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Besar Standart (V-B)" dengan "6"
    And user mengisi field "Kuota Eksternal — Truck/Bus Besar Standart (V-B)" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Penumpang 10.000" dengan "20"
    And user mengisi field "Kuota Eksternal — Bagasi Penumpang 10.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 300.000" dengan "5"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 300.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 1.000.000" dengan "2"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 1.000.000" dengan "0"
    And user mengisi field "Kuota Eksternal — Truck/Bus Besar Standart (V-B)" dengan ""
    And user memeriksa elemen "Simpan & Ajukan" dengan kondisi "disabled atau validation error pada field kosong"
    Then sistem memenuhi hasil "Tidak ada pengajuan atau status Menunggu baru"

  @negative @priority-high @REQ-004 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-005 — Voyage tanpa metadata wajib tidak dapat diajukan
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; fixture metadata Kapal tidak tersedia; kuota numerik lengkap"
    When user memeriksa elemen "Kapal" dengan kondisi "wajib; metadata belum lengkap"
    And user memeriksa elemen "Simpan & Ajukan" dengan kondisi "disabled atau error metadata"
    Then sistem memenuhi hasil "Sistem menolak final/pengajuan sebelum metadata voyage lengkap"

  @positive @priority-high @REQ-005 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-005 — Cabang merevisi pengajuan Menunggu melalui pembatalan
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; pengajuan sendiri Menunggu; Ekonomi Internal=400"
    When user mengklik tombol "Batalkan Pengajuan"
    And user mengklik tombol "Batalkan Pengajuan"
    And user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "390"
    And user mengklik tombol "Simpan & Ajukan"
    And user mengklik tombol "Ajukan ke Pusat"
    And user memeriksa elemen "Status Pengajuan" dengan kondisi "Menunggu"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "value=390; read-only"
    Then sistem memenuhi hasil "Versi kuota revisi diajukan, gate Jadwal tetap tertutup"

  @negative @priority-high @REQ-005 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-006 — Isian Menunggu tidak menerima edit langsung
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; pengajuan Menunggu"
    When user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "disabled/read-only; value=400"
    And user memeriksa elemen "Lanjut ke Jadwal" dengan kondisi "disabled"
    And user memeriksa elemen "Crew List" dengan kondisi "locked"
    Then sistem memenuhi hasil "Nilai kuota tidak berubah selama belum dibatalkan"

  @positive @priority-high @REQ-006 @screen-approval-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-006 — Pusat memutuskan pengajuan terbaru berstatus Menunggu
    Given user berada di halaman "Approval Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; KQ2203 Menunggu versi 1"
    When user mengklik tombol "Lihat detail"
    And user mengklik tombol "Setujui Kuota"
    And user mengklik tombol "Setujui Kuota"
    And user memeriksa elemen "Pengajuan" dengan kondisi "KQ2203 Disetujui"
    Then sistem memenuhi hasil "Keputusan sah hanya dari Pusat terhadap versi Menunggu"

  @negative @priority-high @REQ-006 @screen-approval-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-007 — Cabang ditolak mengakses menu dan route Approval Kuota
    Given user berada di halaman "Approval Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; route Approval Kuota diminta langsung"
    When user memeriksa elemen "Approval Kuota" dengan kondisi "menu absent / akses ditolak"
    And user memeriksa elemen "Setujui kuota" dengan kondisi "absent"
    And user memeriksa elemen "Tolak kuota" dengan kondisi "absent"
    Then sistem memenuhi hasil "Cabang tidak dapat membaca antrean seluruh cabang atau memutuskan pengajuan"

  @negative @priority-high @REQ-006 @screen-detail-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-008 — Pusat tidak bisa Setujui atau Tolak pengajuan Disetujui
    Given user berada di halaman "Detail Pengajuan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; KQ2203 berstatus Disetujui"
    When user memeriksa elemen "Setujui Kuota" dengan kondisi "absent/disabled"
    And user memeriksa elemen "Tolak" dengan kondisi "absent/disabled"
    And user memeriksa elemen "Riwayat" dengan kondisi "tidak bertambah keputusan baru"
    Then sistem memenuhi hasil "Status Disetujui dan audit sebelumnya tetap"

  @negative @priority-high @REQ-006 @screen-detail-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-009 — Pusat tidak bisa Setujui atau Tolak pengajuan Ditolak
    Given user berada di halaman "Detail Pengajuan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; KQ2203 berstatus Ditolak"
    When user memeriksa elemen "Setujui Kuota" dengan kondisi "absent/disabled"
    And user memeriksa elemen "Tolak" dengan kondisi "absent/disabled"
    And user memeriksa elemen "Riwayat" dengan kondisi "tidak bertambah keputusan baru"
    Then sistem memenuhi hasil "Status Ditolak dan audit sebelumnya tetap"

  @negative @priority-high @REQ-006 @screen-detail-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-010 — Pusat tidak bisa Setujui atau Tolak pengajuan Dibatalkan
    Given user berada di halaman "Detail Pengajuan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; KQ2203 berstatus Dibatalkan"
    When user memeriksa elemen "Setujui Kuota" dengan kondisi "absent/disabled"
    And user memeriksa elemen "Tolak" dengan kondisi "absent/disabled"
    And user memeriksa elemen "Riwayat" dengan kondisi "tidak bertambah keputusan baru"
    Then sistem memenuhi hasil "Status Dibatalkan dan audit sebelumnya tetap"

  @positive @priority-high @REQ-007 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-007 — Approve merekam aktor waktu dan membuka Jadwal Cabang
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal approval KQ2203 Menunggu total 484"
    When user mengklik tombol "Setujui Kuota"
    And user membuka halaman "Detail Pengajuan"
    And user memeriksa elemen "Riwayat" dengan kondisi "approval Achmad Riyanto; timestamp server berada dalam interval aksi"
    And user membuka halaman "Setting Kuota" dengan konteks "session:Cabang"
    And user memeriksa elemen "Status Pengajuan" dengan kondisi "Disetujui"
    And user memeriksa elemen "Lanjut ke Jadwal" dengan kondisi "enabled"
    Then sistem memenuhi hasil "Status approval sama pada sesi Pusat/Cabang"
    And sistem memenuhi hasil "Audit mencatat user dan waktu aktual, bukan tanggal hardcoded desain"

  @negative @priority-high @REQ-007 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-011 — Approve gagal tidak mencatat sukses atau membuka Jadwal
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; KQ2203 Menunggu; fixture server approve gagal 500"
    When user mengklik tombol "Setujui Kuota"
    And user memeriksa elemen "Setujui Kuota" dengan kondisi "error dapat dipulihkan"
    And user membuka halaman "Setting Kuota" dengan konteks "session:Cabang"
    And user memeriksa elemen "Status Pengajuan" dengan kondisi "Menunggu"
    And user memeriksa elemen "Lanjut ke Jadwal" dengan kondisi "disabled"
    Then sistem memenuhi hasil "Tidak ada status/audit approval sukses ketika transaksi gagal"

  @positive @priority-high @REQ-008 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-008 — Reject menyimpan alasan aktor timestamp dan sinkron ke Cabang
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal Tolak Pengajuan Kuota KQ2203 Menunggu"
    When user mengisi field "Alasan Penolakan" dengan "  Kuota IV-B perlu dikurangi  "
    And user mengklik tombol "Tolak Pengajuan"
    And user membuka halaman "Detail Pengajuan"
    And user memeriksa elemen "Alasan Penolakan" dengan kondisi "Kuota IV-B perlu dikurangi"
    And user memeriksa elemen "Ditolak Oleh" dengan kondisi "Achmad Riyanto"
    And user memeriksa elemen "Tanggal & Waktu Penolakan" dengan kondisi "timestamp aktual dalam interval aksi"
    And user membuka halaman "Setting Kuota" dengan konteks "session:Cabang"
    And user memeriksa elemen "Status Pengajuan" dengan kondisi "Ditolak"
    Then sistem memenuhi hasil "Alasan trim disimpan dan sama di Pusat/Cabang"
    And sistem memenuhi hasil "User/waktu reject tersedia; Jadwal tetap terkunci"

  @negative @priority-high @REQ-008 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-012 — Reject dengan alasan kosong tidak dapat dikonfirmasi
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal reject pengajuan Menunggu"
    When user mengisi field "Alasan Penolakan" dengan ""
    And user memeriksa elemen "Tolak Pengajuan" dengan kondisi "disabled"
    And user memeriksa elemen "Pengajuan" dengan kondisi "status masih Menunggu"
    Then sistem memenuhi hasil "Tidak ada keputusan reject tanpa alasan nonblank"

  @negative @priority-high @REQ-008 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-013 — Reject dengan alasan whitespace tidak dapat dikonfirmasi
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal reject pengajuan Menunggu"
    When user mengisi field "Alasan Penolakan" dengan "   \t\n"
    And user memeriksa elemen "Tolak Pengajuan" dengan kondisi "disabled"
    And user memeriksa elemen "Pengajuan" dengan kondisi "status masih Menunggu"
    Then sistem memenuhi hasil "Tidak ada keputusan reject tanpa alasan nonblank"

  @positive @priority-high @REQ-009 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-009 — Revisi Ditolak dan ajukan ulang tanpa voyage baru
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; voyage 214 Ditolak karena kuota IV-B"
    When user mengisi field "Kuota Internal — Truck/Bus Sedang Standart (IV-B)" dengan "7"
    And user mengklik tombol "Simpan & Ajukan Ulang"
    And user mengklik tombol "Ajukan ke Pusat"
    And user memeriksa elemen "Nomor Voyage" dengan kondisi "214"
    And user memeriksa elemen "Status Pengajuan" dengan kondisi "Menunggu"
    And user membuka halaman "Detail Pengajuan" dengan konteks "session:Pusat"
    And user memeriksa elemen "Riwayat" dengan kondisi "penolakan lama dan pengajuan ulang tetap ada"
    Then sistem memenuhi hasil "Revisi memakai voyage yang sama dan menunggu keputusan baru"

  @negative @priority-high @REQ-009 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-014 — Ajukan ulang Ditolak dengan data invalid ditolak
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota Ditolak; satu isian wajib dikosongkan"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan ""
    And user memeriksa elemen "Simpan & Ajukan Ulang" dengan kondisi "disabled atau validation error"
    And user memeriksa elemen "Status Pengajuan" dengan kondisi "Ditolak"
    Then sistem memenuhi hasil "Status tidak berubah dan tidak ada pengajuan Menunggu baru"

  @positive @priority-high @REQ-010 @screen-konfirmasi-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-010 — Pembuat membatalkan Menunggu dan Pusat tidak dapat memutuskan
    Given user berada di halaman "Konfirmasi Pengajuan"
    And kondisi awal "Cabang Balikpapan / Suyanto; modal Batalkan Pengajuan sendiri Menunggu terbuka"
    When user mengklik tombol "Batalkan Pengajuan"
    And user membuka halaman "Approval Kuota" dengan konteks "session:Pusat"
    And user mengklik tombol "Dibatalkan"
    And user mengklik tombol "Lihat detail"
    And user memeriksa elemen "Pengajuan" dengan kondisi "Dibatalkan"
    And user memeriksa elemen "Setujui Kuota" dengan kondisi "absent"
    And user memeriksa elemen "Tolak" dengan kondisi "absent"
    Then sistem memenuhi hasil "Pengajuan keluar dari kandidat Menunggu dan tidak dapat diputuskan"

  @negative @priority-high @REQ-010 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-015 — Pembatalan kuota approved ditolak
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota Disetujui"
    When user memeriksa elemen "Batalkan Pengajuan" dengan kondisi "absent/disabled"
    And user memeriksa elemen "Status Pengajuan" dengan kondisi "Disetujui"
    Then sistem memenuhi hasil "Tidak ada pembatalan pengajuan setelah keputusan approval"

  @negative @priority-high @REQ-010 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-016 — Cabang lain tidak dapat membatalkan pengajuan pembuat
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Surabaya membuka pengajuan Menunggu milik Cabang Balikpapan"
    When user memeriksa elemen "Status Pengajuan" dengan kondisi "akses ditolak"
    And user memeriksa elemen "Batalkan Pengajuan" dengan kondisi "absent"
    Then sistem memenuhi hasil "Data dan status pembuat tidak berubah"

  @positive @priority-high @REQ-011 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-011 — Dibatalkan mempertahankan kuota untuk revisi dan ajukan ulang
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; pengajuan dibatalkan dengan kuota Ekonomi=400"
    When user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "value=400; editable"
    And user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "395"
    And user mengklik tombol "Simpan & Ajukan"
    And user mengklik tombol "Ajukan ke Pusat"
    And user memeriksa elemen "Status Pengajuan" dengan kondisi "Menunggu"
    And user membuka halaman "Detail Pengajuan" dengan konteks "session:Pusat"
    And user memeriksa elemen "Riwayat" dengan kondisi "pembatalan lama tetap tercatat"
    Then sistem memenuhi hasil "Nilai lama dipakai ulang tanpa membuat voyage baru; audit tidak hilang"

  @negative @priority-high @REQ-011 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-017 — Draft bekas pembatalan tidak dapat langsung membuka Jadwal
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; pengajuan Dibatalkan; isian lengkap tetap tersimpan"
    When user mengklik tombol "Jadwal"
    And user memeriksa elemen "Jadwal" dengan kondisi "locked"
    And user memeriksa elemen "Crew List" dengan kondisi "locked"
    Then sistem memenuhi hasil "Isian lengkap bekas pembatalan tetap membutuhkan pengajuan dan approval baru"

  @positive @priority-high @REQ-012 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-012 — Pusat mengedit kuota approved dengan nilai valid
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; hak edit existing; kuota Cabang sudah Disetujui"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "390"
    And user mengklik tombol "Simpan"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "value=390 setelah reload"
    And user membuka halaman "Setting Kuota" dengan konteks "session:Cabang"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "value=390; read-only"
    Then sistem memenuhi hasil "Perubahan sah Pusat persisten dan tetap read-only untuk Cabang"

  @negative @priority-high @REQ-012 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-018 — Cabang tidak dapat mengedit kuota setelah approval
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota Disetujui; awal Ekonomi=400"
    When user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "read-only/disabled; value=400"
    And user memeriksa elemen "Simpan & Ajukan" dengan kondisi "absent"
    And user memeriksa elemen "Lanjut ke Jadwal" dengan kondisi "enabled"
    Then sistem memenuhi hasil "Kuota approved tidak berubah oleh Cabang; Jadwal tetap dapat diisi"

  @positive @priority-high @REQ-013 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-013 — Jadwal valid disimpan dan membuka Crew
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota Disetujui"
    When user mengisi field "Waktu Berangkat" dengan "2026-10-10T12:00"
    And user mengisi field "Waktu Tiba" dengan "2026-10-11T08:00"
    And user mengklik tombol "Simpan"
    And user memeriksa elemen "Crew List" dengan kondisi "editable"
    And user memeriksa elemen "Pelabuhan Asal" dengan kondisi "Parepare (PAP)"
    And user memeriksa elemen "Pelabuhan Tujuan" dengan kondisi "Balikpapan (BPN)"
    Then sistem memenuhi hasil "Jadwal final dengan urutan waktu dan pelabuhan benar"

  @negative @priority-high @REQ-013 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-019 — Final Jadwal ditolak saat berangkat kosong
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota Disetujui"
    When user mengisi field "Waktu Berangkat" dengan ""
    And user mengisi field "Waktu Tiba" dengan "2026-10-11T08:00"
    And user memeriksa elemen "Simpan" dengan kondisi "disabled atau validation error"
    And user mengklik tombol "Crew List"
    And user memeriksa elemen "Crew List" dengan kondisi "locked"
    Then sistem memenuhi hasil "Jadwal tidak final; Crew tetap terkunci"

  @negative @priority-high @REQ-013 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-020 — Final Jadwal ditolak saat tiba kosong
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota Disetujui"
    When user mengisi field "Waktu Berangkat" dengan "2026-10-10T12:00"
    And user mengisi field "Waktu Tiba" dengan ""
    And user memeriksa elemen "Simpan" dengan kondisi "disabled atau validation error"
    And user mengklik tombol "Crew List"
    And user memeriksa elemen "Crew List" dengan kondisi "locked"
    Then sistem memenuhi hasil "Jadwal tidak final; Crew tetap terkunci"

  @negative @priority-high @REQ-013 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-021 — Final Jadwal ditolak saat tiba lebih awal
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota Disetujui"
    When user mengisi field "Waktu Berangkat" dengan "2026-10-10T12:00"
    And user mengisi field "Waktu Tiba" dengan "2026-10-10T11:59"
    And user memeriksa elemen "Waktu tiba harus setelah waktu berangkat." dengan kondisi "visible"
    And user memeriksa elemen "Simpan" dengan kondisi "disabled atau validation error"
    And user mengklik tombol "Crew List"
    And user memeriksa elemen "Crew List" dengan kondisi "locked"
    Then sistem memenuhi hasil "Jadwal tidak final; Crew tetap terkunci"

  @negative @priority-high @REQ-013 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-022 — Final Jadwal ditolak saat tiba sama dengan berangkat
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota Disetujui"
    When user mengisi field "Waktu Berangkat" dengan "2026-10-10T12:00"
    And user mengisi field "Waktu Tiba" dengan "2026-10-10T12:00"
    And user memeriksa elemen "Waktu tiba harus setelah waktu berangkat." dengan kondisi "visible"
    And user memeriksa elemen "Simpan" dengan kondisi "disabled atau validation error"
    And user mengklik tombol "Crew List"
    And user memeriksa elemen "Crew List" dengan kondisi "locked"
    Then sistem memenuhi hasil "Jadwal tidak final; Crew tetap terkunci"

  @positive @priority-high @REQ-014 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-014 — Draft parsial setting-jadwal untuk Cabang Balikpapan tidak final
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; step setting-jadwal terbuka dengan data awal kosong"
    When user mengisi field "Waktu Berangkat" dengan "2026-10-10T12:00"
    And user mengklik tombol "Simpan Draft"
    And user membuka halaman "Daftar Kuota & Jadwal"
    And user mengklik tombol "Edit"
    And user memeriksa elemen "Status" dengan kondisi "step terkait belum final; nilai parsial persisten"
    Then sistem memenuhi hasil "Draft disimpan dengan minimal satu data tanpa membuka gate berikutnya"

  @positive @priority-high @REQ-014 @screen-crew-list
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-015 — Draft parsial crew-list untuk Cabang Balikpapan tidak final
    Given user berada di halaman "Crew List"
    And kondisi awal "Cabang Balikpapan / Suyanto; step crew-list terbuka dengan data awal kosong; fixture satu crew parsial sudah dipilih melalui dialog existing"
    When user mengklik tombol "Simpan Draft"
    And user membuka halaman "Daftar Kuota & Jadwal"
    And user mengklik tombol "Edit"
    And user memeriksa elemen "Status" dengan kondisi "step terkait belum final; nilai parsial persisten"
    Then sistem memenuhi hasil "Draft disimpan dengan minimal satu data tanpa membuka gate berikutnya"

  @negative @priority-high @REQ-014 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-023 — Draft kosong setting-jadwal untuk Cabang Balikpapan ditolak
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; step terbuka; tidak ada satu data terisi"
    When user memeriksa elemen "Simpan Draft" dengan kondisi "disabled"
    And user memeriksa elemen "Status" dengan kondisi "step belum final"
    Then sistem memenuhi hasil "Tidak ada draft kosong baru"

  @negative @priority-high @REQ-014 @screen-crew-list
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-024 — Draft kosong crew-list untuk Cabang Balikpapan ditolak
    Given user berada di halaman "Crew List"
    And kondisi awal "Cabang Balikpapan / Suyanto; step terbuka; tidak ada satu data terisi"
    When user memeriksa elemen "Simpan Draft" dengan kondisi "disabled"
    And user memeriksa elemen "Status" dengan kondisi "step belum final"
    Then sistem memenuhi hasil "Tidak ada draft kosong baru"

  @positive @priority-high @REQ-014 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-016 — Draft parsial setting-kuota untuk Kantor Pusat tidak final
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; step setting-kuota terbuka dengan data awal kosong"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "1"
    And user mengklik tombol "Simpan Draft"
    And user membuka halaman "Daftar Kuota & Jadwal"
    And user mengklik tombol "Edit"
    And user memeriksa elemen "Status" dengan kondisi "step terkait belum final; nilai parsial persisten"
    Then sistem memenuhi hasil "Draft disimpan dengan minimal satu data tanpa membuka gate berikutnya"

  @positive @priority-high @REQ-014 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-017 — Draft parsial setting-jadwal untuk Kantor Pusat tidak final
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; step setting-jadwal terbuka dengan data awal kosong"
    When user mengisi field "Waktu Berangkat" dengan "2026-10-10T12:00"
    And user mengklik tombol "Simpan Draft"
    And user membuka halaman "Daftar Kuota & Jadwal"
    And user mengklik tombol "Edit"
    And user memeriksa elemen "Status" dengan kondisi "step terkait belum final; nilai parsial persisten"
    Then sistem memenuhi hasil "Draft disimpan dengan minimal satu data tanpa membuka gate berikutnya"

  @positive @priority-high @REQ-014 @screen-crew-list
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-018 — Draft parsial crew-list untuk Kantor Pusat tidak final
    Given user berada di halaman "Crew List"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; step crew-list terbuka dengan data awal kosong; fixture satu crew parsial sudah dipilih melalui dialog existing"
    When user mengklik tombol "Simpan Draft"
    And user membuka halaman "Daftar Kuota & Jadwal"
    And user mengklik tombol "Edit"
    And user memeriksa elemen "Status" dengan kondisi "step terkait belum final; nilai parsial persisten"
    Then sistem memenuhi hasil "Draft disimpan dengan minimal satu data tanpa membuka gate berikutnya"

  @negative @priority-high @REQ-014 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-025 — Draft kosong setting-jadwal untuk Kantor Pusat ditolak
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; step terbuka; tidak ada satu data terisi"
    When user memeriksa elemen "Simpan Draft" dengan kondisi "disabled"
    And user memeriksa elemen "Status" dengan kondisi "step belum final"
    Then sistem memenuhi hasil "Tidak ada draft kosong baru"

  @negative @priority-high @REQ-014 @screen-crew-list
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-026 — Draft kosong crew-list untuk Kantor Pusat ditolak
    Given user berada di halaman "Crew List"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; step terbuka; tidak ada satu data terisi"
    When user memeriksa elemen "Simpan Draft" dengan kondisi "disabled"
    And user memeriksa elemen "Status" dengan kondisi "step belum final"
    Then sistem memenuhi hasil "Tidak ada draft kosong baru"

  @positive @priority-high @REQ-015 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-019 — Crew terbuka hanya setelah Jadwal lengkap disimpan final
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota Disetujui; jadwal belum final"
    When user mengisi field "Waktu Berangkat" dengan "2026-10-10T12:00"
    And user mengisi field "Waktu Tiba" dengan "2026-10-11T08:00"
    And user mengklik tombol "Simpan"
    And user memeriksa elemen "Crew List" dengan kondisi "enabled/open"
    Then sistem memenuhi hasil "Field lengkap dan simpan final memenuhi gate Crew"

  @negative @priority-high @REQ-015 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-027 — Jadwal lengkap yang hanya disimpan draft tidak membuka Crew
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota Disetujui; Jadwal belum pernah final"
    When user mengisi field "Waktu Berangkat" dengan "2026-10-10T12:00"
    And user mengisi field "Waktu Tiba" dengan "2026-10-11T08:00"
    And user mengklik tombol "Simpan Draft"
    And user membuka halaman "Crew List"
    And user memeriksa elemen "Crew List" dengan kondisi "locked; simpan jadwal terlebih dahulu"
    Then sistem memenuhi hasil "Draft Jadwal lengkap tetap bukan final"

  @negative @priority-high @REQ-015 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-028 — Field Jadwal lengkap tanpa simpan tidak membuka Crew
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota Disetujui; Jadwal belum final"
    When user mengisi field "Waktu Berangkat" dengan "2026-10-10T12:00"
    And user mengisi field "Waktu Tiba" dengan "2026-10-11T08:00"
    And user mengklik tombol "Crew List"
    And user memeriksa elemen "Crew List" dengan kondisi "locked"
    Then sistem memenuhi hasil "Mengisi seluruh field saja tidak memenuhi syarat simpan final"

  @positive @priority-high @REQ-016 @screen-crew-list
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-020 — Crew lengkap difinalisasi dengan Selesai
    Given user berada di halaman "Crew List"
    And kondisi awal "Cabang Balikpapan / Suyanto; Kuota approved dan Jadwal final; dialog existing crew berisi 12 crew valid"
    When user mengklik tombol "Masukkan Crew"
    And user memeriksa elemen "Crew List" dengan kondisi "12 crew valid pada rute voyage"
    And user mengklik tombol "Selesai"
    And user membuka halaman "Daftar Kuota & Jadwal"
    And user memeriksa elemen "Status" dengan kondisi "Jadwal Tampil"
    Then sistem memenuhi hasil "Final semua step tersimpan dan jadwal aktif"

  @negative @priority-high @REQ-016 @screen-crew-list
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-029 — Crew parsial tidak dapat difinalisasi
    Given user berada di halaman "Crew List"
    And kondisi awal "Cabang Balikpapan / Suyanto; Jadwal final; fixture hanya satu crew dengan data mandatory belum lengkap"
    When user memeriksa elemen "Selesai" dengan kondisi "disabled atau validasi crew"
    And user memeriksa elemen "Status" dengan kondisi "Isi Crew List"
    Then sistem memenuhi hasil "Crew belum final dan jadwal belum tampil"

  @positive @priority-high @REQ-017 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-021 — Progress daftar mengikuti tahap final tersimpan
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Balikpapan / Suyanto; fixture voyage berbeda untuk sembilan keadaan proses"
    When user memeriksa elemen "Status" dengan kondisi "Isi Kuota / Menunggu / Disetujui / Ditolak / Isi Jadwal / Isi Crew List / Dibatalkan / Jadwal Tampil / Jadwal Tutup sesuai fixture"
    Then sistem memenuhi hasil "Setiap record menampilkan progress sesuai state approval dan step persisten"

  @negative @priority-high @REQ-017 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-030 — Crew draft tidak membuat status Jadwal Tampil
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota approved; Jadwal final; Crew disimpan draft"
    When user memeriksa elemen "Status" dengan kondisi "Isi Crew List; bukan Jadwal Tampil"
    And user mengklik tombol "Lihat detail"
    And user mengklik tombol "Crew List"
    And user memeriksa elemen "Crew List" dengan kondisi "draft; belum final"
    Then sistem memenuhi hasil "Status tidak maju sebelum Crew final"

  @positive @priority-high @REQ-018 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-022 — Status Jadwal tersembunyi saat pembuatan
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; membuat jadwal pertama setelah approval"
    When user memeriksa elemen "Status Jadwal" dengan kondisi "absent"
    And user memeriksa elemen "Waktu Berangkat" dengan kondisi "editable"
    And user memeriksa elemen "Waktu Tiba" dengan kondisi "editable"
    Then sistem memenuhi hasil "Form buat tidak menampilkan pilihan Status Jadwal"

  @positive @priority-high @REQ-018 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-023 — Edit hanya menawarkan Jadwal Tampil dan Jadwal Tutup
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; jadwal existing final; hak edit existing"
    When user memeriksa elemen "Status Jadwal" dengan kondisi "options exactly Jadwal Tampil,Jadwal Tutup"
    And user memilih opsi "Jadwal Tutup" pada dropdown "Status Jadwal"
    And user mengklik tombol "Simpan"
    And user membuka halaman "Daftar Kuota & Jadwal"
    And user memeriksa elemen "Status" dengan kondisi "Jadwal Tutup"
    Then sistem memenuhi hasil "Status edit tersimpan sesuai dua pilihan existing"

  @negative @priority-high @REQ-018 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-031 — Status approval tidak diterima sebagai Status Jadwal edit
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; edit jadwal existing; fixture request override status jadwal=Menunggu"
    When user memeriksa elemen "Status Jadwal" dengan kondisi "tidak memiliki opsi Menunggu,Ditolak,Dibatalkan"
    And user mengklik tombol "Simpan"
    And user memeriksa elemen "Status Jadwal" dengan kondisi "validasi status invalid; status persisten tetap Jadwal Tampil"
    Then sistem memenuhi hasil "Nilai status approval tidak dapat disimpan sebagai status jadwal"

  @positive @priority-high @REQ-019 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-024 — Pembuat dapat melihat draft sendiri dan melanjutkan
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Balikpapan / Suyanto; draft voyage 214 sendiri tersimpan"
    When user mengklik tombol "Lihat detail"
    And user mengklik tombol "Kuota"
    And user memeriksa elemen "Kuota" dengan kondisi "isian draft sendiri"
    And user mengklik tombol "Edit"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "editable"
    Then sistem memenuhi hasil "Draft terlihat dan editable hanya untuk pembuat"

  @negative @priority-high @REQ-019 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-032 — Cabang lain tidak dapat melihat voyage belum selesai Isi Kuota
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Surabaya; voyage 214 milik Cabang Balikpapan dalam progress Isi Kuota"
    When user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "voyage 214 absent"
    And user membuka halaman "Setting Kuota" dengan konteks "direct voyage 214"
    And user memeriksa elemen "Kuota" dengan kondisi "akses ditolak tanpa bocoran nilai"
    Then sistem memenuhi hasil "Record belum selesai milik Cabang lain tidak terekspos"

  @negative @priority-high @REQ-019 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-033 — Cabang lain tidak dapat melihat voyage belum selesai Menunggu
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Surabaya; voyage 214 milik Cabang Balikpapan dalam progress Menunggu"
    When user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "voyage 214 absent"
    And user membuka halaman "Setting Kuota" dengan konteks "direct voyage 214"
    And user memeriksa elemen "Kuota" dengan kondisi "akses ditolak tanpa bocoran nilai"
    Then sistem memenuhi hasil "Record belum selesai milik Cabang lain tidak terekspos"

  @negative @priority-high @REQ-019 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-034 — Cabang lain tidak dapat melihat voyage belum selesai Disetujui
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Surabaya; voyage 214 milik Cabang Balikpapan dalam progress Disetujui"
    When user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "voyage 214 absent"
    And user membuka halaman "Setting Kuota" dengan konteks "direct voyage 214"
    And user memeriksa elemen "Kuota" dengan kondisi "akses ditolak tanpa bocoran nilai"
    Then sistem memenuhi hasil "Record belum selesai milik Cabang lain tidak terekspos"

  @negative @priority-high @REQ-019 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-035 — Cabang lain tidak dapat melihat voyage belum selesai Isi Jadwal
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Surabaya; voyage 214 milik Cabang Balikpapan dalam progress Isi Jadwal"
    When user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "voyage 214 absent"
    And user membuka halaman "Setting Kuota" dengan konteks "direct voyage 214"
    And user memeriksa elemen "Kuota" dengan kondisi "akses ditolak tanpa bocoran nilai"
    Then sistem memenuhi hasil "Record belum selesai milik Cabang lain tidak terekspos"

  @negative @priority-high @REQ-019 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-036 — Cabang lain tidak dapat melihat voyage belum selesai Isi Crew List
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Surabaya; voyage 214 milik Cabang Balikpapan dalam progress Isi Crew List"
    When user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "voyage 214 absent"
    And user membuka halaman "Setting Kuota" dengan konteks "direct voyage 214"
    And user memeriksa elemen "Kuota" dengan kondisi "akses ditolak tanpa bocoran nilai"
    Then sistem memenuhi hasil "Record belum selesai milik Cabang lain tidak terekspos"

  @negative @priority-high @REQ-019 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-037 — Cabang lain tidak dapat melihat voyage belum selesai Ditolak
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Surabaya; voyage 214 milik Cabang Balikpapan dalam progress Ditolak"
    When user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "voyage 214 absent"
    And user membuka halaman "Setting Kuota" dengan konteks "direct voyage 214"
    And user memeriksa elemen "Kuota" dengan kondisi "akses ditolak tanpa bocoran nilai"
    Then sistem memenuhi hasil "Record belum selesai milik Cabang lain tidak terekspos"

  @negative @priority-high @REQ-019 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-038 — Cabang lain tidak dapat melihat voyage belum selesai Dibatalkan
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Surabaya; voyage 214 milik Cabang Balikpapan dalam progress Dibatalkan"
    When user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "voyage 214 absent"
    And user membuka halaman "Setting Kuota" dengan konteks "direct voyage 214"
    And user memeriksa elemen "Kuota" dengan kondisi "akses ditolak tanpa bocoran nilai"
    Then sistem memenuhi hasil "Record belum selesai milik Cabang lain tidak terekspos"

  @positive @priority-high @REQ-020 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-025 — Pusat melihat data sendiri pengajuan dan jadwal selesai
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; fixture draft Pusat, pengajuan Cabang Menunggu, jadwal selesai Cabang tersedia"
    When user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "ketiga record terlihat"
    And user membuka halaman "Approval Kuota"
    And user mengklik tombol "Menunggu Approval"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "pengajuan Cabang yang membutuhkan approval terlihat"
    Then sistem memenuhi hasil "Visibility Pusat mencakup data sesuai spec"

  @negative @priority-high @REQ-020 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-039 — Draft Cabang belum diajukan tersembunyi dari Pusat
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; Cabang hanya menyimpan Draft kuota voyage 214"
    When user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "voyage 214 absent"
    And user membuka halaman "Approval Kuota"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "voyage 214 absent"
    And user membuka halaman "Setting Kuota" dengan konteks "direct voyage 214"
    And user memeriksa elemen "Kuota" dengan kondisi "akses ditolak"
    Then sistem memenuhi hasil "Draft murni Cabang tidak menjadi pengajuan atau data Pusat"

  @positive @priority-high @REQ-021 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-026 — Jadwal seluruh step final terlihat role existing berhak
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Surabaya memiliki hak melihat jadwal existing; voyage Balikpapan semua step final"
    When user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "voyage 214 terlihat"
    And user mengklik tombol "Lihat detail"
    And user mengklik tombol "Jadwal"
    And user memeriksa elemen "Status" dengan kondisi "Jadwal Tampil"
    And user mengklik tombol "Crew List"
    And user memeriksa elemen "Crew List" dengan kondisi "12 crew final"
    And user mengklik tombol "Kuota"
    And user memeriksa elemen "Kuota" dengan kondisi "nilai approved/final"
    Then sistem memenuhi hasil "Jadwal selesai terpublikasi ke role existing yang berhak"

  @negative @priority-high @REQ-021 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-040 — Role tanpa hak tetap ditolak meski jadwal final
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Role tanpa permission Kuota & Jadwal membuka route final voyage"
    When user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "akses ditolak"
    And user memeriksa elemen "Jadwal" dengan kondisi "data voyage tidak bocor"
    Then sistem memenuhi hasil "Finalisasi tidak memberikan hak baru kepada role unauthorized"

  @positive @priority-high @REQ-022 @screen-detail-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-027 — Riwayat menampilkan rangkaian reject resubmit cancel dan approve
    Given user berada di halaman "Detail Pengajuan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; fixture voyage punya empat siklus dengan keputusan/history tersimpan"
    When user memeriksa elemen "Riwayat" dengan kondisi "semua pengajuan, reject+alasan, resubmit, pembatalan, approve; actor dan timestamp per event"
    Then sistem memenuhi hasil "Riwayat kronologis lengkap tetap tersedia sesuai status"

  @edge @priority-high @REQ-022 @screen-konfirmasi-hapus
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-001 — Penghapusan dari daftar tidak menghilangkan audit penolakan
    Given user berada di halaman "Konfirmasi Hapus"
    And kondisi awal "Cabang Balikpapan / Suyanto; pengajuan Ditolak; hak hapus existing; modal Hapus Pengajuan Ditolak terbuka"
    When user memeriksa elemen "Hapus Pengajuan Ditolak" dengan kondisi "dialog menunjukkan voyage tepat"
    And user mengklik tombol "Hapus"
    And user membuka halaman "Approval Kuota" dengan konteks "session:Pusat"
    And user mengklik tombol "Ditolak"
    And user mengklik tombol "Lihat detail"
    And user memeriksa elemen "Riwayat" dengan kondisi "audit reject actor timestamp alasan tetap ada"
    Then sistem memenuhi hasil "Hapus dari daftar tidak menghapus history wajib approval"

  @positive @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-028 — Kuota numerik valid untuk seluruh golongan dan bagasi
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; form baru"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "400"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan" dengan "0"
    And user mengisi field "Kuota Internal — Ekonomi Lesehan (A)" dengan "40"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan (A)" dengan "0"
    And user mengisi field "Kuota Internal — Sepeda Motor (CC<250) (II-A)" dengan "15"
    And user mengisi field "Kuota Eksternal — Sepeda Motor (CC<250) (II-A)" dengan "0"
    And user mengisi field "Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "15"
    And user mengisi field "Kuota Eksternal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Sedang Standart (IV-B)" dengan "8"
    And user mengisi field "Kuota Eksternal — Truck/Bus Sedang Standart (IV-B)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Besar Standart (V-B)" dengan "6"
    And user mengisi field "Kuota Eksternal — Truck/Bus Besar Standart (V-B)" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Penumpang 10.000" dengan "20"
    And user mengisi field "Kuota Eksternal — Bagasi Penumpang 10.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 300.000" dengan "5"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 300.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 1.000.000" dengan "2"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 1.000.000" dengan "0"
    And user mengklik tombol "Simpan Draft"
    And user membuka halaman "Setting Kuota"
    And user memeriksa elemen "Total kuota" dengan kondisi "484"
    Then sistem memenuhi hasil "Seluruh 18 isian numerik tersimpan sesuai distribusi"

  @negative @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-041 — Kuota negatif ditolak tanpa mengubah makna nilai
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; isian lain lengkap valid"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "-1"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "invalid atau input ditolak; tidak tersimpan sebagai nilai lain"
    And user memeriksa elemen "Simpan & Ajukan" dengan kondisi "tidak mengajukan nilai invalid"
    Then sistem memenuhi hasil "Input tidak valid tidak menjadi kuota lain akibat strip/truncate diam-diam"

  @negative @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-042 — Kuota pecahan ditolak tanpa mengubah makna nilai
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; isian lain lengkap valid"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "1.5"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "invalid atau input ditolak; tidak tersimpan sebagai nilai lain"
    And user memeriksa elemen "Simpan & Ajukan" dengan kondisi "tidak mengajukan nilai invalid"
    Then sistem memenuhi hasil "Input tidak valid tidak menjadi kuota lain akibat strip/truncate diam-diam"

  @negative @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-043 — Kuota huruf ditolak tanpa mengubah makna nilai
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; isian lain lengkap valid"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "abc"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "invalid atau input ditolak; tidak tersimpan sebagai nilai lain"
    And user memeriksa elemen "Simpan & Ajukan" dengan kondisi "tidak mengajukan nilai invalid"
    Then sistem memenuhi hasil "Input tidak valid tidak menjadi kuota lain akibat strip/truncate diam-diam"

  @negative @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-044 — Kuota notasi eksponen ditolak tanpa mengubah makna nilai
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; isian lain lengkap valid"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "1e3"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "invalid atau input ditolak; tidak tersimpan sebagai nilai lain"
    And user memeriksa elemen "Simpan & Ajukan" dengan kondisi "tidak mengajukan nilai invalid"
    Then sistem memenuhi hasil "Input tidak valid tidak menjadi kuota lain akibat strip/truncate diam-diam"

  @negative @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-045 — Kuota lima digit ditolak tanpa mengubah makna nilai
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; isian lain lengkap valid"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "10000"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "invalid atau input ditolak; tidak tersimpan sebagai nilai lain"
    And user memeriksa elemen "Simpan & Ajukan" dengan kondisi "tidak mengajukan nilai invalid"
    Then sistem memenuhi hasil "Input tidak valid tidak menjadi kuota lain akibat strip/truncate diam-diam"

  @negative @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-046 — Kuota digit fullwidth ditolak tanpa mengubah makna nilai
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; isian lain lengkap valid"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "１２"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "invalid atau input ditolak; tidak tersimpan sebagai nilai lain"
    And user memeriksa elemen "Simpan & Ajukan" dengan kondisi "tidak mengajukan nilai invalid"
    Then sistem memenuhi hasil "Input tidak valid tidak menjadi kuota lain akibat strip/truncate diam-diam"

  @positive @priority-high @REQ-024 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-029 — Total internal eksternal subtotal dan bagasi dihitung tepat
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; seluruh isian awal kosong"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "400"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan" dengan "50"
    And user mengisi field "Kuota Internal — Ekonomi Lesehan (A)" dengan "40"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan (A)" dengan "10"
    And user mengisi field "Kuota Internal — Sepeda Motor (CC<250) (II-A)" dengan "15"
    And user mengisi field "Kuota Eksternal — Sepeda Motor (CC<250) (II-A)" dengan "3"
    And user mengisi field "Kuota Internal — Bagasi Penumpang 10.000" dengan "20"
    And user mengisi field "Kuota Eksternal — Bagasi Penumpang 10.000" dengan "2"
    And user memeriksa elemen "Total Distribusi Kuota Penumpang" dengan kondisi "500"
    And user memeriksa elemen "Total Distribusi Kuota Kendaraan" dengan kondisi "18"
    And user memeriksa elemen "Total Distribusi Kuota Bagasi" dengan kondisi "22"
    And user memeriksa elemen "Total kuota" dengan kondisi "518"
    Then sistem memenuhi hasil "Total per baris dan subtotal sesuai jumlah, bagasi tidak menambah 518"

  @negative @priority-high @REQ-024 @screen-konfirmasi-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-047 — Total payload yang dipalsukan tidak merusak perhitungan approval
    Given user berada di halaman "Konfirmasi Pengajuan"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota lengkap total 484; fixture override total payload menjadi 1"
    When user mengklik tombol "Ajukan ke Pusat"
    And user membuka halaman "Approval Kuota" dengan konteks "session:Pusat"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "total=484 hasil recompute atau pengajuan ditolak; tidak ada pengajuan total=1"
    Then sistem memenuhi hasil "Server menghitung dari internal+eksternal atau menolak total inkonsisten"

  @positive @priority-high @REQ-025 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-030 — Pengajuan over-capacity disetujui dengan konfirmasi Pusat
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; Menunggu total 599, kapasitas 598; modal approval terbuka"
    When user memeriksa elemen "Melebihi kapasitas" dengan kondisi "599 >598; selisih 1"
    And user mencentang checkbox "Konfirmasi Melebihi Kapasitas"
    And user mengklik tombol "Setujui Kuota"
    And user memeriksa elemen "Pengajuan" dengan kondisi "Disetujui"
    And user memeriksa elemen "Riwayat" dengan kondisi "konfirmasi over-capacity tersimpan bersama approval"
    Then sistem memenuhi hasil "Kuota over-capacity sah setelah konfirmasi eksplisit Pusat"

  @negative @priority-high @REQ-025 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-048 — Approve over-capacity tanpa checkbox diblokir
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; Menunggu total 599 kapasitas 598; checkbox belum dicentang"
    When user memeriksa elemen "Konfirmasi Melebihi Kapasitas" dengan kondisi "unchecked"
    And user memeriksa elemen "Setujui Kuota" dengan kondisi "disabled"
    And user memeriksa elemen "Pengajuan" dengan kondisi "Menunggu"
    Then sistem memenuhi hasil "Tidak ada approval over-capacity tanpa konfirmasi"

  @negative @priority-high @REQ-025 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-049 — Kuota over-capacity buatan Pusat tidak bypass validasi existing
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; form baru; tidak ada permission override kapasitas"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "481"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan" dengan "0"
    And user mengisi field "Kuota Internal — Ekonomi Lesehan (A)" dengan "60"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan (A)" dengan "0"
    And user mengisi field "Kuota Internal — Sepeda Motor (CC<250) (II-A)" dengan "20"
    And user mengisi field "Kuota Eksternal — Sepeda Motor (CC<250) (II-A)" dengan "0"
    And user mengisi field "Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "20"
    And user mengisi field "Kuota Eksternal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Sedang Standart (IV-B)" dengan "10"
    And user mengisi field "Kuota Eksternal — Truck/Bus Sedang Standart (IV-B)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Besar Standart (V-B)" dengan "8"
    And user mengisi field "Kuota Eksternal — Truck/Bus Besar Standart (V-B)" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Penumpang 10.000" dengan "20"
    And user mengisi field "Kuota Eksternal — Bagasi Penumpang 10.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 300.000" dengan "5"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 300.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 1.000.000" dengan "2"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 1.000.000" dengan "0"
    And user memeriksa elemen "Melebihi kapasitas" dengan kondisi "599 >598"
    And user memeriksa elemen "Simpan" dengan kondisi "disabled atau validasi kapasitas"
    Then sistem memenuhi hasil "Pusat tidak otomatis mengaktifkan kuota melebihi kapasitas tanpa rule override existing"

  @positive @priority-high @REQ-026 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-031 — Setujui Semua hanya kandidat Menunggu yang ditampilkan
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal Setujui Semua Kuota menampilkan 3 pengajuan Menunggu <=kapasitas; ada record Ditolak/Disetujui lain"
    When user memeriksa elemen "Setujui Semua Kuota" dengan kondisi "3 ID kandidat sah"
    And user mengklik tombol "Setujui Semua"
    And user membuka halaman "Approval Kuota"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "3 kandidat Disetujui; Ditolak/Disetujui lain tidak berubah"
    Then sistem memenuhi hasil "Setiap kandidat mendapat actor/timestamp approval; record di luar kandidat tidak berubah"

  @negative @priority-high @REQ-026 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-050 — Bulk over-capacity tidak bisa confirm tanpa checkbox
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; bulk 3 kandidat; satu total 612/598; checkbox tidak dicentang"
    When user memeriksa elemen "Konfirmasi Semua Melebihi Kapasitas" dengan kondisi "unchecked"
    And user memeriksa elemen "Setujui Semua" dengan kondisi "disabled"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "seluruh kandidat tetap Menunggu"
    Then sistem memenuhi hasil "Tidak ada keputusan bulk ketika syarat konfirmasi belum terpenuhi"

  @positive @priority-high @REQ-027 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-032 — Daftar membuka rincian Jadwal Crew Kuota untuk row yang dipilih
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Balikpapan / Suyanto; dua voyage berbeda tersedia; pilih voyage 214"
    When user mengklik tombol "Lihat detail"
    And user mengklik tombol "Jadwal"
    And user memeriksa elemen "Jadwal" dengan kondisi "rute waktu status voyage 214"
    And user mengklik tombol "Crew List"
    And user memeriksa elemen "Crew List" dengan kondisi "crew voyage 214"
    And user mengklik tombol "Kuota"
    And user memeriksa elemen "Kuota" dengan kondisi "internal eksternal total voyage 214"
    And user mengklik tombol "Lihat detail"
    And user memeriksa elemen "Jadwal" dengan kondisi "rincian row collapsed"
    Then sistem memenuhi hasil "Expand/collapse dan tab detail menampilkan data row yang tepat"

  @negative @priority-high @REQ-027 @screen-approval-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-051 — Filter status tanpa record menampilkan empty yang benar
    Given user berada di halaman "Approval Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; tidak ada pengajuan Dibatalkan"
    When user mengklik tombol "Dibatalkan"
    And user memeriksa elemen "Tidak ada pengajuan pada tab ini." dengan kondisi "visible"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "0 rows"
    And user memeriksa elemen "Jumlah Data" dengan kondisi "pager 0–0 dari 0"
    Then sistem memenuhi hasil "Tidak ada stale row atau aksi keputusan pada empty state"

  @positive @priority-high @REQ-028 @screen-konfirmasi-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-033 — Retry setelah gagal submit menghasilkan satu pengajuan
    Given user berada di halaman "Konfirmasi Pengajuan"
    And kondisi awal "Cabang Balikpapan / Suyanto; modal Ajukan; fixture submit pertama gagal 503 dan kedua sukses"
    When user mengklik tombol "Ajukan ke Pusat"
    And user memeriksa elemen "Ajukan ke Pusat" dengan kondisi "error; data form retained"
    And user mengklik tombol "Ajukan ke Pusat"
    And user membuka halaman "Approval Kuota" dengan konteks "session:Pusat"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "tepat satu Menunggu voyage 214"
    Then sistem memenuhi hasil "Retry aman setelah failure tanpa kehilangan isian atau duplikasi"

  @negative @priority-high @REQ-028 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-052 — Session habis saat confirm tidak melakukan perubahan
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal reject terbuka; session expire sebelum confirm"
    When user mengisi field "Alasan Penolakan" dengan "Perlu revisi"
    And user mengklik tombol "Tolak Pengajuan"
    And user memeriksa elemen "Tolak Pengajuan" dengan kondisi "session expired / login required"
    And user membuka halaman "Approval Kuota" dengan konteks "fresh authorized session"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "pengajuan masih Menunggu; audit reject tidak ada"
    Then sistem memenuhi hasil "Session expired tidak menghasilkan keputusan atau audit palsu"

  @edge @priority-high @REQ-003 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-002 — Satu nilai nol eksplisit cukup untuk Simpan Draft
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua isian kosong"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "0"
    And user mengklik tombol "Simpan Draft"
    And user membuka halaman "Setting Kuota"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "value=0; terisi eksplisit"
    Then sistem memenuhi hasil "Nol yang diisi dihitung sebagai satu data, berbeda dari kosong"

  @edge @priority-high @REQ-003 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-003 — Draft hanya Bagasi tanpa kuota penumpang kendaraan
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; form baru kosong"
    When user mengisi field "Kuota Internal — Bagasi Penumpang 10.000" dengan "1"
    And user mengklik tombol "Simpan Draft"
    And user membuka halaman "Setting Kuota"
    And user memeriksa elemen "Total Distribusi Kuota Bagasi" dengan kondisi "1"
    And user memeriksa elemen "Total kuota" dengan kondisi "0"
    Then sistem memenuhi hasil "Satu isian bagasi cukup untuk draft walau total approval 0"

  @edge @priority-high @REQ-004 @screen-konfirmasi-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-004 — Kembali dari modal pengajuan tidak mengirim ke Pusat
    Given user berada di halaman "Konfirmasi Pengajuan"
    And kondisi awal "Cabang Balikpapan / Suyanto; modal pengajuan lengkap terbuka"
    When user memeriksa elemen "Simpan & Ajukan Kuota" dengan kondisi "dialog visible; ID dan total tepat"
    And user mengklik tombol "Kembali"
    And user memeriksa elemen "Simpan & Ajukan" dengan kondisi "visible di form"
    And user membuka halaman "Approval Kuota" dengan konteks "session:Pusat"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "voyage 214 absent"
    Then sistem memenuhi hasil "Menutup modal tidak menghasilkan pengajuan atau status Menunggu"

  @edge @priority-high @REQ-004 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-005 — Agen dapat mengajukan sesuai aturan Cabang pembuat
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Agen Balikpapan; kuota lengkap valid"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "400"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan" dengan "0"
    And user mengisi field "Kuota Internal — Ekonomi Lesehan (A)" dengan "40"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan (A)" dengan "0"
    And user mengisi field "Kuota Internal — Sepeda Motor (CC<250) (II-A)" dengan "15"
    And user mengisi field "Kuota Eksternal — Sepeda Motor (CC<250) (II-A)" dengan "0"
    And user mengisi field "Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "15"
    And user mengisi field "Kuota Eksternal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Sedang Standart (IV-B)" dengan "8"
    And user mengisi field "Kuota Eksternal — Truck/Bus Sedang Standart (IV-B)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Besar Standart (V-B)" dengan "6"
    And user mengisi field "Kuota Eksternal — Truck/Bus Besar Standart (V-B)" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Penumpang 10.000" dengan "20"
    And user mengisi field "Kuota Eksternal — Bagasi Penumpang 10.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 300.000" dengan "5"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 300.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 1.000.000" dengan "2"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 1.000.000" dengan "0"
    And user mengklik tombol "Simpan & Ajukan"
    And user mengklik tombol "Ajukan ke Pusat"
    And user memeriksa elemen "Status Pengajuan" dengan kondisi "Menunggu"
    And user memeriksa elemen "Jadwal" dengan kondisi "locked"
    Then sistem memenuhi hasil "Agen tetap wajib approval sebelum Jadwal"

  @edge @priority-high @REQ-011 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-006 — Simpan Draft setelah pembatalan tidak mengubah audit Dibatalkan
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; isian retained sesudah cancel"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "380"
    And user mengklik tombol "Simpan Draft"
    And user membuka halaman "Detail Pengajuan" dengan konteks "session:Pusat"
    And user memeriksa elemen "Riwayat" dengan kondisi "cancel lama tetap tercatat"
    And user memeriksa elemen "Pengajuan" dengan kondisi "pengajuan lama Dibatalkan; draft revisi belum diajukan"
    Then sistem memenuhi hasil "Draft revisi dan status approval historis dipisahkan"

  @negative @priority-high @REQ-012 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-053 — Perubahan kuota approved Pusat yang invalid ditolak
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; editor kuota approved; Ekonomi=400 tersimpan"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "-1"
    And user memeriksa elemen "Simpan" dengan kondisi "disabled atau error format"
    And user membuka halaman "Setting Kuota" dengan konteks "reload authorized"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "nilai persisten masih 400"
    Then sistem memenuhi hasil "Hak edit Pusat tidak melewati validasi kuota"

  @edge @priority-high @REQ-013 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-007 — Jadwal valid melewati tengah malam satu menit
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota approved; timezone voyage Asia/Makassar"
    When user mengisi field "Waktu Berangkat" dengan "2026-10-10T23:59"
    And user mengisi field "Waktu Tiba" dengan "2026-10-11T00:00"
    And user mengklik tombol "Simpan"
    And user memeriksa elemen "Crew List" dengan kondisi "terbuka; waktu persisten sesuai input"
    Then sistem memenuhi hasil "Validasi memakai waktu aktual lintas tanggal, bukan perbandingan jam saja"

  @edge @priority-high @REQ-013 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-008 — Jadwal valid melewati tahun
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota approved; timezone voyage Asia/Makassar"
    When user mengisi field "Waktu Berangkat" dengan "2026-12-31T23:59"
    And user mengisi field "Waktu Tiba" dengan "2027-01-01T00:01"
    And user mengklik tombol "Simpan"
    And user memeriksa elemen "Crew List" dengan kondisi "terbuka; waktu persisten sesuai input"
    Then sistem memenuhi hasil "Validasi memakai waktu aktual lintas tanggal, bukan perbandingan jam saja"

  @edge @priority-high @REQ-013 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-009 — Jadwal valid tanggal kabisat valid
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota approved; timezone voyage Asia/Makassar"
    When user mengisi field "Waktu Berangkat" dengan "2028-02-28T23:59"
    And user mengisi field "Waktu Tiba" dengan "2028-02-29T00:01"
    And user mengklik tombol "Simpan"
    And user memeriksa elemen "Crew List" dengan kondisi "terbuka; waktu persisten sesuai input"
    Then sistem memenuhi hasil "Validasi memakai waktu aktual lintas tanggal, bukan perbandingan jam saja"

  @negative @priority-high @REQ-013 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-054 — Tanggal Jadwal tidak valid ditolak
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; kuota approved; fixture request override arrival tanggal mustahil"
    When user mengisi field "Waktu Berangkat" dengan "2026-10-10T12:00"
    And user mengisi field "Waktu Tiba" dengan "2026-10-11T08:00"
    And user mengklik tombol "Simpan"
    And user memeriksa elemen "Waktu Tiba" dengan kondisi "validasi tanggal invalid dari server"
    And user memeriksa elemen "Crew List" dengan kondisi "locked"
    Then sistem memenuhi hasil "Server menolak tanggal tidak ada walau UI datetime membatasi input"

  @edge @priority-high @REQ-008 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-010 — Alasan penolakan Unicode dan tanda kutip dipertahankan
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal reject Menunggu"
    When user mengisi field "Alasan Penolakan" dengan "Revisi \"IV-B\" — kapal pengganti é ✓\nBaris kedua"
    And user mengklik tombol "Tolak Pengajuan"
    And user membuka halaman "Detail Pengajuan"
    And user memeriksa elemen "Alasan Penolakan" dengan kondisi "Unicode, kutip dan baris kedua tidak rusak"
    Then sistem memenuhi hasil "Alasan nonblank aman disimpan dan ditampilkan"

  @negative @priority-high @REQ-008 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-055 — Markup alasan tidak dieksekusi ketika tampil ke Cabang
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal reject Menunggu; fixture mengawasi dialog browser"
    When user mengisi field "Alasan Penolakan" dengan "<script>alert(1)</script>"
    And user mengklik tombol "Tolak Pengajuan"
    And user membuka halaman "Setting Kuota" dengan konteks "session:Cabang"
    And user memeriksa elemen "Alasan Penolakan" dengan kondisi "teks escaped atau validasi penolakan aman; tidak ada script/dialog browser"
    Then sistem memenuhi hasil "Alasan tidak menjalankan script saat tampil di semua role"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-011 — Draft kuota menerima nol tanpa kehilangan nilai
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; form baru"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "0"
    And user mengklik tombol "Simpan Draft"
    And user membuka halaman "Setting Kuota"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "value=0 persisten"
    Then sistem memenuhi hasil "Nilai batas format valid dapat disimpan sebagai draft"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-012 — Draft kuota menerima minimum positif tanpa kehilangan nilai
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; form baru"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "1"
    And user mengklik tombol "Simpan Draft"
    And user membuka halaman "Setting Kuota"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "value=1 persisten"
    Then sistem memenuhi hasil "Nilai batas format valid dapat disimpan sebagai draft"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-013 — Draft kuota menerima maksimum empat digit tanpa kehilangan nilai
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; form baru"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "9999"
    And user mengklik tombol "Simpan Draft"
    And user membuka halaman "Setting Kuota"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "value=9999 persisten"
    Then sistem memenuhi hasil "Nilai batas format valid dapat disimpan sebagai draft"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-014 — Batas kapasitas Ekonomi Lesehan pada 479
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "479"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan" dengan "0"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "tanpa penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "479"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >480"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-015 — Batas kapasitas Ekonomi Lesehan pada 480
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "480"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan" dengan "0"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "tanpa penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "480"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >480"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-016 — Batas kapasitas Ekonomi Lesehan pada 481
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "481"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan" dengan "0"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "481"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >480"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-017 — Batas kapasitas Ekonomi Lesehan (A) pada 59
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan (A)" dengan "59"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan (A)" dengan "0"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan (A)" dengan kondisi "tanpa penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "59"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >60"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-018 — Batas kapasitas Ekonomi Lesehan (A) pada 60
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan (A)" dengan "60"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan (A)" dengan "0"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan (A)" dengan kondisi "tanpa penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "60"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >60"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-019 — Batas kapasitas Ekonomi Lesehan (A) pada 61
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan (A)" dengan "61"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan (A)" dengan "0"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan (A)" dengan kondisi "penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "61"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >60"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-020 — Batas kapasitas Sepeda Motor (CC<250) (II-A) pada 19
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Sepeda Motor (CC<250) (II-A)" dengan "19"
    And user mengisi field "Kuota Eksternal — Sepeda Motor (CC<250) (II-A)" dengan "0"
    And user memeriksa elemen "Kuota Internal — Sepeda Motor (CC<250) (II-A)" dengan kondisi "tanpa penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "19"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >20"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-021 — Batas kapasitas Sepeda Motor (CC<250) (II-A) pada 20
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Sepeda Motor (CC<250) (II-A)" dengan "20"
    And user mengisi field "Kuota Eksternal — Sepeda Motor (CC<250) (II-A)" dengan "0"
    And user memeriksa elemen "Kuota Internal — Sepeda Motor (CC<250) (II-A)" dengan kondisi "tanpa penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "20"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >20"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-022 — Batas kapasitas Sepeda Motor (CC<250) (II-A) pada 21
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Sepeda Motor (CC<250) (II-A)" dengan "21"
    And user mengisi field "Kuota Eksternal — Sepeda Motor (CC<250) (II-A)" dengan "0"
    And user memeriksa elemen "Kuota Internal — Sepeda Motor (CC<250) (II-A)" dengan kondisi "penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "21"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >20"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-023 — Batas kapasitas Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A) pada 19
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "19"
    And user mengisi field "Kuota Eksternal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "0"
    And user memeriksa elemen "Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan kondisi "tanpa penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "19"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >20"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-024 — Batas kapasitas Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A) pada 20
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "20"
    And user mengisi field "Kuota Eksternal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "0"
    And user memeriksa elemen "Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan kondisi "tanpa penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "20"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >20"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-025 — Batas kapasitas Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A) pada 21
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "21"
    And user mengisi field "Kuota Eksternal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "0"
    And user memeriksa elemen "Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan kondisi "penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "21"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >20"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-026 — Batas kapasitas Truck/Bus Sedang Standart (IV-B) pada 9
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Truck/Bus Sedang Standart (IV-B)" dengan "9"
    And user mengisi field "Kuota Eksternal — Truck/Bus Sedang Standart (IV-B)" dengan "0"
    And user memeriksa elemen "Kuota Internal — Truck/Bus Sedang Standart (IV-B)" dengan kondisi "tanpa penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "9"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >10"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-027 — Batas kapasitas Truck/Bus Sedang Standart (IV-B) pada 10
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Truck/Bus Sedang Standart (IV-B)" dengan "10"
    And user mengisi field "Kuota Eksternal — Truck/Bus Sedang Standart (IV-B)" dengan "0"
    And user memeriksa elemen "Kuota Internal — Truck/Bus Sedang Standart (IV-B)" dengan kondisi "tanpa penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "10"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >10"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-028 — Batas kapasitas Truck/Bus Sedang Standart (IV-B) pada 11
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Truck/Bus Sedang Standart (IV-B)" dengan "11"
    And user mengisi field "Kuota Eksternal — Truck/Bus Sedang Standart (IV-B)" dengan "0"
    And user memeriksa elemen "Kuota Internal — Truck/Bus Sedang Standart (IV-B)" dengan kondisi "penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "11"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >10"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-029 — Batas kapasitas Truck/Bus Besar Standart (V-B) pada 7
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Truck/Bus Besar Standart (V-B)" dengan "7"
    And user mengisi field "Kuota Eksternal — Truck/Bus Besar Standart (V-B)" dengan "0"
    And user memeriksa elemen "Kuota Internal — Truck/Bus Besar Standart (V-B)" dengan kondisi "tanpa penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "7"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >8"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-030 — Batas kapasitas Truck/Bus Besar Standart (V-B) pada 8
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Truck/Bus Besar Standart (V-B)" dengan "8"
    And user mengisi field "Kuota Eksternal — Truck/Bus Besar Standart (V-B)" dengan "0"
    And user memeriksa elemen "Kuota Internal — Truck/Bus Besar Standart (V-B)" dengan kondisi "tanpa penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "8"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >8"

  @edge @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-031 — Batas kapasitas Truck/Bus Besar Standart (V-B) pada 9
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; semua baris lain 0"
    When user mengisi field "Kuota Internal — Truck/Bus Besar Standart (V-B)" dengan "9"
    And user mengisi field "Kuota Eksternal — Truck/Bus Besar Standart (V-B)" dengan "0"
    And user memeriksa elemen "Kuota Internal — Truck/Bus Besar Standart (V-B)" dengan kondisi "penanda melebihi kapasitas"
    And user memeriksa elemen "Total kuota" dengan kondisi "9"
    Then sistem memenuhi hasil "Penanda golongan aktif hanya ketika total baris >8"

  @edge @priority-high @REQ-025 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-032 — Cabang mengajukan total 597 terhadap kapasitas 598
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; form baru"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "479"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan" dengan "0"
    And user mengisi field "Kuota Internal — Ekonomi Lesehan (A)" dengan "60"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan (A)" dengan "0"
    And user mengisi field "Kuota Internal — Sepeda Motor (CC<250) (II-A)" dengan "20"
    And user mengisi field "Kuota Eksternal — Sepeda Motor (CC<250) (II-A)" dengan "0"
    And user mengisi field "Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "20"
    And user mengisi field "Kuota Eksternal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Sedang Standart (IV-B)" dengan "10"
    And user mengisi field "Kuota Eksternal — Truck/Bus Sedang Standart (IV-B)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Besar Standart (V-B)" dengan "8"
    And user mengisi field "Kuota Eksternal — Truck/Bus Besar Standart (V-B)" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Penumpang 10.000" dengan "20"
    And user mengisi field "Kuota Eksternal — Bagasi Penumpang 10.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 300.000" dengan "5"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 300.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 1.000.000" dengan "2"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 1.000.000" dengan "0"
    And user memeriksa elemen "Total kuota" dengan kondisi "597"
    And user memeriksa elemen "Melebihi kapasitas" dengan kondisi "warning total absent"
    And user mengklik tombol "Simpan & Ajukan"
    And user memeriksa elemen "Total kuota" dengan kondisi "597 dari kapasitas 598"
    And user mengklik tombol "Ajukan ke Pusat"
    And user memeriksa elemen "Status Pengajuan" dengan kondisi "Menunggu"
    Then sistem memenuhi hasil "Batas total dihitung tepat; over-capacity masih dapat diajukan Cabang"

  @edge @priority-high @REQ-025 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-033 — Cabang mengajukan total 598 terhadap kapasitas 598
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; form baru"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "480"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan" dengan "0"
    And user mengisi field "Kuota Internal — Ekonomi Lesehan (A)" dengan "60"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan (A)" dengan "0"
    And user mengisi field "Kuota Internal — Sepeda Motor (CC<250) (II-A)" dengan "20"
    And user mengisi field "Kuota Eksternal — Sepeda Motor (CC<250) (II-A)" dengan "0"
    And user mengisi field "Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "20"
    And user mengisi field "Kuota Eksternal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Sedang Standart (IV-B)" dengan "10"
    And user mengisi field "Kuota Eksternal — Truck/Bus Sedang Standart (IV-B)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Besar Standart (V-B)" dengan "8"
    And user mengisi field "Kuota Eksternal — Truck/Bus Besar Standart (V-B)" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Penumpang 10.000" dengan "20"
    And user mengisi field "Kuota Eksternal — Bagasi Penumpang 10.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 300.000" dengan "5"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 300.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 1.000.000" dengan "2"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 1.000.000" dengan "0"
    And user memeriksa elemen "Total kuota" dengan kondisi "598"
    And user memeriksa elemen "Melebihi kapasitas" dengan kondisi "warning total absent"
    And user mengklik tombol "Simpan & Ajukan"
    And user memeriksa elemen "Total kuota" dengan kondisi "598 dari kapasitas 598"
    And user mengklik tombol "Ajukan ke Pusat"
    And user memeriksa elemen "Status Pengajuan" dengan kondisi "Menunggu"
    Then sistem memenuhi hasil "Batas total dihitung tepat; over-capacity masih dapat diajukan Cabang"

  @edge @priority-high @REQ-025 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-034 — Cabang mengajukan total 599 terhadap kapasitas 598
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; form baru"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "481"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan" dengan "0"
    And user mengisi field "Kuota Internal — Ekonomi Lesehan (A)" dengan "60"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan (A)" dengan "0"
    And user mengisi field "Kuota Internal — Sepeda Motor (CC<250) (II-A)" dengan "20"
    And user mengisi field "Kuota Eksternal — Sepeda Motor (CC<250) (II-A)" dengan "0"
    And user mengisi field "Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "20"
    And user mengisi field "Kuota Eksternal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Sedang Standart (IV-B)" dengan "10"
    And user mengisi field "Kuota Eksternal — Truck/Bus Sedang Standart (IV-B)" dengan "0"
    And user mengisi field "Kuota Internal — Truck/Bus Besar Standart (V-B)" dengan "8"
    And user mengisi field "Kuota Eksternal — Truck/Bus Besar Standart (V-B)" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Penumpang 10.000" dengan "20"
    And user mengisi field "Kuota Eksternal — Bagasi Penumpang 10.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 300.000" dengan "5"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 300.000" dengan "0"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 1.000.000" dengan "2"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 1.000.000" dengan "0"
    And user memeriksa elemen "Total kuota" dengan kondisi "599"
    And user memeriksa elemen "Melebihi kapasitas" dengan kondisi "visible total over 598"
    And user mengklik tombol "Simpan & Ajukan"
    And user memeriksa elemen "Total kuota" dengan kondisi "599 dari kapasitas 598"
    And user mengklik tombol "Ajukan ke Pusat"
    And user memeriksa elemen "Status Pengajuan" dengan kondisi "Menunggu"
    Then sistem memenuhi hasil "Batas total dihitung tepat; over-capacity masih dapat diajukan Cabang"

  @edge @priority-high @REQ-025 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-035 — Konfirmasi over-capacity kembali unchecked setelah reopen
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal approve total 612/598"
    When user mencentang checkbox "Konfirmasi Melebihi Kapasitas"
    And user menghapus centang checkbox "Konfirmasi Melebihi Kapasitas"
    And user memeriksa elemen "Setujui Kuota" dengan kondisi "disabled"
    And user mengklik tombol "Batal"
    And user mengklik tombol "Setujui Kuota"
    And user memeriksa elemen "Konfirmasi Melebihi Kapasitas" dengan kondisi "unchecked"
    And user memeriksa elemen "Setujui Kuota" dengan kondisi "disabled"
    Then sistem memenuhi hasil "Konfirmasi tidak terbawa ke modal/siklus approval berikutnya"

  @edge @priority-high @REQ-025 @screen-detail-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-036 — Kelebihan golongan dengan total di bawah kapasitas tetap ditandai
    Given user berada di halaman "Detail Pengajuan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; Menunggu; IV-B=11 (>10), golongan lain 0; total 11/598"
    When user memeriksa elemen "Kuota vs Kapasitas Kapal" dengan kondisi "IV-B sisa -1; total sisa 587"
    And user mengklik tombol "Setujui Kuota"
    And user memeriksa elemen "Konfirmasi Melebihi Kapasitas" dengan kondisi "absent; total tidak over"
    And user mengklik tombol "Setujui Kuota"
    Then sistem memenuhi hasil "Penanda golongan terlihat; checkbox total mengikuti rule prototipe"

  @edge @priority-high @REQ-024 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-037 — Mengosongkan isian memperbarui total tanpa NaN
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; Ekonomi Internal=400 Eksternal=50"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan ""
    And user memeriksa elemen "Total Distribusi Kuota Penumpang" dengan kondisi "50"
    And user memeriksa elemen "Total kuota" dengan kondisi "50; bukan NaN"
    Then sistem memenuhi hasil "Nilai kosong diperlakukan 0 untuk preview total, bukan final validity"

  @edge @priority-high @REQ-024 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-038 — Distribusi semua field mendekati batas tidak overflow
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; form draft"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "9999"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan" dengan "9999"
    And user mengisi field "Kuota Internal — Ekonomi Lesehan (A)" dengan "9999"
    And user mengisi field "Kuota Eksternal — Ekonomi Lesehan (A)" dengan "9999"
    And user mengisi field "Kuota Internal — Sepeda Motor (CC<250) (II-A)" dengan "9999"
    And user mengisi field "Kuota Eksternal — Sepeda Motor (CC<250) (II-A)" dengan "9999"
    And user mengisi field "Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "9999"
    And user mengisi field "Kuota Eksternal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dengan "9999"
    And user mengisi field "Kuota Internal — Truck/Bus Sedang Standart (IV-B)" dengan "9999"
    And user mengisi field "Kuota Eksternal — Truck/Bus Sedang Standart (IV-B)" dengan "9999"
    And user mengisi field "Kuota Internal — Truck/Bus Besar Standart (V-B)" dengan "9999"
    And user mengisi field "Kuota Eksternal — Truck/Bus Besar Standart (V-B)" dengan "9999"
    And user mengisi field "Kuota Internal — Bagasi Penumpang 10.000" dengan "9999"
    And user mengisi field "Kuota Eksternal — Bagasi Penumpang 10.000" dengan "9999"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 300.000" dengan "9999"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 300.000" dengan "9999"
    And user mengisi field "Kuota Internal — Bagasi Kendaraan 1.000.000" dengan "9999"
    And user mengisi field "Kuota Eksternal — Bagasi Kendaraan 1.000.000" dengan "9999"
    And user memeriksa elemen "Total kuota" dengan kondisi "119988"
    And user memeriksa elemen "Total Distribusi Kuota Penumpang" dengan kondisi "39996"
    And user memeriksa elemen "Total Distribusi Kuota Kendaraan" dengan kondisi "79992"
    And user memeriksa elemen "Total Distribusi Kuota Bagasi" dengan kondisi "59994"
    Then sistem memenuhi hasil "Penjumlahan tepat untuk seluruh 18 isian maksimal tanpa NaN/overflow"

  @edge @priority-high @REQ-026 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-039 — Bulk sah dengan konfirmasi semua kandidat over-capacity
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; 3 kandidat Menunggu, 2 over kapasitas"
    When user mencentang checkbox "Konfirmasi Semua Melebihi Kapasitas"
    And user mengklik tombol "Setujui Semua"
    And user membuka halaman "Approval Kuota"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "3 kandidat Disetujui; audit setiap item ada"
    Then sistem memenuhi hasil "Konfirmasi diterapkan per kandidat sah dan tercatat"

  @edge @priority-high @REQ-026 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-040 — Bulk nol kandidat tidak menyediakan aksi Setujui Semua
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; tidak ada pengajuan Menunggu"
    When user memeriksa elemen "Setujui Semua" dengan kondisi "absent/disabled"
    Then sistem memenuhi hasil "Bulk tidak membuka modal keputusan kosong"

  @negative @priority-high @REQ-026 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-056 — Bulk stale tidak memutuskan item yang telah dibatalkan
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal bulk 3 ID; satu kandidat dibatalkan Cabang setelah modal dibuka"
    When user mengklik tombol "Setujui Semua"
    And user membuka halaman "Approval Kuota"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "item stale tetap Dibatalkan; hasil per item menjelaskan konflik"
    Then sistem memenuhi hasil "Bulk memeriksa status/version terkini, tidak overwrite pembatalan"

  @edge @priority-high @REQ-026 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-041 — Batal bulk tidak memutuskan kandidat apa pun
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal Setujui Semua terbuka"
    When user mengklik tombol "Batal"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "seluruh kandidat masih Menunggu"
    Then sistem memenuhi hasil "Dismiss bulk tidak membuat audit keputusan"

  @positive @priority-high @REQ-027 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-034 — Buat Jadwal menampilkan metadata voyage dan distribusi
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Balikpapan / Suyanto; fixture voyage 214 terpilih"
    When user mengklik tombol "Buat Jadwal"
    And user memeriksa elemen "Trayek" dengan kondisi "PAREPARE - BALIKPAPAN"
    And user memeriksa elemen "Kapal" dengan kondisi "KM. SWARNA BAHTERA"
    And user memeriksa elemen "Call Sign" dengan kondisi "POKG"
    And user memeriksa elemen "Nomor Voyage" dengan kondisi "214"
    And user memeriksa elemen "Kapasitas Kapal" dengan kondisi "598"
    And user memeriksa elemen "Rute" dengan kondisi "Parepare (PAP) → Balikpapan (BPN)"
    And user mengklik tombol "Kuota"
    And user mengklik tombol "Batal"
    Then sistem memenuhi hasil "Form baru memuat ringkasan dan tab step; Batal kembali daftar"

  @positive @priority-high @REQ-027 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-035 — Menu Kuota & Jadwal dan Approval Kuota memakai sesi Pusat
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; permission menu kedua fitur tersedia"
    When user mengklik tombol "Kuota & Jadwal"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "visible"
    And user mengklik tombol "Approval Kuota"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "visible"
    Then sistem memenuhi hasil "Menu mengarah ke layar yang sesuai hak Pusat"

  @positive @priority-medium @REQ-027 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-036 — Paging daftar-kuota-jadwal dengan jumlah 10 data
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; 61 record berhak dilihat tersedia"
    When user memilih opsi "10" pada dropdown "Jumlah Data"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "halaman 1 berisi 10 row; jumlah total 61"
    And user mengklik tombol "Halaman Berikutnya"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "halaman 2 berisi 10 row; ID tidak berulang"
    Then sistem memenuhi hasil "Pagination tidak kehilangan/duplikasi record dan total sesuai"

  @positive @priority-medium @REQ-027 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-037 — Paging daftar-kuota-jadwal dengan jumlah 20 data
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; 61 record berhak dilihat tersedia"
    When user memilih opsi "20" pada dropdown "Jumlah Data"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "halaman 1 berisi 20 row; jumlah total 61"
    And user mengklik tombol "Halaman Berikutnya"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "halaman 2 berisi 20 row; ID tidak berulang"
    Then sistem memenuhi hasil "Pagination tidak kehilangan/duplikasi record dan total sesuai"

  @positive @priority-medium @REQ-027 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-038 — Paging daftar-kuota-jadwal dengan jumlah 50 data
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; 61 record berhak dilihat tersedia"
    When user memilih opsi "50" pada dropdown "Jumlah Data"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "halaman 1 berisi 50 row; jumlah total 61"
    And user mengklik tombol "Halaman Berikutnya"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "halaman 2 berisi 11 row; ID tidak berulang"
    Then sistem memenuhi hasil "Pagination tidak kehilangan/duplikasi record dan total sesuai"

  @edge @priority-medium @REQ-027 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-042 — Panel Filter daftar-kuota-jadwal dapat dibuka tanpa mengubah data
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; dataset berhak tersedia"
    When user mengklik tombol "Filter"
    And user memeriksa elemen "Filter" dengan kondisi "panel/kontrol filter visible; tidak ada perubahan record"
    Then sistem memenuhi hasil "Filter membuka kontrol yang tersedia tanpa mutasi kuota"

  @positive @priority-medium @REQ-027 @screen-approval-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-039 — Paging approval-kuota dengan jumlah 10 data
    Given user berada di halaman "Approval Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; 61 record berhak dilihat tersedia"
    When user memilih opsi "10" pada dropdown "Jumlah Data"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "halaman 1 berisi 10 row; jumlah total 61"
    And user mengklik tombol "Halaman Berikutnya"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "halaman 2 berisi 10 row; ID tidak berulang"
    Then sistem memenuhi hasil "Pagination tidak kehilangan/duplikasi record dan total sesuai"

  @positive @priority-medium @REQ-027 @screen-approval-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-040 — Paging approval-kuota dengan jumlah 20 data
    Given user berada di halaman "Approval Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; 61 record berhak dilihat tersedia"
    When user memilih opsi "20" pada dropdown "Jumlah Data"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "halaman 1 berisi 20 row; jumlah total 61"
    And user mengklik tombol "Halaman Berikutnya"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "halaman 2 berisi 20 row; ID tidak berulang"
    Then sistem memenuhi hasil "Pagination tidak kehilangan/duplikasi record dan total sesuai"

  @positive @priority-medium @REQ-027 @screen-approval-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-041 — Paging approval-kuota dengan jumlah 50 data
    Given user berada di halaman "Approval Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; 61 record berhak dilihat tersedia"
    When user memilih opsi "50" pada dropdown "Jumlah Data"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "halaman 1 berisi 50 row; jumlah total 61"
    And user mengklik tombol "Halaman Berikutnya"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "halaman 2 berisi 11 row; ID tidak berulang"
    Then sistem memenuhi hasil "Pagination tidak kehilangan/duplikasi record dan total sesuai"

  @edge @priority-medium @REQ-027 @screen-approval-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-043 — Panel Filter approval-kuota dapat dibuka tanpa mengubah data
    Given user berada di halaman "Approval Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; dataset berhak tersedia"
    When user mengklik tombol "Filter"
    And user memeriksa elemen "Filter" dengan kondisi "panel/kontrol filter visible; tidak ada perubahan record"
    Then sistem memenuhi hasil "Filter membuka kontrol yang tersedia tanpa mutasi kuota"

  @edge @priority-medium @REQ-027 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-044 — Halaman Sebelumnya mengembalikan daftar dan ID awal
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; 21 record; berada halaman 2 ukuran 10"
    When user mengklik tombol "Halaman Sebelumnya"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "halaman 1; ID pertama dan count 1–10 dari 21"
    Then sistem memenuhi hasil "Navigasi kembali tidak menggandakan ID"

  @negative @priority-medium @REQ-027 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-057 — Daftar kosong tidak menampilkan detail dari cache lama
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Balikpapan / Suyanto; filter/status menghasilkan nol record"
    When user memeriksa elemen "Tidak Ada Data yang tersedia" dengan kondisi "visible"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "0 rows"
    And user memeriksa elemen "Lihat detail" dengan kondisi "absent"
    Then sistem memenuhi hasil "Empty daftar tidak mengekspos stale data sebelumnya"

  @positive @priority-medium @REQ-027 @screen-approval-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-042 — Tab Approval Kuota Semua sesuai status dan count
    Given user berada di halaman "Approval Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; fixture semua status tersedia"
    When user mengklik tombol "Semua"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "ID dan count sesuai Semua; tidak ada status lain kecuali Semua"
    Then sistem memenuhi hasil "Tab tidak mencampurkan status; count sama dengan fixture"

  @positive @priority-medium @REQ-027 @screen-approval-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-043 — Tab Approval Kuota Menunggu Approval sesuai status dan count
    Given user berada di halaman "Approval Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; fixture semua status tersedia"
    When user mengklik tombol "Menunggu Approval"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "ID dan count sesuai Menunggu Approval; tidak ada status lain kecuali Semua"
    Then sistem memenuhi hasil "Tab tidak mencampurkan status; count sama dengan fixture"

  @positive @priority-medium @REQ-027 @screen-approval-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-044 — Tab Approval Kuota Disetujui sesuai status dan count
    Given user berada di halaman "Approval Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; fixture semua status tersedia"
    When user mengklik tombol "Disetujui"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "ID dan count sesuai Disetujui; tidak ada status lain kecuali Semua"
    Then sistem memenuhi hasil "Tab tidak mencampurkan status; count sama dengan fixture"

  @positive @priority-medium @REQ-027 @screen-approval-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-045 — Tab Approval Kuota Ditolak sesuai status dan count
    Given user berada di halaman "Approval Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; fixture semua status tersedia"
    When user mengklik tombol "Ditolak"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "ID dan count sesuai Ditolak; tidak ada status lain kecuali Semua"
    Then sistem memenuhi hasil "Tab tidak mencampurkan status; count sama dengan fixture"

  @positive @priority-medium @REQ-027 @screen-approval-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-046 — Tab Approval Kuota Dibatalkan sesuai status dan count
    Given user berada di halaman "Approval Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; fixture semua status tersedia"
    When user mengklik tombol "Dibatalkan"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "ID dan count sesuai Dibatalkan; tidak ada status lain kecuali Semua"
    Then sistem memenuhi hasil "Tab tidak mencampurkan status; count sama dengan fixture"

  @positive @priority-medium @REQ-027 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-047 — Tab Daftar Cabang Semua membatasi record sendiri
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Balikpapan / Suyanto; fixture sendiri dan cabang lain pada semua status"
    When user mengklik tombol "Semua"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "belum selesai hanya record sendiri; status sesuai tab Semua"
    Then sistem memenuhi hasil "Pemilihan tab tidak membocorkan data Cabang lain"

  @positive @priority-medium @REQ-027 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-048 — Tab Daftar Cabang Menunggu Approval membatasi record sendiri
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Balikpapan / Suyanto; fixture sendiri dan cabang lain pada semua status"
    When user mengklik tombol "Menunggu Approval"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "belum selesai hanya record sendiri; status sesuai tab Menunggu Approval"
    Then sistem memenuhi hasil "Pemilihan tab tidak membocorkan data Cabang lain"

  @positive @priority-medium @REQ-027 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-049 — Tab Daftar Cabang Disetujui membatasi record sendiri
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Balikpapan / Suyanto; fixture sendiri dan cabang lain pada semua status"
    When user mengklik tombol "Disetujui"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "belum selesai hanya record sendiri; status sesuai tab Disetujui"
    Then sistem memenuhi hasil "Pemilihan tab tidak membocorkan data Cabang lain"

  @positive @priority-medium @REQ-027 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-050 — Tab Daftar Cabang Ditolak membatasi record sendiri
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Balikpapan / Suyanto; fixture sendiri dan cabang lain pada semua status"
    When user mengklik tombol "Ditolak"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "belum selesai hanya record sendiri; status sesuai tab Ditolak"
    Then sistem memenuhi hasil "Pemilihan tab tidak membocorkan data Cabang lain"

  @positive @priority-medium @REQ-027 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-051 — Tab Daftar Cabang Dibatalkan membatasi record sendiri
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Balikpapan / Suyanto; fixture sendiri dan cabang lain pada semua status"
    When user mengklik tombol "Dibatalkan"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "belum selesai hanya record sendiri; status sesuai tab Dibatalkan"
    Then sistem memenuhi hasil "Pemilihan tab tidak membocorkan data Cabang lain"

  @positive @priority-medium @REQ-027 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-052 — Tab Aktif Pusat hanya jadwal yang selesai
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; campuran Menunggu dan semua final"
    When user mengklik tombol "Aktif"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "hanya jadwal final aktif; tidak ada Menunggu/Isi Crew List"
    Then sistem memenuhi hasil "Tab Aktif memakai progress final dan hak visibility"

  @positive @priority-high @REQ-027 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-053 — Aksi Pusat pada daftar diarahkan ke pengajuan row tepat
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; 2 Menunggu; row scope KQ2203"
    When user mengklik tombol "Setujui kuota"
    And user memeriksa elemen "Setujui Kuota" dengan kondisi "modal menampilkan KQ2203"
    And user mengklik tombol "Batal"
    And user mengklik tombol "Tolak kuota"
    And user memeriksa elemen "Tolak Pengajuan Kuota" dengan kondisi "modal menampilkan KQ2203"
    And user mengklik tombol "Batal"
    And user mengklik tombol "Setujui Semua"
    And user memeriksa elemen "Setujui Semua Kuota" dengan kondisi "daftar kandidat nyata visible"
    And user mengklik tombol "Batal"
    Then sistem memenuhi hasil "Aksi row dan bulk menampilkan target yang jelas sebelum confirm"

  @positive @priority-high @REQ-027 @screen-approval-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-054 — Reject dari antrean dan kembali detail menjaga asal layar
    Given user berada di halaman "Approval Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; row KQ2203 Menunggu"
    When user mengklik tombol "Tolak kuota"
    And user memeriksa elemen "Alasan Penolakan" dengan kondisi "textbox visible"
    And user mengklik tombol "Batal"
    And user mengklik tombol "Lihat detail"
    And user memeriksa elemen "Pengajuan" dengan kondisi "KQ2203"
    And user mengklik tombol "Tolak"
    And user mengklik tombol "Batal"
    And user mengklik tombol "Kembali"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "visible; row unchanged"
    Then sistem memenuhi hasil "Batal modal dan Kembali detail tidak menghasilkan keputusan"

  @edge @priority-high @REQ-027 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-045 — Batal Jadwal tidak memfinalisasi step
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; approved; Jadwal belum final"
    When user mengisi field "Waktu Berangkat" dengan "2026-10-10T12:00"
    And user mengklik tombol "Batal"
    And user memeriksa elemen "Crew List" dengan kondisi "gate masih locked"
    Then sistem memenuhi hasil "Batal tidak menyimpan Jadwal final"

  @edge @priority-high @REQ-027 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-046 — Kembali ke Kuota dari panel locked mempertahankan draft
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; draft sendiri Ekonomi=1"
    When user mengklik tombol "Jadwal"
    And user memeriksa elemen "Jadwal" dengan kondisi "locked"
    And user mengklik tombol "Kembali ke Kuota"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "value=1"
    Then sistem memenuhi hasil "Panel locked memungkinkan kembali ke step editable"

  @edge @priority-high @REQ-010 @screen-konfirmasi-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-047 — Kembali dari konfirmasi pembatalan mempertahankan Menunggu
    Given user berada di halaman "Konfirmasi Pengajuan"
    And kondisi awal "Cabang Balikpapan / Suyanto; modal Batalkan Pengajuan Menunggu terbuka"
    When user mengklik tombol "Kembali"
    And user memeriksa elemen "Status Pengajuan" dengan kondisi "Menunggu"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "read-only"
    Then sistem memenuhi hasil "Batal modal tidak membatalkan pengajuan"

  @edge @priority-high @REQ-002 @screen-konfirmasi-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-048 — Kembali dari modal Simpan Kuota Pusat tidak membuka Jadwal
    Given user berada di halaman "Konfirmasi Pengajuan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal Simpan Kuota baru terbuka"
    When user memeriksa elemen "Simpan Kuota" dengan kondisi "dialog visible; total sesuai form"
    And user mengklik tombol "Kembali"
    And user memeriksa elemen "Jadwal" dengan kondisi "locked; kuota belum final"
    Then sistem memenuhi hasil "Kuota Pusat tetap belum final jika konfirmasi dibatalkan"

  @edge @priority-high @REQ-007 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-049 — Batal konfirmasi approve mempertahankan status Menunggu
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal Setujui Kuota Menunggu terbuka"
    When user mengklik tombol "Batal"
    And user memeriksa elemen "Pengajuan" dengan kondisi "Menunggu"
    And user memeriksa elemen "Riwayat" dengan kondisi "tidak ada approval baru"
    Then sistem memenuhi hasil "Dismiss modal approve tidak mengubah status atau audit"

  @edge @priority-high @REQ-008 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-050 — Batal reject setelah mengisi alasan tidak membuat keputusan
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal reject terbuka"
    When user mengisi field "Alasan Penolakan" dengan "Perlu revisi"
    And user mengklik tombol "Batal"
    And user memeriksa elemen "Pengajuan" dengan kondisi "Menunggu"
    And user memeriksa elemen "Riwayat" dengan kondisi "tidak ada reject/alasan baru"
    Then sistem memenuhi hasil "Alasan belum dikonfirmasi tidak tersimpan sebagai keputusan"

  @positive @priority-high @REQ-022 @screen-konfirmasi-hapus
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-POS-055 — Hapus draft yang belum diajukan sesuai hak existing
    Given user berada di halaman "Konfirmasi Hapus"
    And kondisi awal "Cabang Balikpapan / Suyanto; draft sendiri belum pernah diajukan; hak hapus existing"
    When user memeriksa elemen "Hapus Draft Kuota" dengan kondisi "voyage 214 dan status draft"
    And user mengklik tombol "Hapus Draft"
    And user membuka halaman "Daftar Kuota & Jadwal"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "draft 214 absent"
    And user membuka halaman "Approval Kuota" dengan konteks "session:Pusat"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "tidak ada history pengajuan baru"
    Then sistem memenuhi hasil "Draft belum diajukan dapat dihapus tanpa menciptakan approval"

  @edge @priority-high @REQ-022 @screen-konfirmasi-hapus
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-051 — Hapus Dibatalkan dari daftar tetap mempertahankan riwayat
    Given user berada di halaman "Konfirmasi Hapus"
    And kondisi awal "Cabang Balikpapan / Suyanto; modal Hapus Pengajuan Dibatalkan; hak hapus existing"
    When user memeriksa elemen "Hapus Pengajuan Dibatalkan" dengan kondisi "voyage benar"
    And user mengklik tombol "Hapus"
    And user membuka halaman "Approval Kuota" dengan konteks "session:Pusat"
    And user mengklik tombol "Dibatalkan"
    And user mengklik tombol "Lihat detail"
    And user memeriksa elemen "Riwayat" dengan kondisi "cancel retained dengan user/timestamp"
    Then sistem memenuhi hasil "Soft delete dari daftar tidak menghapus riwayat pembatalan"

  @edge @priority-high @REQ-027 @screen-konfirmasi-hapus
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-052 — Kembali modal hapus jadwal aktif tidak menutup jadwal
    Given user berada di halaman "Konfirmasi Hapus"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal Hapus Kuota & Jadwal Aktif voyage final terbuka"
    When user memeriksa elemen "Hapus Kuota & Jadwal Aktif" dengan kondisi "warning jadwal aktif dan voyage tepat"
    And user mengklik tombol "Kembali"
    And user membuka halaman "Daftar Kuota & Jadwal"
    And user memeriksa elemen "Status" dengan kondisi "Jadwal Tampil"
    Then sistem memenuhi hasil "Dismiss modal hapus menjaga semua data dan jadwal aktif"

  @edge @priority-high @REQ-027 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-053 — Aksi Hapus daftar membuka modal untuk draft yang tepat
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "Cabang Balikpapan / Suyanto; 2 draft; row scope voyage 214"
    When user mengklik tombol "Hapus"
    And user memeriksa elemen "Hapus Draft Kuota" dengan kondisi "voyage 214; bukan voyage 215"
    And user mengklik tombol "Kembali"
    Then sistem memenuhi hasil "Aksi Hapus tidak langsung memutasi data dan terikat row benar"

  @edge @priority-high @REQ-018 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-054 — Edit membuka kembali Jadwal Tutup menjadi Tampil
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; hak edit existing; seluruh step sudah final dan Jadwal Tutup"
    When user memilih opsi "Jadwal Tampil" pada dropdown "Status Jadwal"
    And user mengklik tombol "Simpan"
    And user membuka halaman "Daftar Kuota & Jadwal"
    And user memeriksa elemen "Status" dengan kondisi "Jadwal Tampil"
    Then sistem memenuhi hasil "Status buka kembali sesuai existing tanpa mengubah audit approval"

  @negative @priority-high @REQ-003 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-058 — Gagal transaksi quota-draft tidak menghasilkan sukses palsu
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; data valid untuk quota-draft; fixture server 500 sebelum commit"
    When user mengklik tombol "Simpan Draft"
    And user memeriksa elemen "Simpan Draft" dengan kondisi "error recoverable; isian retained"
    And user membuka halaman "Daftar Kuota & Jadwal" dengan konteks "reload"
    And user memeriksa elemen "Status" dengan kondisi "state persisten sama sebelum aksi gagal"
    Then sistem memenuhi hasil "Tidak ada kemajuan step/status/audit sukses ketika transaksi gagal"

  @negative @priority-high @REQ-013 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-059 — Gagal transaksi schedule-final tidak menghasilkan sukses palsu
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; data valid untuk schedule-final; fixture server 500 sebelum commit"
    When user mengklik tombol "Simpan"
    And user memeriksa elemen "Simpan" dengan kondisi "error recoverable; isian retained"
    And user membuka halaman "Daftar Kuota & Jadwal" dengan konteks "reload"
    And user memeriksa elemen "Status" dengan kondisi "state persisten sama sebelum aksi gagal"
    Then sistem memenuhi hasil "Tidak ada kemajuan step/status/audit sukses ketika transaksi gagal"

  @negative @priority-high @REQ-014 @screen-crew-list
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-060 — Gagal transaksi crew-draft tidak menghasilkan sukses palsu
    Given user berada di halaman "Crew List"
    And kondisi awal "Cabang Balikpapan / Suyanto; data valid untuk crew-draft; fixture server 500 sebelum commit"
    When user mengklik tombol "Simpan Draft"
    And user memeriksa elemen "Simpan Draft" dengan kondisi "error recoverable; isian retained"
    And user membuka halaman "Daftar Kuota & Jadwal" dengan konteks "reload"
    And user memeriksa elemen "Status" dengan kondisi "state persisten sama sebelum aksi gagal"
    Then sistem memenuhi hasil "Tidak ada kemajuan step/status/audit sukses ketika transaksi gagal"

  @negative @priority-high @REQ-016 @screen-crew-list
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-061 — Gagal transaksi crew-final tidak menghasilkan sukses palsu
    Given user berada di halaman "Crew List"
    And kondisi awal "Cabang Balikpapan / Suyanto; data valid untuk crew-final; fixture server 500 sebelum commit"
    When user mengklik tombol "Selesai"
    And user memeriksa elemen "Selesai" dengan kondisi "error recoverable; isian retained"
    And user membuka halaman "Daftar Kuota & Jadwal" dengan konteks "reload"
    And user memeriksa elemen "Status" dengan kondisi "state persisten sama sebelum aksi gagal"
    Then sistem memenuhi hasil "Tidak ada kemajuan step/status/audit sukses ketika transaksi gagal"

  @negative @priority-high @REQ-010 @screen-konfirmasi-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-062 — Gagal transaksi cancel tidak menghasilkan sukses palsu
    Given user berada di halaman "Konfirmasi Pengajuan"
    And kondisi awal "Cabang Balikpapan / Suyanto; data valid untuk cancel; fixture server 500 sebelum commit"
    When user mengklik tombol "Batalkan Pengajuan"
    And user memeriksa elemen "Batalkan Pengajuan" dengan kondisi "error recoverable; isian retained"
    And user membuka halaman "Daftar Kuota & Jadwal" dengan konteks "reload"
    And user memeriksa elemen "Status" dengan kondisi "state persisten sama sebelum aksi gagal"
    Then sistem memenuhi hasil "Tidak ada kemajuan step/status/audit sukses ketika transaksi gagal"

  @negative @priority-high @REQ-006 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-063 — Request approval dengan role Cabang yang dipalsukan ditolak server
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal approve terbuka; request fixture ditandatangani session Cabang"
    When user mengklik tombol "Setujui Kuota"
    And user memeriksa elemen "Setujui Kuota" dengan kondisi "403/akses ditolak"
    And user membuka halaman "Detail Pengajuan" dengan konteks "fresh Pusat session"
    And user memeriksa elemen "Pengajuan" dengan kondisi "Menunggu"
    And user memeriksa elemen "Riwayat" dengan kondisi "tidak ada keputusan baru"
    Then sistem memenuhi hasil "Server memeriksa role sesi, bukan label role di client"

  @negative @priority-high @REQ-012 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-064 — Request edit kuota approved menggunakan session Cabang ditolak
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; editor approved terbuka; request memakai session Cabang lewat fixture"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "390"
    And user mengklik tombol "Simpan"
    And user memeriksa elemen "Simpan" dengan kondisi "403/akses ditolak"
    And user membuka halaman "Setting Kuota" dengan konteks "fresh authorized session"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "nilai persisten sebelumnya 400"
    Then sistem memenuhi hasil "Kuota approved tidak dapat dimodifikasi Cabang lewat request override"

  @negative @priority-high @REQ-028 @screen-konfirmasi-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-065 — Timeout sesudah commit tidak menggandakan pengajuan saat retry
    Given user berada di halaman "Konfirmasi Pengajuan"
    And kondisi awal "Cabang Balikpapan / Suyanto; fixture submit commit berhasil tetapi respons timeout"
    When user mengklik tombol "Ajukan ke Pusat"
    And user memeriksa elemen "Ajukan ke Pusat" dengan kondisi "hasil belum pasti; refresh/reconcile tersedia"
    And user membuka halaman "Setting Kuota" dengan konteks "reload"
    And user memeriksa elemen "Status Pengajuan" dengan kondisi "Menunggu"
    And user membuka halaman "Approval Kuota" dengan konteks "session:Pusat"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "tepat satu pengajuan voyage 214"
    Then sistem memenuhi hasil "Reconcile membaca state server dan tidak mengulangi transaksi yang sudah commit"

  @negative @priority-high @REQ-022 @screen-detail-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-066 — Role tanpa hak tidak dapat membuka riwayat approval langsung
    Given user berada di halaman "Detail Pengajuan"
    And kondisi awal "Role tanpa permission Approval Kuota meminta detail riwayat pengajuan Cabang"
    When user memeriksa elemen "Riwayat" dengan kondisi "akses ditolak; actor waktu alasan tidak bocor"
    And user memeriksa elemen "Pengajuan" dengan kondisi "data pengajuan absent"
    Then sistem memenuhi hasil "Riwayat tidak terekspos kepada role tanpa hak menu Approval Kuota"

  @negative @priority-high @REQ-016 @screen-crew-list
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-NEG-067 — Crew kosong menampilkan petunjuk lengkap dan Selesai disabled
    Given user berada di halaman "Crew List"
    And kondisi awal "Cabang Balikpapan / Suyanto; Jadwal final; belum satu crew dipilih"
    When user memeriksa elemen "Pastikan Crew List sudah terisi semua" dengan kondisi "visible"
    And user memeriksa elemen "Masukkan Crew" dengan kondisi "enabled"
    And user memeriksa elemen "Selesai" dengan kondisi "disabled"
    Then sistem memenuhi hasil "User mendapat petunjuk pengisian dan tidak bisa final Crew kosong"

  @edge @priority-high @REQ-007 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-055 — Cabang sesi lama melihat keputusan approval setelah reload
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; tab terbuka Menunggu; Pusat menyetujui melalui sesi lain sebelum reload"
    When user membuka halaman "Setting Kuota" dengan konteks "reload"
    And user memeriksa elemen "Status Pengajuan" dengan kondisi "Disetujui"
    And user memeriksa elemen "Lanjut ke Jadwal" dengan kondisi "enabled"
    Then sistem memenuhi hasil "Reload merekonsiliasi state terbaru dan gate"

  @edge @priority-high @REQ-028 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-056 — Race dua Pusat Approve melawan Reject menghasilkan satu keputusan
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Dua sesi Pusat A/B memiliki modal atas KQ2203 versi 1 Menunggu"
    When user mengklik tombol "Setujui Kuota"
    And user membuka halaman "Tolak Pengajuan Kuota" dengan konteks "session:Pusat-B"
    And user mengisi field "Alasan Penolakan" dengan "Revisi diperlukan"
    And user mengklik tombol "Tolak Pengajuan"
    And user membuka halaman "Detail Pengajuan"
    And user memeriksa elemen "Pengajuan" dengan kondisi "tepat satu keputusan terminal sesuai commit pertama"
    And user memeriksa elemen "Riwayat" dengan kondisi "tepat satu event keputusan; aksi kalah mendapat konflik"
    Then sistem memenuhi hasil "Keputusan terakhir tidak overwrite keputusan yang sudah final"

  @edge @priority-high @REQ-010 @screen-konfirmasi-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-057 — Race pembatalan Cabang dengan approve Pusat atomik
    Given user berada di halaman "Konfirmasi Pengajuan"
    And kondisi awal "Cabang dan Pusat mempunyai modal atas pengajuan Menunggu yang sama"
    When user mengklik tombol "Batalkan Pengajuan"
    And user membuka halaman "Setujui Kuota" dengan konteks "session:Pusat"
    And user mengklik tombol "Setujui Kuota"
    And user membuka halaman "Detail Pengajuan"
    And user memeriksa elemen "Pengajuan" dengan kondisi "Dibatalkan atau Disetujui menurut transaksi pertama"
    And user memeriksa elemen "Riwayat" dengan kondisi "satu transisi terminal sah; aksi kalah konflik"
    Then sistem memenuhi hasil "Tidak ada kombinasi Dibatalkan tetapi gate approved atau dua audit keputusan sukses"

  @edge @priority-high @REQ-009 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-EDG-058 — Pusat dengan versi lama tidak memutuskan kuota hasil resubmit
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal versi 1; Cabang telah cancel/revise/resubmit menjadi versi 2"
    When user mengklik tombol "Setujui Kuota"
    And user memeriksa elemen "Setujui Kuota" dengan kondisi "konflik versi; perlu muat ulang"
    And user membuka halaman "Detail Pengajuan"
    And user memeriksa elemen "Pengajuan" dengan kondisi "versi 2 Menunggu"
    And user memeriksa elemen "Kuota vs Kapasitas Kapal" dengan kondisi "nilai versi 2 terbaru"
    Then sistem memenuhi hasil "Approval versi lama tidak mengesahkan kuota yang belum ditinjau"

  @stress @priority-high @REQ-004 @screen-konfirmasi-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-STR-001 — Sepuluh klik submit tidak membuat pengajuan ganda
    Given user berada di halaman "Konfirmasi Pengajuan"
    And kondisi awal "Cabang Balikpapan / Suyanto; modal Ajukan data valid"
    When user mengklik tombol "Ajukan ke Pusat"
    And user memeriksa elemen "Status" dengan kondisi "Hanya satu pengajuan Menunggu dan satu event submit tersimpan"
    Then sistem memenuhi hasil "Hanya satu pengajuan Menunggu dan satu event submit tersimpan"

  @stress @priority-high @REQ-007 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-STR-002 — Seratus sesi Pusat menyetujui pengajuan yang sama
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; 100 sesi pada Menunggu versi sama"
    When user mengklik tombol "Setujui Kuota"
    And user memeriksa elemen "Status" dengan kondisi "Tepat satu keputusan dan satu audit approval; sisanya konflik/idempotent tanpa duplikat"
    Then sistem memenuhi hasil "Tepat satu keputusan dan satu audit approval; sisanya konflik/idempotent tanpa duplikat"

  @stress @priority-high @REQ-008 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-STR-003 — Seratus reject paralel pada pengajuan yang sama
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; 100 sesi pada Menunggu yang sama"
    When user mengisi field "Alasan Penolakan" dengan "Perlu revisi"
    And user mengklik tombol "Tolak Pengajuan"
    And user memeriksa elemen "Status" dengan kondisi "Satu alasan aktor waktu dari keputusan pemenang; tidak ada audit keputusan ganda"
    Then sistem memenuhi hasil "Satu alasan aktor waktu dari keputusan pemenang; tidak ada audit keputusan ganda"

  @stress @priority-high @REQ-010 @screen-konfirmasi-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-STR-004 — Pembatalan berulang tidak menghilangkan draft
    Given user berada di halaman "Konfirmasi Pengajuan"
    And kondisi awal "Cabang Balikpapan / Suyanto; pengajuan sendiri Menunggu"
    When user mengklik tombol "Batalkan Pengajuan"
    And user memeriksa elemen "Status" dengan kondisi "Satu transisi Dibatalkan; draft kuota retained; riwayat tidak ganda"
    Then sistem memenuhi hasil "Satu transisi Dibatalkan; draft kuota retained; riwayat tidak ganda"

  @stress @priority-high @REQ-009 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-STR-005 — Seratus siklus revisi dan ajukan ulang voyage sama
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; fixture satu voyage dapat ditolak oleh Pusat tiap siklus"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "400"
    And user mengklik tombol "Simpan & Ajukan Ulang"
    And user mengklik tombol "Ajukan ke Pusat"
    And user memeriksa elemen "Status" dengan kondisi "Satu voyage; tiap siklus versi baru; riwayat tidak hilang dan satu Menunggu terbaru"
    Then sistem memenuhi hasil "Satu voyage; tiap siklus versi baru; riwayat tidak hilang dan satu Menunggu terbaru"

  @stress @priority-high @REQ-022 @screen-detail-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-STR-006 — Riwayat seribu event dapat dibuka tanpa kehilangan event
    Given user berada di halaman "Detail Pengajuan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; fixture 1000 event berurutan"
    When user memeriksa elemen "Riwayat" dengan kondisi "1000 event tersedia melalui navigasi/scroll existing; ID actor timestamp urut"
    And user memeriksa elemen "Status" dengan kondisi "Semua event konsisten; halaman dapat digunakan tanpa crash"
    Then sistem memenuhi hasil "Semua event konsisten; halaman dapat digunakan tanpa crash"

  @stress @priority-high @REQ-026 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-STR-007 — Bulk seribu pengajuan campuran tetap mematuhi status
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal menampilkan 700 Menunggu dari dataset 1000; 20 over-capacity"
    When user mencentang checkbox "Konfirmasi Semua Melebihi Kapasitas"
    And user mengklik tombol "Setujui Semua"
    And user memeriksa elemen "Status" dengan kondisi "Hanya 700 kandidat valid diproses; 300 status lain tetap; audit per item tersedia"
    Then sistem memenuhi hasil "Hanya 700 kandidat valid diproses; 300 status lain tetap; audit per item tersedia"

  @stress @priority-high @REQ-027 @screen-approval-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-STR-008 — Antrean seribu pengajuan dengan paging 50 data
    Given user berada di halaman "Approval Kuota"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; 1000 pengajuan lintas Cabang"
    When user memilih opsi "50" pada dropdown "Jumlah Data"
    And user mengklik tombol "Menunggu Approval"
    And user mengklik tombol "Halaman Berikutnya"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "ID unik, count konsisten, hanya Menunggu dan role berhak"
    And user memeriksa elemen "Status" dengan kondisi "Semua page dapat dimuat dan data tidak bocor/duplikat"
    Then sistem memenuhi hasil "Semua page dapat dimuat dan data tidak bocor/duplikat"

  @stress @priority-high @REQ-019 @screen-daftar-kuota-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-STR-009 — Seratus sesi Cabang berbeda tetap terisolasi
    Given user berada di halaman "Daftar Kuota & Jadwal"
    And kondisi awal "100 sesi Cabang berbeda; masing-masing 10 draft dan 10 proses"
    When user mengklik tombol "Semua"
    And user memeriksa elemen "Daftar Kuota & Jadwal" dengan kondisi "hanya draft/proses milik sesi plus jadwal final yang berhak"
    And user memeriksa elemen "Status" dengan kondisi "Tidak ada kebocoran data antar Cabang melalui cache atau paging"
    Then sistem memenuhi hasil "Tidak ada kebocoran data antar Cabang melalui cache atau paging"

  @stress @priority-high @REQ-014 @screen-setting-jadwal
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-STR-010 — Simpan Draft berulang pada Jadwal tidak memfinalisasi
    Given user berada di halaman "Setting Jadwal Keberangkatan"
    And kondisi awal "Cabang Balikpapan / Suyanto; Jadwal terbuka; parsial berangkat terisi"
    When user mengisi field "Waktu Berangkat" dengan "2026-10-10T12:00"
    And user mengklik tombol "Simpan Draft"
    And user memeriksa elemen "Status" dengan kondisi "Draft terakhir persisten; Crew tetap locked; tidak membuat jadwal final"
    Then sistem memenuhi hasil "Draft terakhir persisten; Crew tetap locked; tidak membuat jadwal final"

  @stress @priority-high @REQ-016 @screen-crew-list
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-STR-011 — Finalisasi Crew berulang tidak mempublikasikan duplikat
    Given user berada di halaman "Crew List"
    And kondisi awal "Cabang Balikpapan / Suyanto; Crew 12 lengkap; Jadwal final"
    When user mengklik tombol "Selesai"
    And user memeriksa elemen "Status" dengan kondisi "Satu jadwal final dan crew list utuh; no duplicate publication"
    Then sistem memenuhi hasil "Satu jadwal final dan crew list utuh; no duplicate publication"

  @stress @priority-high @REQ-028 @screen-konfirmasi-pengajuan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-STR-012 — Koneksi lambat saat submit menjaga data dan status
    Given user berada di halaman "Konfirmasi Pengajuan"
    And kondisi awal "Cabang Balikpapan / Suyanto; submit valid; fixture respons ditunda"
    When user mengklik tombol "Ajukan ke Pusat"
    And user memeriksa elemen "Status" dengan kondisi "Aksi in-flight tidak menduplikasi submit; hasil/reconcile konsisten tanpa sukses palsu"
    Then sistem memenuhi hasil "Aksi in-flight tidak menduplikasi submit; hasil/reconcile konsisten tanpa sukses palsu"

  @stress @priority-high @REQ-028 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-STR-013 — Kegagalan sebagian bulk dilaporkan dan dapat direkonsiliasi
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; 100 kandidat; fixture 10 gagal sebelum commit"
    When user mengklik tombol "Setujui Semua"
    And user membuka halaman "Approval Kuota"
    And user memeriksa elemen "Daftar Pengajuan Kuota" dengan kondisi "hasil per ID jelas; ID gagal tetap Menunggu; commit berhasil punya audit"
    And user memeriksa elemen "Status" dengan kondisi "Tidak ada klaim semua sukses palsu; retry hanya ID yang belum commit"
    Then sistem memenuhi hasil "Tidak ada klaim semua sukses palsu; retry hanya ID yang belum commit"

  @stress @priority-high @REQ-008 @screen-konfirmasi-keputusan
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-STR-014 — Payload alasan sepuluh ribu karakter ditangani aman
    Given user berada di halaman "Konfirmasi Keputusan"
    And kondisi awal "Kantor Pusat / Achmad Riyanto; modal reject Menunggu"
    When user mengisi field "Alasan Penolakan" dengan "RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR"
    And user mengklik tombol "Tolak Pengajuan"
    And user memeriksa elemen "Alasan Penolakan" dengan kondisi "tersimpan utuh atau validasi batas existing; tidak silent truncate / crash"
    Then sistem memenuhi hasil "Sistem menerima utuh atau menolak dengan pesan batas yang jelas; audit konsisten dengan hasil"

  @stress @priority-high @REQ-023 @screen-setting-kuota
  Scenario: RO319-SETTING-KUOTA-JADWAL-ADA-APPROVAL-STR-015 — Paste kuota sepuluh ribu digit tidak crash atau mengubah nilai
    Given user berada di halaman "Setting Kuota"
    And kondisi awal "Cabang Balikpapan / Suyanto; draft persisten Ekonomi=400"
    When user mengisi field "Kuota Internal — Ekonomi Lesehan" dengan "9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999"
    And user memeriksa elemen "Kuota Internal — Ekonomi Lesehan" dengan kondisi "invalid; nilai persisten 400 tidak berubah"
    And user memeriksa elemen "Total kuota" dengan kondisi "tidak NaN/Infinity/success palsu"
    Then sistem memenuhi hasil "Payload di luar batas format ditangani aman dan form dapat dipulihkan"

