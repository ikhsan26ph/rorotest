# Selector Map — RO315 Lock Device Agen dan Sub Agen

Diverifikasi melalui Playwright MCP pada 14 Oktober 2026, run `20261014-081408`, dilanjutkan resume fixture akun `20261014-091039`.
Sumber bukti: `artifacts/ro315/20261014-081408/`; hasil/triage pada `results/`.
Base URL dan kredensial tetap berasal dari `config/env.md`. Selector berikut berasal dari aplikasi aktual, bukan prototipe.

## Login dan identitas browser

- Login Agen: `/agen`, `#username`, `#password`, `getByRole('button', {name:'Login', exact:true})`.
- Login Pusat/Cabang: ikuti `shared/selector-map-partner-common.md`; context terpisah per role.
- Login valid Agen baru/terkunci menuju `/device`. `#signOut` **tidak** tersedia di gate; deteksi `[data-device-state]` dan identitas akun terautentikasi. Ini bukan kegagalan password.
- Dashboard Agen terverifikasi: `/agen/beranda_agen`. Jual Tiket: ambil href aktual `a[href*='/agen/jualtiket']`, termasuk parameter pencarian; jangan menebak query.
- State gate: `[data-device-state]`, nilai `Baru`, `Menunggu`, `Ditolak`, `Dicabut`.
- Kesiapan browser proof: `[data-device-key-ready='1']`. Penyimpanan IndexedDB, Service Worker dan proof key ikut identitas browser; context kedua tidak sama dengan perangkat fisik kedua.
- `storageState` saja tidak dibuktikan dapat memindahkan proof key pada versi aplikasi ini. Run ini tidak mengekspor cookie/token/private key.

## Verifikasi dan status Agen

| Kontrol | Selector aktual | Catatan |
|---|---|---|
| Heading Baru | `getByRole('heading', {name:'VERIFIKASI PERANGKAT'})` | Setelah autentikasi valid |
| String Code | `locator('strong').filter({hasText:/^[A-Z2-9]{4}-[A-Z2-9]{4}$/})` | Tampilan kode pada Baru/Menunggu |
| Nama Perangkat | `#DeviceName` | Aktual required, maxlength100; berbeda REQ-012 dan batas provisional30 |
| Form pengajuan | `[data-device-registration]` | Action aktual `/device/submit`; token tetap privat |
| Kirim | `getByRole('button', {name:'Kirim ke Kantor Pusat', exact:true})` | Disabled jika nama kosong atau browser key belum siap |
| Izin lokasi | `getByRole('button', {name:'Izinkan Lokasi', exact:true})` | UI aktual mewajibkan lokasi; koordinat0,0 run ini simulasi, bukan lokasi nyata |
| Field lokasi fixture | `[name='Latitude']`, `[name='Longitude']`, `[name='LocationAccuracy']` | Tunggu hasil API geolocation browser; jangan bypass validasi |
| Periksa Status | `getByRole('button', {name:'Periksa Status', exact:true})` | Ada pada Menunggu; tidak ditemukan pada Dicabut |
| Feedback pemeriksaan | `[data-device-feedback]` | Tunggu `Status terbaru: Menunggu` bila memeriksa manual |
| Keluar | `a[href*='dologoutAgen']` | Ditemukan pada Baru/Ditolak/Dicabut; Menunggu tidak mempunyai kontrol Keluar |
| Endpoint logout teramati | `/user/dologoutAgen` | URL ditemukan di UI Baru; dipakai untuk setup relogin Menunggu |

Menunggu tidak mempunyai Kirim Ulang Kode atau tombol Masuk ke Dashboard pada versi ini. Perubahan status dideteksi otomatis; approval/reaktivasi mengarah ke Dashboard tanpa reload manual. Ditolak menampilkan alasan/nama/waktu; Dicabut tidak menampilkan alasan. Email pemroses tersedia di tabel Pusat, bukan layar status Agen.

## Manajemen Device Pusat

Masuk dari `a.sidebar_icon.filter({hasText:'DAFTAR RELASI'})`, kemudian `a[href$='/device/manage']`.
Fallback CSS Daftar Relasi digunakan karena selector role/name exact tidak ditemukan pada run ini.

