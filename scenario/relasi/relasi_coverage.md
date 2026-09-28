# OP-16/OP-17 Daftar Relasi (Relasi Pelanggan + Relasi Agen) — Coverage

Total 22 skenario (`relasi_scenarios.json`): positive 13, negative 7, edge 2; high 9, medium 12,
low 1. Tidak ada `stress`. Submodul **Relasi Pelanggan** = SCN-0001..0011 (11 skenario);
submodul **Relasi Agen** = SCN-0012..0022 (11 skenario).

## Ringkasan per submodul

| Submodul | positive | negative | edge | high | medium | low | Total |
|---|---|---|---|---|---|---|---|
| Relasi Pelanggan (SCN-0001..0011) | 7 | 3 | 1 | 4 | 6 | 1 | 11 |
| Relasi Agen (SCN-0012..0022) | 6 | 4 | 1 | 5 | 6 | 0 | 11 |
| **Total modul** | **13** | **7** | **2** | **9** | **12** | **1** | **22** |

## Temuan kunci yang mendasari desain skenario (WAJIB dipatuhi)

| Topik | Temuan | Dampak pada dokumen ini |
|---|---|---|
| Simetri Relasi Pelanggan | Pusat = Cabang PERSIS (58/58 data, semua tombol Tambah/Edit/Hapus/Tambah Diskon identik) — Q-RA-04 tertutup, FND-RL-08 | SCN-0001 dibuat sebagai skenario POSITIF khusus untuk membandingkan Pusat vs Cabang; SCN-0002 menegaskan ulang dengan data buatan sendiri |
| Asimetri Relasi Agen | Pusat diblokir SERVER-SIDE (bukan cuma UI) dari akses tulis — REQ-AGN-01/P727, FND-RL-07 | SCN-0012 dibuat sebagai skenario NEGATIVE prioritas HIGH, menguji 3 URL langsung (tambahagen/editagen/tambahkomisiagen) |
| FND-RL-01 (wording alert duplikat Komisi beda dari rule) | Teks aktual "Komisi yang Anda inputkan sudah ada di database" ≠ kutipan rule "Komisi sudah ada di database" | SCN-0019 memverifikasi teks AKTUAL dengan partial match, bugCandidate: FND-RL-01, untuk dikonfirmasi bug-triager |
| FND-RL-02 (2 varian Bagasi terpisah) | Rule sebut "Bagasi" tunggal, UI punya 'Bagasi Kendaraan' & 'Bagasi Penumpang' | SCN-0007 menguji KEDUA varian eksplisit, bugCandidate: FND-RL-02 |
| FND-RL-04 (field Agen tak disebut rule) | Kata Sandi, upload dokumen, Informasi Rekening WAJIB diisi tapi tidak ada di P726-737 | SCN-0013 mengisi SEMUA field ini (observasional, bukan asumsi validasi spesifik), bugCandidate: FND-RL-04; SCN-0014 menguji validasi Kata Sandi |
| Q-RA-02 (uniqueness lintas kota) | Butuh akun Cabang kota lain, tidak tersedia | SCN-0015 menguji scope 'Cabang sendiri' penuh, dengan blockedUnless-note eksplisit untuk sisi lintas-kota — TIDAK ada skenario terpisah karena tidak ada langkah tambahan yang bisa dijalankan tanpa akun tsb |
| Q-RA-03 (efek komisi transaksi nyata) | Butuh portal /agen (AG-05), belum dipetakan | SCN-0022 dibuat sebagai skenario BLOCKED eksplisit (pola sama SCN-0007/SCN-0015 di kuota-jadwal_scenarios.json) |
| zemPopover auto-hilang ~1000ms | Popover harus dibaca sinkron dengan klik, bukan setelah await terpisah | Dicatat di steps SCN-0003/SCN-0004/SCN-0014/SCN-0015 sebagai peringatan teknis eksplisit |
| Alert/confirm duplikat pakai native dialog | BUKAN SweetAlert2/zemPopover | Dicatat di steps SCN-0006 (alert Diskon) dan SCN-0018/SCN-0019 (confirm+alert Komisi) — WAJIB page.on('dialog') handler |

