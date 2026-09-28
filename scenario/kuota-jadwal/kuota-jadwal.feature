# language: id
Fitur: OP-12 Kuota dan Jadwal — Tambah/Edit Kuota, Tambah/Edit Jadwal, Crew List, Tutup Jadwal
  Sumber aturan: Rule RORO v1.5.0 P552–P577 (lihat kuota-jadwal_analysis.md) + harvest UI
  27 September 2026 (kuota-jadwal_ui-inventory.md).
  KEPUTUSAN USER 27 Sep 2026: (1) tombol "Kirim ke Pelindo" (REQ-003/AC-03/VAL-008/FND-KJ-02)
  TIDAK DIUJI SAMA SEKALI — tidak ada skenario yang menyentuh/memverifikasi/mengklik tombol ini;
  (2) dropdown Trayek akun Cabang yang tidak difilter kota (FND-KJ-03/VAL-009) adalah DESAIN
  SENGAJA — diuji sebagai skenario POSITIF (SCN-0011), bukan bug-candidate.
  SCN-0001/0002/0003 dan SCN-0004 MEMBUAT DATA BARU (Kuota, Jadwal, Crewlist) berprefix
  AUTOTEST-20260927- pada jadwal keberangkatan sejauh mungkin di masa depan; SCN-0003 dan
  SCN-0004 mengakhiri dengan Hapus (cleanup) karena data belum pernah dipakai transaksi apa pun.
  SCN-0007 dan SCN-0015 berstatus BLOCKED (trayek multi-pelabuhan belum tersedia; data uji
  "sudah dipakai transaksi" milik run sendiri belum tersedia) — lihat catatan masing-masing.

  @positive @high @SCR-02 @REQ-001 @REQ-007 @REQ-011 @REQ-012 @REQ-013 @REQ-017 @REQ-018 @AC-01
  Skenario: SCN-0001 Cabang Pare-Pare: Buat Kuota & Jadwal & Crewlist AUTOTEST-20260927-KJ-CABANG lengkap (wizard 3 tahap), verifikasi tampil di Daftar Cabang sendiri dan Daftar Pusat
    Ketika Login Operator Cabang Pare-Pare, buka /partner/tambahjadwal (link 'Buat Jadwal' a.btn-buat-trayek dari /partner/masterjadwal)
    Dan Pilih Trayek (select#trayek) salah satu opsi berasal-kota Pare-Pare, SELAIN 'AUTOTEST-20260925-PPBPN-01' yang sudah dipakai transaksi OP-13; pilih Kapal (select#kapal) apa saja; isi Nomor Voyage (#nomor_voyage) = 'AUTOTEST-20260927-KJ-CABANG'
    Dan Verifikasi 3 tab (KUOTA/JADWAL/CREW LIST) muncul di bawah setelah Trayek+Kapal dipilih; verifikasi tombol 'Masukkan Crew' dan 'Selesai' pada tab CREW LIST BELUM aktif/tersedia pada tahap ini (REQ-007/011 — wizard bertahap)
    Dan Pada tab KUOTA: isi Kuota Internal & Eksternal (input#dist_penumpang<id>, input#dist_penumpang_eks<id>) untuk minimal 1 golongan penumpang; isi (input#dist_kendaraan<id>.dist_kendaraan, input#dist_kendaraan_eks<id>.dist_kendaraan_eks) untuk minimal 1 golongan kendaraan yang TIDAK readonly (hindari golongan III-A/III-B bila trayek Parepare-Balikpapan), biarkan Bonus Tiket (input.bonus_tiket) default; isi Kuota Bagasi (input#dist_bagasi<id>/_eks<id>) — catat bahwa kolom Internal dan Eksternal terpisah (REQ-013), klik Simpan pada tab KUOTA
    Dan Setelah tab KUOTA tersimpan, buka tab JADWAL: isi Waktu Berangkat (input[name='tgl_etd']) dengan tanggal SEJAUH MUNGKIN DI MASA DEPAN yang bisa dipilih datepicker, isi Waktu Tiba (input[name='tgl_eta']) setelahnya, biarkan Status Jadwal default 'Jadwal Tampil', klik Simpan pada tab JADWAL
    Dan Setelah tab JADWAL tersimpan, buka tab CREW LIST: verifikasi tombol 'Masukkan Crew' kini muncul/aktif, klik untuk membuka modal SCR-09, pilih minimal 1 Awak Kapal existing dari Master Crew untuk tiap pelabuhan, klik Simpan pada modal
    Dan Kembali ke tab CREW LIST, klik tombol 'Selesai'
    Dan Buka /partner/masterjadwal (Daftar), filter Nomor Voyage (#Nomor_Voyage) = 'AUTOTEST-20260927-KJ-CABANG', verifikasi baris muncul di akun Cabang
    Dan Login Operator Pusat, buka /partner/masterjadwal, filter Nomor Voyage yang sama, verifikasi baris yang sama juga muncul di akun Pusat
    Maka Tab JADWAL dan CREW LIST secara efektif tidak bisa diselesaikan sebelum tahap sebelumnya benar-benar tersimpan (REQ-007/011 terverifikasi lewat elemen interaktif yang nonaktif sampai tahap sebelumnya tersimpan)
    Dan Field Kuota Internal dan Eksternal tersedia sebagai kolom terpisah dan bisa diisi independen (REQ-013)
    Dan Tombol Selesai berhasil menyelesaikan wizard setelah crew diisi (REQ-012)
    Dan Baris 'AUTOTEST-20260927-KJ-CABANG' tampil di Daftar akun Cabang Pare-Pare (pembuatnya) DAN di Daftar akun Pusat (REQ-001/AC-01)
    # Catatan: MEMBUAT DATA BARU (Kuota, Jadwal, Crewlist). Dipakai ulang oleh SCN-0002 (perbandingan Edit) dan SCN-0003 (Tutup Jadwal + cleanup) sebelum akhirnya dihapus di SCN-0003 — jangan dihapus di scenario ini. Golongan kendaraan yang dipilih WAJIB bukan III-A/III-B pada trayek Parepare-Balikpapan (readonly, lihat VAL-006/SCN-0009). Trayek yang dipakai harus SELAIN AUTOTEST-20260925-PPBPN-01 (id 2293, sudah dipakai transaksi OP-13, jangan disentuh sesuai Q-KJ-04).

  @positive @medium @SCR-06 @REQ-019 @AC-11
  Skenario: SCN-0002 Edit Kuota & Jadwal AUTOTEST-20260927-KJ-CABANG: verifikasi field Edit sama dengan Tambah (REQ-019)
    Ketika Prasyarat: SCN-0001 sudah dijalankan (Kuota & Jadwal 'AUTOTEST-20260927-KJ-CABANG' sudah ada)
    Dan Buka /partner/masterjadwal, filter Nomor Voyage = 'AUTOTEST-20260927-KJ-CABANG', klik aksi Edit (a.btn-edit.edit) pada baris tsb — AJAX in-place swap ke SCR-06/07/08, URL tetap /partner/masterjadwal
    Dan Bandingkan field yang tampil pada tab Kuota/Jadwal/crew list Edit dengan field pada tab KUOTA/JADWAL/CREW LIST Tambah (SCR-03/04/05): Trayek, Kapal, Kode Kapal, Kapasitas (disabled+terisi), Nomor Voyage (tetap editable), distribusi Kuota, Waktu Berangkat/Tiba, Status Jadwal
    Dan TIDAK mengubah/menyimpan apa pun, navigasi keluar
    Maka Struktur & label field Edit identik dengan Tambah, hanya field Trayek/Kapal/Kode Kapal/Kapasitas yang disabled+terisi data existing (REQ-019/AC-11)
    Dan Nomor Voyage tetap dapat diedit (bukan disabled)
    Dan Tidak ada perubahan yang disimpan
    # Catatan: Read-only comparison, tidak mengubah data 'AUTOTEST-20260927-KJ-CABANG' (masih dipakai SCN-0003 sesudah ini).

  @positive @high @SCR-04 @REQ-010 @AC-09
  Skenario: SCN-0003 Tutup Jadwal AUTOTEST-20260927-KJ-CABANG lalu verifikasi hilang dari pencarian Jual Tiket/User Umum, kemudian Hapus (cleanup)
    Ketika Prasyarat: SCN-0001 sudah dijalankan; jadwal 'AUTOTEST-20260927-KJ-CABANG' belum pernah dipakai transaksi apa pun sehingga aman dihapus di akhir
    Dan Sebelum ditutup: cross-check jadwal ini MUNCUL sebagai pilihan di pencarian Jual Tiket Operator (OP-13) dan/atau Cari Jadwal User Umum (UM-03) sebagai baseline
    Dan Buka Edit Kuota & Jadwal 'AUTOTEST-20260927-KJ-CABANG', tab Jadwal, ubah select Status Jadwal menjadi 'Jadwal Tutup' (value Tutup), klik Simpan
    Dan Ulangi pencarian yang sama di Jual Tiket (OP-13) dan/atau Cari Jadwal User Umum (UM-03)
    Dan Kembali ke /partner/masterjadwal, klik aksi Hapus (a.btn-delete.delete-jadwal) pada baris 'AUTOTEST-20260927-KJ-CABANG' untuk cleanup
    Maka Sebelum ditutup, jadwal tampil sebagai pilihan di pencarian Jual Tiket/User Umum
    Dan Setelah Status Jadwal diubah ke 'Jadwal Tutup' dan disimpan, jadwal TIDAK LAGI muncul di pencarian yang sama (REQ-010/AC-09, menjawab Q-KJ-02)
    Dan Setelah Hapus, baris 'AUTOTEST-20260927-KJ-CABANG' hilang dari /partner/masterjadwal baik di akun Cabang maupun Pusat
    # Catatan: Cross-module verification (OP-13/UM-03) — bila modul tsb belum bisa diakses pada sesi eksekusi, tandai bagian cross-module ini blocked secara parsial dan tetap lanjutkan cleanup Hapus. Cleanup ini AMAN karena jadwal belum pernah dipakai transaksi nyata (dibuat & dihapus dalam rangkaian test yang sama, bukan kasus Q-KJ-04).

  @positive @high @SCR-02 @REQ-002 @REQ-006 @VAL-005 @AC-02
  Skenario: SCN-0004 Pusat: Buat Kuota & Jadwal AUTOTEST-20260927-KJ-PUSAT pada trayek berasal kota Pare-Pare, uji tepi Bonus Tiket melebihi sisa Kuota Kendaraan, verifikasi otomatis tampil di Daftar Cabang Pare-Pare, lalu Hapus (cleanup)
    Ketika Login Operator Pusat, buka /partner/tambahjadwal
    Dan Pilih Trayek (select#trayek) berasal-kota Pare-Pare, SELAIN trayek yang dipakai SCN-0001 dan SELAIN 'AUTOTEST-20260925-PPBPN-01'; pilih Kapal apa saja; isi Nomor Voyage = 'AUTOTEST-20260927-KJ-PUSAT'
    Dan Pada tab KUOTA, pilih 1 golongan kendaraan yang EDITABLE (bukan III-A/III-B Parepare-Balikpapan), isi Kuota Internal=1 dan Eksternal=1 (total 2), lalu isi Bonus Tiket (input.bonus_tiket) golongan tsb dengan nilai jauh melebihi total (mis. 999)
    Dan Klik Simpan pada tab KUOTA, amati apakah ditolak (validasi bonus vs sisa kuota kapal) atau diterima apa adanya (Q-KJ-01)
    Dan Jika ditolak: perbaiki nilai Bonus Tiket ke angka wajar dan Simpan ulang agar wizard bisa lanjut. Jika diterima: lanjutkan apa adanya dan catat sebagai temuan
    Dan Lanjutkan tab JADWAL (tanggal SEJAUH MUNGKIN DI MASA DEPAN) dan tab CREW LIST (minimal 1 crew per pelabuhan) hingga klik 'Selesai'
    Dan Login Operator Cabang Pare-Pare, buka /partner/masterjadwal, filter Nomor Voyage = 'AUTOTEST-20260927-KJ-PUSAT', verifikasi baris muncul TANPA operator Cabang membuatnya sendiri
    Dan Login kembali Operator Pusat, hapus (a.btn-delete.delete-jadwal) baris 'AUTOTEST-20260927-KJ-PUSAT' sebagai cleanup, verifikasi hilang dari Daftar Pusat maupun Cabang
    Maka Dicatat apa adanya: Simpan dengan Bonus Tiket jauh melebihi sisa Kuota Kendaraan DITOLAK (validasi keras) ATAU DITERIMA (tidak ada validasi otomatis) — bukan diasumsikan sebelum eksekusi (REQ-006/VAL-005/Q-KJ-01)
    Dan Kuota & Jadwal yang dibuat Pusat pada trayek berkota-asal Pare-Pare otomatis tampil di Daftar akun Cabang Pare-Pare tanpa aksi tambahan dari Cabang (REQ-002/AC-02)
    Dan Setelah Hapus, baris 'AUTOTEST-20260927-KJ-PUSAT' hilang dari kedua akun
    # Catatan: MEMBUAT DATA BARU (Kuota, Jadwal, Crewlist), dihapus di akhir skenario yang sama (aman, tidak dipakai transaksi apa pun).

  @negative @high @SCR-03 @REQ-005 @VAL-001 @AC-06
  Skenario: SCN-0005 Simpan tab KUOTA dengan field distribusi kosong — observasi perilaku sebenarnya (VAL-001)
    Ketika Buka /partner/tambahjadwal, pilih Trayek & Kapal existing apa saja (data existing, hanya untuk memunculkan tab — TIDAK bermaksud membuat Jadwal untuk trayek ini), isi Nomor Voyage = 'AUTOTEST-20260927-EMPTY-KUOTA'
    Dan Pada tab KUOTA, BIARKAN seluruh field distribusi (dist_penumpang*, dist_kendaraan*, dist_bagasi*) kosong/default
    Dan Pantau network request (browser_network_requests), lalu klik Simpan
    Dan Amati: apakah ada request POST/AJAX terkirim, apakah muncul alert/popover, apakah lanjut ke tab JADWAL, atau tetap diam (silent)
    Dan JIKA ternyata tersimpan (ada baris baru dengan Nomor Voyage 'AUTOTEST-20260927-EMPTY-KUOTA' di /partner/masterjadwal): segera Hapus baris tsb sebagai cleanup. JIKA silent/tidak tersimpan: tidak perlu cleanup
    Maka Dicatat apa adanya salah satu dari: (a) tidak ada request terkirim & tidak ada perubahan (silent, konsisten AC-06), (b) muncul pesan validasi, atau (c) request terkirim dan data tersimpan meski field kosong (pelanggaran AC-06, catat sebagai temuan baru) — BUKAN diasumsikan sebelum eksekusi
    Dan Jika data sempat tersimpan, cleanup Hapus berhasil dilakukan
    # Catatan: OBSERVASIONAL — hasil sebenarnya belum diketahui saat harvest (beda dari FND-M-01 Master yang sudah terverifikasi silent). Trayek/Kapal yang dipilih adalah data existing, hanya dipakai untuk membuka form, TIDAK dimaksudkan tersimpan.

  @negative @high @SCR-04 @REQ-009 @VAL-002 @AC-06
  Skenario: SCN-0006 Simpan tab JADWAL dengan Waktu Berangkat/Tiba kosong — observasi perilaku sebenarnya (VAL-002)
    Ketika Buka /partner/tambahjadwal, pilih Trayek & Kapal existing apa saja (data existing, tidak bermaksud membuat Jadwal), isi Nomor Voyage = 'AUTOTEST-20260927-EMPTY-JADWAL'
    Dan Langsung klik tab JADWAL TANPA mengisi/menyimpan tab KUOTA lebih dulu — amati apakah tab JADWAL bisa diakses & Status Jadwal/Pelabuhan tampil normal walau Kuota belum disimpan
    Dan Biarkan Waktu Berangkat (input[name='tgl_etd']) dan Waktu Tiba (input[name='tgl_eta']) kosong, biarkan Status Jadwal default 'Jadwal Tampil'
    Dan Pantau network request, lalu klik Simpan pada tab JADWAL
    Dan Amati: request terkirim/tidak, alert/tidak, redirect/tidak
    Dan JIKA ternyata tersimpan (baris 'AUTOTEST-20260927-EMPTY-JADWAL' muncul di /partner/masterjadwal): segera Hapus sebagai cleanup
    Maka Dicatat apakah tab JADWAL bisa disimpan independen dari tab KUOTA yang belum disimpan (catatan tambahan di luar VAL-002)
    Dan Dicatat apa adanya salah satu dari: silent tanpa request (konsisten AC-06), muncul pesan validasi, atau request terkirim & data tersimpan meski tanggal kosong (catat sebagai temuan baru) — bukan diasumsikan
    Dan Jika sempat tersimpan, cleanup Hapus berhasil
    # Catatan: OBSERVASIONAL, sama seperti SCN-0005/VAL-001. Trayek/Kapal existing hanya dipakai membuka form.

  @edge @medium @SCR-02 @REQ-008 @VAL-003 @AC-07
  Skenario: SCN-0007 [BLOCKED — trayek uji belum tersedia] Tambah Jadwal trayek multi-rute (≥3 pelabuhan): urutan tanggal wajib urut (REQ-008/VAL-003)
    Ketika Buka /partner/tambahjadwal, periksa seluruh 24 opsi select#trayek satu per satu (nama trayek tidak selalu mencerminkan jumlah pelabuhan) untuk mencari trayek dengan ≥3 pelabuhan/≥2 leg
    Dan Bila ditemukan trayek multi-pelabuhan yang SUDAH punya Tarif Pass (tampil sebagai opsi): lanjutkan uji — pada tab JADWAL isi tanggal rute kedua SAMA/LEBIH AWAL dari rute pertama, amati apakah datepicker membatasi atau submit ditolak
    Dan Bila TIDAK ditemukan (sesuai temuan harvest 27 September 2026 — semua 24 opsi hanya 2 pelabuhan/1 leg): tandai skenario BLOCKED, JANGAN membuat Trayek baru di Master untuk memenuhi prasyarat ini
    Maka Jika trayek multi-pelabuhan ditemukan: tanggal rute kedua ≤ rute pertama ditolak (datepicker atau submit), sesuai AC-07
    Dan Jika tidak ditemukan: status BLOCKED, dicatat alasan 'tidak ada trayek uji ≥3 pelabuhan yang sudah punya Tarif Pass tersedia di antara 24 opsi dropdown' — TIDAK membuat/mengedit Trayek baru di OP-11 Master untuk kasus ini (di luar cakupan modul Kuota & Jadwal, keputusan eksplisit)
    # Catatan: blockedUnless: trayek Master 'asdfghdaf' (Balikpapan-Parepare-Taipa, FND-M-05 di master_analysis.md, data tertinggal sesi lain) bisa jadi kandidat TAPI belum dipastikan sudah punya Tarif Pass (syarat REQ-004) sehingga muncul di dropdown ini — cek dulu sebelum eksekusi. Terkait juga Q-KJ-06 (belum jelas apakah syarat Tarif Pass berlaku semua leg atau sebagian saja pada trayek multi-pelabuhan).

  @positive @high @SCR-05 @REQ-012 @VAL-004 @AC-08
  Skenario: SCN-0008 Tombol 'Selesai' pada tab CREW LIST tetap disabled sebelum Kuota/Jadwal disimpan (VAL-004)
    Ketika Buka /partner/tambahjadwal, pilih Trayek & Kapal existing apa saja (belum menyimpan apa pun)
    Dan Klik tab CREW LIST
    Dan Periksa atribut disabled elemen tombol 'Selesai' via DOM
    Maka Tombol 'Selesai' memiliki atribut HTML disabled=true, didampingi teks 'Pastikan Crew List sudah terisi semua' (M-02) — bukan alert (VAL-004/REQ-012/AC-08 terverifikasi ulang saat eksekusi)
    Dan Tidak ada data yang disimpan pada skenario ini
    # Catatan: Assertion langsung sesuai instruksi (VAL-004 sudah terverifikasi penuh via DOM saat harvest), tidak perlu alur submit penuh.

  @positive @high @SCR-06 @REQ-015 @REQ-016 @VAL-006 @AC-10
  Skenario: SCN-0009 Field Bonus Tiket golongan III-A/III-B pada jadwal Parepare-Balikpapan readonly, dibandingkan trayek lain yang editable (VAL-006)
    Ketika Buka /partner/masterjadwal, cari jadwal 'AUTOTEST-20260925-PPBPN-01' (id 2293, trayek Parepare-Balikpapan) — data existing SUDAH DIPAKAI transaksi lain (Q-KJ-04), klik Edit HANYA untuk membaca (JANGAN mengubah/menyimpan apa pun)
    Dan Pada tab Kuota, periksa atribut readonly elemen input.bonus_tiket golongan 'Kendaraan Kecil (III-A)' dan 'Mobil Mewah (III-B)'
    Dan Navigasi keluar TANPA Simpan
    Dan Buka /partner/tambahjadwal, pilih Trayek Bakauheni-Merak (atau trayek non-Parepare-Balikpapan lain), amati field Bonus Tiket golongan setara — TANPA Simpan
    Maka Field Bonus Tiket golongan III-A/III-B pada jadwal Parepare-Balikpapan memiliki atribut readonly=true, value tetap '1' (REQ-016/VAL-006/AC-10)
    Dan Field Bonus Tiket pada trayek pembanding (Bakauheni-Merak) TIDAK readonly (editable)
    Dan Tidak ada perubahan yang disimpan pada jadwal existing 2293 maupun trayek pembanding
    # Catatan: Read-only observation only, TIDAK mengedit/menyimpan jadwal 2293 (data terpakai transaksi, Q-KJ-04) — konsisten batasan risiko di kuota-jadwal_analysis.md. Turut menambah sampel untuk Q-KJ-03 (generalisasi readonly khusus III-A/III-B + Parepare-Balikpapan, bukan perilaku umum semua golongan/rute) — jangan menggeneralisasi lebih jauh dari 2 sampel trayek yang diuji di sini.

  @edge @medium @SCR-01 @FND-KJ-01
  Skenario: SCN-0010 Klik 'Lihat' pada baris Daftar Kuota & Jadwal menampilkan panel collapse kosong (FND-KJ-01)
    Ketika Buka /partner/masterjadwal, klik ikon mata 'Lihat' (a.btn-viewnya) pada salah satu baris data existing (bukan data AUTOTEST manapun)
    Dan Amati panel collapse (.col<id>) yang terbuka
    Maka Panel collapse terbuka (state collapse show) tetapi TIDAK menampilkan detail data apa pun (kosong, hanya elemen pembatas visual) — mengonfirmasi/membantah FND-KJ-01, pola sama FND-M-04 Master
    Dan Tidak ada perubahan data (aksi Lihat bersifat read-only)
    # Catatan: Memverifikasi kandidat gap desain FND-KJ-01 (pola sama FND-M-04 Master/OP-21). Gunakan data existing manapun, tidak perlu entitas baru.

  @positive @medium @SCR-02 @VAL-009 @FND-KJ-03
  Skenario: SCN-0011 Opsi dropdown Trayek pada Tambah Kuota & Jadwal akun Cabang identik dengan akun Pusat (desain sengaja, VAL-009/FND-KJ-03)
    Ketika Login Operator Pusat, buka /partner/tambahjadwal, ambil seluruh opsi teks select#trayek
    Dan Login Operator Cabang Pare-Pare, buka /partner/tambahjadwal, ambil seluruh opsi teks select#trayek
    Dan Bandingkan kedua daftar opsi
    Maka Daftar opsi Trayek pada akun Cabang SAMA PERSIS dengan akun Pusat (termasuk trayek yang tidak terkait kota Pare-Pare) — mengonfirmasi ini desain sengaja (BUKAN bug), sesuai keputusan user 27 September 2026
    Dan Tidak ada data yang disimpan
    # Catatan: Skenario POSITIF sesuai keputusan user 27 Sep 2026 (FND-KJ-03 DITUTUP, bukan bug-candidate/skenario negatif).

  @positive @medium @SCR-01 @VAL-007
  Skenario: SCN-0012 Filter Daftar Kuota & Jadwal berdasarkan Nama Trayek lalu Reset
    Ketika Buka /partner/masterjadwal, klik toggle Filter (#btn-filter)
    Dan Isi Nama Trayek (#Nama_Trayek) dengan kata kunci yang diketahui ada (mis. 'SURABAYA'), submit Filter
    Dan Klik Reset (.reset-master)
    Maka Setelah filter, hanya baris yang Trayek-nya mengandung kata kunci yang tampil (dikonfirmasi live saat harvest: 2242→230 data untuk kata kunci 'SURABAYA')
    Dan Setelah Reset, daftar penuh tampil kembali
    # Catatan: Efek filter sudah TERVERIFIKASI saat harvest; efek Reset belum dicoba eksplisit sebelumnya — dikonfirmasi di sini.

  @positive @medium @SCR-02 @REQ-004 @REQ-013 @REQ-017 @REQ-018 @AC-04 @AC-05
  Skenario: SCN-0013 Verifikasi ketergantungan Master: Trayek/Golongan/Kelas yang tampil di Tambah Kuota & Jadwal sesuai data Master (REQ-004/017/018)
    Ketika Buka /partner/tarifpass (Master), catat beberapa Trayek yang SUDAH punya Tarif Pass
    Dan Buka /partner/tambahjadwal, periksa opsi select#trayek — verifikasi semua opsi cocok dengan Trayek yang sudah punya Tarif Pass di Master (REQ-004/AC-04), bukan seluruh Trayek Master
    Dan Pilih salah satu Trayek, lalu pilih Kapal — pada tab KUOTA, periksa opsi golongan kendaraan/bagasi yang muncul, bandingkan dengan Master Harga+Tarif Pass untuk trayek tsb (REQ-017/AC-05)
    Dan Periksa opsi golongan penumpang yang muncul, bandingkan dengan Master Kelas milik Kapal yang dipilih (REQ-018/AC-05)
    Dan Verifikasi kolom Kuota Internal dan Kuota Eksternal tampil terpisah untuk tiap golongan (REQ-013)
    Dan TIDAK menyimpan apa pun
    Maka Opsi Trayek pada Tambah HANYA yang sudah punya Tarif Pass di Master (REQ-004/AC-04)
    Dan Opsi golongan kendaraan/bagasi sesuai Harga+Tarif Pass Trayek terpilih; opsi golongan penumpang sesuai Kelas Kapal terpilih (REQ-017/018/AC-05)
    Dan Kolom Kuota Internal & Eksternal terpisah dan independen (REQ-013)
    Dan Tidak ada data yang disimpan

  @edge @low @SCR-03 @REQ-014
  Skenario: SCN-0014 Observasi apakah field Bonus Tiket kendaraan otomatis mengikuti formula (Kuota Internal+Eksternal) × bonus per golongan (REQ-014)
    Ketika Buka /partner/tambahjadwal, pilih Trayek & Kapal existing apa saja (data existing, tidak bermaksud menyimpan)
    Dan Pada tab KUOTA, catat nilai default Bonus Tiket (input.bonus_tiket) untuk 1 golongan kendaraan sebelum mengisi Kuota
    Dan Isi Kuota Internal dan Eksternal untuk golongan tsb dengan angka berbeda-beda (mis. 5+5, lalu ubah ke 10+10), amati apakah nilai Bonus Tiket berubah otomatis mengikuti formula (Internal+Eksternal)×bonus, atau tetap statis (manual entry)
    Dan TIDAK menyimpan apa pun
    Maka Dicatat apa adanya: field Bonus Tiket berubah otomatis mengikuti formula REQ-014, ATAU tetap statis/manual (operator harus menghitung sendiri) — bukan diasumsikan sebelumnya
    Dan Tidak ada data yang disimpan
    # Catatan: Observasional, menjawab catatan 'PERLU VERIFIKASI UI' REQ-014 di kuota-jadwal_analysis.md.

  @edge @medium @SCR-06
  Skenario: SCN-0015 [BLOCKED — data uji belum tersedia] Edit Kuota/Jadwal yang sudah dipakai transaksi lain — perilaku belum diketahui (Q-KJ-04)
    Ketika Idealnya: identifikasi Kuota & Jadwal uji milik run automation ini SENDIRI yang sudah dipakai transaksi OP-13 secara terkontrol, lalu coba Edit field non-destruktif kecil (mis. Nomor Voyage), amati diterima/ditolak/pesan
    Dan Pada run ini: BELUM ada Kuota & Jadwal uji milik run sendiri yang sudah dipakai transaksi terkontrol (SCN-0001/SCN-0004 sengaja dihapus di akhir sebelum dipakai transaksi apa pun, agar aman dibersihkan) — dan data existing yang sudah dipakai transaksi (mis. 'AUTOTEST-20260925-PPBPN-01' id 2293) berisiko mengganggu transaksi/manifest/laporan nyata bila diedit
    Maka Status BLOCKED — tidak dieksekusi pada run ini. Baru bisa dijalankan bila tersedia Kuota & Jadwal uji milik run ini sendiri yang SUDAH dipakai transaksi OP-13 secara terkontrol (data sepenuhnya milik test, aman diedit untuk observasi), dan hasilnya dicatat sebagai temuan baru berdasarkan observasi (bukan pass/fail berdasar ekspektasi yang ditebak)
    # Catatan: Sesuai instruksi tugas: Q-KJ-04 belum diuji, tidak boleh diasumsikan boleh/dilarang. blockedUnless: butuh data uji sendiri yang sudah terpakai transaksi secara terkontrol lebih dulu (di luar cakupan modul ini sendiri, perlu koordinasi dengan skenario OP-13 pada run berikutnya).