| Kontrol | Selector aktual | Catatan |
|---|---|---|
| Tabel | `#device-table` | AJAX GET; tunggu `aria-busy='false'` |
| Body | `#device-table-body` | Hitung row/kode, bukan tombol Detail; Menunggu tidak memiliki Detail |
| Row milik run | `locator('#device-table-body tr').filter({hasText:code})` | Wajib scope ke kode/data run sebelum mutasi |
| Toggle filter | `#device-filter-toggle` | Tunggu `#device-search` visible |
| Nama akun | `#device-search` | Query `q` |
| Jenis akun | `#device-type` | Opsi `agen`, `sub-agen` |
| Kode | `#device-code` | Query `code` |
| Perangkat | `#device-info` | Query `device` |
| Tanggal permintaan | `#device-requested` | Input date; `YYYY-MM-DD` |
| Tanggal proses | `#device-processed` | Input date; query `processed_date` |
| Pemroses | `#device-processor` | Ambil value option dari nama/email aktual; jangan hardcode ID |
| Status | `#device-status` | Menunggu/Aktif/Ditolak/Dicabut |
| Terapkan filter | `#device-filter-form button[type='submit']` | Filter berjalan AJAX |
| Reset | `#device-filter-reset` | Aktual kembali tab Semua |
| Tab | `.device-management-tabs a` | `.active[aria-current='page']` menunjukkan tab; label case-insensitive |
| Ukuran halaman | `#device-page-length` | Aktual10/25/50; bukan prototype10/20/50 |
| Pagination | `#device-pagination` | Link `Selanjutnya »` |
| Detail | `[data-device-detail]` | Scope row sebelum klik; attr memuat ID server |
| ID request | Row `[name='DeviceID']` atau `[data-device-detail]` | Ditolak hanya Detail; Menunggu hanya form operasi |
| Operasi | Row `button[name='operation'][value='approve|reject|revoke|reactivate']` | Periksa status dan kepemilikan sebelum klik |

Tabel kolom: akun/cabang/induk, perangkat, kode, permintaan, proses, pemroses, status, aksi.
`innerText` mengikuti CSS uppercase; `allTextContents` dapat memuat `Sub Agen`/`Aktif` tanpa uppercase.
Backend menolak Agen biasa membuka manajemen dengan alert `Anda Tidak Memiliki Akses Ke Halaman Tersebut`; URL dapat tetap `/device/manage` sambil merender dashboard. Jangan mensyaratkan redirect URL bila tidak ada pada oracle.

## Dialog dan audit

| Kontrol | Selector aktual | Catatan |
|---|---|---|
| Dialog | `#device-dialog` | Tunggu visible/hidden sesuai langkah |
| Heading | `#device-dialog-title` | Registrasi/Detail/Tolak/Cabut/Aktifkan Kembali |
| Body | `#device-dialog-body` | Detail async; tunggu konten, bukan hanya dialog visible |
| String Code registrasi | `#device-registration-code` | **Disabled/prefilled** dari row; tidak menerima input/normalisasi user |
| Hasil lookup | `#device-lookup-feedback` | Tunggu `Kode ditemukan.` sebelum konfirmasi |
| Catatan/alasan | `#device-action-note` | Required reject/revoke; optional approve/reactivate |
| Konfirmasi | `[data-device-confirm]` | Blank reason dijaga saat klik, bukan lewat disabled awal |
| Batal/Tutup | `[data-device-close]` | Hanya kontrol visible pada dialog saat ini |
| Histori | `.device-history`, `.device-history-item` | Tersimpan untuk Ditolak/Dicabut |
| Aksi dari detail | `[data-device-detail-action='revoke|reactivate']` | Scope dialog |

Endpoint yang ditemukan dari script UI: GET `/device/detail/<id>`, GET `/device/lookup?code=...`, POST `/device/process`, GET `/device/status`, GET `/device/binding`. Jangan mencetak isi binding/token/proof. Detail JSON `processor` hanya nama; tabel menampilkan nama+email.

