# Analysis — ro314-penyesuain-registrasi-agen

## Requirements

### Sumber dan batas bukti

Sumber tunggal: `inputs/ro314-penyesuain-registrasi-agen/spec.txt`, enam baris tidak kosong. Tidak ada desain PNG atau extras. Nama modul mengikuti folder input, termasuk ejaan `penyesuain`.

Instruksi pengguna: analisis detail, **jangan berasumsi**. Ketidakjelasan dicatat sebagai gap; tidak diputuskan menjadi perilaku produk. Aturan AUTO MODE tentang mengambil asumsi tidak diterapkan ketika bertentangan dengan instruksi ini. Pipeline tetap diselesaikan dengan batas bukti yang dinyatakan.

| ID | Requirement terkonfirmasi | Sumber | Kriteria penerimaan yang dapat diturunkan langsung |
|---|---|---|---|
| REQ-001 | Kantor Cabang tidak lagi melihat atau mengisi field Jaminan Agen pada tambah/registrasi agen. | Baris 1–2 | Form Tambah Agen tidak menyediakan input Jaminan Agen. Proses registrasi tidak meminta nominal jaminan; ketiadaan nominal tidak boleh menjadi penyebab kegagalan registrasi. Keberhasilan keseluruhan tetap bergantung pada data dan ketentuan registrasi lainnya yang belum disediakan. |
| REQ-002 | Kantor Cabang tidak lagi melihat informasi Jaminan Agen pada Detail Agen. | Baris 3 | Label/informasi jaminan dan nominal/data jaminan tidak ditampilkan pada halaman tersebut, termasuk apabila fixture lama masih memiliki data jaminan. |
| REQ-003 | Kantor Cabang tidak lagi melihat field Jaminan Agen atau menambahkan/mengubahnya melalui Edit Agen. | Baris 4 | Tidak tersedia kontrol untuk mengisi, menambahkan, atau mengubah jaminan di halaman Edit Agen. Operasi edit melalui form tidak meminta nominal jaminan. Ini tidak mendefinisikan perilaku API terhadap payload lama. |
| REQ-004 | Agen tidak lagi melihat informasi/nominal Jaminan Agen pada Akun Saya. | Baris 5 | Informasi jaminan tidak ditampilkan pada Akun Saya, termasuk apabila fixture lama masih memiliki data jaminan. |
| REQ-005 | Penghapusan terbatas pada informasi/proses jaminan; Deposit Agen tetap berjalan sesuai ketentuan yang sudah ada. | Baris 6 | Alur deposit yang terbukti valid pada baseline tetap valid; alur yang terbukti ditolak pada baseline tetap mengikuti ketentuan baseline. Detail alur, aktor, layar, validasi, nominal, serta hasil baseline belum tersedia sehingga oracle deposit belum dapat diisi. |

### Aktor dan akses

| Aktor eksplisit | Alur yang disebut | Hal yang belum ditetapkan |
|---|---|---|
| User Kantor Cabang | Relasi Agen → Tambah Agen, Detail Agen, Edit Agen | Login, URL, akses lintas cabang, akses ke agen milik cabang lain, privilege tambahan. |
| User Agen | Akun Saya | Login, URL, ketentuan akses akun lain. |
| Aktor Deposit Agen | Tidak disebut | Tidak boleh disamakan otomatis dengan Kantor Cabang atau Agen. Gunakan aktor yang dibuktikan oleh baseline deposit. |

Daftar aktor bukan matriks izin lengkap. Tidak ada bukti untuk membuat skenario 403, redirect login, atau pelarangan role lain.

### Validasi dan data

