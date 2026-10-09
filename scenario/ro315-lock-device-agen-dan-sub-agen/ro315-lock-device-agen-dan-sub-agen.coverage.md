# Coverage — ro315-lock-device-agen-dan-sub-agen

Tanggal peninjauan: 8 Oktober 2026 (Asia/Jakarta). Review dilakukan terhadap artefak; aplikasi RORO dan workload belum dijalankan.

## Ringkasan

| Kategori | Jumlah |
|---|---:|
| positive | 50 |
| negative | 55 |
| edge | 42 |
| stress | 15 |
| **Total** | **162** |

39/39 requirement mempunyai ≥1 positive dan ≥1 negative. REQ-001–REQ-032 berasal dari spec; REQ-033–REQ-039 provisional dari HTML (46 scenario primer). Requirement primer di JSON/tag menentukan RTM; coverage sekunder tidak menggantikan kewajiban positive/negative primer.

13/13 layar/dialog disentuh steps; 107/107 elemen penting dalam scope tersentuh. Satu elemen tambahan inventory ditunda dengan alasan eksplisit (lihat gap). Edge/stress mencakup batas nama/kode, data Unicode/XSS, retry, race approval/revoke, status cache, isolasi serta volume.

## Requirements Traceability Matrix

| REQ | Deskripsi | Positive / Negative / Edge / Stress | Scenario IDs |
|---|---|---|---|
| REQ-001 | Cakupan role | 3/3/0/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-001<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-001<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-007<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-007<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-013<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-013 |
| REQ-002 | Urutan autentikasi | 1/4/0/1 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-014<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-014<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-015<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-016<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-017<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-001 |
| REQ-003 | Akses perangkat Aktif | 2/2/0/1 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-002<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-002<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-008<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-008<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-002 |
| REQ-004 | Perangkat baru | 2/2/0/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-003<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-003<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-009<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-009 |
| REQ-005 | Login perangkat Menunggu | 2/2/0/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-004<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-004<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-010<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-010 |
| REQ-006 | Login perangkat Ditolak | 2/2/0/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-005<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-005<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-011<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-011 |
| REQ-007 | Login perangkat Dicabut | 2/2/0/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-006<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-006<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-012<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-012 |
| REQ-008 | Identitas akun/device/browser | 1/1/3/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-015<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-018<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-001<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-002<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-003 |
| REQ-009 | Status server terbaru | 1/1/1/2 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-016<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-019<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-017<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-005<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-015 |
| REQ-010 | Layar verifikasi | 1/1/0/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-017<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-020 |
| REQ-011 | String Code unik | 1/1/1/1 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-018<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-021<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-007<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-003 |
| REQ-012 | Nama Perangkat opsional | 2/1/2/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-019<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-020<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-022<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-008<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-009 |
| REQ-013 | Pengiriman dan payload | 1/1/0/1 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-021<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-023<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-013 |
| REQ-014 | Status setelah pengiriman | 1/1/0/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-022<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-024 |
| REQ-015 | Idempotensi request | 1/1/3/1 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-023<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-025<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-004<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-005<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-006<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-004 |
| REQ-016 | Sinkronisasi halaman | 1/1/2/1 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-024<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-026<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-018<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-019<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-006 |
| REQ-017 | Navigasi Kantor Pusat | 1/1/0/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-025<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-027 |
| REQ-018 | Histori per akun | 1/1/0/1 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-026<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-028<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-007 |
| REQ-019 | Label jenis akun | 1/1/0/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-027<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-029 |
| REQ-020 | Informasi cabang | 1/1/0/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-028<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-030 |
| REQ-021 | Relasi Agen induk | 1/1/0/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-029<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-031 |
| REQ-022 | Informasi perangkat | 1/1/0/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-030<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-032 |
| REQ-023 | Tanggal dan waktu | 1/1/1/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-031<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-033<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-020 |
| REQ-024 | Identitas pemroses | 1/1/1/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-032<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-034<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-021 |
| REQ-025 | Approval Kantor Pusat | 2/1/1/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-033<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-034<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-035<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-016 |
| REQ-026 | Aksi Menunggu | 1/1/1/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-035<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-036<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-015 |
| REQ-027 | Aksi Aktif | 1/1/1/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-036<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-037<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-041 |
| REQ-028 | Aksi Ditolak | 1/1/0/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-037<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-038 |
| REQ-029 | Aksi Dicabut | 1/1/0/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-038<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-039 |
| REQ-030 | Aktifkan kembali | 2/1/1/1 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-039<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-040<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-040<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-042<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-010 |
| REQ-031 | Pergantian perangkat | 1/1/0/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-041<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-041 |
| REQ-032 | Larangan Agen induk | 1/4/0/1 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-042<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-042<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-043<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-044<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-045<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-014 |
| REQ-033 | Format kode prototipe | 1/3/4/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-043<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-046<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-047<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-048<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-011<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-012<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-013<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-014 |
| REQ-034 | Batas nama prototipe | 1/1/1/1 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-044<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-049<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-010<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-012 |
| REQ-035 | Alasan dan catatan prototipe | 2/2/3/1 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-045<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-046<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-050<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-051<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-022<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-023<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-024<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-011 |
| REQ-036 | Filter prototipe | 1/1/3/1 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-047<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-052<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-025<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-026<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-027<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-008 |
| REQ-037 | Tab dan tampilan data prototipe | 1/1/1/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-048<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-053<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-028 |
| REQ-038 | Batas dua perangkat prototipe | 1/1/3/1 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-049<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-054<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-029<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-030<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-031<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-STR-009 |
| REQ-039 | Kontrol UI pendukung | 1/1/9/0 | RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-POS-050<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-NEG-055<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-032<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-033<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-034<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-035<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-036<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-037<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-038<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-039<br>RO315-LOCK-DEVICE-AGEN-DAN-SUB-AGEN-EDG-040 |

