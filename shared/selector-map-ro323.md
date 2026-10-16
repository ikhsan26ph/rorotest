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

## Resume transaksi staging — 20261015-141411

- Top-up Agen Cabang memakai tautan row own `/partner/agen_topup/<opaqueId>`, `#nominal`, `#jenis_bidder` Transfer, `#btn-photo`, dan `button.simpan_topup`; native confirm wajib diterima. POST `/partner/agen_dotopup` redirect ke Riwayat Topup Agen. Timeout setelah klik dapat terjadi sesudah commit: periksa ledger own sebelum mengulang.
- Top-up Operator Admin memakai tautan Monitor Saldo `/adminprahu/op_topup/<opaqueId>`, nominal/dokumen, dan `.simpan_topup`; POST `/adminprahu/op_dotopup`. Inbox Pusat membuka `/partner/riwayatsaldo`.
- TOP melalui own Relasi Pelanggan (14 Hari), input booking `#kategoripembeli` relasi_pelanggan lalu `#pilihanrelasi`. Notifikasi Transaksi TOP muncul pada POST `/home/savebooking`, sebelum tahap `/home/simpanbayarcabang`. Fault uji create TOP harus dipasang pada savebooking.
- Detail TOP asli menuju `/notifikasi/piutang/<id>`, heading DETAIL PIUTANG; ini tujuan valid untuk identitas piutang/order. Daftar `/partner/daftarpiutang` memuat `button.kliklunas` bernilai ID piutang. SweetAlert `.swal2-confirm` berlabel Lunas mengirim POST `/partner/dolunas`.
- Katalog global berubah selama run: baseline47 pilihan menjadi40, tujuh key hilang (enam pemesanan Email/WA dan web:order-h1). Ambil katalog dan label aktual sebelum memilih kontrol; jangan membuat ulang key yang tidak tersedia. Sisa nilai global/personal yang disentuh dikembalikan ke baseline yang masih tersedia.
- Nonaktifkan pengiriman Email ViaGerai sementara untuk fixture TOP dengan alamat internal example.com; tidak memilih Kirim E-Tiket. Cetak saja, lalu ajukan pembatalan own dan setujui melalui UI. Pembatalan TOP own dewasa Rp310.000 menghasilkan denda Rp77.500 dan refund Rp232.500 pada H-1455; kuota2327 kembali1 setiap cleanup.

- Jadwal V1: ID kuota induk berbeda dari ID jadwal penjualan. Fixture kuota2370 menghasilkan kartu Jual Tiket2344. Ambil ID kartu dari DOM sesuai voyage, jangan menganggap ID sama. Waktu baru memakai input aria-label Waktu berangkat/tiba (zona) dengan format DD/MM/YYYY HH:mm, hidden Legs[rute][etd/eta] diperbarui oleh handler. Dismiss popup datepicker lewat Batal/Escape lalu pastikan hidden ISO sebelum Simpan.
- Crew V1: Masukkan Crew membuka #add-crew async, select.pilih-crew, #simpan-crew hanya memilih reference crew untuk form. Selesai menyelesaikan workflow dan kembali masterjadwal dengan pesan Jadwal Tampil; verifikasi state, jangan mengulang hanya karena listener endpoint sempit timeout. Tidak menggunakan Kirim ke Pelindo.


### Resume transaksi — 15 Oktober 2026, 17.16–17.36 WIB

