# Selector Map — Modul OP-12 Kuota dan Jadwal (portal Operator `/partner`)

Disusun dari `scenario/kuota-jadwal/kuota-jadwal_ui-inventory.md` (eksplorasi READ-ONLY 27 September
2026, `browser_evaluate` atas DOM tiap layar — **bukan** hasil `/harvest-selectors` formal; jalankan
skrip itu di kemudian hari bila dibutuhkan sumber selector yang lebih tervalidasi). Elemen
login/header/sidebar/SweetAlert/popover/pagination yang dipakai bersama seluruh portal Operator ada di
`shared/selector-map-partner-common.md` (tidak diulang di sini).

Tidak ada `data-testid` di aplikasi ini. Prioritas selector yang dipakai: id stabil → role+name → css
scoping per-baris → teks (tanpa id, ditandai TIDAK STABIL). Modul ini punya dua rute utama: Daftar
(`/partner/masterjadwal`) dan Tambah (`/partner/tambahjadwal`, route sendiri); **Edit TIDAK punya route
terpisah** — tombol Edit pada Daftar melakukan AJAX in-place swap konten halaman (breadcrumb berubah
jadi "Edit Jadwal", URL tetap `/partner/masterjadwal`).

Menu sidebar: **KUOTA & JADWAL** adalah link tunggal (bukan grup collapsible) → `a[href$="/partner/masterjadwal"]`,
identik pada Operator Pusat maupun Cabang.

**DILARANG KERAS menyentuh `button.btn-kirim` ("Kirim ke Pelindo")** — keputusan user 27 September 2026,
lihat `kuota-jadwal_analysis.md` VAL-008/FND-KJ-02 dan `kuota-jadwal_coverage.md`. Selector ini SENGAJA
TIDAK didokumentasikan lebih lanjut di file ini agar tidak dipakai keliru oleh executor.

## SCR-01 Daftar Kuota & Jadwal

| Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|
| Tombol toggle Filter | `#btn-filter` | id | |
| Filter Tanggal Buat | `#Tanggal_Buat` | id | |
| Filter Nama Trayek | `#Nama_Trayek` | id | dikonfirmasi live: filter 'SURABAYA' → 2242→230 baris |
| Filter Nama Kapal | `select#kapal` | css | id sama dengan `select#kapal` di form Tambah (SCR-02) — scoping per halaman |
| Filter Nomor Voyage | `#Nomor_Voyage` | id | |
| Tombol Reset filter | `.reset-master` | css | |
| Tombol submit Filter | dalam panel filter (`#btn-filter` toggle) | css | ui-inventory tidak menegaskan id submit terpisah dari toggle; verifikasi saat eksekusi |
| Dropdown jumlah baris | `#valuelimit` | id | opsi 10/20/50/100 |
| Link "Buat Jadwal" (Tambah) | `a.btn-buat-trayek` | css | href `/partner/tambahjadwal`; role fallback `getByRole('link', { name: 'Buat Jadwal' })` |
| Tabel daftar | `table tbody tr` | css | kolom Tanggal Buat, Trayek, Nama Kapal, Nomor Voyage, Kapasitas, Aksi + baris tambahan "Rute yang dilewati trayek ini" (badge pelabuhan, selalu tampil) |
| Aksi Lihat (per baris) | `row.locator('a.btn-viewnya')` | css | `data-toggle="collapse"` `data-target=".col<id>"` — panel KOSONG (FND-KJ-01) |
| Aksi Edit (per baris) | `row.locator('a.btn-edit.edit')` | css | id `edit<id>`, atribut `data-idjadwal`/`data-idkapal`/`data-idtrayek`; AJAX in-place swap ke SCR-06/07/08, TANPA ganti URL |
| Aksi Hapus (per baris) | `row.locator('a.btn-delete.delete-jadwal')` | css | title "Hapus Kuota & Jadwal"; SweetAlert2 konfirmasi diasumsikan (lihat `shared/selector-map-partner-common.md`) — dipakai untuk cleanup SCN-0003/0004/0005/0006 |

