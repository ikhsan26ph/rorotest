# Selector Map — RO323 Notifikasi Sistem

Diverifikasi melalui Playwright MCP pada15Oktober2026, run20261015-074926. Kredensial/base URL tetap dari config/env.md. UI inventory modul belum tersedia; selectorHints JSON merupakan usulan.

| Area | Kontrol | Selector/alur aktual |
|---|---|---|
| Portal | Bell | `a[title="Notifikasi"]` (desktop/mobile; pilih elemen visible); href aktual `/notifikasi/` |
| Portal | Badge unread | `[data-notification-badge]:not([hidden])`; status aktual dari GET `/notifikasi/status` |
| Pusat/Cabang/Agen | Preferensi | `a[href$="/notifikasi/preferences"]`; teks PREFERENSI NOTIFIKASI |
| User Umum | Preferensi | `a[href$="/home/preferencenotif"]` redirect ke `/notifikasi/preferences` |
| Admin | Preferensi | Label Preferensi Notifikasi pada grup SETTING; satu menu |
| Admin | Setting global | `a[href$="/adminprahu/settingNotifonof"]` redirect ke `/notifikasi/settings` |
| Semua | Ready | `#notification-content[aria-busy="false"]`; lanjutkan wait DOM untuk hasil async |
| Setting | Section | `details[data-section="Notifikasi Email|Notifikasi WhatsApp|Push Notifikasi JN Member|Push Notifikasi Sistem Web"] > summary`; tunggu properti open selesai animasi |
| Setting | Toggle | `input[data-keys]` dengan aria-label nama jenis/channel/penerima; semua kategori mempunyai array key |
| Preferensi | Checkbox | `input[data-choice="<key>"]`; contoh web:order-bayar, web:device-masuk, web:device-setuju, web:device-cabut |
| Preferensi | Klik checkbox | Input custom tertutup label. Ambil id dari input lalu klik `label[for="<id>"]`, verifikasi isChecked; jangan force atau dispatchEvent sebagai default |
| Setting/Preferensi | Counter | `.notification-counter[data-count-keys]` |
| Setting/Preferensi | Draft | `.notification-change-status` |
| Setting/Preferensi | Save/Cancel | `[data-save]`, `[data-cancel]`; disabled ketika bersih |
| Semua | Pesan aksi/error | `#notification-result`, `.is-error` |
| Inbox | Filter status | `[data-filter="read"]`: all/unread/read; label aktual Status |
| Inbox | Filter kategori | `[data-filter="category"]`; opsi berasal history eligible akun |
| Inbox | Page size | `[data-filter="limit"]`:10/20/50 |
| Inbox | Baris/own scope | `.notification-row`, `[data-select="<notificationId>"]`, `[data-read="<notificationId>"]`, `[data-detail="<notificationId>"]` |
| Inbox | Unread | `.notification-row.is-unread`, `.notification-unread-dot` |
| Inbox | Select all | `[data-select-all]`; indeterminate saat parsial. uncheck() pada checkedfalse dapat no-op; check lalu uncheck untuk clear |
| Inbox | Selection count | `[data-selected-count]` |
| Inbox | Bulk | `[data-bulk="delete"]`, `[data-bulk="read"]`; disabled tanpa seleksi |
| Inbox | Empty | `.notification-empty`: Tidak ada notifikasi yang tersedia. |
| Preferensi | Empty | `.notification-empty`: Belum ada notifikasi yang tersedia. |
| Inbox | Pagination | `.dataTables_info`; nav aria-label Halaman notifikasi; link aria-label Selanjutnya/Sebelumnya/Awal/Halaman N |
| Inbox | Page2 back | Link Awal setara kembali ke1; Sebelumnya baru ditawarkan mulai halaman3 |
| Device | Detail Pusat | POST open mengarah `/device/detail/<ID>`; halaman menampilkan nama/kode/status/riwayat |
| Device | Detail Agen | Disabled; membaca isi melalui `[data-read]` tanpa navigasi |

