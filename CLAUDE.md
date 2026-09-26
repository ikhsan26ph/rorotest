# Sistem Penjualan Tiket Kapal — Claude Code

Baca dan ikuti `docs/agent-guide.md` sebagai sumber utama aturan proyek.
Semua path relatif terhadap root repository.

Slash command di `.claude/commands/` meneruskan tugas dan argumen ke
`docs/workflows/`. Definisi `.claude/agents/` merujuk `docs/roles/`.
Gunakan peran secara berurutan; delegasi opsional mengikuti izin dan kemampuan sesi.
Konfigurasi browser MCP Claude ada di `.mcp.json`.
Perbarui prosedur bersama di `docs/`, bukan menyalinnya ke adapter ini.

Bagian "Aturan Wajib" di `docs/agent-guide.md` memuat aturan khusus sistem penjualan
tiket (PEMBAYARAN, KUOTA, JADWAL, NOTIFIKASI, DATA PENUMPANG, refund/pembatalan/tarif) —
WAJIB dibaca sebelum aksi tulis apa pun di browser. Catatan sesi tentang storageState dan
`dispatchEvent('click')` di sana berstatus HIPOTESIS BAWAAN DARI PROJECT OMS sampai
diverifikasi di aplikasi ini.
