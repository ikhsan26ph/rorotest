# OP-12 Kuota dan Jadwal — UI Inventory

Hasil eksplorasi READ-ONLY 27 September 2026 (UI v1.5.2), Operator Pusat (akun #2) sebagai akun
utama, Operator Cabang Pare-Pare (akun #3, Sub User Cabang) untuk verifikasi akses/isolasi data
(REQ-001/002) dan pembanding dropdown Trayek. Tidak ada spec `/harvest-selectors` khusus modul ini
yang dijalankan — selector dikumpulkan langsung lewat `browser_evaluate` (Playwright MCP) atas DOM
tiap layar dan disalin ke tabel di bawah, mengikuti pola `scenario/master/master_ui-inventory.md`.
Elemen bersama login/header/sidebar mengikuti `shared/selector-map-partner-common.md` (SCR-00 tidak
diulang detailnya di sini).

**TIDAK ADA data ditulis/disimpan selama eksplorasi ini** — sesuai instruksi tugas dan
`docs/workflows/harvest-selectors.md`: form Tambah dibuka dan diisi field pilihan (Trayek/Kapal)
untuk memetakan field turunannya, tapi tombol Simpan/Selesai TIDAK pernah diklik; modal "Input
Crew List" dibuka lalu ditutup dengan Batal; dropdown Status Jadwal ("Jadwal Tutup") dan tombol
"Kirim ke Pelindo" hanya diamati keberadaannya, tidak pernah dipilih/diklik pada jadwal produksi
nyata.

Sidebar **KUOTA & JADWAL** adalah link tunggal (bukan grup collapsible seperti MASTER/PENGATURAN
USER) → `/partner/masterjadwal`, tampil identik pada **Operator Pusat maupun Operator Cabang
Pare-Pare** (dikonfirmasi live, lihat bagian "Perbedaan akses Pusat vs Cabang").

Modul ini tidak memakai route terpisah untuk Edit — tombol Edit pada Daftar melakukan AJAX
in-place swap konten halaman menjadi "Edit Kuota & Jadwal" TANPA mengubah URL browser (tetap
`/partner/masterjadwal`); breadcrumb saja yang berubah jadi "Edit Jadwal". Tambah Kuota & Jadwal
sebaliknya punya route sendiri (`/partner/tambahjadwal`).

Struktur form Tambah maupun Edit sama-sama 3 tab: **Kuota / Jadwal / crew list** (label tab persis
demikian, tidak konsisten kapitalisasinya antar versi — Tambah pakai huruf besar "KUOTA/JADWAL/CREW
LIST", Edit pakai "Kuota/Jadwal/crew list"). Ketiga tab bisa **diklik bebas tanpa terkunci** meski
data tahap sebelumnya belum di-Simpan (lihat temuan FND di bawah) — tapi elemen interaktif tab
berikutnya (tombol "Masukkan Crew", tombol "Selesai") tetap **tidak aktif/tidak tersedia** sampai
tahap sebelumnya benar-benar tersimpan di backend, sehingga wizard REQ-007/011 secara EFEKTIF tetap
bertahap walau navigasi tab itu sendiri tidak digembok.

## Layar (SCR)

| SCR | Layar | Route | Elemen utama (ringkas) |
|---|---|---|---|
| SCR-00 | Login Operator | `/partner` | Sama seperti Master/OP-21 — `#username`, `#password`, tombol Login → redirect `/partner/profil` (Pusat) / `/partner/profilsubuser` (Sub User Cabang) |
| SCR-01 | Daftar Kuota & Jadwal | `/partner/masterjadwal` | Tombol `#btn-filter` (Filter, toggle panel filter: `#Tanggal_Buat`, `#Nama_Trayek`, select `#kapal`(Nama Kapal), `#Nomor_Voyage`, tombol Reset `.reset-master`, tombol Filter submit), link **"Buat Jadwal"** (`a.btn-buat-trayek` href `/partner/tambahjadwal`) → SCR-02, dropdown jumlah baris `#valuelimit` (10/20/50/100); tabel (Tanggal Buat, Trayek, Nama Kapal, Nomor Voyage, Kapasitas, Aksi) + baris tambahan per trayek "Rute yang dilewati trayek ini" (badge tiap pelabuhan, SELALU tampil, bukan collapse); per baris 3 aksi: Lihat (`a.btn-viewnya`, data-toggle="collapse" data-target=".col<id>" — ⚑ panel collapse KOSONG, lihat FND-KJ-01, pola sama Master FND-M-04), Edit (`a.btn-edit.edit` id `edit<id>`, data-idjadwal/data-idkapal/data-idtrayek — AJAX in-place swap ke SCR-06/07/08, TANPA ganti URL), Hapus (`a.btn-delete.delete-jadwal` title "Hapus Kuota & Jadwal", SweetAlert diasumsikan, tidak diuji). Pusat: 2242 data (tidak difilter kota). Cabang Pare-Pare: 571 data, semua baris trayek berasal-kota Pare-Pare (mis. "PAREPARE - BALIKPAPAN") — konsisten REQ-001/002 |
| SCR-02 | Buat Kuota & Jadwal — Langkah 1 (pilih Trayek/Kapal) | `/partner/tambahjadwal` | `select#trayek`(Trayek *, 24 opsi trayek yang SUDAH punya Tarif Pass — konsisten REQ-004, identik utk Pusat & Cabang, TIDAK dibatasi kota cabang — lihat FND-KJ-03), `select#kapal`(Kapal *, opsi = SEMUA Master Kapal terlepas trayek), `#kode_kapal`(Call Sign, disabled, auto), `#nomor_voyage`(Nomor Voyage *, text bebas), `#kapasitas`(Kapasitas Penumpang, disabled, auto "Sesuai Kapal" — terisi dari Kapal, bukan trayek), info statis "Rute yang dilewati trayek ini" (badge pelabuhan). **Tidak ada elemen HTML `required` sama sekali di form ini** (dicek `[required]` count=0) — kalau ada validasi wajib isi, kemungkinan JS custom atau tidak ada sama sekali (pola FND-M-01 Master), belum diuji krn tidak submit. Setelah Trayek+Kapal dipilih, 3 tab (KUOTA/JADWAL/CREW LIST) langsung muncul di bawah tanpa perlu tombol "Lanjut" terpisah |
| SCR-03 | Buat Kuota & Jadwal — tab KUOTA | dalam SCR-02 | 3 blok tabel: **Distribusi Kuota Penumpang** (kolom Kelas, Kuota Internal `input#dist_penumpang<id>`, Kuota Eksternal `input#dist_penumpang_eks<id>`, kolom bonus disabled "Tiket bonus dari kuota kendaraan" — kelas berasal dari Kelas Kapal yg dipilih, REQ-018); **Distribusi Kuota Kendaraan** (kolom Golongan, Kuota Internal `input#dist_kendaraan<id>.dist_kendaraan`, Kuota Eksternal `input#dist_kendaraan_eks<id>.dist_kendaraan_eks`, Bonus Tiket `input.bonus_tiket` placeholder "Jumlah Tiket" — golongan berasal dari Harga+TarifPass trayek terpilih, REQ-017, BERBEDA SET per trayek: Parepare-Balikpapan pakai kode "(II-A)/(III-A)/…", Bakauheni-Merak pakai "Golongan I/II/…IX"); **Distribusi Kuota Bagasi** (Kuota Internal `input#dist_bagasi<id>`, Kuota Eksternal `input#dist_bagasi_eks<id>`); tombol "Simpan" (TIDAK diklik) dan "Batal" |
| SCR-04 | Buat Kuota & Jadwal — tab JADWAL | dalam SCR-02 | Tabel "Jadwal Rute Yang Dijual Dari Satu Trayek" (kolom **Status Jadwal** — `select` opsi value `Tampil`:"Jadwal Tampil" (default) / `Tutup`:"Jadwal Tutup" — **INI mekanisme "Tutup Jadwal", menjawab Q-KJ-02**; Pelabuhan Asal disabled; **Waktu Berangkat** `input[name="tgl_etd"]` id `tgl_etd<n>` placeholder "Tentukan Waktu Berangkat" (datepicker); Pelabuhan Tujuan disabled; **Waktu Tiba** `input[name="tgl_eta"]` id `tgl_eta<n>` placeholder "Tentukan Waktu Tiba"); satu baris per LEG trayek (trayek 2-pelabuhan yang dicoba pada sesi ini hanya render 1 baris — trayek multi-pelabuhan ≥3 port TIDAK ditemukan di antara 24 opsi trayek yang dicoba/diperiksa namanya, REQ-008 belum bisa diverifikasi visual dgn data nyata, lihat catatan risiko); tombol Simpan/Batal. **Tombol "Kirim ke Pelindo" (`button.btn-kirim`, ikon fa-paper-plane) TIDAK ditemukan di tab ini pada tahap Tambah** (baru mungkin muncul di Edit, lihat SCR-07 & FND-KJ-02) |
| SCR-05 | Buat Kuota & Jadwal — tab CREW LIST | dalam SCR-02 | Teks peringatan "Pastikan Crew List sudah terisi semua"; daftar port trayek TANPA tombol "Masukkan Crew" (berbeda dari Edit/SCR-08 — tombol baru muncul setelah Kuota+Jadwal tersimpan, konsisten wizard REQ-007/011); tombol **"Selesai" berstatus `disabled`** (atribut HTML disabled, dikonfirmasi via DOM) — **verifikasi VAL-004/REQ-012 langsung: disabled, bukan alert** |
| SCR-06 | Edit Kuota & Jadwal — tab Kuota | dalam SCR-01 (AJAX swap, URL tetap `/partner/masterjadwal`) | Sama struktur SCR-03 tapi field atas (Trayek, Kapal, Kode Kapal, Kapasitas Penumpang) disabled+terisi; Nomor Voyage TETAP EDITABLE (tidak disabled); tabel kuota terisi data existing. **Contoh jadwal AUTOTEST-20260925-PPBPN-01 (id 2293, Parepare-Balikpapan)**: golongan "Kendaraan Kecil (III-A)" & "Mobil Mewah (III-B)" — field Bonus Tiket (`input.bonus_tiket`, placeholder "Jumlah tiket") punya atribut **`readonly` terkonfirmasi via DOM** (value "1", TIDAK bisa diketik) → **VAL-006 TERVERIFIKASI: field terkunci, sesuai REQ-016**. Dibandingkan dgn **jadwal id 466 (Surabaya-Balikpapan)**: golongan III-A di rute ini menampilkan **"Tidak Tersedia"** (bukan field angka sama sekali) untuk Bonus Tiket — beda dari Parepare-Balikpapan. Dibandingkan lagi dgn **trayek Bakauheni-Merak** (dicoba di form Tambah, golongan "Golongan I/II/…"): field Bonus Tiket **EDITABLE, TIDAK readonly** (dikonfirmasi DOM: `readonly:false`) dgn nilai default terisi otomatis (1/2 tergantung golongan) — **menjawab Q-KJ-03 sebagian**: nilai default bonus per golongan tampil di SEMUA trayek (bukan eksklusif), tapi **KUNCI (readonly)** khusus ditemukan pada kombinasi golongan III-A/III-B + trayek Parepare-Balikpapan; rute Surabaya-Balikpapan sampel tidak menunjukkan field sama sekali (kemungkinan golongan tsb tidak dikonfigurasi utk rute itu, bukan soal kunci) |
| SCR-07 | Edit Kuota & Jadwal — tab Jadwal | dalam SCR-01 | Sama struktur SCR-04, field Waktu Berangkat/Tiba terisi data existing (format "DD/MM/YYYY HH:mm WITA"), select Status Jadwal terisi "Jadwal Tampil". **Tombol "Kirim ke Pelindo" (`button.btn-kirim`) tidak terlihat/tidak ter-render pada tab aktif** untuk 2 sampel yang dicek (jadwal 2293 Parepare-Balikpapan DAN jadwal 466 Surabaya-Balikpapan) — lihat FND-KJ-02 untuk detail kejanggalan (elemen `.btn-kirim` DITEMUKAN di DOM halaman tapi terikat ke `idnya` jadwal LAIN yang sedang tidak aktif/tidak ditampilkan, bukan ke jadwal yang sedang dibuka) |
| SCR-08 | Edit Kuota & Jadwal — tab crew list | dalam SCR-01 | Peringatan "Edit Crew List akan merubah crew list di pelabuhan selanjutnya"; per port: tombol **"Masukkan Crew"** (`button`, teks persis) → membuka SCR-09; tombol "Selesai" (aktif/tidak disabled pada jadwal yang sudah punya crew) |
| SCR-09 | Modal "INPUT CREW LIST" | dari SCR-08, tombol "Masukkan Crew" | Dialog (`role=dialog`, judul konten "INPUT CREW LIST"); 2 tabel info readonly (Nama Kapal, Kode Kapal/Call Sign, Nomor Voyage, Kapasitas Penumpang \| Operator Kapal, Pelabuhan Keberangkatan, Pelabuhan Selanjutnya, Waktu Berangkat); tabel crew dinamis: kolom No, **Nama Awak Kapal** (select2 "Pilih Awak kapal", opsi dari Master Crew), Jenis Kelamin (L/P, auto terisi setelah pilih crew), Tgl Lahir, Kebangsaan, No. Buku Pelaut, Tgl Berakhir Buku Pelaut, Jabatan, Kode Pelaut, No. PKL, Tgl Sign On, Sertifikat Ijazah Pelaut, No. Sertifikat Ijazah Pelaut (semua auto-fill dari data Master Crew setelah baris dipilih, kemungkinan readonly — belum dicek detail per kolom); tombol **"Tambah Baris Input"**; tombol Batal (dipakai untuk menutup tanpa simpan) / Simpan (TIDAK diklik) |

## Pesan (M-xx) — dari perilaku aplikasi (bukan dari rule, kecuali disebutkan)

| ID | Layar | Pemicu | Pesan / bentuk |
|---|---|---|---|
| M-01 | SCR-04/07 | Pilihan Status Jadwal | Native `<select>` 2 opsi: "Jadwal Tampil" (value `Tampil`, default) / "Jadwal Tutup" (value `Tutup`) — bukan alert/popover, murni pilihan form. Efek "tidak tampil di halaman pesan" (REQ-010) belum diverifikasi lintas modul (UM-03/OP-13) pada sesi ini |
| M-02 | SCR-05 | Tab Crew List dibuka sebelum crew diisi (Tambah, jadwal belum tersimpan) | Teks statis "Pastikan Crew List sudah terisi semua" + tombol "Selesai" berstatus `disabled` (atribut HTML, bukan alert) — **VAL-004 terverifikasi: disabled**, bukan pesan popover/alert |
| M-03 | SCR-08 | Tab Crew List pada Edit (jadwal existing) | Teks statis "Edit Crew List akan merubah crew list di pelabuhan selanjutnya" — peringatan efek samping, bukan validasi |
| M-04 | SCR-01 | Klik "Lihat" (ikon mata) pada baris jadwal | Panel collapse `.col<id>` berubah `collapse show` tapi **KOSONG** (hanya elemen divider visual) — identik pola FND-M-04 Master (Trayek/Crew), lihat FND-KJ-01 |
| M-05 | ANY | Route diakses tanpa hak akses / id tidak valid | Pola umum aplikasi: redirect `/partner/dashboard` + `.alert-danger` "Anda Tidak Memiliki Akses Ke Halaman Tersebut" (belum diuji ulang khusus modul ini, mengacu `shared/selector-map-partner-common.md`) |
| M-06 | SCR-02/03/04 | *(belum diverifikasi — TIDAK disubmit)* Simpan dengan field kosong (Trayek/Kapal/Nomor Voyage/kuota) | Tidak ada atribut HTML `required` pada field manapun (dicek langsung via DOM, count=0) → validasi wajib-isi (jika ada) kemungkinan JS custom (popover, pola OP-21) atau TIDAK ADA sama sekali (pola silent FND-M-01 Master) — **VAL-001/VAL-002 TETAP PERLU VERIFIKASI**, sengaja tidak diuji krn akan menyimpan Kuota/Jadwal nyata |
| M-07 | SCR-04/07 | *(belum diverifikasi)* Tanggal rute kedua ≤ tanggal rute pertama pada trayek multi-port | Tidak ditemukan trayek ≥3 pelabuhan di antara 24 opsi yang tersedia saat sesi ini → **VAL-003 TETAP PERLU VERIFIKASI**, butuh trayek uji multi-rute (lihat catatan data) |

## Temuan (FND-KJ-xx) — kandidat bug/gap, belum verdict

| ID | Layar | Temuan | Rujukan | Status |
|---|---|---|---|---|
| FND-KJ-01 | SCR-01 | Tombol "Lihat" (ikon mata, tooltip "Lihat Kuota & Jadwal") men-toggle panel collapse yang KOSONG (tidak ada data ditampilkan) — pola identik FND-M-04 pada Master Trayek/Crew. Kemungkinan kode collapse memang tidak dipakai/tidak diisi konten, atau ada bug render. | Pola sama FND-M-04 `master_ui-inventory.md` | kandidat bug UI, belum diuji lebih lanjut |
| FND-KJ-02 | SCR-07 | Tombol "Kirim ke Pelindo" (`button.btn-kirim`, integrasi API eksternal Pelindo) ADA di DOM halaman Edit. **KEPUTUSAN USER 27 Sep 2026: TIDAK PERLU DIUJI** — cukup dicatat sebagai fitur yang ada, jangan buat skenario verifikasi kemunculan/klik. | P555, REQ-003 | DITUTUP — tidak dijadikan skenario |
| FND-KJ-03 | SCR-02 | Dropdown Trayek pada "Buat Kuota & Jadwal" menampilkan daftar trayek yang SAMA (24 opsi) untuk akun Pusat maupun akun Cabang Pare-Pare — tidak difilter kota. **KEPUTUSAN USER 27 Sep 2026: MEMANG DESAIN SENGAJA, bukan bug.** | REQ-001, REQ-002, REQ-004 | DITUTUP — jadikan skenario positif (opsi Cabang = opsi Pusat) |
| FND-KJ-04 | SCR-02/03/04 | Banyak elemen form (checkbox/hidden/select Status Jadwal, field `dist_*`) tidak punya atribut `name` HTML (kosong) — hanya `id`. Payload submit kemungkinan dirakit manual via JS (bukan form-serialize native), konsisten dgn Master/OP-21 tapi berarti selector `name` tidak bisa diandalkan utk elemen ini, harus pakai `id`/class. | — | catatan automasi, bukan bug bisnis |
| FND-KJ-05 | SCR-02 | Beberapa input non-select2 (mis. `#nomor_voyage`, `#kapasitas`, `#kode_kapal`) punya `name="trayek"` yang salah/duplikat (kemungkinan sisa template copy-paste) — tidak mempengaruhi fungsi krn app tidak pakai native form-submit, tapi bisa membingungkan automasi berbasis `name`. | — | kosmetik/kode, bukan bug bisnis |

## Perbedaan akses Pusat vs Cabang (terverifikasi live 27 September 2026)

| Aspek | Pusat | Cabang Pare-Pare (Sub User) |
|---|---|---|
| Akses menu KUOTA & JADWAL | Tampil, `/partner/masterjadwal` | ✅ Sama — tampil, route identik |
| Jumlah data Daftar Kuota & Jadwal | 2242 (semua kota) | 571 (terfilter — hanya trayek berasal-kota Pare-Pare + kemungkinan buatan Pusat yang match kota, konsisten REQ-001/002) |
| Link "Buat Jadwal" (Tambah) | Tersedia | ✅ Sama — tersedia, form terbuka penuh |
| Dropdown Trayek pada Tambah | 24 opsi (semua trayek ber-Tarif Pass) | ✅ SAMA 24 opsi — TIDAK dibatasi kota cabang (lihat FND-KJ-03) |
| Struktur form Tambah/Edit (tab Kuota/Jadwal/Crew List) | Identik | Identik |

## Data dan temuan yang perlu diperhatikan saat penulisan skenario

- **Jadwal `AUTOTEST-20260925-PPBPN-01` (id 2293, trayek Parepare-Balikpapan, kapal KM. SWARNA
  BAHTERA)** adalah data uji dari sesi OP-13 sebelumnya (SUDAH DIPAKAI transaksi nyata, lihat
  `shared/decisions.md`) — dipakai di sini HANYA untuk membuka halaman Edit (dibaca, tidak
  disimpan perubahan apa pun). JANGAN mengedit/menghapus jadwal ini di skenario OP-12 tanpa
  keperluan eksplisit, karena berstatus data terpakai (Q-KJ-04).
- **Trayek multi-pelabuhan (≥3 port) untuk menguji REQ-008/VAL-003 belum ditemukan** di antara 24
  opsi trayek yang muncul di dropdown Tambah pada sesi ini (semua yang dicoba/diperiksa namanya
  hanya 2 pelabuhan). Sebelum menulis skenario REQ-008, perlu memastikan lebih dulu apakah ada
  trayek uji sendiri yang bisa dibuat di Master Trayek (OP-11) dengan ≥3 pelabuhan, atau mencari
  lebih teliti di 24 opsi yang ada (nama trayek tidak selalu mencerminkan jumlah port).
  Trayek "asdfghdaf" (Balikpapan–Parepare–Taipa) yang dicatat sebagai data tertinggal di
  `master_ui-inventory.md` bisa jadi kandidat, TAPI belum dicek apakah trayek itu sudah punya
  Tarif Pass (syarat REQ-004) sehingga muncul di dropdown ini.
- **VAL-001, VAL-002, VAL-003, VAL-005 tetap belum terverifikasi** karena semuanya butuh aksi
  Simpan/submit sungguhan (yang akan membuat Kuota/Jadwal nyata) — sengaja tidak dilakukan sesuai
  batasan tugas. Rekomendasi: uji ini baru dijalankan pada tahap eksekusi skenario nanti, memakai
  Trayek/Kapal uji milik run ini sendiri (bukan trayek produksi), dengan Nomor Voyage berprefix
  `AUTOTEST-<tanggal>-` — supaya data hasil percobaan validasi (termasuk yang gagal tervalidasi)
  tetap mudah diidentifikasi dan dibersihkan.
- **VAL-004 dan VAL-006 sudah terverifikasi PENUH lewat observasi DOM** (tombol Selesai disabled;
  field Bonus Tiket readonly khusus III-A/III-B Parepare-Balikpapan) — TIDAK perlu diuji ulang
  dengan submit sungguhan, cukup dijadikan assertion langsung di skenario (cek atribut).
- **FND-KJ-02 (Kirim ke Pelindo) — KEPUTUSAN USER 27 Sep 2026: TIDAK PERLU DIUJI.** Integrasi API
  eksternal ke Pelindo, cukup dicatat sebagai fitur yang ada; jangan buat skenario verifikasi
  kemunculan/klik tombol ini.
- **FND-KJ-03 (Trayek dropdown Cabang tidak dibatasi kota) — KEPUTUSAN USER 27 Sep 2026: MEMANG
  DESAIN SENGAJA, bukan bug.** Boleh dijadikan skenario POSITIF (opsi Trayek Cabang identik dengan
  Pusat), bukan skenario negatif/bug-candidate.
