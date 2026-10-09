# Analysis — ro315-lock-device-agen-dan-sub-agen

## Requirements

Sumber utama: `inputs/ro315-lock-device-agen-dan-sub-agen/spec.txt`. Sumber pendukung terbaca: `extras/1-lock-device-agen-dc.html`. REQ-001–REQ-032 normatif; REQ-033–REQ-039 provisional dari extras.

| ID | Requirement | Acceptance criteria | Sumber |
|---|---|---|---|
| REQ-001 | Cakupan role | Lock device diterapkan pada Agen dan Sub Agen; role lain mengikuti login existing tanpa pengecekan device. | General Rules 1, 5 |
| REQ-002 | Urutan autentikasi | Pengecekan device hanya dijalankan setelah autentikasi email dan password berhasil. | General Rules 3; Login 1–2 |
| REQ-003 | Akses perangkat Aktif | Agen dan Sub Agen hanya masuk ke halaman utama dan fitur menggunakan pasangan device/browser terdaftar berstatus Aktif. | General Rules 2, 8; Login 3 |
| REQ-004 | Perangkat baru | Device/browser belum terdaftar diarahkan ke Verifikasi Perangkat setelah login valid. | Login 3–4; Verifikasi 1 |
| REQ-005 | Login perangkat Menunggu | Login perangkat Menunggu tetap menampilkan status menunggu dan tidak memberi akses sistem. | Login 3 |
| REQ-006 | Login perangkat Ditolak | Login perangkat Ditolak menampilkan penolakan dan menutup akses sistem. | Login 3; Verifikasi 7 |
| REQ-007 | Login perangkat Dicabut | Login perangkat Dicabut menampilkan pencabutan dan menutup akses sistem. | Login 3; Verifikasi 7 |
| REQ-008 | Identitas akun/device/browser | Akun sama pada device atau browser berbeda merupakan device baru; approval satu pasangan tidak memberi akses pasangan lain. | General Rules 2; Login 4 |
| REQ-009 | Status server terbaru | Status server terbaru mengendalikan akses; perubahan Kantor Pusat langsung berlaku termasuk sesi yang sudah login. | Login 5 |
| REQ-010 | Layar verifikasi | Verifikasi Perangkat hanya tampil bagi Agen/Sub Agen terautentikasi dengan device belum terdaftar. | Verifikasi 1 |
| REQ-011 | String Code unik | Sistem menyediakan String Code unik untuk registrasi dan mengikatnya pada request perangkat yang tepat. | Verifikasi 2, 5 |
| REQ-012 | Nama Perangkat opsional | Nama Perangkat boleh kosong; bila diisi, dikirim dan ditampilkan bersama request. | Verifikasi 3, 5; Manajemen 5 |
| REQ-013 | Pengiriman dan payload | Kirim membuat request ke Kantor Pusat dengan identitas akun, kode, informasi device/browser, nama jika diisi, tanggal dan waktu. | Verifikasi 4–5 |
| REQ-014 | Status setelah pengiriman | Request yang berhasil menjadi Menunggu; akses sistem belum diizinkan. | Verifikasi 6; Status Menunggu 1–2 |
| REQ-015 | Idempotensi request | Login ulang akun dan device/browser sama tidak membuat request baru jika request perangkat tersebut masih ada. | Verifikasi 8 |
| REQ-016 | Sinkronisasi halaman | Halaman verifikasi/status mengikuti status request terakhir dan otomatis memperbarui perubahan Kantor Pusat. | Verifikasi 7, 9 |
| REQ-017 | Navigasi Kantor Pusat | Sub-menu Manajemen Device berada pada Daftar Relasi di sisi Kantor Pusat. | Manajemen 1; General Rules 6 |
| REQ-018 | Histori per akun | Manajemen Device menampilkan request dan riwayat perangkat per akun tanpa menghapus histori Ditolak/Dicabut. | General Rules 9; Manajemen 2–3 |
| REQ-019 | Label jenis akun | Informasi akun menampilkan label Agen atau Sub Agen sesuai akun pemilik. | Manajemen 4 |
| REQ-020 | Informasi cabang | Data Agen/Sub Agen menampilkan cabang masing-masing. | Manajemen 4 |
| REQ-021 | Relasi Agen induk | Data Sub Agen menyertakan Agen induk yang tepat. | Manajemen 4; Khusus Sub Agen 4 |
| REQ-022 | Informasi perangkat | Data perangkat menampilkan nama bila tersedia, jenis perangkat dan browser. | Manajemen 5 |
| REQ-023 | Tanggal dan waktu | Tanggal Permintaan dan Tanggal Approval/Proses menampilkan tanggal serta waktu, bukan tanggal saja. | Manajemen 6; Approval 2 |
| REQ-024 | Identitas pemroses | Diproses Oleh menampilkan nama dan email user Kantor Pusat yang benar-benar memproses. | Manajemen 7; Approval 2 |
| REQ-025 | Approval Kantor Pusat | Approval oleh Kantor Pusat mengubah Menunggu menjadi Aktif, menyimpan waktu/pemroses, dan membuka akses perangkat tersebut. | General Rules 6; Approval 1–3 |
| REQ-026 | Aksi Menunggu | Menunggu menyediakan Setujui dan Tolak; Tolak mengubah status menjadi Ditolak. | Status Menunggu 3–5 |
| REQ-027 | Aksi Aktif | Aktif menyediakan Lihat Detail dan Cabut Perangkat; Cabut/Reset menjadi Dicabut. | Status Aktif 3–5 |
| REQ-028 | Aksi Ditolak | Ditolak hanya menyediakan Lihat Detail dan tetap tersimpan sebagai histori; tidak dapat diaktifkan kembali. | Status Ditolak 3–5 |
| REQ-029 | Aksi Dicabut | Dicabut menyediakan Lihat Detail dan Aktifkan Kembali; data tidak dihapus. | Status Dicabut 3–7 |
| REQ-030 | Aktifkan kembali | Kantor Pusat mengubah Dicabut menjadi Aktif; pasangan device/browser sama dapat dipakai tanpa registrasi baru. | Manajemen 2; Status Dicabut 4–6 |
| REQ-031 | Pergantian perangkat | Cabut/Reset perangkat lama menyimpan histori dan menutup akses lama; device/browser baru harus diverifikasi dan disetujui kembali. | Pergantian Device 1–4 |
| REQ-032 | Larangan Agen induk | Agen induk tidak boleh menyetujui, menolak, mencabut atau mengaktifkan kembali perangkat Sub Agen. | General Rules 7; Khusus Sub Agen 1–3 |
| REQ-033 | Format kode prototipe | Prototipe memakai 8 karakter alfanumerik, ditampilkan XXXX-XXXX, normalisasi huruf besar dan lookup request Menunggu. | extras HTML: lookup(), onRegInput; asumsi A04 |
| REQ-034 | Batas nama prototipe | Prototipe membatasi Nama Perangkat 30 karakter; tidak mengubah sifat opsional dari spec. | extras HTML: maxlength=30; asumsi A04 |
| REQ-035 | Alasan dan catatan prototipe | Prototipe mewajibkan alasan nonblank saat menolak/mencabut, menyimpannya di histori; catatan approval/reaktivasi opsional. | extras HTML: reasonDisabled, regNote; asumsi A04 |
| REQ-036 | Filter prototipe | Filter nama, jenis akun, kode, perangkat, tanggal permintaan/approval, pemroses, status dan Reset mempersempit data sesuai kombinasi. | extras HTML: filterOpen, rows, resetFilter; asumsi A04 |
| REQ-037 | Tab dan tampilan data prototipe | Tab Semua/Menunggu/Aktif/Ditolak/Dicabut, jumlah Menunggu, empty state, ukuran 10/20/50 dan pagination tersedia sebagai rancangan UI. | extras HTML: TABS, pageSizes, Pagination; asumsi A04/A10 |
| REQ-038 | Batas dua perangkat prototipe | Prototipe membatasi dua perangkat Aktif per akun; penggantian memilih perangkat lama untuk dicabut; reaktivasi tidak melampaui batas. | extras HTML: activeOf, mLimit, reactLimit; asumsi A04/A09 |
| REQ-039 | Kontrol UI pendukung | Toggle kata sandi, Keluar, Periksa Status, Masuk ke Dashboard, Batal/Tutup dan Kirim Ulang Kode mengikuti status tanpa membuka akses ilegal. | extras HTML: togglePass, logout, checkStatus, closeModal, resendCode; asumsi A04/A06 |