- Event pembayaran baru tersimpan dengan `category: Notifikasi Order`; history lama `Order & Keberangkatan` masih tersedia. Baca kategori aktual dari row/opsi UI. Filter lama bisa menghasilkan false absence walau notifikasi ada.
- User QRIS: `.pilihbankbayar[data-channel="QRIS"]:visible` → Bayar Sekarang → link `UNTUK SIMULATOR KLIK DISINI` membuka popup `/home/simulator/` dan memproses dummy. Tunggu Detail **Order Selesai** setelah callback sebelum menilai commit; teks simulator saja belum cukup. Jangan ulang charge saat navigasi gagal.
- Agen payment fault lewat `context.route` untuk request `/home/simpanbayaragen`, cocokkan own idbooking. `page.route` tidak menangkap request ServiceWorker perangkat. Jangan mematikan worker/gate untuk menguji.
- Denda0 Agen: Cabang `/partner/buatpembatalan`, pilih ownjadwal2344 lalu `#pilih-pembatalan=kapal_tidak_berangkat`; tiketAgen muncul pada `#pilih-etiket`. Pilih hanya ownticket, verifikasi preview0, submit dan approvalPusat melalui hrefDetail aktual. Mode normal Cabang/Pusat tidak selalu menawarkan tiketAgen.
- Edit jadwal dari daftar: `#edit<quotaId>` membuka konten edit pada halaman daftar yang sama. Tab memakai `[data-toggle="tab"][href="#jadwal"]:visible` (bukan harus tag a); status `#jadwal select:visible` → valueTutup, `#simpan-jadwal`, POSTsimpanEditJadwal. Scope ownvoyage sebelum simpan; jangan klik tabJADWAL tersembunyi milik baris lain.
- RelasiAgen: detail own → hrefEditAgen aktual; `#status` value2=TidakAktif, `#submit_sub`. Sesudah save tujuan DetailAgen, status berada di barisStatus, bukan trNamaPerusahaan. Tombol tanpa teks pada list adalah Hapus dan membuka konfirmasi; Batal lalu gunakan Edit untuk nonaktif. Jangan menghapus audit saldo.
- EditPelanggan TOP: `button.edit_pelanggan:visible`; tunggu form async. Field tidak menyediakan status nonaktif pada pemeriksaan137. Recordfinansial dipertahankan; tombolBatal menutup form tanpa perubahan.


### Resume channel dan ACL — 15 Oktober 2026, 19.02–20.10 WIB

- Daftar Persetujuan Tiket terbaru memakai tombol `#detail<approvalId>` dan `#edit<approvalId>` tanpa href. Klik Detail lalu ambil URL aktual. Pada fixture88, UI menghasilkan `/partner/detailapprove/ODg=`; jangan menebak opaque ID atau memperbaiki link notifikasi saat assertion.
- SubUser own pada grup dengan permission bisnis dan `notif_web_*` menerima kontrol positif Kuota. Setelah permission dicabut, event baru tidak tersimpan untuk akun tersebut; cabang lain dengan permission/personal ON tidak menerima event cabang Parepare. Catat hak yang dicabut secara tepat, bukan hanya role.
- Pencabutan hanya `detail_persetujuan_tiket` pada grup own menolak Detail notifikasi dan URL bisnis resmi yang sebelumnya HTTP200; redirect ke profilsubuser tanpa isi record. Stale save preferensi TOP ditolak HTTP400 setelah hak TOP dicabut.
- Form pembatalan memuat daftar etiket async saat jadwal/mode berubah. Tunggu `jQuery.active === 0` sebelum memilih tiket, lalu verifikasi nilai `#pilih-etiket` tepat sebelum Cari. Callback kedua dapat mereset pilihan ke0; baca state sebelum retry pengajuan.
- Kapasitas booking Cabang fixture2344 terpapar2 (internal+eksternal), sedangkan public/Agen1. Assertion setup mengikuti kapasitas aktual, bukan menyalin konstanta lintas portal.
- Global choices40 dan personal diperiksa lewat endpoint choices yang digunakan UI; HTTP simpan serta inbox Push tidak membuktikan Email/WA sampai. Bukti receipt perlu mailbox/WA atau ledger provider yang terverifikasi.


### Approval Cabang kedua — 15 Oktober 2026, run20261015-213646

