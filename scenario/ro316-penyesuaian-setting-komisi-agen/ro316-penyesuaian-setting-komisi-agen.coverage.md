# Coverage — ro316-penyesuaian-setting-komisi-agen

Hasil review artefak desain uji, bukan hasil menjalankan test pada aplikasi. Spec utama tetap mengungguli prototipe HTML.

| Kategori | Jumlah |
|---|---:|
| positive | 31 |
| negative | 47 |
| edge | 41 |
| stress | 13 |
| **Total** | **132** |

Coverage requirement: **28/28** memiliki ≥1 positive dan ≥1 negative. Ada **12** layar/state dengan skenario dan **93** entri elemen inventaris tersentuh (dialog termasuk navigate/fixture open).

## Requirements Traceability Matrix

| REQ | Deskripsi | Scenario IDs |
|---|---|---|
| REQ-001 | Menu Master > Master Komisi Agen dapat diakses Pusat dan Cabang; pengguna tanpa sesi tidak dapat mengakses data. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-001<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-002<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-001 |
| REQ-002 | Daftar menampilkan seluruh rute sistem, termasuk arah balik dan rute tanpa konfigurasi. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-003<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-002<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-001 |
| REQ-003 | Status Belum Disetting, Aktif, Tidak Aktif sesuai konfigurasi dan aktivasi komisi rute. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-004<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003 |
| REQ-004 | Komisi general mengikuti rute yang boleh dijual agen; tidak dibedakan per agen atau cabang. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-004<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-031<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-041 |
| REQ-005 | Pusat menambah konfigurasi dengan rute, jenis, golongan, kelas/kondisi yang relevan, dan persentase wajib. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-006<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-005<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-006 |
| REQ-006 | Jenis Tiket berasal dari master jenis tiket sistem. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-007<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-007 |
| REQ-007 | Golongan Tiket bergantung pada Jenis Tiket; pilihan lama yang tidak sesuai harus direset/ditolak. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-008<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-008<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-009 |
| REQ-008 | Kelas/Kondisi mengikuti master jenis tiket; Kendaraan wajib memilih kondisi, Penumpang menggunakan null sesuai prototipe. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-009<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-010<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-011 |
| REQ-009 | Persentase wajib numerik, nonnegatif, maksimal dua desimal; koma/titik desimal diterima. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-010<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-012<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-013<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-014<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-015<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-016<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-017<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-018<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-019<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-043<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-001<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-003<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-004<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-010 |
| REQ-010 | Persentase Komisi tidak boleh lebih dari 100%; batas 100% diterima. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-011<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-020<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-044<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-002 |
| REQ-011 | Kunci Rute + Jenis + Golongan + Kelas/Kondisi unik; duplikat ditolak dan diarahkan ke edit existing. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-012<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-021<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-045<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-008<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-009<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-010<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-011<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-012<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-004 |
| REQ-012 | Konfigurasi tersimpan berlaku bagi seluruh agen yang menjual kombinasi terkait dan transaksi baru sesudah simpan. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-013<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-022 |
| REQ-013 | Hanya Pusat dapat mengedit persentase konfigurasi existing. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-014<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-023<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-024 |
| REQ-014 | Edit tidak boleh menghasilkan duplikat kombinasi dan tidak menganggap record sendiri duplikat. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-015<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-025<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-013<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-005 |
| REQ-015 | Edit berlaku setelah simpan untuk transaksi baru; snapshot komisi transaksi sebelumnya tetap. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-016<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-026<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-014<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-006 |
| REQ-016 | Hanya Pusat menghapus konfigurasi terpilih; kombinasi lain tetap tersimpan. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-017<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-027<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-015 |
| REQ-017 | Kombinasi terhapus menjadi belum disetting; bukan record tersimpan dengan nilai 0%. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-018<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-028<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-016 |
| REQ-018 | Penghapusan konfigurasi tidak mengubah komisi transaksi historis. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-019<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-029<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-007 |
| REQ-019 | Hanya Pusat menonaktifkan komisi rute; status rute terpilih menjadi Tidak Aktif. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-020<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-030<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-031 |
| REQ-020 | Rute nonaktif tidak menggunakan setting untuk transaksi baru, setara belum disetting; konfigurasi tidak dihapus. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-021<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-032<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-046<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-017<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-019<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-008 |
| REQ-021 | Hanya Pusat mengaktifkan kembali rute; konfigurasi existing berlaku lagi untuk transaksi baru. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-022<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-033<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-034<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-047<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-018 |
| REQ-022 | Cabang melihat konfigurasi Pusat secara read-only tanpa Tambah/Edit/Hapus/Nonaktif/Aktif. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-023<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-035<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-003 |
| REQ-023 | Perubahan Pusat menjadi data yang berlaku dan terlihat di seluruh Cabang. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-024<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-036<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-040<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-009 |
| REQ-024 | Relasi Agen/Detail Agen tidak lagi memiliki section, list, tombol, action atau tabel Komisi Agen. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-025<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-037<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-023 |
| REQ-025 | Nilai komisi per agen tidak dapat disimpan lagi dan data legacy per agen tidak menjadi sumber komisi. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-026<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-038<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-020<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-021<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-022<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-013 |
| REQ-026 | Filter daftar rute/detail komisi, rentang tanggal/persen, empty state dan navigasi daftar bekerja konsisten. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-027<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-028<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-039<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-040<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-024<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-025<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-026<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-027<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-028<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-029<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-030<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-031<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-032<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-033<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-002 |
| REQ-027 | Modal tambah/edit/hapus/nonaktif/aktif mendukung konfirmasi, pembatalan, informasi dampak dan feedback. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-029<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-041<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-034<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-035<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-036<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-037<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-038<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-011<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-STR-012 |
| REQ-028 | Estimasi komisi dan konfirmasi 0% mengikuti nilai valid; 0% tersimpan berbeda dari belum disetting. | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-030<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-042<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-005<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-006<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-007<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-039 |

