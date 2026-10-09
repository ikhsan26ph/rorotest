# Analysis — ro316-penyesuaian-setting-komisi-agen

## Requirements

Sumber utama: `inputs/ro316-penyesuaian-setting-komisi-agen/spec.txt`. Sumber pendukung: `extras/desain-ro-1-5-4-master-komisi-agen.html` (template JSON terdekode dan logika komponen, dibaca sebagai teks).

| ID | Requirement / acceptance criteria | Sumber |
|---|---|---|
| REQ-001 | Menu Master > Master Komisi Agen dapat diakses Pusat dan Cabang; pengguna tanpa sesi tidak dapat mengakses data. | General Rules 1–3; Cabang 1 |
| REQ-002 | Daftar menampilkan seluruh rute sistem, termasuk arah balik dan rute tanpa konfigurasi. | General Rules 6; Master 1 |
| REQ-003 | Status Belum Disetting, Aktif, Tidak Aktif sesuai konfigurasi dan aktivasi komisi rute. | Master 2–5 |
| REQ-004 | Komisi general mengikuti rute yang boleh dijual agen; tidak dibedakan per agen atau cabang. | General Rules 4–7; Setting 9 |
| REQ-005 | Pusat menambah konfigurasi dengan rute, jenis, golongan, kelas/kondisi yang relevan, dan persentase wajib. | Master 6; Setting 1; asumsi A03 |
| REQ-006 | Jenis Tiket berasal dari master jenis tiket sistem. | Setting 2 |
| REQ-007 | Golongan Tiket bergantung pada Jenis Tiket; pilihan lama yang tidak sesuai harus direset/ditolak. | Setting 3 |
| REQ-008 | Kelas/Kondisi mengikuti master jenis tiket; Kendaraan wajib memilih kondisi, Penumpang menggunakan null sesuai prototipe. | Setting 4; asumsi A04 |
| REQ-009 | Persentase wajib numerik, nonnegatif, maksimal dua desimal; koma/titik desimal diterima. | Setting 5; extras parsePct; asumsi A03 |
| REQ-010 | Persentase Komisi tidak boleh lebih dari 100%; batas 100% diterima. | Setting 6 |
| REQ-011 | Kunci Rute + Jenis + Golongan + Kelas/Kondisi unik; duplikat ditolak dan diarahkan ke edit existing. | Setting 7–8 |
| REQ-012 | Konfigurasi tersimpan berlaku bagi seluruh agen yang menjual kombinasi terkait dan transaksi baru sesudah simpan. | General Rules 8; Setting 9 |
| REQ-013 | Hanya Pusat dapat mengedit persentase konfigurasi existing. | Edit 1–2 |
| REQ-014 | Edit tidak boleh menghasilkan duplikat kombinasi dan tidak menganggap record sendiri duplikat. | Edit 3 |
| REQ-015 | Edit berlaku setelah simpan untuk transaksi baru; snapshot komisi transaksi sebelumnya tetap. | Edit 4–5 |
| REQ-016 | Hanya Pusat menghapus konfigurasi terpilih; kombinasi lain tetap tersimpan. | Hapus 1–2 |
| REQ-017 | Kombinasi terhapus menjadi belum disetting; bukan record tersimpan dengan nilai 0%. | Hapus 3 |
| REQ-018 | Penghapusan konfigurasi tidak mengubah komisi transaksi historis. | Hapus 4 |
| REQ-019 | Hanya Pusat menonaktifkan komisi rute; status rute terpilih menjadi Tidak Aktif. | Nonaktifkan 1–3; Cabang 4 |
| REQ-020 | Rute nonaktif tidak menggunakan setting untuk transaksi baru, setara belum disetting; konfigurasi tidak dihapus. | Nonaktifkan 4–6 |
| REQ-021 | Hanya Pusat mengaktifkan kembali rute; konfigurasi existing berlaku lagi untuk transaksi baru. | Nonaktifkan 7–8; Cabang 4 |
| REQ-022 | Cabang melihat konfigurasi Pusat secara read-only tanpa Tambah/Edit/Hapus/Nonaktif/Aktif. | Master 7; Cabang 2–4 |
| REQ-023 | Perubahan Pusat menjadi data yang berlaku dan terlihat di seluruh Cabang. | Cabang 5 |
| REQ-024 | Relasi Agen/Detail Agen tidak lagi memiliki section, list, tombol, action atau tabel Komisi Agen. | Relasi Agen 1–3 |
| REQ-025 | Nilai komisi per agen tidak dapat disimpan lagi dan data legacy per agen tidak menjadi sumber komisi. | Relasi Agen 4–5 |
| REQ-026 | Filter daftar rute/detail komisi, rentang tanggal/persen, empty state dan navigasi daftar bekerja konsisten. | Extras template; pelengkap UI, asumsi A08 |
| REQ-027 | Modal tambah/edit/hapus/nonaktif/aktif mendukung konfirmasi, pembatalan, informasi dampak dan feedback. | Extras template; pelengkap UI, asumsi A05/A08 |
| REQ-028 | Estimasi komisi dan konfirmasi 0% mengikuti nilai valid; 0% tersimpan berbeda dari belum disetting. | Extras TARIF, parsePct, mZero; pelengkap UI, asumsi A03/A09 |

