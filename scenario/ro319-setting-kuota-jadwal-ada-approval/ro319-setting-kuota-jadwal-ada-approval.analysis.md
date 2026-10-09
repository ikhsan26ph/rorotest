# Analysis — ro319-setting-kuota-jadwal-ada-approval

## Requirements

Sumber utama: `inputs/ro319-setting-kuota-jadwal-ada-approval/spec.txt`; konteks pendukung: `extras/desain-ro-1-5-4-approval-kuota-jadwal.html` (template JSON dibuka dan logic dibaca). Spec diprioritaskan saat bertentangan dengan desain.

| ID | Requirement / acceptance criteria | Sumber |
|---|---|---|
| REQ-001 | **Alur Cabang/Agen dan approval wajib**. Kuota → Approval Pusat → Jadwal → Crew List → Selesai. Jadwal/Crew tidak dapat dilewati sebelum prasyarat terpenuhi. | spec: General Rules 1,3 |
| REQ-002 | **Kuota Pusat tanpa approval**. Kuota lengkap/final buatan Pusat langsung membuka Jadwal dan tidak masuk antrean approval. | spec: General Rules 2; Setting Kuota Pusat 1–4 |
| REQ-003 | **Draft Kuota minimal satu isian**. Draft boleh parsial jika minimal satu data terisi; tersimpan dan bisa dibuka kembali oleh pembuat, tanpa pengajuan. | spec: Setting Kuota Cabang 1–3 |
| REQ-004 | **Pengajuan Kuota lengkap dan valid**. Simpan & Ajukan membutuhkan seluruh field wajib valid; konfirmasi mengubah status Menunggu dan memasukkan satu pengajuan ke Pusat. | spec: Setting Kuota Cabang 4–5 |
| REQ-005 | **Kunci Menunggu dan revisi**. Kuota terkunci selama Menunggu; untuk mengubah, pembuat membatalkan, merevisi draft, lalu mengajukan ulang. Jadwal/Crew tetap terkunci. | spec: Setting Kuota Cabang 5–6; asumsi A02 |
| REQ-006 | **Otorisasi keputusan approval**. Hanya Pusat berhak Setujui/Tolak, hanya terhadap versi pengajuan terbaru berstatus Menunggu. | spec: Approval Kuota Pusat 1–4 |
| REQ-007 | **Setujui, sinkronisasi, dan audit**. Status Disetujui sama di Pusat/Cabang; user, tanggal/waktu keputusan tersimpan; Jadwal Cabang terbuka. | spec: Approval Kuota Pusat 5 |
| REQ-008 | **Tolak dengan alasan dan audit**. Alasan nonblank wajib; status Ditolak sinkron; user, tanggal/waktu, alasan reject tersimpan. | spec: Approval Kuota Pusat 6 |
| REQ-009 | **Revisi dan ajukan ulang penolakan**. Cabang/Agen memperbaiki kuota Ditolak pada voyage yang sama; pengajuan baru Menunggu tanpa membuat voyage ulang. | spec: Approval Kuota Pusat 7 |
| REQ-010 | **Pembatalan pengajuan Menunggu**. Pembuat Cabang/Agen dapat membatalkan hanya selama Menunggu; hasil Dibatalkan tidak lagi dapat diputuskan Pusat. | spec: Pembatalan Pengajuan 1–2 |
| REQ-011 | **Pemakaian ulang kuota dibatalkan**. Isian kuota tetap tersimpan sebagai draft untuk revisi/pengajuan ulang; riwayat pembatalan dipertahankan. | spec: Pembatalan Pengajuan 2–3 |
| REQ-012 | **Edit kuota setelah disetujui**. Cabang tidak dapat mengedit kuota yang telah disetujui; hanya Pusat boleh mengedit kuota jika diperlukan. | spec: Edit Data Cabang 1–2 |
| REQ-013 | **Validasi Jadwal Keberangkatan**. Waktu Berangkat dan Waktu Tiba wajib pada final; tiba harus setelah berangkat; rute/pelabuhan berasal dari voyage. | spec: General Rules 5; extras: jd.saveOff/jd.err |
| REQ-014 | **Draft setiap step tidak final**. Simpan Draft tersedia di Kuota/Jadwal/Crew untuk Cabang/Pusat, minimal satu data; tidak menyelesaikan step. | spec: Simpan Draft 1–3; Setting Kuota Pusat 5 |
| REQ-015 | **Gate antarstep berdasarkan simpan final**. Lanjut hanya jika field wajib valid, step disimpan final, dan approval Cabang terpenuhi; Crew hanya setelah Jadwal final. | spec: Simpan Draft 4–5 |
| REQ-016 | **Crew List dan penyelesaian**. Crew mengikuti rule existing, hanya bisa selesai bila lengkap/valid; final semua step mengaktifkan jadwal sesuai existing. | spec: General Rules 3,5; Visibility Data 4 |
| REQ-017 | **Status/progress daftar**. Isi Kuota, Menunggu, Disetujui, Ditolak, Isi Jadwal, Isi Crew List, Dibatalkan, Jadwal Tampil, Jadwal Tutup mengikuti keadaan persisten proses. | spec: Status 1–2 |
| REQ-018 | **Status Jadwal saat buat dan edit**. Saat membuat Jadwal, Status Jadwal tidak tampil; saat edit hanya Jadwal Tampil/Jadwal Tutup. | spec: Status 3; asumsi A03 |
| REQ-019 | **Isolasi Cabang pembuat**. Draft dan proses belum selesai hanya terlihat Cabang pembuat; Cabang lain ditolak termasuk akses tautan langsung. | spec: Visibility Data 1–2 |
| REQ-020 | **Cakupan visibility Pusat**. Pusat melihat milik sendiri, pengajuan Cabang yang membutuhkan approval, dan data seluruh step selesai; draft Cabang belum diajukan tidak terlihat. | spec: Visibility Data 3 |
| REQ-021 | **Publikasi hanya setelah seluruh step final**. Jadwal Tampil baru terlihat semua role existing yang berhak sesudah Kuota/Jadwal/Crew selesai; role tanpa hak tetap ditolak. | spec: Visibility Data 4 |
| REQ-022 | **Riwayat keputusan dan pengajuan**. Riwayat approval tersedia melalui Approval Kuota sesuai status termasuk penolakan, pembatalan, pengajuan ulang, user dan waktu. | spec: Visibility Data 5; Pembatalan 3; asumsi A09 |
| REQ-023 | **Format dan kapasitas isian kuota**. Kuota Internal/Eksternal numerik 0–9999 (4 digit pada prototipe); tampilkan penanda bila per golongan melebihi kapasitas. Tidak diam-diam mengubah input invalid menjadi kuota berbeda. | spec: General Rules 5; extras: setVal/GOLS; asumsi A04 |
| REQ-024 | **Perhitungan distribusi kuota**. Total per baris = internal+eksternal; subtotal Penumpang/Kendaraan/Bagasi benar; total approval = Penumpang+Kendaraan, Bagasi terpisah. | extras: rowOf/tot/bagTot/totalQ; asumsi A05 |
| REQ-025 | **Kuota melebihi kapasitas dan konfirmasi**. Sesuai desain, Cabang tetap dapat mengajukan total > kapasitas; Pusat harus mencentang konfirmasi tambahan sebelum Setujui. | spec: General Rules 5; extras: overCap/approveDisabled; asumsi A06 |
| REQ-026 | **Setujui Semua**. Pusat dapat mengonfirmasi sejumlah pengajuan Menunggu; termasuk konfirmasi jika ada over-capacity; hanya versi/status yang masih valid diproses. | extras: mBulk/bulk.confirm; asumsi A07 |
| REQ-027 | **Daftar, antrean, detail, dan navigasi**. Daftar Kuota & Jadwal dan Approval Kuota menampilkan data sesuai hak/status, tab, rincian per rute, jumlah data, paging/filter, aksi dan modal konfirmasi. | extras: scList/scQueue/scDetail, pageSizes, lTabs/qTabs; asumsi A08 |
| REQ-028 | **Konsistensi transaksi dan kegagalan**. Gagal simpan/putus koneksi/session habis/aksi paralel tidak menyebabkan sukses palsu, kehilangan data tersimpan, keputusan ganda, atau bypass hak akses. | turunan untuk negative/stress dari aturan status, audit, akses; asumsi A10 |