## SCR-02 Buat Kuota & Jadwal — Langkah 1 (pilih Trayek/Kapal)

Route `/partner/tambahjadwal`. Setelah Trayek+Kapal dipilih, 3 tab (KUOTA/JADWAL/CREW LIST) langsung
muncul di bawah tanpa tombol "Lanjut" terpisah. **Tidak ada atribut HTML `required` sama sekali** di
form ini (`[required]` count=0 dikonfirmasi via DOM).

| Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|
| Trayek | `select#trayek` | id | 24 opsi (yang sudah punya Tarif Pass, REQ-004), IDENTIK utk Pusat & Cabang (VAL-009/FND-KJ-03, desain sengaja) |
| Kapal | `select#kapal` | id | opsi = SEMUA Master Kapal, tidak terikat trayek |
| Call Sign (readonly) | `#kode_kapal` | id | disabled, auto-terisi dari Kapal |
| Nomor Voyage | `#nomor_voyage` | id | text bebas — pakai prefix `AUTOTEST-20260927-` untuk data uji |
| Kapasitas Penumpang (readonly) | `#kapasitas` | id | disabled, auto "Sesuai Kapal" |
| Info "Rute yang dilewati trayek ini" | badge pelabuhan statis | css | tampil setelah Trayek dipilih |
| Tab KUOTA | teks tab "KUOTA" (huruf besar pada Tambah) | teks, TIDAK STABIL | lihat SCR-03 |
| Tab JADWAL | teks tab "JADWAL" | teks, TIDAK STABIL | lihat SCR-04 |
| Tab CREW LIST | teks tab "CREW LIST" | teks, TIDAK STABIL | lihat SCR-05 |

## SCR-03 Buat Kuota & Jadwal — tab KUOTA (dalam SCR-02)

3 blok tabel: Distribusi Kuota Penumpang, Distribusi Kuota Kendaraan, Distribusi Kuota Bagasi. Golongan
kendaraan/bagasi BERBEDA SET per trayek (mis. Parepare-Balikpapan pakai kode "(II-A)/(III-A)/…",
Bakauheni-Merak pakai "Golongan I/II/…IX").

| Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|
| Kuota Penumpang Internal (baris ke-`<id>`) | `input#dist_penumpang<id>` | id | golongan dari Kelas Kapal terpilih (REQ-018) |
| Kuota Penumpang Eksternal | `input#dist_penumpang_eks<id>` | id | |
| Bonus tiket dari kuota kendaraan (kolom Penumpang) | disabled, read-only | css | tidak diisi manual |
| Kuota Kendaraan Internal | `input#dist_kendaraan<id>.dist_kendaraan` | id+class | golongan dari Harga+Tarif Pass trayek terpilih (REQ-017) |
| Kuota Kendaraan Eksternal | `input#dist_kendaraan_eks<id>.dist_kendaraan_eks` | id+class | |
| Bonus Tiket kendaraan | `input.bonus_tiket` | css | placeholder "Jumlah Tiket"; **readonly khusus golongan III-A/III-B pada trayek Parepare-Balikpapan/Balikpapan-Parepare** (VAL-006), EDITABLE di trayek lain (mis. Bakauheni-Merak) |
| Kuota Bagasi Internal | `input#dist_bagasi<id>` | id | |
| Kuota Bagasi Eksternal | `input#dist_bagasi_eks<id>` | id | |
| Tombol Simpan (tab Kuota) | `getByRole('button', { name: 'Simpan' })` scoped ke tab Kuota | role | Simpan kosong — perilaku BELUM diverifikasi (VAL-001, observasional) |
| Tombol Batal | `getByRole('button', { name: 'Batal' })` scoped ke tab Kuota | role | |

## SCR-04 Buat Kuota & Jadwal — tab JADWAL (dalam SCR-02) / SCR-07 Edit — tab Jadwal

Tabel "Jadwal Rute Yang Dijual Dari Satu Trayek", satu baris per LEG trayek (trayek 2-pelabuhan yang
dicoba saat harvest hanya render 1 baris — trayek ≥3 pelabuhan belum ditemukan, lihat VAL-003/SCN-0007).

| Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|
| Status Jadwal (per leg, baris ke-`<n>`) | `select` opsi value `Tampil`("Jadwal Tampil", default) / `Tutup`("Jadwal Tutup") | css, tanpa `name` valid (FND-KJ-04) | **INI mekanisme "Tutup Jadwal"** (Q-KJ-02); dipakai SCN-0003/REQ-010 |
| Pelabuhan Asal (readonly) | disabled select/text | css | |
| Waktu Berangkat | `input[name="tgl_etd"]` id `tgl_etd<n>` | id/name | placeholder "Tentukan Waktu Berangkat", datepicker |
| Pelabuhan Tujuan (readonly) | disabled select/text | css | |
| Waktu Tiba | `input[name="tgl_eta"]` id `tgl_eta<n>` | id/name | placeholder "Tentukan Waktu Tiba", datepicker |
| Tombol Simpan (tab Jadwal) | `getByRole('button', { name: 'Simpan' })` scoped ke tab Jadwal | role | Simpan kosong — BELUM diverifikasi (VAL-002, observasional) |
| Tombol Batal | `getByRole('button', { name: 'Batal' })` scoped ke tab Jadwal | role | |
| ~~Tombol "Kirim ke Pelindo"~~ | ~~`button.btn-kirim`~~ | — | **DILARANG dipakai** — tidak ditemukan di tab Tambah; ADA di DOM tab Edit (SCR-07) tapi TIDAK PERNAH boleh diklik/diverifikasi sesuai keputusan user (VAL-008/FND-KJ-02) |

## SCR-05 Buat Kuota & Jadwal — tab CREW LIST (dalam SCR-02, sebelum Kuota/Jadwal disimpan)

| Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|
| Teks peringatan | "Pastikan Crew List sudah terisi semua" | teks, TIDAK STABIL | M-02 |
| Tombol "Masukkan Crew" | TIDAK ADA pada tahap ini | — | baru muncul setelah Kuota+Jadwal tersimpan (lihat SCR-08) |
| Tombol "Selesai" | `getByRole('button', { name: 'Selesai' })` | role | **atribut HTML `disabled=true` terkonfirmasi via DOM** sebelum Kuota/Jadwal tersimpan (VAL-004) — assertion langsung, tidak perlu submit |

## SCR-06 Edit Kuota & Jadwal — tab Kuota (dalam SCR-01, AJAX swap, URL tetap `/partner/masterjadwal`)

Sama struktur SCR-03, field Trayek/Kapal/Kode Kapal/Kapasitas disabled+terisi; Nomor Voyage TETAP
EDITABLE (bukan disabled).

| Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|
| Trayek/Kapal/Kode Kapal/Kapasitas (readonly) | sama id dengan SCR-02, `disabled=true` | id | terisi data existing |
| Nomor Voyage | `#nomor_voyage` | id | EDITABLE, tidak disabled |
| Bonus Tiket (contoh jadwal id 2293, Parepare-Balikpapan) | `input.bonus_tiket` | css | golongan "Kendaraan Kecil (III-A)"/"Mobil Mewah (III-B)": **`readonly=true`, value tetap "1"** (VAL-006 TERVERIFIKASI); golongan sama di trayek Bakauheni-Merak: `readonly=false` (editable); rute Surabaya-Balikpapan (jadwal id 466): golongan III-A "Tidak Tersedia" (field tidak ada sama sekali) |

## SCR-08 Edit Kuota & Jadwal — tab crew list (dalam SCR-01)

| Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|
| Teks peringatan | "Edit Crew List akan merubah crew list di pelabuhan selanjutnya" | teks, TIDAK STABIL | M-03 |
| Tombol "Masukkan Crew" (per port) | `getByRole('button', { name: 'Masukkan Crew' })` | role | membuka modal SCR-09; HANYA muncul setelah Kuota+Jadwal tersimpan |
| Tombol "Selesai" | `getByRole('button', { name: 'Selesai' })` | role | aktif/tidak disabled pada jadwal yang sudah punya crew |