### Aktor dan hak akses

| Aktor | Melihat | Mutasi |
|---|---|---|
| Kantor Pusat | Daftar rute dan detail komisi | Tambah, edit, hapus, nonaktif, aktif |
| Kantor Cabang | Data Pusat pada menu Master Komisi Agen | Seluruh mutasi dilarang, termasuk probe server |
| Agen | Transaksi rute/jenis yang berhak dijual | Tidak ada pengaturan komisi per agen |
| Tanpa sesi | Tidak dapat mengakses data | Ditolak |

### Aturan validasi

| Data | Validasi | Dasar |
|---|---|---|
| Rute | Rute sistem terpilih, arah diperhitungkan; read-only pada modal | Spec + HTML |
| Jenis Tiket | Wajib; anggota master jenis | Spec + A03 |
| Golongan Tiket | Wajib; anggota golongan jenis terpilih; reset saat jenis berubah | Spec + HTML |
| Kelas/Kondisi | Kondisi wajib untuk Kendaraan; null untuk Penumpang | A04 |
| % Komisi | Wajib; numerik 0–100 inklusif, <=2 desimal, koma/titik | Spec maksimum; lainnya A03 |
| Kombinasi | Unik tanpa persentase, agen, cabang atau trayek sebagai pembeda | Spec |
| Alasan Nonaktif | Wajib sesudah trim; panjang maks tidak ditentukan | A05 |
| Filter | Rentang inklusif; tanggal null tidak cocok range tanggal; rentang terbalik tidak memberi hasil salah | HTML + A08 |

### Alur dan oracle temporal

Pusat → Master → semua rute → Setting Komisi Rute → Tambah/Edit → validasi → Simpan → transaksi baru memakai konfigurasi committed. Duplikat → Edit baris yang ada. Hapus hanya kombinasi terpilih. Nonaktif menyimpan konfigurasi dan menonaktifkan penggunaannya. Aktif mengembalikan penggunaan existing. Cabang → menu yang sama → Komisi Rute read-only → refresh melihat hasil commit Pusat.

Fixture temporal: T0 terbentuk pada 5%, commit edit pada T1 menjadi 7,50%, T2 terbentuk sesudah commit; basis contoh Rp1000000, komisi T0 Rp50000 dan T2 Rp75000. Untuk tambah/hapus/nonaktif/aktif, rekam snapshot sebelum/sesudah dan bandingkan transaksi historis. Semua setup dilakukan fixture terisolasi, bukan perubahan inputs/.

## UI Inventory

Inventaris statis; tidak ada PNG atau hasil render visual. Scope selector: panel Filter, dialog aktif, atau row berkunci kombinasi. Name tanpa bintang wajib dicocokkan ke accessible name aktual. Seluruh testid hanya usulan.