### Aktor dan hak akses

| Aktor | Hak |
|---|---|
| Cabang/Agen pembuat | Buat, draft, ajukan, batalkan Menunggu, revisi Ditolak/Dibatalkan; final Jadwal/Crew setelah gate terpenuhi; kuota approved read-only. |
| Cabang/Agen lain | Tidak melihat draft/proses belum selesai milik cabang lain; jadwal selesai mengikuti hak existing. |
| Pusat | Buat sendiri tanpa approval; lihat/proses pengajuan Menunggu; lihat riwayat; edit kuota approved; draft cabang belum diajukan tersembunyi. |
| Role tanpa hak / sesi habis | Tidak mengakses/modifikasi data/approval; ditolak pada UI dan server. |

### Validasi dan data uji

| Data | Aturan |
|---|---|
| Trayek, Kapal, Nomor Voyage | Wajib, fixture voyage valid dan konsisten; desain menampilkan ringkasan bukan input. |
| Kuota Internal/Eksternal | Bilangan bulat 0–9999 per isian; minimum satu isian untuk draft; field wajib final lengkap eksplisit (A04). |
| Total kuota | Jumlah dua kolom enam golongan; bagasi terpisah (A05); over-capacity memakai konfirmasi Pusat (A06). |
| Alasan Penolakan | Wajib setelah trim; tidak ada batas panjang resmi. |
| Waktu Berangkat/Tiba | Wajib untuk final Jadwal; tiba > berangkat; contoh waktu WITA pada voyage, bukan timezone semua rute. |
| Crew | Validasi existing dari fixture; satu data untuk draft, lengkap untuk Selesai (A12). |

