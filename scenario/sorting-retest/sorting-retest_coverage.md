# Coverage retest sortir

Hasil final: results/sorting-retest__20261016-065823.json. Sumber43failed audit20261015-033838, ID SCN baru dipetakan melalui originalId. Semua43kasus dicoba,17memerlukan data tambahan/diagnosis. Tidak ada skipped.

| Akun | Passed | Failed | Blocked |
|---|---:|---:|---:|
| Admin Pusat | 11 | 1 | 7 |
| Operator Pusat | 7 | 0 | 2 |
| Operator Cabang Pare-Pare | 11 | 1 | 2 |
| Admin Finance | 1 | 0 | 0 |

Total30passed,2failed,11blocked. Koreksi oracle kota/kode menyelesaikan falsepositive3kasus; bukan perbaikan source aplikasi. Data homogen tetap blocked. Tidak mengklaim seluruh965kolom auditlama, setiap pagination, atau mobile sudah diuji ulang.

Eksekusi desktop1600px, read-only,4akun login berhasil dan context terpisah. Tidak ada booking/pembayaran/settings/fixture atau notifikasi. Artefak percobaan063731,064750 serta diagnosis064709/065505 dipertahankan. Excel dibuat lewat scripts/generate_report.py; triagefinal dengan suffix20261016-065823.

## Retest dua sisa,20261016-074439

SCN0034 sekarangpassed pada20/100baris(HTTP200 dua arah);SCN0006 tetapfailedASC, DESCpassed. Hasilbaru1passed/1failed;41kasus lain dari run065823 tidak diujiulang. Lihat results/sorting-recheck__20261016-074439.json dan Excelnama sama.

## Cek sekali lagi final20261016-082509

SCN0006 danSCN0034 kini2passed. Nama terisi ASC/DESC20/100, penempatanlabelnull dikecualikansecaraeksplisit;W/T→A sudahhilang. Cabang20/100 request200. Nama20recovery082509, Nama100/Cabang20/100 dari081349 pada permintaan sama; preconditionfail disimpan. Sebelasblocked lama tidakdiujiulang. JSON/Excel/triage final082509.