### master-komisi-agen

| Elemen / label | Role | data-testid usulan | Dasar / state |
|---|---|---|---|
| Filter | button | `ro316-master-komisi-agen-filter` | HTML; role/name/testid usulan |
| Daftar Rute | table | `ro316-master-komisi-agen-table` | HTML; role/name/testid usulan |
| Status | status | `ro316-master-komisi-agen-status` | HTML; role/name/testid usulan |
| Master | button | `ro316-master-komisi-agen-menu-master` | HTML; role/name/testid usulan |
| Master Komisi Agen | link | `ro316-master-komisi-agen-menu-komisi` | HTML; role/name/testid usulan |
| Rute | textbox | `ro316-master-komisi-agen-search-route` | HTML placeholder Cari rute; scope panel Filter |
| Status | combobox | `ro316-master-komisi-agen-filter-status` | HTML; role/name/testid usulan |
| Tanggal Awal | generic | `ro316-master-komisi-agen-date-from` | HTML type=date tanpa implicit textbox role atau label mandiri; gunakan testid/label setelah verifikasi DOM |
| Tanggal Akhir | generic | `ro316-master-komisi-agen-date-to` | HTML type=date tanpa implicit textbox role atau label mandiri; gunakan testid/label setelah verifikasi DOM |
| Jumlah Data | combobox | `ro316-master-komisi-agen-page-size` | HTML Menampilkan Data 10/20/50; name usulan |
| Halaman Berikutnya | button | `ro316-master-komisi-agen-pager` | HTML; role/name/testid usulan |
| Urutkan Rute | button | `ro316-master-komisi-agen-sort-route` | Ikon sort HTML, perilaku usulan A08 |
| Urutkan Terakhir Diubah | button | `ro316-master-komisi-agen-sort-date` | Ikon sort HTML, perilaku usulan A08 |
| Setting komisi rute | button | `ro316-master-komisi-agen-setting` | HTML; role/name/testid usulan |
| Lihat komisi rute | button | `ro316-master-komisi-agen-view` | HTML; role/name/testid usulan |

### setting-komisi-rute

| Elemen / label | Role | data-testid usulan | Dasar / state |
|---|---|---|---|
| Filter | button | `ro316-setting-komisi-rute-filter` | HTML; role/name/testid usulan |
| Daftar Komisi | table | `ro316-setting-komisi-rute-table` | HTML; role/name/testid usulan |
| Status | status | `ro316-setting-komisi-rute-status` | HTML; role/name/testid usulan |
| Jenis Tiket | combobox | `ro316-setting-komisi-rute-jenis-filter` | HTML; role/name/testid usulan |
| Golongan Tiket | textbox | `ro316-setting-komisi-rute-gol-filter` | HTML; role/name/testid usulan |
| Kelas / Kondisi Kendaraan | combobox | `ro316-setting-komisi-rute-kelas-filter` | HTML; role/name/testid usulan |
| Komisi Minimum | spinbutton | `ro316-setting-komisi-rute-pct-min` | HTML; role/name/testid usulan |
| Komisi Maksimum | spinbutton | `ro316-setting-komisi-rute-pct-max` | HTML; role/name/testid usulan |
| Kembali | button | `ro316-setting-komisi-rute-back` | HTML; role/name/testid usulan |
| Master Komisi Agen | link | `ro316-setting-komisi-rute-breadcrumb` | HTML; role/name/testid usulan |
| Tambah Komisi | button | `ro316-setting-komisi-rute-add` | HTML; role/name/testid usulan |
| Edit komisi | button | `ro316-setting-komisi-rute-edit` | HTML; role/name/testid usulan |
| Hapus komisi | button | `ro316-setting-komisi-rute-delete` | HTML; role/name/testid usulan |
| Nonaktifkan Komisi | button | `ro316-setting-komisi-rute-off` | HTML; role/name/testid usulan |
| Aktifkan Komisi | button | `ro316-setting-komisi-rute-on` | HTML; role/name/testid usulan |
| Urutkan Jenis Tiket | button | `ro316-setting-komisi-rute-sort-kind` | HTML; role/name/testid usulan |
| Urutkan Komisi | button | `ro316-setting-komisi-rute-sort-pct` | HTML; role/name/testid usulan |

