# Analysis — ro313-cetak-tiket-langsung

Sumber utama: `inputs/ro313-cetak-tiket-langsung/spec.txt`. Analisis tanggal 8 Oktober 2026 (Asia/Jakarta). ID modul sumber: RO313.

## Requirements

| ID | Requirement | Acceptance criteria berdasarkan spec |
|---|---|---|
| REQ-001 | Menu sidebar Cetak Tiket membuka halaman Cetak E-Tiket secara langsung. | Pengguna dapat membuka menu tanpa membuka Daftar Order; judul halaman adalah Cetak E-Tiket. |
| REQ-002 | Daftar berbentuk tabel dengan delapan kolom yang ditetapkan. | ID Order, Nama Pembeli, Rute, Kapal, Berangkat, Jml Tiket, Total (Rp), Aksi ditampilkan; nilai tiap baris sesuai order sumber. |
| REQ-003 | Hanya order berstatus selesai ditampilkan. | Order selesai yang memenuhi syarat cabang dan retensi tampil; pending, dibatalkan, atau gagal tidak tampil. |
| REQ-004 | Pembelian lewat cabang mensyaratkan konfirmasi cetak e-tiket. | Order cabang selesai dan terkonfirmasi tampil; order cabang selesai tanpa konfirmasi tidak tampil. Pembelian noncabang tidak memerlukan konfirmasi cabang. |
| REQ-005 | Baris otomatis hilang setelah melewati H+3 waktu keberangkatan kapal. | Retensi dihitung dari waktu keberangkatan tiap order; order belum kedaluwarsa tetap tampil dan order yang melewati batas tidak tampil. Definisi tepat H+3 masih asumsi A-03. |
| REQ-006 | Cetak Tiket pada baris langsung memanggil fitur print tiket order tersebut. | Pengguna tidak harus membuka informasi Daftar Order; dokumen print sesuai baris yang dipilih dan tidak tercampur dengan order lain. |
| REQ-007 | Download pada baris membuka PDF tiket di tab baru. | Tab asal tetap tersedia; tab baru menampilkan PDF milik order yang dipilih, sesuai data tiket. |
| REQ-008 | Filter ID Order menggunakan text field. | Input ID Order menyaring daftar yang sudah memenuhi syarat; perilaku exact match menggunakan asumsi A-04. |
| REQ-009 | Filter Rute menggunakan dropdown rute yang tersedia. | Pilihan rute tersedia ditampilkan dan hasil hanya memuat rute terpilih; filter tidak mengabaikan syarat status, cabang, dan retensi. |
| REQ-010 | Filter tanggal berangkat menerima tanggal dan waktu DD/MM/YYYY hh:mm. | Filter berdasarkan waktu keberangkatan; tanggal/waktu valid diterima dan tanggal/waktu tidak valid ditolak tanpa menerapkan nilai invalid. |
| REQ-011 | Filter Nama Pembeli menggunakan text field. | Input nama menyaring daftar yang sudah memenuhi syarat; perilaku substring tanpa membedakan kapital menggunakan asumsi A-04. |
| REQ-012 | Filter yang digunakan bersamaan tetap bekerja pada daftar yang memenuhi syarat. | ID, rute, waktu berangkat, dan nama dipadukan sebagai AND; mengosongkan filter mengembalikan daftar eligible. Ini requirement turunan, bukan aturan eksplisit spec (A-05). |
| REQ-013 | Ukuran halaman, nomor halaman, dan ringkasan jumlah data sesuai hasil eligible/filter. | Desain memperlihatkan ukuran 10, halaman aktif 1, dan ringkasan Menampilkan 1 sampai 9 dari 9 data. Navigasi halaman lain dan reset setelah filter adalah perilaku turunan (A-13). |
| REQ-014 | Tombol Filter menyediakan akses ke empat kontrol filter. | Desain menampilkan tombol Filter, tetapi panel belum terbuka. Panel dapat dibuka/ditutup dan nilai filter tetap konsisten (A-12). |

### Aturan validasi