## Coverage layar dan elemen penting

| Layar/dialog | Elemen tersentuh / dalam scope | Scenario primer | Scenario menyentuh layar |
|---|---:|---:|---:|
| login | 5/5 | 30 | 37 |
| verifikasi-perangkat | 11/11 | 26 | 36 |
| menunggu-persetujuan | 9/9 | 12 | 21 |
| perangkat-ditolak | 5/5 | 2 | 7 |
| perangkat-dicabut | 6/6 | 4 | 8 |
| dashboard | 3/3 | 8 | 52 |
| manajemen-device | 35/35 | 35 | 118 |
| registrasi-device | 8/8 | 20 | 33 |
| tolak-permintaan | 4/4 | 4 | 6 |
| cabut-perangkat | 4/4 | 4 | 11 |
| detail-perangkat | 8/8 | 6 | 10 |
| aktifkan-kembali | 5/5 | 8 | 10 |
| batas-perangkat-aktif | 4/4 | 3 | 3 |

Semua tombol, input/dropdown/radio dalam scope, status, pesan utama, kolom wajib, detail/histori, empty state dan pagination diperiksa minimal sekali. `screen` pada JSON/tag adalah layar utama skenario; skenario lintas layar mencantumkan layar setiap action pada target.

## Gap dan keterbatasan

- Tidak ada gap terhadap requirement normatif atau elemen penting yang masuk scope.
- `perangkat-ditolak / Ajukan Permintaan Baru`: ditunda menurut A06. Rekomendasi setelah aturan tersedia: pengajuan ulang harus mempunyai kode/request baru, tidak menghapus histori Ditolak, dan tetap meminta approval Kantor Pusat.
- Batas dua perangkat, format kode, max nama, alasan wajib, filter dan pagination perlu konfirmasi sebagai aturan produk karena hanya ditemukan di HTML. Coverage ada, tetapi bukan bukti aturan telah disetujui.
- Pagination HTML hardcoded satu halaman, ukuran halaman dan sorting tidak memiliki handler. Skenario pagination memeriksa rancangan provisional; sorting di luar scope karena perilakunya belum didefinisikan.
- Nama Perangkat wajib di prototipe dan toleransi sesi 5 menit bertentangan dengan spec. Oracle mengikuti Nama Perangkat opsional dan pemutusan akses pada pemeriksaan server berikutnya; dua konflik ini merupakan temuan sumber, bukan kekurangan coverage.
- Nomor telepon Kantor Pusat belum dikonfirmasi. Bantuan diperiksa sebagai informasi; nomor placeholder tidak dijadikan data produksi.
- Mekanisme/SLA pembaruan otomatis belum diberikan. Pilihan inline status atau redirect sah selama status terbaru terdeteksi otomatis dan hak akses benar. Gunakan timeout environment yang disepakati saat menjalankan test, bukan angka SLA rekaan.

