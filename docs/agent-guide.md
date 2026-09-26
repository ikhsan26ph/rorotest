# Sistem Penjualan Tiket Kapal — Automation Testing Machine

Project ini adalah mesin automation testing untuk **Sistem Penjualan Tiket Kapal**,
dijalankan lewat Claude Code atau Codex, menggunakan script Playwright dan Playwright MCP.

Semua path dalam panduan ini relatif terhadap root repository. Nama `/workflow`
merujuk prosedur di `docs/workflows/`; cara memanggilnya mengikuti adapter agent.

## Alur Kerja Utama

1. `/explore` — eksplorasi general aplikasi: login, petakan SEMUA modul/menu, simpan hasil ke `explore/module-map.md`. Ini WAJIB dijalankan pertama kali (atau saat aplikasi berubah besar).
2. User memerintah modul mana yang mau dites: `/test-module <nama-modul>`.
3. `/task` — perintah bebas (mis. "buatkan booking tiket ..."), berbasis folder `task/`. **Status: belum diimplementasikan.**

Hasil eksekusi disimpan sebagai JSON di `results/`, lalu `/report` mengubahnya menjadi file Excel di `reports/`.

Catatan: `/harvest-selectors <modul>` disarankan dijalankan sekali sebelum test modul pertama kali, dan diulang bila UI aplikasi berubah — hasilnya (`shared/selector-map-*.md`) menjadi sumber selector utama executor.

## Aturan Wajib

- **Jangan pernah menebak URL atau kredensial.** Semua ada di `config/env.md`. Jika file itu belum diisi, berhenti dan minta user mengisinya (contoh format: `config/env.example.md`).
- **Environment testing bisa berisi data nyata.** Dilarang keras: menghapus data yang tidak dibuat oleh test run ini, mengubah setting tenant, atau melakukan aksi destruktif (hapus/batalkan data atau tiket milik orang lain) kecuali skenario secara eksplisit memerintahkannya pada data yang dibuat sendiri oleh run ini.
- **Data test diberi prefix** `AUTOTEST-<tanggal>-` pada field bebas teks (mis. nama penumpang/catatan) supaya mudah diidentifikasi dan dibersihkan.
- **Selector priority**: `getByRole(name)` → `getByLabel` → `getByText` → `getByTestId`. `data-testid` di dokumen skenario hanyalah usulan, belum tentu ada di implementasi.
- **Satu skenario = satu verdict**: `passed` / `failed` / `blocked` / `skipped`. Failed harus menyertakan pesan error + screenshot di `artifacts/screenshots/`.
- **Bedakan BUG vs GAP DESAIN.** Dokumen skenario menandai kandidat bug (FND-xx). Jika perilaku aplikasi cocok desain tapi bertentangan REQ, catat sebagai `bug-candidate`, jangan langsung failed tanpa keterangan.
- Bahasa laporan dan komunikasi: **Indonesia**.

Aturan khusus sistem penjualan tiket (WAJIB):

- **PEMBAYARAN**: DILARANG KERAS menyelesaikan pembayaran nyata. Alur pembayaran hanya boleh sampai halaman/instruksi bayar lalu BERHENTI, KECUALI payment gateway environment ini sudah dikonfirmasi sandbox/dummy oleh user secara eksplisit dan tercatat di `shared/decisions.md`.
- **KUOTA**: setiap booking test mengonsumsi kursi/slot pada jadwal nyata. Semua booking yang dibuat run WAJIB dicatat (kode booking + jadwal) di `results/` dan dibersihkan/dibatalkan di akhir run bila fiturnya ada. Dilarang booking massal tanpa perintah eksplisit user.
- **JADWAL**: data test selalu memakai jadwal keberangkatan sejauh mungkin di masa depan; jangan menyentuh keberangkatan terdekat.
- **NOTIFIKASI**: e-tiket/invoice/OTP hanya boleh diarahkan ke kontak test yang user cantumkan di `config/env.md` — tidak pernah kontak lain.
- **DATA PENUMPANG**: selalu fiktif berprefix `AUTOTEST-<tanggal>-`, identitas dummy; tidak pernah data pribadi nyata.
- **Refund, pembatalan tiket milik orang lain, perubahan tarif/jadwal**: hanya dengan perintah eksplisit user per kasus.