| Field/kondisi | Aturan eksplisit | Interpretasi untuk pengujian |
|---|---|---|
| ID Order | Text field; panjang/karakter wajib tidak ditentukan. | Opsional, trim spasi luar, exact match; tidak menetapkan panjang maksimum bisnis. Payload panjang diuji sebagai robustness. |
| Rute | Dropdown rute tersedia. | Opsional; hanya value rute tersedia boleh diterapkan. Nilai yang dipalsukan harus ditolak atau memberi hasil kosong. |
| Tanggal berangkat | DD/MM/YYYY hh:mm. | Opsional; jam 00–23, menit 00–59, tanggal kalender valid termasuk leap year; pencocokan sampai menit (A-04). |
| Nama Pembeli | Text field; panjang/karakter wajib tidak ditentukan. | Opsional, trim spasi luar, Unicode diterima; substring case-insensitive (A-04). |
| Eligible | Selesai; konfirmasi cetak e-tiket untuk cabang; belum melewati H+3. | Ketiga syarat diterapkan sebelum filter, pada refresh, dan sebelum aksi print/PDF (revalidasi aksi adalah A-09). |
| Kolom angka | Jml Tiket dan Total (Rp). | Harus konsisten dengan fixture; pemisah ribuan/tanggal tampilan dikonfirmasi dari desain, tidak menciptakan aturan harga atau maksimum tiket. |

### Aktor dan akses

Spec tidak menyebut nama role atau matriks izin. Aktor pengujian adalah petugas yang sudah login dan memiliki akses Cetak Tiket. Penolakan sesi habis, akses halaman, dan akses dokumen lintas tenant merupakan pengujian defensif berdasarkan A-02, bukan acceptance criteria role resmi.

### Alur utama dan alternatif

1. Petugas membuka sidebar Cetak Tiket → halaman Cetak E-Tiket memuat order eligible.
2. Petugas mengisi satu atau beberapa filter → hasil tetap memenuhi status, konfirmasi cabang, dan retensi.
3. Cetak Tiket pada baris → fitur print langsung berisi tiket order terpilih; membatalkan print mempertahankan halaman.
4. Download pada baris → tab baru berisi PDF tiket order terpilih; tab asal tetap tersedia.
5. Data tidak cocok → daftar kosong; nilai filter invalid, jaringan gagal, atau dokumen tidak tersedia → penanganan aman; bentuk pesan tepat masih asumsi.
6. Waktu melewati H+3 → baris hilang otomatis; aksi yang tertunda tidak boleh menghasilkan dokumen kedaluwarsa (A-09).

## UI Inventory

### Layar cetak-e-tiket

PNG dibaca langsung: `inputs/ro313-cetak-tiket-langsung/designs/ro313-cetak-tiket-langsung.png` (1920 × 1263). State terlihat: halaman sukses dengan 9 baris, menu aktif CETAK TIKET, Filter tertutup, ukuran halaman 10, halaman 1 aktif, dan tiga baris berwarna krem dengan badge Masa cetak s/d H+3. Tidak terlihat state empty/error/loading/disabled, panel filter terbuka, dialog print, atau tab PDF.

