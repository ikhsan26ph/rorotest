# Analysis — ro318-perubahan-warna-dokumen-roro

## Requirements

### Sumber dan batas analisis

Sumber tunggal: `inputs/ro318-perubahan-warna-dokumen-roro/spec.txt`, 5 baris isi. Folder `designs/` dan `extras/` kosong. Analisis ini mengikuti instruksi pengguna **jangan berasumsi**: informasi yang tidak tercantum menjadi gap, bukan requirement atau perilaku yang ditebak. Ketentuan AUTO MODE tentang memilih asumsi tidak diterapkan pada informasi yang belum diketahui dalam run ini karena instruksi pengguna lebih spesifik.

| Referensi | Bukti dari spesifikasi | Implikasi yang dapat diuji |
|---|---|---|
| S1, baris 1 | Identitas simbolis kapal RORO adalah Biru (Biru Logo JN); dokumen yang disebut ialah E Tiket, Kwitansi, dan Boarding pass. | Ketiga dokumen termasuk cakupan. Baris ini tidak menetapkan kode warna numerik untuk seluruh dokumen. |
| S2, baris 2 | Tampilan/cetakan E-Tiket diubah dari Hijau menjadi Biru. | Perubahan warna identitas harus diperiksa pada tampilan dan cetakan E-Tiket. |
| S3, baris 3 | Tampilan/cetakan Kwitansi diubah dari Hijau menjadi Biru, dengan kode `#002564`. | Target Kwitansi memiliki kode pasti: RGB sRGB `(0, 37, 100)` jika kanal tersebut merepresentasikan warna sebagai sRGB. Representasi warna cetakan belum diketahui. |
| S4, baris 4 | Tampilan/cetakan Boarding Pass diubah dari Hijau menjadi Biru. | Perubahan warna identitas harus diperiksa pada tampilan dan cetakan Boarding Pass. |
| S5, baris 5 | Perubahan hanya pada elemen warna identitas; informasi, format, dan data tidak berubah. | Elemen di luar cakupan warna identitas, informasi, format, dan data memerlukan pemeriksaan regresi. |

### Daftar requirement

| ID | Requirement | Sumber | Acceptance criteria yang diturunkan langsung | Kepastian |
|---|---|---|---|---|
| REQ-001 | Warna identitas E-Tiket berubah dari hijau menjadi biru pada tampilan dan cetakan. | S1, S2, S5 | Elemen identitas yang terkonfirmasi menggunakan biru; tidak ada elemen target yang tertinggal dalam warna hijau identitas lama. | Warna umum eksplisit; kode biru dan elemen target belum tersedia. |
| REQ-002 | Warna identitas Kwitansi berubah dari hijau menjadi biru `#002564` pada tampilan dan cetakan. | S1, S3, S5 | Semua elemen identitas yang terkonfirmasi memakai target warna tersebut; tidak ada warna hijau identitas lama tersisa di elemen target. | Kode warna eksplisit; elemen target dan pembuktian kode pada cetakan belum tersedia. |
| REQ-003 | Warna identitas Boarding Pass berubah dari hijau menjadi biru pada tampilan dan cetakan. | S1, S4, S5 | Elemen identitas yang terkonfirmasi menggunakan biru; tidak ada elemen target yang tertinggal dalam warna hijau identitas lama. | Warna umum eksplisit; kode biru dan elemen target belum tersedia. |
| REQ-004 | Perubahan warna dibatasi pada elemen yang menggunakan warna identitas. | S5 | Warna elemen di luar daftar target tidak berubah terhadap baseline dokumen yang sama. | Aturan eksplisit; daftar elemen identitas dan di luar identitas belum tersedia. |
| REQ-005 | Informasi pada ketiga dokumen tetap. | S5 | Informasi yang benar-benar ada pada baseline tetap tersedia; tidak ada informasi hilang, bertambah, atau berganti. | Aturan eksplisit; struktur informasi belum diberikan. |
| REQ-006 | Format ketiga dokumen tetap. | S5 | Format sebelum/sesudah sesuai baseline dan definisi pembandingan yang disepakati, dengan pengecualian perubahan warna identitas yang diwajibkan. | Aturan eksplisit; arti rinci format dan toleransi perbandingan belum diberikan. |
| REQ-007 | Data pada ketiga dokumen tetap. | S5 | Nilai data pada dokumen dan data sumber yang sama tetap identik sebelum/sesudah perubahan warna. | Aturan eksplisit; field, fixture, dan cara mencocokkan data belum diberikan. |

REQ-004 sampai REQ-007 memecah batas perubahan dalam S5 agar setiap aspek dapat ditelusuri. Pemecahan ini tidak menambahkan field, konten, atau aturan bisnis baru.

### Aturan validasi dan pembandingan

