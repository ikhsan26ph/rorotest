# OP-21 Pengaturan User — Analisis Requirement

Sumber: `scenario/Dokumen Rule RORO v1.5.0 v19042025.docx`, bagian Operator Pusat/Cabang → Pengaturan User (P818–P849), ditambah aturan Agen → Pengaturan User (P1059–P1066) yang dipakai sebagai analogi, dan peta UI `explore/module-map.md` (UI v1.5.2). Rujukan `P<n>` = indeks paragraf DOCX (lihat `docs/module-map-from-rules.md`).

Cakupan modul: Hak Akses, Sub User, Petugas Scan, Hak Akses Agen, Sub User Agen pada portal Operator `/partner`.
Akun uji: Operator Pusat (akun #2 `config/env.md`) sebagai akun utama; Operator Cabang Pare-Pare (akun #3, Sub User Cabang "Akses IK") untuk pembatasan cabang. Sub User Pusat **ditunda** (belum ada akun; keputusan user 2026-09-25).

Tanggal kajian: 25 September 2026.

## REQ — aturan bisnis dari dokumen rule

| ID | Aturan | Sumber | Dapat diuji di web? |
|---|---|---|---|
| REQ-001 | Pada modul hak akses yang punya field "Melihat", mencentang akses lain selain "Melihat" membuat "Melihat" tetap tercentang/tampil (Melihat = tampilan modul). | P820 (P1061 agen) | Ya — form Tambah/Edit Hak Akses |
| REQ-002 | Mencentang modul **Jual Tiket** otomatis mencentang "Melihat Daftar Penjualan" dan "Melihat Detail Penjualan" pada Modul Penjualan. | P821 | Ya |
| REQ-003 | Mencentang modul **Daftar Piutang** otomatis mencentang "Melihat Daftar Penjualan" dan "Melihat Detail Penjualan". | P822 | Ya |
| REQ-004 | Mencentang modul **Persetujuan Tiket** otomatis mencentang "Melihat Daftar Penjualan" dan "Melihat Detail Penjualan". | P823 | Ya |
| REQ-005 | Hak akses yang telah digunakan (dipakai oleh sub user) tidak bisa dihapus. | P824 (P1062 agen) | Ya — butuh hak akses uji yang dipakai sub user uji |
| REQ-006 | Sub user **pusat** memakai data yang sama dengan pusat. | P826 | Sebagian — butuh login Sub User Pusat (ditunda) |
| REQ-007 | Sub user **cabang** memakai data per kota cabang; beberapa sub user dalam satu cabang berbagi data yang sama (Konter Tiket, Daftar Penjualan, Daftar Piutang, Persetujuan Tiket, Kuota dan Jadwal). | P827–P828 | Sebagian — hanya form (Jenis User = Kantor Cabang wajib pilih Cabang Kota); isolasi data lintas modul di luar modul ini |
| REQ-008 | Ubah kata sandi sub user: buka halaman Edit → klik "Ganti Kata Sandi" → isi → Simpan. Berlaku juga untuk Petugas Scan. | P829, P838 | Ya (pada data uji buatan run) |
| REQ-009 | Data yang tampil bagi sub user mengacu pada Jenis User, Konter Tiket, Cabang Kota. | P830 | Sebagian — field ada di form; efek data lintas modul |
| REQ-010 | Email tidak boleh sama antar Sub User cabang/pusat (unik lintas jenis). | P831 (P1065 agen: email & WA) | Ya — negatif duplikat email |
| REQ-011 | Email dan Nomor WA yang sudah terdaftar sebagai sub user tidak bisa didaftarkan di menu lain yang memakai email/WA (mis. Relasi Pelanggan). | P832 | Lintas modul — diuji di modul Relasi Pelanggan; di sini hanya dicatat |
| REQ-012 | Email dan Nomor WA sub user **boleh** didaftarkan lagi sebagai Petugas Scan (web vs apk). | P833 | Ya — positif: petugas scan dengan email/WA sub user uji |
| REQ-013 | Cabang Kota petugas scan membatasi keberangkatan yang boleh discan (hanya kota tersebut). | P836 | Tidak (apk scanner); di web hanya field Cabang Kota wajib |
| REQ-014 | "Jenis akses aplikasi" petugas scan berfungsi sebagai hak akses (check-in / boarding / keduanya). | P837, P1189 | Ya — field ada di form; efek di apk tidak diuji |
| REQ-015 | Petugas scan berstatus tidak aktif tidak bisa login di apk scan boarding. | P839 | Sebagian — status dapat diatur & tampil di daftar; login apk tidak diuji |
| REQ-016 | Hak Akses Agen: operator pusat & cabang hanya **list dan detail**; tambah/edit/hapus milik Agen Pusat. Pusat melihat hak akses semua agen pusat; cabang hanya agen dari cabang sekota. | P841–P844 | Ya (pusat & cabang) — ⚑ FND-01: DOM pusat memuat tautan "Tambah Hak Akses" ke `/agen/buathakakses` |
| REQ-017 | Sub User Agen: operator pusat & cabang hanya **list dan detail**; pusat melihat sub user semua agen pusat; cabang hanya agen sekota. | P846–P849 | Ya (pusat & cabang) |
| REQ-018 | Kolom "Total Hak Akses" = jumlah sub-akses yang dicentang; checkbox "Pilih Semua" per modul tidak ikut dihitung. | P1063 (aturan **Agen**, diterapkan analog pada tabel operator yang memiliki kolom sama) | Ya — verifikasi setelah membuat hak akses uji; bila berbeda catat sebagai gap, bukan bug |
| REQ-019 | Satu sub user dapat memakai beberapa hak akses; akses yang sama pada beberapa hak akses dihitung satu. | P1066 (Agen, analog; form operator punya `hak_akses[]` multi) | Ya — form Tambah Sub User |
| REQ-020 | Cabang: modul Pengaturan User mengikuti pemberian hak akses; akun cabang uji ("Akses IK") dapat membuka daftar & form tambah Hak Akses/Sub User. | P819–P830, module-map | Ya — smoke akses cabang, tanpa simpan |

## VAL — validasi form (turunan UI + aturan umum kata sandi)

| ID | Validasi | Sumber | Catatan |
|---|---|---|---|
| VAL-001 | Tambah Hak Akses: Nama Hak Akses wajib diisi. | UI (field `nama_hak_akses`) | Pesan aktual dicatat saat run |
| VAL-002 | Tambah Hak Akses: minimal satu akses dicentang (asumsi — bila aplikasi mengizinkan 0 akses, catat sebagai gap desain, bukan bug). | Asumsi QA | |
| VAL-003 | Tambah Sub User: Email, Kata Sandi, Konfirmasi Kata Sandi, Nama, Nomor WA, Jenis User, Hak Akses wajib. | UI (field form `buatsubuser`) | |
| VAL-004 | Tambah Sub User: Konfirmasi Kata Sandi harus sama dengan Kata Sandi. | Analog P59 ("Input Konfirmasi Kata Sandi Harus Sama") | Pesan mungkin berbeda — matching longgar |
| VAL-005 | Kata sandi minimal 6 karakter gabungan huruf & angka. | Analog P58 (atur kata sandi baru) | Bila tidak diberlakukan di form sub user → gap desain |
| VAL-006 | Tambah Sub User: Jenis User "Kantor Cabang" mewajibkan Cabang Kota. | P827, UI | |
| VAL-007 | Tambah Sub User: format email valid. | UI (`type=email` bila ada) | |
| VAL-008 | Tambah Petugas Scan: Nama, Nomor WA, Email, Cabang Kota, Jenis Akses Aplikasi, Kata Sandi wajib. | UI | Diverifikasi saat harvest |
| VAL-009 | Filter daftar (Hak Akses / Sub User / Petugas Scan / Hak Akses Agen / Sub User Agen) menyaring baris sesuai input; Reset mengembalikan daftar penuh. | UI | Tidak ada rule tertulis |

## AC — kriteria penerimaan utama

| ID | Kriteria | REQ |
|---|---|---|
| AC-01 | Hak akses baru `AUTOTEST-<tgl>-HA` tersimpan, tampil di daftar dengan Total Hak Akses sesuai jumlah sub-akses yang dicentang. | REQ-018 |
| AC-02 | Auto-centang Melihat Daftar/Detail Penjualan terjadi saat Jual Tiket / Daftar Piutang / Persetujuan Tiket dicentang. | REQ-002..004 |
| AC-03 | Sub user baru `AUTOTEST-<tgl>-SU` (Kantor Pusat) tersimpan memakai hak akses uji; tampil di daftar dengan Jenis User, Status User benar. | REQ-019, VAL-003 |
| AC-04 | Email duplikat sub user ditolak. | REQ-010 |
| AC-05 | Hapus hak akses uji yang sedang dipakai sub user uji ditolak; setelah sub user uji dihapus, hak akses uji dapat dihapus. | REQ-005 |
| AC-06 | Ganti kata sandi sub user uji lewat Edit → "Ganti Kata Sandi" → Simpan berhasil. | REQ-008 |
| AC-07 | Petugas scan uji dengan email/WA sub user uji **diterima**. | REQ-012 |
| AC-08 | Hak Akses Agen & Sub User Agen: hanya aksi Detail yang tersedia bagi operator; tidak ada Edit/Hapus. | REQ-016, REQ-017 |
| AC-09 | Cabang Pare-Pare hanya melihat hak akses/sub user agen sekota. | REQ-016, REQ-017 |

## Kebersihan data (aturan `docs/agent-guide.md`)

Semua data yang dibuat run: nama/email berprefix `AUTOTEST-<YYYYMMDD>-`, email pada domain non-deliverable `@example.com`, nomor WA fiktif. Urutan pembersihan: hapus Petugas Scan uji → hapus Sub User uji → hapus Hak Akses uji (REQ-005 memaksa urutan ini). Bila fitur hapus tidak ada, catat data tersisa di `results/` dan `shared/decisions.md`.

## Ketidakjelasan (tidak diselesaikan dengan asumsi)

| ID | Hal | Dampak |
|---|---|---|
| Q-21-01 | Rule tidak menyebut apakah pembuatan sub user / petugas scan mengirim email/WA notifikasi. Kontak test notifikasi (`kontakTestNotifikasi`) belum diisi user. | Data uji memakai email `@example.com` (non-deliverable) dan nomor WA fiktif; dicatat di `shared/decisions.md`. |
| Q-21-02 | Rule "Total Hak Akses" (P1063) dan "beberapa hak akses per sub user" (P1066) tertulis di bagian Agen, bukan Operator. | Diterapkan analog; selisih dicatat sebagai gap desain, bukan bug. |
| Q-21-03 | Pesan validasi form tidak dinyatakan dalam rule. | Assertion memakai matching longgar (pesan/penanda error terlihat, data tidak tersimpan). |