Endpoint yang dibaca dari script UI aktual: GET `/notifikasi/rows?page=&limit=&read=&category=`, GET `/notifikasi/choices?mode=settings|preferences`, GET `/notifikasi/status`; POST `/notifikasi/save` (mode,values JSON), `/notifikasi/update` (type read/delete,ids[]), `/notifikasi/open` (id). SecurityID berasal dataset token root `#web-notifications`; nilainya privat dan tidak ditulis di dokumen/hasil. Endpoint ini bukan seed/job/clock adapter.

Baseline global: Email14/14,WA0/6,Push aplikasi0/1,Web26/26. Topup-p/c/a merupakan satu key web:topup dengan template sesuai penerima. Pusat9kategori26Push; Cabang8kategori23Push; Agen4kategori9Push; UserUmum1kategori2Push serta Email existing. Jangan memakai angka ini sebagai konstanta run berikutnya: verifikasi baseline aktual.

Hapus/bulk read harus di-scope pada notifikasi milik run; jangan PilihSemua pada history existing untuk mutasi. Run ini menemukan toast bulk umum tanpa jumlah dan seleksi masih aktif setelah read; lihat triage. Snapshot tidak dipakai pada jalur eksekusi normal.


## Resume 15 Oktober 2026 — 20261015-090250

| Area | Kontrol/alur | Selector dan observasi |
|---|---|---|
| Jual tiket Cabang | Filter jadwal | #tgl_berangkat, #tgl_berangkat2, tombol #Carijadwal (accessible name memuat ikon/spasi). Filter tanggal2030 diverifikasi dari query. |
| Jual tiket | Kuota jadwal2327 | #btn_pilih2327 → #masukan-jumlah23271; max_kuota aktual1. Kuota penumpang dipakai bersama. |
| Bayar Cabang | Gratis | label.radio_gratis, #btn-upload-surat-tugas, #namainstansinyaa, #lanjut_tiket. Surat dummy dan instansi AUTOTEST, total0. |
| Persetujuan gratis | Own row82 | #detail82 membuka /partner/detailapprove/ODI=; #edit82 membuka /partner/approve/ODI=. |
| Persetujuan gratis | Approve | #status SETUJU/TOLAK, #keterangan, #simpan → SweetAlert tombol Yakin → POST /partner/doAksiPersetujuan. |
| Notifikasi gratis | Detail | /notifikasi/open mengembalikan /partner/detailapprove/ODI%3D pada notif3138; route encoded ditolak, route resmi rawpadding "=" berhasil. Jangan mengganti URL saat verdict, karena itu menutupi bug. |
| E-tiket Gratis | Konfirmasi kirim | .kirim_tiket via label terkait id, .kirim_tiket_email ke kontak test; #proses_tiket → /home/sendtiket dan /home/selesaiPayment. Tidak membuktikan delivery inbox. |
| Pembatalan Cabang | Buat | Link Buat Pembatalan dari /partner/pembatalantiket menuju /partner/buatpembatalan. |
| Pembatalan Cabang | Cari own tiket | #tgl_berangkat/#tgl_berangkat2 range maksimal30hari; #pilih-jadwal, #pilih-pembatalan batal_tiket, #pilih-etiket; #cari-tiket. Tunggu [name=ket_denda] dan jQuery.active0; .div_tiket dapat visible sebelum data selesai. |
| Pembatalan Cabang | Submit | [name=ket_denda], tombol Batalkan Tiket → SweetAlert Konfirmasi → /partner/dobataltiket. Nilai refund/denda preview diverifikasi, bukan dimanipulasi. |
| Pembatalan | Detail | a[title="Detail Pengajuan"] → /pembatalan/detail/ID. Pusat dapat approve/reject, Cabang pengaju hanya detail/cancel request. |
| Pembatalan Pusat | Modal resmi | Tolak atau Setujui Pembatalan → #cancellation-reason (reject), #cancellation-confirm. Ini modal aplikasi, bukan .swal2-popup; POST /pembatalan/process. |
| Top-up Agen | Form | #nominal, #jenis_bidder Transfer/Tunai, #btn-photo file, #photo filename, tombol Simpan. Resume hanya persiapan Rp10.000 tanpa submit. |