### Flow dan state

Cabang: Isi Kuota → Simpan & Ajukan → Menunggu → Disetujui → Isi Jadwal (final) → Isi Crew List (final) → Jadwal Tampil. Alternatif: Menunggu → Ditolak → revisi → ajukan ulang; Menunggu → Dibatalkan → draft revisi → ajukan ulang. Pusat: Isi Kuota → simpan final → Isi Jadwal → Isi Crew List → Jadwal Tampil. Simpan Draft di setiap step tidak mengubah gate menjadi final. Jadwal Tampil ↔ Jadwal Tutup melalui edit dengan hak existing.

## UI Inventory

Inventaris statis dari template HTML/logic extras, tanpa PNG dan tanpa render browser. `role/name` dan `data-testid` adalah saran untuk implementasi/codegen. `text` berarti elemen ringkasan noninteractive; gunakan testid/text locator. Scope row pada ID voyage dan scope dialog wajib karena nama tombol berulang. State loading/error jaringan merupakan turunan skenario, bukan state yang dibuktikan gambar.

### daftar-kuota-jadwal

| Elemen / label text | Role + name yang disarankan | Usulan data-testid | State / catatan |
|---|---|---|---|
| Kuota & Jadwal | `link` + `Kuota & Jadwal` | `daftar-kuota-jadwal-kuota-jadwal` | Menu daftar |
| Buat Jadwal | `button` + `Buat Jadwal` | `daftar-kuota-jadwal-buat-jadwal` | Buka form baru |
| Filter | `button` + `Filter` | `daftar-kuota-jadwal-filter` | Panel filter; belum dirinci |
| Jumlah Data | `combobox` + `Jumlah Data` | `daftar-kuota-jadwal-jumlah-data` | 10 / 20 / 50 |
| Semua | `button` + `Semua` | `daftar-kuota-jadwal-semua` | Tab |
| Menunggu Approval | `button` + `Menunggu Approval` | `daftar-kuota-jadwal-menunggu-approval` | Tab + count |
| Disetujui | `button` + `Disetujui` | `daftar-kuota-jadwal-disetujui` | Tab Cabang |
| Ditolak | `button` + `Ditolak` | `daftar-kuota-jadwal-ditolak` | Tab Cabang |
| Dibatalkan | `button` + `Dibatalkan` | `daftar-kuota-jadwal-dibatalkan` | Tab Cabang |
| Aktif | `button` + `Aktif` | `daftar-kuota-jadwal-aktif` | Tab Pusat |
| Daftar Kuota & Jadwal | `table` + `Daftar Kuota & Jadwal` | `daftar-kuota-jadwal-daftar-kuota-jadwal` | Trayek, Tanggal Buat, Kapal, Voyage/Kapasitas, Status, Aksi |
| Lihat detail | `button` + `Lihat detail` | `daftar-kuota-jadwal-lihat-detail` | Expand row dengan scope voyage |
| Jadwal | `button` + `Jadwal` | `daftar-kuota-jadwal-jadwal` | Tab expanded row |
| Crew List | `button` + `Crew List` | `daftar-kuota-jadwal-crew-list` | Tab expanded row |
| Kuota | `button` + `Kuota` | `daftar-kuota-jadwal-kuota` | Tab expanded row |
| Edit | `button` + `Edit` | `daftar-kuota-jadwal-edit` | Nama dinamis sesuai progress; scope row |
| Hapus | `button` + `Hapus` | `daftar-kuota-jadwal-hapus` | Nama dinamis / Batalkan pengajuan; scope row |
| Setujui kuota | `button` + `Setujui kuota` | `daftar-kuota-jadwal-setujui-kuota` | Aksi Pusat scope row |
| Tolak kuota | `button` + `Tolak kuota` | `daftar-kuota-jadwal-tolak-kuota` | Aksi Pusat scope row |
| Setujui Semua | `button` + `Setujui Semua` | `daftar-kuota-jadwal-setujui-semua` | Bulk; binding logic ada, trigger eksplisit tidak terbaca |
| Halaman Berikutnya | `button` + `Halaman Berikutnya` | `daftar-kuota-jadwal-halaman-berikutnya` | Usulan aksesibilitas paging |
| Halaman Sebelumnya | `button` + `Halaman Sebelumnya` | `daftar-kuota-jadwal-halaman-sebelumnya` | Usulan aksesibilitas paging |
| Status | `status` + `Status` | `daftar-kuota-jadwal-status` | Progress spec; desain uppercase berbeda |
| Tidak Ada Data yang tersedia | `status` + `Tidak Ada Data yang tersedia` | `daftar-kuota-jadwal-tidak-ada-data-yang-tersedia` | Empty desain |

### setting-kuota

