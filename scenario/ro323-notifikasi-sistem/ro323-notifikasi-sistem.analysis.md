# Analysis — ro323-notifikasi-sistem

## Requirements

67 requirement, diurai dari spec.txt dan perilaku daftar pada extras. Req extras ditandai sumbernya; asumsi tidak menggantikan aturan eksplisit.

| REQ | Kunci | Deskripsi / acceptance criteria | Sumber | Layar |
|---|---|---|---|---|
| REQ-001 | envelope | Notifikasi memuat judul, isi, tanggal, waktu, dan Detail dengan data aktual tanpa placeholder. | Push Notifikasi 1,4,7 | notifikasi |
| REQ-002 | recipients | Distribusi sesuai role, relasi transaksi dan kepemilikan; isi dapat berbeda antar role. | Push Notifikasi 2,3,6; Push Sistem Web 9 | notifikasi |
| REQ-003 | read | Notifikasi unread ditandai; membuka isi atau Detail mengubah hanya notifikasi akun terkait menjadi read. | Push Notifikasi 8,9 | notifikasi |
| REQ-004 | access | Detail menuju record terkait dan tetap tunduk pada hak akses; URL langsung tidak melewati otorisasi. | Push Notifikasi 5,10 | notifikasi |
| REQ-005 | individual-order | Pengajuan tiket gratis diproses per ID Order; status dan notifikasi order lain tidak tercampur. | Persetujuan Tiket Gratis 3 | notifikasi |
| REQ-006 | device-history | History pencabutan approval tetap tersedia untuk Agen; Detail seluruh notifikasi device Agen disabled. | Manajemen Device general 4; Pencabutan 4 | notifikasi |
| REQ-007 | actual-data | Nominal, saldo, identitas, voyage, tanggal, alasan, denda dan poin diambil dari proses aktual, bukan fixture prototipe. | Push Notifikasi 7 | notifikasi |
| REQ-008 | topup-p | Top Up Saldo Berhasil: hanya trigger top-up operator/cabang berhasil; penerima Kantor Pusat; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Top Up Saldo Berhasil | notifikasi |
| REQ-009 | topup-c | Top Up Saldo Agen Berhasil: hanya trigger Cabang berhasil top-up Agen; penerima Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Top Up Saldo Agen Berhasil | notifikasi |
| REQ-010 | topup-a | Saldo Berhasil Ditambahkan: hanya trigger saldo Agen berhasil ditambah Cabang; penerima Agen; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Saldo Berhasil Ditambahkan | notifikasi |
| REQ-011 | free-request | Pengajuan Tiket Gratis: hanya trigger pengajuan tiket gratis berhasil dibuat; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Pengajuan Tiket Gratis | notifikasi |
| REQ-012 | free-c | Tiket Gratis Disetujui Cabang: hanya trigger approval Cabang berhasil; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Tiket Gratis Disetujui Cabang | notifikasi |
| REQ-013 | free-p | Tiket Gratis Disetujui Pusat: hanya trigger approval Pusat berhasil; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Tiket Gratis Disetujui Pusat | notifikasi |
| REQ-014 | top-create | Transaksi Pembayaran TOP: hanya trigger order TOP berhasil dibuat; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Transaksi Pembayaran TOP | notifikasi |
| REQ-015 | top-paid | Piutang TOP Telah Lunas: hanya trigger piutang TOP ditandai lunas; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Piutang TOP Telah Lunas | notifikasi |
| REQ-016 | top-h3 | Piutang TOP Jatuh Tempo H-3: hanya trigger job tanggal H-3 untuk piutang belum lunas; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Piutang TOP Jatuh Tempo H-3 | notifikasi |
| REQ-017 | top-h0 | Piutang TOP Jatuh Tempo Hari Ini: hanya trigger job pada tanggal jatuh tempo piutang belum lunas; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Piutang TOP Jatuh Tempo Hari Ini | notifikasi |
| REQ-018 | payment | Pembayaran Berhasil: hanya trigger pembayaran order berhasil; penerima Kantor Pusat, Kantor Cabang, Agen, User Umum; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Pembayaran Berhasil | notifikasi |
| REQ-019 | departure | Pengingat Keberangkatan: hanya trigger job H-1 jadwal tiket milik penerima; penerima Kantor Pusat, Kantor Cabang, Agen, User Umum; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Pengingat Keberangkatan | notifikasi |
| REQ-020 | device-new | Pengajuan Device Baru: hanya trigger pengajuan device berhasil; penerima Kantor Pusat, Agen; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Pengajuan Device Baru | notifikasi |
| REQ-021 | device-approved | Pengajuan Device Disetujui: hanya trigger approval device Pusat berhasil; penerima Kantor Pusat, Agen; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Pengajuan Device Disetujui | notifikasi |
| REQ-022 | device-revoked | Pencabutan Approval Device: hanya trigger pencabutan approval device berhasil; penerima Kantor Pusat, Agen; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Pencabutan Approval Device | notifikasi |
| REQ-023 | cancel-request | Pengajuan Pembatalan: hanya trigger pengajuan pembatalan tiket berhasil; penerima Kantor Pusat, Kantor Cabang, Agen; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Pengajuan Pembatalan | notifikasi |
| REQ-024 | cancel-approved | Pembatalan Disetujui: hanya trigger pembatalan disetujui; penerima Kantor Pusat, Kantor Cabang, Agen; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Pembatalan Disetujui | notifikasi |
| REQ-025 | cancel-rejected | Pembatalan Ditolak: hanya trigger pembatalan ditolak; penerima Kantor Pusat, Kantor Cabang, Agen; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Pembatalan Ditolak | notifikasi |
| REQ-026 | quota-request | Pengajuan Kuota: hanya trigger Cabang berhasil mengajukan kuota; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Pengajuan Kuota | notifikasi |
| REQ-027 | quota-approved | Kuota Disetujui: hanya trigger pengajuan kuota disetujui Pusat; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Kuota Disetujui | notifikasi |
| REQ-028 | quota-rejected | Kuota Ditolak: hanya trigger pengajuan kuota ditolak Pusat; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Kuota Ditolak | notifikasi |
| REQ-029 | member-request | Pengajuan Member: hanya trigger pendaftaran JN Member berhasil; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Pengajuan Member | notifikasi |
| REQ-030 | member-approved | Member Disetujui: hanya trigger pendaftaran member disetujui; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Member Disetujui | notifikasi |
| REQ-031 | member-rejected | Member Ditolak: hanya trigger pendaftaran member ditolak; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Member Ditolak | notifikasi |
| REQ-032 | member-reverify | Verifikasi Ulang Member: hanya trigger pengajuan ulang setelah ditolak berstatus Waiting Verifikasi; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Verifikasi Ulang Member | notifikasi |
| REQ-033 | reward-request | Pengajuan Reward Masuk: hanya trigger Member mengajukan penukaran reward berhasil; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Pengajuan Reward Masuk | notifikasi |
| REQ-034 | reward-approved | Pengajuan Reward Diterima: hanya trigger pengajuan reward disetujui; penerima Kantor Pusat, Kantor Cabang, Member; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Pengajuan Reward Diterima | notifikasi |
| REQ-035 | reward-rejected | Pengajuan Reward Ditolak: hanya trigger pengajuan reward ditolak; penerima Kantor Pusat, Kantor Cabang, Member; judul, isi aktual, dan tujuan sesuai matriks kontrak. | Pengajuan Reward Ditolak | notifikasi |
| REQ-036 | setting-access | Setting Notifikasi tampil hanya di admin Prahu; akses hanya Admin Utama Prahu termasuk URL langsung. | Setting general 2-4 | setting-notifikasi |
| REQ-037 | global-gate | Global OFF mencegah pengiriman seluruh akun dan menghilangkan pilihan Preferensi; ON tetap tunduk trigger/role/akses/owner/preferensi. | Setting general 5-8; Push Web 8-10 | setting-notifikasi |
| REQ-038 | setting-sections | Empat section Email, WhatsApp, Push JN Member, Push Sistem Web dapat expand/collapse, dengan counter aktif/total. | Setting general 9-13,21 | setting-notifikasi |
| REQ-039 | setting-save | Setting memuat nilai tersimpan; perubahan berlaku hanya setelah Simpan berhasil dengan informasi sukses. | Setting general 13,14,16,20 | setting-notifikasi |
| REQ-040 | setting-cancel | Batal memulihkan setting tersimpan; saat bersih tombol boleh disabled dan indikator perubahan opsional. | Setting general 15,17-19 | setting-notifikasi |
| REQ-041 | email | Email existing dipertahankan, dikelompokkan User Online, Operator, Pembeli Via Gerai, Pembeli Via Agen; toggle per jenis mengatur kiriman/pilihan. | Setting Email 1-8 | setting-notifikasi |
| REQ-042 | whatsapp | WhatsApp hanya jenis yang mendukung; kelompok User Online, Pembeli Via Gerai, Pembeli Via Agen; default awal OFF; toggle mengatur kiriman/pilihan. | Setting WhatsApp 1-9 | setting-notifikasi |
| REQ-043 | push-jn | Toggle Push JN Member mengatur ketersediaan/pengiriman aplikasi; ON memakai rule existing. | Push JN Member 1-4 | setting-notifikasi |
| REQ-044 | web-catalog | Push Sistem Web memuat sembilan kategori; tiap jenis mempunyai nama, trigger, penerima dan toggle; counter kategori akurat. | Push Sistem Web 1-4,11 | setting-notifikasi |
| REQ-045 | web-all | Semua mengubah seluruh jenis dalam kategori; per-jenis hanya mengubah jenis itu dan tidak mengubah penerima. | Push Sistem Web 5-8 | setting-notifikasi |
| REQ-046 | preference-menu | Preferensi Notifikasi tersedia menurut jenis akun; admin Prahu menu dipindah ke Setting dengan label Preferensi Notifikasi. | Preferensi general 1,2 | preferensi-notifikasi |
| REQ-047 | preference-isolation | Preferensi dan perubahan channel bersifat per akun, tidak mengubah user lain ataupun setting global. | Preferensi general 2-4 | preferensi-notifikasi |
| REQ-048 | preference-filter | Hanya jenis/channel global ON, role benar, akses sah dan channel didukung ditawarkan; semua tidak tersedia dapat menyembunyikan jenis/kategori. | Preferensi general 5-12 | preferensi-notifikasi |
| REQ-049 | preference-empty | Jika tidak ada pilihan tersedia tampil persis Belum ada notifikasi yang tersedia. | Preferensi general 13 | preferensi-notifikasi |
| REQ-050 | preference-save | Muat preferensi terakhir; akun baru aktif sesuai global/default sistem; Simpan permanen dan tanggal setting terakhir diperbarui hanya saat sukses. | Preferensi general 14-17,20,21 | preferensi-notifikasi |
| REQ-051 | preference-cancel | Batal mengembalikan pilihan tersimpan; tombol bersih boleh disabled tanpa mengubah tanggal terakhir. | Preferensi general 16,18,19 | preferensi-notifikasi |
| REQ-052 | preference-all | Header kategori counter dipilih/tersedia; Semua mengatur hanya pasangan jenis-channel yang tersedia untuk akun. | Grouping Preferensi 1-7 | preferensi-notifikasi |
| REQ-053 | channels | Email, WhatsApp dan Push independen; mematikan satu tidak mematikan lainnya; global OFF tidak dapat dipilih. | Rule Channel Preferensi 1-7 | preferensi-notifikasi |
| REQ-054 | role-p | Pusat dapat memilih 9 kategori Push sesuai daftar spec; tetap difilter hak akses. | Preferensi Kantor Pusat 1-10 | preferensi-notifikasi |
| REQ-055 | role-c | Cabang dapat memilih 8 kategori Push; Manajemen Device tidak tampil; Top Up memakai alias spec; filter akses. | Preferensi Kantor Cabang 1-10 | preferensi-notifikasi |
| REQ-056 | role-a | Agen hanya Top Up, Order & Keberangkatan, Device, Pembatalan; tidak ada Tiket Gratis/TOP/Kuota/JN Member/Reward. | Preferensi Agen 1-5 | preferensi-notifikasi |
| REQ-057 | role-u | User Umum hanya Order & Keberangkatan; Member terkait juga Reward Diterima/Ditolak; Email/WA existing dipertahankan. | Preferensi User Umum/Member 1-4 | preferensi-notifikasi |
| REQ-058 | migration | Penambahan Push dan pemisahan global/personal tidak menghapus katalog atau me-reset preferensi Email/WA existing. | Penyesuaian existing 1-10 | preferensi-notifikasi |
| REQ-059 | restore | Global lebih tinggi, OFF tidak menghapus preferensi tersimpan; ON kembali menggunakan pilihan terakhir. | General Setting/Preferensi 1-6 | preferensi-notifikasi |
| REQ-060 | persistence | Setting dan preferensi permanen melintasi logout/login, sesi dan browser. | General Setting/Preferensi 7-9 | preferensi-notifikasi |
| REQ-061 | list-entry | Tombol bell Notifikasi membuka daftar dan indikator bell menunjukkan unread akun sendiri. | extras 6-push: header hasUnread/goNotif; routing diasumsikan | notifikasi |
| REQ-062 | list-filter | Filter status Semua/Belum Dibaca/Sudah Dibaca dan kategori bekerja bersama tanpa kebocoran data. | extras 6-push: readOpts,katOpts,setRead,setKat | notifikasi |
| REQ-063 | list-select | Checkbox baris/Pilih Semua mengatur seleksi hasil filter dan counter; perubahan filter membersihkan seleksi. | extras 6-push: toggleAll,selCount,setRead,setKat | notifikasi |
| REQ-064 | list-delete | Hapus Notifikasi menghapus hanya seleksi akun; disabled tanpa seleksi; toast jumlah akurat. | extras 6-push: delSel,noSel | notifikasi |
| REQ-065 | list-bulk-read | Tandai Sudah Dibaca mengubah hanya seleksi akun; disabled tanpa seleksi; toast jumlah akurat. | extras 6-push: readSel,noSel | notifikasi |
| REQ-066 | list-empty | Daftar kosong/filter tanpa hasil menampilkan Tidak ada notifikasi yang tersedia. dan kontrol seleksi tidak aktif. | extras 6-push: empty,allOn | notifikasi |
| REQ-067 | list-pagination | Menampilkan 10/20/50 Data dan pagination menampilkan range/total hasil filter. | extras 6-push: pageSizes,pager; pagination nyata asumsi A09 | notifikasi |

