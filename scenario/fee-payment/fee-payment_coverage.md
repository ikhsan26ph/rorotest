# Cakupan

9pelunasan dummy pada order yang sudah ada;0booking tambahan. Nominal/status/detail setelah payment diperiksa. Retail tanpa instruksi perlu diagnosis pada metode sama; tidak berpindah gateway diam-diam.


## 2026-10-07 — Hasil pelunasan dummy 20261007-074932

Pelunasan hanya pada sembilan kode order baru run20261007-072556, tanpa booking tambahan atau perubahan Finance. QRIS I9135888 lunas 14:53 WIB total320640 fee10640; OVO S9135832 lunas 14:57 WIB total329220 fee19220. Indikator positif Order Selesai + tanggal bayar pada detail, daftar empat role, kwitansi Status Terbayar, dan unduhan e-tiket tombol aktual PDF dengan kode sama. Finance snapshot12baris tetap sama.

Empat bank checkout-staging menampilkan “Sorry, this wasn't supposed to happen” tanpa kontrol pembayaran pada dua pemeriksaan. Retail E9135877/W9135882 awal HTTP500 ApiException; satu retry metode sama/kode sama HTTP200 status_code DOUBLE_VA tanpa instruksi valid. DANA T9135838 awal charge PENDING320850; automation salah menunggu body.length>80 pada halaman pendek eWallet Test Payment sehingga Proceed to Pay belum diklik. Resume checkout existing Data not found, tombol Ganti Metode disabled. Setelah deadline15:27, alur normal aplikasi menjalankan expiry HTTP200 dan UI kedaluwarsa (dana-normal-expiry-check.json). Tidak ada charge ulang, bypass tombol disabled, atau order pengganti. Root cause provider/backend belum ditentukan.

Koreksi TEST ISSUE: status Order Selesai berada juga di baris berikutnya, bukan hanya baris utama daftar. PrintTix tombol menambah parameter kedua; GET single maupun double URL terpisah HTTP500 tidak merepresentasikan unduhan UI. Klik aktual menghasilkan PDF valid QRIS dan OVO (eticket-ui-final.json). Jangan meneruskan kandidat bug cetak berdasarkan pemeriksaan URL tersebut.

30 menu laporan dibaca pada tiga role. Per Trip jadwal2321 menampilkan dua penumpang dengan net tiket531000 (2×265500), bukan total gateway649860 atau harga+pass620000. Kwitansi memuat Total Pembayaran310000 berlabel belum termasuk admin fee, serta persentase2%/6.2%; nominal penuh fee/PF tidak tersedia sehingga fee PDF belum dapat direkonsiliasi. Jangan menyebut beda subtotal vs gross sebagai mismatch. Pemakaian Saldo tiga role dan ledger menampilkan7debit3983=27881, retail tidak ada debit; debit ini tercatat saat inisialisasi sebelum pelunasan, bukan bukti7order lunas. Scope fixture penumpang tidak membuktikan laporan kendaraan/agen/pembatalan seluruhnya.

Hasil11skenario:4passed (2pelunasan +2PDF),0failed,7blocked. Pembayaran2dari9lunas. Excel reports/fee-payment__20261007-074932.xlsx; JSON results/fee-payment__20261007-074932.json. Sisa memerlukan pemulihan checkout/integrasi aplikasi; repository ini hanya pengujian. Tidak melakukan refund/pembatalan tiket lunas karena pengguna meminta menyelesaikan pembayaran. Cleanup belum selesai.

| SCN | Klasifikasi | Rujukan | Severity | Analisis | Rekomendasi |
|---|---|---|---|---|---|
|0001–0004|NEED RECHECK|REQ-FPAY-002|major|Checkout staging error, tanpa kontrol bayar|Perbaiki/periksa checkout lalu uji kode valid|
|0006|TEST ISSUE + NEED RECHECK|REQ-FPAY-002|major|Readiness salah; resume Data not found kemudian expiry normal|Gunakan selector tombol; pulihkan integrasi/state sebelum uji ulang|
|0007–0008|NEED RECHECK|REQ-FPAY-002|major|500 awal kemudian DOUBLE_VA tanpa instruksi|Periksa inisialisasi parsial dan pemulihan gateway|
|0010–0011|TEST ISSUE corrected|REQ-FPAY-003|—|URL ulang500, klik aktual PDF berhasil|Pertahankan assertion download PDF|

Pemeriksaan terakhir ledger setelah expiry DANA:7kode masing-masing tetap satu debit3983; dua retail tidak ada baris. T9135838 berstatus Order Expired pada baris kode yang sama dan debit3983 belum memiliki kredit balik pada100baris terakhir yang diperiksa. Kebijakan pengembalian saldo belum diverifikasi; tidak langsung diklasifikasikan bug. Bukti ledger-after-dana-expiry.json dan dana-normal-expiry-check.json.