### Aktor dan hak akses

| Aktor | Hak |
|---|---|
| Agen | Login hanya dari pasangan Aktif; mengirim permintaan dan melihat status sendiri; tidak mengelola perangkat Sub Agen. |
| Sub Agen | Pemeriksaan/login/registrasi sama dengan Agen; approval tetap Kantor Pusat. |
| Kantor Pusat berizin | Melihat request dan histori, menyetujui/menolak Menunggu, mencabut Aktif, mengaktifkan kembali Dicabut. |
| Role lain | Login existing tanpa lock device; akses menu mengikuti hak existing, bukan otomatis berizin. |

### Aturan validasi

| Field/data | Aturan |
|---|---|
| Email / Kata Sandi | Wajib untuk autentikasi existing; kredensial tidak valid gagal sebelum pemeriksaan perangkat. Tidak ada batas panjang/policy baru dari spec. |
| Nama Perangkat | Opsional menurut spec; maksimum 30 karakter hanya dari HTML (provisional). |
| String Code | Unik dan milik request yang tepat menurut spec; pola `[A-Z0-9]{4}-[A-Z0-9]{4}` hanya dari HTML. |
| Alasan Penolakan / Pencabutan | Trim nonblank wajib hanya dari HTML; disimpan pada histori. |
| Catatan approval / reaktivasi | Opsional dari HTML. |
| Status | Hanya Menunggu, Aktif, Ditolak, Dicabut; belum terdaftar adalah kondisi, bukan status kelima. |
| Jumlah perangkat Aktif | Maksimal 2 per akun hanya dari HTML, termasuk reaktivasi. |
| Tanggal & pemroses | Instant permintaan/proses dari server; nama dan email Kantor Pusat yang memproses, tidak dipasok Agen. |