| Area | Diketahui | Tidak diketahui / konsekuensi |
|---|---|---|
| Jaminan Agen saat tambah | Input nominal dihapus dan tidak diperlukan. | Tidak ada batas nominal, format mata uang, panjang, wajib/opsional sebelumnya, atau pesan validasi lama yang dapat dianggap benar. |
| Jaminan Agen saat edit | Tidak dapat ditambahkan/diubah melalui halaman edit. | Tidak diketahui apakah data lama dihapus, tetap tersimpan, dimigrasikan, atau diteruskan oleh backend. UI yang hilang tidak membuktikan mutasi database. |
| Field registrasi/edit lain | Tidak dirinci. | Tidak boleh mengarang nama field, daftar field wajib, tombol simpan, toast sukses, atau redirect. Dataset valid dan operasi simpan harus merujuk bukti aplikasi/baseline. |
| Deposit Agen | Ketentuan berjalan dipertahankan. | Tidak ada nilai minimum/maksimum, saldo awal, biaya, top-up, transfer, pencairan, atau pesan penolakan yang terdefinisi. |
| Data historis | Perubahan melarang tampilan jaminan pada halaman yang disebut. | Keberadaan record historis tertentu harus diverifikasi. Nilai nonnol, nol, atau kosong hanya variasi fixture uji apabila tersedia/sah pada baseline; bukan pernyataan bahwa semua nilai itu dapat dibuat lewat form saat ini. |

### Alur dan percabangan yang bisa diuji

1. Kantor Cabang membuka Relasi Agen → Tambah Agen: periksa penghapusan field. Untuk uji submit, gunakan data yang sudah terbukti valid untuk field lain dan lakukan operasi registrasi yang memang tersedia. Tidak mengisi jaminan; hasil tidak boleh gagal karena jaminan tidak diisi.
2. Kantor Cabang membuka Detail Agen: periksa label/informasi dan nilai jaminan. Pisahkan agen biasa dari fixture historis berjaminan; label yang hilang saja belum membuktikan nominal ikut hilang.
3. Kantor Cabang membuka Edit Agen: periksa seluruh kontrol terkait jaminan. Fixture historis tidak boleh membuat field lama muncul kembali. Uji simpan perubahan field lain hanya jika field, data valid, dan operasi simpan telah dibuktikan.
4. Agen membuka Akun Saya: periksa informasi dan nominal jaminan milik akun fixture tersebut. Tidak menguji akun lain tanpa aturan otorisasi.
5. Jalankan kasus deposit valid dan invalid yang sudah punya hasil baseline. Bandingkan hasil terhadap baseline, tanpa menciptakan mekanisme deposit atau nilai expected baru.

Pengamatan dilakukan setelah halaman selesai menampilkan data menurut indikator yang benar-benar ada. Indikator loading, waktu tunggu, rute navigasi, serta tombol masuk ke tiap halaman belum diketahui.

### Interpretasi kalimat verifikasi legal

Baris 1 menyebut “Uang jaminan diganti verifikasi legal (field di remove aja)”. Empat rincian halaman berikutnya hanya meminta penghapusan jaminan. Spesifikasi tidak menyebut form legal, dokumen wajib, approval, status verifikasi, role pemeriksa, atau gating registrasi.

Tidak dibuat requirement atau expected result verifikasi legal baru. Penghapusan jaminan tetap dapat diuji. Apakah verifikasi legal merupakan perubahan fungsional tersendiri perlu jawaban pemilik kebutuhan.

### Gap dan pertanyaan untuk pemilik kebutuhan

Pertanyaan berikut tidak menghentikan pembuatan artefak. Jawaban dibutuhkan untuk memperluas cakupan atau menjalankan otomatisasi terkait.