### Aktor dan hak akses

| Aktor | Hak |
|---|---|
| Admin Utama Prahu | Pengaturan global dan preferensi akun sendiri; bukan penerima semua event secara otomatis. |
| Admin Prahu lain | Preferensi sendiri; Setting Notifikasi global dilarang. |
| Kantor Pusat | Semua 9 kategori Push sesuai transaksi dan permission. |
| Kantor Cabang | Semua kategori selain Device; scope cabang terkait. |
| Agen | Saldo, Order/Keberangkatan, Device, Pembatalan; Detail Device disabled. |
| User Umum / Member | Order/Keberangkatan sendiri; Member terkait tambahan hasil Reward. |

### Aturan validasi dan batas data

| Objek | Validasi |
|---|---|
| Pengiriman | global ON ∧ preferensi channel ON ∧ trigger sah ∧ role benar ∧ akses sah ∧ transaksi terkait. |
| Body | Template persis sesuai role, tidak menyisakan [placeholder]; semua nilai fixture aktual; tanggal/jam harus valid. |
| Nominal/saldo/denda/poin | Uji nilai aktual dari transaksi; spec tidak menetapkan min/max maupun formula denda. |
| Setting | Draft tidak efektif; sukses Simpan baru efektif; Batal mengembalikan nilai tersimpan. |
| Preferensi | Counter per jenis-channel; default tersimpan menang atas default baru; tanggal register/nama tidak berubah saat Simpan. |
| Scheduler | H-3 TOP, hari H TOP, H-1 keberangkatan; clock zona bisnis terkendali. |

### Alur utama dan alternatif

1. Fixture memproses transaksi sukses → gating global/personal/role/owner/akses → pesan aktual unread → baca isi atau Detail → read; navigasi menuju record sah. Transaksi gagal atau gating OFF → tidak ada pesan event tersebut.
2. Dua approval Tiket Gratis dapat berjalan Cabang dahulu atau Pusat dahulu; isi pesan bergantung status approval pihak lain pada commit. Semua ditelusuri per ID Order.
3. Admin membuka Setting → expand section → ubah toggle per jenis/Semua → Simpan sukses atau Batal. Draft belum mengubah pengiriman maupun pilihan Preferensi.
4. Akun membuka Preferensi → pilihan difilter → ubah channel/Semua → Simpan dan perbarui tanggal, atau Batal. Global OFF menghilangkan pilihan tanpa menghapus preferensi sebelumnya.
5. Daftar: filter → seleksi → hapus/tandai read → toast/counter; status dan penghapusan per akun.