## Matriks REQ/VAL/AC → Skenario — Relasi Pelanggan (OP-16)

| ID | Skenario | Cakupan | Catatan |
|---|---|---|---|
| REQ-PEL-01 | — | **TIDAK DIUJI** — cross-module (OP-13 Jual Tiket), di luar cakupan OP-16 murni | Field itu sendiri tersimpan & diverifikasi di SCN-0002, tapi efek metode pembayaran di transaksi tidak diuji di sini |
| REQ-PEL-02 | SCN-0002 | E2E (create) | Field lengkap form Tambah Pelanggan |
| REQ-PEL-03 | SCN-0003 | Negative (validasi) | VAL-PEL-01; AC-PEL-01 |
| REQ-PEL-04 | SCN-0009 | Observasi data existing | FND-RL-05; Q-RP-04 tertutup |
| REQ-PEL-05 | SCN-0002 | E2E (create) | Jenis Identitas KTP/SIM/Passport |
| REQ-PEL-06 | SCN-0002 | Sebagian — UI (create) | Dropdown Kota diobservasi, sumber data admin /adminprahu TIDAK diverifikasi cross-portal |
| REQ-PEL-07 | — | **TIDAK DIUJI** — cross-module (OP-13), di luar cakupan | Sama alasan REQ-PEL-01 |
| REQ-PEL-08 | — | **TIDAK DIUJI** — cross-module (OP-13), di luar cakupan | Efek TOP tidak dicentang pada pilihan metode bayar hanya bisa diverifikasi di Jual Tiket |
| REQ-PEL-09 | — | **TIDAK DIUJI** — cross-module (OP-13), di luar cakupan | Sama alasan REQ-PEL-08 |
| REQ-PEL-10 | SCN-0002 | Sebagian — field level | VAL-PEL-03; efek kalkulasi tempo piutang (OP-15) TIDAK diuji, cross-module |
| REQ-PEL-11 | SCN-0005 | E2E (create Diskon) | Jenis persentase diverifikasi; nominal Rupiah tidak diulang eksplisit (format Rupiah sudah tercakup logikanya via REQ-PEL-18) |
| REQ-PEL-12 | SCN-0005 | E2E | Rute+jenis tiket+golongan+kelas |
| REQ-PEL-13 | — | **TIDAK DIUJI** — cross-module (OP-13), di luar cakupan | Efek diskon otomatis di halaman pembayaran |
| REQ-PEL-14 | — | **TIDAK DIUJI** — cross-module (OP-13), di luar cakupan | Diskon tidak sesuai kriteria tidak berlaku |
| REQ-PEL-15 | SCN-0006 | Negative (duplikat) | AC-PEL-05; rujuk `master_analysis.md` REQ-018/019/020, tidak diulang sebagai REQ baru |
| REQ-PEL-16 | SCN-0005 | E2E | Golongan/Kelas menyesuaikan Jenis Tiket |
| REQ-PEL-17 | SCN-0007 | E2E | VAL-PEL-05; AC-PEL-07; FND-RL-02 (2 varian Bagasi) |
| REQ-PEL-18 | SCN-0005 | E2E | Label '%'/format Rupiah |
| REQ-PEL-19 | SCN-0008 | Edge (client+server) | VAL-PEL-04; AC-PEL-06; hasil bypass server-side dicatat apa adanya |
| REQ-PEL-20 | — | **TIDAK DIUJI** — cross-module (OP-13), butuh order nyata | Q-RP-01 (basis diskon order campuran) tetap terbuka, tidak ditebak |
| REQ-PEL-21 | — | **TIDAK DIUJI** — cross-module (OP-21 Petugas Scan), relasi persis ambigu | Q-RP-03 tetap terbuka |
| VAL-PEL-01 | SCN-0003 | | |
| VAL-PEL-02 | SCN-0004 | | |
| VAL-PEL-03 | SCN-0002 | | Q-RP-02 tertutup |
| VAL-PEL-04 | SCN-0008 | | |
| VAL-PEL-05 | SCN-0007 | | |
| VAL-PEL-06 | SCN-0010 | | |
| AC-PEL-01 | SCN-0003 | | |
| AC-PEL-02 | — | **TIDAK DIUJI** — cross-module (OP-13) | Tergantung REQ-PEL-08 |
| AC-PEL-03 | — | **TIDAK DIUJI** — cross-module (OP-13) | Tergantung REQ-PEL-09 |
| AC-PEL-04 | — | **TIDAK DIUJI** — cross-module (OP-13) | Tergantung REQ-PEL-13/14 |
| AC-PEL-05 | SCN-0006 | | |
| AC-PEL-06 | SCN-0008 | | |
| AC-PEL-07 | SCN-0007 | | |