| Gap | Pertanyaan konkret | Dampak |
|---|---|---|
| GAP-01 | Apakah verifikasi legal hanya alasan penghapusan field atau ada workflow baru? Jika baru, apa field, dokumen, aktor, status, dan kriteria lolosnya? | Verifikasi legal belum tercakup karena requirement belum terdefinisi. |
| GAP-02 | Apa URL/rute dan struktur DOM empat halaman, serta cara membuka Detail/Edit Agen? | Semua skenario UI memerlukan pemetaan implementasi sebelum menjadi skrip Playwright. |
| GAP-03 | Apa field registrasi lain, dataset valid, operasi submit, dan bukti registrasi berhasil? | Uji registrasi tanpa jaminan belum dapat dieksekusi deterministik. |
| GAP-04 | Field edit lain apa yang dapat diubah, dengan data valid apa, dan bagaimana hasil simpan diverifikasi? | Uji simpan edit tanpa jaminan bergantung baseline. |
| GAP-05 | Adakah akun/agen lama dengan jaminan nonnol, nol, dan kosong yang sah? Bagaimana menghubungkan user Agen dengan recordnya? | Uji data lama/boundary menunggu fixture; tidak membuat record jaminan lewat form baru. |
| GAP-06 | Apa tampilan atau selector lama untuk label, kontrol, dan nilai jaminan? | Harus membuktikan field dan nominal benar-benar hilang; jangan hanya mengecek satu teks atau satu tipe input. |
| GAP-07 | Apa baseline Deposit Agen: aktor, layar, alur, ketentuan valid/invalid, data, dan hasil? | Dua skenario regresi deposit belum memiliki oracle konkret. |
| GAP-08 | Apa kebijakan data jaminan lama: retensi, migrasi, penghapusan, dan akses API? | Tidak ada assertion database, migrasi, atau respons API terhadap payload jaminan. |
| GAP-09 | Apakah cakupan juga termasuk daftar, ekspor, laporan, aplikasi lain, atau endpoint di luar empat halaman? | Tidak memperluas penghapusan ke permukaan yang tidak disebut. |
| GAP-10 | Adakah aturan otorisasi lintas role/cabang/akun yang relevan? | Tidak membuat hak akses atau hasil penolakan baru. |
| GAP-11 | Adakah target concurrency, volume, durasi, atau waktu respons, berikut baseline performanya? | Tidak membuat stress test dengan ambang lulus atau kemampuan paralel karangan. |
| GAP-12 | Apa indikator halaman selesai memuat data dan bukti hasil operasi? | Pemeriksaan absensi sebelum data selesai dimuat dapat menghasilkan lulus palsu. |

### Batas oracle dan fixture

- Fixture historis nonnol harus punya nilai yang dikenali di baseline sebagai Jaminan Agen. Jangan menguji hilangnya angka secara global: nominal yang sama mungkin sah sebagai deposit atau field lain. Periksa keterkaitannya sebagai informasi jaminan pada halaman bersangkutan.
- Fixture nol menguji kasus angka falsy; fixture kosong menguji sisa label/placeholder. Keduanya tidak mengandaikan rentang nominal jaminan yang sah pada aplikasi baru. Jika baseline tidak mendukung fixture, tandai kasus tidak dapat dijalankan; jangan mengubah skema atau requirement untuk memaksakannya.
- Tidak boleh menganggap field tersembunyi berarti data database sudah dihapus. Requirement yang terkonfirmasi membatasi tampilan dan pengisian melalui UI.
- Uji simpan/registrasi tidak menebak pesan sukses atau kegagalan. Pakai hasil baseline yang dapat dibuktikan. Ketika baseline belum tersedia, scenario merupakan spesifikasi uji bersyarat, bukan hasil pengujian aplikasi.

## UI Inventory

Inventaris ini berasal dari teks, bukan observasi desain/aplikasi. Semua halaman dan elemen di bawah adalah target pemeriksaan, bukan bukti bahwa elemen masih ada pada implementasi sesudah perubahan.

### Tambah Agen

| Elemen | Bukti | State yang diwajibkan | Selector |
|---|---|---|---|
| Field Jaminan Agen | Spec baris 2 | Tidak ditampilkan dan tidak tersedia untuk input nominal. | Label yang disebut spec: `Jaminan Agen`. `role`, ARIA `name`, `testid`, selector kontrol: belum diketahui. |
| Operasi registrasi | Spec menyebut proses tambah/registrasi | Tidak mensyaratkan nominal jaminan. | Nama tombol, kontrol, field lain, URL, dan penanda berhasil: belum diketahui. |

### Detail Agen

| Elemen | Bukti | State yang diwajibkan | Selector |
|---|---|---|---|
| Informasi Jaminan Agen | Spec baris 3 | Label, nominal, dan data terkait jaminan tidak ditampilkan. | Label teks sumber: `Jaminan Agen`; locator informasi/nilai perlu baseline atau DOM. Role/name/testid belum diketahui. |

### Edit Agen