| Elemen / label text | Role + name yang disarankan | Usulan data-testid | State / catatan |
|---|---|---|---|
| Trayek | `text` + `Trayek` | `setting-kuota-trayek` | Ringkasan wajib PAREPARE - BALIKPAPAN |
| Kapal | `text` + `Kapal` | `setting-kuota-kapal` | KM. SWARNA BAHTERA |
| Call Sign | `text` + `Call Sign` | `setting-kuota-call-sign` | POKG |
| Nomor Voyage | `text` + `Nomor Voyage` | `setting-kuota-nomor-voyage` | 214 |
| Kapasitas Kapal | `text` + `Kapasitas Kapal` | `setting-kuota-kapasitas-kapal` | 598 |
| Rute | `text` + `Rute` | `setting-kuota-rute` | Parepare (PAP) → Balikpapan (BPN) |
| Kuota | `button` + `Kuota` | `setting-kuota-kuota` | Tab step |
| Jadwal | `button` + `Jadwal` | `setting-kuota-jadwal` | Tab step/gate |
| Crew List | `button` + `Crew List` | `setting-kuota-crew-list` | Tab step/gate |
| Total Distribusi Kuota Penumpang | `status` + `Total Distribusi Kuota Penumpang` | `setting-kuota-total-distribusi-kuota-penumpang` | Subtotal |
| Total Distribusi Kuota Kendaraan | `status` + `Total Distribusi Kuota Kendaraan` | `setting-kuota-total-distribusi-kuota-kendaraan` | Subtotal |
| Total Distribusi Kuota Bagasi | `status` + `Total Distribusi Kuota Bagasi` | `setting-kuota-total-distribusi-kuota-bagasi` | Subtotal |
| Total kuota | `status` + `Total kuota` | `setting-kuota-total-kuota` | Total approval |
| Simpan Draft | `button` + `Simpan Draft` | `setting-kuota-simpan-draft` | Enabled >=1 data, belum final |
| Simpan & Ajukan | `button` + `Simpan & Ajukan` | `setting-kuota-simpan-ajukan` | Cabang draft |
| Simpan & Ajukan Ulang | `button` + `Simpan & Ajukan Ulang` | `setting-kuota-simpan-ajukan-ulang` | Cabang Ditolak |
| Simpan | `button` + `Simpan` | `setting-kuota-simpan` | Pusat |
| Batal | `button` + `Batal` | `setting-kuota-batal` | Kembali daftar |
| Batalkan Pengajuan | `button` + `Batalkan Pengajuan` | `setting-kuota-batalkan-pengajuan` | Menunggu saja |
| Lanjut ke Jadwal | `button` + `Lanjut ke Jadwal` | `setting-kuota-lanjut-ke-jadwal` | Approved/final Pusat |
| Kembali ke Kuota | `button` + `Kembali ke Kuota` | `setting-kuota-kembali-ke-kuota` | Panel locked |
| Status Pengajuan | `status` + `Status Pengajuan` | `setting-kuota-status-pengajuan` | Menunggu/Disetujui/Ditolak; identitas/waktu/alasan |
| Melebihi kapasitas | `alert` + `Melebihi kapasitas` | `setting-kuota-melebihi-kapasitas` | Warning total dan penanda per baris |
| Kuota Internal — Ekonomi Lesehan | `textbox` + `Kuota Internal — Ekonomi Lesehan` | `setting-kuota-kuota-internal-ekonomi-lesehan` | Placeholder Tentukan Kuota; kapasitas 480; accessible name/testid usulan |
| Kuota Eksternal — Ekonomi Lesehan | `textbox` + `Kuota Eksternal — Ekonomi Lesehan` | `setting-kuota-kuota-eksternal-ekonomi-lesehan` | Placeholder Tentukan Kuota; kapasitas 480; accessible name/testid usulan |
| Kuota Internal — Ekonomi Lesehan (A) | `textbox` + `Kuota Internal — Ekonomi Lesehan (A)` | `setting-kuota-kuota-internal-ekonomi-lesehan-a` | Placeholder Tentukan Kuota; kapasitas 60; accessible name/testid usulan |
| Kuota Eksternal — Ekonomi Lesehan (A) | `textbox` + `Kuota Eksternal — Ekonomi Lesehan (A)` | `setting-kuota-kuota-eksternal-ekonomi-lesehan-a` | Placeholder Tentukan Kuota; kapasitas 60; accessible name/testid usulan |
| Kuota Internal — Sepeda Motor (CC<250) (II-A) | `textbox` + `Kuota Internal — Sepeda Motor (CC<250) (II-A)` | `setting-kuota-kuota-internal-sepeda-motor-cc-250-ii-a` | Placeholder Tentukan Kuota; kapasitas 20; accessible name/testid usulan |
| Kuota Eksternal — Sepeda Motor (CC<250) (II-A) | `textbox` + `Kuota Eksternal — Sepeda Motor (CC<250) (II-A)` | `setting-kuota-kuota-eksternal-sepeda-motor-cc-250-ii-a` | Placeholder Tentukan Kuota; kapasitas 20; accessible name/testid usulan |
| Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A) | `textbox` + `Kuota Internal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)` | `setting-kuota-kuota-internal-kendaraan-kecil-sedan-jeep-pick-up-iii-a` | Placeholder Tentukan Kuota; kapasitas 20; accessible name/testid usulan |
| Kuota Eksternal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A) | `textbox` + `Kuota Eksternal — Kendaraan Kecil (Sedan, Jeep, Pick-up) (III-A)` | `setting-kuota-kuota-eksternal-kendaraan-kecil-sedan-jeep-pick-up-iii-a` | Placeholder Tentukan Kuota; kapasitas 20; accessible name/testid usulan |
| Kuota Internal — Truck/Bus Sedang Standart (IV-B) | `textbox` + `Kuota Internal — Truck/Bus Sedang Standart (IV-B)` | `setting-kuota-kuota-internal-truck-bus-sedang-standart-iv-b` | Placeholder Tentukan Kuota; kapasitas 10; accessible name/testid usulan |
| Kuota Eksternal — Truck/Bus Sedang Standart (IV-B) | `textbox` + `Kuota Eksternal — Truck/Bus Sedang Standart (IV-B)` | `setting-kuota-kuota-eksternal-truck-bus-sedang-standart-iv-b` | Placeholder Tentukan Kuota; kapasitas 10; accessible name/testid usulan |
| Kuota Internal — Truck/Bus Besar Standart (V-B) | `textbox` + `Kuota Internal — Truck/Bus Besar Standart (V-B)` | `setting-kuota-kuota-internal-truck-bus-besar-standart-v-b` | Placeholder Tentukan Kuota; kapasitas 8; accessible name/testid usulan |
| Kuota Eksternal — Truck/Bus Besar Standart (V-B) | `textbox` + `Kuota Eksternal — Truck/Bus Besar Standart (V-B)` | `setting-kuota-kuota-eksternal-truck-bus-besar-standart-v-b` | Placeholder Tentukan Kuota; kapasitas 8; accessible name/testid usulan |
| Kuota Internal — Bagasi Penumpang 10.000 | `textbox` + `Kuota Internal — Bagasi Penumpang 10.000` | `setting-kuota-kuota-internal-bagasi-penumpang-10-000` | Placeholder Tentukan Kuota; kapasitas —; accessible name/testid usulan |
| Kuota Eksternal — Bagasi Penumpang 10.000 | `textbox` + `Kuota Eksternal — Bagasi Penumpang 10.000` | `setting-kuota-kuota-eksternal-bagasi-penumpang-10-000` | Placeholder Tentukan Kuota; kapasitas —; accessible name/testid usulan |
| Kuota Internal — Bagasi Kendaraan 300.000 | `textbox` + `Kuota Internal — Bagasi Kendaraan 300.000` | `setting-kuota-kuota-internal-bagasi-kendaraan-300-000` | Placeholder Tentukan Kuota; kapasitas —; accessible name/testid usulan |
| Kuota Eksternal — Bagasi Kendaraan 300.000 | `textbox` + `Kuota Eksternal — Bagasi Kendaraan 300.000` | `setting-kuota-kuota-eksternal-bagasi-kendaraan-300-000` | Placeholder Tentukan Kuota; kapasitas —; accessible name/testid usulan |
| Kuota Internal — Bagasi Kendaraan 1.000.000 | `textbox` + `Kuota Internal — Bagasi Kendaraan 1.000.000` | `setting-kuota-kuota-internal-bagasi-kendaraan-1-000-000` | Placeholder Tentukan Kuota; kapasitas —; accessible name/testid usulan |
| Kuota Eksternal — Bagasi Kendaraan 1.000.000 | `textbox` + `Kuota Eksternal — Bagasi Kendaraan 1.000.000` | `setting-kuota-kuota-eksternal-bagasi-kendaraan-1-000-000` | Placeholder Tentukan Kuota; kapasitas —; accessible name/testid usulan |