Tidak ditemukan dialog/radio penggantian atau peringatan maksimal2 pada reaktivasi meskipun fixture dua Aktif terverifikasi. Ini hanya bukti perbedaan UI provisional; run tidak mengonfirmasi approval/reaktivasi perangkat ketiga untuk menyimpulkan validasi kapasitas backend.

## Batas eksekusi

Resume20261014-091039 membuat dua Agen dan dua Sub Agen berprefix. Kredensial tersimpan privat pada config/env.md; pilih fixture berdasarkan email/role spesifik, jangan menganggap helper Agen default memilih akun baru. Operator Pusat kedua belum dibuat. Data Sub Agen existing tetap hanya dibaca; mutasi hanya pada perangkat milik fixture baru. Seed/reset/clock/trace/barrier internal server tetap belum tersedia. POS-007/NEG-007 tetap blocked trace/cache, bukan kredensial. Cleanup run awal6 request dan resume5 request seluruhnya Dicabut/Ditolak; histori ada, tidak ada Aktif/Menunggu. Empat akun fixture dan hak aksesnya disimpan untuk penggunaan berikutnya.

## Membuat fixture Agen/Sub Agen (resume 14 Oktober)

- Tambah Agen hanya dari sesi Cabang: tautan `a[href*="tambahagen"]` → `/partner/tambahagen`. Pusat tidak mempunyai kontrol tulis.
- Field Agen: `#nama_perusahaan`, `#penanggung_jawab`, `#email`, `#password`, `#password_confirm`, `#telp`, `#alamat_perusahaan`, `#foto_identitas`, `#foto_perjanjian`, `#status`, `#bank`, `#nomor_rekening`, `#atas_nama`; simpan `#submit_sub`. PDF dummy harus berfilename unik milik run.
- Status1 Aktif/2 Tidak Aktif. Run membuat Tidak Aktif kemudian mengaktifkan melalui Edit Agen yang href/ID-nya ditemukan pada detail hasil create. Aktivasi dapat redirect langsung `/partner/detailagen/<id>`, bukan list. Verifikasi pemilik/status setelah navigasi.
- Email test yang sudah terdaftar tidak dipakai/diubah. Fixture login memakai alamat dummy unik example.com, password diisi manual. Nomor WA Sub Agen dummy non-routable untuk melewati kebutuhan data unik secara resmi; tidak dipakai untuk e-tiket/invoice/OTP.
- Agen baru perlu approval perangkat Pusat sebelum menyiapkan Sub User. Sidebar Agen: `/agen/hakAkses`, `/agen/subUser`; ambil href aktual.
- Hak Akses: `/agen/buathakakses`, `#nama_hak_akses`, `#ket_hak_akses`, checkbox `#jual_tiket`/`#lihat_dashboard`, simpan `#submit_crew`. Native confirm menambah hak akses wajib ditangani; dismiss otomatis membatalkan penyimpanan. Jual Tiket menyeleksi izin dependensi daftar/detail order/selesaikan bayar/konfirmasi tiket pada UI; tidak menggunakan Semua Akses.
- Sub User: `/agen/buatsubuser`, `#email`, `#password`, `#password_confirm`, `#nama`, `#wa`, `#bagian_staff`, `#status_user`, `#hak_akses` (multi), `#submit_sub`. Native confirm menambah Sub User; redirect `/agen/subuser/`. Ambil ID dari href detail row milik run, bukan menebak.
- Dua Sub User dengan nama sama, masing-masing di bawah induk berbeda, berhasil dibuat. Account19578→parent19577; account19580→parent19579. Relasi induk diperiksa pada daftar/detail Pusat dan hasil create.
- ACL induk: POST `/device/process` melalui browser fetch, gunakan CSRF sesi induk dari binding secara privat dan hanya DeviceID milik run. Approve/reject/revoke/reactivate ditolak dengan status/histori tidak berubah. Pastikan binding.accountId sesuai induk dan request punya parent yang benar; penolakan token/proof tidak otomatis membuktikan ACL.
