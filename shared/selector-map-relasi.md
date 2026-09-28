# Selector Map — Modul OP-16/OP-17 Daftar Relasi (portal Operator `/partner`)

Disusun dari `scenario/relasi/relasi_ui-inventory.md` (eksplorasi READ-ONLY 27 September 2026,
`browser_evaluate` atas DOM tiap layar + source JS inline — **bukan** hasil `/harvest-selectors`
formal; jalankan skrip itu di kemudian hari bila dibutuhkan sumber selector yang lebih
tervalidasi). Elemen login/header/sidebar/SweetAlert/popover/pagination bersama seluruh portal
Operator ada di `shared/selector-map-partner-common.md` (tidak diulang di sini).

Tidak ada `data-testid` di aplikasi ini. Prioritas selector: id stabil → role+name → css scoping
per-baris → teks (tanpa id, ditandai TIDAK STABIL). Modul ini punya 2 submenu di grup collapsible
**DAFTAR RELASI** (identik struktur pada Pusat maupun Cabang):

```
DAFTAR RELASI
├── Relasi Pelanggan   /partner/pelanggan
└── Relasi Agen        /partner/agen
```

**Pola validasi zemPopover (Bootstrap `.popover-body`) auto-hilang ~1000ms** (`setTimeout`) —
baca popover DI DALAM evaluate/callback yang SAMA dengan `click()`-nya, JANGAN mengecek setelah
await/round-trip terpisah, atau assertion akan SELALU tampak kosong (jebakan harvest 27 Sep 2026,
lihat catatan teknis di `relasi_ui-inventory.md`).

**Alert/confirm duplikat memakai native `alert()`/`confirm()` browser** (bukan SweetAlert2 seperti
Hapus, bukan zemPopover seperti validasi field-kosong) — WAJIB `page.on('dialog', ...)` handler
untuk SCR-PEL-05 (alert duplikat Diskon, tanpa confirm() sebelumnya) dan SCR-AGN-05 (confirm()
SELALU muncul dulu sebelum submit, lalu alert() bila duplikat — 2 dialog berurutan).

## SCR-PEL-01 Daftar Relasi Pelanggan (`/partner/pelanggan`)

| Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|
| Tombol toggle Filter | `#btn-filter` | id | |
| Filter Nama Perusahaan | `input[name="nama_perusahaan"]` | name | dikonfirmasi live: filter 'Karya Bersama' → 58→1 baris |
| Filter Lama Pembayaran | `input[name="lama_pembayaran"]` | name | |
| Filter PIC | `input[name="pic"]` | name | |
| Filter Email | `input[name="email_perusahaan"]` | name | |
| Filter Telepon/WA | `input[name="telp_perusahaan"]` | name | |
| Hidden status filter | `input[name="status_filter"]` value=1 | name | tidak user-facing |
| Tombol Reset filter | `.reset-master` **ATAU** `.btn-primary` lain | css | **2 tombol berlabel "Reset" ditemukan di DOM**, perilaku persis keduanya BELUM dibedakan detail — verifikasi mana yang berfungsi saat eksekusi (SCN-0010) |
| Dropdown jumlah baris | `#valuelimit` | id | opsi 20/30/50/100 |
| Link "Tambah Pelanggan" | `a.btn-buat-trayek` | css | tanpa id; href `/partner/tambahpelanggan`; role fallback `getByRole('link', { name: 'Tambah Pelanggan' })` |
| Tabel daftar | `table tbody tr` | css | kolom No, Nama Perusahaan, Lama Pembayaran ("Tunai" atau "N Hari"), Nama PIC, Email, Telepon/WA, Aksi |
| Aksi Detail (per baris) | `row.locator('a.btn-view.btn_1')` | css | title "Detail Pelanggan", href `/partner/detailpelanggan/<base64Id>` |
| Aksi Hapus (per baris) | `row.locator('button.btn-delete')` | css | title "Hapus Pelanggan"; SweetAlert2 konfirmasi (lihat `shared/selector-map-partner-common.md`); dipakai cleanup SCN-0011 |
| Jumlah data | teks "Menampilkan X sampai Y dari Z data" | teks | **Pusat: 58. Cabang Pare-Pare: 58 — SAMA PERSIS**, tidak difilter kota (FND-RL-08) |