### Flow dan transisi

Login invalid → error existing, tanpa device check. Login valid role lain → halaman existing. Login valid Agen/Sub Agen → status server terbaru: belum terdaftar → Verifikasi; Menunggu → Menunggu Persetujuan; Aktif → Dashboard; Ditolak/Dicabut → layar penolakan/pencabutan.

Belum terdaftar —Kirim→ Menunggu —Setujui→ Aktif —Cabut/Reset→ Dicabut —Aktifkan Kembali→ Aktif. Menunggu —Tolak→ Ditolak. Ditolak hanya Lihat Detail di Kantor Pusat. Login ulang tidak menciptakan request baru. Penggantian memakai registrasi baru bagi pasangan baru dan menyimpan histori lama.

Kantor Pusat memproses request → status/pemroses/timestamp/histori disimpan → halaman Agen/Sub Agen otomatis mengikuti status server dan akses diputus/dibuka sesuai status. Keputusan race harus diperiksa ulang di server, bukan hanya berdasarkan tombol yang pernah tampil.

## UI Inventory

Basis: spec dan inspeksi struktur/teks HTML, tanpa PNG. Role/name/testid berikut adalah saran locator; komponen custom dan label yang tidak terhubung perlu diperiksa saat integrasi. Tombol bar PROTOTIPE, pilihan Role/Step dan seed demo bukan kontrol produksi. Registrasi Device global tersembunyi (`showRegister=false`); modal registrasi dibuka dari Setujui per baris.

State: login loading/error; verifikasi idle/sending/error; Menunggu/approved/rejected/revoked mengikuti server; tabel populated/empty; lookup found/error; confirm disabled untuk kode invalid, alasan blank, batas reaktivasi atau radio belum dipilih. Spec mengharuskan Kirim enabled untuk Nama Perangkat kosong.