| Elemen / key selector | Bukti dan tipe | role + name / label | Usulan data-testid |
|---|---|---|---|
| Menu Cetak Tiket | Sidebar CETAK TIKET aktif, ikon printer | link / Cetak Tiket (case-insensitive); role perlu verifikasi DOM | nav-cetak-tiket |
| Judul Cetak E-Tiket | CETAK E-TIKET | heading / Cetak E-Tiket (case-insensitive) | cetak-e-tiket-title |
| Breadcrumb Cetak Tiket | Beranda / Cetak Tiket | navigation / Breadcrumb; item current Cetak Tiket | cetak-tiket-breadcrumb |
| Informasi masa cetak | Deskripsi selesai & sudah dikonfirmasi, H+3, alternatif Daftar Order | paragraph / teks deskripsi | cetak-tiket-description |
| Filter | Tombol hijau Filter | button / Filter | ticket-filter-toggle |
| Panel Filter | Tidak tampak; diturunkan dari spec | region / Filter Tiket (nama usulan) | ticket-filter-panel |
| ID Order | Text field dari spec; placeholder tidak terlihat | textbox / ID Order; label ID Order | ticket-filter-order-id |
| Rute | Dropdown dari spec; opsi tidak terlihat | combobox / Rute; label Rute | ticket-filter-route |
| Tanggal berangkat | DD/MM/YYYY hh:mm dari spec; picker tidak terlihat | textbox / Tanggal berangkat; label Tanggal berangkat | ticket-filter-departure |
| Nama Pembeli | Text field dari spec | textbox / Nama Pembeli; label Nama Pembeli | ticket-filter-buyer |
| Ukuran halaman | Menampilkan [10] Data | combobox / Menampilkan (label usulan) | ticket-page-size |
| Tabel e-tiket | Delapan kolom dan 9 baris | table / Daftar E-Tiket (nama usulan) | ticket-table |
| Kolom ID Order | Header ID Order | columnheader / ID Order | ticket-column-order-id |
| Kolom Nama Pembeli | Header Nama Pembeli | columnheader / Nama Pembeli | ticket-column-buyer |
| Kolom Rute | Header Rute | columnheader / Rute | ticket-column-route |
| Kolom Kapal | Header Kapal | columnheader / Kapal | ticket-column-ship |
| Kolom Berangkat | Header Berangkat | columnheader / Berangkat | ticket-column-departure |
| Kolom Jml Tiket | Header Jml Tiket | columnheader / Jml Tiket | ticket-column-count |
| Kolom Total (Rp) | Header Total (Rp) | columnheader / Total (Rp) | ticket-column-total |
| Kolom Aksi | Header Aksi | columnheader / Aksi | ticket-column-actions |
| Baris order | Identitas order di sel pertama | row / ID Order; scope berdasarkan teks sel ID Order secara exact, menghindari prefix yang mirip | ticket-row-<orderId> |
| Cetak Tiket [orderId] | Tombol biru bertuliskan Cetak | button / Cetak (exact), di dalam baris order | ticket-print-<orderId> |
| Download [orderId] | Tombol hijau ikon unduh tanpa teks | button / Download (accessible name usulan), di dalam baris order | ticket-download-<orderId> |
| Badge masa cetak | Masa cetak s/d H+3 pada O7786045, R7785985, W7546030 | generic / Masa cetak s/d H+3 di baris terkait | ticket-retention-badge-<orderId> |
| Ringkasan data | Menampilkan 1 sampai 9 dari 9 data | status / Ringkasan data (role/name usulan) | ticket-data-summary |
| Halaman 1 / 2 | Tombol 1 hijau; 2 diperlukan pada fixture >10 | button / 1 atau 2; halaman aktif via aria-current usulan | ticket-page-<n> |
| Empty / error / loading | Tidak terlihat; state turunan untuk robustness | status atau alert; nama/teks belum ditentukan | ticket-empty / ticket-error / ticket-loading |
| Dokumen print / PDF | Tidak terlihat; bukan elemen DOM yang diasumsikan | adapter print, popup, respons PDF, ekstraksi teks PDF | tidak berlaku |

Semua role/name/testid perlu dicocokkan dengan DOM aplikasi target. Placeholder, endpoint URL, opsi ukuran selain 10, dan tombol Terapkan/Reset tidak diasumsikan sebagai elemen desain. Mengosongkan field memakai field itu sendiri. Navigasi sidebar tidak memerlukan kunjungan ke Daftar Order.

Contoh baris fixture mengikuti desain: F7889561 / Karl Marx / Balikpapan (BPN) → Parepare (PAP) / KM. SWARNA BAHTERA / 10-10-2026 15:31 / 2 / Rp 528.000. K7889545 mempunyai pembeli Yudhistira IK, rute/kapal/waktu sama, 1 tiket, Rp 400.000. R7785985 memiliki 5 tiket, Rp 3.092.750. Status/channel/konfirmasi tidak tampak pada PNG; nilai tersebut ditetapkan sebagai fixture pengujian, bukan fakta desain.

Layout header akun, saldo, Top-Up, Keluar, dan menu sidebar lain merupakan konteks global; perilaku bisnisnya di luar RO313. Pengujian modul hanya menyentuh autentikasi sebagai precondition, tidak menambah requirement saldo/top-up.

## Assumptions Log