### setting-jadwal

| Elemen / label text | Role + name yang disarankan | Usulan data-testid | State / catatan |
|---|---|---|---|
| Pelabuhan Asal | `text` + `Pelabuhan Asal` | `setting-jadwal-pelabuhan-asal` | Dari rute |
| Pelabuhan Tujuan | `text` + `Pelabuhan Tujuan` | `setting-jadwal-pelabuhan-tujuan` | Dari rute |
| Waktu Berangkat | `textbox` + `Waktu Berangkat` | `setting-jadwal-waktu-berangkat` | datetime-local; placeholder Tentukan Waktu Berangkat |
| Waktu Tiba | `textbox` + `Waktu Tiba` | `setting-jadwal-waktu-tiba` | datetime-local; placeholder Tentukan Waktu Tiba |
| Status Jadwal | `combobox` + `Status Jadwal` | `setting-jadwal-status-jadwal` | Hanya edit: Jadwal Tampil / Jadwal Tutup sesuai spec |
| Simpan Draft | `button` + `Simpan Draft` | `setting-jadwal-simpan-draft` | Parsial; tidak membuka Crew |
| Simpan | `button` + `Simpan` | `setting-jadwal-simpan` | Final menuju Crew |
| Batal | `button` + `Batal` | `setting-jadwal-batal` | Kembali |
| Crew List | `button` + `Crew List` | `setting-jadwal-crew-list` | Tab gated |
| Waktu tiba harus setelah waktu berangkat. | `alert` + `Waktu tiba harus setelah waktu berangkat.` | `setting-jadwal-waktu-tiba-harus-setelah-waktu-berangkat` | Pesan desain |