### login

| Elemen | Role | Accessible name usulan | data-testid usulan | Label | Sumber / state |
|---|---|---|---|---|---|
| Email | textbox | Email | login-email | Email | HTML: type=email |
| Kata Sandi | — (getByLabel/getByTestId) | Kata Sandi | login-password | Kata Sandi | HTML: type=password; getByLabel/testid |
| Toggle Kata Sandi | button | Tampilkan/sembunyikan kata sandi | login-toggle-password | — | HTML: tombol ikon tanpa accessible name; usulan |
| Login | button | Login | login-submit | — | HTML: loading Memproses… |
| Error Login | alert | Kesalahan login | login-error | — | HTML: loginErr; role alert usulan |

### verifikasi-perangkat

| Elemen | Role | Accessible name usulan | data-testid usulan | Label | Sumber / state |
|---|---|---|---|---|---|
| Judul Verifikasi | heading | VERIFIKASI PERANGKAT | verification-heading | — | HTML h1 |
| Kode Perangkat | — (getByLabel/getByTestId) | KODE PERANGKAT | device-code | Kode Perangkat | HTML: span, bukan textbox |
| Identitas Akun | — (getByLabel/getByTestId) | Akun | verification-account | Akun | Spec + HTML |
| Informasi Perangkat | — (getByLabel/getByTestId) | Perangkat | verification-device | Perangkat | Spec + HTML: browser/OS |
| Lokasi Perkiraan | — (getByLabel/getByTestId) | Lokasi perkiraan | verification-location | Lokasi perkiraan | HTML informatif |
| Waktu Permintaan | — (getByLabel/getByTestId) | Waktu permintaan | verification-request-time | Waktu permintaan | Spec + HTML |
| Nama Perangkat | textbox | Nama Perangkat | device-name | Nama Perangkat | Spec opsional; HTML placeholder Contoh: COM-ADM-001, max 30 |
| Info Browser Baru | — (getByLabel/getByTestId) | Menghapus data browser atau memakai mode penyamaran membuat perangkat perlu didaftarkan ulang. | browser-identity-info | — | HTML |
| Kirim | button | Kirim ke Kantor Pusat | device-request-submit | — | Spec Kirim; HTML Mengirim… |
| Keluar | button | Keluar | verification-logout | — | HTML |
| Error Pengiriman | alert | Pengiriman gagal | device-request-error | — | State error turunan, teks/role usulan |

### menunggu-persetujuan

| Elemen | Role | Accessible name usulan | data-testid usulan | Label | Sumber / state |
|---|---|---|---|---|---|
| Status Perangkat | — (getByLabel/getByTestId) | Status | device-status | Status | HTML badge MENUNGGU APPROVAL |
| Kode Permintaan | — (getByLabel/getByTestId) | Kode permintaan | waiting-code | Kode permintaan | HTML |
| Informasi Perangkat | — (getByLabel/getByTestId) | Nama Perangkat | waiting-device | Nama Perangkat | HTML |
| Waktu Permintaan | — (getByLabel/getByTestId) | Dikirim | waiting-time | Dikirim | HTML |
| Pesan Persetujuan | — (getByLabel/getByTestId) | Perangkat disetujui Kantor Pusat. Akun siap digunakan dari perangkat ini. | device-approved-message | — | HTML |
| Periksa Status | button | Periksa Status | device-check-status | — | HTML Memeriksa… |
| Masuk ke Dashboard | button | Masuk ke Dashboard | device-enter-dashboard | — | HTML muncul bila Aktif |
| Kirim Ulang Kode | button | Kirim Ulang Kode | device-resend | — | HTML; A06 |
| Bantuan | — (getByLabel/getByTestId) | Butuh bantuan? | device-help | — | HTML; nomor placeholder A07 |

### perangkat-ditolak

