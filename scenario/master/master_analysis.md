# OP-11 Master — Analisis Requirement

Sumber: `scenario/Dokumen Rule RORO v1.5.0 v19042025.docx`, bagian Master (P480–P551), dirujuk dari
`docs/module-map-from-rules.md` baris OP-11 (termasuk bagian "Perbedaan pengguna yang dinyatakan
sumber" dan "Aturan lintas modul operator"). Rujukan `P<n>` = indeks paragraf DOCX ke-n (mulai 0,
termasuk paragraf kosong/tabel, urutan `word/document.xml//w:p`) — diekstrak dengan skrip Python
(`xml.etree.ElementTree` atas `word/document.xml` hasil unzip docx), bukan nomor halaman.
Ditambah verifikasi UI langsung pada `explore/module-map.md` ("Eksplorasi detail kelompok Master —
26 September 2026") dan hasil eksplorasi UI Langkah 2 dokumen ini (27 September 2026).

Cakupan modul: **Kelas, Golongan, Kapal, Trayek, Harga (+ Riwayat Harga), Tarif Pass Pelabuhan,
Crew, Denda Pembatalan, Informasi** — sesuai P480–P551. Sidebar aplikasi (UI v1.5.2) menambahkan
submenu ke-7 **Master Asuransi** (`/partner/masterasuransi`) yang **tidak ada** di dokumen rule
v1.5.0 manapun di P480–P551; ini gap dokumentasi yang sudah dicatat sebelumnya di
`explore/module-map.md` baris 175, bukan temuan baru. Master Asuransi tetap dipetakan di
`master_ui-inventory.md` (karena ada di sidebar MASTER sungguhan dan harus dijelajah sesuai
instruksi), tetapi **tidak** punya REQ bersumber rule di dokumen ini.

Akun uji: **Operator Pusat** (akun #2, `prdct.atg@gmail.com`, `config/env.md`) sebagai akun utama
untuk seluruh submodul; **Operator Cabang Pare-Pare** (akun #3, `partnerbidph@gmail.com`, Sub User
Cabang "Akses IK") dipakai khusus untuk verifikasi pembatasan **Denda Pembatalan** (P540) dan
sebagai spot-check akses baca/tulis submodul lain. Tanggal kajian: 27 September 2026.

## Catatan risiko khusus modul ini (penting untuk tahap penulisan skenario)

Berbeda dari OP-21 (data Sub User/Hak Akses relatif terisolasi dan bisa dihapus balik), data
**Master** (Kelas, Golongan, Kapal, Trayek, Harga, Tarif Pass, Crew, Informasi) adalah **data
referensi bersama** yang dipakai lintas seluruh sistem (Kuota & Jadwal, Jual Tiket, Dashboard
Agen, dll.) dan **begitu dipakai di modul lain menjadi tidak bisa dihapus** (P482, P486, P500,
P501, P509, P516). Data test `AUTOTEST-<tanggal>-` yang dibuat di modul ini **berisiko tertinggal
permanen** bila skenario lanjutan (mis. pembuatan jadwal) memakainya sebelum sempat dihapus.
Urutan pembersihan yang disarankan: hapus dari yang paling "hilir" dulu (Harga → Trayek → Kapal →
Kelas/Golongan; Tarif Pass terpisah), dan **jangan** membuat data Kelas/Golongan/Kapal/Trayek
kecuali skenario benar-benar butuh — pertimbangkan cukup memverifikasi form/validasi tanpa Simpan
bila REQ bisa diuji tanpa menyimpan (banyak REQ di bawah ini justru soal *penolakan* Simpan/Hapus,
yang bisa diuji tanpa membuat data baru).

Selain itu, **Denda Pembatalan** adalah *setting tunggal milik tenant* (bukan per-baris data yang
bisa dihapus) — mengubah nilainya memengaruhi perhitungan denda pembatalan tiket agen sungguhan.
Skenario yang menulis (Simpan) di modul ini **wajib** ada izin eksplisit user per kasus, sesuai
`docs/agent-guide.md` ("dilarang keras ... mengubah setting tenant"), dan **harus dicatat** di
`shared/decisions.md` sebelum dieksekusi.

## REQ — aturan bisnis dari dokumen rule

| ID | Aturan | Sumber | Dapat diuji di web? |
|---|---|---|---|
| REQ-001 | Master Kelas yang sudah dipakai di Master Kapal tidak bisa dihapus. | P482 | Ya — ✅ diverifikasi live 27 Sep 2026: hapus kelas terpakai memunculkan SweetAlert "Data Digunakan di Master Kapal" |
| REQ-002 | Tambah Golongan Penumpang: semua field wajib diisi/tidak boleh kosong. | P484 | Ya |
| REQ-003 | Tambah Golongan Kendaraan: hanya field "kategori dan Kategori" yang boleh diisi (kalimat sumber diulang, makna persis belum jelas — lihat Q-M-01). | P485 | Ya, dengan catatan ambiguitas kalimat sumber |
| REQ-004 | Master Golongan tidak bisa dihapus ketika sudah dipakai di Master Kapal. | P486 | Ya (pola sama dengan REQ-001) |
| REQ-005 | Tambah/Edit: Status tiket aktif punya 2 pilihan — "Semua Channel" dan "Hanya Cabang". | P487 | Ya — ✅ dikonfirmasi live: select `muncul`/`muncul1` opsi `UMUM`="Semua Channel", `CABANG`="Hanya Cabang" |
| REQ-006 | "Semua Channel": tiket yang dijual tampil di User Umum, Cabang, dan Agen (agen pusat & sub user agen). | P488 | Sebagian — field tersimpan di sini; efek tampil lintas channel diuji di modul lain (Jual Tiket/User Umum/Agen) |
| REQ-007 | "Hanya Cabang": tiket yang dijual hanya tampil di Cabang. | P489 | Sebagian — sama seperti REQ-006 |
| REQ-008 | Tambah Kapal: pemilihan kelas bisa lebih dari satu, daftar kelas berasal dari Master Kelas. | P491 | Ya — ✅ dikonfirmasi live: `select[name="kelas[]"]` multi-select terisi dari data Master Kelas |
| REQ-009 | Tambah Kapal: semua field wajib diisi/tidak boleh kosong. | P492 | Ya, tapi lihat FND-M-01 (Simpan kosong tidak memberi pesan apa pun) |
| REQ-010 | Call sign untuk saat ini diisi dengan kode API Pelindo. | P493 | Tidak — catatan pengisian data, bukan aturan validasi yang bisa diuji sebagai pass/fail UI |
| REQ-011 | Tambah Trayek: semua field wajib diisi kecuali Konsumsi Penumpang. | P495 | Ya — ✅ dikonfirmasi live: label `Konsumsi Penumpang` tanpa tanda `*`, field lain bertanda `*` |
| REQ-012 | Trayek 2 pelabuhan: baris "RUTE DIJUAL DARI SATU TRAYEK" harus urut sesuai pelabuhan yang dipilih di "Pilih Pelabuhan". | P496 | Ya — butuh kasus 2 pelabuhan |
| REQ-013 | Trayek 3 pelabuhan: baris rute harus urut/tidak boleh melompati (jadi Pelabuhan1→2, Pelabuhan2→3). | P497–P499 | Ya — butuh kasus 3 pelabuhan |
| REQ-014 | Edit Trayek tidak bisa dilakukan ketika trayek sudah punya harga. | P500 | Ya — butuh trayek uji yang sudah diisi harga |
| REQ-015 | Hapus Trayek tidak bisa dilakukan ketika trayek sudah punya harga. | P501 | Ya — sama seperti REQ-014 |
| REQ-016 | Tambah Harga: hanya bisa ditambahkan ketika harga (untuk kombinasi rute terkait) belum pernah ditambahkan. | P503 | Ya, tapi makna "belum pernah ditambahkan" perlu diverifikasi saat scenario-writing (lihat Q-M-02) |
| REQ-017 | Tambah Harga: semua field harus ada inputannya. | P504 | Ya, tapi lihat FND-M-01 |
| REQ-018 | Harga tidak boleh sama dari segi kombinasi (Golongan Tiket, Mulai Berlaku, Kondisi Kendaraan). | P505 | Ya |
| REQ-019 | Baris harga yang sama (duplikat) ditandai merah setelah ditambahkan. | P506 | Ya — assertion visual/CSS |
| REQ-020 | Edit Harga: aturan tidak-boleh-sama yang sama berlaku (Golongan Tiket, Mulai Berlaku, Kondisi Kendaraan). | P507 | Ya |
| REQ-021 | Edit Harga: menghapus salah satu baris harga **tetap terhapus meskipun klik Batal** — sumber sendiri menandai "harus dipastikan lagi". | P508 | Ya, TAPI BERISIKO — jangan diuji pada data harga produksi; lihat Q-08 di `docs/module-map-from-rules.md` (belum dilabeli bug oleh sumber) |
| REQ-022 | Hapus Harga tidak bisa dilakukan ketika harga sudah dipakai di Master Jadwal (Kuota & Jadwal). | P509 | Ya |
| REQ-023 | Riwayat Harga mencatat: (a) saat data harga dihapus, dan (b) saat edit harga memperbarui tanggal mulai berlaku. | P510–P512 | Ya — ✅ route `/partner/historyharga/<id>` dikonfirmasi live, kolom "Status" ada di tabel riwayat |
| REQ-024 | Tambah Harga Tarif Pass: hanya bisa ditambahkan ketika harga tarif pass (untuk rute terkait) belum pernah ditambahkan. | P514 | Ya (pola sama dengan REQ-016) |
| REQ-025 | Data Tarif Pass yang sudah ada adalah referensi dari Administrator. | P515 | Tidak langsung — asal data dari sisi Admin (`/adminprahu`), di luar cakupan pengujian OP-11 murni; hanya bisa diobservasi nilainya |
| REQ-026 | Hapus Tarif Pass tidak bisa dilakukan ketika sudah dipakai di Kuota dan Jadwal. | P516 | Ya |
| REQ-027 | Pertama kali menambahkan Tarif Pass untuk suatu rute, harga akan direkomendasikan (hasil input Administrator). | P517 | Sebagian — butuh rute baru yang belum ada tarif pass-nya untuk verifikasi nilai default terisi |
| REQ-028 | Tambah Crew: semua field wajib diisi. | P519 | Ya, tapi lihat FND-M-01 |
| REQ-029 | Data Crew yang ditambahkan masuk sebagai pilihan crew list di Kuota dan Jadwal. | P520 | Sebagian — verifikasi lanjutan ada di modul OP-12 (di luar cakupan OP-11) |
| REQ-030 | Master Denda Pembatalan mengatur jumlah denda pada pembatalan **tiket Agen** (bukan tiket cabang/user umum secara langsung). | P522 | Ya — batasan lingkup dicatat eksplisit untuk penulisan skenario |
| REQ-031 | Default ada 3 jenis denda pembatalan: Rusak, Batal, Hangus. | P523 | Ya — ✅ dikonfirmasi live: 3 baris persis (Rusak, Batal, Hangus) |
| REQ-032 | Masing-masing jenis denda punya "Trigger By" pemberlakuannya. | P524 | Ya — ✅ kolom "Trigger By" ada di tabel |
| REQ-033 | Jenis denda pembatalan baru **hanya bisa ditambahkan lewat backend (PGR)**, bukan dari UI operator. | P525 | Ya (negatif) — ✅ dikonfirmasi tidak ada tombol "Tambah Denda" di layar, hanya "Setting" per baris |
| REQ-034 | Denda "Rusak": trigger setelah cetak e-tiket, sesuai range waktu yang disetting. | P526–P527 | Ya — field range waktu ada di form Setting; efek trigger sungguhan diuji lintas modul (Cetak Tiket) |
| REQ-035 | Denda "Rusak" bisa disetting dalam Rupiah atau persentase (dihitung dari harga tiket saja). | P528 | Ya — ✅ dikonfirmasi live: select `pilihan_denda_edit` opsi Rupiah/Persentase |
| REQ-036 | Jika pembatalan dilakukan sebelum cetak e-tiket, denda "Rusak" yang berlaku = Rp 0. | P529 | Sebagian — ✅ catatan ini muncul tertulis di modal Setting ("*) Denda pembatalan tiket agen sebelum cetak tiket : Rp. 0"); efek sungguhan perlu skenario pembatalan lintas modul |
| REQ-037 | Denda "Batal": trigger sebelum kapal berangkat, sesuai range waktu yang disetting. | P530–P531 | Ya — field ada di form Setting |
| REQ-038 | Denda "Batal" bisa Rupiah atau persentase dari harga tiket. | P532 | Ya |
| REQ-039 | Jika range waktu "Batal" < range waktu "Hangus" → Simpan gagal + alert "Range waktu tidak boleh kurang dari denda Hangus". | P533 | Ya, TAPI MENULIS SETTING TENANT — butuh izin eksplisit user sebelum dieksekusi (lihat "Catatan risiko" di atas) |
| REQ-040 | Input persentase tidak boleh lebih dari 100%. | P534 | Ya, sama catatan seperti REQ-039 |
| REQ-041 | Denda "Hangus": trigger sebelum kapal berangkat, sesuai range waktu yang disetting. | P535–P536 | Ya — field ada, nilai default terlihat live (6 Jam) |
| REQ-042 | Denda "Hangus" **tidak bisa diubah-ubah**; default persentase 100%. | P537 | Ya — ✅ nilai live = 100%; perlu verifikasi lanjutan apakah field `jumlah_denda_edit` benar-benar terkunci (disabled) saat Setting dibuka — belum dipastikan saat harvest |
| REQ-043 | Jika waktu "Hangus" > range waktu "Batal" → Simpan gagal + alert "Range waktu tidak boleh lebih dari denda Batal". | P538 | Ya, sama catatan seperti REQ-039 (menulis setting tenant) |
| REQ-044 | Potongan denda "Hangus" diambil 100% dari harga tiket. | P539 | Sebagian — verifikasi nilai sungguhan perlu skenario pembatalan lintas modul |
| REQ-045 | **Hanya Operator Pusat yang bisa setting Denda Pembatalan; Cabang hanya punya akses lihat (view), meskipun diberi hak akses setting.** | P540 | Ya — ✅ **SUDAH DIVERIFIKASI LIVE 27 Sep 2026** pada Pusat (modal Setting terbuka, field terisi) dan Cabang (tombol "Setting" tampil dengan tooltip "Hanya bisa dilakukan oleh kantor pusat", klik tidak membuka modal apa pun) |
| REQ-046 | Operator Pusat & Cabang bisa menambahkan Informasi di Master ini. | P542 | Ya — dikonfirmasi pola akses Cabang sama dengan Pusat untuk submodul lain (lihat AC-13); Informasi belum sempat dicek spesifik untuk Cabang saat harvest (daftar Pusat kosong tanpa data) |
| REQ-047 | Informasi yang dibuat di Master ini akan ditampilkan di sisi Agen pada menu DASHBOARD. | P543 | Tidak di OP-11 — cross-module, perlu verifikasi lanjutan di portal Agen |
| REQ-048 | Judul Informasi maksimal 100 karakter; jika melebihi, muncul alert "Jumlah karakter melebihi batas karakter". | P544 | Ya — ✅ `maxlength="100"` dikonfirmasi live pada input Judul; lihat FND-M-02 soal keterjangkauan alert ini |
| REQ-049 | Tanggal pada datepicker "Berlaku Sampai" default-nya tanggal hari ini. | P545 | Ya |
| REQ-050 | Isi Informasi maksimal 350 karakter, pola alert sama seperti Judul. | P546 | Ya — ✅ `maxlength="350"` dikonfirmasi live pada textarea Isi Informasi; lihat FND-M-02 |
| REQ-051 | Jika Pusat yang membuat informasi → tampil di Dashboard SEMUA agen dari seluruh cabang. | P547 | Tidak di OP-11 — cross-module (Dashboard Agen) |
| REQ-052 | Jika Cabang yang membuat informasi → tampil di Dashboard agen SE-KOTA cabang tersebut saja (contoh: Cabang Surabaya → agen Surabaya). | P548–P549 | Tidak di OP-11 — cross-module (Dashboard Agen) |
| REQ-053 | Tanggal Edit diambil dari waktu operator Pusat/Cabang mengubah data informasi terkait. | P550 | Ya — field tanggal update di daftar/detail, verifikasi setelah edit |
| REQ-054 | "User Buat" diambil dari nama user yang membuat informasi (dari Pusat atau Cabang). | P551 | Ya — field di daftar/detail |

## VAL — validasi form (sumber UI, dilengkapi hasil harvest 27 September 2026)

| ID | Validasi | Sumber | Catatan |
|---|---|---|---|
| VAL-001 | Tambah Kelas: field "Nama Kelas" (`nama[]`/`nama0`) wajib (`required` HTML pada baris pertama), placeholder "Masukkan Kelas". | UI | Simpan kosong **tidak menampilkan pesan apa pun** dan tidak mengirim request (FND-M-01) |
| VAL-002 | Tambah Golongan: Jenis Tiket (`select2` `#jenis1`, opsi Penumpang/Kendaraan/Bagasi Kendaraan/Bagasi Penumpang), Nama Golongan Tiket, Status Aktif (`#muncul1`, opsi Semua Channel/Hanya Cabang) wajib. | UI | Sama pola FND-M-01 (silent) |
| VAL-003 | Tambah Kapal: label bertanda `*` pada Nama Kapal, Call Sign, Kapasitas Penumpang, Kelas Yang Tersedia — namun atribut `required` pada elemen DOM = `false` untuk semuanya. | UI | Ketidaksesuaian tanda visual vs atribut HTML — kandidat FND (lihat FND-M-03) |
| VAL-004 | Tambah Trayek: Nama Trayek, Pilih Pelabuhan, Pelabuhan Dipilih, Pelabuhan Asal, Pelabuhan Tujuan wajib (`*`); Konsumsi Penumpang tidak bertanda `*`, sesuai P495. | UI + P495 | |
| VAL-005 | Tambah Harga: harus pilih Trayek dan Rute dulu (baru tombol "Tambahkan" memunculkan baris input Jenis Tiket/Golongan/Kelas/Harga/Mulai Berlaku/Kondisi Kendaraan). | UI | Alur 2 langkah; Simpan kosong pada langkah kedua juga silent (FND-M-01) |
| VAL-006 | Tambah Tarif Pass Pelabuhan: alur 2 langkah identik dengan Tambah Harga (pilih Trayek → Rute → Tambahkan). | UI | |
| VAL-007 | Tambah Crew: 11 field bertanda `*` (Nama, Jenis Kelamin, Tanggal Lahir, No. Buku Pelaut, Tgl Berakhir Buku Pelaut, Kode Pelaut, Jabatan, No. PKL, Tanggal Sign On, Sertifikat Ijazah Pelaut, No. Sertifikat); Kebangsaan tidak bertanda `*`. | UI | Simpan kosong silent (FND-M-01) |
| VAL-008 | Tambah Informasi: Judul (`maxlength=100`), Berlaku Sampai (date picker, default hari ini), Isi Informasi (`maxlength=350`) wajib. | UI + P544–P546 | Simpan kosong silent (FND-M-01); alert batas karakter kandidat unreachable via keyboard biasa (FND-M-02) |
| VAL-009 | Setting Denda Pembatalan: Range Waktu (angka + satuan Jam), Jumlah Denda (angka, Rupiah/Persentase); Persentase harus ≤100% (P534); range Batal harus ≥ range Hangus (P533/P538). | UI + P533–P534/P538 | Belum diverifikasi live (menulis setting tenant — butuh izin eksplisit, lihat "Catatan risiko") |
| VAL-010 | Filter daftar (semua submodul: Kelas/Golongan/Kapal/Trayek/Harga/Tarif Pass/Asuransi/Crew/Informasi) menyaring baris sesuai input; Reset mengembalikan daftar penuh. | UI | Tidak ada rule tertulis, pola sama dengan OP-21 VAL-009 |

## AC — kriteria penerimaan utama

| ID | Kriteria | REQ |
|---|---|---|
| AC-01 | Kelas `AUTOTEST-<tgl>-` yang sudah dipakai di Master Kapal ditolak saat dihapus (SweetAlert "Data Digunakan di Master Kapal"). | REQ-001 |
| AC-02 | Golongan `AUTOTEST-<tgl>-` yang sudah dipakai di Master Kapal ditolak saat dihapus. | REQ-004 |
| AC-03 | Status Aktif Golongan/Kelas tiket (Semua Channel vs Hanya Cabang) tersimpan sesuai pilihan dan konsisten di kolom daftar. | REQ-005 |
| AC-04 | Edit dan Hapus Trayek `AUTOTEST-<tgl>-` yang sudah punya harga ditolak. | REQ-014, REQ-015 |
| AC-05 | Tambah Harga dengan kombinasi (Golongan Tiket, Mulai Berlaku, Kondisi Kendaraan) duplikat pada trayek/rute yang sama ditandai/gagal sesuai pola aplikasi. | REQ-018, REQ-019 |
| AC-06 | Hapus Harga/Tarif Pass yang sudah dipakai di Kuota & Jadwal ditolak; Riwayat Harga (`/partner/historyharga/<id>`) mencatat perubahan tanggal mulai berlaku dan penghapusan. | REQ-022, REQ-023, REQ-026 |
| AC-07 | **Denda Pembatalan: Operator Pusat dapat membuka dan mengubah Setting; Operator Cabang HANYA melihat (tombol Setting tampil tapi tidak dapat dibuka, tooltip "Hanya bisa dilakukan oleh kantor pusat").** | REQ-045 |
| AC-08 | Tidak ada tombol "Tambah" jenis Denda Pembatalan baru di UI operator manapun (Pusat/Cabang). | REQ-033 |
| AC-09 | Judul Informasi >100 karakter dan Isi Informasi >350 karakter ditolak dengan pesan/alert sesuai P544/P546 — verifikasi lewat event `paste`, bukan hanya keystroke satu-satu (lihat FND-M-02). | REQ-048, REQ-050 |
| AC-10 | Master Kelas/Golongan/Kapal/Trayek/Harga/Tarif Pass/Asuransi/Crew/Informasi dapat diakses (lihat DAN tambah) oleh Operator Cabang, bukan hanya Pusat — dikonfirmasi live untuk Kelas; submodul lain dikonfirmasi via eksplorasi umum 26 September 2026 (`explore/module-map.md`). | — (bukan REQ eksplisit rule, baseline akses) |
| AC-11 | Simpan pada form Tambah manapun (Kelas/Golongan/Kapal/Trayek/Harga/Crew/Informasi) dengan field kosong TIDAK menyimpan data (tidak ada request POST/AJAX terkirim) — kriteria minimum keamanan data meski pesan error tidak tampil. | REQ-002, REQ-009, REQ-011, REQ-017, REQ-028, VAL-001..008 |

## Ketidakjelasan (tidak diselesaikan dengan asumsi)

| ID | Hal | Dampak |
|---|---|---|
| Q-M-01 | P485: "Tambah Golongan Kendaraan, untuk menambahkan jenis tiket kendaraan, hanya field kategori dan Kategori yg boleh di isi" — kalimat sumber mengulang kata "kategori/Kategori", maknanya tidak jelas field mana persisnya (kemungkinan: Golongan Kendaraan + Bonus Tiket, atau Golongan Kendaraan + Kondisi Kendaraan). | Skenario terkait REQ-003 harus memakai matching longgar (observasi field mana yang benar-benar aktif/wajib saat Jenis Tiket = Kendaraan dipilih), bukan menebak field spesifik dari kalimat sumber. |
| Q-M-02 | P503: "Tambah Harga, cuma bisa ditambahkan ketika harga belum pernah ditambahkan" — belum jelas apakah ini per kombinasi (rute + golongan + tanggal) atau per rute secara keseluruhan (tombol "Tambah Harga" tetap ada dan bisa dipakai berulang untuk rute yang sama pada harvest 27 Sep 2026, hanya validasi duplikat kombinasi P505 yang tampak berlaku). | REQ-016 diuji sebagai "penolakan kombinasi duplikat" (mengacu P505), bukan "penolakan tambah harga kedua untuk rute yang sama". |
| Q-M-03 | P508 (Edit Harga: hapus baris tetap terhapus meski klik Batal) — sumber sendiri menulis "harus dipastikan lagi", menunjukkan ini catatan ketidakpastian penulis rule, bukan pernyataan aturan final. Sudah dicatat sebagai Q-08 di `docs/module-map-from-rules.md`. | Skenario terkait REQ-021 WAJIB memakai data Harga uji yang aman dihapus (bukan data produksi), dan hasil pengujian dicatat sebagai `bug-candidate` bila ternyata true, bukan `failed` langsung — perilaku sesuai dugaan sumber sendiri, bukan pasti salah desain. |
| Q-M-04 | P540 menyebut Cabang "hanya punya akses view saja (meskipun diberi akses untuk setting denda pembatalan)" — frasa ini mengisyaratkan ada skenario di mana Cabang *diberi* hak akses setting tapi tetap dibatasi UI. Belum diverifikasi apakah pembatasan ini murni client-side (tooltip disabled) atau juga ditegakkan di server (mis. request langsung ke endpoint `do_edit_denda_pembatalan` dari Cabang). | Harvest 27 Sep 2026 hanya menguji jalur UI (klik tombol Setting Cabang tidak membuka modal). Pengujian penetrasi endpoint langsung di luar cakupan automation Playwright berbasis UI dan TIDAK dilakukan (berisiko menulis setting tenant tanpa izin). |
| Q-M-05 | REQ-047/051/052 (P543, P547–P549) tentang tampilan Informasi di Dashboard Agen adalah cross-module ke portal Agen (`/agen`), di luar cakupan OP-11 (portal Operator). Belum ditentukan apakah modul ini akan memverifikasi efeknya atau cukup mencatat sebagai referensi. | Skenario OP-11 hanya menguji sampai tahap "Informasi tersimpan dengan atribut Pusat/Cabang yang benar"; efek tampil di Agen dicatat sebagai catatan silang, bukan AC wajib modul ini kecuali user meminta perluasan cakupan ke portal Agen. |

## Temuan harvest awal (kandidat FND — bukan kode resmi, deskriptif saja)

- **FND-M-01 (paling signifikan, berulang di ≥7 layar)** — Tombol Simpan pada form Tambah (Kelas,
  Golongan, Kapal, Trayek, Harga, Crew, Informasi) yang diklik dengan SEMUA field kosong tidak
  menampilkan pesan/popover/alert apa pun, dan **tidak ada request POST/AJAX yang terkirim**
  (dikonfirmasi via `browser_network_requests` untuk Kelas dan Golongan). Berbeda dari pola modul
  OP-21 (Pengaturan User) yang memakai popover `zemPopover` untuk validasi field kosong. Tombol
  tampak "diam" bagi pengguna — berpotensi gap desain (UX), bukan kegagalan penyimpanan data,
  karena data memang tidak tersimpan.
- **FND-M-02** — Field Judul Informasi (`maxlength=100`) dan Isi Informasi (`maxlength=350`)
  memakai atribut HTML `maxlength`, yang mencegah pengetikan karakter melebihi batas sejak awal.
  Alert "Jumlah karakter melebihi batas karakter" yang disebut P544/P546 kemungkinan hanya bisa
  dipicu lewat event `paste` teks panjang (yang tidak dibatasi `maxlength` di sebagian browser)
  atau memang tidak pernah terpicu lewat jalur UI normal — perlu diverifikasi khusus saat
  scenario-writing, bukan diasumsikan sebagai bug.
- **FND-M-03** — Form Tambah Kapal menampilkan label bertanda `*` (wajib) pada Nama Kapal, Call
  Sign, Kapasitas Penumpang, dan Kelas, tetapi atribut `required` pada elemen input/select-nya
  semua `false`. Tidak konsisten dengan pola Tambah Kelas/Golongan/Crew yang memakai atribut
  `required=true` pada elemen sesuai tanda `*`.
  Berkaitan dengan FND-M-01: karena Simpan kosong silent, tanda `*` di sini kemungkinan hanya
  dekoratif.
- **FND-M-04** — Tombol "Lihat" (ikon mata, `btn-viewnya`) pada baris Master Trayek dan Master
  Crew membuka panel *collapse* inline yang **kosong** (hanya garis pembatas, tanpa detail
  pelabuhan/rute untuk Trayek atau identitas crew untuk Crew), dikonfirmasi pada 2 baris Trayek
  berbeda dan 1 baris Crew. Pola berulang di 2 submodul berbeda mengindikasikan ini bukan masalah
  data satu baris, melainkan kandidat gap desain/bug pada komponen "Lihat" itu sendiri.
- **FND-M-05** — Ditemukan baris data Trayek "asdfghdaf" (Balikpapan, Parepare, Taipa, dibuat
  25 Sep 2026) di lingkungan — pola nama mengindikasikan data uji manual/otomatis dari sesi
  sebelumnya yang tertinggal (bukan dibuat run dokumen ini). Sesuai `docs/agent-guide.md`, data
  ini **tidak boleh dihapus** oleh run mendatang kecuali dikonfirmasi dibuat oleh run itu sendiri;
  dicatat di sini sebagai observasi kebersihan lingkungan, bukan tindakan.
- **FND-M-06** — Sama seperti temuan OP-21 (FND-05), ditemukan `id` HTML duplikat lintas baris
  tabel pada beberapa daftar Master (mis. `select_kapal`/`delete_kapal` dipakai ulang di Master
  Trayek untuk tombol Edit/Hapus Trayek, bukan hanya Master Kapal) — catatan otomasi/a11y, bukan
  bug bisnis; berdampak pada strategi selector (harus pakai scoping per-baris, bukan `#id` global).

## Perbedaan hak Pusat vs Cabang (ringkasan eksplisit)

| Submodul | Pusat | Cabang |
|---|---|---|
| Kelas, Golongan, Kapal, Trayek, Harga, Tarif Pass Pelabuhan, Asuransi, Crew | Lihat + Tambah + Edit + Hapus (dengan syarat P482/486/500/501/509/516) | **Sama seperti Pusat** — dikonfirmasi live (Kelas) dan via eksplorasi umum 26 Sep 2026 (submodul lain); rule tidak menyatakan pembatasan Cabang di submodul ini |
| Informasi | Lihat + Tambah + Edit + Hapus; info yang dibuat tampil ke SEMUA agen (P547) | Lihat + Tambah (P542); info yang dibuat hanya tampil ke agen SE-KOTA cabang (P548–P549) — perbedaan pada **cakupan visibilitas data**, bukan pada hak akses CRUD |
| **Denda Pembatalan** | **Lihat + Setting (ubah nilai)** | **HANYA Lihat — tombol Setting tampil tapi diblokir client-side (tooltip "Hanya bisa dilakukan oleh kantor pusat"), TIDAK bisa membuka form Setting (P540, ✅ diverifikasi live)** |

Baris Denda Pembatalan adalah **satu-satunya** pembatasan hak Pusat vs Cabang yang dinyatakan
eksplisit di P480–P551, dan sudah diverifikasi berfungsi sesuai dokumen pada harvest 27 September
2026 — bukan kandidat bug.