## Coverage Layar dan Elemen UI

ID lengkap pada RTM. Kolom berikut memberi contoh skenario; elemen berulang seperti Filter/tombol Batal discope ke screen/dialog aktif saat implementasi. Pemeriksaan dialog bisa memakai fixture modal-open. Inventaris menetapkan semua selector sebagai usulan.

| Layar/state | Scenario |
|---|---:|
| aktifkan-komisi | 2 |
| detail-agen | 4 |
| detail-transaksi | 3 |
| edit-komisi-agen | 12 |
| hapus-komisi | 2 |
| komisi-rute | 6 |
| konfirmasi-komisi-nol | 1 |
| master-komisi-agen | 14 |
| nonaktifkan-komisi | 4 |
| setting-komisi-rute | 22 |
| tambah-komisi-agen | 50 |
| transaksi-agen | 12 |

| Layar inventaris | Elemen | Role | Contoh Scenario IDs |
|---|---|---|---|
| master-komisi-agen | Filter | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-027<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-028 |
| master-komisi-agen | Daftar Rute | table | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-001<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-003 |
| master-komisi-agen | Status | status | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-018<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-028 |
| master-komisi-agen | Master | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-001<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-002 |
| master-komisi-agen | Master Komisi Agen | link | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-001<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-002 |
| master-komisi-agen | Rute | textbox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-004 |
| master-komisi-agen | Status | combobox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-018<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-028 |
| master-komisi-agen | Tanggal Awal | generic | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-027<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-025 |
| master-komisi-agen | Tanggal Akhir | generic | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-027<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-025 |
| master-komisi-agen | Jumlah Data | combobox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-029 |
| master-komisi-agen | Halaman Berikutnya | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-029 |
| master-komisi-agen | Urutkan Rute | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-030 |
| master-komisi-agen | Urutkan Terakhir Diubah | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-030 |
| master-komisi-agen | Setting komisi rute | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-032 |
| master-komisi-agen | Lihat komisi rute | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-002 |
| setting-komisi-rute | Filter | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-027<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-028 |
| setting-komisi-rute | Daftar Komisi | table | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-002<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003 |
| setting-komisi-rute | Status | status | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-018<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-028 |
| setting-komisi-rute | Jenis Tiket | combobox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005 |
| setting-komisi-rute | Golongan Tiket | textbox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005 |
| setting-komisi-rute | Kelas / Kondisi Kendaraan | combobox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-006<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-008 |
| setting-komisi-rute | Komisi Minimum | spinbutton | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-028<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-040 |
| setting-komisi-rute | Komisi Maksimum | spinbutton | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-028<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-040 |
| setting-komisi-rute | Kembali | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-006<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-032 |
| setting-komisi-rute | Master Komisi Agen | link | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-001<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-002 |
| setting-komisi-rute | Tambah Komisi | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-018<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-023 |
| setting-komisi-rute | Edit komisi | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-023<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-029 |
| setting-komisi-rute | Hapus komisi | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-017<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-018 |
| setting-komisi-rute | Nonaktifkan Komisi | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-020<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-021 |
| setting-komisi-rute | Aktifkan Komisi | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-022<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-034 |
| setting-komisi-rute | Urutkan Jenis Tiket | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-031 |
| setting-komisi-rute | Urutkan Komisi | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-031 |
| komisi-rute | Filter | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-027<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-028 |
| komisi-rute | Daftar Komisi | table | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-002<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003 |
| komisi-rute | Status | status | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-018<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-028 |
| komisi-rute | Jenis Tiket | combobox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005 |
| komisi-rute | Golongan Tiket | textbox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005 |
| komisi-rute | Kelas / Kondisi Kendaraan | combobox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-006<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-008 |
| komisi-rute | Komisi Minimum | spinbutton | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-028<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-040 |
| komisi-rute | Komisi Maksimum | spinbutton | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-028<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-040 |
| komisi-rute | Kembali | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-006<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-032 |
| komisi-rute | Master Komisi Agen | link | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-001<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-002 |
| tambah-komisi-agen | Tambah Komisi Agen | dialog | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-006 |
| tambah-komisi-agen | Rute | generic | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-004 |
| tambah-komisi-agen | Jenis Tiket | combobox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005 |
| tambah-komisi-agen | Golongan Tiket | combobox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005 |
| tambah-komisi-agen | Kelas / Kondisi Kendaraan | combobox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-006<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-008 |
| tambah-komisi-agen | % Komisi | textbox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-006 |
| tambah-komisi-agen | Simpan Komisi | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-006 |
| tambah-komisi-agen | Batal | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-022<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-024 |
| tambah-komisi-agen | Tutup | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-034<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-035 |
| tambah-komisi-agen | Edit baris yang ada | link | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-012 |
| tambah-komisi-agen | Estimasi komisi pada tarif berjalan | generic | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-030<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-042 |
| edit-komisi-agen | Edit Komisi Agen | dialog | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-012<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-014 |
| edit-komisi-agen | Rute | generic | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-004 |
| edit-komisi-agen | Jenis Tiket | combobox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005 |
| edit-komisi-agen | Golongan Tiket | combobox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005 |
| edit-komisi-agen | Kelas / Kondisi Kendaraan | combobox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-006<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-008 |
| edit-komisi-agen | % Komisi | textbox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-006 |
| edit-komisi-agen | Simpan Komisi | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-006 |
| edit-komisi-agen | Batal | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-022<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-024 |
| edit-komisi-agen | Tutup | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-034<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-035 |
| edit-komisi-agen | Edit baris yang ada | link | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-012 |
| edit-komisi-agen | Estimasi komisi pada tarif berjalan | generic | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-030<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-042 |
| hapus-komisi | Hapus Komisi | dialog | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-017<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-027 |
| hapus-komisi | Hapus Komisi | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-017<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-018 |
| hapus-komisi | Batal | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-022<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-024 |
| hapus-komisi | Tutup | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-034<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-035 |
| nonaktifkan-komisi | Nonaktifkan Komisi | dialog | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-020<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-030 |
| nonaktifkan-komisi | Nonaktifkan | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-020<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-031 |
| nonaktifkan-komisi | Batal | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-022<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-024 |
| nonaktifkan-komisi | Tutup | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-034<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-035 |
| nonaktifkan-komisi | Alasan | textbox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-020<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-031 |
| aktifkan-komisi | Aktifkan Komisi | dialog | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-022<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-033 |
| aktifkan-komisi | Aktifkan | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-022<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-018 |
| aktifkan-komisi | Batal | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-022<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-024 |
| aktifkan-komisi | Tutup | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-034<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-035 |
| konfirmasi-komisi-nol | Konfirmasi Komisi 0% | dialog | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-005<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-039 |
| konfirmasi-komisi-nol | Ya, Simpan 0% | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-005 |
| konfirmasi-komisi-nol | Kembali | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-006<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-032 |
| konfirmasi-komisi-nol | Tutup | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-034<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-035 |
| detail-agen | Nama Perusahaan Agen | generic | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-025<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-EDG-023 |
| detail-agen | Komisi Agen | tab | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-026 |
| detail-agen | Tambah Komisi | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-018<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-023 |
| detail-agen | Komisi Agen | table | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-026 |
| transaksi-agen | Rute | combobox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-004 |
| transaksi-agen | Jenis Tiket | combobox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005 |
| transaksi-agen | Golongan Tiket | combobox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-003<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005 |
| transaksi-agen | Kelas / Kondisi Kendaraan | combobox | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-006<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-008 |
| transaksi-agen | Buat Transaksi | button | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-032 |
| transaksi-agen | Komisi Agen | generic | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-026 |
| detail-transaksi | Komisi Agen | generic | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-POS-005<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-026 |
| detail-transaksi | Persentase Komisi | generic | RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-026<br>RO316-PENYESUAIAN-SETTING-KOMISI-AGEN-NEG-029 |