### Matriks kontrak notifikasi dan contoh data uji

Data berikut adalah kontrak kasus dari spec; identifier dan nominal adalah fixture, bukan hardcode produksi. Destinations memakai ID record, bukan voyage sebagai ID pengajuan kuota. null berarti Detail disabled. Semua clock contoh historis sengaja dibekukan, tidak memakai waktu runtime.

```json
[
  {
    "requirement": "REQ-008",
    "key": "topup-p",
    "title": "Top Up Saldo Berhasil",
    "category": "Top Up Saldo",
    "trigger": "top-up operator/cabang berhasil",
    "failedTrigger": "top-up operator/cabang gagal",
    "roles": [
      "Kantor Pusat"
    ],
    "bodies": {
      "Kantor Pusat": "Top up saldo Cabang Balikpapan sebesar Rp5.000.000 berhasil. Saldo saat ini Rp12.450.000."
    },
    "destinations": {
      "Kantor Pusat": "Riwayat Saldo > TU-CBG-001"
    },
    "data": {
      "recordId": "TU-CBG-001",
      "nominal": 5000000,
      "saldo": 12450000,
      "nama": "Cabang Balikpapan"
    }
  },
  {
    "requirement": "REQ-009",
    "key": "topup-c",
    "title": "Top Up Saldo Agen Berhasil",
    "category": "Top Up Saldo",
    "trigger": "Cabang berhasil top-up Agen",
    "failedTrigger": "top-up Agen dibatalkan sebelum berhasil",
    "roles": [
      "Kantor Cabang"
    ],
    "bodies": {
      "Kantor Cabang": "Top up saldo PT. Agen RORO Balikpapan sebesar Rp5.000.000 berhasil. Saldo agen saat ini Rp12.450.000."
    },
    "destinations": {
      "Kantor Cabang": "Riwayat Saldo > TU-AGN-001"
    },
    "data": {
      "recordId": "TU-AGN-001",
      "nominal": 5000000,
      "saldo": 12450000,
      "agen": "PT. Agen RORO Balikpapan"
    }
  },
  {
    "requirement": "REQ-010",
    "key": "topup-a",
    "title": "Saldo Berhasil Ditambahkan",
    "category": "Top Up Saldo",
    "trigger": "saldo Agen berhasil ditambah Cabang",
    "failedTrigger": "penambahan saldo Agen gagal",
    "roles": [
      "Agen"
    ],
    "bodies": {
      "Agen": "Saldo sebesar Rp5.000.000 telah ditambahkan oleh Cabang Balikpapan. Saldo Anda saat ini Rp12.450.000."
    },
    "destinations": {
      "Agen": "Riwayat Saldo > TU-AGN-001"
    },
    "data": {
      "recordId": "TU-AGN-001",
      "nominal": 5000000,
      "saldo": 12450000,
      "cabang": "Cabang Balikpapan"
    }
  },
  {
    "requirement": "REQ-011",
    "key": "free-request",
    "title": "Pengajuan Tiket Gratis",
    "category": "Persetujuan Tiket Gratis",
    "trigger": "pengajuan tiket gratis berhasil dibuat",
    "failedTrigger": "pengajuan tiket gratis gagal dibuat",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang"
    ],
    "bodies": {
      "Kantor Pusat": "Pengajuan tiket gratis untuk order G8902260 telah masuk dan menunggu persetujuan.",
      "Kantor Cabang": "Pengajuan tiket gratis untuk order G8902260 telah masuk dan menunggu persetujuan."
    },
    "destinations": {
      "Kantor Pusat": "Persetujuan Tiket > Detail G8902260",
      "Kantor Cabang": "Persetujuan Tiket > Detail G8902260"
    },
    "data": {
      "recordId": "G8902260"
    }
  },
  {
    "requirement": "REQ-012",
    "key": "free-c",
    "title": "Tiket Gratis Disetujui Cabang",
    "category": "Persetujuan Tiket Gratis",
    "trigger": "approval Cabang berhasil",
    "failedTrigger": "approval Cabang gagal",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang"
    ],
    "bodies": {
      "Kantor Pusat": "Pengajuan tiket gratis untuk order G8902260 telah disetujui Cabang Balikpapan dan menunggu persetujuan Kantor Pusat.",
      "Kantor Cabang": "Pengajuan tiket gratis untuk order G8902260 telah disetujui Cabang Balikpapan dan menunggu persetujuan Kantor Pusat."
    },
    "destinations": {
      "Kantor Pusat": "Persetujuan Tiket > Detail G8902260",
      "Kantor Cabang": "Persetujuan Tiket > Detail G8902260"
    },
    "data": {
      "recordId": "G8902260",
      "otherApproval": false
    }
  },
  {
    "requirement": "REQ-013",
    "key": "free-p",
    "title": "Tiket Gratis Disetujui Pusat",
    "category": "Persetujuan Tiket Gratis",
    "trigger": "approval Pusat berhasil",
    "failedTrigger": "approval Pusat gagal",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang"
    ],
    "bodies": {
      "Kantor Pusat": "Pengajuan tiket gratis untuk order G8902260 telah disetujui Kantor Pusat, dan menunggu persetujuan Kantor Cabang.",
      "Kantor Cabang": "Pengajuan tiket gratis untuk order G8902260 telah disetujui Kantor Pusat, dan menunggu persetujuan Kantor Cabang."
    },
    "destinations": {
      "Kantor Pusat": "Persetujuan Tiket > Detail G8902260",
      "Kantor Cabang": "Persetujuan Tiket > Detail G8902260"
    },
    "data": {
      "recordId": "G8902260",
      "otherApproval": false
    }
  },
  {
    "requirement": "REQ-014",
    "key": "top-create",
    "title": "Transaksi Pembayaran TOP",
    "category": "TOP",
    "trigger": "order TOP berhasil dibuat",
    "failedTrigger": "order TOP gagal dibuat",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang"
    ],
    "bodies": {
      "Kantor Pusat": "Order T8810921 milik CV. Borneo Makmur menggunakan pembayaran TOP dengan jatuh tempo 14 hari.",
      "Kantor Cabang": "Order T8810921 milik CV. Borneo Makmur menggunakan pembayaran TOP dengan jatuh tempo 14 hari."
    },
    "destinations": {
      "Kantor Pusat": "Daftar Piutang > Detail Piutang T8810921",
      "Kantor Cabang": "Daftar Piutang > Detail Piutang T8810921"
    },
    "data": {
      "recordId": "T8810921",
      "lamaTOP": 14,
      "pelanggan": "CV. Borneo Makmur"
    }
  },
  {
    "requirement": "REQ-015",
    "key": "top-paid",
    "title": "Piutang TOP Telah Lunas",
    "category": "TOP",
    "trigger": "piutang TOP ditandai lunas",
    "failedTrigger": "penandaan lunas gagal",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang"
    ],
    "bodies": {
      "Kantor Pusat": "Piutang TOP order T8799310 milik PT. Sinar Samudra Logistik telah ditandai lunas.",
      "Kantor Cabang": "Piutang TOP order T8799310 milik PT. Sinar Samudra Logistik telah ditandai lunas."
    },
    "destinations": {
      "Kantor Pusat": "Daftar Piutang > Detail Piutang T8799310",
      "Kantor Cabang": "Daftar Piutang > Detail Piutang T8799310"
    },
    "data": {
      "recordId": "T8799310"
    }
  },
  {
    "requirement": "REQ-016",
    "key": "top-h3",
    "title": "Piutang TOP Jatuh Tempo H-3",
    "category": "TOP",
    "trigger": "job tanggal H-3 untuk piutang belum lunas",
    "failedTrigger": "job pada H-4 sehingga belum H-3",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang"
    ],
    "bodies": {
      "Kantor Pusat": "Piutang TOP CV. Borneo Makmur order T8810921 sebesar Rp7.250.000 jatuh tempo pada 01 Okt 2026.",
      "Kantor Cabang": "Piutang TOP CV. Borneo Makmur order T8810921 sebesar Rp7.250.000 jatuh tempo pada 01 Okt 2026."
    },
    "destinations": {
      "Kantor Pusat": "Daftar Piutang > Detail Piutang T8810921",
      "Kantor Cabang": "Daftar Piutang > Detail Piutang T8810921"
    },
    "data": {
      "recordId": "T8810921",
      "nominal": 7250000,
      "dueDate": "2026-10-01",
      "clock": "2026-09-28T07:00:00+07:00"
    }
  },
  {
    "requirement": "REQ-017",
    "key": "top-h0",
    "title": "Piutang TOP Jatuh Tempo Hari Ini",
    "category": "TOP",
    "trigger": "job pada tanggal jatuh tempo piutang belum lunas",
    "failedTrigger": "job pada H-1 sehingga belum jatuh tempo hari ini",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang"
    ],
    "bodies": {
      "Kantor Pusat": "Piutang TOP PT. Sinar Samudra Logistik order T8812044 sebesar Rp18.450.000 jatuh tempo hari ini.",
      "Kantor Cabang": "Piutang TOP PT. Sinar Samudra Logistik order T8812044 sebesar Rp18.450.000 jatuh tempo hari ini."
    },
    "destinations": {
      "Kantor Pusat": "Daftar Piutang > Detail Piutang T8812044",
      "Kantor Cabang": "Daftar Piutang > Detail Piutang T8812044"
    },
    "data": {
      "recordId": "T8812044",
      "nominal": 18450000,
      "dueDate": "2026-09-30",
      "clock": "2026-09-30T07:00:00+07:00"
    }
  },
  {
    "requirement": "REQ-018",
    "key": "payment",
    "title": "Pembayaran Berhasil",
    "category": "Order & Keberangkatan",
    "trigger": "pembayaran order berhasil",
    "failedTrigger": "pembayaran order gagal/expired",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang",
      "Agen",
      "User Umum"
    ],
    "bodies": {
      "Kantor Pusat": "Pembayaran order V8987400 sebesar Rp505.000 berhasil. E-tiket sudah dapat diproses.",
      "Kantor Cabang": "Pembayaran order V8987400 sebesar Rp505.000 berhasil. E-tiket sudah dapat diproses.",
      "Agen": "Pembayaran order V8987400 sebesar Rp505.000 berhasil. E-tiket sudah dapat diproses.",
      "User Umum": "Pembayaran order V8987400 sebesar Rp505.000 berhasil. E-tiket Anda sudah tersedia."
    },
    "destinations": {
      "Kantor Pusat": "Detail Order V8987400",
      "Kantor Cabang": "Detail Order V8987400",
      "Agen": "Detail Order V8987400",
      "User Umum": "Detail Order V8987400"
    },
    "data": {
      "recordId": "V8987400",
      "nominal": 505000
    }
  },
  {
    "requirement": "REQ-019",
    "key": "departure",
    "title": "Pengingat Keberangkatan",
    "category": "Order & Keberangkatan",
    "trigger": "job H-1 jadwal tiket milik penerima",
    "failedTrigger": "job H-2 sehingga belum H-1",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang",
      "Agen",
      "User Umum"
    ],
    "bodies": {
      "Kantor Pusat": "KM. SWARNA BAHTERA voyage 09.26 (13) Balikpapan (BPN) → Parepare (PAP) berangkat besok, 01 Okt 2026 15:00 WITA.",
      "Kantor Cabang": "KM. SWARNA BAHTERA voyage 09.26 (13) Balikpapan (BPN) → Parepare (PAP) berangkat besok, 01 Okt 2026 15:00 WITA.",
      "Agen": "KM. SWARNA BAHTERA voyage 09.26 (13) Balikpapan (BPN) → Parepare (PAP) berangkat besok, 01 Okt 2026 15:00 WITA.",
      "User Umum": "KM. SWARNA BAHTERA voyage 09.26 (13) Balikpapan (BPN) → Parepare (PAP) berangkat besok, 01 Okt 2026 15:00 WITA."
    },
    "destinations": {
      "Kantor Pusat": "Detail Order V8987400",
      "Kantor Cabang": "Detail Order V8987400",
      "Agen": "Detail Order V8987400",
      "User Umum": "Detail Order V8987400"
    },
    "data": {
      "recordId": "V8987400",
      "departureAt": "2026-10-01T15:00:00+08:00",
      "clock": "2026-09-30T08:00:00+08:00",
      "timezone": "Asia/Makassar"
    }
  },
  {
    "requirement": "REQ-020",
    "key": "device-new",
    "title": "Pengajuan Device Baru",
    "category": "Manajemen Device",
    "trigger": "pengajuan device berhasil",
    "failedTrigger": "pengajuan device gagal",
    "roles": [
      "Kantor Pusat",
      "Agen"
    ],
    "bodies": {
      "Kantor Pusat": "PT. Agen RORO Balikpapan - Bapak Abdul Dulman mengajukan perangkat baru Galaxy A52s 5G · Google Chrome (COM-ADM-003). Menunggu persetujuan.",
      "Agen": "Pengajuan perangkat Galaxy A52s 5G · Google Chrome (COM-ADM-003) berhasil dikirim dan menunggu persetujuan Kantor Pusat."
    },
    "destinations": {
      "Kantor Pusat": "Manajemen Device > Detail/Approval Device COM-ADM-003",
      "Agen": null
    },
    "data": {
      "recordId": "COM-ADM-003",
      "agency": "PT. Agen RORO Balikpapan",
      "user": "Bapak Abdul Dulman",
      "device": "Galaxy A52s 5G",
      "browser": "Google Chrome"
    }
  },
  {
    "requirement": "REQ-021",
    "key": "device-approved",
    "title": "Pengajuan Device Disetujui",
    "category": "Manajemen Device",
    "trigger": "approval device Pusat berhasil",
    "failedTrigger": "approval device gagal",
    "roles": [
      "Kantor Pusat",
      "Agen"
    ],
    "bodies": {
      "Kantor Pusat": "Perangkat Galaxy A52s 5G · Google Chrome (COM-ADM-003) milik PT. Agen RORO Balikpapan - Bapak Abdul Dulman telah disetujui.",
      "Agen": "Perangkat Galaxy A52s 5G · Google Chrome (COM-ADM-003) telah disetujui Kantor Pusat."
    },
    "destinations": {
      "Kantor Pusat": "Manajemen Device > Detail/Approval Device COM-ADM-003",
      "Agen": null
    },
    "data": {
      "recordId": "COM-ADM-003",
      "agency": "PT. Agen RORO Balikpapan",
      "user": "Bapak Abdul Dulman",
      "device": "Galaxy A52s 5G",
      "browser": "Google Chrome"
    }
  },
  {
    "requirement": "REQ-022",
    "key": "device-revoked",
    "title": "Pencabutan Approval Device",
    "category": "Manajemen Device",
    "trigger": "pencabutan approval device berhasil",
    "failedTrigger": "pencabutan approval device gagal",
    "roles": [
      "Kantor Pusat",
      "Agen"
    ],
    "bodies": {
      "Kantor Pusat": "Approval perangkat Galaxy A52s 5G · Google Chrome (COM-ADM-003) milik PT. Agen RORO Balikpapan - Bapak Abdul Dulman telah dicabut.",
      "Agen": "Persetujuan perangkat Galaxy A52s 5G · Google Chrome (COM-ADM-003) telah dicabut oleh Kantor Pusat."
    },
    "destinations": {
      "Kantor Pusat": "Manajemen Device > Detail/Approval Device COM-ADM-003",
      "Agen": null
    },
    "data": {
      "recordId": "COM-ADM-003",
      "agency": "PT. Agen RORO Balikpapan",
      "user": "Bapak Abdul Dulman",
      "device": "Galaxy A52s 5G",
      "browser": "Google Chrome"
    }
  },
  {
    "requirement": "REQ-023",
    "key": "cancel-request",
    "title": "Pengajuan Pembatalan",
    "category": "Pembatalan Tiket",
    "trigger": "pengajuan pembatalan tiket berhasil",
    "failedTrigger": "pengajuan pembatalan gagal",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang",
      "Agen"
    ],
    "bodies": {
      "Kantor Pusat": "Terdapat pengajuan pembatalan tiket C6845054-001 dari PT. Agen RORO Balikpapan. Menunggu persetujuan.",
      "Kantor Cabang": "Terdapat pengajuan pembatalan tiket C6845054-001 dari PT. Agen RORO Balikpapan. Menunggu persetujuan.",
      "Agen": "Pengajuan pembatalan tiket C6845054-001 berhasil dikirim dan menunggu persetujuan."
    },
    "destinations": {
      "Kantor Pusat": "Pembatalan Tiket > Detail/Validasi Pembatalan C6845054-001",
      "Kantor Cabang": "Pembatalan Tiket > Detail/Validasi Pembatalan C6845054-001",
      "Agen": "Pembatalan Tiket > Detail Pembatalan C6845054-001"
    },
    "data": {
      "recordId": "C6845054-001",
      "applicantRole": "Agen",
      "approverRoles": [
        "Kantor Pusat",
        "Kantor Cabang"
      ]
    }
  },
  {
    "requirement": "REQ-024",
    "key": "cancel-approved",
    "title": "Pembatalan Disetujui",
    "category": "Pembatalan Tiket",
    "trigger": "pembatalan disetujui",
    "failedTrigger": "approval pembatalan gagal",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang",
      "Agen"
    ],
    "bodies": {
      "Kantor Pusat": "Pembatalan tiket H8937453-005 telah disetujui. Denda sebesar Rp126.250 dikenakan sesuai ketentuan pembatalan.",
      "Kantor Cabang": "Pembatalan tiket H8937453-005 telah disetujui. Denda sebesar Rp126.250 dikenakan sesuai ketentuan pembatalan.",
      "Agen": "Pembatalan tiket H8937453-005 telah disetujui. Denda sebesar Rp126.250 dikenakan sesuai ketentuan pembatalan."
    },
    "destinations": {
      "Kantor Pusat": "Pembatalan Tiket > Detail Pembatalan H8937453-005",
      "Kantor Cabang": "Pembatalan Tiket > Detail Pembatalan H8937453-005",
      "Agen": "Pembatalan Tiket > Detail Pembatalan H8937453-005"
    },
    "data": {
      "recordId": "H8937453-005",
      "denda": 126250
    }
  },
  {
    "requirement": "REQ-025",
    "key": "cancel-rejected",
    "title": "Pembatalan Ditolak",
    "category": "Pembatalan Tiket",
    "trigger": "pembatalan ditolak",
    "failedTrigger": "penolakan pembatalan gagal",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang",
      "Agen"
    ],
    "bodies": {
      "Kantor Pusat": "Pembatalan tiket G8902260-001 ditolak. Alasan: Dokumen pendukung tidak dilampirkan.",
      "Kantor Cabang": "Pembatalan tiket G8902260-001 ditolak. Alasan: Dokumen pendukung tidak dilampirkan.",
      "Agen": "Pembatalan tiket G8902260-001 ditolak. Alasan: Dokumen pendukung tidak dilampirkan."
    },
    "destinations": {
      "Kantor Pusat": "Pembatalan Tiket > Detail Pembatalan G8902260-001",
      "Kantor Cabang": "Pembatalan Tiket > Detail Pembatalan G8902260-001",
      "Agen": "Pembatalan Tiket > Detail Pembatalan G8902260-001"
    },
    "data": {
      "recordId": "G8902260-001",
      "alasan": "Dokumen pendukung tidak dilampirkan"
    }
  },
  {
    "requirement": "REQ-026",
    "key": "quota-request",
    "title": "Pengajuan Kuota",
    "category": "Kuota & Jadwal",
    "trigger": "Cabang berhasil mengajukan kuota",
    "failedTrigger": "pengajuan kuota gagal",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang"
    ],
    "bodies": {
      "Kantor Pusat": "Cabang Balikpapan mengajukan kuota KM. SWARNA BAHTERA voyage V-216 (Balikpapan → Parepare). Menunggu persetujuan.",
      "Kantor Cabang": "Pengajuan kuota KM. SWARNA BAHTERA voyage V-216 (Balikpapan → Parepare) berhasil dikirim dan menunggu persetujuan Kantor Pusat."
    },
    "destinations": {
      "Kantor Pusat": "Kuota & Jadwal > Detail Pengajuan Q-216",
      "Kantor Cabang": "Kuota & Jadwal > Detail Kuota Q-216"
    },
    "data": {
      "recordId": "Q-216",
      "voyage": "V-216",
      "ship": "KM. SWARNA BAHTERA",
      "route": "Balikpapan → Parepare",
      "alasan": null
    }
  },
  {
    "requirement": "REQ-027",
    "key": "quota-approved",
    "title": "Kuota Disetujui",
    "category": "Kuota & Jadwal",
    "trigger": "pengajuan kuota disetujui Pusat",
    "failedTrigger": "approval kuota gagal",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang"
    ],
    "bodies": {
      "Kantor Pusat": "Pengajuan kuota KM. SWARNA BAHTERA voyage V-216 (Balikpapan → Parepare) telah disetujui Kantor Pusat. Setting jadwal keberangkatan sudah dapat dilanjutkan.",
      "Kantor Cabang": "Pengajuan kuota KM. SWARNA BAHTERA voyage V-216 (Balikpapan → Parepare) telah disetujui Kantor Pusat. Setting jadwal keberangkatan sudah dapat dilanjutkan."
    },
    "destinations": {
      "Kantor Pusat": "Kuota & Jadwal > Detail Pengajuan Q-216",
      "Kantor Cabang": "Kuota & Jadwal > Detail Kuota Q-216"
    },
    "data": {
      "recordId": "Q-216",
      "voyage": "V-216",
      "ship": "KM. SWARNA BAHTERA",
      "route": "Balikpapan → Parepare",
      "alasan": null
    }
  },
  {
    "requirement": "REQ-028",
    "key": "quota-rejected",
    "title": "Kuota Ditolak",
    "category": "Kuota & Jadwal",
    "trigger": "pengajuan kuota ditolak Pusat",
    "failedTrigger": "penolakan kuota gagal",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang"
    ],
    "bodies": {
      "Kantor Pusat": "Pengajuan kuota KM. SWARNA BAHTERA voyage V-216 (Balikpapan → Parepare) ditolak. Alasan: Kuota Gol. IV-B melebihi kapasitas dek kendaraan.",
      "Kantor Cabang": "Pengajuan kuota KM. SWARNA BAHTERA voyage V-216 (Balikpapan → Parepare) ditolak. Alasan: Kuota Gol. IV-B melebihi kapasitas dek kendaraan."
    },
    "destinations": {
      "Kantor Pusat": "Kuota & Jadwal > Detail Pengajuan Q-216",
      "Kantor Cabang": "Kuota & Jadwal > Detail Kuota Q-216"
    },
    "data": {
      "recordId": "Q-216",
      "voyage": "V-216",
      "ship": "KM. SWARNA BAHTERA",
      "route": "Balikpapan → Parepare",
      "alasan": "Kuota Gol. IV-B melebihi kapasitas dek kendaraan"
    }
  },
  {
    "requirement": "REQ-029",
    "key": "member-request",
    "title": "Pengajuan Member",
    "category": "JN Member",
    "trigger": "pendaftaran JN Member berhasil",
    "failedTrigger": "pendaftaran JN Member gagal",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang"
    ],
    "bodies": {
      "Kantor Pusat": "Rizwandy Rajab mengajukan pendaftaran JN Member. Menunggu proses validasi.",
      "Kantor Cabang": "Rizwandy Rajab mengajukan pendaftaran JN Member. Menunggu proses validasi."
    },
    "destinations": {
      "Kantor Pusat": "Validasi Member > Detail Member REG-0012872",
      "Kantor Cabang": "Validasi Member > Detail Member REG-0012872"
    },
    "data": {
      "recordId": "REG-0012872",
      "user": "Rizwandy Rajab"
    }
  },
  {
    "requirement": "REQ-030",
    "key": "member-approved",
    "title": "Member Disetujui",
    "category": "JN Member",
    "trigger": "pendaftaran member disetujui",
    "failedTrigger": "approval pendaftaran gagal",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang"
    ],
    "bodies": {
      "Kantor Pusat": "Pendaftaran JN Member Muh Aprisal disetujui. Nomor member JN-0012871.",
      "Kantor Cabang": "Pendaftaran JN Member Muh Aprisal disetujui. Nomor member JN-0012871."
    },
    "destinations": {
      "Kantor Pusat": "Validasi Member > Detail Member REG-0012871",
      "Kantor Cabang": "Validasi Member > Detail Member REG-0012871"
    },
    "data": {
      "recordId": "REG-0012871",
      "user": "Muh Aprisal",
      "memberId": "JN-0012871"
    }
  },
  {
    "requirement": "REQ-031",
    "key": "member-rejected",
    "title": "Member Ditolak",
    "category": "JN Member",
    "trigger": "pendaftaran member ditolak",
    "failedTrigger": "penolakan pendaftaran gagal",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang"
    ],
    "bodies": {
      "Kantor Pusat": "Pendaftaran JN Member Yudi Kustanto ditolak. Alasan: Foto KTP tidak terbaca.",
      "Kantor Cabang": "Pendaftaran JN Member Yudi Kustanto ditolak. Alasan: Foto KTP tidak terbaca."
    },
    "destinations": {
      "Kantor Pusat": "Validasi Member > Detail Member REG-0012874",
      "Kantor Cabang": "Validasi Member > Detail Member REG-0012874"
    },
    "data": {
      "recordId": "REG-0012874",
      "user": "Yudi Kustanto",
      "alasan": "Foto KTP tidak terbaca"
    }
  },
  {
    "requirement": "REQ-032",
    "key": "member-reverify",
    "title": "Verifikasi Ulang Member",
    "category": "JN Member",
    "trigger": "pengajuan ulang setelah ditolak berstatus Waiting Verifikasi",
    "failedTrigger": "pengajuan ulang gagal sehingga tetap Ditolak",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang"
    ],
    "bodies": {
      "Kantor Pusat": "Pengajuan ulang JN Member Damayanti Sukma telah masuk dan berstatus Menunggu Verifikasi.",
      "Kantor Cabang": "Pengajuan ulang JN Member Damayanti Sukma telah masuk dan berstatus Menunggu Verifikasi."
    },
    "destinations": {
      "Kantor Pusat": "Validasi Member > Detail Member REG-0012873",
      "Kantor Cabang": "Validasi Member > Detail Member REG-0012873"
    },
    "data": {
      "recordId": "REG-0012873",
      "user": "Damayanti Sukma",
      "previousStatus": "Ditolak",
      "status": "Waiting Verifikasi"
    }
  },
  {
    "requirement": "REQ-033",
    "key": "reward-request",
    "title": "Pengajuan Reward Masuk",
    "category": "Reward Member",
    "trigger": "Member mengajukan penukaran reward berhasil",
    "failedTrigger": "pengajuan reward gagal",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang"
    ],
    "bodies": {
      "Kantor Pusat": "Nabila Putri mengajukan penukaran reward Voucher Tiket Rp50.000 (1.200 poin). Menunggu persetujuan.",
      "Kantor Cabang": "Nabila Putri mengajukan penukaran reward Voucher Tiket Rp50.000 (1.200 poin). Menunggu persetujuan."
    },
    "destinations": {
      "Kantor Pusat": "Persetujuan Reward > Detail/Validasi RW-001201",
      "Kantor Cabang": "Persetujuan Reward > Detail/Validasi RW-001201"
    },
    "data": {
      "recordId": "RW-001201",
      "member": "Nabila Putri",
      "reward": "Voucher Tiket Rp50.000",
      "points": 1200
    }
  },
  {
    "requirement": "REQ-034",
    "key": "reward-approved",
    "title": "Pengajuan Reward Diterima",
    "category": "Reward Member",
    "trigger": "pengajuan reward disetujui",
    "failedTrigger": "approval reward gagal",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang",
      "Member"
    ],
    "bodies": {
      "Kantor Pusat": "Pengajuan reward Voucher Tiket Rp50.000 atas nama Nabila Putri telah disetujui.",
      "Kantor Cabang": "Pengajuan reward Voucher Tiket Rp50.000 atas nama Nabila Putri telah disetujui.",
      "Member": "Pengajuan reward Voucher Tiket Rp50.000 Anda telah disetujui. Lihat detail reward untuk informasi selanjutnya."
    },
    "destinations": {
      "Kantor Pusat": "Persetujuan Reward > Detail RW-001200",
      "Kantor Cabang": "Persetujuan Reward > Detail RW-001200",
      "Member": "Reward Milik Saya > Detail Reward RW-001200"
    },
    "data": {
      "recordId": "RW-001200",
      "member": "Nabila Putri",
      "reward": "Voucher Tiket Rp50.000",
      "points": 1200,
      "alasan": null
    }
  },
  {
    "requirement": "REQ-035",
    "key": "reward-rejected",
    "title": "Pengajuan Reward Ditolak",
    "category": "Reward Member",
    "trigger": "pengajuan reward ditolak",
    "failedTrigger": "penolakan reward gagal",
    "roles": [
      "Kantor Pusat",
      "Kantor Cabang",
      "Member"
    ],
    "bodies": {
      "Kantor Pusat": "Pengajuan reward Voucher Tiket Rp50.000 atas nama Nabila Putri ditolak. Alasan: Stok reward habis.",
      "Kantor Cabang": "Pengajuan reward Voucher Tiket Rp50.000 atas nama Nabila Putri ditolak. Alasan: Stok reward habis.",
      "Member": "Pengajuan reward Voucher Tiket Rp50.000 ditolak. Alasan: Stok reward habis. Poin telah dikembalikan."
    },
    "destinations": {
      "Kantor Pusat": "Persetujuan Reward > Detail RW-001200",
      "Kantor Cabang": "Persetujuan Reward > Detail RW-001200",
      "Member": "Reward Milik Saya > Detail Reward RW-001200"
    },
    "data": {
      "recordId": "RW-001200",
      "member": "Nabila Putri",
      "reward": "Voucher Tiket Rp50.000",
      "points": 1200,
      "alasan": "Stok reward habis"
    }
  }
]
```