### komisi-rute

| Elemen / label | Role | data-testid usulan | Dasar / state |
|---|---|---|---|
| Filter | button | `ro316-komisi-rute-filter` | HTML; role/name/testid usulan |
| Daftar Komisi | table | `ro316-komisi-rute-table` | HTML; role/name/testid usulan |
| Status | status | `ro316-komisi-rute-status` | HTML; role/name/testid usulan |
| Jenis Tiket | combobox | `ro316-komisi-rute-jenis-filter` | HTML; role/name/testid usulan |
| Golongan Tiket | textbox | `ro316-komisi-rute-gol-filter` | HTML; role/name/testid usulan |
| Kelas / Kondisi Kendaraan | combobox | `ro316-komisi-rute-kelas-filter` | HTML; role/name/testid usulan |
| Komisi Minimum | spinbutton | `ro316-komisi-rute-pct-min` | HTML; role/name/testid usulan |
| Komisi Maksimum | spinbutton | `ro316-komisi-rute-pct-max` | HTML; role/name/testid usulan |
| Kembali | button | `ro316-komisi-rute-back` | HTML; role/name/testid usulan |
| Master Komisi Agen | link | `ro316-komisi-rute-breadcrumb` | HTML; role/name/testid usulan |

### tambah-komisi-agen

| Elemen / label | Role | data-testid usulan | Dasar / state |
|---|---|---|---|
| Tambah Komisi Agen | dialog | `ro316-tambah-komisi-agen-dialog` | HTML; role/name/testid usulan |
| Rute | generic | `ro316-tambah-komisi-agen-route` | HTML; role/name/testid usulan |
| Jenis Tiket | combobox | `ro316-tambah-komisi-agen-jenis` | HTML; role/name/testid usulan |
| Golongan Tiket | combobox | `ro316-tambah-komisi-agen-gol` | HTML; role/name/testid usulan |
| Kelas / Kondisi Kendaraan | combobox | `ro316-tambah-komisi-agen-kelas` | HTML; role/name/testid usulan |
| % Komisi | textbox | `ro316-tambah-komisi-agen-pct` | HTML; role/name/testid usulan |
| Simpan Komisi | button | `ro316-tambah-komisi-agen-save` | HTML; role/name/testid usulan |
| Batal | button | `ro316-tambah-komisi-agen-cancel` | HTML; role/name/testid usulan |
| Tutup | button | `ro316-tambah-komisi-agen-close` | HTML; role/name/testid usulan |
| Edit baris yang ada | link | `ro316-tambah-komisi-agen-dup-link` | HTML; role/name/testid usulan |
| Estimasi komisi pada tarif berjalan | generic | `ro316-tambah-komisi-agen-estimate` | HTML; role/name/testid usulan |

### edit-komisi-agen

| Elemen / label | Role | data-testid usulan | Dasar / state |
|---|---|---|---|
| Edit Komisi Agen | dialog | `ro316-edit-komisi-agen-dialog` | HTML; role/name/testid usulan |
| Rute | generic | `ro316-edit-komisi-agen-route` | HTML; role/name/testid usulan |
| Jenis Tiket | combobox | `ro316-edit-komisi-agen-jenis` | HTML; role/name/testid usulan |
| Golongan Tiket | combobox | `ro316-edit-komisi-agen-gol` | HTML; role/name/testid usulan |
| Kelas / Kondisi Kendaraan | combobox | `ro316-edit-komisi-agen-kelas` | HTML; role/name/testid usulan |
| % Komisi | textbox | `ro316-edit-komisi-agen-pct` | HTML; role/name/testid usulan |
| Simpan Komisi | button | `ro316-edit-komisi-agen-save` | HTML; role/name/testid usulan |
| Batal | button | `ro316-edit-komisi-agen-cancel` | HTML; role/name/testid usulan |
| Tutup | button | `ro316-edit-komisi-agen-close` | HTML; role/name/testid usulan |
| Edit baris yang ada | link | `ro316-edit-komisi-agen-dup-link` | HTML; role/name/testid usulan |
| Estimasi komisi pada tarif berjalan | generic | `ro316-edit-komisi-agen-estimate` | HTML; role/name/testid usulan |