## Struktur Project

- `explore/` — output `/explore` (`module-map.md`): peta seluruh modul/route + info login & environment.
- `scenario/<modul>/` — dokumen skenario per modul: `*_analysis.md`, `*_ui-inventory.md`, `*.feature`, `*_scenarios.json` (**sumber utama eksekusi**), `*_coverage.md`. Skema wajib: lihat `scenario/README.md`.
- `task/` — fitur perintah bebas `/task` (defaults, intent schema). Belum diimplementasikan.
- `shared/` — hal lintas fitur: `selector-map-<area>.md` (hasil `/harvest-selectors`, **sumber selector utama executor**), `decisions.md` (keputusan triage bertanggal).
- `config/` — `env.md` (link + kredensial, gitignore) dan `env.example.md` (contoh format).
- `results/`, `reports/`, `artifacts/` — output run (JSON, Excel, screenshot); gitignore, tidak di-commit.

Saat mengeksekusi modul, SELALU baca `scenario/<modul>/*_scenarios.json` sebagai daftar skenario, dan `*_ui-inventory.md` sebagai peta selector. Bila selector-map di `shared/` tersedia, selector dari sana diprioritaskan di atas usulan ui-inventory.

## Skema Hasil Eksekusi (`results/`)

Satu run = satu file `results/<modul>__<YYYYMMDD-HHmmss>.json`:

```json
{
  "module": "<nama-modul>",
  "runId": "20260821-140501",
  "startedAt": "...", "finishedAt": "...",
  "environment": {"baseUrl": "...", "user": "...", "role": "..."},
  "scenarios": [
    {
      "id": "SCN-0001",
      "title": "...",
      "category": "positive|negative|edge|stress",
      "priority": "high|medium|low",
      "screen": "...",
      "requirements": ["REQ-001"],
      "status": "passed|failed|blocked|skipped",
      "durationSec": 12.3,
      "error": null,
      "screenshot": null,
      "bugCandidate": null,
      "notes": ""
    }
  ]
}
```

Field `id`, `title`, `category`, `priority`, `requirements` HARUS disalin apa adanya dari `scenarios.json` agar traceability terjaga.

## Report Excel

`python scripts/generate_report.py results/<file>.json` → menghasilkan `reports/<modul>__<runId>.xlsx`
berisi sheet: **Summary**, **Detail**, **Failed & Bug Candidates**. Jangan menulis Excel manual — selalu lewat script ini.

## Mode Eksekusi (urutan prioritas)

1. **Playwright script** — bila `tests/<modul>.spec.js` ada, eksekusi modul WAJIB lewat
   `bash scripts/run-playwright.sh <modul>` (opsi filter: argumen playwright, mis. `--grep SCN-0004`).
   Script otomatis: jalankan test → konversi ke skema `results/` (`scripts/playwright_to_results.py`) → generate Excel.
   Judul test berformat `SCN-xxxx: <judul asli scenarios.json>` — jangan diubah, dipakai untuk traceability.
   Butuh Node ≥ 22, lihat `.nvmrc`; runner mengatur PATH sendiri (via nvm bila tersedia).
2. **Playwright MCP tanpa snapshot** — untuk modul tanpa spec / eksplorasi: gunakan tool eksekusi kode Playwright yang tersedia (lihat pemetaan tool di bawah)
   (satu call = seluruh langkah + assertion satu skenario, selector dari `shared/selector-map-*.md`).
   `browser_snapshot` HANYA untuk explore/harvest/diagnosis kegagalan — dilarang di jalur eksekusi normal (lambat & boros context).

Catatan sesi — status hipotesis bawaan project OMS (diperiksa 2026-09-25 pada modul Pengaturan User, lihat `shared/decisions.md`):