## UI Inventory

Tidak ada PNG; daftar diambil dari markup extras 6-push dan spec. State loading/error belum terlihat; diusulkan untuk pengujian fault tanpa mengunci teks. Semua testid merupakan usulan. Role checkbox toggle adalah kontrak codegen yang perlu disesuaikan bila UI aktual memakai switch.

### notifikasi

| Elemen | role | name / label | testid (usulan) | Catatan |
|---|---|---|---|---|
| Notifikasi | button | Notifikasi | notification-bell | title teramati; bell dot merah sesuai unread akun |
| Daftar notifikasi | region | Daftar notifikasi | notification-list | region/name usulan; setiap baris di-scope notificationId + accountId |
| Penanda belum dibaca | status | Belum dibaca | notification-unread | dot merah dan background baris dari HTML; role/name usulan |
| Baca notifikasi | button | Baca notifikasi | notification-read | title teramati; konten judul/body menjadi accessible name aktual, gunakan testid scoped |
| Detail | button | Detail | notification-detail | label teramati; disabled untuk seluruh device Agen |
| Status baca | combobox | Status baca | notification-read-filter | name usulan; Semua / Belum Dibaca / Sudah Dibaca |
| Kategori | combobox | Kategori | notification-category-filter | name usulan; Semua Kategori dan kategori role terkait |
| Pilih Semua | checkbox | Pilih Semua | notification-select-all | label teramati; semua hasil filter, bukan akun lain |
| Pilih notifikasi | checkbox | Pilih notifikasi | notification-select | name usulan; scope notificationId wajib |
| Jumlah dipilih | status | Jumlah dipilih | notification-selection-count | teks n dipilih; role/name usulan |
| Hapus Notifikasi | button | Hapus Notifikasi | notification-delete | disabled tanpa seleksi; standalone memakai Hapus Notif |
| Tandai Sudah Dibaca | button | Tandai Sudah Dibaca | notification-mark-read | disabled tanpa seleksi; standalone memakai Tandai Dibaca |
| Menampilkan Data | combobox | Menampilkan Data | notification-page-size | name usulan; 10 / 20 / 50 |
| Pagination | navigation | Pagination | notification-pagination | komponen import; tombol Selanjutnya/Sebelumnya dan range nama usulan |
| Daftar kosong | status | Tidak ada notifikasi yang tersedia. | notification-empty | teks teramati; tidak sama dengan empty Preferensi |
| Informasi aksi | status | Informasi aksi | notification-toast | toast jumlah hapus/mark read teramati; role/name usulan |

