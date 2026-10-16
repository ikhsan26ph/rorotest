# Peta ikon sortir

Selector dasar sumber: scripts/audit_sort_icons.js inventory/state; shared/selector-map-partner-common.md (login); shared/selector-map-finance.md (CMS).

Portal: thead th[groupnya] / th.clicknya, ikon i.fa-sort/i.fa-sort-up/i.fa-sort-down; field groupnya dan arah sortnya. Harvest DOM aktual dan cocokkan label agar perubahan indeks tidak mengubah target. Verifikasi posisi ikon dengan elementFromPoint; jangan force klik atau dispatchEvent.
CMS: tombol .grid-field__sort pada header yang sesuai; indikator sorted-asc/sorted-desc/aria-sort.
Data: sel dari tabel header tersebut, bukan seluruh tabel halaman. Hanya hash nilai personal disimpan. Screenshot hanya failed.

SCR-01: /adminprahu/laporanpenjualanharian
SCR-02: /adminprahu/laporanpendapatanpertrip
SCR-03: /adminprahu/masterpelabuhan
SCR-04: /adminprahu/syaratdanketentuan
SCR-05: /adminprahu/userumum
SCR-06: /adminprahu/manifestkapal
SCR-07: /adminprahu/data_kendaraan_show
SCR-08: /adminprahu/daftarpiutang
SCR-09: /adminprahu/persetujuantiket
SCR-10: /adminprahu/pelanggan
SCR-11: /adminprahu/agen
SCR-12: /adminprahu/petugasscan
SCR-13: /adminprahu/hakAksesagen
SCR-14: /adminprahu/mastergolongan
SCR-15: /adminprahu/MasterCrew
SCR-16: /adminprahu/agen_riwayat_topup/R24wWEVIYmM1dk1jTWZUYXZzR2I2Zz09
SCR-17: /adminprahu/detailasuransi/71
SCR-18: /partner/laporanpenjualanharian
SCR-19: /partner/laporanpendapatanpertrip
SCR-20: /partner/daftarpiutang
SCR-21: /partner/persetujuantiket
SCR-22: /home/directprint
SCR-23: /partner/laporanPendapatanPenumpang
SCR-24: /admin/Finance/

## Diagnosis 16 Oktober 2026

Rekap Pendapatan: sel Kota Asal/Berangkat mengandung baris pertama kota beserta kode pelabuhan, lalu tanggal/waktu berangkat pada baris kedua. Field header pol/pod adalah kota asal/tujuan. Untuk retest urutan kota, proyeksikan baris pertama dan jangan memasukkan waktu. Contoh bentuk publik: `Parepare (PAP)` lalu `Kam, 22 Okt 2026 08:00 WITA`. DOM sel berupa DIV.

Kontrol jumlah data #valuelimit aktual berupa SELECT, nilai awal10, opsi10/20/50/100. Boleh pilih100 untuk mencari variasi data; hanya mengubah tampilan, tanpa seed atau perubahan bisnis.

Koreksi triage: `Balikpapan (BPN)` dan `Balikpapan (KRG)` memiliki kota sama; perbandingan seluruh label pertama dapat memberi false positive karena kode. Untuk field kota, hilangkan kode akhir dalam kurung sebelum membandingkan. Urutan sekunder kode belum didefinisikan, tidak diasumsikan sebagai bug. Bukti DOM publik: artifacts/sorting/20261016-065505/dom-diagnosis.json.

## Validasi Nama Lengkap setelah perbaikan16Oktober

Nama yang terisi dibandingkan A–Z/Z–A. Label tampilan `null` tetap dapat muncul di awalASC; posisi label kosong bukan assertion pengurutan nama. Tidak menyimpulkan tipeDB dari label ini. Oracle mendukung emptyPlaceholders opt-in; runner --name-null-placeholder hanya menerapkannya keNamaLengkap. Indeks placeholder yang diabaikan disimpan dalamcheck.

Regresi oracle memastikan urutan W-TEST→A-TEST danT-TEST→A-TEST tetap gagal walaupun null dikecualikan. Ini tidak menghapus kegagalan nyata run074439. Pada080927 kesalahan tersebut sudah hilang; satu pelanggaran mentah tersisa hanya labelnull→A. BuktiASC baru artifacts/screenshots/20261016-081257/SCN-0006-ASC.png.
