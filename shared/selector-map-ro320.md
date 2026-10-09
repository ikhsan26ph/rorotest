# Selector Map — RO320 Batas Order User Umum

Terverifikasi 9 Oktober 2026, run `20261009-082337`, melalui Playwright langsung. Base URL dan akun tetap berasal dari `config/env.md`. Kredensial dan token tidak disimpan di sini. Inventaris sumber tergabung dalam `.analysis.md`; testid sumber adalah usulan.

| Layar | Elemen | Selector aktual | Catatan |
|---|---|---|---|
| Menu Admin/Pusat | Pengaturan Sistem | `getByRole('link', {name: /PENGATURAN SISTEM/i}).first()` | Exact uppercase gagal karena accessible name; regex terverifikasi |
| Menu | Batas Order User Umum | `getByRole('link', {name: 'Batas Order User Umum', exact: true})` | URL aktual `/pengaturan-sistem/` |
| Menu | Kontak Kantor Cabang | `getByRole('link', {name: 'Kontak Kantor Cabang', exact: true})` | URL aktual `/pengaturan-sistem/contacts` |
| Batas | Angka batas | `#order-limit-number` | type number, range sah 1–500 sesuai klarifikasi pengguna untuk load test; oracle sumber 1–10 sudah usang |
| Batas | Periode | `#order-limit-period` | readonly, nilai `Per hari kalender (reset 00:00 WIB)` |
| Batas | Status | `#order-limit-active` | option Aktif=`1`, Nonaktif=`0` |
| Batas | Pesan | `#order-limit-message` | textarea |
| Batas | Simpan | `getByRole('button', {name: 'Simpan Pengaturan', exact: true})` | Langsung POST; tidak ada modal konfirmasi diff pada run ini |
| Batas | Riwayat | `#settings-show-history` | modal `#settings-history-modal`, isi `#system-setting-history`, tutup `#settings-close-history` |
| Batas | Hasil/error simpan | `#settings-result-message` | HTTP error non-2xx diterjemahkan `Pengaturan gagal diproses.` |
| Batas | Tabel penolakan | `#order-rejection-rows` | Empat kolom Tanggal, Rute, Jumlah Penolakan, User Unik |
| Kontak | Jumlah per halaman | `#contact-page-size` | 10/25/50; tunggu `#branch-contact-rows[aria-busy]` selesai dan rows aktual |
| Kontak | Filter | `#btn-filter`, `#contact-port-filter`, `#contact-address-filter`, `#contact-whatsapp-filter`, `#contact-status` | Tidak memakai selector daftar partner umum |
| Kontak | Baris / paging | `#branch-contact-rows`, `#contact-pages`, `#contact-page-info` | 36 pelabuhan pada run; tidak diasumsikan tetap |
| Kontak | Ubah | `getByRole('button', {name: 'Ubah kontak <Nama> (<Kode>)', exact: true})` | Nama berasal dari response contactRows; scope port aktual |
| Edit kontak | Modal / form | `#contact-edit-modal`, `#branch-contact-form` | Form hanya port ID; pemilihan operator tidak ditemukan pada entry point ini |
| Edit kontak | Alamat / WA / Email | `#branch-address`, `#branch-whatsapp`, `#branch-email` | Email aktual berlabel Opsional; sumber A09 mengasumsikan wajib |
| Edit kontak | Hari | `#branch-contact-form [name=day][value="0".."6"]` | checkbox Senin sampai Minggu; accessible name hari penuh |
| Edit kontak | Pilih Semua | `#contact-select-all` | Mengaktifkan 7 checkbox |
| Edit kontak | 24 Jam | `#branch-contact-form [name=allDay]` | Meng-disable field jam; label zona terpisah dari preview 24 Jam tetap sah secara semantik |
| Edit kontak | Jam / zona / preview | `#branch-open`, `#branch-close`, `#contact-zone-label`, `#contact-preview-hours` | Jam interval 30 menit, zona mengikuti pelabuhan |
| Edit kontak | Simpan / Batal | `#branch-contact-form [type=submit]`, `#contact-cancel` | Simpan tetap enabled pada invalid; setelah klik, native/JS menolak WA sebelum request |
| Edit kontak | Validasi | `.popover-body`, `[aria-invalid=true]`, `#contact-error` | Error field lokal berbeda dari error request |
| Pencarian publik | Form rute | `#kota_asal`, `#kota_tujuan`, `#tgl_berangkat`, `#Carijadwal` | Value port diambil dari options aktual |
| Pencarian publik | Pilih / jumlah / Pesan | `[id^=btn_pilih]`, `.masukkan-jumlah:visible`, `.pesannya<scheduleID>:visible` | Schedule ID diperoleh dari kartu aktual; jangan menebak |
| Pencarian publik | Kuota | `.public-search-quota`, `.public-quota-card` | Counter admission endpoint dipakai sebagai bukti sebelum/sesudah |
| Pencarian publik | Error quota | native `dialog` | Fault quota memakai `window.alert`, bukan SweetAlert |
| Isi Data | Batal | `getByRole('link', {name: 'Batal', exact: true})` | Href aktual kembali `/home/pencarian`; tidak membuktikan penghapusan row tmp internal |

