# OP-11 Master — Coverage

Total 40 skenario (`master_scenarios.json`): positive 17, negative 14, edge 9; high 15, medium 23, low 2. Tidak ada `stress`.

3 skenario ditandai **[SEKALI PAKAI — DATA PERMANEN, TIDAK BISA DIBERSIHKAN]**: SCN-0015 (membuat Trayek+Harga
AUTOTEST-20260927-TRAYEK-AC04), plus SCN-0017 dan SCN-0019 yang menambah baris Harga permanen pada entitas yang sama
(tidak menambah entitas permanen baru, hanya menumpuk pada yang sudah ada). SCN-0021 dan SCN-0023 memakai ulang
entitas ini tetapi tidak menambah data permanen baru (SCN-0023 sengaja berhenti sebelum Simpan akhir).

3 skenario ditandai **[MEMBUTUHKAN IZIN EKSPLISIT USER SEBELUM DIEKSEKUSI]**: SCN-0030 (REQ-039), SCN-0031 (REQ-040),
SCN-0032 (REQ-043) — ketiganya hanya memverifikasi tampilan form (field ada, nilai saat ini) TANPA submit; menguji
alert penolakan sungguhan (P533/P534/P538) membutuhkan Simpan nyata pada setting tenant Denda Pembatalan, dilarang
tanpa izin + catatan di `shared/decisions.md` sesuai `docs/agent-guide.md`.