| Elemen | Role | Accessible name usulan | data-testid usulan | Label | Sumber / state |
|---|---|---|---|---|---|
| Status Perangkat | — (getByLabel/getByTestId) | DITOLAK | device-status | Status | Spec + HTML |
| Alasan Proses | — (getByLabel/getByTestId) | Alasan | device-process-reason | Alasan | HTML |
| Waktu Proses | — (getByLabel/getByTestId) | Ditolak | device-process-time | — | HTML |
| Diproses Oleh | — (getByLabel/getByTestId) | Diproses Oleh | device-processor | — | HTML: nama dan email |
| Bantuan | — (getByLabel/getByTestId) | Butuh bantuan? | device-help | — | HTML; nomor belum dikonfirmasi |
| Ajukan Permintaan Baru | button | Ajukan Permintaan Baru | device-new-request | — | HTML saja: kebijakan belum ditetapkan; hanya inventory |

### perangkat-dicabut

| Elemen | Role | Accessible name usulan | data-testid usulan | Label | Sumber / state |
|---|---|---|---|---|---|
| Status Perangkat | — (getByLabel/getByTestId) | DICABUT | device-status | Status | Spec + HTML |
| Alasan Proses | — (getByLabel/getByTestId) | Alasan | device-process-reason | Alasan | HTML |
| Waktu Proses | — (getByLabel/getByTestId) | Dicabut | device-process-time | — | HTML |
| Diproses Oleh | — (getByLabel/getByTestId) | Diproses Oleh | device-processor | — | HTML: nama dan email |
| Bantuan | — (getByLabel/getByTestId) | Butuh bantuan? | device-help | — | HTML; nomor belum dikonfirmasi |
| Periksa Status | button | Periksa Status | device-check-status | — | HTML |

### dashboard

| Elemen | Role | Accessible name usulan | data-testid usulan | Label | Sumber / state |
|---|---|---|---|---|---|
| Dashboard | heading | Dashboard | dashboard-heading | — | Spec halaman utama; nama heading usulan |
| Jual Tiket | button | Jual Tiket | nav-sell-ticket | — | HTML menu; role tergantung komponen |
| Halaman Terlindungi | — (getByLabel/getByTestId) | Konten halaman terlindungi | protected-content | — | Spec; testid usulan |

### manajemen-device

