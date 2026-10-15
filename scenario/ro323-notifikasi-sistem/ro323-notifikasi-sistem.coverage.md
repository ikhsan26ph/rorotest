# Coverage — ro323-notifikasi-sistem

## Ringkasan

| Kategori | Jumlah |
|---|---:|
| positive | 113 |
| negative | 173 |
| edge | 22 |
| stress | 12 |
| **Total** | **320** |

67/67 requirement memiliki minimal satu positive dan satu negative; 43/43 elemen inti tersentuh; seluruh 3 layar inti ter-cover. Tujuan Detail diverifikasi lewat destination dan recordId pada setiap template-role yang memiliki navigasi.

## Requirements Traceability Matrix

| REQ | Deskripsi | Scenario IDs |
|---|---|---|
| REQ-001 | Notifikasi memuat judul, isi, tanggal, waktu, dan Detail dengan data aktual tanpa placeholder. | RO323-NOTIFIKASI-SISTEM-POS-068, RO323-NOTIFIKASI-SISTEM-NEG-119 |
| REQ-002 | Distribusi sesuai role, relasi transaksi dan kepemilikan; isi dapat berbeda antar role. | RO323-NOTIFIKASI-SISTEM-POS-069, RO323-NOTIFIKASI-SISTEM-NEG-120, RO323-NOTIFIKASI-SISTEM-NEG-172, RO323-NOTIFIKASI-SISTEM-NEG-173, RO323-NOTIFIKASI-SISTEM-STR-001 |
| REQ-003 | Notifikasi unread ditandai; membuka isi atau Detail mengubah hanya notifikasi akun terkait menjadi read. | RO323-NOTIFIKASI-SISTEM-POS-070, RO323-NOTIFIKASI-SISTEM-NEG-121, RO323-NOTIFIKASI-SISTEM-EDG-001 |
| REQ-004 | Detail menuju record terkait dan tetap tunduk pada hak akses; URL langsung tidak melewati otorisasi. | RO323-NOTIFIKASI-SISTEM-POS-071, RO323-NOTIFIKASI-SISTEM-NEG-122 |
| REQ-005 | Pengajuan tiket gratis diproses per ID Order; status dan notifikasi order lain tidak tercampur. | RO323-NOTIFIKASI-SISTEM-POS-072, RO323-NOTIFIKASI-SISTEM-NEG-123 |
| REQ-006 | History pencabutan approval tetap tersedia untuk Agen; Detail seluruh notifikasi device Agen disabled. | RO323-NOTIFIKASI-SISTEM-POS-073, RO323-NOTIFIKASI-SISTEM-NEG-124, RO323-NOTIFIKASI-SISTEM-EDG-022 |
| REQ-007 | Nominal, saldo, identitas, voyage, tanggal, alasan, denda dan poin diambil dari proses aktual, bukan fixture prototipe. | RO323-NOTIFIKASI-SISTEM-POS-074, RO323-NOTIFIKASI-SISTEM-NEG-125, RO323-NOTIFIKASI-SISTEM-EDG-002, RO323-NOTIFIKASI-SISTEM-EDG-003, RO323-NOTIFIKASI-SISTEM-STR-011 |
| REQ-008 | Top Up Saldo Berhasil: hanya trigger top-up operator/cabang berhasil; penerima Kantor Pusat; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-001, RO323-NOTIFIKASI-SISTEM-NEG-001, RO323-NOTIFIKASI-SISTEM-NEG-002, RO323-NOTIFIKASI-SISTEM-NEG-003 |
| REQ-009 | Top Up Saldo Agen Berhasil: hanya trigger Cabang berhasil top-up Agen; penerima Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-002, RO323-NOTIFIKASI-SISTEM-NEG-004, RO323-NOTIFIKASI-SISTEM-NEG-005, RO323-NOTIFIKASI-SISTEM-NEG-006 |
| REQ-010 | Saldo Berhasil Ditambahkan: hanya trigger saldo Agen berhasil ditambah Cabang; penerima Agen; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-003, RO323-NOTIFIKASI-SISTEM-NEG-007, RO323-NOTIFIKASI-SISTEM-NEG-008, RO323-NOTIFIKASI-SISTEM-NEG-009 |
| REQ-011 | Pengajuan Tiket Gratis: hanya trigger pengajuan tiket gratis berhasil dibuat; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-004, RO323-NOTIFIKASI-SISTEM-NEG-010, RO323-NOTIFIKASI-SISTEM-POS-005, RO323-NOTIFIKASI-SISTEM-NEG-011, RO323-NOTIFIKASI-SISTEM-NEG-012, RO323-NOTIFIKASI-SISTEM-NEG-013 |
| REQ-012 | Tiket Gratis Disetujui Cabang: hanya trigger approval Cabang berhasil; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-006, RO323-NOTIFIKASI-SISTEM-NEG-014, RO323-NOTIFIKASI-SISTEM-POS-007, RO323-NOTIFIKASI-SISTEM-NEG-015, RO323-NOTIFIKASI-SISTEM-NEG-016, RO323-NOTIFIKASI-SISTEM-NEG-017, RO323-NOTIFIKASI-SISTEM-POS-063, RO323-NOTIFIKASI-SISTEM-POS-064, RO323-NOTIFIKASI-SISTEM-EDG-010 |
| REQ-013 | Tiket Gratis Disetujui Pusat: hanya trigger approval Pusat berhasil; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-008, RO323-NOTIFIKASI-SISTEM-NEG-018, RO323-NOTIFIKASI-SISTEM-POS-009, RO323-NOTIFIKASI-SISTEM-NEG-019, RO323-NOTIFIKASI-SISTEM-NEG-020, RO323-NOTIFIKASI-SISTEM-NEG-021, RO323-NOTIFIKASI-SISTEM-POS-065, RO323-NOTIFIKASI-SISTEM-POS-066 |
| REQ-014 | Transaksi Pembayaran TOP: hanya trigger order TOP berhasil dibuat; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-010, RO323-NOTIFIKASI-SISTEM-NEG-022, RO323-NOTIFIKASI-SISTEM-POS-011, RO323-NOTIFIKASI-SISTEM-NEG-023, RO323-NOTIFIKASI-SISTEM-NEG-024, RO323-NOTIFIKASI-SISTEM-NEG-025 |
| REQ-015 | Piutang TOP Telah Lunas: hanya trigger piutang TOP ditandai lunas; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-012, RO323-NOTIFIKASI-SISTEM-NEG-026, RO323-NOTIFIKASI-SISTEM-POS-013, RO323-NOTIFIKASI-SISTEM-NEG-027, RO323-NOTIFIKASI-SISTEM-NEG-028, RO323-NOTIFIKASI-SISTEM-NEG-029 |
| REQ-016 | Piutang TOP Jatuh Tempo H-3: hanya trigger job tanggal H-3 untuk piutang belum lunas; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-014, RO323-NOTIFIKASI-SISTEM-NEG-030, RO323-NOTIFIKASI-SISTEM-POS-015, RO323-NOTIFIKASI-SISTEM-NEG-031, RO323-NOTIFIKASI-SISTEM-NEG-032, RO323-NOTIFIKASI-SISTEM-NEG-033, RO323-NOTIFIKASI-SISTEM-EDG-004, RO323-NOTIFIKASI-SISTEM-EDG-005, RO323-NOTIFIKASI-SISTEM-STR-010 |
| REQ-017 | Piutang TOP Jatuh Tempo Hari Ini: hanya trigger job pada tanggal jatuh tempo piutang belum lunas; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-016, RO323-NOTIFIKASI-SISTEM-NEG-034, RO323-NOTIFIKASI-SISTEM-POS-017, RO323-NOTIFIKASI-SISTEM-NEG-035, RO323-NOTIFIKASI-SISTEM-NEG-036, RO323-NOTIFIKASI-SISTEM-NEG-037, RO323-NOTIFIKASI-SISTEM-EDG-006, RO323-NOTIFIKASI-SISTEM-EDG-007 |
| REQ-018 | Pembayaran Berhasil: hanya trigger pembayaran order berhasil; penerima Kantor Pusat, Kantor Cabang, Agen, User Umum; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-018, RO323-NOTIFIKASI-SISTEM-NEG-038, RO323-NOTIFIKASI-SISTEM-POS-019, RO323-NOTIFIKASI-SISTEM-NEG-039, RO323-NOTIFIKASI-SISTEM-POS-020, RO323-NOTIFIKASI-SISTEM-NEG-040, RO323-NOTIFIKASI-SISTEM-POS-021, RO323-NOTIFIKASI-SISTEM-NEG-041, RO323-NOTIFIKASI-SISTEM-NEG-042, RO323-NOTIFIKASI-SISTEM-NEG-043 |
| REQ-019 | Pengingat Keberangkatan: hanya trigger job H-1 jadwal tiket milik penerima; penerima Kantor Pusat, Kantor Cabang, Agen, User Umum; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-022, RO323-NOTIFIKASI-SISTEM-NEG-044, RO323-NOTIFIKASI-SISTEM-POS-023, RO323-NOTIFIKASI-SISTEM-NEG-045, RO323-NOTIFIKASI-SISTEM-POS-024, RO323-NOTIFIKASI-SISTEM-NEG-046, RO323-NOTIFIKASI-SISTEM-POS-025, RO323-NOTIFIKASI-SISTEM-NEG-047, RO323-NOTIFIKASI-SISTEM-NEG-048, RO323-NOTIFIKASI-SISTEM-NEG-049, RO323-NOTIFIKASI-SISTEM-EDG-008, RO323-NOTIFIKASI-SISTEM-EDG-009, RO323-NOTIFIKASI-SISTEM-STR-009 |
| REQ-020 | Pengajuan Device Baru: hanya trigger pengajuan device berhasil; penerima Kantor Pusat, Agen; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-026, RO323-NOTIFIKASI-SISTEM-NEG-050, RO323-NOTIFIKASI-SISTEM-POS-027, RO323-NOTIFIKASI-SISTEM-NEG-051, RO323-NOTIFIKASI-SISTEM-NEG-052, RO323-NOTIFIKASI-SISTEM-NEG-053 |
| REQ-021 | Pengajuan Device Disetujui: hanya trigger approval device Pusat berhasil; penerima Kantor Pusat, Agen; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-028, RO323-NOTIFIKASI-SISTEM-NEG-054, RO323-NOTIFIKASI-SISTEM-POS-029, RO323-NOTIFIKASI-SISTEM-NEG-055, RO323-NOTIFIKASI-SISTEM-NEG-056, RO323-NOTIFIKASI-SISTEM-NEG-057 |
| REQ-022 | Pencabutan Approval Device: hanya trigger pencabutan approval device berhasil; penerima Kantor Pusat, Agen; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-030, RO323-NOTIFIKASI-SISTEM-NEG-058, RO323-NOTIFIKASI-SISTEM-POS-031, RO323-NOTIFIKASI-SISTEM-NEG-059, RO323-NOTIFIKASI-SISTEM-NEG-060, RO323-NOTIFIKASI-SISTEM-NEG-061 |
| REQ-023 | Pengajuan Pembatalan: hanya trigger pengajuan pembatalan tiket berhasil; penerima Kantor Pusat, Kantor Cabang, Agen; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-032, RO323-NOTIFIKASI-SISTEM-NEG-062, RO323-NOTIFIKASI-SISTEM-POS-033, RO323-NOTIFIKASI-SISTEM-NEG-063, RO323-NOTIFIKASI-SISTEM-POS-034, RO323-NOTIFIKASI-SISTEM-NEG-064, RO323-NOTIFIKASI-SISTEM-NEG-065, RO323-NOTIFIKASI-SISTEM-NEG-066, RO323-NOTIFIKASI-SISTEM-POS-067 |
| REQ-024 | Pembatalan Disetujui: hanya trigger pembatalan disetujui; penerima Kantor Pusat, Kantor Cabang, Agen; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-035, RO323-NOTIFIKASI-SISTEM-NEG-067, RO323-NOTIFIKASI-SISTEM-POS-036, RO323-NOTIFIKASI-SISTEM-NEG-068, RO323-NOTIFIKASI-SISTEM-POS-037, RO323-NOTIFIKASI-SISTEM-NEG-069, RO323-NOTIFIKASI-SISTEM-NEG-070, RO323-NOTIFIKASI-SISTEM-NEG-071 |
| REQ-025 | Pembatalan Ditolak: hanya trigger pembatalan ditolak; penerima Kantor Pusat, Kantor Cabang, Agen; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-038, RO323-NOTIFIKASI-SISTEM-NEG-072, RO323-NOTIFIKASI-SISTEM-POS-039, RO323-NOTIFIKASI-SISTEM-NEG-073, RO323-NOTIFIKASI-SISTEM-POS-040, RO323-NOTIFIKASI-SISTEM-NEG-074, RO323-NOTIFIKASI-SISTEM-NEG-075, RO323-NOTIFIKASI-SISTEM-NEG-076 |
| REQ-026 | Pengajuan Kuota: hanya trigger Cabang berhasil mengajukan kuota; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-041, RO323-NOTIFIKASI-SISTEM-NEG-077, RO323-NOTIFIKASI-SISTEM-POS-042, RO323-NOTIFIKASI-SISTEM-NEG-078, RO323-NOTIFIKASI-SISTEM-NEG-079, RO323-NOTIFIKASI-SISTEM-NEG-080 |
| REQ-027 | Kuota Disetujui: hanya trigger pengajuan kuota disetujui Pusat; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-043, RO323-NOTIFIKASI-SISTEM-NEG-081, RO323-NOTIFIKASI-SISTEM-POS-044, RO323-NOTIFIKASI-SISTEM-NEG-082, RO323-NOTIFIKASI-SISTEM-NEG-083, RO323-NOTIFIKASI-SISTEM-NEG-084 |
| REQ-028 | Kuota Ditolak: hanya trigger pengajuan kuota ditolak Pusat; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-045, RO323-NOTIFIKASI-SISTEM-NEG-085, RO323-NOTIFIKASI-SISTEM-POS-046, RO323-NOTIFIKASI-SISTEM-NEG-086, RO323-NOTIFIKASI-SISTEM-NEG-087, RO323-NOTIFIKASI-SISTEM-NEG-088 |
| REQ-029 | Pengajuan Member: hanya trigger pendaftaran JN Member berhasil; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-047, RO323-NOTIFIKASI-SISTEM-NEG-089, RO323-NOTIFIKASI-SISTEM-POS-048, RO323-NOTIFIKASI-SISTEM-NEG-090, RO323-NOTIFIKASI-SISTEM-NEG-091, RO323-NOTIFIKASI-SISTEM-NEG-092 |
| REQ-030 | Member Disetujui: hanya trigger pendaftaran member disetujui; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-049, RO323-NOTIFIKASI-SISTEM-NEG-093, RO323-NOTIFIKASI-SISTEM-POS-050, RO323-NOTIFIKASI-SISTEM-NEG-094, RO323-NOTIFIKASI-SISTEM-NEG-095, RO323-NOTIFIKASI-SISTEM-NEG-096 |
| REQ-031 | Member Ditolak: hanya trigger pendaftaran member ditolak; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-051, RO323-NOTIFIKASI-SISTEM-NEG-097, RO323-NOTIFIKASI-SISTEM-POS-052, RO323-NOTIFIKASI-SISTEM-NEG-098, RO323-NOTIFIKASI-SISTEM-NEG-099, RO323-NOTIFIKASI-SISTEM-NEG-100 |
| REQ-032 | Verifikasi Ulang Member: hanya trigger pengajuan ulang setelah ditolak berstatus Waiting Verifikasi; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-053, RO323-NOTIFIKASI-SISTEM-NEG-101, RO323-NOTIFIKASI-SISTEM-POS-054, RO323-NOTIFIKASI-SISTEM-NEG-102, RO323-NOTIFIKASI-SISTEM-NEG-103, RO323-NOTIFIKASI-SISTEM-NEG-104 |
| REQ-033 | Pengajuan Reward Masuk: hanya trigger Member mengajukan penukaran reward berhasil; penerima Kantor Pusat, Kantor Cabang; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-055, RO323-NOTIFIKASI-SISTEM-NEG-105, RO323-NOTIFIKASI-SISTEM-POS-056, RO323-NOTIFIKASI-SISTEM-NEG-106, RO323-NOTIFIKASI-SISTEM-NEG-107, RO323-NOTIFIKASI-SISTEM-NEG-108 |
| REQ-034 | Pengajuan Reward Diterima: hanya trigger pengajuan reward disetujui; penerima Kantor Pusat, Kantor Cabang, Member; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-057, RO323-NOTIFIKASI-SISTEM-NEG-109, RO323-NOTIFIKASI-SISTEM-POS-058, RO323-NOTIFIKASI-SISTEM-NEG-110, RO323-NOTIFIKASI-SISTEM-POS-059, RO323-NOTIFIKASI-SISTEM-NEG-111, RO323-NOTIFIKASI-SISTEM-NEG-112, RO323-NOTIFIKASI-SISTEM-NEG-113 |
| REQ-035 | Pengajuan Reward Ditolak: hanya trigger pengajuan reward ditolak; penerima Kantor Pusat, Kantor Cabang, Member; judul, isi aktual, dan tujuan sesuai matriks kontrak. | RO323-NOTIFIKASI-SISTEM-POS-060, RO323-NOTIFIKASI-SISTEM-NEG-114, RO323-NOTIFIKASI-SISTEM-POS-061, RO323-NOTIFIKASI-SISTEM-NEG-115, RO323-NOTIFIKASI-SISTEM-POS-062, RO323-NOTIFIKASI-SISTEM-NEG-116, RO323-NOTIFIKASI-SISTEM-NEG-117, RO323-NOTIFIKASI-SISTEM-NEG-118 |
| REQ-036 | Setting Notifikasi tampil hanya di admin Prahu; akses hanya Admin Utama Prahu termasuk URL langsung. | RO323-NOTIFIKASI-SISTEM-POS-075, RO323-NOTIFIKASI-SISTEM-NEG-126, RO323-NOTIFIKASI-SISTEM-NEG-127, RO323-NOTIFIKASI-SISTEM-NEG-128, RO323-NOTIFIKASI-SISTEM-NEG-129, RO323-NOTIFIKASI-SISTEM-NEG-130, RO323-NOTIFIKASI-SISTEM-NEG-131, RO323-NOTIFIKASI-SISTEM-NEG-164 |
| REQ-037 | Global OFF mencegah pengiriman seluruh akun dan menghilangkan pilihan Preferensi; ON tetap tunduk trigger/role/akses/owner/preferensi. | RO323-NOTIFIKASI-SISTEM-POS-076, RO323-NOTIFIKASI-SISTEM-NEG-132, RO323-NOTIFIKASI-SISTEM-STR-002 |
| REQ-038 | Empat section Email, WhatsApp, Push JN Member, Push Sistem Web dapat expand/collapse, dengan counter aktif/total. | RO323-NOTIFIKASI-SISTEM-POS-077, RO323-NOTIFIKASI-SISTEM-NEG-133, RO323-NOTIFIKASI-SISTEM-EDG-012 |
| REQ-039 | Setting memuat nilai tersimpan; perubahan berlaku hanya setelah Simpan berhasil dengan informasi sukses. | RO323-NOTIFIKASI-SISTEM-POS-078, RO323-NOTIFIKASI-SISTEM-NEG-134, RO323-NOTIFIKASI-SISTEM-NEG-165, RO323-NOTIFIKASI-SISTEM-STR-003 |
| REQ-040 | Batal memulihkan setting tersimpan; saat bersih tombol boleh disabled dan indikator perubahan opsional. | RO323-NOTIFIKASI-SISTEM-POS-079, RO323-NOTIFIKASI-SISTEM-NEG-135, RO323-NOTIFIKASI-SISTEM-EDG-011 |
| REQ-041 | Email existing dipertahankan, dikelompokkan User Online, Operator, Pembeli Via Gerai, Pembeli Via Agen; toggle per jenis mengatur kiriman/pilihan. | RO323-NOTIFIKASI-SISTEM-POS-080, RO323-NOTIFIKASI-SISTEM-NEG-136 |
| REQ-042 | WhatsApp hanya jenis yang mendukung; kelompok User Online, Pembeli Via Gerai, Pembeli Via Agen; default awal OFF; toggle mengatur kiriman/pilihan. | RO323-NOTIFIKASI-SISTEM-POS-081, RO323-NOTIFIKASI-SISTEM-NEG-137, RO323-NOTIFIKASI-SISTEM-POS-108, RO323-NOTIFIKASI-SISTEM-NEG-166 |
| REQ-043 | Toggle Push JN Member mengatur ketersediaan/pengiriman aplikasi; ON memakai rule existing. | RO323-NOTIFIKASI-SISTEM-POS-082, RO323-NOTIFIKASI-SISTEM-NEG-138 |
| REQ-044 | Push Sistem Web memuat sembilan kategori; tiap jenis mempunyai nama, trigger, penerima dan toggle; counter kategori akurat. | RO323-NOTIFIKASI-SISTEM-POS-083, RO323-NOTIFIKASI-SISTEM-NEG-139 |
| REQ-045 | Semua mengubah seluruh jenis dalam kategori; per-jenis hanya mengubah jenis itu dan tidak mengubah penerima. | RO323-NOTIFIKASI-SISTEM-POS-084, RO323-NOTIFIKASI-SISTEM-NEG-140 |
| REQ-046 | Preferensi Notifikasi tersedia menurut jenis akun; admin Prahu menu dipindah ke Setting dengan label Preferensi Notifikasi. | RO323-NOTIFIKASI-SISTEM-POS-085, RO323-NOTIFIKASI-SISTEM-NEG-141, RO323-NOTIFIKASI-SISTEM-POS-109, RO323-NOTIFIKASI-SISTEM-POS-110, RO323-NOTIFIKASI-SISTEM-POS-111, RO323-NOTIFIKASI-SISTEM-POS-112, RO323-NOTIFIKASI-SISTEM-POS-113 |
| REQ-047 | Preferensi dan perubahan channel bersifat per akun, tidak mengubah user lain ataupun setting global. | RO323-NOTIFIKASI-SISTEM-POS-086, RO323-NOTIFIKASI-SISTEM-NEG-142, RO323-NOTIFIKASI-SISTEM-STR-004 |
| REQ-048 | Hanya jenis/channel global ON, role benar, akses sah dan channel didukung ditawarkan; semua tidak tersedia dapat menyembunyikan jenis/kategori. | RO323-NOTIFIKASI-SISTEM-POS-087, RO323-NOTIFIKASI-SISTEM-NEG-143, RO323-NOTIFIKASI-SISTEM-NEG-168, RO323-NOTIFIKASI-SISTEM-EDG-016 |
| REQ-049 | Jika tidak ada pilihan tersedia tampil persis Belum ada notifikasi yang tersedia. | RO323-NOTIFIKASI-SISTEM-POS-088, RO323-NOTIFIKASI-SISTEM-NEG-144 |
| REQ-050 | Muat preferensi terakhir; akun baru aktif sesuai global/default sistem; Simpan permanen dan tanggal setting terakhir diperbarui hanya saat sukses. | RO323-NOTIFIKASI-SISTEM-POS-089, RO323-NOTIFIKASI-SISTEM-NEG-145, RO323-NOTIFIKASI-SISTEM-NEG-167, RO323-NOTIFIKASI-SISTEM-EDG-013, RO323-NOTIFIKASI-SISTEM-EDG-014, RO323-NOTIFIKASI-SISTEM-STR-005 |
| REQ-051 | Batal mengembalikan pilihan tersimpan; tombol bersih boleh disabled tanpa mengubah tanggal terakhir. | RO323-NOTIFIKASI-SISTEM-POS-090, RO323-NOTIFIKASI-SISTEM-NEG-146 |
| REQ-052 | Header kategori counter dipilih/tersedia; Semua mengatur hanya pasangan jenis-channel yang tersedia untuk akun. | RO323-NOTIFIKASI-SISTEM-POS-091, RO323-NOTIFIKASI-SISTEM-NEG-147, RO323-NOTIFIKASI-SISTEM-EDG-015 |
| REQ-053 | Email, WhatsApp dan Push independen; mematikan satu tidak mematikan lainnya; global OFF tidak dapat dipilih. | RO323-NOTIFIKASI-SISTEM-POS-092, RO323-NOTIFIKASI-SISTEM-NEG-148 |
| REQ-054 | Pusat dapat memilih 9 kategori Push sesuai daftar spec; tetap difilter hak akses. | RO323-NOTIFIKASI-SISTEM-POS-093, RO323-NOTIFIKASI-SISTEM-NEG-149 |
| REQ-055 | Cabang dapat memilih 8 kategori Push; Manajemen Device tidak tampil; Top Up memakai alias spec; filter akses. | RO323-NOTIFIKASI-SISTEM-POS-094, RO323-NOTIFIKASI-SISTEM-NEG-150 |
| REQ-056 | Agen hanya Top Up, Order & Keberangkatan, Device, Pembatalan; tidak ada Tiket Gratis/TOP/Kuota/JN Member/Reward. | RO323-NOTIFIKASI-SISTEM-POS-095, RO323-NOTIFIKASI-SISTEM-NEG-151 |
| REQ-057 | User Umum hanya Order & Keberangkatan; Member terkait juga Reward Diterima/Ditolak; Email/WA existing dipertahankan. | RO323-NOTIFIKASI-SISTEM-POS-096, RO323-NOTIFIKASI-SISTEM-NEG-152, RO323-NOTIFIKASI-SISTEM-POS-097, RO323-NOTIFIKASI-SISTEM-NEG-153 |
| REQ-058 | Penambahan Push dan pemisahan global/personal tidak menghapus katalog atau me-reset preferensi Email/WA existing. | RO323-NOTIFIKASI-SISTEM-POS-098, RO323-NOTIFIKASI-SISTEM-NEG-154 |
| REQ-059 | Global lebih tinggi, OFF tidak menghapus preferensi tersimpan; ON kembali menggunakan pilihan terakhir. | RO323-NOTIFIKASI-SISTEM-POS-099, RO323-NOTIFIKASI-SISTEM-NEG-155, RO323-NOTIFIKASI-SISTEM-EDG-017 |
| REQ-060 | Setting dan preferensi permanen melintasi logout/login, sesi dan browser. | RO323-NOTIFIKASI-SISTEM-POS-100, RO323-NOTIFIKASI-SISTEM-NEG-156, RO323-NOTIFIKASI-SISTEM-EDG-018, RO323-NOTIFIKASI-SISTEM-STR-012 |
| REQ-061 | Tombol bell Notifikasi membuka daftar dan indikator bell menunjukkan unread akun sendiri. | RO323-NOTIFIKASI-SISTEM-POS-101, RO323-NOTIFIKASI-SISTEM-NEG-157 |
| REQ-062 | Filter status Semua/Belum Dibaca/Sudah Dibaca dan kategori bekerja bersama tanpa kebocoran data. | RO323-NOTIFIKASI-SISTEM-POS-102, RO323-NOTIFIKASI-SISTEM-NEG-158 |
| REQ-063 | Checkbox baris/Pilih Semua mengatur seleksi hasil filter dan counter; perubahan filter membersihkan seleksi. | RO323-NOTIFIKASI-SISTEM-POS-103, RO323-NOTIFIKASI-SISTEM-NEG-159 |
| REQ-064 | Hapus Notifikasi menghapus hanya seleksi akun; disabled tanpa seleksi; toast jumlah akurat. | RO323-NOTIFIKASI-SISTEM-POS-104, RO323-NOTIFIKASI-SISTEM-NEG-160, RO323-NOTIFIKASI-SISTEM-NEG-169, RO323-NOTIFIKASI-SISTEM-NEG-171, RO323-NOTIFIKASI-SISTEM-EDG-020, RO323-NOTIFIKASI-SISTEM-STR-008 |
| REQ-065 | Tandai Sudah Dibaca mengubah hanya seleksi akun; disabled tanpa seleksi; toast jumlah akurat. | RO323-NOTIFIKASI-SISTEM-POS-105, RO323-NOTIFIKASI-SISTEM-NEG-161, RO323-NOTIFIKASI-SISTEM-NEG-170, RO323-NOTIFIKASI-SISTEM-EDG-019, RO323-NOTIFIKASI-SISTEM-STR-007 |
| REQ-066 | Daftar kosong/filter tanpa hasil menampilkan Tidak ada notifikasi yang tersedia. dan kontrol seleksi tidak aktif. | RO323-NOTIFIKASI-SISTEM-POS-106, RO323-NOTIFIKASI-SISTEM-NEG-162 |
| REQ-067 | Menampilkan 10/20/50 Data dan pagination menampilkan range/total hasil filter. | RO323-NOTIFIKASI-SISTEM-POS-107, RO323-NOTIFIKASI-SISTEM-NEG-163, RO323-NOTIFIKASI-SISTEM-EDG-021, RO323-NOTIFIKASI-SISTEM-STR-006 |