**REQ-PEL ter-cover: 13 dari 21** (02,03,04,05,06\*,10\*,11,12,15,16,17,18,19 — \* = sebagian).
**REQ-PEL tidak diuji: 8 dari 21** (01,07,08,09,13,14,20,21 — SEMUA karena cross-module OP-13/OP-15/OP-21,
di luar cakupan submodul OP-16 murni, bukan kegagalan cakupan).
**AC-PEL ter-cover: 4 dari 7** (01,05,06,07); **tidak diuji: 3 dari 7** (02,03,04 — cross-module OP-13).
**VAL-PEL ter-cover: 6 dari 6.**

## Matriks REQ/VAL/AC → Skenario — Relasi Agen (OP-17)

| ID | Skenario | Cakupan | Catatan |
|---|---|---|---|
| REQ-AGN-01 | SCN-0012, SCN-0013 | E2E (negative Pusat + positive Cabang) | AC-AGN-01; FND-RL-07 dikonfirmasi ulang; prioritas HIGH eksplisit |
| REQ-AGN-02 | SCN-0013, SCN-0014 | E2E + Negative | VAL-AGN-01; Q-RA-01 tertutup |
| REQ-AGN-03 | SCN-0015 | Negative (sebagian) | VAL-AGN-02; AC-AGN-02; scope 'Cabang sendiri' PENUH, scope lintas-kota lihat Q-RA-02 |
| REQ-AGN-04 | SCN-0013 | Sebagian | Pusat lihat semua + Cabang pembuat lihat milik sendiri terverifikasi; sisi 'Cabang lain SEKOTA' TIDAK BISA DIUJI (hanya 1 akun Cabang) |
| REQ-AGN-05 | SCN-0013 | E2E | WAJIB kontakTestNotifikasi/kontakTestWhatsapp; AC-AGN-04 |
| REQ-AGN-06 | SCN-0016 | E2E | AC-AGN-04; verifikasi notifikasi sebatas observasi tidak langsung |
| REQ-AGN-07 | SCN-0017 | E2E (reaktivasi) | AC-AGN-04; sama keterbatasan verifikasi notifikasi seperti REQ-AGN-06 |
| REQ-AGN-08 | SCN-0018 | E2E | Komisi selalu persentase |
| REQ-AGN-09 | SCN-0022 | **BLOCKED** | Field-level (kolom form) sudah tercakup di SCN-0018; efek transaksi nyata portal /agen (AG-05) di luar cakupan, Q-RA-03 |
| REQ-AGN-10 | SCN-0019 | Negative (duplikat) | VAL-AGN-03; AC-AGN-05; FND-RL-01 (wording beda dari rule) |
| REQ-AGN-11 | SCN-0018 | Sebagian | Sama keterbatasan REQ-AGN-04 (butuh Cabang kota sama kedua) |
| VAL-AGN-01 | SCN-0014 | | |
| VAL-AGN-02 | SCN-0015 | | |
| VAL-AGN-03 | SCN-0019 | | |
| VAL-AGN-04 | SCN-0020 | | Pengujian fungsional PERTAMA (sebelumnya hanya struktur field terkonfirmasi) |
| AC-AGN-01 | SCN-0012, SCN-0013 | | |
| AC-AGN-02 | SCN-0015 | | |
| AC-AGN-03 | SCN-0013 | Sebagian | Cross-city sekota TIDAK BISA DIUJI PENUH |
| AC-AGN-04 | SCN-0013, SCN-0016, SCN-0017 | | Gabungan REQ-AGN-05/06/07 |
| AC-AGN-05 | SCN-0019 | | |
| AC-AGN-06 | SCN-0018 | Sebagian | Sama keterbatasan AC-AGN-03 |