### setting-notifikasi

| Elemen | role | name / label | testid (usulan) | Catatan |
|---|---|---|---|---|
| Setting Notifikasi | link | Setting Notifikasi | setting-notification-menu | diturunkan spec; hanya Admin Utama |
| Section notifikasi | button | Notifikasi Email / Notifikasi WhatsApp / Push Notifikasi JN Member / Push Notifikasi Sistem Web | setting-section | expand/collapse; aria-expanded usulan |
| Counter section | status | Jumlah notifikasi aktif | setting-section-count | n dari total notifikasi aktif; name/role usulan |
| Kelompok penerima Email | group | User Online / Operator / Pembeli Via Gerai / Pembeli Via Agen | setting-email-group | jenis dari katalog existing |
| Kelompok penerima WhatsApp | group | User Online / Pembeli Via Gerai / Pembeli Via Agen | setting-whatsapp-group | hanya dukungan WA; default awal OFF |
| Toggle Email | checkbox | Email <jenis> <penerima> | setting-email-toggle | checkbox usulan untuk check/uncheck; jika implementasi switch perlu adapter |
| Toggle WhatsApp | checkbox | WhatsApp <jenis> <penerima> | setting-whatsapp-toggle | per jenis/penerima, tidak mempengaruhi Email/Push |
| Toggle Push JN Member | checkbox | Push Notifikasi JN Member | setting-push-jn | scope channel aplikasi; tidak sama dengan Push Web kategori JN Member |
| Kategori Push Web | group | <kategori> | setting-web-category | 9 kategori spec; metadata nama, trigger, penerima dan counter |
| Semua jenis kategori | checkbox | Semua <kategori> | setting-web-all | scope kategori wajib |
| Toggle jenis Web | checkbox | <jenis notifikasi> | setting-web-toggle | scope kategori + typeId, bukan judul kiriman setiap role |
| Batal | button | Batal | setting-cancel | memulihkan nilai tersimpan; disabled opsional jika bersih |
| Simpan | button | Simpan | setting-save | draft baru efektif setelah sukses |
| Informasi hasil simpan | status | Pengaturan notifikasi berhasil disimpan | setting-result | makna dari spec; diksi final belum ada desain |
| Perubahan belum disimpan | status | Perubahan belum disimpan | setting-dirty-count | opsional; bila tampil counter harus benar |