| Elemen | Bukti | State yang diwajibkan | Selector |
|---|---|---|---|
| Field Jaminan Agen | Spec baris 4 | Tidak ditampilkan; tidak tersedia untuk menambahkan atau mengubah data jaminan. | Label teks sumber: `Jaminan Agen`; tipe input, role/name/testid belum diketahui. |
| Operasi edit | Spec menyebut halaman/proses edit | Edit melalui form tidak membutuhkan input jaminan. | Field lain yang dapat diedit dan kontrol simpan perlu baseline; tidak memberi nama tombol usulan. |

### Akun Saya

| Elemen | Bukti | State yang diwajibkan | Selector |
|---|---|---|---|
| Informasi Jaminan Agen | Spec baris 5 | Informasi/nominal jaminan tidak ditampilkan kepada user Agen. | Label teks sumber: `Jaminan Agen`; locator informasi/nilai perlu baseline atau DOM. Role/name/testid belum diketahui. |

### Deposit Agen — konteks pengujian, bukan nama layar terkonfirmasi

Spec baris 6 menyebut mekanisme Deposit Agen, tanpa menyebut halamannya. Metadata memakai `screen: deposit-agen` dan tag `@screen-deposit-agen` hanya sebagai pengenal konteks. Ganti pemetaan ke layar/URL sebenarnya setelah baseline tersedia. Tidak ada inventaris field, tombol, label deposit, atau state error yang bisa diambil dari bukti sekarang.

### Keamanan pemetaan otomatisasi

- `selectorHints` menggunakan `role: null`, `name: null`, `testid: null`. `labelText` hanya menyimpan teks yang memang disebut spec. Nilai null berarti belum diketahui, bukan wildcard selector.
- Tidak membuat usulan `data-testid` untuk elemen yang seharusnya dihapus. Selector lama yang dapat dibuktikan tetap berguna untuk pengujian absensi, termasuk nilai tanpa label.
- Absensi memerlukan pemeriksaan kontrol dan informasi jaminan setelah halaman selesai memuat data. Teks “Jaminan Agen” yang tidak terlihat saja belum cukup bila nilai atau inputnya masih muncul tanpa label.
- Spec tidak menetapkan apakah penghapusan berarti node DOM dihapus atau sekadar tidak tersedia/terlihat oleh user. Jangan menetapkan `count = 0` sebagai satu-satunya oracle tanpa bukti tambahan; verifikasi larangan tampilan dan penggunaan kontrol menurut kontrak UI.
- Langkah `expect` untuk elemen yang dihapus harus diterjemahkan sebagai assertion **absent**, bukan mapping default `toBeVisible()`. Ini memerlukan dukungan codegen yang memahami metadata assertion.

## Assumptions Log

**Asumsi perilaku produk yang dibuat: tidak ada.** Bagian ini tetap ada untuk kompatibilitas workflow; isinya adalah batas bukti dan keputusan penyajian.

| ID | Catatan | Perlakuan |
|---|---|---|
| EVID-01 | Folder `designs/` kosong. | Inventaris hanya boleh memakai nama halaman dan Jaminan Agen dari spec; tipe kontrol, layout, URL, ARIA name, testid, dan tombol tidak diketahui. |
| EVID-02 | Folder `extras/` kosong. | Tidak ada bukti tambahan atau baseline deposit. |
| EVID-03 | Pengguna melarang asumsi. | Gap dipertahankan; tidak mengambil opsi perilaku produk yang dianggap paling masuk akal. |
| EVID-04 | Nama layar, ID REQ, dan ID skenario dipakai sebagai pengenal artefak. | Normalisasi untuk metadata, bukan URL, selector, atau nama baru pada UI. |
| EVID-05 | Skenario historis/valid/invalid baseline memerlukan fixture dan oracle eksternal yang belum tersedia. | Ditandai dependency secara eksplisit; tidak dianggap executable atau terbukti lulus. |
| EVID-06 | Spec tidak menyediakan kontrak stress/performance. | Kategori stress berjumlah nol; dicatat sebagai gap, tanpa menciptakan SLA atau load profile. |
