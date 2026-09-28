# OP-12 Kuota dan Jadwal — Coverage

Total 15 skenario (`kuota-jadwal_scenarios.json`): positive 9, negative 2, edge 4; high 7, medium 7,
low 1. Tidak ada `stress`.

2 skenario **MEMBUAT DATA BARU** (Kuota, Jadwal, Crewlist) berprefix `AUTOTEST-20260927-` pada jadwal
keberangkatan sejauh mungkin di masa depan, dan **dihapus (cleanup) di akhir rangkaiannya sendiri**
karena tidak pernah dipakai transaksi apa pun:
- **SCN-0001** (Cabang Pare-Pare, Nomor Voyage `AUTOTEST-20260927-KJ-CABANG`) — dipakai ulang oleh
  SCN-0002 (perbandingan Edit) dan SCN-0003 (Tutup Jadwal + cross-module + **Hapus di akhir SCN-0003**).
- **SCN-0004** (Pusat, Nomor Voyage `AUTOTEST-20260927-KJ-PUSAT`) — **Hapus di akhir skenario yang sama**.

2 skenario **BERPOTENSI membuat data** hanya sebagai efek samping observasi (VAL-001/002, perilaku
Simpan-kosong belum diketahui saat harvest) — bila ternyata tersimpan, langkah cleanup Hapus SUDAH
termasuk dalam skenario itu sendiri:
- **SCN-0005** (Nomor Voyage `AUTOTEST-20260927-EMPTY-KUOTA`)
- **SCN-0006** (Nomor Voyage `AUTOTEST-20260927-EMPTY-JADWAL`)

Sisanya (SCN-0002, SCN-0003 langkah observasi, SCN-0007 sampai SCN-0015 kecuali disebut di atas)
bersifat **OBSERVASIONAL/read-only** pada data existing (Master atau Daftar Kuota & Jadwal), tanpa
membuat entitas baru.

2 skenario berstatus **BLOCKED** pada penulisan dokumen ini (dieksekusi tetap dicoba, tapi kemungkinan
besar berakhir `blocked` sesuai catatan masing-masing, bukan ditebak hasilnya):
- **SCN-0007** (REQ-008/VAL-003) — trayek uji ≥3 pelabuhan yang sudah punya Tarif Pass belum ditemukan.
- **SCN-0015** (Q-KJ-04) — belum ada Kuota/Jadwal uji milik run sendiri yang sudah dipakai transaksi
  terkontrol; data existing yang sudah terpakai berisiko diedit.

## Keputusan user 27 September 2026 (WAJIB dipatuhi)

| Topik | Keputusan | Dampak pada dokumen ini |
|---|---|---|
| Tombol "Kirim ke Pelindo" (REQ-003, AC-03, VAL-008, FND-KJ-02) | **TIDAK PERLU DIUJI SAMA SEKALI** — bukan cuma dilarang klik, verifikasi kemunculannya pun tidak diminta. | TIDAK ADA skenario apa pun yang menyentuh `.btn-kirim`/`button.btn-kirim`. Dicatat di baris REQ-003/AC-03/VAL-008 tabel di bawah sebagai "tidak diuji — keputusan user, integrasi eksternal di luar cakupan". |
| Dropdown Trayek Cabang tidak difilter kota (FND-KJ-03, VAL-009) | **MEMANG DESAIN SENGAJA**, bukan bug. | SCN-0011 dibuat sebagai skenario **POSITIF** (opsi Trayek Cabang = opsi Trayek Pusat), bukan negative/bug-candidate. |

## Matriks REQ/VAL/AC → Skenario