### preferensi-notifikasi

| Elemen | role | name / label | testid (usulan) | Catatan |
|---|---|---|---|---|
| Preferensi Notifikasi | link | Preferensi Notifikasi | preference-menu | admin di menu Setting; ejaan lama Preference Notif extras tidak dipakai |
| Kategori preferensi | group | <kategori> | preference-category | sesuai role/akses/global |
| Counter preferensi | status | Jumlah pilihan aktif | preference-count | dipilih/tersedia per pasangan jenis-channel |
| Semua channel kategori | checkbox | Semua <kategori> | preference-all | hanya pilihan tersedia pada akun |
| Email | checkbox | Email <jenis> | preference-email | channel independen; typeId + accountId scope |
| WhatsApp | checkbox | WhatsApp <jenis> | preference-whatsapp | channel independen; typeId + accountId scope |
| Push | checkbox | Push <jenis> | preference-push | channel independen; typeId + accountId scope |
| Batal | button | Batal | preference-cancel | kembali ke preferensi terakhir |
| Simpan | button | Simpan | preference-save | simpan personal dan tanggal terakhir |
| Preferensi kosong | status | Belum ada notifikasi yang tersedia. | preference-empty | teks spec persis |
| Informasi akun | group | Informasi akun | preference-account | opsional menurut akun; Nama Lengkap, Tanggal Register, Tanggal Setting Terakhir |
| Tanggal Setting Terakhir | status | Tanggal Setting Terakhir | preference-last-setting | berubah hanya saat sukses; role/name usulan |

