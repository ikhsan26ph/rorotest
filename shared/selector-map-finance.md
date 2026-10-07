# Selector Finance dan quote biaya admin

Terverifikasi 7 Oktober 2026. Host dan akun berasal dari `config/env.md`.

| Area | Selector / perilaku aktual |
|---|---|
| Finance | `/admin/Finance/` (SilverStripe; berbeda dari Admin Prahu `/adminprahu`) |
| Baris channel | `tbody tr` yang memuat nama channel; URL edit didapat dari properti `href` pada `a.edit-link` |
| Jumlah | `#Form_ItemEditForm_jumlah` / `input[name="jumlah"]` |
| Processing Fee | `#Form_ItemEditForm_processing_fee` / `input[name="processing_fee"]` |
| Limit | `#Form_ItemEditForm_limit`; format angka dapat memakai pemisah koma |
| Simpan | `[name="action_save"]`; tunggu response POST dan baca ulang nilai tersimpan |
| Daftar metode user | `.pilihbankbayar:visible`, nama pada teks, channel pada `data-channel` |
| Quote aplikasi | Fungsi bawaan `showva(channel)` memanggil POST `/home/getFeeAdmin` dengan ID booking dari halaman, tanpa memanggil gateway |
| Response quote | `subtotal`, `adminfee`, `processingfee`, `biayaadmin`, `voucher` |
| Fee ringkasan | `#TotalAdmin1` |
| Total ringkasan | `#TotalAll1` |

Channel yang tampil: Bank Mandiri (802), BCA (702), BNI (801), BRI (800), QRIS, OVO, DANA, Alfamart, Indomaret. Link ada dalam DOM tetapi tersembunyi; Permata dan Dishbursment tidak tampil pada daftar user yang diuji.

`ajaxfaspay` pada pemilihan metode juga memanggil `/home/potongkomisisaldouser`. Pemeriksaan quote bukan pemeriksaan lifecycle gateway/ledger; pemilihan metode sampai instruksi bayar dan debit awal termasuk izin pengujian pengguna. Pelunasan, simulator, dan otorisasi wallet belum dijalankan tanpa konfirmasi dummy.

Pada run awal, script salah memilih elemen Save dan elemen modal; ini TEST ISSUE, sudah diperbaiki memakai selector di atas. Semua sembilan channel kemudian memenuhi assertion quote sebelum/sesudah perubahan, dan konfigurasi kembali identik snapshot awal.