## Hasil Validasi

- JSON berhasil diparse; schema field wajib, action enum, category/priority enum, ID unik dan sequential per kategori valid.
- Gherkin diparse memakai `gherkin-official` 42.0.1; 132 Scenario AST dikompilasi menjadi 132 pickle tanpa syntax error.
- Nama/id scenario, tag kategori/priority/REQ/screen/id, seluruh preconditions, target/value/action langkah dan expected diverifikasi satu per satu terhadap JSON, bukan hanya hitungan.
- Summary sama dengan hitungan aktual. Seluruh 28 requirement memiliki positive dan negative. Source input dan extras yang dipakai ada; designs kosong sesuai sumber.
- Setiap skenario memiliki Then/expect. Skenario baca dan probe boleh hanya Given/Then; aksi fixture/probe ada pada prasyarat dan testData.harness.
- Selector hints tersedia untuk setiap target. Link diklik sebagai tautan di Gherkin. Input range persen HTML type=number memakai titik; field persen teks menerima koma/titik.
- Data JSON kombinasi diselaraskan dengan langkah Jenis/Golongan/Kondisi; fixture spesifik menggantikan default ketika diperlukan.

## Duplikat dan Review Semantik

- Duplikat identik: **0**, berdasarkan screen + preconditions + steps + testData. Tidak ada skenario yang dibuang.
- Ditinjau tumpang tindih: validasi UI dan probe server dipertahankan karena titik kegagalan berbeda; negative pembatalan temporal dan edge close modal memeriksa oracle berbeda; snapshot historis dan pembayaran sesudah mutasi sama-sama diperlukan.
- Null/empty kondisi Penumpang, arah balik, kondisi Kendaraan, persen 0/0,01/99,99/100/100,01, last-record delete, nonaktif kosong, aktif kosong, cache stale, race serta volume paralel memiliki oracle terpisah.