| REQ/VAL/AC | Skenario | Cakupan | Catatan |
|---|---|---|---|
| REQ-001 | SCN-0001 | E2E (create Cabang) | AC-01; MEMBUAT DATA BARU, dihapus di SCN-0003 |
| REQ-002 | SCN-0004 | E2E (create Pusat) | AC-02; MEMBUAT DATA BARU, dihapus di skenario sama |
| REQ-003 | — | **TIDAK DIUJI — keputusan user 27 Sep 2026, integrasi eksternal (Pelindo) di luar cakupan** | Lihat VAL-008/FND-KJ-02; DILARANG membuat skenario apa pun terkait ini |
| REQ-004 | SCN-0013 | UI (cross-reference Master) | AC-04; tanpa entitas baru |
| REQ-005 | SCN-0005 | UI (observasional) | VAL-001; AC-06; hasil TIDAK diasumsikan sebelum eksekusi |
| REQ-006 | SCN-0004 | E2E (edge case bonus vs kuota) | VAL-005; Q-KJ-01; hasil dicatat apa adanya (ditolak/diterima) |
| REQ-007 | SCN-0001 | E2E (wizard bertahap) | struktural, bagian dari create Cabang |
| REQ-008 | SCN-0007 | **BLOCKED** | VAL-003; AC-07; trayek uji ≥3 pelabuhan tidak ditemukan, TIDAK membuat Trayek baru di Master |
| REQ-009 | SCN-0006 | UI (observasional) | VAL-002; AC-06; hasil TIDAK diasumsikan sebelum eksekusi |
| REQ-010 | SCN-0003 | E2E (create+tutup+cross-module+cleanup) | AC-09; menjawab Q-KJ-02 (mekanisme dropdown Status Jadwal) |
| REQ-011 | SCN-0001 | E2E (wizard bertahap) | struktural, bagian dari create Cabang |
| REQ-012 | SCN-0001, SCN-0008 | E2E + assertion | AC-08; VAL-004 (SCN-0008, sudah TERVERIFIKASI via DOM, tidak perlu submit penuh) |
| REQ-013 | SCN-0001, SCN-0013 | E2E + UI | kolom Kuota Internal/Eksternal terpisah |
| REQ-014 | SCN-0014 | UI (observasional) | formula bonus kendaraan; hasil TIDAK diasumsikan (auto-calc atau manual) |
| REQ-015 | SCN-0009 | E2E (observasi data existing) | VAL-006; AC-10; hanya observasi, TIDAK diedit |
| REQ-016 | SCN-0009 | E2E (observasi data existing) | VAL-006; AC-10; field readonly terkonfirmasi ulang |
| REQ-017 | SCN-0001, SCN-0013 | E2E + UI | AC-04/AC-05; dependency Master Harga+Tarif Pass |
| REQ-018 | SCN-0001, SCN-0013 | E2E + UI | AC-04/AC-05; dependency Master Kelas Kapal |
| REQ-019 | SCN-0002 | E2E (read-only, data sendiri) | AC-11 |
| VAL-001 | SCN-0005 | | observasional, bukan asumsi FND-M-01-style Master |
| VAL-002 | SCN-0006 | | observasional, bukan asumsi FND-M-01-style Master |
| VAL-003 | SCN-0007 | **BLOCKED** | trayek uji ≥3 pelabuhan tidak ditemukan |
| VAL-004 | SCN-0008 | assertion (disabled attribute) | **TERVERIFIKASI** saat harvest, tidak perlu submit penuh |
| VAL-005 | SCN-0004 | E2E (edge case) | Q-KJ-01; hasil dicatat apa adanya |
| VAL-006 | SCN-0009 | assertion (readonly attribute) | **TERVERIFIKASI** saat harvest, tidak perlu submit penuh; turut menambah sampel Q-KJ-03 |
| VAL-007 | SCN-0012 | UI (filter+reset) | efek filter sudah terverifikasi saat harvest, efek Reset dikonfirmasi di sini |
| VAL-008 | — | **TIDAK DIUJI — keputusan user 27 Sep 2026** | sama seperti REQ-003/AC-03 |
| VAL-009 | SCN-0011 | UI (positive, perbandingan opsi) | FND-KJ-03; **desain sengaja**, bukan bug-candidate |
| AC-01 | SCN-0001 | | |
| AC-02 | SCN-0004 | | |
| AC-03 | — | **TIDAK DIUJI — keputusan user 27 Sep 2026** | sama seperti REQ-003 |
| AC-04 | SCN-0013 | | |
| AC-05 | SCN-0013 | | |
| AC-06 | SCN-0005, SCN-0006 | | kriteria minimum "tidak ada POST tersimpan" — diverifikasi observasional, bisa jadi hasilnya melanggar AC-06 (dicatat sebagai temuan, bukan diasumsikan lolos) |
| AC-07 | SCN-0007 | **BLOCKED** | |
| AC-08 | SCN-0008 | | sama dengan VAL-004 |
| AC-09 | SCN-0003 | | |
| AC-10 | SCN-0009 | | |
| AC-11 | SCN-0002 | | |

## Ketidakjelasan (Q-KJ-xx) — status penanganan

| ID | Ditangani di | Pendekatan |
|---|---|---|
| Q-KJ-01 | SCN-0004 (REQ-006/VAL-005) | Diuji sebagai edge case dalam alur create Pusat; hasil (ditolak/diterima) dicatat apa adanya, tidak ditebak |
| Q-KJ-02 | SCN-0003 (REQ-010) | **TERJAWAB sebelum penulisan skenario** (harvest UI): mekanisme adalah dropdown Status Jadwal per-leg pada tab Jadwal; SCN-0003 memverifikasi efeknya lintas modul |
| Q-KJ-03 | SCN-0009 (VAL-006) | Sebagian terjawab (readonly khusus III-A/III-B + Parepare-Balikpapan, bukan perilaku umum); SCN-0009 menambah 1 sampel pembanding (Bakauheni-Merak), tidak menggeneralisasi lebih jauh |
| Q-KJ-04 | SCN-0015 | **BLOCKED** — belum ada data uji milik run sendiri yang aman diedit (sudah dipakai transaksi terkontrol); tidak diasumsikan boleh/dilarang |
| Q-KJ-05 | — tidak diuji | Kasus "kota tanpa akun Cabang terdaftar" tidak bisa diverifikasi dengan akun yang tersedia (hanya ada 1 akun Cabang, Pare-Pare) — dicatat sebagai gap cakupan, konsisten catatan `kuota-jadwal_analysis.md` |
| Q-KJ-06 | SCN-0007 (catatan) | Terkait erat dengan blocker VAL-003/REQ-008 — belum bisa dijawab tanpa trayek uji multi-pelabuhan yang sudah punya Tarif Pass |