- (i) Backend OMS menolak sesi yang dipindah antar browser-context (`storageState` tidak berfungsi) — **BELUM DIUJI di aplikasi ini**.
  Fixture yang dipakai (`tests/helpers/partner-session.js`, `workers: 1` di `playwright.config.js`) login sekali per role pada context
  yang terus hidup dengan guard "login gagal 2x → berhenti", sehingga storageState memang tidak diperlukan. Jangan beralih ke pola
  storageState sebelum diuji dan dicatat di `shared/decisions.md`.
- (ii) "Wajib `locator.dispatchEvent('click')`" — **TIDAK BERLAKU di aplikasi ini** (aturan dihapus 2026-09-25): `locator.click()` biasa
  memicu handler jQuery (toggle filter, checkbox via label, tombol Simpan/Hapus, SweetAlert). Pakai `click()` biasa; `dispatchEvent`
  hanya sebagai fallback terdokumentasi bila sebuah elemen terbukti tidak merespons.

Login portal Operator (`/partner`): `#username`, `#password`, tombol "Login" → tetap di `/partner` (Akun Saya) lalu redirect
`/partner/profil` (Operator Pusat) / `/partner/profilsubuser` (Sub User); indikator sesi `#signOut`. Detail: `shared/selector-map-partner-common.md`.
`tests/helpers/fixtures.js` adalah fixture lama OMS (akun #1, route `/login`) dan tidak dipakai modul portal Operator.

## Batasan Eksekusi Browser

- Selalu tunggu network idle / elemen terlihat sebelum assert; komponen yang render async (drawer/modal/dropdown) sering jadi sumber flaky.
- Skenario `@stress` dan yang berpotensi membuat data masif hanya dijalankan jika user secara eksplisit memintanya.
- Jika login gagal 2x berturut-turut, BERHENTI (jangan sampai akun terkunci) dan lapor ke user.

## Integrasi Agent dan Browser

- Baca prosedur `docs/workflows/<nama>.md` sebelum menjalankan workflow, serta
  `docs/roles/<peran>.md` untuk setiap peran yang dipakai.
- Peran explorer, planner, executor, dan triager adalah tahapan kerja. Adapter
  boleh menjalankannya berurutan dalam satu agent; subagent tidak wajib.
- Periksa tool MCP yang benar-benar tersedia. Gunakan `browser_run_code` atau
  `browser_run_code_unsafe` jika tersedia dan sesuai izin sesi; jangan mengasumsikan
  nama tool tertentu tersedia atau menurunkan pengamanan agar bisa memakainya.
- Untuk diagnosis, gunakan `browser_find` bila tersedia; jika tidak, gunakan
  locator melalui tool run-code. Snapshot tetap terbatas untuk explore/harvest/diagnosis.
- Jika kemampuan browser yang diperlukan tidak tersedia, laporkan hambatan dan
  tandai skenario terdampak `blocked`; jangan mengarang hasil pengujian.
- Jangan menulis password, token, cookie, atau storage sesi ke dokumentasi/laporan.
  Kredensial yang belum terisi hanya menghalangi pekerjaan yang membutuhkan login.

## Penggunaan Bergantian atau Bersamaan

- Untuk penggunaan bergantian, baca perubahan Git, plan/hasil terakhir yang relevan,
  dan `shared/decisions.md` sebelum melanjutkan. Konteks percakapan agent lain tidak
  otomatis ikut berpindah. Catat pekerjaan selesai dan pekerjaan tersisa saat handoff.
- Jangan menjalankan dua test run dalam working directory yang sama: runner memakai
  `results/_playwright/last-run.json` dan output lain yang dapat tertimpa.
- Untuk kerja simultan, gunakan worktree terpisah, dependency dan `config/env.md`
  masing-masing (file yang diabaikan Git tidak otomatis ikut), serta browser context
  terpisah. Jangan berbagi cookie/storageState.
- Worktree tidak memisahkan backend aplikasi. Gunakan akun/data uji terpisah yang sudah
  disediakan; tambahkan penanda agent/run setelah prefix `AUTOTEST-<tanggal>-` jika
  skenario mengizinkan. Bila isolasi data/sesi tidak tersedia, jalankan test bergantian.
- Jangan menimpa hasil run lama. Pertahankan format runId yang digunakan runner.