### hapus-komisi

| Elemen / label | Role | data-testid usulan | Dasar / state |
|---|---|---|---|
| Hapus Komisi | dialog | `ro316-hapus-komisi-dialog` | HTML; role/name/testid usulan |
| Hapus Komisi | button | `ro316-hapus-komisi-confirm` | HTML; role/name/testid usulan |
| Batal | button | `ro316-hapus-komisi-cancel` | HTML; role/name/testid usulan |
| Tutup | button | `ro316-hapus-komisi-close` | HTML; role/name/testid usulan |

### nonaktifkan-komisi

| Elemen / label | Role | data-testid usulan | Dasar / state |
|---|---|---|---|
| Nonaktifkan Komisi | dialog | `ro316-nonaktifkan-komisi-dialog` | HTML; role/name/testid usulan |
| Nonaktifkan | button | `ro316-nonaktifkan-komisi-confirm` | HTML; role/name/testid usulan |
| Batal | button | `ro316-nonaktifkan-komisi-cancel` | HTML; role/name/testid usulan |
| Tutup | button | `ro316-nonaktifkan-komisi-close` | HTML; role/name/testid usulan |
| Alasan | textbox | `ro316-nonaktifkan-komisi-reason` | HTML textarea placeholder Contoh: Rute tidak beroperasi sementara karena kapal docking |

### aktifkan-komisi

| Elemen / label | Role | data-testid usulan | Dasar / state |
|---|---|---|---|
| Aktifkan Komisi | dialog | `ro316-aktifkan-komisi-dialog` | HTML; role/name/testid usulan |
| Aktifkan | button | `ro316-aktifkan-komisi-confirm` | HTML; role/name/testid usulan |
| Batal | button | `ro316-aktifkan-komisi-cancel` | HTML; role/name/testid usulan |
| Tutup | button | `ro316-aktifkan-komisi-close` | HTML; role/name/testid usulan |

### konfirmasi-komisi-nol

| Elemen / label | Role | data-testid usulan | Dasar / state |
|---|---|---|---|
| Konfirmasi Komisi 0% | dialog | `ro316-konfirmasi-komisi-nol-dialog` | HTML; role/name/testid usulan |
| Ya, Simpan 0% | button | `ro316-konfirmasi-komisi-nol-confirm` | HTML; role/name/testid usulan |
| Kembali | button | `ro316-konfirmasi-komisi-nol-cancel` | HTML; role/name/testid usulan |
| Tutup | button | `ro316-konfirmasi-komisi-nol-close` | HTML; role/name/testid usulan |

### detail-agen

| Elemen / label | Role | data-testid usulan | Dasar / state |
|---|---|---|---|
| Nama Perusahaan Agen | generic | `ro316-detail-agen-profile` | Spec; elemen komisi harus tidak ada meskipun HTML menampilkannya |
| Komisi Agen | tab | `ro316-detail-agen-removed-tab` | Spec; elemen komisi harus tidak ada meskipun HTML menampilkannya |
| Tambah Komisi | button | `ro316-detail-agen-removed-add` | Spec; elemen komisi harus tidak ada meskipun HTML menampilkannya |
| Komisi Agen | table | `ro316-detail-agen-removed-table` | Spec; elemen komisi harus tidak ada meskipun HTML menampilkannya |

### transaksi-agen