## Coverage layar dan UI

| Layar | Positive | Negative | Edge | Stress |
|---|---:|---:|---:|---:|
| notifikasi | 81 | 137 | 14 | 7 |
| setting-notifikasi | 11 | 18 | 2 | 2 |
| preferensi-notifikasi | 21 | 18 | 6 | 3 |

| Layar | Elemen | Contoh Scenario ID |
|---|---|---|
| notifikasi | Notifikasi | RO323-NOTIFIKASI-SISTEM-POS-101, RO323-NOTIFIKASI-SISTEM-NEG-157, RO323-NOTIFIKASI-SISTEM-EDG-020 |
| notifikasi | Daftar notifikasi | RO323-NOTIFIKASI-SISTEM-POS-068, RO323-NOTIFIKASI-SISTEM-POS-069, RO323-NOTIFIKASI-SISTEM-NEG-120 |
| notifikasi | Penanda belum dibaca | RO323-NOTIFIKASI-SISTEM-POS-001, RO323-NOTIFIKASI-SISTEM-POS-002, RO323-NOTIFIKASI-SISTEM-POS-003 |
| notifikasi | Baca notifikasi | RO323-NOTIFIKASI-SISTEM-POS-027, RO323-NOTIFIKASI-SISTEM-POS-029, RO323-NOTIFIKASI-SISTEM-POS-031 |
| notifikasi | Detail | RO323-NOTIFIKASI-SISTEM-POS-001, RO323-NOTIFIKASI-SISTEM-POS-002, RO323-NOTIFIKASI-SISTEM-POS-003 |
| notifikasi | Status baca | RO323-NOTIFIKASI-SISTEM-POS-102, RO323-NOTIFIKASI-SISTEM-NEG-162, RO323-NOTIFIKASI-SISTEM-STR-006 |
| notifikasi | Kategori | RO323-NOTIFIKASI-SISTEM-POS-102, RO323-NOTIFIKASI-SISTEM-NEG-158, RO323-NOTIFIKASI-SISTEM-NEG-159 |
| notifikasi | Pilih Semua | RO323-NOTIFIKASI-SISTEM-POS-103, RO323-NOTIFIKASI-SISTEM-NEG-159, RO323-NOTIFIKASI-SISTEM-POS-104 |
| notifikasi | Pilih notifikasi | RO323-NOTIFIKASI-SISTEM-NEG-121, RO323-NOTIFIKASI-SISTEM-POS-103 |
| notifikasi | Jumlah dipilih | RO323-NOTIFIKASI-SISTEM-POS-103, RO323-NOTIFIKASI-SISTEM-NEG-159 |
| notifikasi | Hapus Notifikasi | RO323-NOTIFIKASI-SISTEM-NEG-159, RO323-NOTIFIKASI-SISTEM-POS-104, RO323-NOTIFIKASI-SISTEM-NEG-160 |
| notifikasi | Tandai Sudah Dibaca | RO323-NOTIFIKASI-SISTEM-NEG-159, RO323-NOTIFIKASI-SISTEM-POS-105, RO323-NOTIFIKASI-SISTEM-NEG-161 |
| notifikasi | Menampilkan Data | RO323-NOTIFIKASI-SISTEM-POS-107, RO323-NOTIFIKASI-SISTEM-EDG-021, RO323-NOTIFIKASI-SISTEM-STR-006 |
| notifikasi | Pagination | RO323-NOTIFIKASI-SISTEM-POS-107, RO323-NOTIFIKASI-SISTEM-NEG-163, RO323-NOTIFIKASI-SISTEM-EDG-021 |
| notifikasi | Daftar kosong | RO323-NOTIFIKASI-SISTEM-POS-106, RO323-NOTIFIKASI-SISTEM-NEG-162, RO323-NOTIFIKASI-SISTEM-EDG-020 |
| notifikasi | Informasi aksi | RO323-NOTIFIKASI-SISTEM-POS-104, RO323-NOTIFIKASI-SISTEM-POS-105, RO323-NOTIFIKASI-SISTEM-NEG-169 |
| setting-notifikasi | Setting Notifikasi | RO323-NOTIFIKASI-SISTEM-POS-075, RO323-NOTIFIKASI-SISTEM-NEG-126, RO323-NOTIFIKASI-SISTEM-NEG-127 |
| setting-notifikasi | Section notifikasi | RO323-NOTIFIKASI-SISTEM-POS-075 |
| setting-notifikasi | Counter section | RO323-NOTIFIKASI-SISTEM-POS-077, RO323-NOTIFIKASI-SISTEM-NEG-133, RO323-NOTIFIKASI-SISTEM-POS-083 |
| setting-notifikasi | Kelompok penerima Email | RO323-NOTIFIKASI-SISTEM-POS-080 |
| setting-notifikasi | Kelompok penerima WhatsApp | RO323-NOTIFIKASI-SISTEM-POS-081 |
| setting-notifikasi | Toggle Email | RO323-NOTIFIKASI-SISTEM-NEG-133, RO323-NOTIFIKASI-SISTEM-POS-080, RO323-NOTIFIKASI-SISTEM-NEG-136 |
| setting-notifikasi | Toggle WhatsApp | RO323-NOTIFIKASI-SISTEM-POS-081, RO323-NOTIFIKASI-SISTEM-POS-108, RO323-NOTIFIKASI-SISTEM-NEG-166 |
| setting-notifikasi | Toggle Push JN Member | RO323-NOTIFIKASI-SISTEM-POS-077, RO323-NOTIFIKASI-SISTEM-POS-082, RO323-NOTIFIKASI-SISTEM-NEG-138 |
| setting-notifikasi | Kategori Push Web | RO323-NOTIFIKASI-SISTEM-POS-083, RO323-NOTIFIKASI-SISTEM-NEG-139, RO323-NOTIFIKASI-SISTEM-POS-084 |
| setting-notifikasi | Semua jenis kategori | RO323-NOTIFIKASI-SISTEM-POS-084, RO323-NOTIFIKASI-SISTEM-NEG-140 |
| setting-notifikasi | Toggle jenis Web | RO323-NOTIFIKASI-SISTEM-POS-076, RO323-NOTIFIKASI-SISTEM-POS-078, RO323-NOTIFIKASI-SISTEM-NEG-134 |
| setting-notifikasi | Batal | RO323-NOTIFIKASI-SISTEM-POS-079, RO323-NOTIFIKASI-SISTEM-NEG-135 |
| setting-notifikasi | Simpan | RO323-NOTIFIKASI-SISTEM-POS-076, RO323-NOTIFIKASI-SISTEM-POS-078, RO323-NOTIFIKASI-SISTEM-NEG-134 |
| setting-notifikasi | Informasi hasil simpan | RO323-NOTIFIKASI-SISTEM-POS-076, RO323-NOTIFIKASI-SISTEM-POS-078, RO323-NOTIFIKASI-SISTEM-NEG-134 |
| setting-notifikasi | Perubahan belum disimpan | RO323-NOTIFIKASI-SISTEM-POS-079, RO323-NOTIFIKASI-SISTEM-EDG-011 |
| preferensi-notifikasi | Preferensi Notifikasi | RO323-NOTIFIKASI-SISTEM-POS-085, RO323-NOTIFIKASI-SISTEM-NEG-141, RO323-NOTIFIKASI-SISTEM-POS-109 |
| preferensi-notifikasi | Kategori preferensi | RO323-NOTIFIKASI-SISTEM-POS-087, RO323-NOTIFIKASI-SISTEM-POS-088, RO323-NOTIFIKASI-SISTEM-POS-093 |
| preferensi-notifikasi | Counter preferensi | RO323-NOTIFIKASI-SISTEM-POS-090, RO323-NOTIFIKASI-SISTEM-POS-091, RO323-NOTIFIKASI-SISTEM-NEG-147 |
| preferensi-notifikasi | Semua channel kategori | RO323-NOTIFIKASI-SISTEM-POS-091, RO323-NOTIFIKASI-SISTEM-NEG-147, RO323-NOTIFIKASI-SISTEM-EDG-015 |
| preferensi-notifikasi | Email | RO323-NOTIFIKASI-SISTEM-POS-090, RO323-NOTIFIKASI-SISTEM-NEG-146, RO323-NOTIFIKASI-SISTEM-POS-092 |
| preferensi-notifikasi | WhatsApp | RO323-NOTIFIKASI-SISTEM-POS-090, RO323-NOTIFIKASI-SISTEM-POS-091, RO323-NOTIFIKASI-SISTEM-POS-092 |
| preferensi-notifikasi | Push | RO323-NOTIFIKASI-SISTEM-POS-086, RO323-NOTIFIKASI-SISTEM-NEG-142, RO323-NOTIFIKASI-SISTEM-POS-089 |
| preferensi-notifikasi | Batal | RO323-NOTIFIKASI-SISTEM-POS-090, RO323-NOTIFIKASI-SISTEM-NEG-146 |
| preferensi-notifikasi | Simpan | RO323-NOTIFIKASI-SISTEM-POS-086, RO323-NOTIFIKASI-SISTEM-NEG-142, RO323-NOTIFIKASI-SISTEM-POS-089 |
| preferensi-notifikasi | Preferensi kosong | RO323-NOTIFIKASI-SISTEM-POS-088, RO323-NOTIFIKASI-SISTEM-NEG-144, RO323-NOTIFIKASI-SISTEM-EDG-016 |
| preferensi-notifikasi | Informasi akun | RO323-NOTIFIKASI-SISTEM-POS-089 |
| preferensi-notifikasi | Tanggal Setting Terakhir | RO323-NOTIFIKASI-SISTEM-POS-089, RO323-NOTIFIKASI-SISTEM-NEG-145 |