### crew-list

| Elemen / label text | Role + name yang disarankan | Usulan data-testid | State / catatan |
|---|---|---|---|
| Rute | `text` + `Rute` | `crew-list-rute` | Pelabuhan rute voyage |
| Masukkan Crew | `button` + `Masukkan Crew` | `crew-list-masukkan-crew` | Dialog existing; detail tidak ada |
| Crew List | `table` + `Crew List` | `crew-list-crew-list` | Crew fixture existing; nama crew tidak direka |
| Simpan Draft | `button` + `Simpan Draft` | `crew-list-simpan-draft` | >=1 data; belum final |
| Selesai | `button` + `Selesai` | `crew-list-selesai` | Lengkap saja |
| Pastikan Crew List sudah terisi semua | `status` + `Pastikan Crew List sudah terisi semua` | `crew-list-pastikan-crew-list-sudah-terisi-semua` | Desain state incomplete |

### approval-kuota

| Elemen / label text | Role + name yang disarankan | Usulan data-testid | State / catatan |
|---|---|---|---|
| Approval Kuota | `link` + `Approval Kuota` | `approval-kuota-approval-kuota` | Menu Pusat |
| Filter | `button` + `Filter` | `approval-kuota-filter` | Tanpa field filter asumtif |
| Jumlah Data | `combobox` + `Jumlah Data` | `approval-kuota-jumlah-data` | 10 / 20 / 50 |
| Semua | `button` + `Semua` | `approval-kuota-semua` | Tab |
| Menunggu Approval | `button` + `Menunggu Approval` | `approval-kuota-menunggu-approval` | Tab + count |
| Disetujui | `button` + `Disetujui` | `approval-kuota-disetujui` | Tab |
| Ditolak | `button` + `Ditolak` | `approval-kuota-ditolak` | Tab |
| Dibatalkan | `button` + `Dibatalkan` | `approval-kuota-dibatalkan` | Tab |
| Daftar Pengajuan Kuota | `table` + `Daftar Pengajuan Kuota` | `approval-kuota-daftar-pengajuan-kuota` | ID, tanggal, kapal, voyage, rute, berangkat, selisih H, total, kapasitas, pengaju, cabang, status, aksi |
| Setujui kuota | `button` + `Setujui kuota` | `approval-kuota-setujui-kuota` | Aksi per row |
| Tolak kuota | `button` + `Tolak kuota` | `approval-kuota-tolak-kuota` | Aksi per row |
| Lihat detail | `button` + `Lihat detail` | `approval-kuota-lihat-detail` | Aksi per row |
| Halaman Berikutnya | `button` + `Halaman Berikutnya` | `approval-kuota-halaman-berikutnya` | Usulan paging |
| Tidak ada pengajuan pada tab ini. | `status` + `Tidak ada pengajuan pada tab ini.` | `approval-kuota-tidak-ada-pengajuan-pada-tab-ini` | Empty desain |

### detail-pengajuan

| Elemen / label text | Role + name yang disarankan | Usulan data-testid | State / catatan |
|---|---|---|---|
| Pengajuan | `heading` + `Pengajuan` | `detail-pengajuan-pengajuan` | ID dan status |
| Kuota vs Kapasitas Kapal | `table` + `Kuota vs Kapasitas Kapal` | `detail-pengajuan-kuota-vs-kapasitas-kapal` | Golongan, kapasitas, kuota diajukan, sisa, total |
| Setujui Kuota | `button` + `Setujui Kuota` | `detail-pengajuan-setujui-kuota` | Menunggu saja |
| Tolak | `button` + `Tolak` | `detail-pengajuan-tolak` | Menunggu saja |
| Riwayat | `region` + `Riwayat` | `detail-pengajuan-riwayat` | Aktor, timestamp, aksi, alasan |
| Ditolak Oleh | `text` + `Ditolak Oleh` | `detail-pengajuan-ditolak-oleh` | User + email existing |
| Tanggal & Waktu Penolakan | `text` + `Tanggal & Waktu Penolakan` | `detail-pengajuan-tanggal-waktu-penolakan` | Timestamp reject |
| Alasan Penolakan | `text` + `Alasan Penolakan` | `detail-pengajuan-alasan-penolakan` | Alasan |
| Kembali | `button` + `Kembali` | `detail-pengajuan-kembali` | Ke antrean/daftar asal |
| Melebihi kapasitas | `alert` + `Melebihi kapasitas` | `detail-pengajuan-melebihi-kapasitas` | Selisih total |

### konfirmasi-pengajuan