| Elemen | Role | Accessible name usulan | data-testid usulan | Label | Sumber / state |
|---|---|---|---|---|---|
| Daftar Relasi | button | Daftar Relasi | nav-relations | — | Spec + HTML komponen sidebar |
| Manajemen Device | button | Manajemen Device | nav-device-management | — | Spec + HTML |
| Filter | button | Filter | device-filter-toggle | — | HTML |
| Nama Agen / Sub Agen | textbox | Nama Agen / Sub Agen | filter-account-name | Nama Agen / Sub Agen | HTML placeholder Cari nama |
| Jenis Akun | combobox | Jenis Akun | filter-account-type | Jenis Akun | HTML Semua/Agen/Sub Agen |
| String Code | textbox | String Code | filter-device-code | String Code | HTML placeholder Contoh: 7K4M-92QD |
| Perangkat | textbox | Perangkat | filter-device | Perangkat | HTML Cari nama perangkat / browser |
| Tanggal Permintaan | — (getByLabel/getByTestId) | Tanggal Permintaan | filter-request-date | Tanggal Permintaan | HTML date; fill via getByLabel/testid |
| Tanggal Approval | — (getByLabel/getByTestId) | Tanggal Approval | filter-approval-date | Tanggal Approval | HTML date; fill via getByLabel/testid |
| Diproses Oleh | combobox | Diproses Oleh | filter-processor | Diproses Oleh | HTML nama - email |
| Status | combobox | Status | filter-status | Status | HTML empat status + Semua |
| Reset | button | Reset | device-filter-reset | — | HTML |
| Tabel Device | table | Daftar perangkat Agen dan Sub Agen | device-table | — | HTML table tanpa nama; usulan |
| Data Akun | — (getByLabel/getByTestId) | Nama Agen / Sub Agen | device-account-cell | — | Spec: label, cabang, Agen induk; scope row |
| Data Perangkat | — (getByLabel/getByTestId) | Perangkat | device-info-cell | — | Spec nama/jenis/browser; HTML OS ikon mobile/desktop |
| Data Kode | — (getByLabel/getByTestId) | String Code | device-code-cell | — | HTML |
| Data Waktu | — (getByLabel/getByTestId) | Tgl Permintaan / Tgl Approval | device-time-cell | — | Spec tanggal+waktu |
| Data Pemroses | — (getByLabel/getByTestId) | Diproses Oleh | device-processor-cell | — | Spec nama/email |
| Data Status | — (getByLabel/getByTestId) | Status | device-status-cell | — | Spec empat status |
| Setujui | button | Setujui permintaan | device-approve | — | Spec Setujui; HTML title ikon |
| Tolak | button | Tolak permintaan | device-reject | — | Spec Tolak; HTML title ikon |
| Lihat Detail | button | Lihat detail | device-view | — | Spec + HTML title ikon |
| Cabut Perangkat | button | Cabut perangkat | device-revoke | — | Spec + HTML title ikon |
| Aktifkan Kembali | button | Aktifkan kembali | device-reactivate | — | Spec + HTML title ikon |
| Empty State | — (getByLabel/getByTestId) | Tidak Ada Data yang tersedia | device-empty | — | HTML |
| Ukuran Halaman | combobox | Menampilkan Data | device-page-size | Menampilkan Data | HTML 10/20/50 tanpa handler; nama usulan |
| Halaman Berikutnya | button | Halaman berikutnya | device-page-next | — | HTML komponen Pagination; nama usulan, hardcoded |
| Pagination | — (getByLabel/getByTestId) | Pagination | device-pagination | — | HTML komponen Pagination |
| Jumlah Menunggu | — (getByLabel/getByTestId) | Jumlah Menunggu | device-waiting-count | — | HTML badge tab |
| Notifikasi | status | Notifikasi proses perangkat | device-toast | — | HTML toast; role/name usulan |
| Tab Semua | button | Semua | device-tab-semua | — | HTML button; bukan role tab |
| Tab Menunggu | button | Menunggu | device-tab-menunggu | — | HTML button; bukan role tab |
| Tab Aktif | button | Aktif | device-tab-aktif | — | HTML button; bukan role tab |
| Tab Ditolak | button | Ditolak | device-tab-ditolak | — | HTML button; bukan role tab |
| Tab Dicabut | button | Dicabut | device-tab-dicabut | — | HTML button; bukan role tab |

### registrasi-device

| Elemen | Role | Accessible name usulan | data-testid usulan | Label | Sumber / state |
|---|---|---|---|---|---|
| Dialog Registrasi | dialog | Registrasi Device | device-register-dialog | — | HTML modal |
| String Code | textbox | String Code | registration-code | String Code | HTML XXXX-XXXX max 9 tampilan |
| Hasil Lookup | — (getByLabel/getByTestId) | Kode ditemukan. | registration-lookup | — | HTML akun/perangkat/waktu |
| Error Kode | alert | Kesalahan kode perangkat | registration-code-error | — | HTML pesan lookup; role/name usulan |
| Catatan | textbox | Catatan (opsional) | registration-note | Catatan (opsional) | HTML textarea |
| Daftarkan Perangkat | button | Daftarkan Perangkat | registration-confirm | — | HTML konfirmasi Setujui |
| Pilih Perangkat Dicabut | button | Pilih Perangkat Dicabut | registration-replace | — | HTML saat batas dua Aktif |
| Batal | button | Batal | registration-cancel | — | HTML |

### tolak-permintaan

| Elemen | Role | Accessible name usulan | data-testid usulan | Label | Sumber / state |
|---|---|---|---|---|---|
| Dialog Proses | dialog | Tolak Permintaan Device | device-process-dialog | — | HTML modal |
| Alasan | textbox | Alasan Penolakan | device-process-reason-input | Alasan Penolakan | HTML textarea wajib provisional |
| Konfirmasi | button | Tolak Permintaan | device-process-confirm | — | HTML |
| Batal | button | Batal | device-process-cancel | — | HTML |

### cabut-perangkat