## Matriks template / penerima

| Jenis | Penerima positive teruji | Kondisi negative |
|---|---|---|
| Top Up Saldo Berhasil | Kantor Pusat | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Top Up Saldo Agen Berhasil | Kantor Cabang | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Saldo Berhasil Ditambahkan | Agen | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Pengajuan Tiket Gratis | Kantor Pusat, Kantor Cabang | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Tiket Gratis Disetujui Cabang | Kantor Pusat, Kantor Cabang | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Tiket Gratis Disetujui Pusat | Kantor Pusat, Kantor Cabang | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Transaksi Pembayaran TOP | Kantor Pusat, Kantor Cabang | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Piutang TOP Telah Lunas | Kantor Pusat, Kantor Cabang | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Piutang TOP Jatuh Tempo H-3 | Kantor Pusat, Kantor Cabang | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Piutang TOP Jatuh Tempo Hari Ini | Kantor Pusat, Kantor Cabang | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Pembayaran Berhasil | Kantor Pusat, Kantor Cabang, Agen, User Umum | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Pengingat Keberangkatan | Kantor Pusat, Kantor Cabang, Agen, User Umum | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Pengajuan Device Baru | Kantor Pusat, Agen | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Pengajuan Device Disetujui | Kantor Pusat, Agen | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Pencabutan Approval Device | Kantor Pusat, Agen | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Pengajuan Pembatalan | Kantor Pusat, Kantor Cabang, Agen | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Pembatalan Disetujui | Kantor Pusat, Kantor Cabang, Agen | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Pembatalan Ditolak | Kantor Pusat, Kantor Cabang, Agen | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Pengajuan Kuota | Kantor Pusat, Kantor Cabang | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Kuota Disetujui | Kantor Pusat, Kantor Cabang | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Kuota Ditolak | Kantor Pusat, Kantor Cabang | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Pengajuan Member | Kantor Pusat, Kantor Cabang | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Member Disetujui | Kantor Pusat, Kantor Cabang | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Member Ditolak | Kantor Pusat, Kantor Cabang | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Verifikasi Ulang Member | Kantor Pusat, Kantor Cabang | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Pengajuan Reward Masuk | Kantor Pusat, Kantor Cabang | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Pengajuan Reward Diterima | Kantor Pusat, Kantor Cabang, Member | trigger gagal/non-due per penerima; global OFF; personal OFF |
| Pengajuan Reward Ditolak | Kantor Pusat, Kantor Cabang, Member | trigger gagal/non-due per penerima; global OFF; personal OFF |