| REQ/VAL/AC | Skenario | Cakupan | Catatan |
|---|---|---|---|
| REQ-001 | SCN-0001 | E2E (data existing) | AC-01; tanpa entitas baru |
| REQ-002 | SCN-0004 | UI (silent submit) | ⚑ FND-M-01; AC-11 |
| REQ-003 | SCN-0005 | observasional | ⚑ Q-M-01 — matching longgar, tidak menebak field |
| REQ-004 | SCN-0003 | E2E (data existing) | AC-02; tanpa entitas baru; hasil bisa blocked bila tidak ada Golongan terpakai di Kapal (lihat catatan Q di scenarios.json) |
| REQ-005 | SCN-0006 | UI (opsi select) | |
| REQ-006 | SCN-0007 | E2E (create+cleanup) | AC-03; Golongan AUTOTEST tidak dipakai submodul lain → aman dihapus |
| REQ-007 | SCN-0007 | E2E (create+cleanup) | AC-03; sama seperti REQ-006 |
| REQ-008 | SCN-0008 | UI | tanpa entitas baru |
| REQ-009 | SCN-0009 | UI (silent submit) | ⚑ FND-M-01; VAL-003; AC-11 |
| REQ-010 | — | tidak diuji | P493 catatan pengisian data (call sign = kode API Pelindo), bukan aturan validasi pass/fail |
| REQ-011 | SCN-0011, SCN-0012 | UI + silent submit | VAL-004; ⚑ FND-M-01 (SCN-0012); AC-11 |
| REQ-012 | SCN-0013 | UI (observasional) | tanpa Simpan |
| REQ-013 | SCN-0014 | UI (observasional) | tanpa Simpan |
| REQ-014 | SCN-0015 | E2E | AC-04; **[SEKALI PAKAI, TIDAK BISA DIBERSIHKAN]** |
| REQ-015 | SCN-0015 | E2E | AC-04; sama seperti REQ-014 |
| REQ-016 | SCN-0017 | E2E | ⚑ Q-M-02 — diuji sebagai penolakan kombinasi duplikat, bukan penolakan tambah kedua; menumpuk pada data permanen SCN-0015 |
| REQ-017 | SCN-0018 | UI (silent submit) | ⚑ FND-M-01; VAL-005; AC-11; tanpa entitas baru |
| REQ-018 | SCN-0017 | E2E | AC-05; menumpuk pada data permanen SCN-0015 |
| REQ-019 | SCN-0017 | E2E (visual) | AC-05; assertion warna merah baris duplikat |
| REQ-020 | SCN-0017 | E2E | menumpuk pada data permanen SCN-0015 |
| REQ-021 | SCN-0019 | E2E (bug-candidate) | ⚑ Q-M-03; hasil dicatat bug-candidate bukan failed langsung; memakai data permanen SCN-0015/17 (aman, tidak menambah risiko baru) |
| REQ-022 | SCN-0020 | E2E (data existing) | AC-06; butuh identifikasi lintas modul Kuota & Jadwal, blocked bila tidak ditemukan |
| REQ-023 | SCN-0021 | E2E | AC-06; memakai riwayat dari SCN-0017/0019 |
| REQ-024 | SCN-0022 | observasional | ⚑ Q-M-02 (analog REQ-016 untuk Tarif Pass); berhenti sebelum Simpan akhir |
| REQ-025 | — | tidak diuji | data referensi dari Administrator (`/adminprahu`), di luar cakupan OP-11 |
| REQ-026 | SCN-0024 | E2E (data existing) | AC-06; butuh identifikasi lintas modul, blocked bila tidak ditemukan |
| REQ-027 | SCN-0023 | E2E (observasional) | VAL-006; memakai rute baru dari SCN-0015, berhenti sebelum Simpan akhir → tidak menambah entitas |
| REQ-028 | SCN-0025 | UI (silent submit) | ⚑ FND-M-01; VAL-007; AC-11 |
| REQ-029 | — | tidak diuji | efek lintas modul OP-12 (Kuota & Jadwal); tidak ada porsi yang testable murni di OP-11 |
| REQ-030 | SCN-0026 | UI (teks) | |
| REQ-031 | SCN-0027 | UI | |
| REQ-032 | SCN-0027 | UI | |
| REQ-033 | SCN-0028 | negative (Pusat+Cabang) | AC-08 |
| REQ-034 | SCN-0029 | UI (tanpa submit) | VAL-009 |
| REQ-035 | SCN-0029 | UI (tanpa submit) | VAL-009 |
| REQ-036 | SCN-0029 | UI (tanpa submit) | catatan statis modal (M-04) |
| REQ-037 | SCN-0029 | UI (tanpa submit) | VAL-009 |
| REQ-038 | SCN-0029 | UI (tanpa submit) | VAL-009 |
| REQ-039 | SCN-0030 | UI (tanpa submit) | **[IZIN EKSPLISIT USER]**; VAL-009; alert P533 sungguhan tidak diuji |
| REQ-040 | SCN-0031 | UI (tanpa submit) | **[IZIN EKSPLISIT USER]**; VAL-009; alert P534 sungguhan tidak diuji |
| REQ-041 | SCN-0029 | UI (tanpa submit) | VAL-009 |
| REQ-042 | SCN-0029 | UI (tanpa submit) | field disabled belum dipastikan sebelumnya, dikonfirmasi di sini |
| REQ-043 | SCN-0032 | UI (tanpa submit) | **[IZIN EKSPLISIT USER]**; VAL-009; alert P538 sungguhan tidak diuji |
| REQ-044 | — | tidak diuji | efek sungguhan butuh pembatalan tiket agen nyata, lintas modul |
| REQ-045 | SCN-0033 | E2E (Pusat+Cabang) | AC-07; tanpa Simpan di sisi Pusat |
| REQ-046 | SCN-0036, SCN-0037 | E2E (create+cleanup, Pusat & Cabang) | Informasi bukan data referensi permanen → aman dihapus |
| REQ-047 | — | tidak diuji | cross-module Dashboard Agen (`/agen`), lihat Q-M-05 |
| REQ-048 | SCN-0035 | UI (paste event) | ⚑ FND-M-02; AC-09 |
| REQ-049 | SCN-0036 | E2E | |
| REQ-050 | SCN-0035 | UI (paste event) | ⚑ FND-M-02; AC-09 |
| REQ-051 | — | tidak diuji | cross-module Dashboard Agen, lihat Q-M-05 |
| REQ-052 | — | tidak diuji | cross-module Dashboard Agen, lihat Q-M-05 |
| REQ-053 | SCN-0036 | E2E | |
| REQ-054 | SCN-0036 | E2E | |
| VAL-001 | SCN-0002 | | ⚑ FND-M-01 |
| VAL-002 | SCN-0004 | | ⚑ FND-M-01 |
| VAL-003 | SCN-0009, SCN-0010 | | ⚑ FND-M-01 (SCN-0009), FND-M-03 (SCN-0010) |
| VAL-004 | SCN-0011 | | |
| VAL-005 | SCN-0018 | | alur 2 langkah + silent submit |
| VAL-006 | SCN-0023 | | alur 2 langkah, tanpa Simpan akhir |
| VAL-007 | SCN-0025 | | ⚑ FND-M-01 |
| VAL-008 | SCN-0034 | | ⚑ FND-M-01; lihat juga SCN-0035 (batas karakter), SCN-0036 (default tanggal) |
| VAL-009 | SCN-0029, SCN-0030, SCN-0031, SCN-0032 | | 3 dari 4 skenario butuh izin eksplisit untuk submit sungguhan |
| VAL-010 | SCN-0039, SCN-0040 | | hanya Kelas & Trayek diuji; submodul lain tidak diuji individual (lihat di bawah) |
| AC-01 | SCN-0001 | | |
| AC-02 | SCN-0003 | | |
| AC-03 | SCN-0007 | | |
| AC-04 | SCN-0015 | | **[SEKALI PAKAI, TIDAK BISA DIBERSIHKAN]** |
| AC-05 | SCN-0017 | | |
| AC-06 | SCN-0020, SCN-0021, SCN-0024 | | |
| AC-07 | SCN-0033 | | |
| AC-08 | SCN-0028 | | |
| AC-09 | SCN-0035 | | |
| AC-10 | SCN-0037, SCN-0038 | | |
| AC-11 | SCN-0002, SCN-0004, SCN-0009, SCN-0012, SCN-0018, SCN-0025, SCN-0034 | | 7 skenario, sesuai klaim FND-M-01 "≥7 layar" |