| Elemen / label | Role | data-testid usulan | Dasar / state |
|---|---|---|---|
| Rute | combobox | `ro316-transaksi-agen-route` | Inferensi minimal dari spec; layar/label produksi tidak tersedia A07 |
| Jenis Tiket | combobox | `ro316-transaksi-agen-jenis` | Inferensi minimal dari spec; layar/label produksi tidak tersedia A07 |
| Golongan Tiket | combobox | `ro316-transaksi-agen-gol` | Inferensi minimal dari spec; layar/label produksi tidak tersedia A07 |
| Kelas / Kondisi Kendaraan | combobox | `ro316-transaksi-agen-kelas` | Inferensi minimal dari spec; layar/label produksi tidak tersedia A07 |
| Buat Transaksi | button | `ro316-transaksi-agen-sell` | Inferensi minimal dari spec; layar/label produksi tidak tersedia A07 |
| Komisi Agen | generic | `ro316-transaksi-agen-commission` | Inferensi minimal dari spec; layar/label produksi tidak tersedia A07 |

### detail-transaksi

| Elemen / label | Role | data-testid usulan | Dasar / state |
|---|---|---|---|
| Komisi Agen | generic | `ro316-detail-transaksi-commission` | Inferensi minimal dari spec A07 |
| Persentase Komisi | generic | `ro316-detail-transaksi-snapshot` | Inferensi minimal dari spec A07 |

### State dan pesan

- Daftar/detail: populated dan empty `Tidak Ada Data yang tersedia`; status `Belum Disetting`, `Aktif`, `Tidak Aktif`.
- Form: incomplete/invalid/duplicate → Simpan Komisi disabled; kelas Penumpang menampilkan `— (khusus Kendaraan)`; valid → estimasi; edit → pemberitahuan transaksi lama tetap.
- Persentase invalid: `Format tidak valid. Gunakan angka dengan maksimal 2 desimal, contoh 3,50.`; di atas 100: `Nilai maksimal 100,00%.`.
- Duplikat: `Kombinasi ini sudah memiliki komisi ...` dengan tautan `Edit baris yang ada`.
- Sukses tambah/edit: `Komisi ditambahkan. Berlaku untuk transaksi baru.` / `Komisi diperbarui. Berlaku untuk transaksi baru.`.
- Hapus: informasi kombinasi, jumlah agen terdampak dan transaksi sebelumnya tetap; nonaktif: konfigurasi dipertahankan dan Alasan wajib; aktif: transaksi masa nonaktif tidak dihitung ulang.
- Cabang: tombol mutasi tidak dirender. Detail Agen: elemen komisi diharapkan absent menurut spec.
- Loading/error jaringan tidak disediakan template; oracle semantik A05. Header, saldo, logo, menu lain dan switch Role/Page prototipe bukan elemen penting fitur ini.

## Assumptions Log