## Gap dan Batas Eksekusi

- **Tidak ada gap pada requirement, kategori atau elemen penting yang diinventarisasi.** Coverage ini mengukur rancangan uji, bukan test passing pada aplikasi.
- Perbedaan desain: HTML masih menyajikan Komisi Agen di Detail Agen dan menurunkan status dari aktif trayek; oracle mengikuti spec. Ini gap desain terhadap spec, bukan alasan mempertahankan perilaku prototipe.
- Belum tersedia aplikasi target, URL/endpoint, DOM accessible names, API contract, layar transaksi, dasar tarif/batas pembulatan produksi, SLA atau kapasitas. Skenario terkait inferensi dan pelengkap HTML ditandai di Assumptions Log.
- Sebelum codegen/eksekusi: petakan alias navigate ke URL; modal dibuka melalui fixture/detail rute. Screen pada tag adalah titik mulai scenario. Scope aksi baris ke testData.combination/rowScope, scope tombol Hapus Komisi ke dialog aktif, dan verifikasi native/custom select.
- Target Hasil Probe/Hasil Race/Hasil Beban/Hasil Transaksi Fixture/Konfigurasi Fixture adalah oracle harness, bukan klaim elemen aplikasi. Selector untuknya bersifat usulan; implementasi sebaiknya memakai assertion fixture/API atau hasil yang ditampilkan harness.
- steps.expect.value menyimpan oracle: visible/hidden/enabled/disabled → matcher UI; value/equals/count/options/set/contains → matcher data/locator; oracle gabungan → verifier harness. Pemetaan expect-toBeVisible sederhana di panduan tidak cukup untuk semua oracle bisnis; jangan mengubah assertion hidden/disabled/data menjadi hanya visible.
- Dibutuhkan harness untuk probe Cabang dan endpoint legacy, payload invalid server, pemesanan/pembayaran, barrier commit, parallel sessions, timeout-after-commit, pagination scan dan load. Mereka tidak dapat dieksekusi hanya dari tujuh action UI tanpa setup/hook testData.harness.
- Stress bersifat eksploratif dengan ukuran uji A10; tidak menetapkan SLA. Payload panjang boleh diterima utuh atau ditolak jelas bila maksimum belum ditentukan. Rentang terbalik boleh empty/error; final contract perlu dipastikan dari implementasi.
- Rekomendasi lanjutan setelah kontrak tersedia: ganti oracle alternatif dengan respons pasti, verifikasi rounding/dasar komisi transaksi, tetapkan SLA, serta pastikan kebijakan kelas Penumpang dan edit kunci. Tidak diperlukan scenario tambahan untuk menutup REQ yang belum terpetakan.

## Integritas Artefak

| Artefak | SHA-256 |
|---|---|
| ro316-penyesuaian-setting-komisi-agen.analysis.md | `fbcc4a2b8804a03e324a8ab9749952ddaf507a01c517d0d0bebfa7a50297eb45` |
| ro316-penyesuaian-setting-komisi-agen.feature | `b95acedd9bd15fc657d1721bae363ead0b37c5cd3037dcf1746ff6b2f4dbeceb` |
| ro316-penyesuaian-setting-komisi-agen.scenarios.json | `b6e92d8446c8c8f72e48698bc9a698080823ca4aa5297100abdc9e35ce641bad` |

Keempat artefak UTF-8 tersedia dalam folder modul. Inputs hanya dibaca. Run baru tidak menemukan artefak lama sehingga tidak ada arsip yang diperlukan.