- Hilangnya `#edit<approvalId>` dari daftar sesudah Pusat menyetujui tidak membuktikan form approval Cabang tidak tersedia. Sebelum approval pertama, klik tombol Cabang dan simpan URL resmi yang dihasilkan UI. Pada own request89, `/partner/approve/ODk=` tetap HTTP200 dan form Cabang dapat menyetujui kedua meski row sudah DISETUJUI dan tombol edit hilang. Jangan menebak opaque ID atau mengulang approval pertama.
- Own orderI9207521: Pusat FIRST→Cabang SECOND menghasilkan notifikasi4789(Pusat)/4788(Cabang), body tepat “Pengajuan tiket gratis untuk order I9207521 telah disetujui Cabang Parepare. E-tiket sudah dapat diproses.” Pesan Pusat pertama yang menunggu tetap history terpisah; scope assertion pada judul/event Cabang kedua.
- Kedua Detail notifikasi tetap salah tujuan (dashboard Pusat/profilsubuser Cabang); kontrol positif dari tombol `#detail89` menu bisnis membuka `/partner/detailapprove/ODk=` dan record yang sama. Jangan memperbaiki link saat assertion. Body respons open dapat unavailable setelah navigation; simpan status dan tujuan akhir sebagai bukti, jangan mengarang payload atau mengklaim akar encoding tanpa source.


### Resume44 blocker — run20261015-214951

- Pagination exact10/11 dapat dibangun tanpa seed backend: own SubUser Pusat pada grup hanya Kuota (`membuat_all_jadwal`, `melihat_all_jadwal`, `lihat_daftar_pengajuan_kuota`, `detail_pengajuan_kuota`, dan3 notif_web_kuota). Inbox awal0;5 request own masing-masing dibuat+Ditolak memberi10 pesan; request6 memberi11 sebelumDitolak. UI limit10 menunjukkan satu halaman pada10 dan dua halaman pada11, page2 tepat1 tanpaduplikasi. Jangan mengubah role menjadi UserUmum untuk kasus ini: sumberEDG021 memang Pusat.
- EDG020 hanya memerlukan UserUmum dengan tepat1 pesan own; tidak harus akun baru. Env8 sudah login dengan inbox0 dan menghasilkan1 Push ownG9207703. Hapus pilihsemua aman hanya setelah assert seluruh dataset milik run; total0, bell0, selectionkosong danbulkdisabled terverifikasi. Untuk EDG013, inbox0 tidak membuktikan preferensi belum tersimpan; API account.lastSetting env8 sudahbernilai.
- EDG010 memakai dua form resmi Cabang/Pusat sebelum salah satu approve; tahan kedua request asli pada route doAksiPersetujuan, kirim konfirmasi bersama, releaseCabang→amati commit+notifpersisten→releasePusat. Submission191ms. Ini barrier permintaan dengan urutan commit teramati, bukan bukti overlap/rowlock DB.
- User8 inputpesanan memuat ID penumpang ganda; scope `#identitasDEWASA1:visible`, `#datepicker0:visible`. Listener popup simulator dapat timeout sesudah pembayaran berhasil dan originaltab sudah /home/cetaktiket/. Periksa Detail/OrderSelesai serta inbox server; jangan ulang pembayaran karena listener gagal.
- AdminFinance env7 autentikasi berhasil di SilverStripeCMS. Akun env1/AdminPrahu bukan kredensial CMS yang sama. CMS AddAdminPrahu tidak menyediakan CreateUserUmum. Root `.cms-content` pada SiteSettings dapat lebih dari1: scope elemen controller atau `.first()`. Field setting provider dibaca sebagai metadata; jangan tulis valueAPIkey/captcha/SMTP ke artefak.
- Settings menyediakan link_mgnotif, notification_queue, app_id, instanceEmail/WA, x_api_key dan tes_error_mgnotif. Pengiriman terkonfigurasi tidak sama dengan akses readledger. Relayroot200 hanya pesan APIberjalan; GETprefix404 tidak membuktikan POSTqueue rusak. Ikuti endpoint/dokumen nyata, jangan menebak route log/job.
- TOP H3 bisa diberi tanggal nyata melalui tenor pelanggan3hari dengan keberangkatan own2031. J9207789 transaks15Okt, jatuh18Okt2026, global/personalH3ON dan eventTOPcommit; jobH3 tidak terverifikasi. Untuk cleanup: Lunas pada rowown → SweetAlertLunas → dolunas, pastikan statusLunas dan kliklunas hilang; cetak saja, batalkan ownticket, approvePusat.