### Halaman tujuan

Riwayat Saldo, Persetujuan Tiket > Detail, Daftar Piutang > Detail Piutang, Detail Order/tiket, Manajemen Device > Detail/Approval Device, Pembatalan Tiket > Detail/Validasi atau Detail Pembatalan, Kuota & Jadwal > Detail Pengajuan atau Detail Kuota, Validasi Member > Detail Member, Persetujuan Reward > Detail/Validasi atau Detail, Reward Milik Saya > Detail Reward. Hanya keberadaan halaman dan identitas record diuji; field/tombol halaman tujuan tidak diinventarisasi karena desainnya tidak diberikan.

### Kontrak UI untuk penelusuran mekanis

```json
{
  "notifikasi": [
    [
      "Notifikasi",
      "button",
      "Notifikasi",
      "notification-bell",
      "list-entry",
      "title teramati; bell dot merah sesuai unread akun"
    ],
    [
      "Daftar notifikasi",
      "region",
      "Daftar notifikasi",
      "notification-list",
      "envelope",
      "region/name usulan; setiap baris di-scope notificationId + accountId"
    ],
    [
      "Penanda belum dibaca",
      "status",
      "Belum dibaca",
      "notification-unread",
      "read",
      "dot merah dan background baris dari HTML; role/name usulan"
    ],
    [
      "Baca notifikasi",
      "button",
      "Baca notifikasi",
      "notification-read",
      "read",
      "title teramati; konten judul/body menjadi accessible name aktual, gunakan testid scoped"
    ],
    [
      "Detail",
      "button",
      "Detail",
      "notification-detail",
      "access",
      "label teramati; disabled untuk seluruh device Agen"
    ],
    [
      "Status baca",
      "combobox",
      "Status baca",
      "notification-read-filter",
      "list-filter",
      "name usulan; Semua / Belum Dibaca / Sudah Dibaca"
    ],
    [
      "Kategori",
      "combobox",
      "Kategori",
      "notification-category-filter",
      "list-filter",
      "name usulan; Semua Kategori dan kategori role terkait"
    ],
    [
      "Pilih Semua",
      "checkbox",
      "Pilih Semua",
      "notification-select-all",
      "list-select",
      "label teramati; semua hasil filter, bukan akun lain"
    ],
    [
      "Pilih notifikasi",
      "checkbox",
      "Pilih notifikasi",
      "notification-select",
      "list-select",
      "name usulan; scope notificationId wajib"
    ],
    [
      "Jumlah dipilih",
      "status",
      "Jumlah dipilih",
      "notification-selection-count",
      "list-select",
      "teks n dipilih; role/name usulan"
    ],
    [
      "Hapus Notifikasi",
      "button",
      "Hapus Notifikasi",
      "notification-delete",
      "list-delete",
      "disabled tanpa seleksi; standalone memakai Hapus Notif"
    ],
    [
      "Tandai Sudah Dibaca",
      "button",
      "Tandai Sudah Dibaca",
      "notification-mark-read",
      "list-bulk-read",
      "disabled tanpa seleksi; standalone memakai Tandai Dibaca"
    ],
    [
      "Menampilkan Data",
      "combobox",
      "Menampilkan Data",
      "notification-page-size",
      "list-pagination",
      "name usulan; 10 / 20 / 50"
    ],
    [
      "Pagination",
      "navigation",
      "Pagination",
      "notification-pagination",
      "list-pagination",
      "komponen import; tombol Selanjutnya/Sebelumnya dan range nama usulan"
    ],
    [
      "Daftar kosong",
      "status",
      "Tidak ada notifikasi yang tersedia.",
      "notification-empty",
      "list-empty",
      "teks teramati; tidak sama dengan empty Preferensi"
    ],
    [
      "Informasi aksi",
      "status",
      "Informasi aksi",
      "notification-toast",
      "list-delete",
      "toast jumlah hapus/mark read teramati; role/name usulan"
    ]
  ],
  "setting-notifikasi": [
    [
      "Setting Notifikasi",
      "link",
      "Setting Notifikasi",
      "setting-notification-menu",
      "setting-access",
      "diturunkan spec; hanya Admin Utama"
    ],
    [
      "Section notifikasi",
      "button",
      "Notifikasi Email / Notifikasi WhatsApp / Push Notifikasi JN Member / Push Notifikasi Sistem Web",
      "setting-section",
      "setting-sections",
      "expand/collapse; aria-expanded usulan"
    ],
    [
      "Counter section",
      "status",
      "Jumlah notifikasi aktif",
      "setting-section-count",
      "setting-sections",
      "n dari total notifikasi aktif; name/role usulan"
    ],
    [
      "Kelompok penerima Email",
      "group",
      "User Online / Operator / Pembeli Via Gerai / Pembeli Via Agen",
      "setting-email-group",
      "email",
      "jenis dari katalog existing"
    ],
    [
      "Kelompok penerima WhatsApp",
      "group",
      "User Online / Pembeli Via Gerai / Pembeli Via Agen",
      "setting-whatsapp-group",
      "whatsapp",
      "hanya dukungan WA; default awal OFF"
    ],
    [
      "Toggle Email",
      "checkbox",
      "Email <jenis> <penerima>",
      "setting-email-toggle",
      "email",
      "checkbox usulan untuk check/uncheck; jika implementasi switch perlu adapter"
    ],
    [
      "Toggle WhatsApp",
      "checkbox",
      "WhatsApp <jenis> <penerima>",
      "setting-whatsapp-toggle",
      "whatsapp",
      "per jenis/penerima, tidak mempengaruhi Email/Push"
    ],
    [
      "Toggle Push JN Member",
      "checkbox",
      "Push Notifikasi JN Member",
      "setting-push-jn",
      "push-jn",
      "scope channel aplikasi; tidak sama dengan Push Web kategori JN Member"
    ],
    [
      "Kategori Push Web",
      "group",
      "<kategori>",
      "setting-web-category",
      "web-catalog",
      "9 kategori spec; metadata nama, trigger, penerima dan counter"
    ],
    [
      "Semua jenis kategori",
      "checkbox",
      "Semua <kategori>",
      "setting-web-all",
      "web-all",
      "scope kategori wajib"
    ],
    [
      "Toggle jenis Web",
      "checkbox",
      "<jenis notifikasi>",
      "setting-web-toggle",
      "web-all",
      "scope kategori + typeId, bukan judul kiriman setiap role"
    ],
    [
      "Batal",
      "button",
      "Batal",
      "setting-cancel",
      "setting-cancel",
      "memulihkan nilai tersimpan; disabled opsional jika bersih"
    ],
    [
      "Simpan",
      "button",
      "Simpan",
      "setting-save",
      "setting-save",
      "draft baru efektif setelah sukses"
    ],
    [
      "Informasi hasil simpan",
      "status",
      "Pengaturan notifikasi berhasil disimpan",
      "setting-result",
      "setting-save",
      "makna dari spec; diksi final belum ada desain"
    ],
    [
      "Perubahan belum disimpan",
      "status",
      "Perubahan belum disimpan",
      "setting-dirty-count",
      "setting-cancel",
      "opsional; bila tampil counter harus benar"
    ]
  ],
  "preferensi-notifikasi": [
    [
      "Preferensi Notifikasi",
      "link",
      "Preferensi Notifikasi",
      "preference-menu",
      "preference-menu",
      "admin di menu Setting; ejaan lama Preference Notif extras tidak dipakai"
    ],
    [
      "Kategori preferensi",
      "group",
      "<kategori>",
      "preference-category",
      "preference-all",
      "sesuai role/akses/global"
    ],
    [
      "Counter preferensi",
      "status",
      "Jumlah pilihan aktif",
      "preference-count",
      "preference-all",
      "dipilih/tersedia per pasangan jenis-channel"
    ],
    [
      "Semua channel kategori",
      "checkbox",
      "Semua <kategori>",
      "preference-all",
      "preference-all",
      "hanya pilihan tersedia pada akun"
    ],
    [
      "Email",
      "checkbox",
      "Email <jenis>",
      "preference-email",
      "channels",
      "channel independen; typeId + accountId scope"
    ],
    [
      "WhatsApp",
      "checkbox",
      "WhatsApp <jenis>",
      "preference-whatsapp",
      "channels",
      "channel independen; typeId + accountId scope"
    ],
    [
      "Push",
      "checkbox",
      "Push <jenis>",
      "preference-push",
      "channels",
      "channel independen; typeId + accountId scope"
    ],
    [
      "Batal",
      "button",
      "Batal",
      "preference-cancel",
      "preference-cancel",
      "kembali ke preferensi terakhir"
    ],
    [
      "Simpan",
      "button",
      "Simpan",
      "preference-save",
      "preference-save",
      "simpan personal dan tanggal terakhir"
    ],
    [
      "Preferensi kosong",
      "status",
      "Belum ada notifikasi yang tersedia.",
      "preference-empty",
      "preference-empty",
      "teks spec persis"
    ],
    [
      "Informasi akun",
      "group",
      "Informasi akun",
      "preference-account",
      "preference-save",
      "opsional menurut akun; Nama Lengkap, Tanggal Register, Tanggal Setting Terakhir"
    ],
    [
      "Tanggal Setting Terakhir",
      "status",
      "Tanggal Setting Terakhir",
      "preference-last-setting",
      "preference-save",
      "berubah hanya saat sukses; role/name usulan"
    ]
  ]
}
```