Endpoint yang ditemukan dari kode halaman aktual: GET `/pengaturan-sistem/settingsData`, GET `/pengaturan-sistem/contactRows`, GET `/pengaturan-sistem/quota?schedule=<ID>`, POST `/pengaturan-sistem/saveLimit`, POST `/pengaturan-sistem/saveContact`, POST `/home/savetmpbooking`. Jangan mengarang endpoint seed/reset/callback dari daftar ini.

Admin, Pusat, Cabang Pare-Pare, User Umum, dan tanpa sesi diperiksa. Sesi Agen terhenti di `/device`; tidak melakukan pendaftaran/bypass device. Hasil read-only tidak membuktikan write yang berhasil. Request mutasi valid pada pengujian fault/konfirmasi dicegah lokal; tidak ada perubahan setting tenant pada run ini.

## Verifikasi transaksi 9 Oktober 2026 — run20261009-104428

User pending: menu `a[href*="/home/daftarpembelian"]`, baris scopekodebooking, action `a[href*="/home/pilihpembayaran/"]`. Detailhref diambil dari halaman order. `#lanjut_bayar` membuat booking; pilihmetode `.pilihbankbayar:visible`. Error saveContact saat modal terbuka berada pada `#contact-error`, bukan alert global. Klik Pilih menunggu response `/pengaturan-sistem/quota` dan DOMdisabled sebelum assertion; networkidle saja sempat terlalu cepat. Dua pending penuh menampilkan `.public-quota-card-message` dan `[data-branch-contact-toggle]`, dialog `#branch-contact-dialog`, entri `.branch-contact-entry` sesuai urutan asal/tujuan. Nonaktif menyembunyikan panel kuota, tanpa badgeTANPA BATAS. QRIS menampilkan simulator aktual, tetapi belum dilunasi. Agen login valid diarahkan/device dengan identitas akun; helper `gatedByDevice` sudah diverifikasi.

## Resume akun/channel/rute — 20261009-121900

Cabang/Agen `a[href*="/partner/jualtiket"]` / `a[href*="/agen/jualtiket"]` membawa satu tiket ke form IsiData actual; quota publik tidak berubah. Menu ManajemenDevice dapat tersembunyi di grup collapsible: temukan actual `a[href*="/device/manage"]`, bukan menyimpulkan tidak ada dari rolelocator default. Baris sendiri `tr` filterkode, tombol aria `Setujui perangkat <code>` membuka modal REGISTRASI DEVICE; tombol `Daftarkan Perangkat` menyelesaikan POST dan approvalAktif. Admin hanya Detail; Pusat dapatapprove. Lokasi fixture0,0 dicatat sebagai simulasi; bukan lokasi fisik.

Private storageState Agen mode600 diuji pada context terpisah dan menuju/agen/beranda_agen; hanya role Agen terverifikasi. Device AUTOTEST NQAR-J4J6 dipertahankan untukresume. Jangan mencetakcookie/token dari fileauth. Pemulihanuser/forgotpassword memerlukan reCAPTCHA; tidak mem-bypassdan belum mengirimemail.

Tripfixture2338/2339 sudah dihapus/absence dua role. ReverseDetail2328 tampilpublik, sedangkanKRG→MJU2339tidak; tidak menyimpulkanRO320buguntukjadwal kosong. Tombol/linkBatal dapat tersembunyi; diagnosis formbuyer/passenger actual sebelum menerapkan oracle. Responsebody AJAXyang langsung navigasi jangan dibaca setelah halaman berganti.