| Elemen | Role | Accessible name usulan | data-testid usulan | Label | Sumber / state |
|---|---|---|---|---|---|
| Dialog Proses | dialog | Cabut Perangkat | device-process-dialog | — | HTML modal |
| Alasan | textbox | Alasan Pencabutan | device-process-reason-input | Alasan Pencabutan | HTML textarea wajib provisional |
| Konfirmasi | button | Cabut Perangkat | device-process-confirm | — | HTML |
| Batal | button | Batal | device-process-cancel | — | HTML |

### detail-perangkat

| Elemen | Role | Accessible name usulan | data-testid usulan | Label | Sumber / state |
|---|---|---|---|---|---|
| Dialog Detail | dialog | Detail Perangkat | device-detail-dialog | — | HTML modal |
| Detail Akun | — (getByLabel/getByTestId) | Akun / Relasi | device-detail-account | — | Spec + HTML |
| Detail Perangkat | — (getByLabel/getByTestId) | Nama Perangkat / Perangkat | device-detail-info | — | Spec + HTML |
| Detail Waktu | — (getByLabel/getByTestId) | Tgl permintaan / Tgl approval | device-detail-time | — | Spec + HTML |
| Riwayat | — (getByLabel/getByTestId) | RIWAYAT | device-history | — | Spec + HTML: aksi/tanggal/waktu/aktor/alasan |
| Cabut Perangkat | button | Cabut Perangkat | detail-revoke | — | HTML jika Aktif |
| Aktifkan Kembali | button | Aktifkan Kembali | detail-reactivate | — | HTML jika Dicabut |
| Tutup | button | Tutup | device-detail-close | — | HTML |

### aktifkan-kembali

| Elemen | Role | Accessible name usulan | data-testid usulan | Label | Sumber / state |
|---|---|---|---|---|---|
| Dialog Reaktivasi | dialog | Aktifkan Kembali Perangkat | device-reactivate-dialog | — | HTML |
| Catatan | textbox | Catatan (opsional) | reactivation-note | Catatan (opsional) | HTML opsional |
| Konfirmasi | button | Aktifkan Kembali | reactivation-confirm | — | HTML |
| Peringatan Batas | — (getByLabel/getByTestId) | Akun ini sudah memiliki 2 perangkat aktif (batas maksimal). Cabut salah satu perangkat aktif terlebih dahulu. | reactivation-limit | — | HTML |
| Batal | button | Batal | reactivation-cancel | — | HTML |

### batas-perangkat-aktif

| Elemen | Role | Accessible name usulan | data-testid usulan | Label | Sumber / state |
|---|---|---|---|---|---|
| Dialog Batas | dialog | Batas Perangkat Aktif | device-limit-dialog | — | HTML |
| Perangkat Lama | radio | Perangkat lama yang akan dicabut | device-limit-choice | Label perangkat + OS + browser | HTML input radio; locator getByLabel atau check |
| Konfirmasi | button | Cabut & Daftarkan yang Baru | device-limit-confirm | — | HTML |
| Batal | button | Batal | device-limit-cancel | — | HTML |

### Batas cakupan elemen

Ajukan Permintaan Baru pada Ditolak hanya dicatat dalam inventory karena kebijakan pengajuan ulang belum dinyatakan spec (A06). Footer, sosial media, banner, Lupa Kata Sandi, jadwal kapal dan sorting icon adalah existing/dekoratif di luar perubahan lock device; tidak dibuat kontrak perilaku baru. Bantuan dan lokasi diperiksa sebagai informasi, tanpa validasi nomor placeholder atau izin berdasar lokasi.

## Assumptions Log