| ID | Asumsi / ketidakpastian | Dampak pada pengujian |
|---|---|---|
| A-01 | Tidak ada extras pada modul ini. | Hanya spec dan satu PNG menjadi sumber; tidak ada batas panjang, SLA, kontrak API, ataupun skema order tambahan. |
| A-02 | Sesi login dan otorisasi fitur/dokumen tersedia; nama role dan cakupan tenant belum dijelaskan. | Fixture menyediakan petugas berizin, petugas tanpa izin, sesi habis, dan order di luar cakupannya. Perlu konfirmasi aturan akses sebelum eksekusi kasus defensif. |
| A-03 | H+3 berarti 72 jam sejak timestamp keberangkatan, bukan akhir hari kalender ketiga. Tepat batas tetap tampil karena spec memakai kata melewati. Zona waktu pengujian Asia/Jakarta. | Bekukan jam aplikasi/browser/backend; tampil jika now ≤ departure + 72 jam, hilang jika now > departure + 72 jam. Konfirmasi definisi bisnis karena dapat mengubah boundary. |
| A-04 | ID memakai exact match, nama memakai substring case-insensitive; spasi luar diabaikan. Tanggal/waktu menyaring menit keberangkatan yang sama. | Data pembeda sengaja memakai prefix ID, nama berbeda kapital, dan waktu beda satu menit. Perlu konfirmasi semantik filter. |
| A-05 | Filter opsional, saling dipadukan AND, dan dapat dikosongkan untuk memulihkan daftar; cara menerapkan mengikuti desain. | REQ-012 adalah requirement turunan. Tidak menetapkan field wajib atau batas maksimum yang tidak ada di sumber. |
| A-06 | Dokumen print/PDF memuat semua tiket order, dengan order/pembeli/rute/kapal/waktu benar; nominal total PDF diasumsikan sesuai total order. Reprint/download tidak mengubah status order atau menambah order. | Tidak mengarang layout PDF, QR, nomor tiket, atau nama file. Pemeriksaan identitas, jumlah tiket, dan nominal bila ditampilkan. |
| A-07 | Kesalahan memberi pemberitahuan yang dapat dipahami; konten berbahaya diperlakukan sebagai data; halaman kosong/loading/error dapat dipulihkan. | Isi pesan exact dan desain state error belum ditentukan. Assertion menggunakan makna dan efek, bukan string pesan rekaan sebagai kontrak. |
| A-08 | Native print dialog dan PDF viewer/tab browser perlu adapter/harness Playwright. Rute halaman/endpoint dan data-testid belum diketahui. | Selector hanya saran; jangan mengklaim bisa mengotomatiskan dialog OS dengan locator DOM. Fixture/stub memeriksa print dipanggil dan payload, popup serta MIME PDF. |
| A-09 | Status, konfirmasi cabang, dan retensi diperiksa kembali sebelum print/download untuk menangani race; polling/event memperbarui baris ketika batas dilewati. | Interval auto-update belum ditentukan; gunakan event/clock terkendali, jangan menentukan SLA polling fiktif. Kasus race adalah asumsi defensif. |
| A-10 | Beban 10.000 order eligible, 1.000 perubahan filter, 100 sesi paralel, dan payload 10.000 karakter hanya profil uji awal. | Tidak menetapkan angka tersebut sebagai kapasitas/SLA bisnis. Pantau error, konsistensi, dan pemulihan; benchmark waktu membutuhkan SLA terpisah. |
| A-11 | Spec menyebut Cetak Tiket dan Download; desain memakai Cetak dan ikon download. Deskripsi desain menyebut semua order sudah dikonfirmasi, sedangkan spec mensyaratkan konfirmasi hanya untuk pembelian cabang. | Nama tombol mengikuti desain, semantik eligibility mengikuti spec. Ikon download memerlukan accessible name atau testid. Info desain bahwa tiket tetap bisa dicetak lewat Daftar Order dicatat saja; pengujian halaman Daftar Order di luar scope. |
| A-12 | Panel filter tidak terlihat di PNG. Tombol Filter diasumsikan toggle panel; keempat field berasal dari spec. Nilai filter diterapkan setelah perubahan field/debounce, tanpa mengarang tombol Terapkan. | Adapter codegen harus menyesuaikan trigger penerapan filter dan input tanggal dengan implementasi. Menutup/membuka panel diasumsikan mempertahankan nilai. |
| A-13 | Pagination turunan desain memakai ukuran 10, halaman 2 bila >10 hasil, total dihitung sesudah eligibility/filter, dan reset ke halaman 1 saat filter berubah. Urutan default belum diketahui. | Set hasil diperiksa tanpa mengunci sorting; fixture pagination memakai ordering deterministik yang disepakati adapter. Tidak mengasumsikan opsi ukuran 25/50/100. |
| A-14 | Badge Masa cetak s/d H+3 tampak pada tiga baris, tetapi ambang mulai muncul/warna per umur belum ditentukan. | Hanya uji badge pada fixture state yang diketahui mendukung badge dan konsistensi penghapusan baris setelah H+3. Jangan mengubah badge menjadi aturan eligibility atau menetapkan threshold umur baru. |
