# language: id
Fitur: OP-16/OP-17 Daftar Relasi — Relasi Pelanggan (Tambah/Edit/Hapus, Tambah Diskon) dan Relasi Agen (Tambah/Edit/Hapus, Tambah Komisi)
  Sumber aturan: Rule RORO v1.5.0 P702-737 (lihat relasi_analysis.md) + harvest UI
  27 September 2026 (relasi_ui-inventory.md).
  TEMUAN KUNCI 27 Sep 2026: (1) Relasi Pelanggan SIMETRIS PENUH antara Operator Pusat dan
  Cabang (58/58 data sama, semua tombol Tambah/Edit/Hapus/Tambah Diskon tersedia identik,
  Q-RA-04 tertutup, FND-RL-08); (2) Relasi Agen SANGAT ASIMETRIS — Operator Pusat diblokir
  SERVER-SIDE (bukan cuma UI) dari akses tulis (redirect /partner/dashboard + alert "Anda
  Tidak Memiliki Akses Ke Halaman Tersebut" pada akses URL langsung /partner/tambahagen,
  /partner/editagen/<id>, /partner/tambahkomisiagen/<id>), hanya Cabang yang bisa
  menambah/mengedit/menghapus Agen dan mengatur Komisi (REQ-AGN-01/P727, FND-RL-07).
  SCN-0002 dan SCN-0013 MEMBUAT DATA BARU (Pelanggan/Agen) berprefix AUTOTEST-20260927-,
  dipakai ulang oleh beberapa skenario turunan (Diskon/Komisi/reaktivasi/filter), dan
  DIHAPUS (cleanup) di SCN-0011 (submodul Pelanggan) dan SCN-0021 (submodul Agen) —
  mengikuti pola OP-12 Kuota & Jadwal (cleanup dalam rangkaian skenario sendiri), BUKAN
  pola OP-11 Master (data referensi permanen tidak dihapus), karena modul ini punya aksi
  Hapus yang berfungsi dan data uji di sini tidak pernah dipakai transaksi lintas modul
  (OP-13/OP-15/AG-05) apa pun selama rangkaian test.
  SCN-0022 berstatus BLOCKED (efek Komisi Agen pada transaksi Jual Tiket Agen portal /agen,
  Q-RA-03, di luar cakupan OP-16/OP-17). Q-RA-02 (scope validasi unique email/WA Agen
  lintas-kota) TIDAK terjawab — dicatat sebagai blockedUnless di SCN-0015, butuh akun
  Operator Cabang kota lain yang tidak tersedia di config/env.md.
  PERINGATAN TEKNIS lintas-skenario: validasi zemPopover (.popover-body) otomatis hilang
  ~1000ms — baca popover SEGERA di dalam callback/evaluate yang sama dengan klik Simpan,
  JANGAN mengecek setelah await/round-trip terpisah (lihat SCN-0003/SCN-0014). Alert/confirm
  duplikat Diskon/Komisi memakai native alert()/confirm() browser, WAJIB page.on('dialog')
  handler (lihat SCN-0006/SCN-0018/SCN-0019), bukan SweetAlert2/zemPopover.

  @positive @high @SCR-PEL-01
  Skenario: SCN-0001 Verifikasi simetri akses Relasi Pelanggan: Operator Pusat vs Cabang Pare-Pare (jumlah data & tombol aksi SAMA) — kontras dengan Relasi Agen
    Ketika Login Operator Pusat, buka /partner/pelanggan, catat jumlah total data pada info 'Menampilkan X sampai Y dari Z data' dan cek keberadaan tombol/link 'Tambah Pelanggan' (a.btn-buat-trayek) serta aksi baris Hapus Pelanggan (button.btn-delete) pada beberapa baris sampel
    Dan Buka salah satu Detail Pelanggan (a.btn-view.btn_1), catat keberadaan tombol 'Edit Pelanggan' dan link 'Tambah Diskon'
    Dan Logout, Login Operator Cabang Pare-Pare, ulangi langkah 1-2 persis pada /partner/pelanggan
    Dan Bandingkan: jumlah total data (Z) Pusat vs Cabang, keberadaan tombol Tambah/Edit/Hapus/Tambah Diskon pada kedua akun
    Maka Jumlah total data Relasi Pelanggan pada Pusat dan Cabang SAMA PERSIS (dikonfirmasi live saat harvest 27 Sep 2026: 58 dari 58 pada kedua akun, tidak difilter kota) — menjawab Q-RA-04, mengonfirmasi ulang FND-RL-08
    Dan Tombol/link Tambah Pelanggan, Edit Pelanggan, Hapus Pelanggan, Tambah Diskon SEMUA tersedia identik pada kedua akun
    Dan Kontras eksplisit dicatat dengan hasil SCN-0012 (Relasi Agen: Pusat DITOLAK akses tulis) — perbedaan pola akses antar dua submodul dalam modul yang sama dikonfirmasi ulang di sini, bukan diasumsikan
    # Catatan: OBSERVASIONAL, tidak membuat/mengubah data apa pun, memakai 58 data existing. Jalankan SEBELUM SCN-0002 dst. agar baseline jumlah data (Z) tercatat sebelum data AUTOTEST ditambahkan.

  @positive @high @SCR-PEL-04 @REQ-PEL-02 @REQ-PEL-05 @REQ-PEL-06 @REQ-PEL-10 @VAL-PEL-03
  Skenario: SCN-0002 Cabang Pare-Pare: Tambah Pelanggan AUTOTEST-20260927-PEL-CABANG lengkap semua field (termasuk Jenis Identitas/Nomor Identitas/Kota, TOP dicentang + Lama Pembayaran), verifikasi tersimpan & tampil identik di Daftar Cabang dan Pusat
    Ketika Login Operator Cabang Pare-Pare, buka /partner/pelanggan, klik link 'Tambah Pelanggan' (a.btn-buat-trayek) → /partner/tambahpelanggan
    Dan Isi #nama_perusahaan = 'AUTOTEST-20260927-PEL-CABANG', #penanggung_jawab = 'AUTOTEST-20260927-PEL-CABANG-PIC'
    Dan Centang checkbox #topnya ('Pembayaran Bisa TOP'), verifikasi field #lama_pembayaran berubah dari disabled menjadi enabled TEPAT setelah dicentang (VAL-PEL-03/Q-RP-02), isi dengan '7' (Hari)
    Dan Isi #email_perusahaan dan #telp_perusahaan dengan kontakTestNotifikasi/kontakTestWhatsapp dari config/env.md (WAJIB, bukan kontak nyata)
    Dan Pilih #jenis_identitas (select2) = 'KTP', isi #nomor_identitas = 'AUTOTEST-20260927-PEL-CABANG-KTP-0001'
    Dan Pilih #kota (satu-satunya field dengan atribut HTML required sungguhan) = 'Parepare' atau kota lain; catat dropdown ini berisi ratusan opsi kota/kab Indonesia (REQ-PEL-06 — sumber data admin /adminprahu, hanya diobservasi dari sisi Operator)
    Dan Isi #alamat_perusahaan = 'AUTOTEST-20260927-PEL-CABANG Alamat Test', biarkan #keterangan kosong (opsional, TIDAK bertanda *)
    Dan Klik #simpan
    Dan Verifikasi redirect ke /partner/pelanggan dan baris baru muncul (M-PEL-02: AJAX POST /partner/doaddpelanggan)
    Dan Buka Detail Pelanggan baris ini, verifikasi field 'Lama Pembayaran' menampilkan '7 Hari' (bukan 'Tunai'), dan seluruh field lain sesuai input
    Dan Login Operator Pusat, buka /partner/pelanggan, filter nama_perusahaan yang sama, verifikasi tampil IDENTIK
    Maka Data tersimpan (redirect ke daftar, tidak ada error) dengan seluruh field sesuai input (REQ-PEL-02, REQ-PEL-05)
    Dan Field #lama_pembayaran disabled sebelum #topnya dicentang, enabled sesudahnya, nilainya tersimpan dan tampil sebagai 'N Hari' (VAL-PEL-03) — dasar tempo piutang OP-15 (REQ-PEL-10), efek kalkulasinya TIDAK diuji di sini (cross-module)
    Dan Baris 'AUTOTEST-20260927-PEL-CABANG' tampil identik pada Daftar Cabang (pembuat) DAN Daftar Pusat
    # Catatan: MEMBUAT DATA BARU (Pelanggan). Dipakai ulang oleh SCN-0004/0005/0006/0007/0008, dihapus di SCN-0011. Email/Telp WAJIB kontakTestNotifikasi/kontakTestWhatsapp dari config/env.md.

  @negative @high @SCR-PEL-04 @REQ-PEL-03 @VAL-PEL-01 @AC-PEL-01
  Skenario: SCN-0003 Tambah Pelanggan dengan seluruh field wajib kosong (kecuali Keterangan) — verifikasi alert zemPopover per-field berurutan, tidak tersimpan
    Ketika Buka /partner/tambahpelanggan (akun Cabang atau Pusat, keduanya simetris), JANGAN isi field apa pun
    Dan PERINGATAN TEKNIS: zemPopover (.popover-body) otomatis hilang ~1000ms — baca popover DI DALAM evaluate/callback yang SAMA dengan klik #simpan, JANGAN mengecek setelah await/round-trip terpisah
    Dan Klik #simpan, baca popover pertama SEGERA (sinkron) → harus 'Masukkan Nama Perusahaan'
    Dan Isi field satu-per-satu mengikuti urutan M-PEL-01: penanggung_jawab kosong → 'Masukkan Nama PIC'; email_perusahaan kosong → 'Masukkan Email Perusahaan'; format email salah → 'Masukkan Email Dengan Benar'; telp_perusahaan kosong → 'Masukkan Nomor'; jenis_identitas kosong → 'Pilih Jenis Identitas'; nomor_identitas kosong → 'Masukkan Nomor'; kota kosong → 'Pilih Kota / Kab'; alamat_perusahaan kosong → 'Masukkan Alamat Perusahaan' — baca popover SEGERA tiap langkah
    Dan TANPA submit sungguhan, verifikasi via DOM bahwa elemen #keterangan TIDAK memiliki penanda wajib (tidak ada tanda *, tidak termasuk rantai validasi M-PEL-01) — submit penuh dengan Keterangan kosong sudah dibuktikan berhasil di SCN-0002
    Dan Pantau browser_network_requests: pastikan TIDAK ADA request ke /partner/doaddpelanggan selama field wajib masih kosong
    Maka Setiap field wajib kosong memicu zemPopover per-field dengan teks PERSIS sesuai M-PEL-01 (bukan silent, bukan alert gabungan) — REQ-PEL-03/VAL-PEL-01/AC-PEL-01 terverifikasi ulang
    Dan Tidak ada POST ke doaddpelanggan selama field wajib masih ada yang kosong
    Dan #keterangan terkonfirmasi TIDAK wajib
    # Catatan: TIDAK membuat data apa pun (form tidak pernah disubmit lolos dalam skenario ini).

  @negative @medium @SCR-PEL-04 @VAL-PEL-02
  Skenario: SCN-0004 Tambah Pelanggan dengan Email/WA duplikat milik AUTOTEST-20260927-PEL-CABANG dan format email salah — verifikasi pesan sesuai
    Ketika Prasyarat: SCN-0002 sudah dijalankan (Pelanggan 'AUTOTEST-20260927-PEL-CABANG' dengan email=kontakTestNotifikasi, telp=kontakTestWhatsapp sudah ada)
    Dan Buka /partner/tambahpelanggan, isi nama_perusahaan='AUTOTEST-20260927-PEL-DUP' dan field lain valid KECUALI email_perusahaan; isi email format salah (mis. 'bukan-email'), trigger validasi → verifikasi popover 'Masukkan Email Dengan Benar'
    Dan Perbaiki email_perusahaan PERSIS sama dengan kontakTestNotifikasi (email AUTOTEST-20260927-PEL-CABANG), trigger cek AJAX /partner/cek_email_pelanggan → verifikasi popover 'Email Sudah terdaftar'
    Dan Ganti email ke nilai unik baru, isi telp_perusahaan PERSIS sama dengan kontakTestWhatsapp, trigger cek AJAX /partner/cek_wa_pelanggan → verifikasi popover 'Nomor Whatsapp Sudah terdaftar'
    Dan Pantau network request: pastikan TIDAK ADA request /partner/doaddpelanggan yang berhasil selama duplikasi/format belum diperbaiki
    Maka Format email salah → 'Masukkan Email Dengan Benar' (VAL-PEL-02)
    Dan Email duplikat → 'Email Sudah terdaftar'; WA duplikat → 'Nomor Whatsapp Sudah terdaftar' — TIDAK ada validasi format angka spesifik untuk WA
    Dan Tidak ada data 'AUTOTEST-20260927-PEL-DUP' tersimpan pada skenario ini
    # Catatan: TIDAK membuat data baru. Sengaja menggunakan email/WA milik AUTOTEST-20260927-PEL-CABANG (data sendiri) untuk memicu uniqueness check dengan aman.

  @positive @medium @SCR-PEL-05 @REQ-PEL-11 @REQ-PEL-12 @REQ-PEL-16 @REQ-PEL-18
  Skenario: SCN-0005 Tambah Diskon Pelanggan (persen) pada AUTOTEST-20260927-PEL-CABANG: rute+jenis tiket Penumpang+golongan+kelas, verifikasi label '%'
    Ketika Prasyarat: SCN-0002 sudah dijalankan (Pelanggan 'AUTOTEST-20260927-PEL-CABANG' ada)
    Dan Buka Detail Pelanggan 'AUTOTEST-20260927-PEL-CABANG', klik link 'Tambah Diskon' → /partner/tambahandiskon/<base64Id>
    Dan Pilih select#rute (berlaku_untuk) = trayek apa saja, pilih select#jenis1 (ParentID[]) = 'Penumpang', verifikasi select#golongan1 terisi via AJAX POST /partner/getgolongantiket (REQ-PEL-16), pilih golongan, pilih select#kelas1 sesuai golongan
    Dan Pilih select#tipe1 (tipe[]) = 'Persen', isi input#harga1 = '10', verifikasi label '%' tampil di kiri input (REQ-PEL-18)
    Dan Klik #simpan (AJAX POST /partner/saveIncludeDiskon)
    Dan Verifikasi baris diskon baru muncul di tabel Diskon Detail Pelanggan (Diskon Harga = '10%')
    Maka Baris Diskon baru tersimpan dan tampil dengan format '10%' (REQ-PEL-11/18)
    Dan Golongan/Kelas yang tersedia sesuai Jenis Tiket 'Penumpang' (REQ-PEL-16), field rute+jenis tiket+golongan+kelas semua tersimpan sesuai input (REQ-PEL-12)
    # Catatan: MEMBUAT DATA BARU (1 baris Diskon). Dipakai ulang oleh SCN-0006, dihapus bersama Pelanggan induknya di SCN-0011 (verifikasi apakah Hapus Pelanggan cascade menghapus Diskon, bukan diasumsikan pasti).

  @negative @medium @SCR-PEL-05 @REQ-PEL-15 @AC-PEL-05
  Skenario: SCN-0006 Duplikat kombinasi Diskon Pelanggan (sama Golongan+Kelas+Rute+Jenis Tiket) — verifikasi alert 'Tidak bisa! Diskon sudah ditambahkan'
    Ketika Prasyarat: SCN-0005 sudah dijalankan (1 baris Diskon persis pada AUTOTEST-20260927-PEL-CABANG)
    Dan Siapkan page.on('dialog') handler (native alert, BUKAN zemPopover/SweetAlert) SEBELUM klik Simpan
    Dan Buka /partner/tambahandiskon/<base64Id>, isi kombinasi PERSIS SAMA dengan SCN-0005 (harga boleh beda), klik Simpan
    Maka Native alert() muncul dengan teks PERSIS 'Tidak bisa! Diskon sudah ditambahkan' (M-PEL-04); AJAX /partner/saveIncludeDiskon TIDAK menghasilkan baris baru
    Dan Aturan larangan kombinasi duplikat konsisten dengan pola Master Harga (REQ-PEL-15 rujuk master_analysis.md REQ-018/019/020, tidak diulang sebagai REQ baru). Teks alert BELUM dibandingkan langsung dengan Master Harga — dicatat sebagai observasi tambahan bila berbeda kata
    Dan Tabel Diskon Pelanggan tetap hanya 1 baris, tidak bertambah
    # Catatan: TIDAK membuat data baru (submit duplikat sengaja ditolak).

  @positive @medium @SCR-PEL-05 @REQ-PEL-17 @VAL-PEL-05 @AC-PEL-07 @FND-RL-02
  Skenario: SCN-0007 Tambah Diskon Pelanggan Jenis Tiket = Bagasi Kendaraan DAN Bagasi Penumpang — verifikasi Kelas/Kondisi Kendaraan otomatis disabled value 'Bagasi' pada KEDUA varian (FND-RL-02)
    Ketika Prasyarat: Pelanggan 'AUTOTEST-20260927-PEL-CABANG' ada (SCN-0002)
    Dan Buka /partner/tambahandiskon/<base64Id>, pilih rute apa saja, pilih select#jenis1 = 'Bagasi Kendaraan' (opsi PERTAMA dari 2 varian Bagasi — FND-RL-02), verifikasi select#kelas1 disembunyikan digantikan input.bagasi_<n> value='Bagasi' disabled=true
    Dan Pilih tipe1='Rupiah', isi harga1='5000', klik Simpan, verifikasi baris tersimpan Kelas/Kondisi='Bagasi'
    Dan Ulangi dengan select#jenis1 = 'Bagasi Penumpang' (varian KEDUA), rute BERBEDA agar tidak duplikat, verifikasi perilaku identik
    Maka KEDUA varian memicu perilaku identik: select#kelas1 disembunyikan digantikan input value='Bagasi' disabled=true (REQ-PEL-17/VAL-PEL-05/AC-PEL-07 terverifikasi untuk kedua opsi)
    Dan Dicatat sebagai verifikasi FND-RL-02 (kandidat gap-dokumentasi: rule menyebut 'Bagasi' tunggal, UI punya 2 opsi terpisah) untuk dikonfirmasi status resminya oleh bug-triager
    Dan 2 baris Diskon baru tersimpan (Bagasi Kendaraan dan Bagasi Penumpang, rute berbeda)
    # Catatan: MEMBUAT DATA BARU (2 baris Diskon tambahan). Dihapus bersama Pelanggan induknya di SCN-0011.

  @edge @medium @SCR-PEL-05 @REQ-PEL-19 @VAL-PEL-04 @AC-PEL-06
  Skenario: SCN-0008 Input Diskon Persen >100% pada Tambah Diskon Pelanggan — verifikasi dibatasi client-side (Inputmask), amati bypass langsung
    Ketika Buka /partner/tambahandiskon/<base64Id> untuk AUTOTEST-20260927-PEL-CABANG, pilih kombinasi BELUM dipakai (hindari duplikat SCN-0005/0007), pilih tipe1='Persen'
    Dan Ketik '150' pada input#harga1 memakai keyboard event asli, amati nilai terpotong maksimal '100' sesuai mask
    Dan SETELAH itu, coba fill() langsung (bypass keyboard event) nilai '150' via evaluate, klik Simpan — amati ditolak (validasi server-side) atau diterima
    Dan JIKA server menerima: catat TEMUAN BARU, hapus baris tsb sebagai cleanup segera. JIKA ditolak/dikoreksi: tidak perlu cleanup
    Maka Input keyboard normal '150' pada field Persen TERPOTONG otomatis maksimal '100' (VAL-PEL-04 terverifikasi ulang)
    Dan Hasil bypass server-side dicatat APA ADANYA (ditolak ATAU diterima) — bukan diasumsikan (REQ-PEL-19/AC-PEL-06)
    Dan Jika sempat tersimpan >100%, cleanup baris tsb berhasil
    # Catatan: OBSERVASIONAL untuk langkah bypass server-side. Pakai kombinasi unik agar tidak bentrok dengan SCN-0005/0006/0007.

  @positive @low @SCR-PEL-02 @REQ-PEL-04
  Skenario: SCN-0009 Observasi data Pelanggan lama 'CV Karya Bersama' (id 3701) — Jenis Identitas/Nomor Identitas/Kota tampil strip '-' di Detail (data pre-fitur)
    Ketika Buka /partner/detailpelanggan/MzcwMQ== (CV Karya Bersama, id 3701, data existing pra-fitur)
    Dan Baca field Jenis Identitas, Nomor Identitas, Kota/Kab pada halaman Detail
    Maka Ketiga field menampilkan strip '-' karena data ini dibuat sebelum field tsb ditambahkan (REQ-PEL-04 terverifikasi, FND-RL-05 dikonfirmasi ulang)
    Dan Tidak ada perubahan data (read-only, TIDAK membuka form Edit)
    # Catatan: Read-only, data existing bukan milik test run ini, JANGAN edit/hapus.

  @positive @medium @SCR-PEL-01 @VAL-PEL-06
  Skenario: SCN-0010 Filter Daftar Relasi Pelanggan berdasarkan Nama Perusahaan lalu Reset
    Ketika Buka /partner/pelanggan, klik toggle Filter (#btn-filter)
    Dan Isi nama_perusahaan = 'Karya Bersama', submit filter
    Dan Verifikasi daftar menyempit ke 1 baris (CV Karya Bersama) — dikonfirmasi live saat harvest 27 Sep 2026 (58→1)
    Dan Klik salah satu tombol 'Reset' (.reset-master ATAU .btn-primary lain — catat selector mana yang berfungsi)
    Maka Setelah filter, hanya baris 'CV Karya Bersama' tampil (VAL-PEL-06 dikonfirmasi ulang)
    Dan Setelah Reset, daftar penuh tampil kembali
    # Catatan: Observasional pada data existing. Jalankan SETELAH SCN-0002.

  @positive @high @SCR-PEL-01
  Skenario: SCN-0011 Cleanup: Hapus Pelanggan AUTOTEST-20260927-PEL-CABANG beserta seluruh Diskon terkait, verifikasi hilang dari Daftar Cabang & Pusat
    Ketika Prasyarat: SCN-0002/0004/0005/0006/0007/0008 sudah dijalankan; Pelanggan 'AUTOTEST-20260927-PEL-CABANG' TIDAK pernah dipakai transaksi apa pun di modul lain — aman dihapus
    Dan Buka /partner/pelanggan (akun Cabang Pare-Pare), filter nama_perusahaan='AUTOTEST-20260927-PEL-CABANG'
    Dan Klik aksi Hapus (button.btn-delete), konfirmasi dialog SweetAlert2
    Dan Verifikasi baris hilang dari akun Cabang
    Dan Login Operator Pusat, buka /partner/pelanggan, verifikasi baris yang sama JUGA hilang
    Maka Baris 'AUTOTEST-20260927-PEL-CABANG' berhasil dihapus dari Daftar Cabang maupun Pusat
    Dan Seluruh Diskon terkait tidak lagi dapat diakses — catat perilaku APA ADANYA (cascade atau orphan), bukan diasumsikan
    # Catatan: Cleanup akhir rangkaian Pelanggan. Data AMAN dihapus karena tidak pernah dipakai transaksi lintas modul.

  @negative @high @SCR-AGN-03 @REQ-AGN-01 @AC-AGN-01
  Skenario: SCN-0012 Operator Pusat mengakses langsung URL /partner/tambahagen, /partner/editagen/<id>, /partner/tambahkomisiagen/<id> — verifikasi DITOLAK server-side
    Ketika Login Operator Pusat
    Dan Navigasi LANGSUNG ke /partner/tambahagen, verifikasi redirect ke /partner/dashboard DAN muncul .alert-danger 'Anda Tidak Memiliki Akses Ke Halaman Tersebut'
    Dan Ambil id Agen existing (mis. 19534, PT. Integritas Kuasa) dari Detail Agen, navigasi LANGSUNG ke /partner/editagen/19534, verifikasi redirect+alert yang sama
    Dan Navigasi LANGSUNG ke /partner/tambahkomisiagen/19534, verifikasi redirect+alert yang sama
    Dan Sebagai pembanding, buka /partner/agen sebagai Pusat, pindai seluruh halaman memastikan TIDAK ADA link/tombol 'Tambah Agen'; buka /partner/detailagen/<base64Id> mana saja, verifikasi TIDAK ADA tombol 'Edit Agen' dan tabel Komisi Agen TANPA kolom Aksi/link 'Tambah Komisi'
    Maka KETIGA route mengembalikan redirect + alert 'Anda Tidak Memiliki Akses Ke Halaman Tersebut' untuk Operator Pusat — REQ-AGN-01/AC-AGN-01 terverifikasi PENUH di level server (mengonfirmasi ulang FND-RL-07, bukan bug)
    Dan UI Pusat pada /partner/agen dan /partner/detailagen TIDAK menampilkan tombol/link Tambah/Edit/Tambah Komisi sama sekali
    # Catatan: PRIORITAS HIGH sesuai instruksi eksplisit — bukti kuat pembatasan server-side. Tidak ada data yang diubah.

  @positive @high @SCR-AGN-03 @REQ-AGN-02 @REQ-AGN-04 @REQ-AGN-05 @AC-AGN-01 @AC-AGN-03 @AC-AGN-04 @FND-RL-04
  Skenario: SCN-0013 Cabang Pare-Pare: Tambah Agen AUTOTEST-20260927-AGN-01 status Aktif, isi SEMUA field termasuk Kata Sandi/Upload Dokumen/Informasi Rekening (FND-RL-04), notifikasi ke kontak test — verifikasi tersimpan & tampil di Daftar Cabang (pembuat) dan Pusat (view)
    Ketika Login Operator Cabang Pare-Pare, buka /partner/agen, klik link 'Tambah Agen' → /partner/tambahagen
    Dan Isi #nama_perusahaan='AUTOTEST-20260927-AGN-01', #penanggung_jawab='AUTOTEST-20260927-AGN-01-PIC'
    Dan Isi #email=kontakTestNotifikasi dari config/env.md (WAJIB kontak test, REQ-AGN-05)
    Dan Isi #password dan #password_confirm dengan nilai lolos regex huruf+angka min 6 karakter (mis. 'Autotest2026') — field TIDAK disebut rule (FND-RL-04), tapi WAJIB untuk submit berhasil
    Dan Isi #telp=kontakTestWhatsapp dari config/env.md
    Dan Isi #alamat_perusahaan='AUTOTEST-20260927-AGN-01 Alamat Test'
    Dan Upload #foto_identitas dan #foto_perjanjian dengan file dummy/placeholder (bukan dokumen identitas asli); biarkan #foto_stnk dan #foto_dokumen kosong (opsional)
    Dan Pilih select#status='Aktif' (REQ-AGN-05)
    Dan Pilih select#bank (mis. 'BRI'), isi #nomor_rekening dummy, isi #atas_nama='AUTOTEST-20260927-AGN-01' (Informasi Rekening, FND-RL-04)
    Dan Klik #submit_sub (native form.submit(), bukan AJAX), tunggu navigasi/reload penuh
    Dan Verifikasi redirect ke /partner/agen dan baris baru muncul dengan Aksi 'Detail Agen' DAN 'Hapus Agen' (akun Cabang)
    Dan Buka Detail Agen baris ini, verifikasi field Informasi Rekening & status upload dokumen sesuai input
    Dan Login Operator Pusat, buka /partner/agen, verifikasi baris yang sama JUGA muncul (REQ-AGN-04 sebagian) tapi TANPA tombol Edit/Hapus/Tambah Komisi (AC-AGN-01 sisi Pusat)
    Maka Data tersimpan dengan seluruh field termasuk yang TIDAK disebut rule (Kata Sandi, Dokumen, Informasi Rekening — FND-RL-04) berhasil diisi dan tersimpan, TERBUKTI WAJIB untuk submit berhasil
    Dan Notifikasi login diharapkan terkirim ke kontak test karena status Aktif saat pembuatan pertama (REQ-AGN-05) — verifikasi sebatas tidak ada error alur submit, isi kontak TIDAK dicek (di luar cakupan portal /agen)
    Dan Baris tampil di Daftar Cabang (pembuat, dengan Hapus Agen) DAN Daftar Pusat (view-only) — AC-AGN-01 dan AC-AGN-03 (bagian testable) terverifikasi
    # Catatan: MEMBUAT DATA BARU (Agen). WAJIB kontak test. Dipakai ulang oleh SCN-0014/0015/0018/0019, dihapus di SCN-0021. Siapkan file dummy upload SEBELUM eksekusi.

  @negative @high @SCR-AGN-03 @REQ-AGN-02 @VAL-AGN-01
  Skenario: SCN-0014 Tambah Agen dengan seluruh field wajib kosong — verifikasi alert zemPopover per-field berurutan (termasuk validasi Kata Sandi)
    Ketika Login Operator Cabang Pare-Pare, buka /partner/tambahagen, JANGAN isi field apa pun
    Dan PERINGATAN TEKNIS sama seperti SCN-0003: zemPopover auto-hilang ~1000ms, baca popover SEGERA dalam callback yang sama dengan klik Simpan
    Dan Klik #submit_sub, baca popover pertama SEGERA → harus 'Masukkan Nama Perusahaan'
    Dan Isi field satu-per-satu mengikuti urutan M-AGN-01: penanggung_jawab kosong → 'Masukkan Nama Penanggung Jawab'; email kosong → 'Masukkan email', format salah → 'Penulisan email salah'; password kosong → 'Masukkan Kata Sandi', gagal regex → 'Kombinasi Hanya Boleh Huruf dan Angka'; password_confirm kosong → 'Masukkan Konfirmasi Kata Sandi', tidak sama → 'Kata Sandi Belum Sama'; telp kosong → 'Masukkan Nomor'; alamat_perusahaan kosong → 'Masukkan Alamat Perusahaan'; Dokumen Identitas kosong → 'Masukkan Dokumen Identitas'; Surat Perjanjian kosong → 'Masukkan Surat Perjanjian'; status kosong → 'Pilih Status'; bank kosong → 'Pilih Bank'; nomor_rekening kosong → 'Masukkan Nomor Rekening'; atas_nama kosong → 'Masukkan Nama'
    Dan Pantau network request: pastikan TIDAK ADA form.submit() sungguhan selama field wajib masih kosong
    Maka Setiap field wajib kosong/invalid memicu zemPopover per-field dengan teks PERSIS sesuai M-AGN-01 (pola IDENTIK dengan Pelanggan, BUKAN silent seperti Master) — REQ-AGN-02/VAL-AGN-01 terverifikasi, menjawab Q-RA-01
    Dan Validasi Kata Sandi (regex huruf+angka min 6) dan Konfirmasi Kata Sandi berfungsi sebagai bagian REQ-AGN-02, meski field ini FND-RL-04
    Dan Tidak ada submit berhasil selama field wajib kosong
    # Catatan: TIDAK membuat data baru.

  @negative @medium @SCR-AGN-03 @REQ-AGN-03 @VAL-AGN-02 @AC-AGN-02
  Skenario: SCN-0015 Tambah Agen dengan Email/WA duplikat milik AUTOTEST-20260927-AGN-01 (Cabang sendiri) — verifikasi alert; scope lintas-kota (Q-RA-02) TIDAK diuji
    Ketika Prasyarat: SCN-0013 sudah dijalankan (Agen 'AUTOTEST-20260927-AGN-01' ada)
    Dan Buka /partner/tambahagen (Cabang Pare-Pare yang sama), isi field valid KECUALI #email — isi PERSIS sama dengan kontakTestNotifikasi (email AGN-01), trigger cek → verifikasi popover 'Email sudah Terdaftar'
    Dan Ganti email unik, isi #telp PERSIS sama dengan kontakTestWhatsapp (WA AGN-01), trigger cek → verifikasi popover 'Nomor sudah Terdaftar'
    Dan Pantau network request: pastikan form.submit() TIDAK pernah berhasil selama duplikasi belum diperbaiki
    Maka Email duplikat (data Cabang sendiri) → 'Email sudah Terdaftar'; WA duplikat → 'Nomor sudah Terdaftar' (REQ-AGN-03/VAL-AGN-02/AC-AGN-02 terverifikasi PENUH untuk scope Cabang sendiri)
    Dan Q-RA-02 (scope lintas SEMUA kota atau cuma per-cabang) TIDAK terjawab — blockedUnless akun Operator Cabang kota lain (tidak tersedia), JANGAN menebak
    Dan Tidak ada data 'AUTOTEST-20260927-AGN-DUP' tersimpan
    # Catatan: TIDAK membuat data baru. blockedUnless hanya untuk bagian scope lintas-kota; bagian testable (Cabang sendiri) dijalankan penuh.

  @positive @high @SCR-AGN-03 @REQ-AGN-06 @AC-AGN-04
  Skenario: SCN-0016 Cabang Tambah Agen AUTOTEST-20260927-AGN-02 status 'Tidak Aktif' saat dibuat — verifikasi TIDAK ADA notifikasi terkirim
    Ketika Login Operator Cabang Pare-Pare, buka /partner/tambahagen
    Dan Isi seluruh field wajib sama seperti SCN-0013 dengan nama_perusahaan='AUTOTEST-20260927-AGN-02', gunakan kontak test BERBEDA dari AGN-01 (cek config/env.md apakah ada kontak kedua atau alias, WAJIB berbeda agar tidak ditolak unique check, JANGAN menebak nilai)
    Dan Pilih select#status='Tidak Aktif' (beda dari SCN-0013)
    Dan Klik #submit_sub, verifikasi tersimpan dengan Status='Tidak Aktif'
    Maka Data tersimpan dengan Status='Tidak Aktif'
    Dan TIDAK ADA notifikasi terkirim ke kontak test (REQ-AGN-06) — verifikasi sebatas observasi tidak langsung, JANGAN diasumsikan lolos tanpa pemeriksaan bila ada cara memeriksa log notifikasi
    # Catatan: MEMBUAT DATA BARU (Agen kedua). Dipakai ulang oleh SCN-0017, dihapus di SCN-0021.

  @positive @medium @SCR-AGN-04 @REQ-AGN-07 @AC-AGN-04
  Skenario: SCN-0017 Edit Agen AUTOTEST-20260927-AGN-02: ubah status Tidak Aktif → Aktif (reaktivasi) — verifikasi welcome email TIDAK terkirim ulang
    Ketika Prasyarat: SCN-0016 sudah dijalankan (Agen 'AUTOTEST-20260927-AGN-02' status Tidak Aktif ada)
    Dan Buka Detail Agen 'AUTOTEST-20260927-AGN-02', klik 'Edit Agen' (data milik run test ini sendiri, aman disimpan)
    Dan Verifikasi field password/password_confirm tampil mask literal '*******', JANGAN mengubah password
    Dan Ubah select#status dari 'Tidak Aktif' menjadi 'Aktif', klik Simpan
    Dan Verifikasi perubahan tersimpan (Status='Aktif')
    Maka Status berhasil diubah menjadi 'Aktif'
    Dan Welcome email 'Selamat Datang di RORO' TIDAK terkirim ulang pada reaktivasi ini (REQ-AGN-07) — verifikasi sebatas observasi tidak langsung, JANGAN diasumsikan tanpa pemeriksaan
    # Catatan: Mengedit data MILIK RUN TEST INI SENDIRI, bukan data existing nyata.

  @positive @medium @SCR-AGN-05 @REQ-AGN-08 @REQ-AGN-11 @AC-AGN-06
  Skenario: SCN-0018 Cabang Tambah Komisi Agen pada AUTOTEST-20260927-AGN-01 (persentase, rute+jenis tiket+golongan+kelas) — verifikasi confirm() dialog dulu, tersimpan, kolom 'Komisi (%)'
    Ketika Prasyarat: SCN-0013 sudah dijalankan (Agen 'AUTOTEST-20260927-AGN-01' ada)
    Dan Login Operator Cabang Pare-Pare, buka Detail Agen 'AUTOTEST-20260927-AGN-01', klik link 'Tambah Komisi' → /partner/tambahkomisiagen/<idPolos>
    Dan Siapkan page.on('dialog') handler SEBELUM klik Simpan — layar ini memicu native confirm("Apakah Anda yakin untuk menambahan komisi agen ?") LEBIH DULU sebelum AJAX POST (M-AGN-02)
    Dan Pilih select#rute, select#jenis1='Penumpang', select#golongan1, select#kelas1; isi input#harga1='10' (TIDAK ADA selector tipe1 — Komisi Agen SELALU persentase, REQ-AGN-08)
    Dan Klik Simpan, terima dialog confirm, verifikasi AJAX POST /partner/saveIncludeKomisi berhasil
    Dan Verifikasi baris Komisi baru muncul dengan kolom 'Komisi (%)' = '10'
    Dan Login Operator Pusat, buka Detail Agen yang sama, verifikasi baris Komisi JUGA tampil (view-only, tanpa kolom Aksi)
    Maka Dialog confirm() muncul SEBELUM AJAX POST tersimpan (M-AGN-02 terverifikasi ulang) — WAJIB disiapkan sebelum klik Simpan
    Dan Komisi tersimpan sebagai persentase (REQ-AGN-08), tampil di Cabang (dengan Aksi) dan Pusat (tanpa Aksi)
    Dan REQ-AGN-11 (visibilitas Cabang lain SEKOTA) HANYA sebagian terverifikasi — sisi 'Cabang lain sekota' TIDAK BISA DIUJI PENUH (hanya 1 akun Cabang), JANGAN diasumsikan
    # Catatan: MEMBUAT DATA BARU (1 baris Komisi). Dipakai ulang oleh SCN-0019, dihapus bersama Agen induknya di SCN-0021.

  @negative @medium @SCR-AGN-05 @REQ-AGN-10 @VAL-AGN-03 @AC-AGN-05 @FND-RL-01
  Skenario: SCN-0019 Duplikat kombinasi Komisi Agen (sama) pada AUTOTEST-20260927-AGN-01 — verifikasi alert aktual (FND-RL-01)
    Ketika Prasyarat: SCN-0018 sudah dijalankan (1 baris Komisi pada AUTOTEST-20260927-AGN-01)
    Dan Buka /partner/tambahkomisiagen/<idPolos>, siapkan page.on('dialog') handler untuk MENANGANI 2 dialog berurutan: confirm() dulu (M-AGN-02, terima), baru alert() duplikat
    Dan Isi kombinasi PERSIS SAMA dengan SCN-0018 (harga boleh beda), klik Simpan, terima confirm()
    Dan Verifikasi alert() KEDUA muncul dengan teks PERSIS 'Komisi yang Anda inputkan sudah ada di database' — WAJIB partial match /sudah ada di database/i, JANGAN exact-match ke teks rule (FND-RL-01)
    Dan Verifikasi tabel Komisi Agen tetap hanya 1 baris, tidak bertambah
    Maka Fungsi penolakan duplikat bekerja (AJAX /partner/saveIncludeKomisi tidak menghasilkan baris baru) — REQ-AGN-10/AC-AGN-05 terverifikasi secara FUNGSIONAL
    Dan Teks alert AKTUAL adalah 'Komisi yang Anda inputkan sudah ada di database', BUKAN persis 'Komisi sudah ada di database' — dicatat sebagai verifikasi FND-RL-01 untuk dikonfirmasi bug-triager
    # Catatan: TIDAK membuat data baru (submit duplikat sengaja ditolak).

  @positive @medium @SCR-AGN-01 @VAL-AGN-04
  Skenario: SCN-0020 Filter Daftar Relasi Agen berdasarkan Nama Perusahaan/Status lalu Reset (pengujian fungsional pertama)
    Ketika Buka /partner/agen (Cabang atau Pusat), klik toggle Filter
    Dan Isi nama_perusahaan='AUTOTEST-20260927-AGN', submit filter, verifikasi hanya baris AUTOTEST yang tampil
    Dan Reset filter, isi select#status='Aktif', submit, verifikasi hanya baris berstatus Aktif yang tampil
    Dan Klik Reset, verifikasi daftar penuh kembali
    Maka Filter nama_perusahaan dan status BERFUNGSI menyaring baris sesuai kriteria (VAL-AGN-04 — pengujian fungsional PERTAMA)
    Dan Reset mengembalikan daftar penuh
    # Catatan: Jalankan SETELAH SCN-0013/0016/0017 agar ada ≥2 data AUTOTEST.

  @positive @high @SCR-AGN-01
  Skenario: SCN-0021 Cleanup: Hapus Agen AUTOTEST-20260927-AGN-01 dan AGN-02 (Cabang) beserta Komisi terkait, verifikasi hilang dari Daftar Cabang & Pusat
    Ketika Prasyarat: SCN-0013/0015/0016/0017/0018/0019/0020 sudah dijalankan; kedua Agen AUTOTEST TIDAK pernah dipakai transaksi AG-05 apa pun — aman dihapus
    Dan Login Operator Cabang Pare-Pare (HANYA Cabang yang punya tombol Hapus Agen), buka /partner/agen, filter 'AUTOTEST-20260927-AGN'
    Dan Klik aksi Hapus pada baris 'AUTOTEST-20260927-AGN-01', konfirmasi dialog
    Dan Ulangi untuk baris 'AUTOTEST-20260927-AGN-02'
    Dan Verifikasi kedua baris hilang dari akun Cabang
    Dan Login Operator Pusat, buka /partner/agen, verifikasi kedua baris JUGA hilang
    Maka Kedua Agen AUTOTEST berhasil dihapus dari Daftar Cabang maupun Pusat
    Dan Komisi terkait tidak lagi dapat diakses — catat perilaku APA ADANYA (cascade atau orphan), bukan diasumsikan
    # Catatan: Cleanup akhir rangkaian Agen. Hapus HANYA lewat akun Cabang (REQ-AGN-01).

  @edge @medium @SCR-AGN-02 @REQ-AGN-09
  Skenario: SCN-0022 [BLOCKED — di luar cakupan OP-16/17] Efek Komisi Agen AUTOTEST-20260927-AGN-01 pada transaksi Jual Tiket Agen Pusat & Sub User Agen (Q-RA-03)
    Ketika Idealnya: login portal /agen (Agen Pusat akun #4 atau Sub User Agen) memakai kredensial AUTOTEST-20260927-AGN-01, lakukan transaksi Jual Tiket Agen (AG-05) pada kombinasi PERSIS sama dengan Komisi SCN-0018, verifikasi komisi 10% diterapkan
    Dan Pada dokumen ini: portal /agen (AG-05, P852-1066) BELUM dipetakan dan DI LUAR cakupan submodul Operator OP-16/OP-17 — TIDAK dieksekusi pada rangkaian ini
    Maka Status BLOCKED — tidak dieksekusi dalam cakupan dokumen relasi ini, baru bisa dijalankan setelah modul AG-05 dipetakan/diuji terpisah
    # Catatan: Q-RA-03 tidak dijawab di sini, JANGAN menebak. blockedUnless: modul AG-05 dipetakan. REQ-AGN-09 field-level SUDAH diverifikasi di SCN-0018 — yang BLOCKED hanya efek transaksi nyatanya.