## Temuan (FND-KJ-xx) — status verifikasi

| ID | Ditangani di | Status |
|---|---|---|
| FND-KJ-01 | SCN-0010 | Kandidat gap desain (panel "Lihat" kosong), pola sama FND-M-04 Master — diverifikasi ulang saat eksekusi, belum verdict akhir |
| FND-KJ-02 (Kirim ke Pelindo) | — tidak ada skenario | **DITUTUP sesuai keputusan user 27 Sep 2026** — tidak diuji sama sekali, dicatat sebagai fitur yang ada (referensi), integrasi eksternal di luar cakupan |
| FND-KJ-03 (Trayek dropdown Cabang tidak difilter kota) | SCN-0011 | **DITUTUP sesuai keputusan user 27 Sep 2026** — desain sengaja, dijadikan skenario POSITIF (bukan negative/bug-candidate) |
| FND-KJ-04 (elemen tanpa atribut `name`) | — tidak ada skenario | Catatan strategi selector (bukan bug bisnis) — lihat `shared/selector-map-kuota-jadwal.md` § Rekomendasi data-testid |
| FND-KJ-05 (`name="trayek"` salah/duplikat pada beberapa input) | — tidak ada skenario | Kosmetik/kode, bukan bug bisnis — lihat `shared/selector-map-kuota-jadwal.md` § Rekomendasi data-testid |

Tidak tercakup: REQ-003/AC-03/VAL-008 (Kirim ke Pelindo — **keputusan user, tidak diuji sama sekali**),
Q-KJ-05 (kota tanpa akun Cabang, keterbatasan data uji). REQ-008/VAL-003/AC-07 dan Q-KJ-04 berstatus
BLOCKED pada penulisan dokumen ini (skenario dibuat dan tetap dicoba dieksekusi, tapi kemungkinan besar
berakhir `blocked` sesuai prasyarat data yang belum terpenuhi — jangan menebak hasilnya sebelum
prasyarat tersedia).

## Ringkasan risiko data (penting untuk eksekusi)

- **Data yang dibuat dan dihapus dalam rangkaian test yang sama** (aman, tidak tertinggal permanen):
  `AUTOTEST-20260927-KJ-CABANG` (SCN-0001 → dipakai SCN-0002/0003 → dihapus di akhir SCN-0003),
  `AUTOTEST-20260927-KJ-PUSAT` (SCN-0004, dihapus di akhir skenario yang sama). Berbeda dari Master
  (Trayek+Harga permanen tidak bisa dihapus) — modul ini punya aksi Hapus Kuota & Jadwal yang berfungsi
  selama data belum dipakai transaksi apa pun.
- **Data yang berpotensi tertinggal jika perilaku ternyata tidak silent** (VAL-001/002, SCN-0005/0006,
  Nomor Voyage `AUTOTEST-20260927-EMPTY-KUOTA`/`-EMPTY-JADWAL`) — skenario SUDAH menyertakan langkah
  cleanup kontingensi bila ternyata tersimpan.
- **Data existing yang TIDAK BOLEH diedit/dihapus** dalam modul ini: `AUTOTEST-20260925-PPBPN-01`
  (id 2293, trayek Parepare-Balikpapan) — sudah dipakai transaksi OP-13 nyata (Q-KJ-04); SCN-0009 HANYA
  membuka halaman Edit untuk membaca atribut `readonly`, TIDAK pernah menyimpan perubahan.
  Trayek/Kapal produksi lain yang dipilih di SCN-0005/0006/0008/0009/0013/0014 hanya dipilih dari
  dropdown untuk membuka form (read), tidak dimaksudkan untuk benar-benar tersimpan/diubah.
- **Trayek yang TIDAK BOLEH dibuat**: Trayek uji ≥3 pelabuhan untuk SCN-0007 (REQ-008/VAL-003) —
  instruksi eksplisit melarang membuat Trayek baru di Master OP-11 untuk memenuhi prasyarat modul ini;
  skenario tetap dijalankan sebagai BLOCKED sampai trayek yang sesuai tersedia secara alami.
- **Butuh koordinasi lintas modul sebelum bisa dijalankan penuh**: SCN-0003 (cross-check OP-13/UM-03
  untuk efek Tutup Jadwal), SCN-0015/Q-KJ-04 (butuh Jadwal uji milik run sendiri yang sudah dipakai
  transaksi terkontrol — disarankan dikoordinasikan dengan eksekusi modul OP-13 pada run berikutnya).