## Assumptions Log

- **A01** — Tidak ada PNG. UI Setting/Preferensi diturunkan minimal dari spec; UI daftar notifikasi memakai teks/markup extras HTML, bukan hasil inspeksi visual.
- **A02** — Spec mengungguli kedua HTML saat konflik. 6-push-notification-dc.html dipilih untuk Detail, Baca notifikasi, Hapus Notifikasi, Tandai Sudah Dibaca, judul/body terbaru, rute record, dan disabled Detail device Agen; standalone hanya konteks regresi.
- **A03** — Retensi otomatis 3 bulan hanya muncul di standalone dan tidak ditetapkan spec; tidak dijadikan acceptance criterion. Kontrol PROTOTIPE/Role, toast simulasi tujuan, sidebar/footer umum bukan fitur produksi yang diwajibkan.
- **A04** — Preferensi Cabang Top Up Saldo Berhasil dianggap alias jenis event top-up; judul kiriman Cabang tetap Top Up Saldo Agen Berhasil. Kategori UI Saldo/Persetujuan Tiket/Order/Operasional dipetakan ke Top Up Saldo/Persetujuan Tiket Gratis/Order & Keberangkatan untuk setting.
- **A05** — Daftar Email/WhatsApp serta trigger Push JN Member existing tidak diberikan lengkap. Fixture katalog existing yang disetujui menjadi oracle; tidak membuat jenis/trigger baru. WhatsApp OFF untuk konfigurasi awal tanpa setting tersimpan; setting tersimpan tetap diutamakan.
- **A06** — Routing dan pengiriman menggunakan relasi transaksi, hak akses, kepemilikan akun/cabang/agen; penerima bukan seluruh akun ber-role sama. Cabang pengaju pembatalan mendapat pesan pengaju, Cabang approver mendapat pesan approver. Reward untuk akun User Umum berlaku hanya jika akun tersebut Member terkait.
- **A07** — H-3/H-1 memakai tanggal kalender zona bisnis fixture (Asia/Makassar untuk voyage WITA, Asia/Jakarta untuk TOP contoh). Jam scheduler, SLA, retry/dedup tidak ditentukan; clock/job completion dikendalikan fixture. Piutang lunas tidak diingatkan; voyage yang dijadwal ulang memakai jadwal aktual.
- **A08** — Default preferensi akun baru aktif hanya untuk pilihan yang global ON dan tersedia. Default Push saat deployment memakai konfigurasi fixture. Pengaktifan ulang memakai preferensi terakhir; tidak membuat pengiriman retroaktif.
- **A09** — Toggle campuran diuji lewat counter dan nilai anak; tampilan indeterminate tidak diwajibkan. Counter Preferensi menghitung pasangan jenis-channel. Semua daftar notifikasi mengacu hasil filter saat ini; seleksi dibersihkan saat filter berubah. Pagination produksi mengikuti page size 10/20/50, walau HTML hanya simulasi satu halaman.
- **A10** — URL, pesan error, ARIA/name beberapa kontrol, dan data-testid belum tersedia. SelectorHints adalah usulan; locator baris harus di-scope memakai ID notifikasi/record + akun. Pesan sukses Setting diuji maknanya; hanya empty Preferensi dan template notifikasi memakai teks persis dari spec.
- **A11** — Fixture transaksi berhasil/gagal, katalog existing, clock, fault jaringan, migrasi, dan beban perlu adapter implementasi. Stress memakai 10000 event/100 sesi sebagai data uji usulan tanpa ambang latency; oracle kelengkapan, isolasi, dan konsistensi. Tidak menguji layanan eksternal nyata.
- **A12** — Simpan gagal tidak menghasilkan sukses/perubahan permanen; sesi kedaluwarsa ditolak; data record tidak boleh bocor. Deduplikasi event retry dan konsistensi konkurensi diuji sebagai rekomendasi robustness, bukan rule eksplisit. Tidak mengarang min/max nominal/panjang teks atau formula denda.
