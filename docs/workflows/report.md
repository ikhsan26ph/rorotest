# report

Semua path relatif terhadap root repository. Baca `docs/agent-guide.md` terlebih dahulu.

Parameter: `$1` adalah nama modul; `$ARGUMENTS` adalah argumen pengguna untuk workflow ini. Adapter meneruskannya dari slash command atau instruksi biasa. Baca dokumen `docs/roles/<peran>.md` untuk setiap peran yang disebut.

Generate report Excel dari file hasil di `results/`.

- Jika $ARGUMENTS kosong → pakai file hasil PALING BARU di `results/` (abaikan file `_plan__*`).
- Jika $ARGUMENTS berisi nama modul → pakai run terbaru modul tersebut.
- Jika $ARGUMENTS berisi path file JSON → pakai file itu.
- Jika $ARGUMENTS = `all` → gabungkan seluruh run terbaru per modul menjadi satu workbook rekap lintas modul (`python scripts/generate_report.py --all`).

Jalankan `python scripts/generate_report.py <file...>`, lalu beri tahu user lokasi file Excel di `reports/` beserta ringkasan angka Summary-nya.

Untuk permintaan laporan analisis user umum/order tahun 2025–2026, bukan hasil
pengujian, gunakan `python scripts/generate_report.py --sales-analysis <input-analisis.json>`
sesuai skema di `docs/agent-guide.md`. Verifikasi snapshot order dan rute lengkap,
total order pada tabel mingguan/bulanan/rute konsisten, dan total user gabungan
merupakan jumlah ID pembeli berbeda (bukan jumlah user per tahun/minggu/rute).