| Aspek | Fakta | Batas pembuktian |
|---|---|---|
| Kode warna Kwitansi | `#002564` eksplisit. | Pemeriksaan CSS dapat memakai representasi numerik ekuivalen jika implementasi menggunakan CSS; teknologi implementasi belum diketahui. Jangan menggunakan estimasi warna dari screenshot sebagai bukti kode sumber pasti. |
| Kode warna E-Tiket dan Boarding Pass | Hanya disebut biru dan konteks Biru Logo JN. | Jangan menyamakan kode kedua dokumen dengan Kwitansi. Diperlukan referensi warna yang disahkan. |
| Warna hijau sebelumnya | Disebut hijau, tanpa kode. | Gunakan baseline warna identitas lama; jangan mengarang kode hex hijau. |
| Elemen target | Elemen yang memakai warna identitas. | Semua elemen hijau tidak otomatis merupakan elemen identitas; daftar target perlu dikonfirmasi. |
| Elemen di luar target | Tidak boleh ikut berubah warna. | Dibandingkan dengan baseline pada dokumen dan kanal yang sama. Tidak diasumsikan bahwa elemen tersebut memiliki warna tertentu. |
| Informasi, format, data | Tidak berubah. | Baseline sebelum perubahan diperlukan. Pembandingan dengan transaksi berbeda tidak membuktikan regresi ini. |
| Field wajib, tipe, panjang, rentang, input invalid | Tidak ada dalam spesifikasi. | Tidak dibuat aturan validasi atau skenario input fiktif. |
| Cetakan | Perubahan disebut pada cetakan. | Media, renderer, file hasil, printer, profil warna, dan toleransi tidak dijelaskan; tidak diasumsikan PDF atau kertas tertentu. |

### Aktor, hak akses, dan alur

- Spesifikasi tidak menyebut aktor, role, autentikasi, atau izin. Tidak dibuat akun, peran, atau aturan akses.
- Keluaran yang dinyatakan hanya tampilan dan cetakan tiga jenis dokumen. Nama menu, URL, tombol, serta cara membuka atau mencetak belum tersedia.
- Alur bisnis tidak dijabarkan. Alur verifikasi adalah memperoleh dokumen dari sistem dengan mekanisme yang benar-benar tersedia, memeriksa warna, lalu membandingkan aspek yang harus tetap terhadap baseline dokumen yang sama.
- Tidak ada ketentuan untuk dokumen non-RORO, dokumen historis, perubahan data sumber, cache, reprint, ekspor, atau template lain. Tidak ditetapkan expected result bagi kondisi tersebut.

### Matriks cakupan dasar

| Dokumen | Tampilan | Cetakan | Warna identitas target | Aspek tetap |
|---|---|---|---|---|
| E-Tiket | Disebut S2 | Disebut S2 | Biru; kode belum diketahui | Warna di luar target, informasi, format, data |
| Kwitansi | Disebut S3 | Disebut S3 | `#002564` | Warna di luar target, informasi, format, data |
| Boarding Pass | Disebut S4 | Disebut S4 | Biru; kode belum diketahui | Warna di luar target, informasi, format, data |

Tampilan dan cetakan perlu diperiksa masing-masing. Keberhasilan pada tampilan saja tidak membuktikan keluaran cetakan.

### Gap dan pertanyaan klarifikasi

Pertanyaan berikut dicatat untuk melengkapi pengujian, bukan dijawab dengan tebakan dan bukan menghentikan pembuatan artefak.

| Gap | Informasi yang dibutuhkan | Dampak |
|---|---|---|
| GAP-001 | Kode atau referensi biru yang disahkan untuk E-Tiket dan Boarding Pass; apakah memang sama dengan `#002564`? | Oracle warna biru dua dokumen belum pasti. |
| GAP-002 | Daftar elemen warna identitas dan daftar elemen di luar target untuk setiap dokumen/kanal. | Tidak dapat menentukan locator, mask visual, atau membuktikan seluruh target telah berubah. |
| GAP-003 | Baseline sebelum perubahan untuk dokumen yang sama, beserta data sumber tetap. | Warna hijau lama, informasi, format, dan data tidak dapat dibandingkan secara valid. |
| GAP-004 | Implementasi keluaran cetakan dan metode verifikasi warna; apakah berupa artefak digital atau hasil fisik? | Pembuktian `#002564` pada cetakan belum dapat diotomasi. Tidak ditetapkan toleransi warna. |
| GAP-005 | Cara mengakses tiap tampilan/cetakan, lingkungan aplikasi, dan locator aktual. | Langkah navigasi dan selector Playwright belum dapat diikat ke implementasi. |
| GAP-006 | Definisi format dan aturan pembandingannya, termasuk apakah ada bagian dinamis yang sah. | Tidak ditentukan ukuran, font, layout, pagination, maupun pengecualian pembandingan yang tidak disebut sumber. |
| GAP-007 | Kriteria dan batas stress, fixture edge, serta dukungan variasi dokumen. | Tidak ada dasar menetapkan volume, timeout, kondisi langka, atau expected result kategori tersebut. |
| GAP-008 | Identifikasi dokumen RORO serta aturan cakupan terhadap dokumen historis/non-RORO atau template lain. | Tidak dibuat skenario cakupan luar dengan perilaku yang belum disepakati. |
| GAP-009 | Inventaris informasi dan pemetaan nilai data yang benar-benar ada pada ketiga dokumen. | Tidak dapat menamai field atau membuat assertion data spesifik. |