| Elemen / label text | Role + name yang disarankan | Usulan data-testid | State / catatan |
|---|---|---|---|
| Simpan & Ajukan Kuota | `dialog` + `Simpan & Ajukan Kuota` | `konfirmasi-pengajuan-simpan-ajukan-kuota` | Cabang; total, keberangkatan |
| Ajukan ke Pusat | `button` + `Ajukan ke Pusat` | `konfirmasi-pengajuan-ajukan-ke-pusat` | Confirm |
| Kembali | `button` + `Kembali` | `konfirmasi-pengajuan-kembali` | Dismiss |
| Simpan Kuota | `dialog` + `Simpan Kuota` | `konfirmasi-pengajuan-simpan-kuota` | Pusat |
| Simpan | `button` + `Simpan` | `konfirmasi-pengajuan-simpan` | Confirm Pusat |
| Batalkan Pengajuan | `dialog` + `Batalkan Pengajuan` | `konfirmasi-pengajuan-batalkan-pengajuan` | Withdraw; retain draft |
| Batalkan Pengajuan | `button` + `Batalkan Pengajuan` | `konfirmasi-pengajuan-batalkan-pengajuan` | Confirm withdraw |

### konfirmasi-keputusan

| Elemen / label text | Role + name yang disarankan | Usulan data-testid | State / catatan |
|---|---|---|---|
| Setujui Kuota | `dialog` + `Setujui Kuota` | `konfirmasi-keputusan-setujui-kuota` | Detail quota/voyage |
| Konfirmasi Melebihi Kapasitas | `checkbox` + `Konfirmasi Melebihi Kapasitas` | `konfirmasi-keputusan-konfirmasi-melebihi-kapasitas` | Label desain Saya menyetujui kuota …; scope dialog |
| Setujui Kuota | `button` + `Setujui Kuota` | `konfirmasi-keputusan-setujui-kuota` | Confirm; disabled tanpa checkbox bila over |
| Tolak Pengajuan Kuota | `dialog` + `Tolak Pengajuan Kuota` | `konfirmasi-keputusan-tolak-pengajuan-kuota` | Tabel quota dan alasan |
| Alasan Penolakan | `textbox` + `Alasan Penolakan` | `konfirmasi-keputusan-alasan-penolakan` | Wajib; placeholder Contoh: Kuota Gol. IV-B melebihi kapasitas dek kendaraan |
| Tolak Pengajuan | `button` + `Tolak Pengajuan` | `konfirmasi-keputusan-tolak-pengajuan` | Disabled bila trim kosong |
| Batal | `button` + `Batal` | `konfirmasi-keputusan-batal` | Dismiss; no decision |
| Setujui Semua Kuota | `dialog` + `Setujui Semua Kuota` | `konfirmasi-keputusan-setujui-semua-kuota` | Daftar kandidat dan total |
| Konfirmasi Semua Melebihi Kapasitas | `checkbox` + `Konfirmasi Semua Melebihi Kapasitas` | `konfirmasi-keputusan-konfirmasi-semua-melebihi-kapasitas` | Label desain Saya menyetujui N kuota … |
| Setujui Semua | `button` + `Setujui Semua` | `konfirmasi-keputusan-setujui-semua` | Confirm bulk |

### konfirmasi-hapus

| Elemen / label text | Role + name yang disarankan | Usulan data-testid | State / catatan |
|---|---|---|---|
| Hapus Draft Kuota | `dialog` + `Hapus Draft Kuota` | `konfirmasi-hapus-hapus-draft-kuota` | Trayek, kapal/voyage, status |
| Hapus Draft | `button` + `Hapus Draft` | `konfirmasi-hapus-hapus-draft` | Confirm |
| Hapus Pengajuan Ditolak | `dialog` + `Hapus Pengajuan Ditolak` | `konfirmasi-hapus-hapus-pengajuan-ditolak` | Riwayat tetap dipertahankan A09 |
| Hapus Pengajuan Dibatalkan | `dialog` + `Hapus Pengajuan Dibatalkan` | `konfirmasi-hapus-hapus-pengajuan-dibatalkan` | Riwayat tetap dipertahankan A09 |
| Hapus | `button` + `Hapus` | `konfirmasi-hapus-hapus` | Confirm sesuai hak existing |
| Hapus Kuota & Jadwal Aktif | `dialog` + `Hapus Kuota & Jadwal Aktif` | `konfirmasi-hapus-hapus-kuota-jadwal-aktif` | Warning penjualan dari desain |
| Kembali | `button` + `Kembali` | `konfirmasi-hapus-kembali` | Dismiss; no deletion |

Pesan nyata desain: `Draft kuota berhasil disimpan.`, `Draft jadwal berhasil disimpan.`, `Draft crew list berhasil disimpan.`, `Jadwal Berhasil Disimpan`, `Waktu tiba harus setelah waktu berangkat.`, `Pengajuan dibatalkan. Isian kuota tersimpan sebagai draft.` Pesan approval/pengajuan sukses memasukkan ID dan Cabang secara dinamis.
## Assumptions Log