| ID | Keputusan / keterbatasan |
|---|---|
| A01 | Tidak ada PNG di designs/. UI diturunkan dari spec dan struktur/teks HTML extras/1-lock-device-agen-dc.html; tidak ada klaim inspeksi visual atau eksekusi prototipe. Tidak ada extras biner. |
| A02 | Spec menjadi acuan saat konflik. Nama Perangkat opsional walaupun HTML menampilkan tanda * dan sendDisabled menolak nilai kosong. Skenario kosong mengharapkan pengiriman berhasil dan akan menangkap konflik implementasi. |
| A03 | Perubahan status server langsung menutup akses pada request terlindungi berikutnya, termasuk sesi aktif. Toleransi sesi maks. 5 menit pada HTML tidak dipakai sebagai acceptance criteria karena bertentangan dengan spec. Mekanisme polling/push dan SLA pembaruan visual belum ditentukan. |
| A04 | REQ-033–REQ-039 berasal dari extras dan bersifat provisional: format kode 8 karakter, nama maksimal 30, alasan wajib, catatan opsional, filter/tab/pagination, batas dua perangkat, serta kontrol pendukung. Ini bukan aturan bisnis yang telah dinyatakan di spec. |
| A05 | Identitas device adalah pasangan akun + device + browser dengan token server; algoritme fingerprint tidak diberikan. Konteks browser terpisah disiapkan fixture. Menghapus data browser atau incognito diperlakukan sebagai identitas baru sesuai informasi HTML; akun berbeda tidak mewarisi approval. |
| A06 | Kirim Ulang Kode pada Menunggu hanya mengulang notifikasi request yang sama, tidak membuat request/kode baru. Prototipe menawarkan Ajukan Permintaan Baru untuk Ditolak, tetapi kebijakan pengajuan ulang tidak ditetapkan spec: tidak dibuat acceptance scenario untuk transisi Ditolak ke request baru. |
| A07 | Nomor telepon Kantor Pusat belum dikonfirmasi; 031-xxxx-xxx adalah placeholder. Tidak menguji panggilan/nomor produksi. Lokasi perkiraan dari HTML informatif dan bukan syarat approval. |
| A08 | URL, endpoint, selector nyata, seed/reset data, kredensial valid dan hak akses existing tidak diberikan. Route route:... dan data sintetis harus dipetakan fixture codegen. Nama ARIA/testid adalah usulan; input tanggal native memakai getByLabel/getByTestId dengan fill; password tidak memiliki role textbox implisit. |
| A09 | Jika aturan batas dua perangkat dipakai, pencabutan lama dan approval baru harus konsisten/atomik. Race, error jaringan dan isolasi akun diuji sebagai guard terhadap bypass/integritas, bukan fitur endpoint baru. |
| A10 | Pagination prototipe hardcoded satu halaman dan ukuran halaman tidak punya handler; icon sort juga tidak punya handler. Pagination diuji sebagai rancangan provisional dengan fixture multi-halaman; sorting tidak diberi perilaku rekaan. |
| A11 | Data uji memakai akun/email sintetis, tanggal uji 8 Oktober 2026 zona Asia/Jakarta (WIB); tampilan zona lain sah bila menunjuk instant yang sama. Batas 30 karakter diuji ASCII; aturan hitung Unicode belum ditetapkan. Panjang max alasan/catatan/password tidak diinventarisasi sebagai aturan baru. |
| A12 | Stress memakai profil eksploratif 100–200 sesi, 10000 histori, dan teks 100000 karakter; tidak ada SLA atau batas kapasitas resmi. Fixture mengorkestrasi konteks, intersepsi jaringan, barrier race dan workload; hasil harus menjaga akses, status, histori dan idempotensi tanpa menjanjikan angka latensi. |
| A13 | Kewenangan Kantor Pusat diasumsikan dimiliki user uji berizin; role non-Agen/Sub Agen lain diwakili Kantor Cabang dengan hak existing. Lock device tidak memberikan hak akses Manajemen Device kepada role lain. Validasi credential mengikuti kontrak login existing, tanpa mengarang kebijakan kompleksitas password. |
| A14 | Preconditions menyediakan fixture data dan kondisi fault; steps hanya action skema yang diizinkan. expect.value memuat matcher untuk terlihat/tidak terlihat, disabled, jumlah, teks atau invariant server melalui fixture. Target berprefiks pusat::/agen::/subagen::/sesi-lain:: memilih konteks browser; fixture wajib memverifikasi invariant server, bukan sekadar teks UI. |
