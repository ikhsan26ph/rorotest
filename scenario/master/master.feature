# language: id
Fitur: OP-11 Master — Kelas, Golongan, Kapal, Trayek, Harga, Tarif Pass, Crew, Denda Pembatalan, Informasi
  Sumber aturan: Rule RORO v1.5.0 P480–P551 (lihat master_analysis.md).
  PERINGATAN: sebagian data uji (Trayek+Harga AUTOTEST-20260927-TRAYEK-AC04, SCN-0015/0017/0019/0021/0023)
  bersifat PERMANEN dan TIDAK dibersihkan di akhir run — lihat catatan 'notes' pada scenarios.json.
  Skenario SCN-0030/0031/0032 (REQ-039/040/043) MEMBUTUHKAN IZIN EKSPLISIT USER dan tidak dijalankan otomatis.

  @negative @high @SCR-01 @REQ-001 @AC-01
  Skenario: SCN-0001 Hapus Kelas yang sudah dipakai di Master Kapal ditolak (data existing, tanpa entitas baru)
    Ketika Buka /partner/mkapal (Daftar Master Kapal), buka salah satu Edit Kapal untuk mencatat Nama Kelas yang dipakai kapal tersebut (select 'kelas[]')
    Dan Buka /partner/masterkelasnew (Daftar Master Kelas)
    Dan Cari baris dengan Nama Kelas yang dicatat, klik aksi Hapus (.btn-delete, id delete_kelas)
    Maka SweetAlert2 muncul dengan title 'Data Digunakan di Master Kapal' (M-01)
    Dan Baris Kelas tetap ada di daftar (tidak terhapus)
    Dan Tidak ada entitas Master baru dibuat pada skenario ini

  @negative @high @SCR-02 @VAL-001 @AC-11 @FND-M-01
  Skenario: SCN-0002 Simpan Tambah Kelas dengan field kosong tidak mengirim request (FND-M-01)
    Ketika Buka /partner/tambahkelas
    Dan Biarkan input Nama Kelas (#nama0) kosong
    Dan Pantau network request, lalu klik Simpan (#submit_kelas)
    Maka Tidak ada popover/alert/pesan validasi apa pun yang tampil
    Dan Tidak ada request POST/AJAX terkirim (verifikasi via browser_network_requests)
    Dan Tetap di halaman Tambah Kelas, tidak ada Kelas baru tersimpan
    # Catatan: Memverifikasi FND-M-01 (kandidat gap desain, bukan bug penyimpanan data karena data memang tidak tersimpan) — aman diulang berkali-kali karena tidak membuat entitas.

  @negative @high @SCR-04 @REQ-004 @AC-02
  Skenario: SCN-0003 Hapus Golongan yang sudah dipakai di Master Kapal ditolak (data existing, tanpa entitas baru)
    Ketika Identifikasi Golongan yang sudah dipakai di Master Kapal (cross-check /partner/mkapal detail/edit kapal existing)
    Dan Buka /partner/mastergolongan
    Dan Klik aksi Hapus (.btn-delete, id delete_golongan) pada baris Golongan tersebut
    Maka Muncul penolakan (SweetAlert/alert) menyatakan data masih dipakai di Master Kapal
    Dan Baris Golongan tetap ada di daftar
    # Catatan: P486 tidak menyebutkan redaksi pesan persis seperti Kelas (P482); catat redaksi pesan apa adanya saat eksekusi. Bila ternyata tidak ada Golongan yang benar-benar terpakai di Kapal (form Tambah Kapal SCR-08 hanya expose 'kelas[]', bukan 'golongan[]'), tandai skenario ini blocked/inconclusive dan laporkan sebagai ketidaksesuaian dokumen vs UI, jangan menebak hasilnya.

  @negative @high @SCR-05 @REQ-002 @VAL-002 @AC-11 @FND-M-01
  Skenario: SCN-0004 Simpan Tambah Golongan dengan field kosong tidak mengirim request (FND-M-01)
    Ketika Buka /partner/tambahgolongan
    Dan Biarkan semua field (Jenis Tiket #jenis1, Nama Golongan Tiket, Status Aktif #muncul1) kosong/tidak dipilih
    Dan Pantau network request, lalu klik Simpan (#submit_golongan)
    Maka Tidak ada popover/alert/pesan validasi yang tampil
    Dan Tidak ada request POST/AJAX terkirim
    Dan Tetap di halaman Tambah Golongan
    # Catatan: Memverifikasi FND-M-01; aman diulang, tidak membuat entitas.

  @edge @medium @SCR-05 @REQ-003
  Skenario: SCN-0005 Golongan Kendaraan: observasi field yang aktif/wajib saat Jenis Tiket = Kendaraan (Q-M-01)
    Ketika Buka /partner/tambahgolongan
    Dan Pilih Jenis Tiket (#jenis1) = 'Kendaraan'
    Dan Amati kolom/field yang muncul aktif pada baris tersebut (Golongan Kendaraan, Bonus Tiket, Kondisi Kendaraan) tanpa mengisi/menyimpan
    Maka Dicatat field mana saja yang benar-benar aktif/wajib saat Jenis Tiket=Kendaraan (observasional, tidak menebak field spesifik dari kalimat sumber P485 yang ambigu)
    Dan Tidak menyimpan data apa pun
    # Catatan: Q-M-01: kalimat sumber P485 ambigu (mengulang kata 'kategori/Kategori'); gunakan matching longgar sesuai catatan master_analysis.md, jangan menebak field spesifik.

  @positive @medium @SCR-05 @REQ-005
  Skenario: SCN-0006 Verifikasi opsi Status Aktif 'Semua Channel' dan 'Hanya Cabang' pada Tambah Golongan
    Ketika Buka /partner/tambahgolongan
    Dan Periksa opsi select Status Aktif (#muncul1)
    Maka Opsi 'Semua Channel' bernilai UMUM tersedia
    Dan Opsi 'Hanya Cabang' bernilai CABANG tersedia
    Dan Tidak menyimpan data apa pun

  @positive @medium @SCR-05 @REQ-006 @REQ-007 @AC-03
  Skenario: SCN-0007 Buat Golongan AUTOTEST-20260927- dengan Status Aktif Semua Channel & Hanya Cabang, verifikasi kolom daftar, lalu hapus
    Ketika Buka /partner/tambahgolongan
    Dan Isi baris 1: Jenis Tiket 'Penumpang', Nama Golongan Tiket 'AUTOTEST-20260927-GOL-UMUM', Status Aktif 'Semua Channel'
    Dan Klik 'Tambah Baris Input' (#add_menu), isi baris 2: Jenis Tiket 'Penumpang', Nama Golongan Tiket 'AUTOTEST-20260927-GOL-CABANG', Status Aktif 'Hanya Cabang'
    Dan Klik Simpan (#submit_golongan)
    Dan Di /partner/mastergolongan, cari kedua baris, verifikasi kolom Status Aktif
    Dan Hapus kedua baris (.btn-delete) sebagai cleanup
    Maka Redirect ke daftar Golongan
    Dan Baris 'AUTOTEST-20260927-GOL-UMUM' menampilkan Status Aktif sesuai 'Semua Channel'
    Dan Baris 'AUTOTEST-20260927-GOL-CABANG' menampilkan Status Aktif sesuai 'Hanya Cabang'
    Dan Setelah cleanup, kedua baris hilang dari daftar
    # Catatan: Data AUTOTEST ini TIDAK dipakai di Master Kapal/submodul lain pada skenario ini sehingga bisa dibersihkan; JANGAN dipakai sebagai pilihan Golongan pada skenario Kapal manapun agar cleanup tetap berhasil.

  @positive @medium @SCR-08 @REQ-008
  Skenario: SCN-0008 Verifikasi pilihan Kelas pada Tambah Kapal berasal dari Master Kelas (multi-select)
    Ketika Buka /partner/masterkelasnew, catat 2-3 Nama Kelas yang ada
    Dan Buka /partner/tambahkapal
    Dan Periksa opsi select[name="kelas[]"]
    Maka Opsi select Kelas berisi persis nama-nama Kelas dari Master Kelas yang dicatat
    Dan Select mendukung pemilihan lebih dari satu (multiple)
    Dan Tidak menyimpan data apa pun

  @negative @high @SCR-08 @REQ-009 @VAL-003 @AC-11 @FND-M-01
  Skenario: SCN-0009 Simpan Tambah Kapal dengan field kosong tidak mengirim request (FND-M-01)
    Ketika Buka /partner/tambahkapal
    Dan Biarkan semua field (#nama_kapal, #kode_kapal, #kapasitas, select[name="kelas[]"]) kosong
    Dan Pantau network request, lalu klik Simpan
    Maka Tidak ada popover/alert/pesan validasi yang tampil
    Dan Tidak ada request POST/AJAX terkirim
    Dan Tetap di halaman Tambah Kapal
    # Catatan: Memverifikasi FND-M-01; aman diulang, tidak membuat entitas.

  @edge @medium @SCR-08 @VAL-003 @FND-M-03
  Skenario: SCN-0010 Verifikasi ketidaksesuaian tanda wajib (*) vs atribut required pada form Tambah Kapal (FND-M-03)
    Ketika Buka /partner/tambahkapal
    Dan Periksa label Nama Kapal, Call Sign, Kapasitas Penumpang, Kelas Yang Tersedia (harus bertanda *)
    Dan Periksa atribut required elemen DOM masing-masing field (#nama_kapal, #kode_kapal, #kapasitas, select[name="kelas[]"])
    Maka Semua label bertanda * (tampil wajib secara visual)
    Dan Atribut required pada elemen DOM = false untuk semuanya (tidak konsisten dengan tanda visual) — kandidat FND-M-03
    Dan Tidak menyimpan data apa pun

  @positive @medium @SCR-11 @REQ-011 @VAL-004
  Skenario: SCN-0011 Verifikasi label wajib Tambah Trayek — semua field bertanda * kecuali Konsumsi Penumpang (P495)
    Ketika Buka /partner/mtrayek_tambah
    Dan Periksa label Nama Trayek, Pilih Pelabuhan, Pelabuhan Dipilih, Pelabuhan Asal, Pelabuhan Tujuan, dan Konsumsi Penumpang
    Maka Nama Trayek, Pilih Pelabuhan, Pelabuhan Dipilih, Pelabuhan Asal, Pelabuhan Tujuan bertanda *
    Dan Konsumsi Penumpang TIDAK bertanda *
    Dan Tidak menyimpan data apa pun

  @negative @high @SCR-11 @REQ-011 @AC-11 @FND-M-01
  Skenario: SCN-0012 Simpan Tambah Trayek dengan field kosong tidak mengirim request (FND-M-01)
    Ketika Buka /partner/mtrayek_tambah
    Dan Biarkan semua field kosong (#nama_trayek, select[name="port[]"], dst.)
    Dan Pantau network request, lalu klik Simpan
    Maka Tidak ada popover/alert/pesan validasi yang tampil
    Dan Tidak ada request POST/AJAX terkirim
    Dan Tetap di halaman Tambah Trayek
    # Catatan: Memverifikasi FND-M-01; aman diulang, tidak membuat entitas.

  @positive @medium @SCR-11 @REQ-012
  Skenario: SCN-0013 Pilih 2 pelabuhan di Tambah Trayek, verifikasi baris rute urut sesuai Pilih Pelabuhan (P496)
    Ketika Buka /partner/mtrayek_tambah
    Dan Pada 'Pilih Pelabuhan' (select[name="port[]"]), pilih 2 pelabuhan berbeda berurutan (Pelabuhan A lalu Pelabuhan B)
    Dan Amati daftar 'Pelabuhan Dipilih' dan baris 'RUTE DIJUAL DARI SATU TRAYEK' yang muncul, TANPA mengisi Nama Trayek/Simpan
    Maka Baris rute yang dihasilkan urut sesuai urutan pemilihan pelabuhan (Pelabuhan A → Pelabuhan B)
    Dan Tidak menyimpan data apa pun

  @positive @medium @SCR-11 @REQ-013
  Skenario: SCN-0014 Pilih 3 pelabuhan di Tambah Trayek, verifikasi baris rute urut tidak melompat (P497–P499)
    Ketika Buka /partner/mtrayek_tambah
    Dan Pada 'Pilih Pelabuhan', pilih 3 pelabuhan berbeda berurutan (Pelabuhan A, B, C)
    Dan Amati baris rute yang dihasilkan, TANPA Simpan
    Maka Baris rute berurutan Pelabuhan A→B, B→C (tidak melompat langsung A→C atau urutan lain)
    Dan Tidak menyimpan data apa pun

  @negative @high @SCR-10 @REQ-014 @REQ-015 @AC-04
  Skenario: SCN-0015 [SEKALI PAKAI - DATA PERMANEN] Buat Trayek+Harga AUTOTEST-20260927-TRAYEK-AC04, verifikasi Edit dan Hapus Trayek ditolak (P500, P501)
    Ketika Buka /partner/mtrayek_tambah, isi Nama Trayek 'AUTOTEST-20260927-TRAYEK-AC04', pilih 2 pelabuhan (mis. Surabaya, Parepare), lengkapi field wajib lainnya, klik Simpan — TRAYEK BENAR-BENAR TERSIMPAN
    Dan Buka /partner/masterharga, cari trayek 'AUTOTEST-20260927-TRAYEK-AC04', buka Tambah Harga (/partner/tambahharga), pilih Trayek & Rute tersebut, klik 'Tambahkan'
    Dan Isi 1 baris harga valid (Jenis Tiket, Golongan, Kelas, Harga, Mulai Berlaku, Kondisi Kendaraan), klik Simpan — HARGA BENAR-BENAR TERSIMPAN
    Dan Kembali ke /partner/DaftarTrayek, klik aksi Edit pada baris 'AUTOTEST-20260927-TRAYEK-AC04'
    Dan Klik aksi Hapus pada baris yang sama
    Maka Aksi Edit ditolak/diblokir (bentuk pasti — alert, tombol nonaktif, atau redirect — dikonfirmasi dan dicatat saat eksekusi)
    Dan Aksi Hapus ditolak/diblokir dengan pesan yang menyebutkan trayek sudah punya harga (redaksi pasti dicatat saat eksekusi)
    Dan Baris Trayek dan baris Harga tetap ada
    # Catatan: SEKALI PAKAI DAN TIDAK BISA DIBERSIHKAN. Trayek+Harga 'AUTOTEST-20260927-TRAYEK-AC04' akan TERTINGGAL PERMANEN di lingkungan setelah skenario ini (Trayek tidak bisa dihapus selama masih ada Harga, sesuai REQ-014/015) — TIDAK ADA LANGKAH CLEANUP di akhir, sesuai instruksi eksplisit untuk modul ini. Entitas ini SENGAJA dipakai ulang oleh SCN-0017 (duplikat harga), SCN-0019 (edit+batal), dan SCN-0021 (riwayat harga) serta SCN-0023 (tarif pass rute baru) untuk meminimalkan jumlah entitas permanen tambahan. Jangan membuat Trayek+Harga permanen kedua untuk tujuan serupa.

  @edge @medium @SCR-10 @FND-M-04
  Skenario: SCN-0016 Klik 'Lihat' pada baris Master Trayek dan Master Crew menampilkan panel collapse kosong (FND-M-04)
    Ketika Buka /partner/DaftarTrayek, klik ikon mata 'Lihat' (a.btn-viewnya) pada salah satu baris data existing (bukan data uji AUTOTEST manapun)
    Dan Amati panel collapse yang terbuka (class .col<id>)
    Dan Buka /partner/MasterCrew, klik ikon mata 'Lihat' pada salah satu baris data existing
    Dan Amati panel collapse yang terbuka
    Maka Kedua panel collapse terbuka (state collapse show) tetapi TIDAK menampilkan detail data (kosong, hanya elemen pembatas visual) — mengonfirmasi atau membantah FND-M-04
    Dan Tidak ada perubahan data (aksi 'Lihat' bersifat read-only)
    # Catatan: Memverifikasi kandidat gap desain FND-M-04 (ditemukan di 2 submodul berbeda saat harvest 27 Sep 2026). Gunakan data existing manapun, tidak perlu entitas baru.

  @negative @high @SCR-13 @REQ-016 @REQ-018 @REQ-019 @REQ-020 @AC-05
  Skenario: SCN-0017 Tambah dan Edit Harga dengan kombinasi duplikat pada Trayek AUTOTEST-20260927-TRAYEK-AC04 ditandai merah/ditolak (P505, P507, Q-M-02)
    Ketika Prasyarat: SCN-0015 sudah dijalankan sehingga Trayek 'AUTOTEST-20260927-TRAYEK-AC04' + 1 baris Harga sudah ada
    Dan Buka Lihat Harga trayek tsb (/partner/lihatharga/<id>), klik 'Tambah Harga', pilih Trayek & Rute yang sama, klik Tambahkan
    Dan Isi baris harga baru dengan kombinasi (Golongan Tiket, Mulai Berlaku, Kondisi Kendaraan) PERSIS SAMA dengan baris harga yang sudah ada dari SCN-0015 (Jenis Tiket/Kelas/Harga boleh beda)
    Dan Klik Simpan
    Dan Kembali ke Lihat Harga, amati baris harga yang duplikat
    Dan Buka Edit pada salah satu baris duplikat, ubah kombinasi agar duplikat dengan baris lain (bila belum), klik Simpan
    Maka Baris harga dengan kombinasi duplikat ditandai warna merah pada tabel (REQ-019) DAN/ATAU Simpan ditolak (REQ-018) — bentuk pasti dicatat saat eksekusi
    Dan Edit Harga dengan kombinasi duplikat mengikuti aturan yang sama (REQ-020)
    Dan Tidak ada Trayek/Harga baru yang dibuat selain yang sudah permanen dari SCN-0015
    # Catatan: REQ-016 diuji sebagai penolakan kombinasi duplikat sesuai Q-M-02 (bukan 'penolakan tambah harga kedua untuk rute yang sama' — tombol Tambah Harga tetap bisa dipakai berulang menurut harvest). Baris harga tambahan yang dibuat di sini menumpuk pada Trayek permanen SCN-0015 — TIDAK BISA dibersihkan (sama seperti SCN-0015), tapi tidak menambah entitas permanen BARU.

  @negative @high @SCR-14 @REQ-017 @VAL-005 @AC-11 @FND-M-01
  Skenario: SCN-0018 Simpan Tambah Harga langkah 2 dengan field kosong tidak mengirim request (FND-M-01, VAL-005)
    Ketika Buka /partner/tambahharga
    Dan Pilih Trayek (#trayek) dan Rute (#rute) apa saja yang sudah ada (data existing, bukan trayek AC-04), klik 'Tambahkan' untuk memunculkan langkah 2
    Dan Biarkan semua field baris (Jenis Tiket, Golongan, Kelas, Harga, Mulai Berlaku, Kondisi Kendaraan) kosong
    Dan Pantau network request, lalu klik Simpan
    Maka Langkah 2 (baris input dinamis) hanya muncul setelah Trayek+Rute dipilih dan 'Tambahkan' diklik (VAL-005)
    Dan Tidak ada popover/alert/pesan validasi yang tampil saat Simpan field kosong
    Dan Tidak ada request POST/AJAX terkirim
    # Catatan: Memverifikasi FND-M-01; memilih Trayek/Rute existing hanya untuk memicu tampilan langkah 2, TIDAK ada data harga yang disimpan (Simpan kosong = silent), aman diulang.

  @edge @medium @SCR-13 @REQ-021
  Skenario: SCN-0019 Edit Harga: menghapus salah satu baris tetap terhapus meski klik Batal (P508, Q-M-03) — bug-candidate
    Ketika Prasyarat: SCN-0015/SCN-0017 sudah dijalankan sehingga Trayek 'AUTOTEST-20260927-TRAYEK-AC04' punya ≥2 baris Harga
    Dan Buka Lihat Harga trayek tsb, klik Edit pada salah satu baris harga (bukan satu-satunya baris, agar minimal 1 baris tersisa)
    Dan Di dalam modal Edit, hapus salah satu baris (tombol hapus baris dalam modal, bila ada)
    Dan Klik 'Batal' (BUKAN Simpan)
    Dan Reload / buka kembali Lihat Harga, periksa apakah baris yang tadi dihapus di modal masih ada
    Maka Bila baris yang dihapus di modal TETAP hilang meski klik Batal → mengonfirmasi P508 sebagai bug-candidate (bukan failed langsung, sesuai catatan sumber sendiri 'harus dipastikan lagi')
    Dan Bila baris tetap ada setelah Batal → P508 tidak berlaku/sudah diperbaiki, catat sebagai passed
    # Catatan: WAJIB memakai data Harga uji (Trayek AC04 dari SCN-0015/17), BUKAN data harga produksi — sesuai Q-M-03. Hasil dicatat sebagai bug-candidate, bukan failed langsung, sesuai instruksi triage.

  @negative @high @SCR-12 @REQ-022 @AC-06
  Skenario: SCN-0020 Hapus Harga yang sudah dipakai di Master Jadwal (Kuota & Jadwal) ditolak (P509)
    Ketika Identifikasi trayek/harga yang statusnya sudah dipakai jadwal aktif (cross-check modul Kuota & Jadwal/OP-12 sebelum eksekusi; JANGAN memakai Trayek AUTOTEST-20260927-TRAYEK-AC04 dari SCN-0015 karena belum tentu punya jadwal)
    Dan Buka /partner/masterharga, buka Lihat Harga trayek tersebut
    Dan Klik 'Hapus Harga' (.hapusHarga) pada baris harga yang dipakai jadwal
    Maka Muncul penolakan (SweetAlert/alert) menyatakan harga masih dipakai di Kuota & Jadwal
    Dan Baris harga tetap ada
    # Catatan: Butuh identifikasi data lintas modul (Kuota & Jadwal) sebelum eksekusi. Jika tidak ditemukan harga yang terverifikasi dipakai jadwal, tandai skenario ini blocked dan laporkan sebagai gap data uji, jangan menebak.

  @positive @medium @SCR-14b @REQ-023 @AC-06
  Skenario: SCN-0021 Riwayat Harga mencatat perubahan tanggal mulai berlaku (edit) dan penghapusan harga (P510–P512)
    Ketika Prasyarat: SCN-0017 (edit/duplikat) dan SCN-0019 (edit+hapus baris) sudah dijalankan pada Trayek 'AUTOTEST-20260927-TRAYEK-AC04'
    Dan Buka Lihat Harga trayek tsb, klik 'Riwayat Harga' (menuju /partner/historyharga/<id>)
    Maka Tabel Riwayat Harga menampilkan kolom Status
    Dan Ada baris riwayat yang mencerminkan perubahan Mulai Berlaku dari aksi Edit sebelumnya
    Dan Ada baris riwayat yang mencerminkan penghapusan baris harga sebelumnya

  @edge @medium @SCR-16 @REQ-024
  Skenario: SCN-0022 Tambah Tarif Pass pada rute yang SUDAH ADA tarif pass — observasi perilaku (P514, Q-M-02)
    Ketika Buka /partner/tarifpass, catat salah satu Trayek/Rute yang sudah punya Tarif Pass
    Dan Buka /partner/tambahtarifpass, pilih Trayek & Rute yang sama, klik 'Tambahkan'
    Dan Amati apakah form langkah 2 muncul, ditolak, atau disembunyikan, TANPA klik Simpan akhir
    Maka Dicatat apakah aplikasi mencegah penambahan kedua untuk rute yang sama, atau mengizinkan — hasil dipakai untuk menjawab Q-M-02, bukan ditebak
    Dan Tidak menyimpan data apa pun (berhenti sebelum Simpan akhir)
    # Catatan: Gunakan matching longgar sesuai Q-M-02 — jangan menyimpulkan makna 'belum pernah ditambahkan' (per-kombinasi atau per-rute) tanpa bukti UI langsung.

  @positive @medium @SCR-16 @REQ-027 @VAL-006
  Skenario: SCN-0023 Tambah Tarif Pass pada rute baru (Trayek AUTOTEST-20260927-TRAYEK-AC04) — verifikasi nilai rekomendasi default terisi (P517)
    Ketika Prasyarat: SCN-0015 sudah dijalankan (Trayek 'AUTOTEST-20260927-TRAYEK-AC04' belum punya Tarif Pass)
    Dan Buka /partner/tambahtarifpass, pilih Trayek 'AUTOTEST-20260927-TRAYEK-AC04' dan Rute-nya, klik 'Tambahkan'
    Dan Amati nilai yang muncul di field-field Tarif Pass (Tiket Penumpang & Kendaraan), TANPA klik Simpan
    Maka Alur 2 langkah (pilih Trayek → Rute → Tambahkan) sesuai VAL-006
    Dan Field harga menampilkan nilai rekomendasi (bukan kosong), berasal dari input Administrator (P517) — dicatat apa adanya
    Dan Tidak menyimpan data apa pun (berhenti sebelum Simpan akhir), sehingga TIDAK menambah entitas Tarif Pass baru

  @negative @high @SCR-15 @REQ-026 @AC-06
  Skenario: SCN-0024 Hapus Tarif Pass yang sudah dipakai di Kuota & Jadwal ditolak (P516)
    Ketika Identifikasi Tarif Pass yang sudah dipakai di Kuota & Jadwal (cross-check modul OP-12 sebelum eksekusi)
    Dan Buka /partner/tarifpass, klik 'Hapus Harga Pass' (.hapusHarga) pada baris tersebut
    Maka Muncul penolakan menyatakan Tarif Pass masih dipakai di Kuota & Jadwal
    Dan Baris tetap ada
    # Catatan: Butuh identifikasi data lintas modul; jika tidak ditemukan, tandai blocked, jangan menebak.

  @negative @high @SCR-23 @REQ-028 @VAL-007 @AC-11 @FND-M-01
  Skenario: SCN-0025 Simpan Tambah Crew dengan field kosong tidak mengirim request (FND-M-01)
    Ketika Buka /partner/tambahcrew
    Dan Biarkan semua 11 field bertanda * kosong (Nama, Jenis Kelamin, Tanggal Lahir, No. Buku Pelaut, dst.)
    Dan Pantau network request, lalu klik Simpan (#submit_crew)
    Maka Tidak ada popover/alert/pesan validasi yang tampil
    Dan Tidak ada request POST/AJAX terkirim
    Dan Tetap di halaman Tambah Crew
    # Catatan: Memverifikasi FND-M-01; aman diulang, tidak membuat entitas.

  @positive @low @SCR-25 @REQ-030
  Skenario: SCN-0026 Verifikasi Denda Pembatalan mengatur tiket Agen (bukan Cabang/User Umum) — teks pada modal Setting (P522, P529)
    Ketika Buka /partner/masterdenda, klik 'Setting' pada salah satu baris (Rusak/Batal/Hangus)
    Dan Baca teks catatan di modal SCR-25
    Dan Tutup modal via Batal (tanpa Simpan)
    Maka Teks modal secara eksplisit menyebut 'tiket agen' (mis. '*) Denda pembatalan tiket agen sebelum cetak tiket : Rp. 0')
    Dan Tidak ada perubahan/simpan apa pun

  @positive @medium @SCR-24 @REQ-031 @REQ-032
  Skenario: SCN-0027 Verifikasi 3 baris default Denda Pembatalan (Rusak, Batal, Hangus) dan kolom Trigger By
    Ketika Buka /partner/masterdenda
    Dan Periksa tabel: jumlah baris dan Nama Denda
    Dan Periksa kolom Trigger By tiap baris
    Maka Persis 3 baris: Rusak, Batal, Hangus (tidak lebih tidak kurang)
    Dan Kolom Trigger By terisi untuk tiap baris (mis. Rusak='Setelah Cetak Tiket', Batal/Hangus='Sebelum Kapal Berangkat')

  @negative @medium @SCR-24 @REQ-033 @AC-08
  Skenario: SCN-0028 Tidak ada tombol 'Tambah' Denda Pembatalan baru di UI operator Pusat maupun Cabang (P525)
    Ketika Login Operator Pusat, buka /partner/masterdenda, cari tombol/link 'Tambah'
    Dan Login Operator Cabang Pare-Pare, buka /partner/masterdenda, cari tombol/link 'Tambah'
    Maka Tidak ada tombol/link 'Tambah Denda' pada akun Pusat
    Dan Tidak ada tombol/link 'Tambah Denda' pada akun Cabang
    Dan Hanya tombol 'Setting' (.tombol_setting_modal) per baris yang tersedia

  @positive @high @SCR-25 @REQ-034 @REQ-035 @REQ-036 @REQ-037 @REQ-038 @REQ-041 @REQ-042 @VAL-009
  Skenario: SCN-0029 Buka Setting Denda Rusak/Batal/Hangus, verifikasi field dan nilai default TANPA menyimpan perubahan
    Ketika Buka /partner/masterdenda, klik 'Setting' pada baris Rusak
    Dan Periksa field Range Waktu (range_waktu_edit), select Rupiah/Persentase (pilihan_denda_edit), Jumlah Denda (jumlah_denda_edit); catat nilai default (1 Jam, Rp.1.000 sesuai ui-inventory)
    Dan Klik Batal (BUKAN Simpan)
    Dan Ulangi untuk baris Batal (default 24 Jam, 50%) dan Hangus (default 6 Jam, 100%)
    Dan Untuk baris Hangus, periksa apakah jumlah_denda_edit berstatus disabled/terkunci (REQ-042)
    Maka Setting Rusak: field Range Waktu & Jenis Denda (Rupiah/Persentase) tampil dan dapat diisi (REQ-034, REQ-035)
    Dan Setting Batal: field Range Waktu & Jenis Denda tampil (REQ-037, REQ-038)
    Dan Setting Hangus: nilai default persentase = 100% (REQ-041); field jumlah_denda_edit diverifikasi apakah disabled (REQ-042 — 'belum dipastikan saat harvest', dicatat hasil pastinya di sini)
    Dan TIDAK ADA perubahan yang disimpan (semua ditutup via Batal)
    # Catatan: Skenario ini HANYA observasi field & nilai default, TIDAK melakukan Simpan sama sekali — aman dieksekusi tanpa izin tambahan (berbeda dari REQ-039/040/043 yang butuh submit sungguhan untuk memicu alert validasi).

  @edge @medium @SCR-25 @REQ-039 @VAL-009
  Skenario: SCN-0030 [MEMBUTUHKAN IZIN EKSPLISIT USER SEBELUM DIEKSEKUSI — jangan dijalankan otomatis] Verifikasi field Range Waktu Batal & Hangus pada Setting Denda (P533)
    Ketika Buka /partner/masterdenda, klik 'Setting' pada baris Batal, catat nilai Range Waktu saat ini
    Dan Klik 'Setting' pada baris Hangus, catat nilai Range Waktu saat ini
    Dan Tutup modal via Batal (JANGAN mengubah nilai atau klik Simpan)
    Maka Field Range Waktu (range_waktu_edit) pada kedua modal Setting terlihat dan menampilkan nilai saat ini
    Dan TIDAK ADA perubahan nilai atau Simpan yang dilakukan pada skenario ini
    # Catatan: MEMBUTUHKAN IZIN EKSPLISIT USER SEBELUM DIEKSEKUSI — jangan dijalankan otomatis. Skenario ini HANYA memverifikasi tampilan form (field ada, nilai saat ini), TIDAK submit. Untuk menguji alert penolakan 'Range waktu tidak boleh kurang dari denda Hangus' (P533/M-05) yang membutuhkan Simpan sungguhan dengan Range Waktu Batal < Hangus, WAJIB izin eksplisit user + catat di shared/decisions.md dulu, karena mengubah setting tenant yang memengaruhi perhitungan denda pembatalan tiket agen sungguhan.

  @edge @medium @SCR-25 @REQ-040 @VAL-009
  Skenario: SCN-0031 [MEMBUTUHKAN IZIN EKSPLISIT USER SEBELUM DIEKSEKUSI — jangan dijalankan otomatis] Verifikasi field Jumlah Denda Persentase pada Setting Rusak/Batal (P534)
    Ketika Buka /partner/masterdenda, klik 'Setting' pada baris Rusak, pilih Jenis Denda 'Persentase', amati field jumlah_denda_edit (batas maksimal, attribute max/pattern bila ada)
    Dan Ulangi untuk baris Batal
    Dan Tutup modal via Batal (JANGAN mengisi nilai >100% atau klik Simpan)
    Maka Field Jumlah Denda tampil untuk opsi Persentase pada kedua baris
    Dan Constraint HTML (max, pattern, atau sejenis) untuk membatasi ≤100% dicatat apa adanya (ada/tidak ada)
    Dan TIDAK ADA perubahan nilai atau Simpan yang dilakukan
    # Catatan: MEMBUTUHKAN IZIN EKSPLISIT USER SEBELUM DIEKSEKUSI — jangan dijalankan otomatis. Untuk menguji alert penolakan saat input >100% (P534) yang membutuhkan Simpan sungguhan, WAJIB izin eksplisit user + catat di shared/decisions.md dulu.

  @edge @medium @SCR-25 @REQ-043 @VAL-009
  Skenario: SCN-0032 [MEMBUTUHKAN IZIN EKSPLISIT USER SEBELUM DIEKSEKUSI — jangan dijalankan otomatis] Verifikasi field Range Waktu Hangus vs Batal pada Setting Denda (P538)
    Ketika Buka /partner/masterdenda, klik 'Setting' pada baris Hangus, catat Range Waktu saat ini
    Dan Klik 'Setting' pada baris Batal, catat Range Waktu saat ini
    Dan Tutup modal via Batal (JANGAN mengubah nilai atau klik Simpan)
    Maka Field Range Waktu kedua baris terlihat dengan nilai saat ini
    Dan TIDAK ADA perubahan nilai atau Simpan yang dilakukan
    # Catatan: MEMBUTUHKAN IZIN EKSPLISIT USER SEBELUM DIEKSEKUSI — jangan dijalankan otomatis. Untuk menguji alert penolakan 'Range waktu tidak boleh lebih dari denda Batal' (P538/M-06) yang membutuhkan Simpan sungguhan dengan Range Waktu Hangus > Batal, WAJIB izin eksplisit user + catat di shared/decisions.md dulu.

  @positive @high @SCR-24 @REQ-045 @AC-07
  Skenario: SCN-0033 Operator Pusat dapat membuka modal Setting Denda Pembatalan; Operator Cabang tombol Setting tampil tapi tidak bisa dibuka (P540)
    Ketika Login Operator Pusat, buka /partner/masterdenda, klik 'Setting' pada salah satu baris
    Dan Verifikasi modal SCR-25 terbuka dengan field terisi, lalu Batal (TANPA Simpan)
    Dan Login Operator Cabang Pare-Pare, buka /partner/masterdenda, arahkan kursor ke tombol 'Setting'
    Dan Klik tombol 'Setting'
    Maka Pusat: modal 'EDIT DENDA PEMBATALAN AGEN' terbuka, field terisi (nama, trigger by, range waktu, jenis denda, jumlah denda)
    Dan Cabang: tooltip 'Hanya bisa dilakukan oleh kantor pusat' muncul saat hover
    Dan Cabang: klik tombol Setting TIDAK membuka modal apa pun
    Dan Tidak ada perubahan/simpan apa pun di kedua akun

  @negative @high @SCR-27 @VAL-008 @AC-11 @FND-M-01
  Skenario: SCN-0034 Simpan Tambah Informasi dengan field kosong tidak mengirim request (FND-M-01)
    Ketika Buka /partner/informasi_add
    Dan Biarkan semua field kosong (Judul, Berlaku Sampai, Isi Informasi)
    Dan Pantau network request, lalu klik Simpan (#submit_crew)
    Maka Tidak ada popover/alert/pesan validasi yang tampil
    Dan Tidak ada request POST/AJAX terkirim
    Dan Tetap di halaman Tambah Informasi
    # Catatan: Memverifikasi FND-M-01; aman diulang, tidak membuat entitas. Catatan: tombol Simpan memakai id #submit_crew (sisa template, sama dengan Master Crew).

  @edge @medium @SCR-27 @REQ-048 @REQ-050 @AC-09 @FND-M-02
  Skenario: SCN-0035 Tempel (paste) teks Judul >100 karakter dan Isi Informasi >350 karakter — verifikasi pembatasan (P544, P546, FND-M-02)
    Ketika Buka /partner/informasi_add
    Dan Tempel (paste event, bukan keystroke satu-satu) teks 120 karakter ke field Judul
    Dan Tempel teks 400 karakter ke field Isi Informasi
    Dan Amati apakah nilai field terpotong pada batas (100/350) ATAU muncul alert 'Jumlah karakter melebihi batas karakter'
    Dan Tutup form tanpa Simpan (Batal)
    Maka Dicatat perilaku sebenarnya: field terpotong otomatis oleh maxlength (kemungkinan besar), ATAU alert P544/P546 muncul — salah satu dari dua ini valid, gunakan matching longgar sesuai FND-M-02
    Dan Tidak menyimpan data apa pun
    # Catatan: Memverifikasi kandidat FND-M-02 (alert mungkin unreachable via jalur UI normal karena maxlength HTML). Verifikasi via event paste, bukan hanya keystroke, sesuai AC-09.

  @positive @medium @SCR-27 @REQ-046 @REQ-049 @REQ-053 @REQ-054
  Skenario: SCN-0036 Buat Informasi AUTOTEST-20260927- (Pusat): verifikasi Berlaku Sampai default hari ini, kolom daftar, Edit mengubah Tanggal Edit, lalu hapus
    Ketika Buka /partner/informasi_add
    Dan Verifikasi field 'Berlaku Sampai' terisi default tanggal hari ini (27/09/2026) sebelum diisi manual
    Dan Isi Judul 'AUTOTEST-20260927-INFO', Isi Informasi 'AUTOTEST-20260927- info uji otomatis', biarkan/ubah Berlaku Sampai
    Dan Klik Simpan
    Dan Di /partner/informasi_show, verifikasi baris 'AUTOTEST-20260927-INFO' beserta kolom Tanggal Buat, Berlaku Sampai
    Dan Klik Edit, ubah sedikit Isi Informasi, Simpan lagi
    Dan Verifikasi kolom/field 'Tanggal Edit' (atau setara) berubah ke waktu edit terakhir; catat User Buat
    Dan Hapus baris 'AUTOTEST-20260927-INFO' sebagai cleanup
    Maka Berlaku Sampai default = tanggal hari ini saat form dibuka (REQ-049)
    Dan Redirect ke daftar Informasi setelah Simpan, baris 'AUTOTEST-20260927-INFO' tampil (REQ-046)
    Dan Setelah Edit, field tanggal update berubah (REQ-053); User Buat tercatat (REQ-054)
    Dan Setelah Hapus, baris hilang dari daftar
    # Catatan: Data Informasi ini akan tampil sementara di Dashboard Agen (Pusat: SEMUA agen, P547) sebelum sempat dihapus — pastikan langkah Hapus di akhir benar-benar dijalankan secepatnya untuk meminimalkan visibilitas. Berbeda dari Kelas/Golongan/Kapal/Trayek/Harga/Tarif Pass, Informasi TIDAK termasuk data referensi yang menjadi permanen setelah dipakai (tidak ada REQ yang menyatakan Informasi tidak bisa dihapus), sehingga cleanup di sini valid.

  @positive @medium @SCR-27 @REQ-046 @AC-10
  Skenario: SCN-0037 Operator Cabang Pare-Pare dapat membuat Informasi AUTOTEST-20260927-, lalu hapus
    Ketika Login Operator Cabang Pare-Pare, buka /partner/informasi_add
    Dan Isi Judul 'AUTOTEST-20260927-INFO-CABANG', Isi Informasi singkat, Berlaku Sampai default
    Dan Klik Simpan
    Dan Verifikasi baris muncul di /partner/informasi_show milik Cabang
    Dan Hapus baris sebagai cleanup
    Maka Redirect ke daftar Informasi, baris 'AUTOTEST-20260927-INFO-CABANG' tampil
    Dan Setelah Hapus, baris hilang dari daftar
    # Catatan: Sesuai P548–P549, informasi Cabang hanya tampil ke agen se-kota cabang tersebut (tidak diverifikasi lebih lanjut di OP-11, cross-module Dashboard Agen — lihat Q-M-05). Data dihapus segera setelah verifikasi untuk meminimalkan visibilitas sementara di Dashboard Agen se-kota.

  @positive @medium @SCR-01 @AC-10
  Skenario: SCN-0038 Operator Cabang dapat membuka seluruh 10 submenu Master (Lihat + tombol Tambah tersedia)
    Ketika Login Operator Cabang Pare-Pare
    Dan Buka berturut-turut: /partner/masterkelasnew, /partner/mastergolongan, /partner/mkapal, /partner/DaftarTrayek, /partner/masterharga, /partner/tarifpass, /partner/masterasuransi, /partner/MasterCrew, /partner/masterdenda, /partner/informasi_show
    Dan Pada tiap layar (kecuali Denda Pembatalan & Asuransi yang tidak punya tombol Tambah manual), cek keberadaan tombol/link 'Tambah ...'
    Maka Kesepuluh daftar berhasil dibuka tanpa redirect ke dashboard/.alert-danger
    Dan Tombol/link Tambah tersedia pada submodul yang seharusnya punya (Kelas, Golongan, Kapal, Trayek, Harga, Tarif Pass, Crew, Informasi)
    Dan Master Denda Pembatalan dan Master Asuransi memang TIDAK punya tombol Tambah manual (sesuai desain, bukan pembatasan Cabang)

  @positive @medium @SCR-01 @VAL-010
  Skenario: SCN-0039 Filter Master Kelas berdasarkan nama lalu Reset
    Ketika Buka /partner/masterkelasnew, klik Filter (#btn-filter)
    Dan Isi filter Nama Kelas (nama_kelas) dengan nama Kelas yang diketahui ada, submit Filter
    Dan Klik Reset
    Maka Setelah filter, hanya baris yang cocok dengan nama yang tampil
    Dan Setelah Reset, daftar penuh tampil kembali

  @positive @low @SCR-10 @VAL-010
  Skenario: SCN-0040 Filter Master Trayek berdasarkan nama lalu Reset
    Ketika Buka /partner/DaftarTrayek, klik Filter (#btn-filter)
    Dan Isi filter Nama Trayek (nama_trayek_filter) dengan nama trayek yang diketahui ada, submit Filter
    Dan Klik Reset
    Maka Setelah filter, hanya baris yang cocok yang tampil
    Dan Setelah Reset, daftar penuh tampil kembali
    # Catatan: Filter submodul lain (Golongan, Kapal, Harga, Tarif Pass, Crew, Informasi, Denda) tidak diuji individual pada modul ini — pola sama, prioritas rendah, dicatat sebagai gap di coverage.md (konsisten dengan pola OP-21).