- **A01** — Tidak ada PNG di designs/. Inventaris berasal dari spec dan template HTML terdekode secara statis, tanpa menjalankan script HTML atau mengklaim pemeriksaan visual browser. Tidak ada extras biner terpisah; aset tertanam logo/font bukan sumber requirement.
- **A02** — Spec mengungguli HTML: tab/tabel Komisi Agen masih muncul di Detail Agen pada prototipe, namun harus dihilangkan. Status komisi rute tidak otomatis mengikuti aktif/tidak aktif trayek seperti contoh TRAYEK. Tidak diasumsikan rute nonoperasional pasti komisinya nonaktif.
- **A03** — Batas bawah 0%, field wajib, maksimal dua desimal, pemisah koma/titik, trim whitespace dan dialog 0% berasal dari HTML atau inferensi, karena spec hanya menyebut persen dan maksimum 100%. Nilai negatif, teks, notasi ilmiah dan separator campuran ditolak; tidak menebak batas panjang field lain.
- **A04** — Mengikuti HTML, kelas/kondisi Kendaraan wajib (Kosong/Isi Muatan); Penumpang menampilkan khusus Kendaraan dan menyimpan null. Jika master produksi menyediakan kelas Penumpang, fixture serta oracle harus disesuaikan. Null untuk Penumpang dinormalisasi agar empty/null tidak menggandakan kunci. Rute read-only pada modal; perubahan kunci pada edit diuji dengan fixture/probe karena kontrol kunci mungkin dibatasi.
- **A05** — Alasan Nonaktif wajib non-whitespace mengikuti HTML; spec tidak mewajibkannya. Pembatalan/close modal tidak menyimpan. Error jaringan menampilkan feedback tanpa sukses palsu. Pesan negatif selain dua pesan persen dan duplikat dari HTML adalah oracle semantik, bukan teks literal kontrak.
- **A06** — Belum disetting, konfigurasi terhapus dan rute nonaktif menghasilkan komisi baru 0 sesuai HTML. Komisi transaksi memakai snapshot saat transaksi terbentuk, bukan saat pembayaran; titik berlaku ditentukan urutan commit server. Transaksi sebelum tambah/edit/hapus/nonaktif/aktif tidak dihitung ulang.
- **A07** — Tanpa URL, endpoint, locator DOM final, maupun layar transaksi dari desain: navigate.value memakai alias layar yang wajib dipetakan ke URL lingkungan; selectorHints adalah usulan. Role/name harus diverifikasi, selectOption hanya jika native select. Probe otorisasi/legacy, fixture race/load/timeout harus disediakan harness; schema steps tidak memiliki action API/paralel sehingga kontrak tersebut dicatat di testData.harness dan prasyarat. Skenario merupakan desain uji, belum eksekusi aplikasi.
- **A08** — Filter, page size 10/20/50, pagination, tombol Kembali/close dan sort adalah pelengkap dari HTML. Pagination/sort terlihat namun wiring prototipe tidak lengkap. UI date range diberi nama usulan Tanggal Awal/Akhir; rentang terbalik tidak boleh menampilkan hasil salah (error atau empty). Kontrol prototipe Role/Page bukan elemen produk. Tidak mengarang banner/tautan dari fungsi yang tidak dirender.
- **A09** — Data contoh berasal dari HTML; fixture diisolasi agar tidak bentrok SEED. Tarif 485000 untuk Dewasa; estimasi saja menggunakan pembulatan rupiah Math.round sesuai HTML. Formula komisi transaksi, dasar tarif dan kebijakan pembulatan produksi tidak tersedia, sehingga contoh memakai basis Rp1000000 yang hasilnya integral; ini bukan aturan finansial baru.
- **A10** — Tidak ada SLA atau kapasitas resmi. Load eksploratif: 10000 rute, 50000 konfigurasi, 100 sesi baca, 20 penulis, 1000 transaksi, durasi 60 detik; batas timeout harness 30 detik hanya penjaga uji, bukan acceptance SLA. Oracle stress fokus integritas, isolasi dan pemulihan; laporkan latensi/error tanpa ambang bisnis buatan.
- **A11** — Cabang dilarang menulis di UI maupun server. Sesi tanpa login ditolak; role Agen hanya dapat menjual rute yang diberikan fixture dan tidak diberi akses pengaturan. Setting baru pada rute nonaktif boleh disimpan mengikuti HTML namun aktivasi tetap eksplisit. Status rute berkonfigurasi 0% tetap Aktif; hapus konfigurasi terakhir pada rute aktif membuat Belum Disetting. Rute nonaktif tanpa konfigurasi tetap Tidak Aktif sampai diaktifkan; aktifkan tanpa konfigurasi menghasilkan Belum Disetting.
- **A12** — Sinkronisasi Cabang diverifikasi pada fetch/refresh berikut setelah commit Pusat; spec tidak menentukan push real-time. Hasil cache lama tidak boleh berlaku untuk transaksi baru. Kontrol revisi edit concurrent bebas implementasi (serialisasi/reject konflik) asalkan tidak menimpa perubahan diam-diam atau membentuk data parsial.