**REQ-AGN ter-cover: 10 dari 11 dieksekusi penuh/sebagian** (01,02,03\*,04\*,05,06,07,08,10,11\* — \* = sebagian);
**REQ-AGN-09 direpresentasikan lewat skenario BLOCKED** (SCN-0022) — TIDAK ada REQ Agen yang benar-benar tanpa skenario sama sekali.
**AC-AGN ter-cover: 6 dari 6** (2 di antaranya sebagian: AC-AGN-03, AC-AGN-06).
**VAL-AGN ter-cover: 4 dari 4.**

## Ketidakjelasan (Q-xx) — status penanganan

| ID | Ditangani di | Pendekatan |
|---|---|---|
| Q-RP-01 | — tidak diuji | Basis diskon untuk order campuran butuh transaksi OP-13 nyata, di luar cakupan; TIDAK ditebak |
| Q-RP-02 | SCN-0002 | **TERTUTUP** sebelum penulisan skenario (harvest UI): field Lama Pembayaran ada di form yang sama, kondisional pada checkbox TOP — VAL-PEL-03 |
| Q-RP-03 | — tidak diuji | Relasi email/WA Pelanggan dengan Petugas Scan (OP-21) tetap ambigu, butuh cross-module di luar cakupan |
| Q-RP-04 | SCN-0009 | **TERTUTUP**: environment demo memang punya data pelanggan lama (CV Karya Bersama id 3701) |
| Q-RA-01 | SCN-0014 (via VAL-AGN-01) | **TERTUTUP sebelum penulisan skenario**: pola pesan error Agen identik Pelanggan (per-field zemPopover) |
| Q-RA-02 | SCN-0015 (blockedUnless note) | Scope lintas-kota TIDAK terjawab — butuh akun Cabang kota lain, tidak ditebak |
| Q-RA-03 | SCN-0022 | **BLOCKED** — butuh portal /agen (AG-05) dipetakan terpisah |
| Q-RA-04 | SCN-0001 (via reconfirm FND-RL-08) | **TERTUTUP sebelum penulisan skenario**: Relasi Pelanggan SIMETRIS PENUH Pusat=Cabang |

## Temuan (FND-RL-xx) — status verifikasi

| ID | Ditangani di | Status |
|---|---|---|
| FND-RL-01 (wording alert duplikat Komisi) | SCN-0019 | bugCandidate ditandai di scenarios.json — kandidat bug-dokumentasi/wording, untuk dikonfirmasi bug-triager |
| FND-RL-02 (2 varian Bagasi terpisah) | SCN-0007 | bugCandidate ditandai — kandidat gap-dokumentasi, untuk dikonfirmasi bug-triager |
| FND-RL-03 (lokasi field Lama Pembayaran) | SCN-0002 | **DITUTUP** sebelum penulisan skenario — bukan gap, VAL-PEL-03 terverifikasi penuh, tidak perlu bugCandidate |
| FND-RL-04 (field Agen tak disebut rule) | SCN-0013, SCN-0014 | bugCandidate ditandai di SCN-0013 — kandidat gap-dokumentasi PENTING (field WAJIB tapi tidak ada di rule), untuk dikonfirmasi bug-triager |
| FND-RL-05 (data pelanggan lama ada di demo) | SCN-0009 | **DITUTUP** — bukan gap, cakupan REQ-PEL-04 aman diuji, tidak perlu bugCandidate |
| FND-RL-06 (id tombol Simpan Edit Pelanggan sisa template) | — tidak ada skenario | Catatan strategi selector (bukan bug bisnis) — lihat `shared/selector-map-relasi.md` § Rekomendasi data-testid |
| FND-RL-07 (Pusat diblokir server-side Relasi Agen) | SCN-0012 | **DITUTUP** — bukan bug, justru desain akses solid, dikonfirmasi ulang lewat akses URL langsung, tidak perlu bugCandidate |
| FND-RL-08 (Relasi Pelanggan simetris penuh) | SCN-0001 | **DITUTUP** — bukan bug, dikonfirmasi ulang dengan data existing (SCN-0001) dan data buatan sendiri (SCN-0002), tidak perlu bugCandidate |