## Temuan harvest (FND-M-xx) — status verifikasi

| ID | Diverifikasi oleh | Catatan |
|---|---|---|
| FND-M-01 | SCN-0002, SCN-0004, SCN-0009, SCN-0012, SCN-0018, SCN-0025, SCN-0034 | Simpan kosong silent di 7 form (Kelas, Golongan, Kapal, Trayek, Harga, Crew, Informasi) |
| FND-M-02 | SCN-0035 | Batas karakter Judul/Isi Informasi via event paste |
| FND-M-03 | SCN-0010 | Label `*` vs atribut `required=false` pada Tambah Kapal |
| FND-M-04 | SCN-0016 | Panel collapse "Lihat" kosong pada Trayek & Crew |
| FND-M-05 | — tidak ada skenario | Observasi lingkungan (data tertinggal "asdfghdaf"), bukan perilaku aplikasi — jangan dihapus, cukup dihindari sebagai data acuan |
| FND-M-06 | — tidak ada skenario | Duplikasi id lintas baris (`select_kapal`/`delete_kapal` dipakai ulang di Trayek) — catatan strategi selector, lihat `shared/selector-map-master.md` § Rekomendasi data-testid |

## Ketidakjelasan (Q-M-xx) — status penanganan

| ID | Ditangani di | Pendekatan |
|---|---|---|
| Q-M-01 | SCN-0005 | Observasional, tidak menebak field spesifik dari P485 |
| Q-M-02 | SCN-0017 (REQ-016), SCN-0022 (REQ-024) | Diuji sebagai penolakan kombinasi duplikat, bukan "tambah kedua ditolak" |
| Q-M-03 | SCN-0019 | Hasil dicatat bug-candidate, bukan failed langsung; memakai data uji aman (bukan produksi) |
| Q-M-04 | — tidak diuji | Pengujian penetrasi endpoint langsung di luar cakupan Playwright berbasis UI, berisiko menulis setting tenant tanpa izin |
| Q-M-05 | SCN-0037 (catatan) | Skenario OP-11 berhenti di "Informasi tersimpan dengan atribut Pusat/Cabang benar"; efek tampil di Dashboard Agen dicatat sebagai catatan silang, bukan AC wajib |

Tidak tercakup: REQ-010 (catatan pengisian data, bukan validasi), REQ-025 (data referensi Administrator, di luar
OP-11), REQ-029 (efek lintas modul OP-12 murni), REQ-044 (butuh pembatalan tiket agen nyata, lintas modul),
REQ-047/051/052 (tampilan Dashboard Agen, cross-module — lihat Q-M-05). Filter (VAL-010) submodul Golongan, Kapal,
Harga, Tarif Pass, Asuransi, Crew, Informasi, dan Denda Pembatalan tidak diuji individual (pola sama dengan Kelas
dan Trayek yang sudah diuji di SCN-0039/0040) — konsisten dengan pola OP-21 yang juga tidak menguji filter di semua
submodul. Master Asuransi (SCR-19/20/21) tidak punya REQ bersumber rule (di luar cakupan P480–P551) sehingga hanya
tersentuh smoke test akses di SCN-0038, tanpa skenario validasi tersendiri.

## Ringkasan risiko data (penting untuk eksekusi)

- **Data permanen tidak bisa dibersihkan**: Trayek+Harga `AUTOTEST-20260927-TRAYEK-AC04` (dibuat di SCN-0015,
  ditambah baris harga di SCN-0017/0019) — akan TERTINGGAL SELAMANYA di lingkungan setelah eksekusi. Ini SENGAJA
  dan SESUAI instruksi modul ini (berbeda dari OP-21 yang semua data bisa dihapus balik).
- **Data cleanable (dengan langkah Hapus di scenario)**: Golongan `AUTOTEST-20260927-GOL-UMUM`/`-CABANG` (SCN-0007),
  Informasi `AUTOTEST-20260927-INFO` (SCN-0036) dan `AUTOTEST-20260927-INFO-CABANG` (SCN-0037) — dihapus di akhir
  masing-masing skenario.
- **Butuh izin eksplisit user sebelum eksekusi**: SCN-0030, SCN-0031, SCN-0032 (REQ-039/040/043) — meski skenario
  itu sendiri tidak submit, penguji alert penolakan sungguhan pada Setting Denda Pembatalan tetap memerlukan izin
  + catatan di `shared/decisions.md` sesuai `docs/agent-guide.md` dan `master_analysis.md` § Catatan risiko.
- **Butuh identifikasi data lintas modul sebelum eksekusi** (boleh berakhir `blocked` jika tidak ditemukan, jangan
  ditebak): SCN-0003 (Golongan dipakai Kapal), SCN-0020 (Harga dipakai Kuota & Jadwal), SCN-0024 (Tarif Pass
  dipakai Kuota & Jadwal).