Nama buyer/penumpang pada form input dinormalisasi menjadi huruf saja; prefix tanggal/digit/hyphen terhapus. Identifikasi own memakai kodebooking + instansi/dokumen/catatan yang mempertahankan AUTOTEST-tanggal-run. Filter tanggal diberi nilai DOM lalu event UI pada diagnosis/preparation jika inputmask bermasalah; bukan perubahan jam server. Sidebar link dapat di luar viewport: href yang sudah diverifikasi dapat dibuka melalui goto; jangan menebak URL. Response body AJAX dapat hilang sesudah navigation; simpan HTTP/status dan verifikasi UI/status/own notification, jangan mengulang commit tanpa memeriksa state.

## Resume 15 Oktober 2026 — 20261015-100755

- Kuota V1: `/partner/tambahjadwal` memakai `#trayek`, `#kapal`, `#nomor_voyage`, `Quota[p5][internal]`. Draft `button[name="Mode"][value="draft"]`; final `#simpan-kuota` membuka dialog dan baru mengirim setelah `[data-dialog-submit]`. POST native `/kuota-jadwal/saveQuota`; final kembali ke form edit, draft ke daftar. Tunggu navigation, jangan mengharuskan final redirect ke daftar.
- ID/Round tersembunyi dapat muncul lebih dari sekali: scope form atau `.first()`. Daftar `/partner/masterjadwal`, scope row dengan voyage AUTOTEST milik run. Pusat `[data-quota-list-action="approve|reject"]`, dialog `#quota-list-dialog`, alasan `#quota-list-reason`, konfirmasi `[data-quota-dialog-confirm]`, POST `/kuota-jadwal/decide`.
- Kuota disetujui berstatus **Isi Jadwal**; ini belum membuat/menerbitkan jadwal keberangkatan. Kuota2365/2366/2367 dibuat tanpa tanggal keberangkatan.
- Inbox kategori perangkat aktual **Manajemen Device**, bukan Device. Query kategori salah dapat menghasilkan daftar kosong; pastikan kontrol positif event milik run ditemukan sebelum assertion absence.
- Agen pada gate Baru/Menunggu belum dapat membaca endpoint inbox (dapat merespons HTML). Gunakan viewer perangkat milik run yang sudah Aktif untuk mengamati notifikasi akun Agen. Perangkat78/79 run ini selesai dicabut.
- Dialog perangkat dirender async. Untuk revoke/reject, tunggu `#device-action-note` visible sebelum fill; `isVisible()` terlalu dini dapat melewati alasan wajib. Ini masalah timing executor.
- Cetak e-tiket Gratis tanpa email: `label[for="exampleCustomInline1"]` lalu `#proses_tiket`; POST `/home/selesaiPayment`, UI **Cetak Tiket Berhasil**. Tidak mengirim ke kontak tambahan.
- Setelah fault transport pengajuan Gratis, tombol dapat tetap disabled. Reload form, pastikan pengajuan belum commit lewat status/own notification, kemudian ulangi normal. Jangan mengulangi save hanya karena response/navigation hilang.
- Fault HTTP500 pada endpoint bisnis dipenuhi sebelum origin dan diberi label batasan **transport sebelum commit**. Ini bukan bukti rollback transaksi database, dan tidak menggantikan fixture backend untuk kegagalan sesudah server mulai transaksi.

Tambahan penutupan: Preferensi User Umum merangkum payment Email/WA/Push bersama reminder Push dalam `.notification-group` **Order & Keberangkatan** (4 pasangan saat WA eligible); katalog API legacy masih menyebut User Online. Gunakan DOM grup, bukan menganggap kategori katalog API adalah layout UI. Master `input[aria-label="Semua preferensi Order & Keberangkatan"]` diklik melalui label pembungkus. POS091 membuktikan0/4→4/4→3/4; POS090 memakai globalH1 sementaraOFF untuk fixturepayment2/3, lalu dipulihkan. WA global sementaraON tidak dipakai memicu transaksi atau pengiriman. Nilai personalWA awal ketika direvealON dicatat dan dipulihkan walaupun global akhirOFF.

CMS cleanup AdminUtama own: daftar terverifikasi `/admin/my-account/`, scope nama AUTOTEST dan `#action_SoftDeleteRecord19587`. Respons200, row own hilang. Tombol Delete form edit hanya menampilkan konfirmasi dan tidak menyelesaikan penghapusan pada percobaan ini; jangan menebak endpoint atau menganggap timeout berarti terhapus.