## Validasi Gherkin dan JSON

- LULUS: Gherkin diparse dengan parser resmi gherkin-official; setiap Scenario mempunyai Given/When/Then, tag kategori/priority/REQ/screen sah, dan ID padanan JSON tepat.
- LULUS: target/nilai/prasyarat langkah diperiksa terhadap AST; rendering penuh Gherkin sesuai metadata JSON. Expect mencakup visible, absent/count, disabled, body, counter, read-state, destination/record. Adapter codegen harus membaca kondisi value, bukan mengubah semua expect menjadi toBeVisible.
- LULUS: seluruh field wajib, action enum, selectorHints role/name/testid, format/keunikan ID dan requirement/screen diperiksa. Summary dihitung ulang dari seluruh scenario.
- LULUS: tiap REQ memiliki positive/negative; elemen UI ditelusuri via testid usulan; sumber input ada. Ini validasi artefak, bukan hasil eksekusi terhadap aplikasi TMS.

## Duplikat dan tinjauan tumpang tindih

- Duplikat identik yang dibuang: **0**. Signature membandingkan prasyarat, langkah, expected, dan testData; ID/title diabaikan.
- Skenario per-role sengaja dipertahankan karena body, tujuan, actor atau permission berbeda. Trigger gagal, global OFF, dan personal OFF memeriksa jalur berbeda. Counter/draft dan Simpan/Batal memakai oracle committed berbeda.
- Kasus ulang jadwal, retry job, pemalsuan ID, dan konkurensi bukan duplikasi happy path; ditandai rekomendasi robustness bila spec tidak mengunci kebijakan.

