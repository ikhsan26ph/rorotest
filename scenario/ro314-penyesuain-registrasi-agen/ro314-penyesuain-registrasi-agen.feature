Feature: Penyesuaian registrasi agen — penghapusan Jaminan Agen
  Sumber: spec.txt baris 1–6. Tidak ada desain atau extras.
  Skenario baseline/fixture bersifat bersyarat; detail implementasi belum tersedia.
  Negative mencakup regresi perilaku terlarang, bukan aturan invalid buatan.
  Semua skenario bertag @automation-blocked; belum merupakan skrip Playwright.

  # deposit-agen adalah konteks, bukan nama halaman yang dikonfirmasi.
  # Langkah baseline belum terurai; jangan mengarang tombol, field, atau hasil.

  # Fokus: Penghapusan label sekaligus kontrol pada form awal.
  # Dependency: GAP-02, GAP-06, GAP-12
  @positive @priority-high @REQ-001 @screen-tambah-agen @automation-blocked
  Scenario: RO314-PENYESUAIN-REGISTRASI-AGEN-POS-001 — Field Jaminan Agen dihapus dari Tambah Agen
    Given user Kantor Cabang memiliki akses sah ke Relasi Agen sesuai spesifikasi
    Given user berada di halaman "Tambah Agen"
    When halaman selesai menampilkan data menurut indikator implementasi yang telah diverifikasi
    Then sistem tidak menampilkan label dan kontrol input "Jaminan Agen"
    And user tidak memiliki input UI untuk mengisi nominal jaminan agen

  # Fokus: Tidak ada bagian informasi jaminan pada record baseline tanpa jaminan historis.
  # Dependency: GAP-02, GAP-06, GAP-12, GAP-05
  @positive @priority-high @REQ-002 @screen-detail-agen @automation-blocked @needs-fixture
  Scenario: RO314-PENYESUAIN-REGISTRASI-AGEN-POS-002 — Informasi Jaminan Agen dihapus dari Detail Agen
    Given user Kantor Cabang memiliki akses sah ke Relasi Agen sesuai spesifikasi
    And fixture agen tanpa data jaminan historis telah diverifikasi tersedia pada baseline
    Given user berada di halaman "Detail Agen"
    When halaman selesai menampilkan data menurut indikator implementasi yang telah diverifikasi
    Then sistem tidak menampilkan informasi "Jaminan Agen" beserta nominal atau datanya

  # Fokus: Tidak ada field atau kemampuan menambahkan jaminan pada record yang belum memilikinya.
  # Dependency: GAP-02, GAP-06, GAP-12, GAP-05
  @positive @priority-high @REQ-003 @screen-edit-agen @automation-blocked @needs-fixture
  Scenario: RO314-PENYESUAIN-REGISTRASI-AGEN-POS-003 — Field Jaminan Agen dihapus dari Edit Agen
    Given user Kantor Cabang memiliki akses sah ke Relasi Agen sesuai spesifikasi
    And fixture agen tanpa data jaminan historis telah diverifikasi tersedia pada baseline
    Given user berada di halaman "Edit Agen"
    When halaman selesai menampilkan data menurut indikator implementasi yang telah diverifikasi
    Then sistem tidak menampilkan label dan kontrol input "Jaminan Agen"
    And user tidak memiliki kontrol UI untuk menambahkan atau mengubah "Jaminan Agen"

  # Fokus: Keberhasilan edit valid untuk record tanpa jaminan historis; tidak menyatakan mutasi data jaminan di database.
  # Dependency: GAP-02, GAP-06, GAP-12, GAP-04, GAP-05
  @positive @priority-high @REQ-003 @screen-edit-agen @automation-blocked @needs-baseline @needs-fixture
  Scenario: RO314-PENYESUAIN-REGISTRASI-AGEN-POS-004 — Edit field lain tidak membutuhkan input Jaminan Agen
    Given user Kantor Cabang memiliki akses sah ke Relasi Agen sesuai spesifikasi
    And fixture agen tanpa data jaminan historis telah diverifikasi tersedia pada baseline
    And field edit lain, nilai perubahan valid, operasi simpan, dan bukti hasilnya telah diverifikasi pada baseline
    Given user berada di halaman "Edit Agen"
    When user menjalankan perubahan field lain dan operasi simpan sesuai baseline tanpa mengisi Jaminan Agen
    Then perubahan field lain tersimpan menurut bukti baseline tanpa mengisi nominal Jaminan Agen
    And sistem tidak menampilkan label dan kontrol input "Jaminan Agen"

  # Fokus: Tidak ada bagian jaminan pada Akun Saya untuk record baseline tanpa jaminan historis.
  # Dependency: GAP-02, GAP-06, GAP-12, GAP-05
  @positive @priority-high @REQ-004 @screen-akun-saya @automation-blocked @needs-fixture
  Scenario: RO314-PENYESUAIN-REGISTRASI-AGEN-POS-005 — Informasi Jaminan Agen dihapus dari Akun Saya
    Given user Agen memiliki akses sah ke Akun Saya sesuai spesifikasi
    And fixture agen tanpa data jaminan historis telah diverifikasi tersedia pada baseline
    And akun user Agen telah dipetakan ke fixture agen tersebut
    Given user berada di halaman "Akun Saya"
    When halaman selesai menampilkan data menurut indikator implementasi yang telah diverifikasi
    Then sistem tidak menampilkan informasi "Jaminan Agen" beserta nominal atau datanya

  # Fokus: Preservasi mekanisme deposit; tidak menciptakan alur top-up, nominal, saldo, biaya, atau pesan baru.
  # Dependency: GAP-07
  @positive @priority-high @REQ-005 @screen-deposit-agen @automation-blocked @needs-baseline
  Scenario: RO314-PENYESUAIN-REGISTRASI-AGEN-POS-006 — Alur Deposit Agen valid tetap mengikuti baseline
    Given aktor, layar, data, urutan tindakan, dan hasil alur deposit valid telah dibuktikan pada baseline
    And lingkungan uji sesudah perubahan memakai kondisi awal yang setara dengan baseline
    When user menjalankan alur Deposit Agen valid sesuai urutan tindakan baseline
    Then hasil alur Deposit Agen valid tetap sesuai hasil dan ketentuan baseline

  # Fokus: Regresi negatif: larangan validasi wajib jaminan yang sudah dihapus; bukan input nominal invalid buatan.
  # Dependency: GAP-02, GAP-06, GAP-12, GAP-03
  @negative @priority-high @REQ-001 @screen-tambah-agen @automation-blocked @needs-baseline
  Scenario: RO314-PENYESUAIN-REGISTRASI-AGEN-NEG-001 — Registrasi tidak ditolak oleh validasi Jaminan Agen yang tertinggal
    Given user Kantor Cabang memiliki akses sah ke Relasi Agen sesuai spesifikasi
    And data selain jaminan, seluruh prasyarat registrasi, operasi submit, dan bukti keberhasilan telah diverifikasi valid
    Given user berada di halaman "Tambah Agen"
    When user menjalankan registrasi dengan data dan prasyarat valid yang telah diverifikasi tanpa mengisi Jaminan Agen
    Then sistem tidak menolak registrasi karena nominal Jaminan Agen tidak diisi
    And registrasi berhasil menurut bukti keberhasilan yang telah diverifikasi untuk data dan prasyarat valid

  # Fokus: Mendeteksi kebocoran data historis walau label sudah hilang; jangan melarang angka yang sama pada konteks deposit.
  # Dependency: GAP-02, GAP-06, GAP-12, GAP-05
  @negative @priority-high @REQ-002 @screen-detail-agen @automation-blocked @needs-fixture
  Scenario: RO314-PENYESUAIN-REGISTRASI-AGEN-NEG-002 — Nominal jaminan lama tidak bocor pada Detail Agen
    Given user Kantor Cabang memiliki akses sah ke Relasi Agen sesuai spesifikasi
    And fixture agen lama dengan nominal Jaminan Agen nonnol yang dikenali dari baseline telah tersedia
    Given user berada di halaman "Detail Agen"
    When halaman selesai menampilkan data menurut indikator implementasi yang telah diverifikasi
    Then sistem tidak menampilkan nominal historis sebagai informasi jaminan, termasuk nominal yang tampil tanpa label
    And sistem tidak menampilkan informasi "Jaminan Agen" beserta nominal atau datanya

  # Fokus: Regresi negatif: data lama tidak boleh memunculkan kembali kontrol jaminan pada Edit Agen. Tidak mengirim payload API.
  # Dependency: GAP-02, GAP-06, GAP-12, GAP-05
  @negative @priority-high @REQ-003 @screen-edit-agen @automation-blocked @needs-fixture
  Scenario: RO314-PENYESUAIN-REGISTRASI-AGEN-NEG-003 — Agen lama tidak memperoleh kontrol untuk mengubah jaminan
    Given user Kantor Cabang memiliki akses sah ke Relasi Agen sesuai spesifikasi
    And fixture agen lama dengan nominal Jaminan Agen nonnol yang dikenali dari baseline telah tersedia
    Given user berada di halaman "Edit Agen"
    When halaman selesai menampilkan data menurut indikator implementasi yang telah diverifikasi
    Then user tidak memiliki kontrol UI untuk menambahkan atau mengubah "Jaminan Agen"
    And sistem tidak menampilkan label dan kontrol input "Jaminan Agen"

  # Fokus: Mendeteksi kebocoran nominal lama kepada pemilik akun; tanpa membuat aturan akses akun lain.
  # Dependency: GAP-02, GAP-06, GAP-12, GAP-05
  @negative @priority-high @REQ-004 @screen-akun-saya @automation-blocked @needs-fixture
  Scenario: RO314-PENYESUAIN-REGISTRASI-AGEN-NEG-004 — Nominal jaminan lama tidak bocor pada Akun Saya
    Given user Agen memiliki akses sah ke Akun Saya sesuai spesifikasi
    And fixture agen lama dengan nominal Jaminan Agen nonnol yang dikenali dari baseline telah tersedia
    And akun user Agen telah dipetakan ke fixture historis tersebut
    Given user berada di halaman "Akun Saya"
    When halaman selesai menampilkan data menurut indikator implementasi yang telah diverifikasi
    Then sistem tidak menampilkan nominal historis sebagai informasi jaminan, termasuk nominal yang tampil tanpa label
    And sistem tidak menampilkan informasi "Jaminan Agen" beserta nominal atau datanya

  # Fokus: Validasi deposit lama dipertahankan; tidak mengarang jenis invalid, rentang nominal, atau pesan penolakan.
  # Dependency: GAP-07
  @negative @priority-high @REQ-005 @screen-deposit-agen @automation-blocked @needs-baseline
  Scenario: RO314-PENYESUAIN-REGISTRASI-AGEN-NEG-005 — Alur Deposit Agen invalid tetap mengikuti penolakan baseline
    Given aktor, layar, data atau kondisi invalid, tindakan, dan hasil penolakan deposit telah dibuktikan pada baseline
    And lingkungan uji sesudah perubahan memakai kondisi awal yang setara dengan baseline
    When user menjalankan alur Deposit Agen invalid yang telah dibuktikan pada baseline
    Then alur Deposit Agen invalid tetap mengikuti penolakan dan ketentuan baseline

  # Fokus: Boundary fixture historis nol; tidak mengasumsikan nilai nol valid untuk input aplikasi baru.
  # Dependency: GAP-02, GAP-06, GAP-12, GAP-05
  @edge @priority-medium @REQ-002 @screen-detail-agen @automation-blocked @needs-fixture
  Scenario: RO314-PENYESUAIN-REGISTRASI-AGEN-EDG-001 — Jaminan bernilai nol tetap dihapus pada Detail Agen
    Given user Kantor Cabang memiliki akses sah ke Relasi Agen sesuai spesifikasi
    And fixture historis dengan nilai Jaminan Agen nol telah diverifikasi sah dan tersedia pada baseline
    Given user berada di halaman "Detail Agen"
    When halaman selesai menampilkan data menurut indikator implementasi yang telah diverifikasi
    Then sistem tidak menampilkan informasi "Jaminan Agen" beserta nominal atau datanya
    And sistem tidak menampilkan nilai nol sebagai informasi Jaminan Agen

  # Fokus: Boundary fixture historis nol; tidak mengasumsikan nilai nol valid untuk input aplikasi baru.
  # Dependency: GAP-02, GAP-06, GAP-12, GAP-05
  @edge @priority-medium @REQ-004 @screen-akun-saya @automation-blocked @needs-fixture
  Scenario: RO314-PENYESUAIN-REGISTRASI-AGEN-EDG-002 — Jaminan bernilai nol tetap dihapus pada Akun Saya
    Given user Agen memiliki akses sah ke Akun Saya sesuai spesifikasi
    And fixture historis dengan nilai Jaminan Agen nol telah diverifikasi sah dan tersedia pada baseline
    And akun user Agen telah dipetakan ke fixture historis tersebut
    Given user berada di halaman "Akun Saya"
    When halaman selesai menampilkan data menurut indikator implementasi yang telah diverifikasi
    Then sistem tidak menampilkan informasi "Jaminan Agen" beserta nominal atau datanya
    And sistem tidak menampilkan nilai nol sebagai informasi Jaminan Agen

  # Fokus: Boundary fixture historis nol; tidak mengasumsikan nilai nol valid untuk input aplikasi baru.
  # Dependency: GAP-02, GAP-06, GAP-12, GAP-05
  @edge @priority-medium @REQ-003 @screen-edit-agen @automation-blocked @needs-fixture
  Scenario: RO314-PENYESUAIN-REGISTRASI-AGEN-EDG-003 — Jaminan bernilai nol tetap dihapus pada Edit Agen
    Given user Kantor Cabang memiliki akses sah ke Relasi Agen sesuai spesifikasi
    And fixture historis dengan nilai Jaminan Agen nol telah diverifikasi sah dan tersedia pada baseline
    Given user berada di halaman "Edit Agen"
    When halaman selesai menampilkan data menurut indikator implementasi yang telah diverifikasi
    Then sistem tidak menampilkan label dan kontrol input "Jaminan Agen"
    And user tidak memiliki kontrol UI untuk menambahkan atau mengubah "Jaminan Agen"

  # Fokus: Data kosong menguji sisa bagian informasi; tidak mengarang karakter placeholder seperti tanda hubung.
  # Dependency: GAP-02, GAP-06, GAP-12, GAP-05
  @edge @priority-medium @REQ-002 @screen-detail-agen @automation-blocked @needs-fixture
  Scenario: RO314-PENYESUAIN-REGISTRASI-AGEN-EDG-004 — Jaminan kosong tidak menyisakan label atau placeholder pada Detail Agen
    Given user Kantor Cabang memiliki akses sah ke Relasi Agen sesuai spesifikasi
    And fixture historis dengan data Jaminan Agen kosong telah diverifikasi sah dan tersedia pada baseline
    Given user berada di halaman "Detail Agen"
    When halaman selesai menampilkan data menurut indikator implementasi yang telah diverifikasi
    Then sistem tidak menampilkan informasi "Jaminan Agen" beserta nominal atau datanya
    And sistem tidak menampilkan label atau placeholder yang merepresentasikan informasi Jaminan Agen kosong

  # Fokus: Data kosong menguji sisa bagian informasi; tidak mengarang karakter placeholder seperti tanda hubung.
  # Dependency: GAP-02, GAP-06, GAP-12, GAP-05
  @edge @priority-medium @REQ-004 @screen-akun-saya @automation-blocked @needs-fixture
  Scenario: RO314-PENYESUAIN-REGISTRASI-AGEN-EDG-005 — Jaminan kosong tidak menyisakan label atau placeholder pada Akun Saya
    Given user Agen memiliki akses sah ke Akun Saya sesuai spesifikasi
    And fixture historis dengan data Jaminan Agen kosong telah diverifikasi sah dan tersedia pada baseline
    And akun user Agen telah dipetakan ke fixture historis tersebut
    Given user berada di halaman "Akun Saya"
    When halaman selesai menampilkan data menurut indikator implementasi yang telah diverifikasi
    Then sistem tidak menampilkan informasi "Jaminan Agen" beserta nominal atau datanya
    And sistem tidak menampilkan label atau placeholder yang merepresentasikan informasi Jaminan Agen kosong

  # Fokus: Kombinasi legacy record dan operasi simpan. Tidak menilai retensi, migrasi, atau nilai database jaminan.
  # Dependency: GAP-02, GAP-06, GAP-12, GAP-04, GAP-05
  @edge @priority-high @REQ-003 @screen-edit-agen @automation-blocked @needs-baseline @needs-fixture
  Scenario: RO314-PENYESUAIN-REGISTRASI-AGEN-EDG-006 — Edit agen historis tidak mengaktifkan kembali field atau kewajiban jaminan
    Given user Kantor Cabang memiliki akses sah ke Relasi Agen sesuai spesifikasi
    And fixture agen lama dengan nominal Jaminan Agen nonnol yang dikenali dari baseline telah tersedia
    And field edit lain, nilai perubahan valid, operasi simpan, dan bukti hasilnya telah diverifikasi pada baseline
    Given user berada di halaman "Edit Agen"
    When user menjalankan perubahan field lain dan operasi simpan pada agen historis sesuai baseline tanpa mengisi Jaminan Agen
    Then perubahan field lain tersimpan menurut bukti baseline tanpa memasukkan atau mengubah Jaminan Agen melalui form
    And sistem tidak menolak edit karena nominal Jaminan Agen tidak diisi
    And sistem tidak menampilkan label dan kontrol input "Jaminan Agen"

