Feature: RO313 Cetak tiket langsung
  Petugas mencetak atau membuka PDF tiket dari daftar order eligible tanpa membuka Daftar Order.
  Asumsi dan batas eksekusi tersedia di ro313-cetak-tiket-langsung.analysis.md.
  Preconditions, fixture, clock, gangguan, workload, dan oracle adapter mengikuti scenarios.json.

  @positive @priority-high @REQ-001 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-001 — Menu Cetak Tiket langsung membuka layar dan breadcrumb yang benar
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-001" disiapkan sesuai scenarios.json
    When user membuka halaman "Beranda"
    And user mengklik tombol "Menu Cetak Tiket"
    Then sistem menampilkan hasil pemeriksaan "Judul Cetak E-Tiket" dengan "Cetak E-Tiket terlihat"
    And sistem menampilkan hasil pemeriksaan "Menu Cetak Tiket" dengan "menu aktif Cetak Tiket"
    And sistem menampilkan hasil pemeriksaan "Breadcrumb Cetak Tiket" dengan "Beranda / Cetak Tiket"
    And sistem menampilkan hasil pemeriksaan "Informasi masa cetak" dengan "keterangan selesai, H+3, dan alternatif Daftar Order terlihat"
    And sistem menampilkan hasil pemeriksaan "Riwayat navigasi" dengan "tidak mengunjungi Daftar Order sebelum mencapai Cetak E-Tiket"

  @negative @priority-high @REQ-001 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-001 — Petugas tanpa izin tidak dapat membuka halaman Cetak Tiket
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-001" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Pemberitahuan" dengan "pemberitahuan bermakna akses ditolak; teks persis belum ditentukan"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak mengungkap data order"
    And sistem menampilkan hasil pemeriksaan "Adapter jaringan" dengan "respons tidak mengandung data tiket"

  @negative @priority-high @REQ-001 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-002 — Sesi habis ketika membuka halaman tidak mengungkap daftar tiket
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-002" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Autentikasi" dengan "meminta login atau menolak sesi habis"
    And sistem menampilkan hasil pemeriksaan "Adapter jaringan" dengan "respons tidak mengandung data tiket"

  @edge @priority-high @REQ-001 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-001 — Membuka URL halaman langsung menghasilkan daftar yang sama
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-001" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561, K7889545, Z7879284, R7785985, W7546030 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Judul Cetak E-Tiket" dengan "Cetak E-Tiket terlihat"

  @positive @priority-medium @REQ-002 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-002 — Delapan header dan seluruh nilai baris sesuai data order
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-002" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Kolom ID Order" dengan "header ID Order terlihat"
    And sistem menampilkan hasil pemeriksaan "Kolom Nama Pembeli" dengan "header Nama Pembeli terlihat"
    And sistem menampilkan hasil pemeriksaan "Kolom Rute" dengan "header Rute terlihat"
    And sistem menampilkan hasil pemeriksaan "Kolom Kapal" dengan "header Kapal terlihat"
    And sistem menampilkan hasil pemeriksaan "Kolom Berangkat" dengan "header Berangkat terlihat"
    And sistem menampilkan hasil pemeriksaan "Kolom Jml Tiket" dengan "header Jml Tiket terlihat"
    And sistem menampilkan hasil pemeriksaan "Kolom Total (Rp)" dengan "header Total (Rp) terlihat"
    And sistem menampilkan hasil pemeriksaan "Kolom Aksi" dengan "header Aksi terlihat"
    And sistem menampilkan hasil pemeriksaan "Baris order [F7889561]" dengan "F7889561 | Karl Marx | Balikpapan (BPN) → Parepare (PAP) | KM. SWARNA BAHTERA | 10-10-2026 15:31 | 2 | Rp 528.000"
    And sistem menampilkan hasil pemeriksaan "Cetak Tiket [F7889561]" dengan "tombol Cetak tersedia"
    And sistem menampilkan hasil pemeriksaan "Download [F7889561]" dengan "ikon unduh tersedia"

  @positive @priority-medium @REQ-002 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-003 — Jumlah lima tiket dan nominal jutaan tidak tertukar dengan harga per tiket
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-003" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Baris order [R7785985]" dengan "Jml Tiket 5 dan Total Rp 3.092.750"

  @negative @priority-medium @REQ-002 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-003 — Kegagalan memuat daftar tidak ditampilkan sebagai data sukses
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-003" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Adapter jaringan" dengan "pemberitahuan gagal memuat daftar terekam sebelum reload"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561, K7889545, Z7879284, R7785985, W7546030 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Status loading" dengan "loading berakhir setelah respons pulih"

  @negative @priority-medium @REQ-002 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-004 — Nama pembeli dengan markup dirender sebagai teks tanpa menjalankan skrip
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-004" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Baris order [SAFE-TEXT]" dengan "nama markup tampil literal"
    And sistem menampilkan hasil pemeriksaan "Adapter browser" dengan "tidak ada dialog atau eksekusi script dari nama pembeli"

  @edge @priority-medium @REQ-002 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-002 — Tidak ada order eligible menghasilkan tabel kosong yang tetap dapat digunakan
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-002" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memiliki baris order"
    And sistem menampilkan hasil pemeriksaan "Status kosong" dengan "state tidak ada data yang jelas"
    And sistem menampilkan hasil pemeriksaan "Filter" dengan "tetap dapat dibuka"

  @positive @priority-high @REQ-003 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-004 — Order selesai tampil bersama dan tetap dapat dicetak
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-004" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561, K7889545, Z7879284 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Cetak Tiket [K7889545]" dengan "aksi tersedia pada order selesai"

  @negative @priority-high @REQ-003 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-005 — Order berstatus pending tidak masuk daftar
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-005" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memuat P-PENDING"

  @negative @priority-high @REQ-003 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-006 — Order berstatus dibatalkan tidak masuk daftar
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-006" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memuat C-CANCELLED"

  @negative @priority-high @REQ-003 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-007 — Order berstatus gagal tidak masuk daftar
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-007" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memuat G-FAILED"

  @edge @priority-high @REQ-003 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-003 — Order yang baru berubah menjadi selesai masuk setelah pembaruan data
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-003" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris P-PENDING tanpa mengunci urutan"

  @edge @priority-high @REQ-003 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-004 — Order yang kembali tidak selesai hilang setelah pembaruan data
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-004" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memiliki baris order"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memuat F7889561"

  @positive @priority-high @REQ-004 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-005 — Order cabang selesai dan terkonfirmasi tampil
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-005" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris K7889545 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Download [K7889545]" dengan "aksi tersedia pada order cabang terkonfirmasi"

  @positive @priority-high @REQ-004 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-006 — Order noncabang selesai tampil meskipun tidak memiliki konfirmasi cabang
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-006" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561 tanpa mengunci urutan"

  @negative @priority-high @REQ-004 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-008 — Order cabang selesai tanpa konfirmasi tidak tampil
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-008" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memuat B-UNCONFIRMED"

  @negative @priority-high @REQ-004 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-009 — Konfirmasi cabang tidak dapat mengalahkan status pending
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-009" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris K7889545 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memuat BRANCH-PENDING"

  @edge @priority-high @REQ-004 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-005 — Konfirmasi cabang yang baru diberikan memunculkan order pada pembaruan berikutnya
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-005" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris B-UNCONFIRMED tanpa mengunci urutan"

  @positive @priority-high @REQ-005 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-007 — Order sebelum batas H+3 dan keberangkatan mendatang tetap tampil
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-007" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561, W7546030 tanpa mengunci urutan"

  @negative @priority-high @REQ-005 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-010 — Order satu milidetik melewati H+3 tidak tampil
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-010" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memuat BOUNDARY"

  @negative @priority-high @REQ-005 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-011 — Order kedaluwarsa tidak kembali melalui filter ID
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-011" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "X-EXPIRED"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memiliki baris order"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memuat X-EXPIRED"

  @edge @priority-high @REQ-005 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-006 — Order tepat H+3 tetap tampil
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-006" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris BOUNDARY tanpa mengunci urutan"

  @edge @priority-high @REQ-005 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-007 — Order satu milidetik sebelum H+3 tetap tampil
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-007" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris BOUNDARY tanpa mengunci urutan"

  @edge @priority-high @REQ-005 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-008 — Baris dan badge hilang otomatis ketika jam melewati H+3 tanpa reload manual
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-008" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memiliki baris order"
    And sistem menampilkan hasil pemeriksaan "Badge masa cetak [BOUNDARY]" dengan "badge ikut hilang bersama baris"

  @edge @priority-high @REQ-005 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-009 — Tanggal UTC dan Jakarta yang mewakili waktu sama memberi retensi sama
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-009" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris TIME-UTC, TIME-JKT tanpa mengunci urutan"

  @edge @priority-high @REQ-005 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-010 — Pergantian bulan tetap menghitung retensi dari timestamp keberangkatan
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-010" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris MONTH-BOUNDARY tanpa mengunci urutan"

  @edge @priority-high @REQ-005 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-011 — Badge masa cetak pada state desain tidak menghilangkan aksi order yang masih eligible
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-011" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Badge masa cetak [R7785985]" dengan "Masa cetak s/d H+3 terlihat pada fixture state badge"
    And sistem menampilkan hasil pemeriksaan "Cetak Tiket [R7785985]" dengan "Cetak tetap dapat dipakai sebelum batas"
    And sistem menampilkan hasil pemeriksaan "Download [R7785985]" dengan "Download tetap dapat dipakai sebelum batas"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris R7785985 tanpa mengunci urutan"

  @positive @priority-high @REQ-006 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-008 — Cetak langsung menghasilkan dokumen order yang dipilih tanpa membuka Daftar Order
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-008" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Cetak Tiket [F7889561]"
    Then sistem menampilkan hasil pemeriksaan "Adapter print" dengan "dokumen F7889561, Karl Marx, Balikpapan (BPN) → Parepare (PAP), KM. SWARNA BAHTERA, 2026-10-10T15:31:00+07:00, 2 tiket"
    And sistem menampilkan hasil pemeriksaan "Adapter print" dengan "fungsi print dipanggil sekali"
    And sistem menampilkan hasil pemeriksaan "Riwayat navigasi" dengan "tidak membuka Daftar Order"
    And sistem menampilkan hasil pemeriksaan "Data order" dengan "status, jumlah tiket, total, dan jumlah order tidak berubah"

  @positive @priority-high @REQ-006 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-009 — Cetak order lima tiket mencakup seluruh tiket dalam order
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-009" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Cetak Tiket [R7785985]"
    Then sistem menampilkan hasil pemeriksaan "Adapter print" dengan "dokumen R7785985, Egy Pranastama, Balikpapan (BPN) → Parepare (PAP), KM. SWARNA BAHTERA, 2026-10-06T13:37:00+07:00, 5 tiket"
    And sistem menampilkan hasil pemeriksaan "Data order" dengan "status, jumlah tiket, total, dan jumlah order tidak berubah"

  @negative @priority-high @REQ-006 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-012 — Gagal mengambil dokumen print tidak membuka print dengan data kosong
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-012" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Cetak Tiket [F7889561]"
    Then sistem menampilkan hasil pemeriksaan "Pemberitahuan" dengan "pemberitahuan bermakna gagal menyiapkan cetak; teks persis belum ditentukan"
    And sistem menampilkan hasil pemeriksaan "Adapter print" dengan "tidak menghasilkan dokumen tiket atau bocoran data order"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561, K7889545, Z7879284, R7785985, W7546030 tanpa mengunci urutan"

  @negative @priority-high @REQ-006 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-013 — Sesi habis sebelum klik Cetak tidak menghasilkan dokumen
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-013" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Cetak Tiket [F7889561]"
    Then sistem menampilkan hasil pemeriksaan "Autentikasi" dengan "meminta autentikasi ulang"
    And sistem menampilkan hasil pemeriksaan "Adapter print" dengan "tidak menghasilkan dokumen tiket atau bocoran data order"

  @negative @priority-high @REQ-006 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-014 — Order menjadi tidak eligible sebelum Cetak ditolak oleh sumber dokumen
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-014" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Cetak Tiket [F7889561]"
    Then sistem menampilkan hasil pemeriksaan "Adapter print" dengan "tidak menghasilkan dokumen tiket atau bocoran data order"
    And sistem menampilkan hasil pemeriksaan "Pemberitahuan" dengan "pemberitahuan bermakna order tidak lagi dapat dicetak; teks persis belum ditentukan"

  @negative @priority-high @REQ-006 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-015 — Cetak ditolak saat order melewati H+3 sesudah daftar dimuat
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-015" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Cetak Tiket [BOUNDARY]"
    Then sistem menampilkan hasil pemeriksaan "Adapter print" dengan "tidak menghasilkan dokumen tiket atau bocoran data order"
    And sistem menampilkan hasil pemeriksaan "Pemberitahuan" dengan "pemberitahuan bermakna masa cetak sudah lewat; teks persis belum ditentukan"

  @edge @priority-high @REQ-006 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-012 — Membatalkan dialog print mempertahankan daftar dan filter
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-012" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "F7889561"
    And user mengklik tombol "Cetak Tiket [F7889561]"
    Then sistem menampilkan hasil pemeriksaan "Adapter print" dengan "dokumen F7889561, Karl Marx, Balikpapan (BPN) → Parepare (PAP), KM. SWARNA BAHTERA, 2026-10-10T15:31:00+07:00, 2 tiket"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "ID Order" dengan "nilai F7889561 dipertahankan"
    And sistem menampilkan hasil pemeriksaan "Data order" dengan "status, jumlah tiket, total, dan jumlah order tidak berubah"

  @edge @priority-high @REQ-006 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-013 — Mencetak dua baris berturut-turut tidak menukar identitas dokumen
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-013" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Cetak Tiket [F7889561]"
    And user mengklik tombol "Cetak Tiket [K7889545]"
    Then sistem menampilkan hasil pemeriksaan "Adapter print" dengan "urutan dokumen F7889561 lalu K7889545"
    And sistem menampilkan hasil pemeriksaan "Data order" dengan "status, jumlah tiket, total, dan jumlah order tidak berubah"

  @edge @priority-high @REQ-006 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-014 — Cetak ulang order yang sama menghasilkan identitas tiket tetap
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-014" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Cetak Tiket [F7889561]"
    And user mengklik tombol "Cetak Tiket [F7889561]"
    Then sistem menampilkan hasil pemeriksaan "Adapter print" dengan "dua dokumen F7889561 dengan identitas tiket sama"
    And sistem menampilkan hasil pemeriksaan "Data order" dengan "status, jumlah tiket, total, dan jumlah order tidak berubah"

  @positive @priority-high @REQ-007 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-010 — Download membuka PDF order terpilih di tab baru dan mempertahankan tab asal
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-010" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Download [F7889561]"
    Then sistem menampilkan hasil pemeriksaan "Adapter popup" dengan "satu tab baru dibuka dan tab asal tetap Cetak E-Tiket"
    And sistem menampilkan hasil pemeriksaan "Adapter jaringan" dengan "respons dokumen application/pdf dengan signature PDF valid"
    And sistem menampilkan hasil pemeriksaan "Tab PDF" dengan "dokumen F7889561, Karl Marx, Balikpapan (BPN) → Parepare (PAP), KM. SWARNA BAHTERA, 2026-10-10T15:31:00+07:00, 2 tiket"
    And sistem menampilkan hasil pemeriksaan "Data order" dengan "status, jumlah tiket, total, dan jumlah order tidak berubah"

  @positive @priority-high @REQ-007 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-011 — PDF order multi-tiket mencakup lima tiket dan nominal order benar
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-011" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Download [R7785985]"
    Then sistem menampilkan hasil pemeriksaan "Tab PDF" dengan "dokumen R7785985, Egy Pranastama, Balikpapan (BPN) → Parepare (PAP), KM. SWARNA BAHTERA, 2026-10-06T13:37:00+07:00, 5 tiket"
    And sistem menampilkan hasil pemeriksaan "Tab PDF" dengan "Total Rp 3.092.750 sesuai order"
    And sistem menampilkan hasil pemeriksaan "Data order" dengan "status, jumlah tiket, total, dan jumlah order tidak berubah"

  @negative @priority-high @REQ-007 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-016 — Kegagalan membuat PDF tidak tampil sebagai PDF valid
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-016" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Download [F7889561]"
    Then sistem menampilkan hasil pemeriksaan "Tab PDF" dengan "tidak menghasilkan dokumen tiket atau bocoran data order"
    And sistem menampilkan hasil pemeriksaan "Penanganan PDF" dengan "kegagalan PDF diberitahukan di tab asal atau tab baru"
    And sistem menampilkan hasil pemeriksaan "Data order" dengan "status, jumlah tiket, total, dan jumlah order tidak berubah"

  @negative @priority-high @REQ-007 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-017 — Pemblokiran popup memberi pemberitahuan dan tidak menavigasi tab asal
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-017" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Download [F7889561]"
    Then sistem menampilkan hasil pemeriksaan "Pemberitahuan" dengan "pemberitahuan bermakna tab baru diblokir; teks persis belum ditentukan"
    And sistem menampilkan hasil pemeriksaan "Adapter popup" dengan "tidak ada tab PDF dan tab asal tetap Cetak E-Tiket"

  @negative @priority-high @REQ-007 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-018 — Order melewati H+3 sebelum Download tidak menghasilkan PDF
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-018" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Download [BOUNDARY]"
    Then sistem menampilkan hasil pemeriksaan "Tab PDF" dengan "tidak menghasilkan dokumen tiket atau bocoran data order"
    And sistem menampilkan hasil pemeriksaan "Penanganan PDF" dengan "dokumen kedaluwarsa ditolak"

  @negative @priority-high @REQ-007 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-019 — Konfirmasi cabang dicabut sebelum Download sehingga PDF ditolak
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-019" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Download [K7889545]"
    Then sistem menampilkan hasil pemeriksaan "Tab PDF" dengan "tidak menghasilkan dokumen tiket atau bocoran data order"
    And sistem menampilkan hasil pemeriksaan "Penanganan PDF" dengan "konfirmasi cabang tidak lagi memenuhi syarat"

  @negative @priority-high @REQ-007 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-020 — Dokumen order di luar cakupan petugas tidak dapat diakses lewat URL yang dimanipulasi
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-020" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user membuka halaman "PDF tiket order FOREIGN melalui URL dokumen yang dipetakan adapter"
    Then sistem menampilkan hasil pemeriksaan "Tab PDF" dengan "tidak menghasilkan dokumen tiket atau bocoran data order"
    And sistem menampilkan hasil pemeriksaan "Adapter jaringan" dengan "permintaan dokumen FOREIGN ditolak tanpa membocorkan tiket"

  @edge @priority-high @REQ-007 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-015 — Menutup tab PDF mempertahankan hasil filter di tab asal
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-015" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Nama Pembeli" dengan "Karl"
    And user mengklik tombol "Download [F7889561]"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Nama Pembeli" dengan "nilai Karl tetap tersedia"
    And sistem menampilkan hasil pemeriksaan "Adapter popup" dengan "tab asal tetap dapat dipakai setelah popup ditutup"

  @edge @priority-high @REQ-007 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-016 — Dua download berbeda tidak saling menukar order di tab baru
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-016" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Download [F7889561]"
    And user mengklik tombol "Download [K7889545]"
    Then sistem menampilkan hasil pemeriksaan "Adapter popup" dengan "dua tab PDF dengan identitas F7889561 dan K7889545"
    And sistem menampilkan hasil pemeriksaan "Data order" dengan "status, jumlah tiket, total, dan jumlah order tidak berubah"

  @positive @priority-medium @REQ-008 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-012 — ID lengkap hanya menampilkan order yang cocok
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-012" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "F7889561"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561 tanpa mengunci urutan"

  @positive @priority-medium @REQ-008 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-013 — Mengosongkan ID Order memulihkan semua order eligible
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-013" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "F7889561"
    And user mengisi field "ID Order" dengan ""
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561, K7889545, Z7879284, R7785985, W7546030 tanpa mengunci urutan"

  @negative @priority-medium @REQ-008 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-021 — ID yang tidak ditemukan menghasilkan daftar kosong
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-021" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "NOT-FOUND-999"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memiliki baris order"
    And sistem menampilkan hasil pemeriksaan "Status kosong" dengan "tidak ada hasil pencarian"

  @negative @priority-medium @REQ-008 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-022 — Filter ID tidak memunculkan order pending
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-022" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "P-PENDING"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memiliki baris order"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memuat P-PENDING"

  @negative @priority-medium @REQ-008 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-023 — Input pola SQL pada ID tidak memperluas hasil atau merusak daftar
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-023" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "' OR 1=1 --"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memiliki baris order"
    And sistem menampilkan hasil pemeriksaan "Adapter jaringan" dengan "tidak terjadi error SQL atau bocoran data"

  @edge @priority-medium @REQ-008 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-017 — Spasi luar pada ID diabaikan
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-017" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "  F7889561  "
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561 tanpa mengunci urutan"

  @edge @priority-medium @REQ-008 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-018 — Prefix ID bukan kecocokan exact
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-018" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "F788"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memiliki baris order"

  @positive @priority-medium @REQ-009 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-014 — Dropdown memuat rute tersedia dan pilihan menyaring rute yang sesuai
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-014" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user memilih opsi "Kariangau (KRG) → Palu (PAL)" pada dropdown "Rute"
    Then sistem menampilkan hasil pemeriksaan "Rute" dengan "opsi sama dengan katalog rute fixture"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris Z7879284, W7546030 tanpa mengunci urutan"

  @positive @priority-medium @REQ-009 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-015 — Mengosongkan pilihan rute mengembalikan hasil eligible
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-015" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user memilih opsi "Kariangau (KRG) → Palu (PAL)" pada dropdown "Rute"
    And user memilih opsi "" pada dropdown "Rute"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561, K7889545, Z7879284, R7785985, W7546030 tanpa mengunci urutan"

  @negative @priority-medium @REQ-009 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-024 — Rute tersedia tanpa order eligible menghasilkan hasil kosong
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-024" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user memilih opsi "Parepare (PAP) → Balikpapan (BPN)" pada dropdown "Rute"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memiliki baris order"
    And sistem menampilkan hasil pemeriksaan "Status kosong" dengan "tidak ada order pada rute tersebut"

  @negative @priority-medium @REQ-009 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-025 — Value rute palsu tidak dapat memperluas hasil
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-025" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user memilih opsi "Balikpapan (BPN) → Parepare (PAP)" pada dropdown "Rute"
    Then sistem menampilkan hasil pemeriksaan "Adapter jaringan" dengan "rute palsu ditolak atau menghasilkan kosong tanpa memperluas eligible set"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memuat P-PENDING, B-UNCONFIRMED, X-EXPIRED"

  @edge @priority-medium @REQ-009 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-019 — Rute arah balik dibedakan dari rute asal
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-019" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user memilih opsi "Balikpapan (BPN) → Parepare (PAP)" pada dropdown "Rute"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memuat REVERSE"

  @edge @priority-medium @REQ-009 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-020 — Rute yang sama tidak membatasi hasil ke satu kapal
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-020" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user memilih opsi "Balikpapan (BPN) → Parepare (PAP)" pada dropdown "Rute"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561, OTHER-SHIP tanpa mengunci urutan"

  @positive @priority-medium @REQ-010 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-016 — Tanggal dan menit valid menampilkan semua order pada waktu tersebut
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-016" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Tanggal berangkat" dengan "10/10/2026 15:31"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561, K7889545 tanpa mengunci urutan"

  @positive @priority-medium @REQ-010 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-017 — Mengosongkan tanggal memulihkan semua order eligible
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-017" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Tanggal berangkat" dengan "10/10/2026 15:31"
    And user mengisi field "Tanggal berangkat" dengan ""
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561, K7889545, Z7879284, R7785985, W7546030 tanpa mengunci urutan"

  @negative @priority-medium @REQ-010 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-026 — Tanggal berangkat menolak tanggal tidak ada
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-026" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Tanggal berangkat" dengan "31/02/2026 10:00"
    Then sistem menampilkan hasil pemeriksaan "Pemberitahuan" dengan "pemberitahuan bermakna tanggal/waktu invalid: tanggal tidak ada; teks persis belum ditentukan"
    And sistem menampilkan hasil pemeriksaan "Adapter filter" dengan "nilai invalid tidak diterapkan sebagai tanggal lain atau tanpa filter"

  @negative @priority-medium @REQ-010 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-027 — Tanggal berangkat menolak tahun bukan kabisat
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-027" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Tanggal berangkat" dengan "29/02/2025 12:00"
    Then sistem menampilkan hasil pemeriksaan "Pemberitahuan" dengan "pemberitahuan bermakna tanggal/waktu invalid: tahun bukan kabisat; teks persis belum ditentukan"
    And sistem menampilkan hasil pemeriksaan "Adapter filter" dengan "nilai invalid tidak diterapkan sebagai tanggal lain atau tanpa filter"

  @negative @priority-medium @REQ-010 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-028 — Tanggal berangkat menolak jam di luar 00–23
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-028" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Tanggal berangkat" dengan "10/10/2026 24:00"
    Then sistem menampilkan hasil pemeriksaan "Pemberitahuan" dengan "pemberitahuan bermakna tanggal/waktu invalid: jam di luar 00–23; teks persis belum ditentukan"
    And sistem menampilkan hasil pemeriksaan "Adapter filter" dengan "nilai invalid tidak diterapkan sebagai tanggal lain atau tanpa filter"

  @negative @priority-medium @REQ-010 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-029 — Tanggal berangkat menolak menit di luar 00–59
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-029" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Tanggal berangkat" dengan "10/10/2026 15:60"
    Then sistem menampilkan hasil pemeriksaan "Pemberitahuan" dengan "pemberitahuan bermakna tanggal/waktu invalid: menit di luar 00–59; teks persis belum ditentukan"
    And sistem menampilkan hasil pemeriksaan "Adapter filter" dengan "nilai invalid tidak diterapkan sebagai tanggal lain atau tanpa filter"

  @negative @priority-medium @REQ-010 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-030 — Tanggal berangkat menolak format bukan DD/MM/YYYY hh:mm
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-030" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Tanggal berangkat" dengan "2026-10-10 15:31"
    Then sistem menampilkan hasil pemeriksaan "Pemberitahuan" dengan "pemberitahuan bermakna tanggal/waktu invalid: format bukan DD/MM/YYYY hh:mm; teks persis belum ditentukan"
    And sistem menampilkan hasil pemeriksaan "Adapter filter" dengan "nilai invalid tidak diterapkan sebagai tanggal lain atau tanpa filter"

  @negative @priority-medium @REQ-010 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-031 — Tanggal berangkat menolak waktu tidak lengkap
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-031" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Tanggal berangkat" dengan "10/10/2026"
    Then sistem menampilkan hasil pemeriksaan "Pemberitahuan" dengan "pemberitahuan bermakna tanggal/waktu invalid: waktu tidak lengkap; teks persis belum ditentukan"
    And sistem menampilkan hasil pemeriksaan "Adapter filter" dengan "nilai invalid tidak diterapkan sebagai tanggal lain atau tanpa filter"

  @edge @priority-medium @REQ-010 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-021 — Tanggal kabisat 29 Februari diterima ketika tahun valid
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-021" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Tanggal berangkat" dengan "29/02/2028 12:00"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris LEAP tanpa mengunci urutan"

  @edge @priority-medium @REQ-010 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-022 — Awal hari 00:00 dan akhir hari 23:59 tetap dapat dibedakan
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-022" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Tanggal berangkat" dengan "10/10/2026 00:00"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris MIDNIGHT tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memuat LAST-MINUTE"

  @edge @priority-medium @REQ-010 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-023 — Filter akhir hari 23:59 menerima nilai valid
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-023" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Tanggal berangkat" dengan "10/10/2026 23:59"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris LAST-MINUTE tanpa mengunci urutan"

  @edge @priority-medium @REQ-010 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-024 — Perbedaan satu menit keberangkatan tidak ikut hasil
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-024" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Tanggal berangkat" dengan "10/10/2026 15:31"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561 tanpa mengunci urutan"

  @positive @priority-medium @REQ-011 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-018 — Nama pembeli lengkap menyaring order yang sesuai
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-018" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Nama Pembeli" dengan "Rina Marlina"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris Z7879284 tanpa mengunci urutan"

  @positive @priority-medium @REQ-011 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-019 — Nama pembeli parsial tanpa membedakan kapital diterima
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-019" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Nama Pembeli" dengan "mArX"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561 tanpa mengunci urutan"

  @negative @priority-medium @REQ-011 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-032 — Nama pembeli yang tidak ada menghasilkan hasil kosong
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-032" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Nama Pembeli" dengan "Pembeli Tidak Terdaftar"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memiliki baris order"
    And sistem menampilkan hasil pemeriksaan "Status kosong" dengan "hasil pencarian kosong"

  @negative @priority-medium @REQ-011 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-033 — Script pada filter nama diperlakukan sebagai teks biasa
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-033" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Nama Pembeli" dengan "<script>alert(1)</script>"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memiliki baris order"
    And sistem menampilkan hasil pemeriksaan "Adapter browser" dengan "tidak ada script atau dialog dijalankan"

  @edge @priority-medium @REQ-011 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-025 — Nama Unicode dan apostrof tetap bisa difilter
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-025" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Nama Pembeli" dengan "O'Connor 李"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris UNICODE tanpa mengunci urutan"

  @edge @priority-medium @REQ-011 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-026 — Nama identik pada dua order menampilkan kedua order
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-026" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Nama Pembeli" dengan "Karl Marx"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561, SAME-BUYER tanpa mengunci urutan"

  @edge @priority-medium @REQ-011 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-027 — Nama hanya spasi diperlakukan sebagai filter kosong
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-027" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Nama Pembeli" dengan "   "
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561, K7889545, Z7879284, R7785985, W7546030 tanpa mengunci urutan"

  @positive @priority-medium @REQ-012 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-020 — Empat filter kompatibel dipadukan sebagai AND
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-020" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "F7889561"
    And user memilih opsi "Balikpapan (BPN) → Parepare (PAP)" pada dropdown "Rute"
    And user mengisi field "Tanggal berangkat" dengan "10/10/2026 15:31"
    And user mengisi field "Nama Pembeli" dengan "Karl"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561 tanpa mengunci urutan"

  @positive @priority-medium @REQ-012 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-021 — Mengosongkan semua filter memulihkan hanya order eligible
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-021" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "F7889561"
    And user memilih opsi "Balikpapan (BPN) → Parepare (PAP)" pada dropdown "Rute"
    And user mengisi field "Tanggal berangkat" dengan "10/10/2026 15:31"
    And user mengisi field "Nama Pembeli" dengan "Karl"
    And user mengisi field "ID Order" dengan ""
    And user memilih opsi "" pada dropdown "Rute"
    And user mengisi field "Tanggal berangkat" dengan ""
    And user mengisi field "Nama Pembeli" dengan ""
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561, K7889545, Z7879284, R7785985, W7546030 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memuat P-PENDING, C-CANCELLED, G-FAILED, B-UNCONFIRMED, X-EXPIRED"

  @negative @priority-medium @REQ-012 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-034 — Filter ID dan rute yang bertentangan tidak dipadukan sebagai OR
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-034" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "F7889561"
    And user memilih opsi "Kariangau (KRG) → Palu (PAL)" pada dropdown "Rute"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memiliki baris order"

  @negative @priority-medium @REQ-012 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-035 — Empat filter cocok tidak dapat menampilkan order cabang tanpa konfirmasi
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-035" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "B-UNCONFIRMED"
    And user memilih opsi "Balikpapan (BPN) → Parepare (PAP)" pada dropdown "Rute"
    And user mengisi field "Tanggal berangkat" dengan "10/10/2026 15:31"
    And user mengisi field "Nama Pembeli" dengan "Karl"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memiliki baris order"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memuat B-UNCONFIRMED"

  @edge @priority-medium @REQ-012 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-028 — Respons filter lama yang datang terakhir tidak menimpa filter terbaru
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-028" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Nama Pembeli" dengan "Karl"
    And user mengisi field "Nama Pembeli" dengan "Rina"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris Z7879284 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Nama Pembeli" dengan "Rina tetap menjadi nilai aktif"

  @positive @priority-medium @REQ-013 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-022 — Ukuran sepuluh menampilkan sepuluh baris dan ringkasan dari sebelas hasil
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-022" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user memilih opsi "10" pada dropdown "Ukuran halaman"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris VOL-00001, VOL-00002, VOL-00003, VOL-00004, VOL-00005, VOL-00006, VOL-00007, VOL-00008, VOL-00009, VOL-00010 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Ringkasan data" dengan "Menampilkan 1 sampai 10 dari 11 data"
    And sistem menampilkan hasil pemeriksaan "Halaman 1" dengan "aktif sebagai halaman pertama"

  @positive @priority-medium @REQ-013 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-023 — Halaman kedua memuat sisa data tanpa duplikat dari halaman pertama
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-023" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Halaman 2"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris VOL-00011 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Ringkasan data" dengan "Menampilkan 11 sampai 11 dari 11 data"
    And sistem menampilkan hasil pemeriksaan "Halaman 2" dengan "aktif sebagai halaman kedua"

  @negative @priority-medium @REQ-013 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-036 — Order tidak eligible tidak dihitung dalam total pagination
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-036" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Ringkasan data" dengan "Menampilkan 1 sampai 10 dari 11 data"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memuat P-PENDING, B-UNCONFIRMED, X-EXPIRED"

  @negative @priority-medium @REQ-013 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-037 — Filter dari halaman kedua tidak terjebak pada halaman kosong
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-037" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Halaman 2"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "VOL-00001"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris VOL-00001 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Ringkasan data" dengan "Menampilkan 1 sampai 1 dari 1 data"
    And sistem menampilkan hasil pemeriksaan "Halaman 1" dengan "aktif setelah perubahan filter"

  @edge @priority-medium @REQ-013 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-029 — Tepat sepuluh hasil tidak membuat halaman kosong tambahan
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-029" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris VOL-00001, VOL-00002, VOL-00003, VOL-00004, VOL-00005, VOL-00006, VOL-00007, VOL-00008, VOL-00009, VOL-00010 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Ringkasan data" dengan "Menampilkan 1 sampai 10 dari 10 data"
    And sistem menampilkan hasil pemeriksaan "Halaman 2" dengan "tidak ada halaman kedua yang dapat dinavigasi"

  @edge @priority-medium @REQ-013 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-030 — Baris terakhir halaman kedua kedaluwarsa lalu pagination kembali ke halaman valid
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-030" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Halaman 2"
    Then sistem menampilkan hasil pemeriksaan "Ringkasan data" dengan "Menampilkan 1 sampai 10 dari 10 data"
    And sistem menampilkan hasil pemeriksaan "Halaman 1" dengan "aktif karena halaman kedua sudah tidak ada"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memuat BOUNDARY"

  @positive @priority-medium @REQ-014 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-POS-024 — Filter membuka panel berisi empat kontrol sesuai spec
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-POS-024" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    Then sistem menampilkan hasil pemeriksaan "Panel Filter" dengan "panel terlihat"
    And sistem menampilkan hasil pemeriksaan "ID Order" dengan "kontrol tersedia dengan label sesuai spec"
    And sistem menampilkan hasil pemeriksaan "Rute" dengan "kontrol tersedia dengan label sesuai spec"
    And sistem menampilkan hasil pemeriksaan "Tanggal berangkat" dengan "kontrol tersedia dengan label sesuai spec"
    And sistem menampilkan hasil pemeriksaan "Nama Pembeli" dengan "kontrol tersedia dengan label sesuai spec"

  @negative @priority-medium @REQ-014 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-NEG-038 — Menutup panel tidak menghapus filter aktif secara diam-diam
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-NEG-038" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "F7889561"
    And user mengklik tombol "Filter"
    And user mengklik tombol "Filter"
    Then sistem menampilkan hasil pemeriksaan "ID Order" dengan "nilai F7889561 tetap tersedia"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561 tanpa mengunci urutan"

  @edge @priority-medium @REQ-014 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-EDG-031 — Panel filter terbuka tidak menghilangkan aksi cetak pada hasil
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-EDG-031" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "F7889561"
    And user mengklik tombol "Cetak Tiket [F7889561]"
    Then sistem menampilkan hasil pemeriksaan "Adapter print" dengan "dokumen F7889561, Karl Marx, Balikpapan (BPN) → Parepare (PAP), KM. SWARNA BAHTERA, 2026-10-10T15:31:00+07:00, 2 tiket"
    And sistem menampilkan hasil pemeriksaan "Panel Filter" dengan "panel tetap tersedia pada halaman asal"

  @stress @priority-medium @REQ-002 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-STR-001 — Sepuluh ribu order tetap dimuat melalui daftar berhalaman yang konsisten
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-STR-001" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Adapter daftar" dengan "total 10.000, setiap halaman maksimum 10, semua ID unik dan nilai order sesuai sumber"
    And sistem menampilkan hasil pemeriksaan "Status loading" dengan "loading berhenti setelah respons selesai"

  @stress @priority-high @REQ-003 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-STR-002 — Dataset besar campuran status tidak meloloskan order belum selesai
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-STR-002" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Adapter daftar" dengan "hanya 2.500 order selesai, tidak ada status lain pada seluruh hasil"

  @stress @priority-high @REQ-004 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-STR-003 — Konfirmasi cabang massal tidak meloloskan order tanpa konfirmasi
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-STR-003" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Adapter daftar" dengan "hanya 5.000 order cabang terkonfirmasi pada seluruh hasil"

  @stress @priority-high @REQ-005 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-STR-004 — Banyak order melewati H+3 serentak tanpa menyisakan baris atau total lama
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-STR-004" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "tidak memiliki baris order"
    And sistem menampilkan hasil pemeriksaan "Ringkasan data" dengan "total hasil menjadi nol tanpa baris stale"

  @stress @priority-high @REQ-006 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-STR-005 — Seratus sesi mencetak order berbeda tanpa pertukaran dokumen
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-STR-005" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Cetak Tiket [VOL-00001]"
    Then sistem menampilkan hasil pemeriksaan "Adapter print" dengan "100 dokumen sesuai order masing-masing sesi, tanpa data silang"
    And sistem menampilkan hasil pemeriksaan "Data order" dengan "status, jumlah tiket, total, dan jumlah order tidak berubah"

  @stress @priority-high @REQ-007 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-STR-006 — Seratus sesi mendownload PDF tanpa kontaminasi isi atau tab asal
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-STR-006" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Download [VOL-00001]"
    Then sistem menampilkan hasil pemeriksaan "Adapter popup" dengan "100 PDF valid sesuai order setiap sesi dan seluruh tab asal tetap tersedia"
    And sistem menampilkan hasil pemeriksaan "Data order" dengan "status, jumlah tiket, total, dan jumlah order tidak berubah"

  @stress @priority-medium @REQ-008 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-STR-007 — ID Order sepuluh ribu karakter ditangani tanpa hang atau kebocoran
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-STR-007" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    Then sistem menampilkan hasil pemeriksaan "Adapter filter" dengan "input panjang ditolak secara jelas atau menghasilkan kosong; tidak meluas ke semua order"
    And sistem menampilkan hasil pemeriksaan "Adapter browser" dengan "UI tetap responsif dan tidak memunculkan error tak tertangani"

  @stress @priority-medium @REQ-009 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-STR-008 — Pergantian rute berulang mempertahankan hasil sesuai pilihan terakhir
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-STR-008" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user memilih opsi "Kariangau (KRG) → Palu (PAL)" pada dropdown "Rute"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris Z7879284, W7546030 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Rute" dengan "nilai akhir Kariangau (KRG) → Palu (PAL)"

  @stress @priority-medium @REQ-010 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-STR-009 — Banyak perubahan tanggal valid dan invalid tidak merusak filter terakhir
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-STR-009" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Tanggal berangkat" dengan "10/10/2026 15:31"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561, K7889545 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Adapter browser" dengan "tidak ada error tidak tertangani"

  @stress @priority-medium @REQ-011 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-STR-010 — Nama sepuluh ribu karakter Unicode tetap ditangani secara aman
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-STR-010" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "Nama Pembeli" dengan "李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李李"
    Then sistem menampilkan hasil pemeriksaan "Adapter filter" dengan "payload Unicode panjang ditolak secara jelas atau menghasilkan kosong"
    And sistem menampilkan hasil pemeriksaan "Adapter browser" dengan "UI dapat dipakai kembali tanpa error tak tertangani"

  @stress @priority-medium @REQ-012 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-STR-011 — Seratus sesi dengan kombinasi filter berbeda tidak saling mempengaruhi hasil
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-STR-011" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    And user mengisi field "ID Order" dengan "F7889561"
    Then sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Adapter filter" dengan "hasil tiap context sesuai kombinasi filter context tersebut tanpa state silang"

  @stress @priority-medium @REQ-002 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-STR-012 — Respons daftar timeout dapat dipulihkan tanpa loading selamanya
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-STR-012" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user membuka halaman "Cetak E-Tiket"
    Then sistem menampilkan hasil pemeriksaan "Adapter jaringan" dengan "timeout pertama ditangani dan pemberitahuan tercatat"
    And sistem menampilkan hasil pemeriksaan "Tabel e-tiket" dengan "hanya baris F7889561, K7889545, Z7879284, R7785985, W7546030 tanpa mengunci urutan"
    And sistem menampilkan hasil pemeriksaan "Status loading" dengan "loading berakhir setelah reload berhasil"

  @stress @priority-medium @REQ-014 @screen-cetak-e-tiket
  Scenario: RO313-CETAK-TIKET-LANGSUNG-STR-013 — Toggle filter berulang tidak menggandakan panel atau listener
    Given prasyarat dan fixture skenario "RO313-CETAK-TIKET-LANGSUNG-STR-013" disiapkan sesuai scenarios.json
    When user membuka halaman "Cetak E-Tiket"
    And user mengklik tombol "Filter"
    Then sistem menampilkan hasil pemeriksaan "Panel Filter" dengan "tepat satu panel terbuka dengan satu kontrol untuk setiap field"
    And sistem menampilkan hasil pemeriksaan "Adapter browser" dengan "tidak ada error tak tertangani atau listener yang menggandakan request"