## Gap dan batas verifikasi

- Gap coverage requirement/UI terhadap kontrak analisis: **tidak ada**. 67 REQ merupakan dekomposisi QA, bukan ID requirement asli dari spec.
- PNG tidak tersedia. Belum ada pemeriksaan pixel/layout nyata; UI Setting/Preferensi diturunkan spec, UI daftar dari HTML teks. Tidak mengklaim prototipe bisa dijalankan atau routing simulasi merupakan hasil navigasi produksi.
- Katalog Email/WhatsApp dan trigger aplikasi JN Member existing memerlukan fixture katalog existing yang disetujui untuk menjalankan oracle. Belum tersedia daftar item lengkap dalam input; scenario tidak mengarang daftar baru.
- URL, DOM/ARIA aktual, scope notificationId, status/error string, endpoint dan adapter fixture belum tersedia. Seluruh data-testid usulan. Counter/top-up memakai jumlah jenis konfigurasi, bukan jumlah template role.
- Event/pengiriman, migrasi, fault, clock scheduler, ledger/mailbox/WA/app-push sink, dan stress memerlukan fixture implementasi. Assertion di testData.assertionsOutsideUI/fixtureFollowUp/fixtureInterleave harus diikat oleh codegen; expected[] tetap bagian oracle test walaupun pemeriksaannya bukan elemen halaman ini.
- Pilihan tampilan opsional (tombol disabled saat bersih, dirty count, info akun, hide kategori) tidak diperlakukan sebagai kewajiban desain tanpa implementasi. Toggle switch aktual perlu adapter dari check/uncheck.
- Stress 10000 event/100 sesi merupakan beban usulan. Tidak ada SLA/ambang latency yang ditetapkan spec; skenario menguji set ID/receiver dan konsistensi, bukan menjanjikan performa. Retensi 3 bulan dari standalone tidak menjadi acceptance criterion.