- **A01** — Tidak ada PNG. Inventaris diturunkan dari spec dan template/logic prototipe HTML extras yang dibaca statis; tampilan render, ARIA, dan perilaku sistem produksi belum diverifikasi. Extras HTML dipakai sebagai konteks desain, bukan bukti implementasi.
- **A02** — Spec Menunggu bertentangan: isian terkunci tetapi boleh diubah. Dipilih alur desain: batalkan dahulu → revisi draft → ajukan ulang; tidak ada edit langsung pada Menunggu.
- **A03** — Spec mengungguli prototipe untuk Status Jadwal: sembunyikan saat pembuatan; saat edit hanya Jadwal Tampil/Jadwal Tutup. Label desain Jadwal Disembunyikan dipetakan ke Jadwal Tutup; AKTIF/SELESAI/DRAFT dipetakan ke progress spec, bukan status approval tambahan.
- **A04** — Batas 4 digit 0–9999 berasal dari setVal prototipe, bukan angka eksplisit spec. Input nonangka, negatif, pecahan, atau >4 digit harus ditolak/ditandai invalid tanpa silently sanitizing nilai (prototipe stripping/truncation berisiko). Final memakai isian numerik eksplisit semua baris Internal/Eksternal, termasuk 0; draft boleh parsial. Metadata Trayek/Kapal/Voyage tersedia dari fixture voyage karena desain berupa ringkasan noneditable.
- **A05** — Fixture kapasitas prototipe: Ekonomi Lesehan 480, Ekonomi Lesehan (A) 60, II-A 20, III-A 20, IV-B 10, V-B 8; total 598. Bagasi tiga baris terpisah, tidak dihitung dalam kapasitas kapal 598. Semua kapasitas adalah data uji, bukan konstanta semua kapal.
- **A06** — Desain memperbolehkan total over-capacity melalui approval dengan checkbox Pusat. Kelebihan per golongan tetap ditandai walau total <=598; prototipe mensyaratkan checkbox hanya jika total >598. Untuk Pusat yang membuat kuota sendiri, over-capacity final diblokir sampai rule existing override tersedia; draft tetap boleh disimpan.
- **A07** — Setujui Semua berasal dari HTML pada Daftar Kuota & Jadwal, bukan spec; diasumsikan scope kandidat ditampilkan jelas dalam modal, hanya Menunggu yang sah diproses. Versi berubah/stale dilaporkan per item tanpa mengubah keputusan final sebelumnya; daftar terfilter tidak diasumsikan menentukan scope bulk.
- **A08** — Filter dan paging hanya terlihat sebagai kontrol prototipe tanpa logic lengkap. Skenario meminta panel Filter, paging 10/20/50 dan jumlah data konsisten, tanpa mengarang field filter. Label panah halaman, URL, selector data-testid, pesan selain yang nyata dalam desain merupakan usulan; bind ke aplikasi sebelum codegen. Role/name input kuota memerlukan accessible name per baris+kolom atau testid karena placeholder berulang. Kontrol Role/Page/Status Kuota pada bar PROTOTIPE tidak dianggap fitur produk.
- **A09** — Riwayat dipertahankan lintas pembatalan/pengajuan ulang. Tombol Hapus pada desain diuji sebagai penghapusan dari daftar/soft delete sesuai hak existing, dengan audit approval tetap ada; teks desain yang menghilangkan riwayat ditolak karena bertentangan dengan spec. Hapus data aktif hanya diuji batal agar tidak mengarang aturan penjualan/refund.
- **A10** — Stress memakai fixture 1.000 pengajuan, 100 sesi, 10 percobaan submit, payload 10.000 karakter; angka ini beban uji, bukan SLA. Tidak ada target latency, batas panjang alasan, maupun timeout resmi; uji integritas dan recoverability, terima validasi batas existing bila payload besar ditolak. Network fault, stale request, dan role injection dikonfigurasi lewat fixture Playwright; action tetap memakai UI.
- **A11** — Agen diperlakukan sama dengan Cabang pembuat. Pusat diberi hak melihat pengajuan Ditolak/Dibatalkan melalui menu Approval untuk riwayat, walau draft murni Cabang tidak terlihat. Hak edit/hapus/finalisasi existing yang tidak rinci harus disediakan fixture sesuai role; edit Pusat setelah approval tidak memerlukan approval Cabang baru (tidak disebut spec).
- **A12** — Crew mengikuti fixture existing: 12 crew lengkap pada satu rute. Detail form pemilihan crew dan aturan jumlah/kompetensi tidak tersedia; Masukkan Crew memakai fixture dialog existing yang sudah diisi. Draft Crew dengan satu data belum lengkap tetap diizinkan sesuai spec, walau prototipe menyamakan crewDone untuk enable Draft dan Selesai. Pesan expected yang berupa kondisi adalah oracle, bukan teks literal UI; codegen harus memetakan ke assertion state/isi/jumlah/hidden/disabled/audit.