## SCR-PEL-02 Detail Pelanggan (`/partner/detailpelanggan/<base64Id>`)

| Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|
| Tombol "Edit Pelanggan" | teks tombol, TIDAK STABIL tanpa id | teks | membuka modal SCR-PEL-03 (BUKAN route terpisah) — **ADA identik pada Pusat maupun Cabang** |
| Field tampilan | Nama Perusahaan, Lama Pembayaran, Nama PIC, Email (mailto), Telepon/Whatsapp, Jenis Identitas, Nomor Identitas, Kota/Kab, Alamat Perusahaan, Keterangan | css, per-label | data lama (pra-fitur) menampilkan `-` untuk Jenis Identitas/Nomor Identitas/Kota (REQ-PEL-04, contoh nyata: CV Karya Bersama id 3701, base64 `MzcwMQ==`) |
| Link "Tambah Diskon" | href `/partner/tambahandiskon/<base64Id>` | css | → SCR-PEL-05 |
| Tabel Diskon | `table tbody tr` dalam blok Diskon | css | kolom Tanggal Buat, Jenis Tiket, Golongan Tiket, Kelas/Kondisi, Rute, Diskon Harga, Aksi (2 tombol tanpa title captured, kemungkinan Edit/Hapus Diskon — BELUM dipetakan detail, verifikasi saat eksekusi SCN-0011) |

## SCR-PEL-03 Edit Pelanggan (modal `#modalpelanggan`, dalam SCR-PEL-02)

| Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|
| Nama Perusahaan | `#nama_perusahaan` | id | wajib (*) |
| Nama PIC | `#penanggung_jawab` | id | wajib (*) |
| Checkbox "Pembayaran Bisa TOP" | `#topnya` | id | |
| Lama Pembayaran | `#lama_pembayaran` | id | number, placeholder "Lama Pembayaran (Hari)", `disabled` sampai `#topnya` dicentang (VAL-PEL-03) |
| Email | `#email_perusahaan` | id | wajib (*) |
| Telepon/WA | `#telp_perusahaan` | id | wajib (*) |
| Jenis Identitas | `#jenis_identitas` | id | select2: Pilih Jenis/KTP/SIM/Passport, wajib (*) |
| Nomor Identitas | `#nomor_identitas` | id | wajib (*) |
| Kota/Kab | `#kota` | id | select, **satu-satunya field dengan atribut HTML `required` sungguhan**, ratusan opsi |
| Alamat Perusahaan | `#alamat_perusahaan` | id | textarea, wajib (*) |
| Keterangan | `#keterangan` | id | textarea, **TANPA tanda \*** (opsional) |
| Hidden OperatorID | `select#OperatorID` | id | `display:none`, tenant scoping, TIDAK user-facing |
| Hidden id_perusahaan | `#id_perusahaan` | id | |
| Tombol Simpan | `#btn_update_golongan` | id | **id sisa template dari Master Golongan (kosmetik, FND-RL-06)** — pakai selector teks "Simpan" dalam scope modal, JANGAN andalkan id ini |
| Tombol Batal | `#button-batal` | id | `data-dismiss="modal"` |

## SCR-PEL-04 Tambah Pelanggan (`/partner/tambahpelanggan`)

Field SAMA PERSIS dengan SCR-PEL-03 (bukan modal, halaman sendiri) — gunakan id yang sama
(`#nama_perusahaan`, `#penanggung_jawab`, `#topnya`, `#lama_pembayaran`, `#email_perusahaan`,
`#telp_perusahaan`, `#jenis_identitas`, `#nomor_identitas`, `#kota`, `#alamat_perusahaan`,
`#keterangan`).

| Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|
| Tombol Simpan | `#simpan` | id | AJAX POST `/partner/doaddpelanggan` |
| Tombol Batal | `#button-batal` | id | redirect `/partner/pelanggan` |

### Pesan validasi (M-PEL-01), urutan & teks PERSIS

