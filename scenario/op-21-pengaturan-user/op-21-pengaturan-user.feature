# language: id
Fitur: OP-21 Pengaturan User — Hak Akses, Sub User, Petugas Scan, Hak Akses Agen, Sub User Agen
  Sumber aturan: Rule RORO v1.5.0 P818–P849 (lihat op-21-pengaturan-user_analysis.md).
  Data uji berprefix AUTOTEST-20260925-; dibersihkan di akhir run (petugas → sub user → hak akses).

  @positive @high @SCR-01 @REQ-018
  Skenario: SCN-0001 Daftar Hak Akses tampil dengan kolom dan tombol Tambah Hak Akses
    Ketika Login sebagai Operator Pusat
    Dan Buka /partner/hakAkses
    Dan Tunggu tabel dirender
    Maka Header tabel memuat kolom No, Nama Hak Akses, Deskripsi, Total Hak Akses, Aksi
    Dan Tombol/link 'Tambah Hak Akses' terlihat
    Dan Minimal satu baris data tampil dengan format 'N Hak Akses' pada kolom Total

  @negative @high @SCR-02 @VAL-001
  Skenario: SCN-0002 Simpan Tambah Hak Akses tanpa Nama menampilkan popover "Masukkan Nama Hak Akses"
    Ketika Buka /partner/buathakakses
    Dan Biarkan Nama kosong, isi Deskripsi
    Dan Klik Simpan (#submit_crew)
    Maka Popover berteks 'Masukkan Nama Hak Akses' tampil
    Dan Tetap berada di halaman Tambah Hak Akses

  @negative @medium @SCR-02 @VAL-001
  Skenario: SCN-0003 Simpan Tambah Hak Akses tanpa Deskripsi menampilkan popover "Masukkan Deskripsi Hak Akses"
    Ketika Buka /partner/buathakakses
    Dan Isi Nama, biarkan Deskripsi kosong
    Dan Klik Simpan
    Maka Popover berteks 'Masukkan Deskripsi Hak Akses' tampil
    Dan Tetap di halaman Tambah Hak Akses

  @negative @high @SCR-02 @VAL-002
  Skenario: SCN-0004 Simpan Tambah Hak Akses tanpa akses tercentang menampilkan alert "Pilih Hak akses minimal 1"
    Ketika Buka /partner/buathakakses
    Dan Isi Nama dan Deskripsi, jangan centang akses apa pun
    Dan Klik Simpan
    Maka Dialog alert berteks 'Pilih Hak akses minimal 1' muncul
    Dan Data tidak tersimpan, tetap di halaman Tambah

  @positive @high @SCR-02 @REQ-002
  Skenario: SCN-0005 Centang Modul Jual Tiket otomatis mencentang Lihat Daftar Order dan Lihat Detail Order
    Ketika Buka /partner/buathakakses
    Dan Centang 'Modul Jual Tiket (Pilih Semua)' (#modul_jualtiket)
    Maka Checkbox 'Lihat Daftar Order' (#melihat_daftar_penjualan) tercentang
    Dan Checkbox 'Lihat Detail Order' (#melihat_detail_penjualan) tercentang
    Dan Checkbox 'Jual Tiket' (#melihat_jualtiket) tercentang

  @positive @high @SCR-02 @REQ-003
  Skenario: SCN-0006 Centang Modul Daftar Piutang otomatis mencentang Lihat Daftar Order dan Lihat Detail Order
    Ketika Buka /partner/buathakakses
    Dan Centang 'Modul Daftar Piutang (Pilih Semua)' (#modul_piutang)
    Maka #melihat_daftar_penjualan tercentang
    Dan #melihat_detail_penjualan tercentang
    Dan #melihat_daftar_piutang tercentang

  @positive @high @SCR-02 @REQ-004
  Skenario: SCN-0007 Centang Modul Persetujuan Tiket otomatis mencentang Lihat Daftar Order dan Lihat Detail Order
    Ketika Buka /partner/buathakakses
    Dan Centang 'Modul Persetujuan Tiket (Pilih Semua)' (#modul_persetujuan_tiket)
    Maka #melihat_daftar_penjualan tercentang
    Dan #melihat_detail_penjualan tercentang
    Dan #melihat_persetujuan_tiket tercentang

  @edge @medium @SCR-02 @REQ-001 @FND-04
  Skenario: SCN-0008 Centang akses Edit Hak Akses otomatis mempertahankan Lihat Hak Akses tercentang
    Ketika Buka /partner/buathakakses
    Dan Centang 'Edit Hak Akses' (#edit_hak_akses) saja
    Maka Checkbox 'Lihat Hak Akses' (#melihat_hak_akses) ikut tercentang (field Melihat sebagai tampilan modul)

  @positive @high @SCR-02 @REQ-018 @AC-01
  Skenario: SCN-0009 Buat hak akses AUTOTEST-20260925-HA dengan 7 akses Modul Pengaturan User
    Ketika Buka /partner/buathakakses
    Dan Isi Nama 'AUTOTEST-20260925-HA' dan Deskripsi
    Dan Centang: Lihat Hak Akses, Detail Hak Akses, Lihat Sub User, Detail Sub User, Lihat Petugas Scan, Lihat Hak Akses Agen, Lihat Sub User Agen
    Dan Klik Simpan
    Maka Redirect ke daftar Hak Akses
    Dan Baris 'AUTOTEST-20260925-HA' tampil dengan Total '7 Hak Akses'

  @positive @medium @SCR-03 @REQ-018
  Skenario: SCN-0010 Detail hak akses AUTOTEST-20260925-HA menampilkan nama, deskripsi, total dan perijinan
    Ketika Di daftar, klik aksi Lihat pada baris 'AUTOTEST-20260925-HA'
    Maka Halaman DETAIL HAK AKSES memuat 'Nama Hak Akses : AUTOTEST-20260925-HA'
    Dan 'Total Hak Akses : 7'
    Dan Perijinan memuat 'Lihat Hak Akses', 'Detail Sub User', 'Lihat Petugas Scan', 'Lihat Sub User Agen'

  @positive @high @SCR-04 @REQ-018 @FND-08
  Skenario: SCN-0011 Edit hak akses AUTOTEST-20260925-HA dengan Pilih Semua Modul Pengaturan User menghitung total tanpa checkbox Pilih Semua
    Ketika Klik aksi Edit pada baris 'AUTOTEST-20260925-HA'
    Dan Centang 'Modul Pengaturan User (Pilih Semua)' (#modul_user)
    Dan Verifikasi 20 sub-akses modul Pengaturan User tercentang
    Dan Klik Simpan (#update_data)
    Maka Redirect ke daftar
    Dan Baris 'AUTOTEST-20260925-HA' menampilkan Total '20 Hak Akses' (checkbox Pilih Semua tidak dihitung)

  @positive @medium @SCR-01 @VAL-009
  Skenario: SCN-0012 Filter daftar Hak Akses berdasarkan nama lalu Reset
    Ketika Buka /partner/hakAkses, klik Filter (#btn-filter)
    Dan Isi Nama Hak Akses 'AUTOTEST-20260925-HA', klik tombol Filter (submit)
    Dan Klik Reset
    Maka Setelah filter hanya baris 'AUTOTEST-20260925-HA' yang tampil
    Dan Setelah Reset daftar penuh (lebih dari 1 baris) tampil kembali

  @negative @high @SCR-01 @REQ-005 @AC-05
  Skenario: SCN-0013 Hapus hak akses yang sedang dipakai sub user ditolak
    Ketika Pastikan sub user AUTOTEST-20260925-SU memakai hak akses AUTOTEST-20260925-HA
    Dan Di daftar Hak Akses klik aksi Hapus pada baris tersebut
    Maka Muncul alert 'Tidak bisa hapus! Hak akses sudah digunakan.'
    Dan Baris tetap ada di daftar

  @positive @high @SCR-01 @REQ-005 @AC-05
  Skenario: SCN-0014 Hapus hak akses AUTOTEST-20260925-HA setelah tidak dipakai berhasil
    Ketika Pastikan sub user AUTOTEST-20260925-SU sudah dihapus
    Dan Klik aksi Hapus pada baris hak akses uji
    Dan Klik 'Ya' pada konfirmasi 'Apakah anda yakin ingin hapus hak akses?'
    Maka Baris hak akses uji hilang dari daftar

  @edge @low @SCR-01 @REQ-005
  Skenario: SCN-0015 Batal pada konfirmasi hapus hak akses tidak menghapus data
    Ketika Klik aksi Hapus pada baris hak akses uji (tidak sedang dipakai)
    Dan Klik 'Batal' pada konfirmasi
    Maka Konfirmasi tertutup
    Dan Baris hak akses uji tetap ada

  @positive @high @SCR-05 @REQ-019
  Skenario: SCN-0016 Daftar Sub User tampil dengan kolom, filter, dan tombol Tambah Sub User
    Ketika Buka /partner/subUser
    Dan Klik Filter (#btn-filter)
    Maka Header tabel memuat No, Nama Sub User, Email Sub User, Jenis User, Cabang Kota, Status User, Aksi
    Dan Tombol 'Tambah Sub User' terlihat
    Dan Field filter Nama, Jenis User, Email, Cabang Kota, Status User tampil

  @negative @high @SCR-06 @VAL-003
  Skenario: SCN-0017 Simpan Tambah Sub User kosong menampilkan popover "Masukkan email"
    Ketika Buka /partner/buatsubuser
    Dan Klik Simpan (#submit_sub) tanpa mengisi apa pun
    Maka Popover 'Masukkan email' tampil
    Dan Tetap di halaman Tambah Sub User

  @negative @high @SCR-06 @REQ-010 @AC-04
  Skenario: SCN-0018 Email sub user yang sudah terdaftar ditolak
    Ketika Buka /partner/subUser, ambil email sub user pada baris pertama
    Dan Buka /partner/buatsubuser, ketik email tersebut pada field Email
    Dan Klik Simpan
    Maka Penanda '.email_alert' tampil setelah pengecekan email
    Dan Popover 'Email sudah Terdaftar' tampil saat Simpan
    Dan Data tidak tersimpan

  @negative @medium @SCR-06 @VAL-005
  Skenario: SCN-0019 Kata sandi tanpa huruf ditolak dengan pesan "Password Harus Terdiri Dari Huruf & Angka"
    Ketika Buka /partner/buatsubuser
    Dan Isi Email valid, Kata Sandi '123456'
    Dan Klik Simpan
    Maka Popover 'Password Harus Terdiri Dari Huruf & Angka' tampil

  @negative @medium @SCR-06 @VAL-004
  Skenario: SCN-0020 Konfirmasi kata sandi berbeda ditolak dengan pesan "Password Belum Sama"
    Ketika Buka /partner/buatsubuser
    Dan Isi Email valid, Kata Sandi 'Autotest2026', Konfirmasi 'Autotest2027'
    Dan Klik Simpan
    Maka Popover 'Password Belum Sama' tampil

  @negative @medium @SCR-06 @VAL-007
  Skenario: SCN-0021 Format email tidak valid ditolak
    Ketika Buka /partner/buatsubuser
    Dan Ketik 'autotest-salah' pada Email
    Dan Klik Simpan
    Maka Popover 'Masukkan Email dengan benar' (atau 'Penulisan email salah') tampil

  @negative @medium @SCR-06 @VAL-003 @FND-03
  Skenario: SCN-0022 Simpan Tambah Sub User tanpa Jenis User menampilkan pesan "Pilih Jenis User"
    Ketika Buka /partner/buatsubuser
    Dan Isi Email, Kata Sandi, Konfirmasi, Nama, Nomor WA; biarkan Jenis User kosong
    Dan Klik Simpan
    Maka Popover 'Pilih Jenis User' tampil
    Dan Tetap di halaman Tambah Sub User

  @positive @medium @SCR-06 @VAL-006 @REQ-007
  Skenario: SCN-0023 Jenis User Kantor Cabang mengaktifkan Cabang Kota, Kantor Pusat menonaktifkannya
    Ketika Buka /partner/buatsubuser
    Dan Pilih Jenis User 'Kantor Cabang'
    Dan Pilih Jenis User 'Kantor Pusat'
    Maka Setelah Kantor Cabang: select Cabang Kota enabled
    Dan Setelah Kantor Pusat: select Cabang Kota disabled

  @positive @high @SCR-06 @REQ-019 @REQ-006 @VAL-003 @AC-03
  Skenario: SCN-0024 Buat sub user AUTOTEST-20260925-SU Kantor Pusat dengan hak akses AUTOTEST-20260925-HA
    Ketika Buka /partner/buatsubuser
    Dan Isi Email autotest-20260925-su@example.com, Kata Sandi & Konfirmasi 'Autotest2026', Nama 'AUTOTEST-20260925-SU', WA 081200000925
    Dan Pilih Jenis User Kantor Pusat, Bagian Staff, Status Aktif
    Dan Pilih Hak Akses 'AUTOTEST-20260925-HA'
    Dan Klik Simpan
    Maka Redirect ke daftar Sub User
    Dan Baris 'AUTOTEST-20260925-SU' tampil dengan email uji, Jenis User 'Pusat', Cabang Kota '-', Status 'AKTIF'

  @positive @medium @SCR-07 @REQ-019
  Skenario: SCN-0025 Detail sub user AUTOTEST-20260925-SU menampilkan data dan hak akses yang dipilih
    Ketika Klik aksi Detail pada baris 'AUTOTEST-20260925-SU'
    Maka DETAIL SUB USER memuat 'Nama : AUTOTEST-20260925-SU'
    Dan 'Jenis User : Pusat'
    Dan 'Hak Akses : AUTOTEST-20260925-HA'
    Dan 'Status User : AKTIF'

  @positive @high @SCR-08 @REQ-008 @AC-06
  Skenario: SCN-0026 Ganti kata sandi sub user AUTOTEST-20260925-SU melalui Edit berhasil disimpan
    Ketika Klik aksi Edit pada baris 'AUTOTEST-20260925-SU'
    Dan Klik 'Ganti kata sandi' (#ganti_sandi)
    Dan Isi Kata Sandi & Konfirmasi 'Autotest2026b'
    Dan Klik Simpan
    Maka Setelah klik Ganti kata sandi field sandi aktif (tidak readonly, type password, kosong)
    Dan Redirect ke daftar Sub User tanpa pesan error

  @negative @medium @SCR-08 @REQ-008 @VAL-004
  Skenario: SCN-0027 Ganti kata sandi dengan konfirmasi berbeda ditolak
    Ketika Klik aksi Edit pada baris 'AUTOTEST-20260925-SU'
    Dan Klik 'Ganti kata sandi'
    Dan Isi Kata Sandi 'Autotest2026b', Konfirmasi 'Autotest2026c'
    Dan Klik Simpan
    Maka Popover 'Password Belum Sama' tampil
    Dan Tetap di halaman Edit Sub User

  @positive @medium @SCR-05 @VAL-009
  Skenario: SCN-0028 Filter daftar Sub User berdasarkan email lalu Reset
    Ketika Buka /partner/subUser, klik Filter
    Dan Isi Email 'autotest-20260925-su@example.com', klik tombol Filter (submit)
    Dan Klik Reset
    Maka Hanya baris 'AUTOTEST-20260925-SU' yang tampil
    Dan Setelah Reset daftar penuh tampil kembali

  @positive @high @SCR-05 @REQ-005
  Skenario: SCN-0029 Hapus sub user AUTOTEST-20260925-SU berhasil
    Ketika Klik aksi Hapus pada baris 'AUTOTEST-20260925-SU'
    Dan Klik 'Ya' pada konfirmasi 'Apakah anda yakin ingin hapus sub user?'
    Maka Baris 'AUTOTEST-20260925-SU' hilang dari daftar

  @positive @high @SCR-09 @REQ-014 @REQ-015
  Skenario: SCN-0030 Daftar Petugas Scan tampil dengan kolom, tombol Tambah dan Download Scanner
    Ketika Buka /partner/petugasscan
    Maka Header tabel memuat No, Nama Petugas, Nomor WA, Email Petugas, Cabang Kota, Status User, Aksi
    Dan Tombol 'Tambah Petugas Scan' dan 'Download Scanner' terlihat (Download tidak diklik)

  @negative @high @SCR-10 @VAL-008
  Skenario: SCN-0031 Simpan Tambah Petugas Scan kosong menampilkan popover "Masukkan Email"
    Ketika Buka /partner/tambahPetugasScan_
    Dan Klik Simpan (#btn_petugas)
    Maka Popover 'Masukkan Email' tampil
    Dan Tetap di halaman Buat Petugas Scan

  @negative @medium @SCR-10 @VAL-008
  Skenario: SCN-0032 Nomor WA lebih dari 13 digit ditolak
    Ketika Buka /partner/tambahPetugasScan_
    Dan Isi Email, Sandi, Konfirmasi, Nama, Bagian Staff, WA 14 digit
    Dan Klik Simpan
    Maka Popover 'Tidak boleh lebih dari 13 angka' tampil

  @negative @medium @SCR-10 @VAL-008 @REQ-013
  Skenario: SCN-0033 Tambah Petugas Scan tanpa Cabang Kota ditolak dengan pesan "Pilih Kota"
    Ketika Buka /partner/tambahPetugasScan_
    Dan Isi semua field teks valid, biarkan Cabang Kota kosong
    Dan Klik Simpan
    Maka Popover 'Pilih Kota' tampil

  @negative @medium @SCR-10 @REQ-014
  Skenario: SCN-0034 Tambah Petugas Scan tanpa Jenis Akses Aplikasi ditolak dengan pesan "Pilih Akses"
    Ketika Buka /partner/tambahPetugasScan_
    Dan Isi semua field valid termasuk Cabang Kota, biarkan Jenis Akses Aplikasi kosong
    Dan Klik Simpan
    Maka Popover 'Pilih Akses' tampil

  @positive @high @SCR-10 @REQ-012 @REQ-014 @REQ-015 @AC-07
  Skenario: SCN-0035 Buat petugas scan AUTOTEST-20260925-PS memakai email dan WA sub user AUTOTEST-20260925-SU
    Ketika Buka /partner/tambahPetugasScan_
    Dan Isi Email autotest-20260925-su@example.com (email sub user uji), Sandi & Konfirmasi 'Autotest2026', Nama 'AUTOTEST-20260925-PS', Bagian Staff, WA 081200000925 (WA sub user uji)
    Dan Pilih Cabang Kota 'Surabaya', Jenis Akses 'Scan Check In' dan 'Scan Boarding', Status Aktif
    Dan Klik Simpan
    Maka Tidak ada alert 'Email Sudah Ada' (email/WA sub user boleh dipakai petugas scan)
    Dan Redirect ke daftar Petugas Scan
    Dan Baris 'AUTOTEST-20260925-PS' tampil dengan Cabang Kota 'Surabaya' dan Status 'AKTIF'

  @positive @medium @SCR-11 @REQ-014
  Skenario: SCN-0036 Detail petugas scan AUTOTEST-20260925-PS menampilkan jenis akses dan status
    Ketika Klik aksi Lihat pada baris 'AUTOTEST-20260925-PS'
    Maka Halaman DETAIL PETUGAS SCAN memuat nama petugas uji
    Dan 'Jenis Akses Aplikasi' memuat 'Scan Check in' dan 'Scan Boarding'
    Dan 'Status User' AKTIF

  @positive @medium @SCR-11 @REQ-015
  Skenario: SCN-0037 Edit petugas scan AUTOTEST-20260925-PS menjadi Tidak Aktif tampil di daftar
    Ketika Klik aksi Edit pada baris 'AUTOTEST-20260925-PS'
    Dan Ubah Status User menjadi 'Tidak Aktif'
    Dan Klik Simpan
    Maka Redirect ke daftar Petugas Scan
    Dan Baris 'AUTOTEST-20260925-PS' menampilkan Status 'TIDAK AKTIF'

  @negative @medium @SCR-10 @VAL-008
  Skenario: SCN-0038 Tambah petugas scan dengan email petugas yang sudah ada ditolak "Email Sudah Ada"
    Ketika Buka /partner/tambahPetugasScan_
    Dan Isi form valid dengan email petugas uji yang sudah ada (autotest-20260925-su@example.com)
    Dan Klik Simpan
    Maka Alert 'Email Sudah Ada' muncul
    Dan Tetap di halaman Buat Petugas Scan

  @positive @high @SCR-09 @REQ-015
  Skenario: SCN-0039 Hapus petugas scan AUTOTEST-20260925-PS berhasil
    Ketika Klik aksi Hapus pada baris 'AUTOTEST-20260925-PS'
    Dan Klik 'Hapus' pada konfirmasi 'Hapus?'
    Maka Baris 'AUTOTEST-20260925-PS' hilang dari daftar

  @positive @high @SCR-12 @REQ-016 @AC-08
  Skenario: SCN-0040 Daftar Hak Akses Agen hanya menyediakan aksi Lihat
    Ketika Buka /partner/hakAksesagen
    Maka Header tabel memuat No, Nama Agen, Nama Hak Akses, Deskripsi, Total Hak Akses, Aksi
    Dan Setiap baris data hanya punya aksi Lihat (link detailhakaksesagen), tanpa Edit/Hapus

  @negative @high @SCR-12 @REQ-016 @FND-01
  Skenario: SCN-0041 Operator pusat tidak memiliki tombol Tambah Hak Akses pada Hak Akses Agen
    Ketika Login Operator Pusat, buka /partner/hakAksesagen
    Maka Tidak ada tombol/link 'Tambah Hak Akses' (operator hanya list & detail, P841)

  @positive @medium @SCR-13 @REQ-016
  Skenario: SCN-0042 Detail Hak Akses Agen menampilkan agen, nama, total dan perijinan
    Ketika Klik aksi Lihat pada baris pertama Hak Akses Agen
    Maka Halaman DETAIL HAK AKSES AGEN memuat 'Agen :', 'Nama Hak Akses :', 'Total Hak Akses :', dan 'PERIJINAN HAK AKSES'
    Dan Link KEMBALI tersedia

  @positive @medium @SCR-12 @REQ-016
  Skenario: SCN-0043 Filter Nama Agen pada Hak Akses Agen pusat memuat semua agen pusat
    Ketika Buka /partner/hakAksesagen, klik Filter
    Maka Select Nama Agen memuat lebih dari satu agen (mis. RORO COBA, PT. Agen RORO Balikpapan, PT. Integritas Kuasa)

  @positive @high @SCR-14 @REQ-017 @AC-08
  Skenario: SCN-0044 Daftar Sub User Agen hanya menyediakan aksi Detail tanpa tombol Tambah
    Ketika Buka /partner/subuseragen
    Maka Tidak ada link 'Tambah'
    Dan Baris data hanya punya aksi Detail (link detailsubuseragen), tanpa Edit/Hapus

  @positive @medium @SCR-15 @REQ-017
  Skenario: SCN-0045 Detail Sub User Agen menampilkan nama agen, sub user, hak akses dan status
    Ketika Klik aksi Detail pada baris pertama Sub User Agen
    Maka Halaman DETAIL SUB USER memuat 'Nama Agen :', 'Nama Sub User :', 'Hak Akses :', 'Status User :'

  @positive @high @SCR-12 @REQ-016 @AC-09
  Skenario: SCN-0046 Cabang: Hak Akses Agen tanpa tombol Tambah dan filter agen hanya agen sekota
    Ketika Login Operator Cabang Pare-Pare (Sub User Cabang)
    Dan Buka /partner/hakAksesagen, klik Filter
    Maka Tidak ada link 'Tambah Hak Akses'
    Dan Opsi select Nama Agen tidak memuat agen luar kota (RORO COBA / Balikpapan)

  @negative @high @SCR-12 @REQ-016 @AC-09 @FND-02
  Skenario: SCN-0047 Cabang: daftar Hak Akses Agen hanya memuat agen sekota
    Ketika Login Operator Cabang Pare-Pare
    Dan Buka /partner/hakAksesagen
    Maka Baris tabel tidak memuat hak akses agen luar kota (mis. 'RORO COBA' / Agen Surabaya) — P843

  @positive @medium @SCR-14 @REQ-017 @AC-09
  Skenario: SCN-0048 Cabang: daftar Sub User Agen hanya memuat agen sekota
    Ketika Login Operator Cabang Pare-Pare
    Dan Buka /partner/subuseragen
    Maka Baris tabel tidak memuat sub user agen luar kota ('RORO COBA'); bila tidak ada agen sekota tampil 'Tidak Ada Data yang tersedia'

  @positive @medium @SCR-01 @REQ-020
  Skenario: SCN-0049 Cabang dengan hak akses dapat membuka Hak Akses, Sub User, dan Petugas Scan
    Ketika Login Operator Cabang Pare-Pare (hak akses 'Akses IK')
    Dan Buka /partner/hakAkses, /partner/subUser, /partner/petugasscan
    Maka Ketiga daftar tampil dengan tabel dan tombol Tambah masing-masing
