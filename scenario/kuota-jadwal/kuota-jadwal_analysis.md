# OP-12 Kuota dan Jadwal — Analisis Requirement

Sumber: `scenario/Dokumen Rule RORO v1.5.0 v19042025.docx`, bagian **Kuota dan Jadwal**
(P552–P577), dirujuk dari `docs/module-map-from-rules.md` baris OP-12 (termasuk bagian
"Aturan lintas modul operator yang harus dipertahankan" untuk konteks silang modul).
Rujukan `P<n>` = indeks paragraf DOCX ke-n (mulai 0, termasuk paragraf kosong/tabel/judul,
urutan `word/document.xml//w:p`) — diekstrak dengan skrip Python (`xml.etree.ElementTree`
atas `word/document.xml` hasil unzip docx), PERSIS metode yang dipakai untuk OP-11 Master;
bukan nomor halaman. Batas rentang (P552 = judul "Kuota dan Jadwal", P578 = judul "Jual
Tiket" berikutnya) sudah dikonfirmasi lewat ekstraksi langsung, cocok dengan pembagian di
`module-map-from-rules.md`.

**Dokumen ini awalnya HANYA berisi REQ/VAL/AC dari dokumen rule** (harvest UI belum dikerjakan
saat penulisan awal, lihat catatan larangan browser di bawah). **Update 27 September 2026**:
harvest UI read-only sudah dijalankan terpisah, hasilnya di
`scenario/kuota-jadwal/kuota-jadwal_ui-inventory.md` (peta layar SCR-xx, selector, pesan M-xx,
temuan FND-KJ-xx) — bagian VAL dan beberapa Q-KJ di bawah sudah diperbarui mengacu ke dokumen
tsb; REQ dan AC tetap seperti versi awal (proyeksi dari rule, belum ada perubahan berbasis UI).

Cakupan modul: **Tambah/Edit Kuota, Tambah/Edit Jadwal, Crew List, Kuota Internal/Eksternal,
Bonus Kendaraan, Tutup Jadwal, Kirim Jadwal ke Pelindo** — sesuai P552–P577.

Akun uji yang relevan (`config/env.md`): **Operator Pusat** (akun #2, `prdct.atg@gmail.com`)
sebagai akun utama; **Operator Cabang Pare-Pare** (akun #3, `partnerbidph@gmail.com`) untuk
verifikasi isolasi data per-cabang dan kota keberangkatan. **Catatan keterbatasan**: hanya
ada **satu** akun Cabang (Pare-Pare) di `config/env.md` — rule P553 menjelaskan isolasi data
antar-cabang (mis. "cabang Surabaya" vs "cabang lain"), tetapi tanpa akun cabang kedua,
sisi *negatif* aturan ini (data cabang A tidak boleh tampil di cabang B) **tidak bisa
diverifikasi penuh**; hanya sisi positif (data cabang sendiri + pusat tampil) yang bisa diuji
dengan akun yang tersedia. Tandai sebagai **PERLU VERIFIKASI UI** dengan keterbatasan ini
dicatat eksplisit saat scenario-writing.

Tanggal kajian: 27 September 2026. Sesuai instruksi tugas ini, **tidak ada sesi
browser/Playwright MCP yang dibuka** — ada test run lain berjalan memakai akun Operator
Pusat/Cabang yang sama, dan `docs/agent-guide.md` melarang sesi browser bersamaan pada akun
yang sama. Semua baris "Dapat diuji di web?" di bawah adalah proyeksi dari teks rule, bukan
hasil pengamatan aplikasi.

## Catatan risiko khusus modul ini (penting untuk tahap penulisan skenario)

- **Modul ini ADALAH "jadwal nyata" yang dimaksud aturan wajib `docs/agent-guide.md`.**
  Aturan KUOTA/JADWAL di `agent-guide.md` ("setiap booking test mengonsumsi kursi/slot pada
  jadwal nyata", "data test selalu memakai jadwal keberangkatan sejauh mungkin di masa depan;
  jangan menyentuh keberangkatan terdekat") ditulis untuk modul Jual Tiket (OP-13), tetapi
  OP-12 adalah modul **pembuat** objek jadwal/kuota itu sendiri. Data uji Kuota & Jadwal yang
  dibuat run ini (idealnya berprefix `AUTOTEST-<tanggal>-` pada field bebas teks seperti nama
  trayek bila trayek uji dibuat khusus) **wajib** memakai tanggal keberangkatan sejauh mungkin
  di masa depan, dan sedapat mungkin memakai Trayek/Kapal uji sendiri (bukan trayek produksi)
  supaya tidak mengganggu inventori penjualan nyata.
- **Data referensi lintas modul, mirip pola Master (P480–P551), tetapi rule di P552–P577
  TIDAK secara eksplisit menyatakan larangan hapus/edit setelah dipakai** (beda dari Master
  yang eksplisit di P482/486/500/501/509/516). Begitu sebuah Jadwal dipakai (ada tiket
  terjual di atasnya lewat OP-13 Jual Tiket / AG-05 Jual Tiket Agen / UM-03 Cari Jadwal
  User Umum), jadwal itu kemungkinan besar juga menjadi rujukan di Manifest (OP-08),
  Persetujuan Tiket (OP-19), Pembatalan Tiket (OP-20), Dashboard/Laporan (OP-05/06,
  AG-04/08), dan tampilan Administrator (AD-15, khusus lihat). **Diam-nya rule soal
  edit/hapus setelah dipakai dicatat sebagai ketidakjelasan (Q-KJ-04), bukan diasumsikan
  sebagai "boleh"** — perlakukan Jadwal/Kuota uji dengan kehati-hatian yang sama seperti
  data Master: hindari mengedit/menghapus Jadwal uji setelah dipakai skenario lain sebelum
  dikonfirmasi aman lewat harvest UI.
- **Tombol "Kirim ke Pelindo" (P555) adalah integrasi ke sistem eksternal (otoritas
  pelabuhan).** Ini setara risikonya dengan "mengubah setting tenant" pada Master Denda
  Pembatalan — mengklik tombol ini pada jadwal nyata berpotensi memicu efek di sistem pihak
  ketiga di luar aplikasi ini. **Skenario pengujian HANYA boleh memverifikasi kemunculan/
  ketidakmunculan tombol** (berdasarkan pelabuhan asal Surabaya vs bukan), **tidak boleh
  benar-benar mengklik tombol tersebut** tanpa izin eksplisit user per kasus, dicatat lebih
  dulu di `shared/decisions.md` (pola sama seperti REQ-039/043 Master).
- **Alur wizard bertahap** (Tambah Kuota → Simpan → Tambah Jadwal → Simpan → Tambah
  Crewlist → Selesai, P560/P566/P567) berarti pengujian yang berhenti di tengah jalan bisa
  meninggalkan objek data "yatim" (Kuota tanpa Jadwal, atau Jadwal tanpa Crewlist) di sistem.
  Strategi pembersihan/urutan hapus untuk kondisi ini **belum diketahui** (rule tidak
  membahasnya) — PERLU VERIFIKASI UI apakah ada cara membatalkan proses di tengah wizard
  tanpa menyimpan data parsial.
- **Bonus kendaraan khusus rute Parepare–Balikpapan/Balikpapan–Parepare (P572–P573) adalah
  data produksi nyata** (bukan data yang dibuat run ini), dikonfigurasi dari backend dan
  disebut eksplisit "tidak bisa diedit". Skenario terkait **hanya boleh mengobservasi**
  (memastikan field terkunci/nilai sesuai), **tidak boleh mencoba mengubahnya** — mirip
  perlakuan Master REQ-025 (Tarif Pass referensi Administrator).
- **Ketergantungan pada Master (OP-11) sebagai prasyarat data.** REQ-004, REQ-017, REQ-018
  di bawah menunjukkan Tambah Kuota/Jadwal hanya menampilkan pilihan (trayek, golongan
  kendaraan/bagasi, golongan penumpang) yang **sudah** punya Tarif Pass/Harga/Kelas di Master.
  Urutan pembuatan data uji untuk OP-12 **wajib** menyiapkan dulu Trayek + Harga + Tarif Pass
  Pelabuhan + Kelas Kapal yang valid di OP-11 sebelum mencoba Tambah Kuota — sejalan dengan
  catatan `master_analysis.md` REQ-029 ("Data Crew masuk sebagai pilihan crew list di Kuota
  dan Jadwal") yang juga menegaskan arah ketergantungan yang sama (Master → Kuota & Jadwal).

## REQ — aturan bisnis dari dokumen rule

| ID | Aturan | Sumber | Dapat diuji di web? |
|---|---|---|---|
| REQ-001 | Data Kuota & Jadwal yang dibuat sebuah Cabang hanya tampil di akun Cabang itu sendiri dan Pusat; cabang lain tidak bisa melihat data tersebut. | P553 | Sebagian — hanya ada 1 akun Cabang (Pare-Pare) di `config/env.md`; sisi positif (tampil di cabang sendiri+pusat) bisa diuji, sisi negatif (tidak tampil di cabang lain) tidak bisa diverifikasi tanpa akun cabang kedua |
| REQ-002 | Kuota & Jadwal yang dibuat Pusat otomatis masuk ke akun Pusat DAN akun Cabang yang kotanya sesuai kota keberangkatan rute (mis. rute Surabaya-Makassar masuk ke akun Cabang Surabaya). | P554 | Ya, tapi terbatas pada kota yang punya akun Cabang tersedia (Pare-Pare) |
| REQ-003 | Tombol "Kirim ke Pelindo" pada jadwal hanya muncul untuk rute dengan pelabuhan asal Surabaya; rute selain Surabaya tidak punya tombol tersebut. | P555 | Ya — verifikasi kemunculan tombol saja (JANGAN diklik, lihat "Catatan risiko") |
| REQ-004 | Tambah Jadwal: hanya trayek yang sudah punya Tarif Pass Pelabuhan yang tampil sebagai pilihan. | P557 | Ya — butuh Trayek + Tarif Pass uji dari OP-11 sudah tersedia lebih dulu |
| REQ-005 | Tambah Kuota: semua field wajib diisi. | P558 | Ya, tapi lihat pola Master FND-M-01 (kemungkinan silent tanpa pesan) — PERLU VERIFIKASI UI |
| REQ-006 | Bonus Tiket (kendaraan) masuk ke dalam hitungan kuota kapal, sehingga harus disesuaikan dulu dengan jumlah kuota kapal. | P559 | Sebagian — mekanisme penyesuaian (validasi sistem vs disiplin manual operator) belum jelas, lihat Q-KJ-01 |
| REQ-007 | Tambah Kuota: harus klik Simpan lebih dulu untuk lanjut ke proses berikutnya (Tambah Jadwal) — alur bertahap/wizard. | P560 | Ya — bisa diuji secara struktural (coba lanjut tanpa Simpan) |
| REQ-008 | Tambah Jadwal untuk trayek >1 rute: tanggal keberangkatan harus urut; tanggal rute kedua tidak boleh sama/lebih awal dari rute pertama (contoh: pelabuhan1→2 tgl 10/08, pelabuhan2→3 tgl 12/08). | P561–P563 | Ya — butuh kasus trayek uji dengan ≥2 rute (dependency Trayek multi-pelabuhan OP-11) |
| REQ-009 | Tambah Jadwal: semua field wajib diisi. | P564 | Ya, sama catatan seperti REQ-005 — PERLU VERIFIKASI UI |
| REQ-010 | Jadwal yang berstatus ditutup tidak akan tampil di halaman pemesanan User Umum maupun Cabang. | P565 | Sebagian — field/aksi "tutup" ada di OP-12, efek "tidak tampil" diverifikasi lintas modul (UM-03 Cari Jadwal, OP-13 Jual Tiket) |
| REQ-011 | Tambah Jadwal: harus klik Simpan untuk lanjut ke proses berikutnya (Tambah Crewlist). | P566 | Ya — bagian alur wizard yang sama dengan REQ-007 |
| REQ-012 | Tambah Crewlist: wajib menginputkan crewlist dulu sebelum bisa klik tombol "Selesai". | P567 | Ya — PERLU VERIFIKASI UI apakah tombol disabled atau submit ditolak |
| REQ-013 | Kuota Internal = jatah penjualan tiket Cabang; Kuota Eksternal = jatah penjualan tiket Umum, Agen (Agen Pusat & Sub User Agen), dan Cabang (bila Kuota Internal sudah habis). | P568–P570 | Sebagian — field pembagian kuota ada & bisa diisi terpisah di OP-12; efek pengambilan kuota saat transaksi nyata diuji lintas modul OP-13 (lihat P586–P589 di `module-map-from-rules.md`, di luar rentang P552–P577) |
| REQ-014 | Perhitungan kuota bonus tiket kendaraan = (Kuota Internal + Kuota Eksternal) × jumlah bonus tiket dari golongan kendaraan terkait. | P571 | Sebagian — PERLU VERIFIKASI UI apakah rumus ini ditampilkan/dihitung otomatis di form atau harus dihitung manual oleh tester untuk verifikasi angka |
| REQ-015 | Rute Parepare–Balikpapan dan Balikpapan–Parepare punya custom bonus tiket dari backend untuk golongan "Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)" dan "Mobil Mewah/Perlakuan Khusus (III-B)" = 1 bonus tiket. | P572 | Tidak langsung — data produksi nyata utk 1 rute spesifik, hanya bisa diobservasi nilainya, jangan dibuat/diubah oleh test |
| REQ-016 | Bonus tiket kendaraan golongan III-A/III-B pada rute Parepare–Balikpapan/Balikpapan–Parepare **tidak bisa diedit**. | P573 | Sebagian — hanya observasi (field terkunci) pada rute spesifik tsb, JANGAN uji destruktif di rute produksi nyata |
| REQ-017 | Golongan tiket kendaraan & bagasi yang muncul saat membuat kuota adalah golongan yang sudah punya Harga **dan** Tarif Pass (di Master). | P574 | Ya — dependency langsung ke OP-11 Master (Harga P503–509, Tarif Pass P514–517) |
| REQ-018 | Golongan tiket penumpang yang muncul saat membuat kuota berdasarkan Kelas kapal (di Master). | P575 | Ya — dependency langsung ke OP-11 Master (Kelas P482, Kapal P491) |
| REQ-019 | Edit Kuota dan Jadwal memakai alur & field yang hampir sama dengan Tambah Kuota dan Jadwal. | P576–P577 | Ya — bandingkan field form Edit vs Tambah; kalimat sumber "hampir sama" itu sendiri ambigu, lihat Q-KJ-04 soal batasan edit setelah jadwal dipakai |

## VAL — validasi form (diperbarui dari harvest UI live 27 September 2026)

Sumber tambahan: `scenario/kuota-jadwal/kuota-jadwal_ui-inventory.md` (eksplorasi live read-only,
Operator Pusat akun #2 + Operator Cabang Pare-Pare akun #3). Baris yang sudah terverifikasi
langsung lewat observasi DOM/UI ditandai **TERVERIFIKASI**; yang masih butuh aksi submit
sungguhan (sengaja tidak dilakukan pada sesi harvest ini, sesuai batasan read-only) tetap
ditandai **PERLU VERIFIKASI UI**.

| ID | Validasi (indikasi rule) | Sumber | Catatan |
|---|---|---|---|
| VAL-001 | Tambah Kuota: semua field wajib diisi sebelum bisa Simpan/lanjut. | P558 | PERLU VERIFIKASI UI (submit tidak dicoba) — dikonfirmasi TIDAK ADA atribut HTML `required` sama sekali pada form Tambah (`[required]` count=0, lihat SCR-02 di ui-inventory); jika ada validasi wajib-isi kemungkinan JS custom (popover) atau TIDAK ADA sama sekali (pola silent, mirip FND-M-01 Master) — baru bisa dipastikan saat skenario benar-benar men-submit dengan Trayek/Kapal uji sendiri |
| VAL-002 | Tambah Jadwal: semua field wajib diisi sebelum bisa Simpan/lanjut. | P564 | PERLU VERIFIKASI UI, sama catatan seperti VAL-001 (tab Jadwal berbagi form dengan tab Kuota, sama-sama tanpa atribut `required`) |
| VAL-003 | Tambah Jadwal multi-rute: tanggal rute kedua dst tidak boleh sama/lebih awal dari rute sebelumnya. | P561–P563 | PERLU VERIFIKASI UI — trayek ≥3 pelabuhan TIDAK ditemukan di antara 24 opsi trayek yang tersedia di dropdown Tambah pada sesi harvest ini (semua sampel hanya 2 pelabuhan/1 leg); perlu trayek uji multi-rute lebih dulu sebelum validasi ini bisa diuji sama sekali |
| VAL-004 | Tambah Crewlist: tombol "Selesai" baru berfungsi/berhasil submit setelah minimal ada input crewlist. | P567 | **TERVERIFIKASI** — pada tab Crew List di Tambah (SCR-05, sebelum Kuota/Jadwal disimpan), tombol "Selesai" memiliki atribut HTML `disabled` (dikonfirmasi via DOM), didampingi teks "Pastikan Crew List sudah terisi semua". Bukan alert/popover — cukup diuji dengan assertion atribut disabled, tidak perlu submit sungguhan |
| VAL-005 | Bonus Tiket kendaraan: nilai bonus harus konsisten dengan sisa Kuota Kapal (implikasi dari "harus disesuaikan dulu"). | P559 | PERLU VERIFIKASI UI — lihat Q-KJ-01, belum jelas apakah ini validasi keras (reject) atau sekadar arahan pengisian manual; field kuota tidak menunjukkan constraint client-side yang terlihat (tidak ada `max`/`min` pada `input#dist_kendaraan*`), kemungkinan validasi (jika ada) di server saat submit |
| VAL-006 | Field bonus kuota golongan III-A/III-B pada rute Parepare–Balikpapan/Balikpapan–Parepare terkunci (read-only/disabled). | P573 | **TERVERIFIKASI** — pada jadwal existing `AUTOTEST-20260925-PPBPN-01` (id 2293, trayek Parepare-Balikpapan), field Bonus Tiket golongan "Kendaraan Kecil (III-A)" dan "Mobil Mewah (III-B)" (`input.bonus_tiket`) memiliki atribut `readonly` (dikonfirmasi via DOM, value tetap "1"). Sebagai pembanding, trayek Bakauheni-Merak (golongan penamaan lama "Golongan I/II/…") menampilkan field bonus yang SAMA TAPI EDITABLE (`readonly:false`) — mengonfirmasi kunci ini spesifik utk kombinasi golongan III-A/III-B + rute Parepare-Balikpapan/Balikpapan-Parepare, bukan perilaku umum semua golongan/rute. Detail & rute pembanding lain di ui-inventory SCR-06 |
| VAL-007 | Filter daftar Kuota dan Jadwal (bila ada, pola sama modul lain) menyaring baris sesuai input; Reset mengembalikan daftar penuh. | Belum ada di rule — pola umum (analog OP-11 VAL-010, OP-21 VAL-009) | **Field filter TERVERIFIKASI ADA**: Tgl Buat (`#Tanggal_Buat`), Nama Trayek (`#Nama_Trayek`), Nama Kapal (`select#kapal`), No. Voyage (`#Nomor_Voyage`), tombol Reset (`.reset-master`) & Filter submit. Fungsi filter-menyaring-benar dicoba 1x (filter "SURABAYA" pada Nama Trayek berhasil menyaring dari 2242 ke 230 data, hanya trayek mengandung "SURABAYA") — **efek positif TERVERIFIKASI**, efek Reset (mengembalikan ke daftar penuh) belum dicoba eksplisit |
| VAL-008 *(baru)* | Kemunculan tombol "Kirim ke Pelindo" (REQ-003) berdasarkan pelabuhan asal Surabaya. | P555 | **KEPUTUSAN USER 27 Sep 2026: TIDAK PERLU DIUJI.** Tombol `button.btn-kirim` (integrasi API eksternal ke Pelindo) cukup dicatat sebagai fitur yang ADA (referensi), tidak perlu skenario verifikasi kemunculan/klik. Jangan buat skenario yang mengklik atau memverifikasi kondisi tampil tombol ini. |
| VAL-009 *(baru)* | Trayek dropdown pada Tambah Kuota & Jadwal dibatasi sesuai kota akun (khusus akun Cabang). | Tidak ada di rule — turunan dari REQ-001/002 | **KEPUTUSAN USER 27 Sep 2026: MEMANG DESAIN SENGAJA, BUKAN BUG.** Dropdown Trayek pada akun Cabang Pare-Pare menampilkan 24 opsi yang sama dengan akun Pusat (termasuk trayek tidak terkait Pare-Pare) — dikonfirmasi user ini perilaku yang diharapkan. Boleh dijadikan skenario POSITIF (opsi trayek Cabang = opsi trayek Pusat), bukan skenario negatif/bug-candidate. |

## AC — kriteria penerimaan utama

| ID | Kriteria | REQ |
|---|---|---|
| AC-01 | Kuota & Jadwal `AUTOTEST-<tgl>-` yang dibuat akun Cabang Pare-Pare tampil di akun Cabang Pare-Pare sendiri dan di akun Pusat. | REQ-001 |
| AC-02 | Kuota & Jadwal yang dibuat Pusat untuk rute berkeberangkatan dari kota yang sama dengan Cabang Pare-Pare otomatis tampil juga di akun Cabang Pare-Pare. | REQ-002 |
| AC-03 | Tombol "Kirim ke Pelindo" hanya tampil pada jadwal dengan pelabuhan asal Surabaya; tidak tampil pada jadwal dengan pelabuhan asal lain (tanpa mengklik tombol). | REQ-003 |
| AC-04 | Form Tambah Jadwal hanya menawarkan pilihan Trayek yang sudah memiliki Tarif Pass Pelabuhan tersimpan di Master. | REQ-004, REQ-017 |
| AC-05 | Form Tambah Kuota hanya menawarkan golongan tiket kendaraan/bagasi yang sudah punya Harga+Tarif Pass, dan golongan penumpang sesuai Kelas Kapal. | REQ-017, REQ-018 |
| AC-06 | Simpan pada Tambah Kuota/Tambah Jadwal dengan field kosong TIDAK melanjutkan ke tahap berikutnya (tidak ada request POST/AJAX tersimpan) — kriteria minimum meski pesan error tidak tampil. | REQ-005, REQ-009, VAL-001, VAL-002 |
| AC-07 | Tambah Jadwal untuk trayek multi-rute dengan tanggal rute kedua ≤ tanggal rute pertama ditolak (baik dibatasi datepicker maupun ditolak saat submit). | REQ-008 |
| AC-08 | Tambah Crewlist tidak bisa diselesaikan (tombol "Selesai" tidak berhasil) tanpa input crewlist minimal satu. | REQ-012 |
| AC-09 | Jadwal `AUTOTEST-<tgl>-` yang ditutup tidak muncul lagi di hasil pencarian jadwal User Umum maupun Cabang (verifikasi lintas modul UM-03/OP-13). | REQ-010 |
| AC-10 | Field bonus kuota golongan III-A/III-B pada rute produksi Parepare–Balikpapan/Balikpapan–Parepare teramati terkunci/tidak bisa diubah (observasi saja, tanpa percobaan submit perubahan). | REQ-015, REQ-016 |
| AC-11 | Form Edit Kuota dan Jadwal menampilkan field yang sama dengan form Tambah, terisi data existing. | REQ-019 |

## Ketidakjelasan (Q-xx)

| ID | Hal | Dampak |
|---|---|---|
| Q-KJ-01 | P559: "Bonus Tiket masuk ke dalam kuota kapal, maka harus di sesuaikan dulu dengan jumlah kuota kapal" — tidak jelas apakah ini validasi sistem yang menolak input tidak sesuai (hard validation), atau sekadar instruksi/disiplin manual bagi operator saat mengisi form (tidak ditegakkan otomatis). | Skenario REQ-006/VAL-005 harus menguji dua kemungkinan saat harvest UI (coba input bonus yang melebihi sisa kuota kapal, amati apakah ditolak atau diterima), bukan mengasumsikan salah satunya. |
| Q-KJ-02 | ✅ **TERJAWAB lewat harvest UI 27 September 2026** (lihat `kuota-jadwal_ui-inventory.md` SCR-04/SCR-07): mekanisme "Tutup Jadwal" adalah dropdown **Status Jadwal** (`select`, opsi "Jadwal Tampil"/"Jadwal Tutup") pada tab **Jadwal**, satu dropdown per LEG/rute trayek, diikuti klik Simpan pada tab tsb — BUKAN tombol terpisah/aksi di Daftar. Efek "tidak tampil di halaman pesan" (P565) belum diverifikasi lintas modul (UM-03/OP-13) pada sesi ini. | Skenario REQ-010 sekarang bisa disusun konkret: pilih "Jadwal Tutup" pada jadwal uji sendiri (bukan data terpakai/produksi), Simpan, lalu verifikasi lintas modul (UM-03 Cari Jadwal, OP-13 Jual Tiket) bahwa jadwal tsb hilang dari pencarian. |
| Q-KJ-03 | ⚠️ **SEBAGIAN TERJAWAB lewat harvest UI 27 September 2026** (lihat ui-inventory SCR-06): field Bonus Tiket dgn nilai default (angka 1/2 dst tergantung golongan) TERNYATA tampil di SEMUA trayek yang dicoba (bukan eksklusif Parepare-Balikpapan) — tapi status **readonly/terkunci** HANYA ditemukan pada kombinasi golongan III-A/III-B + trayek Parepare-Balikpapan (jadwal id 2293). Trayek Bakauheni-Merak: field bonus serupa ada tapi EDITABLE. Trayek Surabaya-Balikpapan: golongan III-A malah tampil "Tidak Tersedia" (field tidak ada sama sekali). Baru 3 trayek yang disampel — generalisasi ke SEMUA trayek lain masih belum pasti. | Skenario REQ-015/016 bisa memakai jadwal `AUTOTEST-20260925-PPBPN-01` (id 2293) sebagai bukti positif observasi (field readonly), TIDAK perlu menyentuh data produksi lain untuk itu. Untuk klaim "satu-satunya pengecualian di seluruh sistem", masih perlu sampel trayek lebih banyak — jangan digeneralisasi. |
| Q-KJ-04 | P552–P577 tidak menyatakan apakah Kuota/Jadwal yang **sudah dipakai** (ada tiket terjual) bisa diedit atau dihapus — berbeda dari OP-11 Master yang eksplisit melarang hapus/edit data terpakai (P482/486/500/501/509/516). P576–P577 hanya bilang alur Edit "hampir sama" dengan Tambah, tanpa membahas status data terpakai. | Tidak boleh diasumsikan "boleh diedit/dihapus kapan saja" maupun "otomatis dilarang sama seperti Master" — kedua asumsi sama-sama tidak berdasar dari sumber. Skenario edit/hapus Jadwal/Kuota yang sudah dipakai transaksi lain WAJIB dijalankan hati-hati (data uji sendiri, bukan data terpakai skenario lain) dan hasilnya dicatat sebagai temuan baru (FND), bukan pass/fail berdasar ekspektasi yang ditebak. |
| Q-KJ-05 | P554 tidak menyebutkan apa yang terjadi bila kota keberangkatan rute yang dibuat Pusat **tidak memiliki akun Cabang terdaftar sama sekali** — apakah data tetap tersimpan hanya di akun Pusat tanpa error, atau ditolak. | Skenario REQ-002 dibatasi pada kota yang diketahui punya akun Cabang (Pare-Pare); kasus "kota tanpa cabang" tidak diuji tanpa klarifikasi lebih lanjut, dicatat sebagai gap cakupan. |
| Q-KJ-06 | P557: "Tambah jadwal trayek tampil yang sudah ada tarif pass pelabuhannya" — untuk Trayek dengan 3+ pelabuhan (multi-rute, lihat REQ-008), tidak jelas apakah syarat ini berarti **semua** pasangan rute/leg pada trayek tsb harus sudah punya Tarif Pass, atau cukup sebagian/salah satu leg saja. | Skenario REQ-004 pada trayek multi-pelabuhan harus menguji dengan Tarif Pass lengkap di semua leg lebih dulu (kondisi paling aman/pasti), dan mencatat sebagai temuan terpisah bila ternyata sebagian leg saja sudah cukup. |

## Ringkasan tumpang tindih dengan modul yang sudah dipetakan

- **OP-11 Master**: REQ-004/017/018 (dan Q-KJ-06) murni tentang **ketergantungan data**
  (Trayek+Tarif Pass, Harga+Tarif Pass, Kelas+Kapal) — bukan duplikasi REQ, karena aturan
  aslinya (P514–517, P503–509, P482, P491) sudah dianalisis sebagai REQ-024/016/001/008 di
  `scenario/master/master_analysis.md`. Di sini hanya dicatat sebagai **prasyarat urutan
  pembuatan data uji** untuk OP-12, tidak diulang sebagai REQ tersendiri. `master_analysis.md`
  REQ-029 (P520, "Data Crew masuk sebagai pilihan crew list di Kuota dan Jadwal") juga sudah
  menandai arah ketergantungan yang sama dari sisi OP-11.
- **OP-13 Jual Tiket** (belum dipetakan sebagai analysis doc, hanya baris module-map):
  REQ-013 (Kuota Internal/Eksternal, P568–570) punya pasangan pernyataan yang **diulang**
  dengan sudut pandang penjualan di P586–P589 (bagian Jual Tiket, di luar rentang P552–P577
  tugas ini). Saat OP-13 dipetakan nanti, REQ soal "kuota berkurang saat penjualan"
  sebaiknya bersumber dari P586–589 (efek transaksi), bukan diduplikasi dari P568–570 (definisi
  kuota) yang sudah dicakup di sini — supaya tidak dobel-hitung REQ untuk aturan yang sama.
- **OP-21 Pengaturan User**: tidak ada tumpang tindih substansi; disebut hanya sebagai
  referensi gaya/struktur dokumen sesuai instruksi tugas.
- **AD-15 Kuota dan Jadwal (Administrator, P1983–1986)**: dikonfirmasi Administrator hanya
  punya akses **lihat** (jadwal, crew list, kuota internal/eksternal) atas data seluruh
  operator — tidak relevan untuk pengujian portal Operator (`/partner`) yang jadi cakupan
  dokumen ini, dicatat sebagai referensi saja bila modul Administrator dipetakan terpisah.

## Perlu Verifikasi UI (ringkasan)

**Update 27 September 2026**: harvest UI read-only sudah dijalankan (Operator Pusat + Cabang
Pare-Pare) — hasil lengkap di `scenario/kuota-jadwal/kuota-jadwal_ui-inventory.md`. Status tiap
poin di bawah diperbarui; yang masih terbuka WAJIB tetap diverifikasi lagi sebelum jadi langkah
skenario final (kebanyakan butuh aksi submit sungguhan yang sengaja tidak dilakukan saat harvest).

- ✅ **SELESAI** — Lokasi & mekanisme tombol/aksi "Tutup Jadwal" (Q-KJ-02): dropdown Status Jadwal per-leg di tab Jadwal, lihat VAL update & ui-inventory SCR-04/07.
- ✅ **SELESAI** — Perilaku tombol "Selesai" pada Tambah Crewlist tanpa input (VAL-004): tombol `disabled` via atribut HTML, bukan alert.
- ✅ **SELESAI** — Status disabled/read-only field bonus kuota golongan III-A/III-B pada rute Parepare–Balikpapan/Balikpapan–Parepare (VAL-006): terkonfirmasi `readonly` via DOM pada jadwal id 2293; dibandingkan dgn 2 trayek lain (editable/tidak tersedia).
- ⚠️ **MASIH TERBUKA** — Perilaku Simpan kosong pada Tambah Kuota/Tambah Jadwal — silent atau bertampilan pesan (VAL-001, VAL-002). Dikonfirmasi TIDAK ada atribut HTML `required`; perilaku submit sungguhan belum diuji (sengaja, agar tidak membuat data nyata tanpa rencana skenario matang).
- ⚠️ **MASIH TERBUKA** — Constraint tanggal pada Tambah Jadwal multi-rute — dibatasi datepicker atau ditolak saat submit (VAL-003). Trayek uji multi-pelabuhan (≥3 port) belum ditemukan di antara 24 opsi trayek yang tersedia; perlu dicari/dibuat dulu.
- ⚠️ **MASIH TERBUKA** — Apakah field Bonus Tiket kendaraan punya validasi keras terhadap sisa Kuota Kapal (VAL-005, Q-KJ-01). Tidak ada constraint client-side (`max`/`min`) terlihat; kemungkinan validasi di server saat submit, belum diuji.
- ✅ **DITUTUP (keputusan user 27 Sep 2026)** — Tombol "Kirim ke Pelindo" (REQ-003/AC-03, VAL-008): TIDAK PERLU diuji, cukup dicatat sebagai fitur yang ada. Jangan buat skenario untuk ini.
- ✅ **DITUTUP (keputusan user 27 Sep 2026)** — Trayek dropdown Cabang tidak dibatasi kota (VAL-009, FND-KJ-03): MEMANG DESAIN SENGAJA, bukan bug. Boleh jadi skenario positif (opsi Cabang = opsi Pusat).
- Perilaku Edit Kuota/Jadwal pada data yang sudah dipakai transaksi lain (Q-KJ-04) — BELUM diuji (di luar cakupan harvest read-only ini, tetap butuh kehati-hatian khusus saat scenario-writing).
- ✅ **Field filter daftar Kuota dan Jadwal (VAL-007) ADA dan berfungsi** (dicoba filter Nama Trayek "SURABAYA": 2242 → 230 data) — lihat ui-inventory SCR-01.