## Hasil validasi Gherkin dan JSON

- LULUS parsing dengan `gherkin-official`; AST dan compiler Pickles menghasilkan 162 Scenario dan 162 Pickle.
- LULUS korespondensi 1:1 ID/judul/tag kategori/priority/REQ/screen antara AST Gherkin dan JSON; semua ID dan judul unik.
- LULUS Given/precondition, When/action, Then/assertion hadir pada setiap Scenario; jumlah dan urutan steps cocok; nilai fill/select/navigate dan expectation JSON diverifikasi terhadap teks AST.
- LULUS seluruh field skema, action yang diizinkan, tipe nilai, kecocokan role locator, selectorHints untuk semua target dan urutan expected sesuai steps.
- LULUS summary total/per kategori cocok dengan hitungan aktual; setiap REQ memiliki positive/negative; seluruh 13 layar/dialog tersentuh; elemen penting dalam scope lengkap.
- LULUS source menunjuk spec dan HTML yang benar; designs kosong sesuai input. Testid/ARIA merupakan usulan dan perlu pemetaan ke DOM nyata.

## Duplikasi dan overlap

- Tidak ada duplikat ID, judul, atau kombinasi steps + fixture/cases/workload identik. Tidak ada scenario yang dibuang.
- Overlap login dipertahankan untuk menguji kedua role, scope role dengan cache role lama, routing setiap status, dan akses URL/fitur langsung; fixture/oracle membedakan tujuannya.
- Nama kosong positive memeriksa request/data tersimpan; negative memeriksa tidak ada required error/disabled. Race dua pengiriman, retry setelah commit dan 100 pengiriman sama memeriksa failure mode berbeda.
- Aksi per status dibedakan dari transisi sukses/gagal, kewenangan induk, proses yang dibatalkan, dan race; tidak dihitung sebagai duplikat hanya karena memakai tombol sama.

## Catatan untuk codegen Playwright

- `route:<screen>` dipetakan ke URL environment; `route:jual-tiket` adalah URL fitur langsung. Jangan melakukan page.goto pada literal placeholder.
- `target` berbentuk `context|screen|element`; fixture memilih page/konteks dan membatasi aksi baris dengan requestId/rowScope/rowScopeByStep. Pusat memakai sesi berizin; konteks kedua harus dipetakan ke aktor sesuai preconditions.
- Isi `fixture.initialConditions` adalah kondisi awal authoritative. Field seed sintetis dan overrides di fixture memudahkan implementasi; buat/reset data sesuai kondisi, termasuk deviceId/accountId per konteks.
- `fixture:<parameter>` diisi kredensial atau data kasus/workload; `cases` mereset kondisi per kasus. Kredensial contoh bukan akun produksi.
- `expect.value.matcher` menjelaskan visible/hidden/enabled/disabled/text/value/rowCount/rows/timestamps serta invariant. Map assertion tampilan ke locator Playwright; `serverInvariant` dan kriteria server pada matcher lain diverifikasi melalui trace/adapter read-only fixture ke server, bukan sekadar toBeVisible.
- Password/date tidak selalu memiliki role textbox; gunakan label/testid. Tombol custom/ikon membutuhkan accessible name; nama di inventory adalah usulan. check dipakai untuk radio pilihan perangkat lama.
- `race` mengatur barrier/interleaving lintas konteks, `fault` mengintersep error sebelum/sesudah commit, `unauthorizedProbe` memverifikasi endpoint existing memakai sesi induk. Jangan memalsukan hasil otorisasi di fixture.
- `workload` di stress memerlukan orkestrasi nyata dan assertion untuk setiap konteks; metadata jumlah sesi tidak berarti test telah dijalankan. Sesuaikan identitas/kredensial/rowScope tiap sesi. Skenario gagal status service memakai prinsip fail-closed, bukan kontrak SLA baru.

## Integritas sumber

Agent hanya membaca inputs; SHA-256 sumber pada review:

| Sumber | SHA-256 |
|---|---|
| spec.txt | `7a46c6f53d8e63165a11211308661b75a22af55e968dbbacd4974810647ad6db` |
| extras/1-lock-device-agen-dc.html | `7d0b125d783cba856fee6b2ab45809b3ac94021d23ec75eef9e229e5616f4c39` |

