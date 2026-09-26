# OP-21 Pengaturan User — Coverage

Total 49 skenario (`op-21-pengaturan-user_scenarios.json`): positive 29, negative 18, edge 2; high 25, medium 23, low 1. Tidak ada `stress`.

| REQ/VAL/AC | Skenario | Cakupan | Catatan |
|---|---|---|---|
| REQ-001 | SCN-0008 | UI | ⚑ FND-04 — implementasi tidak ditemukan; hasil menentukan bug vs gap |
| REQ-002 | SCN-0005 | UI | |
| REQ-003 | SCN-0006 | UI | |
| REQ-004 | SCN-0007 | UI | |
| REQ-005 | SCN-0013, SCN-0014, SCN-0015 | E2E | butuh HA & SU uji |
| REQ-006 | SCN-0024 | sebagian | login Sub User Pusat ditunda |
| REQ-007 | SCN-0023 | form saja | isolasi data lintas modul di luar cakupan |
| REQ-008 | SCN-0026, SCN-0027 | E2E (simpan) | verifikasi login dengan sandi baru tidak dilakukan |
| REQ-009 | — | tidak diuji | efek lintas modul |
| REQ-010 | SCN-0018 | E2E | |
| REQ-011 | — | tidak diuji | milik modul Relasi Pelanggan |
| REQ-012 | SCN-0035 | E2E | |
| REQ-013 | SCN-0033 | form saja | efek scan di apk tidak diuji |
| REQ-014 | SCN-0030, SCN-0034, SCN-0035, SCN-0036 | form/detail | |
| REQ-015 | SCN-0030, SCN-0035, SCN-0037, SCN-0039 | web saja | login apk tidak diuji |
| REQ-016 | SCN-0040..0043, SCN-0046, SCN-0047 | pusat & cabang | ⚑ FND-01, FND-02 |
| REQ-017 | SCN-0044, SCN-0045, SCN-0048 | pusat & cabang | |
| REQ-018 | SCN-0001, SCN-0009, SCN-0010, SCN-0011 | E2E | ⚑ FND-08 (analog P1063) |
| REQ-019 | SCN-0016, SCN-0024, SCN-0025 | E2E | satu hak akses per sub user; multi-hak-akses tidak diuji |
| REQ-020 | SCN-0049 | smoke cabang | |
| VAL-001 | SCN-0002, SCN-0003 | | |
| VAL-002 | SCN-0004 | | |
| VAL-003 | SCN-0017, SCN-0022, SCN-0024 | | ⚑ FND-03 |
| VAL-004 | SCN-0020, SCN-0027 | | |
| VAL-005 | SCN-0019 | | |
| VAL-006 | SCN-0023 | | |
| VAL-007 | SCN-0021 | | |
| VAL-008 | SCN-0031, SCN-0032, SCN-0033, SCN-0038 | | |
| VAL-009 | SCN-0012, SCN-0028 | | filter Petugas Scan/Agen tidak diuji |
| AC-01..AC-09 | lihat kolom requirements di scenarios.json | | |

Tidak tercakup: Sub User Pusat (ditunda), multi hak akses per sub user, filter Petugas Scan & halaman agen, pagination, `#valuelimit`, Download Scanner (unduh APK), Edit Hak Akses selain Pilih Semua, edit data sub user selain kata sandi, ganti sandi petugas scan.