## Data uji: yang MEMBUAT dan yang MENGHAPUS

Mengikuti pola OP-12 Kuota & Jadwal (cleanup dalam rangkaian skenario sendiri), BUKAN pola OP-11
Master (data referensi permanen, tidak dihapus) — modul ini punya aksi Hapus Pelanggan/Hapus Agen
yang berfungsi, dan seluruh data uji berikut TIDAK PERNAH dipakai transaksi lintas modul (OP-13
Jual Tiket, OP-15 Piutang, AG-05 Jual Tiket Agen) apa pun sepanjang rangkaian test ini, sehingga
AMAN dihapus di akhir:

**Relasi Pelanggan:**
- **SCN-0002** membuat Pelanggan `AUTOTEST-20260927-PEL-CABANG` — dipakai ulang oleh SCN-0004
  (uji duplikat, tidak mengubah), SCN-0005/0007 (menambah baris Diskon), SCN-0006/0008
  (uji negative/edge pada Diskon, SCN-0008 punya cleanup kontingensi sendiri jika bypass
  server-side ternyata tersimpan) — **dihapus di SCN-0011** (beserta seluruh Diskon terkait).

**Relasi Agen:**
- **SCN-0013** membuat Agen `AUTOTEST-20260927-AGN-01` (status Aktif) — dipakai ulang oleh
  SCN-0014 (validasi, tidak mengubah), SCN-0015 (uji duplikat email/WA, tidak mengubah),
  SCN-0018 (menambah 1 baris Komisi), SCN-0019 (uji duplikat Komisi, tidak mengubah) —
  **dihapus di SCN-0021** (beserta Komisi terkait).
- **SCN-0016** membuat Agen `AUTOTEST-20260927-AGN-02` (status Tidak Aktif) — diedit
  (reaktivasi ke Aktif) di **SCN-0017** — **dihapus di SCN-0021**.

**Observasional murni (TIDAK membuat data):** SCN-0001, SCN-0003, SCN-0004, SCN-0006, SCN-0009,
SCN-0010, SCN-0012, SCN-0014, SCN-0015, SCN-0020, SCN-0022.

## Tidak tercakup (ringkasan alasan)

- **REQ-PEL-01/07/08/09/13/14/20, AC-PEL-02/03/04** (8+3 item): cross-module OP-13 Jual Tiket,
  di luar cakupan submodul OP-16 murni — analysis.md sendiri secara eksplisit menandai ini
  "Tidak di OP-16 murni" untuk setiap item.
- **REQ-PEL-21**: cross-module OP-21 Petugas Scan, relasi persis dengan data Relasi Pelanggan
  masih ambigu (Q-RP-03).
- **Q-RP-01**: basis perhitungan diskon untuk order campuran, butuh transaksi OP-13 nyata.
- **Q-RA-02**: scope lintas-kota validasi unique Agen, butuh akun Operator Cabang kota lain
  (tidak ada di `config/env.md`) — ditangani sebagai blockedUnless-note di SCN-0015, bukan
  skenario terpisah karena tidak ada langkah tambahan yang bisa dijalankan tanpa akun tsb.
- **REQ-AGN-09, Q-RA-03**: efek Komisi Agen pada transaksi nyata, butuh portal `/agen` (AG-05)
  yang belum dipetakan — direpresentasikan sebagai skenario BLOCKED (SCN-0022), bukan diabaikan
  sepenuhnya.
- **Visibilitas "Cabang lain SEKOTA"** (bagian dari REQ-AGN-04/REQ-AGN-11, AC-AGN-03/AC-AGN-06):
  hanya ada 1 akun Cabang (Pare-Pare) di `config/env.md` — pola keterbatasan IDENTIK dengan
  Q-KJ-05 di `kuota-jadwal_coverage.md` (tidak diberi skenario terpisah, dicatat sebagai gap
  cakupan permanen sampai akun kedua tersedia).