## UI Inventory

### Batas inventaris

Tidak ada PNG desain. Nama di bawah adalah label objek uji yang disebut spesifikasi, bukan nama layar/menu yang telah diverifikasi. Kanal tampilan dan cetakan dicatat terpisah; tidak diasumsikan bahwa keduanya memiliki DOM, renderer, atau template yang sama.

| Label logis / tag layar | Kanal yang diketahui | Elemen yang boleh diinventarisasi | Selector |
|---|---|---|---|
| E-Tiket / `@screen-e-tiket` | Tampilan dan cetakan | Elemen warna identitas; elemen di luar target; informasi, format, dan data sesuai baseline E-Tiket. Daftar aktual belum tersedia. | `role`, accessible name, label, dan `data-testid` belum diketahui. |
| Kwitansi / `@screen-kwitansi` | Tampilan dan cetakan | Elemen warna identitas dengan target `#002564`; elemen di luar target; informasi, format, dan data sesuai baseline Kwitansi. Daftar aktual belum tersedia. | `role`, accessible name, label, dan `data-testid` belum diketahui. |
| Boarding Pass / `@screen-boarding-pass` | Tampilan dan cetakan | Elemen warna identitas; elemen di luar target; informasi, format, dan data sesuai baseline Boarding Pass. Daftar aktual belum tersedia. | `role`, accessible name, label, dan `data-testid` belum diketahui. |

### Detail yang tidak tersedia

Tidak dapat memastikan header, logo, border, background, teks tertentu, QR/barcode, tabel, tombol cetak, input, dropdown, navigasi, atau state loading/error/success. Tidak ada pesan validasi yang diberikan. Elemen-elemen tersebut tidak ditambahkan ke inventaris atau test case sebagai fakta.

`selectorHints` di JSON tetap `{}` karena tidak ada selector yang terverifikasi. Field `screen`, target langkah, dan label dokumen hanya menjadi referensi semantik. Langkah `navigate` berarti mengakses/verifikasi keluaran melalui mekanisme aktual yang belum diberikan; bukan URL atau tombol rekaan. Langkah `expect` memuat kontrak pemeriksaan warna/regresi dan memerlukan implementasi assertion yang sesuai; `toBeVisible()` saja tidak membuktikan warna, kesetaraan data, atau format.

### Prasyarat penerjemahan ke Playwright

1. Dapatkan akses lingkungan, mekanisme membuka dokumen dan memperoleh cetakan, serta locator aktual (GAP-005).
2. Tetapkan pemetaan elemen identitas dan di luar target per dokumen/kanal (GAP-002).
3. Siapkan baseline dan dokumen sesudah perubahan dengan data sumber yang sama (GAP-003), beserta inventaris informasi/pemetaan data jika assertion memerlukannya (GAP-009).
4. Lengkapi referensi biru dua dokumen (GAP-001), pembuktian warna cetakan (GAP-004), dan definisi pembandingan format (GAP-006).

Semua ini adalah dependensi yang belum dipenuhi. Keberadaan skenario tidak berarti aplikasi telah diuji, selector telah ditemukan, atau kode Playwright siap dijalankan.

## Assumptions Log

**Tidak ada asumsi perilaku sistem yang diambil.**

| Catatan | Status | Penanganan |
|---|---|---|
| Tidak tersedia desain atau extras. | Fakta dari direktori input | UI Inventory hanya mencatat tiga dokumen dan dua kanal yang disebut sumber; tidak mengarang widget. |
| Spesifikasi pendek dan sejumlah oracle belum lengkap. | Fakta dari S1–S5 | Kekurangan dicatat sebagai GAP-001–GAP-009. |
| Pengguna melarang asumsi. | Instruksi run | Tidak memakai nilai default, role, URL, field, selector, atau batas beban yang ditebak. |
| Nama layar/tag adalah label analisis untuk dokumen. | Konvensi artefak | Label tersebut tidak mengklaim adanya halaman aplikasi terpisah. |
| Baseline dan pemetaan elemen belum tersedia. | Prasyarat pengujian, bukan fakta implementasi | Skenario ditandai terblokir untuk otomasi sampai dependensi terkait tersedia. |
