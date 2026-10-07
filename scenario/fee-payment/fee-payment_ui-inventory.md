# Inventaris

URL dari DOM aktual/ artifacts/fee-purchase/20261007-072556/payment-preflight.json. Bank/QRIS #linknya; bank menuju checkout /web/, bukan menebak endpoint simulator. OVO .bayarovo, DANA .clickdana. Checkbox/control checkout harus dipetakan dari rendered DOM sebelum klik. Status pada daftar/detail User Umum; lihat shared/selector-map-finance.md untuk fee. Jangan menjalankan script lama berkode order hardcoded.


Diagnosis aktual: Order Selesai dapat berada pada nextElementSibling baris kode; tombol Cetak E-Tiket menambah parameter kedua saat klik. Untuk verifikasi cetak gunakan waitForEvent(download), saveAs, magic %PDF dan kode booking via pdftotext, bukan GET ulang href. Readiness checkout DANA gunakan Proceed to Pay visible, bukan panjang body.
