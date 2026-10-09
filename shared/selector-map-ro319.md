# Selector RO319 — aplikasi aktual, 9 Oktober 2026

Sumber verifikasi: artifacts/ro319/discovery.json, own-inspection.json dan hasil retest RO319. Inventaris desain ada di scenario/ro319-setting-kuota-jadwal-ada-approval/ro319-setting-kuota-jadwal-ada-approval.analysis.md; accessible name/testid di sana adalah usulan.

Akun pembuat menggunakan Cabang Pare-Pare sesuai instruksi pengguna. Pusat memakai akun konfigurasi. Contoh Balikpapan/Suyanto/voyage214 tidak menentukan identitas test aktual.

| Elemen | Selector / binding aktual | Catatan |
|---|---|---|
| Daftar | `/partner/masterjadwal`, `#main-content` | Ada `#edit-content` tersembunyi; `.app-main__inner` tanpa scope ambigu. |
| Buat Jadwal | `a.btn-buat-trayek` → `/partner/tambahjadwal` | Link aktual memiliki NBSP sebelum teks. |
| Status daftar | `.quota-list-tab` dengan teks label | Pusat: Semua/Menunggu Approval/Aktif; Cabang: Semua/Menunggu Approval/Disetujui/Ditolak/Dibatalkan. |
| Respons tabel | POST `/partner/searchJadwal` | Tunggu response yang dipicu aksi lalu parse JSON; `jQuery.active===0` saja dapat terlalu dini sebelum request awal. Jangan memakai respons halaman sebelumnya. |
| Jumlah Data | `#valuelimit` | 10/20/50/100; oracle count/ID memakai dataset aktual. |
| Pagination | `#fi-pagination a[aria-label="Selanjutnya"]`, `a[aria-label="Sebelumnya"]` | Tidak ada URL langsung; aksi memicu AJAX. |
| Filter | `#btn-filter`, `#Tanggal_Buat` | Toggle tidak melakukan mutasi; cek ID record sebelum/sesudah. |
| Metadata tambah | `#trayek`, `#kapal`, `#kode_kapal`, `#nomor_voyage`, `#kapasitas` | Trayek5 Parepare-Balikpapan, Kapal2 KM.Swarna Bahtera; kapasitas aktual125000, Call SignPOKG. Baca nilai aktual setiap run. |
| Field kuota | Scope `tr` berdasar label kolom pertama, `input[id^="dist_"]` | Internal tidak memiliki `_eks` pada ID; Eksternal memiliki `_eks`. Jangan memakai total golongan desain sebagai konstanta. |
| Simpan Kuota | `#simpan-kuota` → POST `/partner/simpanKuota` | Handler yang dimuat pada form ini mewajibkan semua isian; respons ID dicatat untuk cleanup. Tidak menyediakan Simpan Draft/Simpan & Ajukan pada form yang diperiksa. |
| Tab Jadwal | `.tab-jadwal`, `input[name="tgl_etd"]`, `input[name="tgl_eta"]` | Observasi run: tab/field editable bahkan kuota belum lengkap; jangan menyatakan approved hanya karena tab terbuka. |
| Record sendiri | `#edit<ID>` pada baris `tr` | Ambil ID dari respons save; voyage pada form tidak ikut payload simpanKuota dan belum tersimpan sebelum simpanJadwal. |
| Keputusan approval | `[data-quota-id] [data-quota-list-action="approve/reject/cancel"]` | Kode daftar menampilkan hanya jika flags server mengizinkan. Belum ada record submission sendiri untuk memverifikasi keputusan. |
| Dialog keputusan | `#quota-list-dialog`, `[data-quota-decision-form]` | Handler memakai JadwalID/Round/Decision/Reason, confirmation over-capacity. Keberadaan kode bukan bukti alur berhasil. |
| Detail record | `a.btn-viewnya`, tab-list-detail dengan `ide=<ID>` | Jadwal/Crew List/Kuota/Riwayat; scope ke ID. |
| Cleanup sendiri | `a.delete-jadwal` pada baris ID sendiri → `.swal2-popup` tombol Hapus | POST cekdeletejadwal lalu deletejadwal. Verifikasi absence pada respons daftar dua role. Tidak menghapus data orang lain. |

Jangan klik Kirim ke Pelindo. Record2334 dibuat melalui Simpan Cabang pada form aktual: kuota1, tanpa Jadwal/Crew, server melaporkan workflow_version0/JadwalTampil dan record terlihat Pusat. Ini bukti entry point tersebut melewati gate RO319; bukan alasan memblokir karena nama cabang berbeda.