## SCR-09 Modal "INPUT CREW LIST" (dari SCR-08, tombol "Masukkan Crew")

| Elemen | Selector terbaik | Sumber | Catatan |
|---|---|---|---|
| Dialog | `role=dialog` judul "INPUT CREW LIST" | role | |
| Info readonly (Nama Kapal, Kode Kapal, Nomor Voyage, dst.) | tabel statis | css | tidak perlu diisi |
| Nama Awak Kapal (baris ke-n) | select2 "Pilih Awak kapal" | css, TIDAK STABIL tanpa id pasti | opsi dari Master Crew; pilih via role/text search select2 |
| Jenis Kelamin, Tgl Lahir, dst. | auto-fill setelah crew dipilih | css | kemungkinan readonly, belum dicek detail per kolom |
| Tombol "Tambah Baris Input" | `getByRole('button', { name: 'Tambah Baris Input' })` | role | |
| Tombol Batal | `getByRole('button', { name: 'Batal' })` | role | menutup tanpa simpan |
| Tombol Simpan | `getByRole('button', { name: 'Simpan' })` | role | |

## Rekomendasi data-testid untuk developer

| Layar | Elemen | Usulan data-testid |
|---|---|---|
| SCR-01 | Aksi baris Lihat/Edit/Hapus (`a.btn-viewnya`, `a.btn-edit.edit`, `a.btn-delete.delete-jadwal`) | `kj-row-view-<id>`, `kj-row-edit-<id>`, `kj-row-delete-<id>` |
| SCR-01 | Tombol submit Filter vs toggle Filter vs Reset | `kj-filter-toggle`, `kj-filter-submit`, `kj-filter-reset` |
| SCR-02/03/04 | Banyak elemen form (checkbox/hidden/select Status Jadwal, field `dist_*`) TANPA atribut `name` HTML (FND-KJ-04) — payload submit kemungkinan dirakit manual via JS, bukan form-serialize native | `kj-field-<nama-logis>` per elemen, supaya automasi tidak bergantung pada `id` generatif (`dist_penumpang<id>`, dsb.) yang berubah per baris |
| SCR-02 | Beberapa input non-select2 (`#nomor_voyage`, `#kapasitas`, `#kode_kapal`) punya `name="trayek"` yang salah/duplikat, sisa template copy-paste (FND-KJ-05) | Perbaiki atribut `name` agar sesuai field masing-masing, atau tambahkan `data-testid` unik per field supaya automasi berbasis `name` tidak salah target |
| SCR-01/22 (pola sama Master) | Aksi "Lihat" (panel collapse kosong, FND-KJ-01) | `kj-viewnya-<id>` + pastikan konten collapse benar-benar terisi data (Trayek, Kapal, ringkasan kuota) |
| SCR-03/04 | Tombol Simpan pada tab Kuota vs tab Jadwal (keduanya `getByRole('button', {name:'Simpan'})` tanpa pembeda id — berisiko ambigu bila kedua tab terbuka bersamaan di DOM) | `kj-submit-kuota`, `kj-submit-jadwal` — id unik per tombol Simpan per tab |
| SCR-02/03/04 | Simpan dengan field kosong belum diketahui perilakunya (VAL-001/002) — bila ternyata silent tanpa feedback | Tambahkan validasi client-side (popover/alert) konsisten dengan pola modul lain (OP-21 `zemPopover`), alih-alih silent no-op tanpa penjelasan ke operator |
| SCR-04/07 | Dropdown "Kirim ke Pelindo" terikat ke jadwal yang salah pada state tertentu (FND-KJ-02 — DITUTUP, tidak diuji, tapi tetap dicatat sebagai catatan kode untuk developer) | Pastikan `button.btn-kirim` terikat ke `idnya` jadwal yang sedang aktif ditampilkan, bukan jadwal lain yang sedang tidak aktif |
| SweetAlert | Tombol Ya/Batal/Hapus | `swal-confirm`, `swal-cancel` (sama seperti Master/OP-21) |