## Asumsi dan rekomendasi pelaksanaan

A01–A12 lengkap terdapat pada analysis.md. Fixture historis scheduler memakai clock beku; tanggal simpan contoh menggunakan 8 Oktober 2026 Asia/Jakarta. Jalankan robustness dengan kebijakan dedup/konflik yang dipilih sistem; oracle rekomendasi dicantumkan tanpa menganggap kebijakan tersebut sudah implementasi.

## Integritas artefak

| Artefak/sumber | SHA-256 |
|---|---|
| output/ro323-notifikasi-sistem/ro323-notifikasi-sistem.analysis.md | 67a883192bb861de266b164c38f6a72e15385bb30db165c7832ae5693ea9fec9 |
| output/ro323-notifikasi-sistem/ro323-notifikasi-sistem.feature | 993765b79691fac96df95ecb9a84b77c32b2521559d8881ad0df020fa00c4fc7 |
| output/ro323-notifikasi-sistem/ro323-notifikasi-sistem.scenarios.json | bc7b76d2c6498656a24a1e93beb02e5785f2cdffcf5cff1b26a6a3d3b1c71435 |
| inputs/ro323-notifikasi-sistem/spec.txt | 787b5468e3d5baf66c66464e873f9b6621a0bdc2197b3b13b286e19d4d799e12 |
| inputs/ro323-notifikasi-sistem/extras/6-push-notification-dc.html | d7eec595e3c3dd7ff77fcdd1c3befc09409e5af3f0695597284a6b3094111a9b |
| inputs/ro323-notifikasi-sistem/extras/push-notification-standalone-dc.html | 4b2e52a1cb2eb216b346b894a06c7b0fb53607e50fc3a6a9e87dcc1c969106e7 |