| Field kosong/invalid | Pesan (zemPopover kecuali disebut lain) |
|---|---|
| nama_perusahaan | "Masukkan Nama Perusahaan" (live-verified) |
| penanggung_jawab | "Masukkan Nama PIC" |
| lama_pembayaran (bila #topnya dicentang) | "Masukkan Jumlah Hari"; nilai 0 → native `alert("Minimal 1")` |
| email_perusahaan kosong | "Masukkan Email Perusahaan" (live-verified) |
| email_perusahaan format salah | "Masukkan Email Dengan Benar" (live-verified) |
| email_perusahaan duplikat | "Email Sudah terdaftar" (AJAX POST `/partner/cek_email_pelanggan`) |
| telp_perusahaan kosong | "Masukkan Nomor" |
| telp_perusahaan duplikat | "Nomor Whatsapp Sudah terdaftar" (AJAX POST `/partner/cek_wa_pelanggan`) |
| jenis_identitas kosong | "Pilih Jenis Identitas" |
| nomor_identitas kosong | "Masukkan Nomor" |
| kota kosong | "Pilih Kota / Kab" |
| alamat_perusahaan kosong | "Masukkan Alamat Perusahaan" |
| keterangan kosong | TIDAK DICEK (opsional) |

## SCR-PEL-05 Tambah Diskon (`/partner/tambahandiskon/<base64Id>`)

| Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|
| Rute | `select#rute` (name `berlaku_untuk`) | id/name | 58 opsi trayek |
| Jenis Tiket | `select#jenis1` (name `ParentID[]`) | id/name | opsi: Penumpang / Kendaraan / **Bagasi Kendaraan** / **Bagasi Penumpang** — 2 varian Bagasi terpisah (FND-RL-02) |
| Golongan Tiket | `select#golongan1` (name `golongan[]`) | id/name | terisi AJAX POST `/partner/getgolongantiket` berdasar jenis1 |
| Kelas/Kondisi Kendaraan | `select#kelas1` (name `kelas[]`) | id/name | **DIGANTIKAN** oleh `input.bagasi_<n>` (value="Bagasi", disabled) saat jenis1 = salah satu varian Bagasi (VAL-PEL-05) |
| Jenis Diskon | `select#tipe1` (name `tipe[]`) | id/name | opsi Rupiah/Persen |
| Harga Diskon | `input#harga1` (name `harga[]`) | id/name | placeholder "Harga Diskon"; label "%" tampil di kiri saat tipe=Persen; Inputmask numeric max 100 + keyup/keypress handler saat Persen (VAL-PEL-04) |
| Tombol "Tambah Baris Input" | `#add_menu` | id | |
| Tombol Simpan | `#simpan` | id | type submit; AJAX POST `/partner/saveIncludeDiskon` |
| Tombol Batal | `#batal3` | id | |

### Pesan (M-PEL-xx)

| ID | Pemicu | Pesan |
|---|---|---|
| M-PEL-03 | 2 baris dalam 1 submit, kombinasi Golongan+Kelas sama | Native `alert('Input harga penumpang/kendaran ada yang sama ')` [kutip persis termasuk typo], baris di-highlight `#ffc4c4` |
| M-PEL-04 | Kombinasi Golongan+Kelas+Rute+Jenis Tiket sudah ada di database | Native `alert('Tidak bisa! Diskon sudah ditambahkan')` [kutip persis] |
| M-PEL-05 | Jenis Tiket = Bagasi Kendaraan/Bagasi Penumpang | `select#kelas1` disembunyikan, digantikan `input.bagasi_<n>` value="Bagasi" disabled |
| M-PEL-06 | Filter `nama_perusahaan=Karya Bersama` (SCR-PEL-01) | "Menampilkan 1 sampai 1 dari 1 data" |

## SCR-AGN-01 Daftar Relasi Agen "DAFTAR AGEN" (`/partner/agen`)

| Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|
| Tombol toggle Filter | `#btn-filter` (atau `a[href="#"]` versi agen) | id/css | |
| Filter Nama Perusahaan | `input[name="nama_perusahaan"]` | name | |
| Filter Penanggung Jawab | `input[name="penanggung_jawab"]` | name | |
| Filter Telepon/WA | `input[name="telp"]` | name | |
| Filter Status | `select#status` | id | opsi: Pilih Status / Aktif / Tidak Aktif |
| Dropdown jumlah baris | `#valuelimit2` | id | |
| Link "Tambah Agen" | href `/partner/tambahagen` | css | **HANYA ADA pada akun Cabang** — dipindai penuh (`querySelectorAll`) dan dikonfirmasi ABSEN pada akun Pusat (REQ-AGN-01/FND-RL-07) |
| Tabel daftar | `table tbody tr` | css | kolom No, Nama Perusahaan Agen, Penanggung Jawab, Telepon/WA, Status, Aksi |
| Aksi "Detail Agen" | `a.btn-view` | css | tersedia pada KEDUA akun |
| Aksi "Hapus Agen" | `button.btn-delete` | css | **HANYA ADA pada akun Cabang** — TIDAK ADA sama sekali pada Pusat |
| Jumlah data | teks "Menampilkan..." | teks | **Pusat: 3 (semua kota). Cabang Pare-Pare: 1 (hanya sekota Pare-Pare)** — REQ-AGN-04 |

## SCR-AGN-02 Detail Agen (`/partner/detailagen/<base64Id>`)

| Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|
| Field identitas | Nama Perusahaan Agen, Penanggung Jawab, Email (mailto), Telepon/Whatsapp, Kota, Alamat Perusahaan | css, per-label | Kota mengikuti kota Cabang pembuat (server-side, tidak dipilih user) |
| Logo Perusahaan (status upload) | css, per-label | | |
| Dokumen Identitas / Surat Perjanjian / Dokumen Tambahan | link PDF | css | |
| Blok "INFORMASI REKENING" | Nama Bank, Nomor Rekening, Atas Nama Rekening | css | field FND-RL-04, tidak disebut rule P726-737 |
| Blok "Komisi Agen" | tabel: No, Jenis Tiket, Golongan Tiket, Kelas/Kondisi Kendaraan, Rute, Komisi (%), [Aksi] | css | **Pusat: TANPA kolom Aksi, TANPA link "Tambah Komisi"**. **Cabang: PUNYA kolom Aksi + link "Tambah Komisi"** |
| Tombol "Edit Agen" | href `/partner/editagen/<idPolos>` | css | **HANYA ADA pada Cabang** — TIDAK ADA pada Pusat (hanya tombol "Kembali") |
| Link "Tambah Komisi" | href `/partner/tambahkomisiagen/<idPolos>` | css | **HANYA ADA pada Cabang** → SCR-AGN-05 |
| Catatan id | id Agen di route Edit/Tambah Komisi = **angka polos** (mis. `19534`), BEDA dari route Detail (base64) | — | JANGAN tertukar format id saat membangun URL |

## SCR-AGN-03 Tambah Agen (`/partner/tambahagen`) — Cabang saja

**Pusat diblokir SERVER-SIDE**: akses URL langsung → redirect `/partner/dashboard` + `.alert-danger`
"Anda Tidak Memiliki Akses Ke Halaman Tersebut" (FND-RL-07, dikonfirmasi via akses URL langsung,
BUKAN cuma tombol tersembunyi).

| Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|
| Nama Perusahaan | `#nama_perusahaan` | id | wajib (*) |
| Penanggung Jawab | `#penanggung_jawab` | id | wajib (*) |
| Email | `#email` | id | type email, wajib (*) |
| Kata Sandi | `#password` | id | wajib (*), FND-RL-04 (tak disebut rule); regex `^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]).{5,}$` |
| Konfirmasi Kata Sandi | `#password_confirm` | id | wajib (*) |
| Telepon/WA | `#telp` | id | wajib (*) |
| Alamat Perusahaan | `#alamat_perusahaan` | id | textarea, wajib (*) |
| Logo Perusahaan Agen | `#foto_stnk` | id | file, **opsional** (TIDAK bertanda *) |
| Dokumen Identitas | `#foto_identitas` | id | file, wajib (*), FND-RL-04 |
| Surat Perjanjian | `#foto_perjanjian` | id | file, wajib (*), FND-RL-04 |
| Dokumen Tambahan | `#foto_dokumen` | id | file, **opsional** |
| Status | `select#status` | id | Aktif/Tidak Aktif, wajib (*) |
| Bank | `select#bank` | id | BRI/BNI/BCA/CIMB NIAGA/+2 lain (6 opsi total), wajib (*), FND-RL-04 |
| Nomor Rekening | `#nomor_rekening` | id | wajib (*), FND-RL-04 |
| Atas Nama Rekening | `#atas_nama` | id | wajib (*), FND-RL-04 |
| Tombol Simpan | `#submit_sub` | id | **native `form.submit()`** (`#form-agen`), BUKAN AJAX (upload file multipart) — tunggu navigasi/reload penuh, bukan AJAX response |
| Field TIDAK ADA di form ini | — | — | Kota — otomatis mengikuti kota Cabang pembuat (server-side) |

### Pesan validasi (M-AGN-01), urutan & teks PERSIS

| Field kosong/invalid | Pesan |
|---|---|
| nama_perusahaan | "Masukkan Nama Perusahaan" (live-verified) |
| penanggung_jawab | "Masukkan Nama Penanggung Jawab" |
| email kosong | "Masukkan email" |
| email duplikat (`$('#email').attr("ada")=="1"`) | "Email sudah Terdaftar" |
| email attr ada=="2" | "Masukkan Email dengan benar" |
| email gagal regex | "Penulisan email salah" |
| password kosong | "Masukkan Kata Sandi" |
| password gagal regex | "Kombinasi Hanya Boleh Huruf dan Angka" |
| password_confirm kosong | "Masukkan Konfirmasi Kata Sandi" |
| password_confirm ≠ password | "Kata Sandi Belum Sama" |
| telp kosong | "Masukkan Nomor" |
| telp duplikat (attr ada=="1") | "Nomor sudah Terdaftar" (REQ-AGN-03; scope lintas-cabang = Q-RA-02, tidak terjawab) |
| alamat_perusahaan kosong | "Masukkan Alamat Perusahaan" |
| foto_identitas kosong | "Masukkan Dokumen Identitas" |
| foto_perjanjian kosong | "Masukkan Surat Perjanjian" |
| status kosong | "Pilih Status" |
| bank kosong | "Pilih Bank" |
| nomor_rekening kosong | "Masukkan Nomor Rekening" |
| atas_nama kosong | "Masukkan Nama" |

## SCR-AGN-04 Edit Agen (`/partner/editagen/<idPolos>`) — Cabang saja

Field identik SCR-AGN-03, terisi data existing. `password`/`password_confirm` tampil sebagai
mask literal `*******` (bukan value asli). `status` bisa diganti (REQ-AGN-06/07). Pusat diblokir
sama seperti SCR-AGN-03 (dikonfirmasi via akses URL langsung, SCN-0012).

## SCR-AGN-05 Tambah Komisi Agen (`/partner/tambahkomisiagen/<idPolos>`) — Cabang saja

Struktur field SAMA seperti SCR-PEL-05, TAPI **TIDAK ADA selector `tipe1`** (Komisi Agen SELALU
persentase). Pusat diblokir sama seperti SCR-AGN-03/04.

| Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|
| Rute | `select#rute` (name `berlaku_untuk`) | id/name | |
| Jenis Tiket | `select#jenis1` (name `ParentID[]`) | id/name | |
| Golongan Tiket | `select#golongan1` | id | |
| Kelas/Kondisi Kendaraan | `select#kelas1` | id | |
| Harga Komisi (%) | `input#harga1` (class `hanyaangka-koma-`) | id/class | placeholder "0" |
| Tombol "Tambah Baris Input" | `#add_menu` | id | |
| Tombol Simpan | `#simpan` | id | memicu native `confirm()` DULU (M-AGN-02), BARU AJAX POST `/partner/saveIncludeKomisi` |
| Tombol Batal | `#batal3` | id | |
| Tombol Kembali | `#kembalikan` | id | |

### Pesan (M-AGN-xx)

| ID | Pemicu | Pesan |
|---|---|---|
| M-AGN-02 | Klik Simpan (sebelum validasi field, awal handler) | Native `confirm("Apakah Anda yakin untuk menambahan komisi agen ?")` [kutip persis termasuk typo] — WAJIB `page.on('dialog')` handler, SELALU muncul dulu meski data valid |
| M-AGN-03 | Simpan dengan field kosong | zemPopover — live-verified: Rute kosong → "Pilih Rute" |
| M-AGN-04 | Kombinasi Golongan+Kelas+Rute komisi sudah ada di database | Native `alert('Komisi yang Anda inputkan sudah ada di database')` — **BEDA dari kutipan rule P736 "Komisi sudah ada di database" (FND-RL-01)**, assertion pakai partial match `/sudah ada di database/i` |
| M-AGN-05 | Pusat mengakses route Tambah/Edit/Tambah Komisi Agen langsung via URL | Redirect `/partner/dashboard` + `.alert-danger` "Anda Tidak Memiliki Akses Ke Halaman Tersebut" |

## Rekomendasi data-testid untuk developer

| Layar | Elemen | Usulan data-testid |
|---|---|---|
| SCR-PEL-01 | 2 tombol "Reset" (`.reset-master` dan `.btn-primary` lain) tidak dibedakan fungsinya | `rl-pel-filter-reset` — satu id unik agar automasi tidak ambigu memilih tombol Reset mana yang berfungsi |
| SCR-PEL-01/SCR-AGN-01 | Aksi baris Detail/Hapus tanpa data-testid (`a.btn-view.btn_1`, `button.btn-delete`, `a.btn-view`) | `rl-pel-row-detail-<id>`, `rl-pel-row-delete-<id>`, `rl-agn-row-detail-<id>`, `rl-agn-row-delete-<id>` |
| SCR-PEL-02 | Tabel Diskon, 2 tombol Aksi tanpa title (kemungkinan Edit/Hapus Diskon) | `rl-diskon-row-edit-<id>`, `rl-diskon-row-delete-<id>` — beri title/aria-label eksplisit juga, bukan hanya data-testid |
| SCR-PEL-03 | Tombol Simpan modal Edit Pelanggan memakai id `btn_update_golongan` (sisa template Master Golongan, FND-RL-06) | `rl-pel-edit-submit` — id unik, jangan pakai id sisa copy-paste modul lain |
| SCR-PEL-05/SCR-AGN-05 | Tombol Simpan sama-sama `#simpan` di kedua layar berbeda — berisiko ambigu bila dua layar termuat bersamaan (edge case SPA) | `rl-diskon-submit`, `rl-komisi-submit` |
| SCR-AGN-02 | Tombol "Edit Agen"/"Tambah Komisi" tanpa id, hanya href | `rl-agn-detail-edit-btn`, `rl-agn-detail-tambahkomisi-btn` |
| SCR-AGN-03/04 | Banyak field WAJIB (Kata Sandi, Upload Dokumen, Informasi Rekening) sama sekali tidak disebut rule bisnis (FND-RL-04) — bukan masalah selector, tapi risiko dokumentasi | Tambahkan anotasi/tooltip di UI menjelaskan field ini WAJIB dan fungsinya (kredensial login Agen, dokumen legal, rekening pencairan), bukan cuma tanda \* generik |
| SCR-PEL-05/SCR-AGN-05 | Opsi Jenis Tiket "Bagasi Kendaraan"/"Bagasi Penumpang" tidak match penamaan "Bagasi" tunggal di rule (FND-RL-02) | `rl-jenis-bagasi-kendaraan`, `rl-jenis-bagasi-penumpang` pada `<option>` — memudahkan automasi memilih varian spesifik tanpa bergantung pada teks label yang bisa berubah |
| SCR-AGN-05 | Alert duplikat Komisi berbeda teks dari rule (FND-RL-01) | Selaraskan teks pesan aplikasi dengan dokumen rule ATAU perbarui dokumen rule — bukan masalah selector murni, tapi disarankan diberi `data-testid="rl-komisi-alert-duplikat"` pada elemen pemicu agar assertion tidak bergantung pada teks yang mungkin berubah |
| SweetAlert (Hapus Pelanggan/Agen) | Tombol Ya/Batal/Hapus | `swal-confirm`, `swal-cancel` (sama seperti Master/Kuota&Jadwal/OP-21) |
