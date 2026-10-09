import pathlib, json, re, collections, datetime, shutil, sys
sys.stdout.reconfigure(encoding='utf-8')
M = 'ro316-penyesuaian-setting-komisi-agen'
ROOT = pathlib.Path.cwd()
OUT = ROOT/'output'/M
OUT.mkdir(parents=True, exist_ok=True)
old = [p for p in OUT.iterdir() if p.is_file() and p.suffix in ('.feature','.json','.md')]
if old:
    stamp = datetime.datetime.now(datetime.timezone.utc).isoformat(timespec='milliseconds').replace('+00:00','Z').replace(':','-').replace('.','-')
    archive = OUT/'_archive'/stamp
    archive.mkdir(parents=True, exist_ok=True)
    for p in old: shutil.move(str(p), str(archive/p.name))

req_text = [
('Menu Master > Master Komisi Agen dapat diakses Pusat dan Cabang; pengguna tanpa sesi tidak dapat mengakses data.', 'General Rules 1–3; Cabang 1'),
('Daftar menampilkan seluruh rute sistem, termasuk arah balik dan rute tanpa konfigurasi.', 'General Rules 6; Master 1'),
('Status Belum Disetting, Aktif, Tidak Aktif sesuai konfigurasi dan aktivasi komisi rute.', 'Master 2–5'),
('Komisi general mengikuti rute yang boleh dijual agen; tidak dibedakan per agen atau cabang.', 'General Rules 4–7; Setting 9'),
('Pusat menambah konfigurasi dengan rute, jenis, golongan, kelas/kondisi yang relevan, dan persentase wajib.', 'Master 6; Setting 1; asumsi A03'),
('Jenis Tiket berasal dari master jenis tiket sistem.', 'Setting 2'),
('Golongan Tiket bergantung pada Jenis Tiket; pilihan lama yang tidak sesuai harus direset/ditolak.', 'Setting 3'),
('Kelas/Kondisi mengikuti master jenis tiket; Kendaraan wajib memilih kondisi, Penumpang menggunakan null sesuai prototipe.', 'Setting 4; asumsi A04'),
('Persentase wajib numerik, nonnegatif, maksimal dua desimal; koma/titik desimal diterima.', 'Setting 5; extras parsePct; asumsi A03'),
('Persentase Komisi tidak boleh lebih dari 100%; batas 100% diterima.', 'Setting 6'),
('Kunci Rute + Jenis + Golongan + Kelas/Kondisi unik; duplikat ditolak dan diarahkan ke edit existing.', 'Setting 7–8'),
('Konfigurasi tersimpan berlaku bagi seluruh agen yang menjual kombinasi terkait dan transaksi baru sesudah simpan.', 'General Rules 8; Setting 9'),
('Hanya Pusat dapat mengedit persentase konfigurasi existing.', 'Edit 1–2'),
('Edit tidak boleh menghasilkan duplikat kombinasi dan tidak menganggap record sendiri duplikat.', 'Edit 3'),
('Edit berlaku setelah simpan untuk transaksi baru; snapshot komisi transaksi sebelumnya tetap.', 'Edit 4–5'),
('Hanya Pusat menghapus konfigurasi terpilih; kombinasi lain tetap tersimpan.', 'Hapus 1–2'),
('Kombinasi terhapus menjadi belum disetting; bukan record tersimpan dengan nilai 0%.', 'Hapus 3'),
('Penghapusan konfigurasi tidak mengubah komisi transaksi historis.', 'Hapus 4'),
('Hanya Pusat menonaktifkan komisi rute; status rute terpilih menjadi Tidak Aktif.', 'Nonaktifkan 1–3; Cabang 4'),
('Rute nonaktif tidak menggunakan setting untuk transaksi baru, setara belum disetting; konfigurasi tidak dihapus.', 'Nonaktifkan 4–6'),
('Hanya Pusat mengaktifkan kembali rute; konfigurasi existing berlaku lagi untuk transaksi baru.', 'Nonaktifkan 7–8; Cabang 4'),
('Cabang melihat konfigurasi Pusat secara read-only tanpa Tambah/Edit/Hapus/Nonaktif/Aktif.', 'Master 7; Cabang 2–4'),
('Perubahan Pusat menjadi data yang berlaku dan terlihat di seluruh Cabang.', 'Cabang 5'),
('Relasi Agen/Detail Agen tidak lagi memiliki section, list, tombol, action atau tabel Komisi Agen.', 'Relasi Agen 1–3'),
('Nilai komisi per agen tidak dapat disimpan lagi dan data legacy per agen tidak menjadi sumber komisi.', 'Relasi Agen 4–5'),
('Filter daftar rute/detail komisi, rentang tanggal/persen, empty state dan navigasi daftar bekerja konsisten.', 'Extras template; pelengkap UI, asumsi A08'),
('Modal tambah/edit/hapus/nonaktif/aktif mendukung konfirmasi, pembatalan, informasi dampak dan feedback.', 'Extras template; pelengkap UI, asumsi A05/A08'),
('Estimasi komisi dan konfirmasi 0% mengikuti nilai valid; 0% tersimpan berbeda dari belum disetting.', 'Extras TARIF, parsePct, mZero; pelengkap UI, asumsi A03/A09'),
]
REQ = {f'REQ-{i:03}': {'description':d,'source':s} for i,(d,s) in enumerate(req_text,1)}
assumptions = [
('A01','Tidak ada PNG di designs/. Inventaris berasal dari spec dan template HTML terdekode secara statis, tanpa menjalankan script HTML atau mengklaim pemeriksaan visual browser. Tidak ada extras biner terpisah; aset tertanam logo/font bukan sumber requirement.'),
('A02','Spec mengungguli HTML: tab/tabel Komisi Agen masih muncul di Detail Agen pada prototipe, namun harus dihilangkan. Status komisi rute tidak otomatis mengikuti aktif/tidak aktif trayek seperti contoh TRAYEK. Tidak diasumsikan rute nonoperasional pasti komisinya nonaktif.'),
('A03','Batas bawah 0%, field wajib, maksimal dua desimal, pemisah koma/titik, trim whitespace dan dialog 0% berasal dari HTML atau inferensi, karena spec hanya menyebut persen dan maksimum 100%. Nilai negatif, teks, notasi ilmiah dan separator campuran ditolak; tidak menebak batas panjang field lain.'),
('A04','Mengikuti HTML, kelas/kondisi Kendaraan wajib (Kosong/Isi Muatan); Penumpang menampilkan khusus Kendaraan dan menyimpan null. Jika master produksi menyediakan kelas Penumpang, fixture serta oracle harus disesuaikan. Rute read-only pada modal; perubahan kunci pada edit diuji dengan fixture/probe karena kontrol kunci mungkin dibatasi.'),
('A05','Alasan Nonaktif wajib non-whitespace mengikuti HTML; spec tidak mewajibkannya. Pembatalan/close modal tidak menyimpan. Error jaringan menampilkan feedback tanpa sukses palsu. Pesan negatif selain dua pesan persen dan duplikat dari HTML adalah oracle semantik, bukan teks literal kontrak.'),
('A06','Belum disetting, konfigurasi terhapus dan rute nonaktif menghasilkan komisi baru 0 sesuai HTML. Komisi transaksi memakai snapshot saat transaksi terbentuk, bukan saat pembayaran; titik berlaku ditentukan urutan commit server. Transaksi sebelum tambah/edit/hapus/nonaktif/aktif tidak dihitung ulang.'),
('A07','Tanpa URL, endpoint, locator DOM final, maupun layar transaksi dari desain: navigate.value memakai alias layar yang wajib dipetakan ke URL lingkungan; selectorHints adalah usulan. Role/name harus diverifikasi, selectOption hanya jika native select. Probe otorisasi/legacy, fixture race/load/timeout harus disediakan harness; schema steps tidak memiliki action API/paralel sehingga kontrak tersebut dicatat di testData.harness dan prasyarat. Skenario merupakan desain uji, belum eksekusi aplikasi.'),
('A08','Filter, page size 10/20/50, pagination, tombol Kembali/close dan sort adalah pelengkap dari HTML. Pagination/sort terlihat namun wiring prototipe tidak lengkap. UI date range diberi nama usulan Tanggal Awal/Akhir; rentang terbalik tidak boleh menampilkan hasil salah (error atau empty). Kontrol prototipe Role/Page bukan elemen produk. Tidak mengarang banner/tautan dari fungsi yang tidak dirender.'),
('A09','Data contoh berasal dari HTML; fixture diisolasi agar tidak bentrok SEED. Tarif 485000 untuk Dewasa; estimasi saja menggunakan pembulatan rupiah Math.round sesuai HTML. Formula komisi transaksi, dasar tarif dan kebijakan pembulatan produksi tidak tersedia, sehingga contoh memakai basis Rp1000000 yang hasilnya integral; ini bukan aturan finansial baru.'),
('A10','Tidak ada SLA atau kapasitas resmi. Load eksploratif: 10000 rute, 50000 konfigurasi, 100 sesi baca, 20 penulis, 1000 transaksi, durasi 60 detik; batas timeout harness 30 detik hanya penjaga uji, bukan acceptance SLA. Oracle stress fokus integritas, isolasi dan pemulihan; laporkan latensi/error tanpa ambang bisnis buatan.'),
('A11','Cabang dilarang menulis di UI maupun server. Sesi tanpa login ditolak; role Agen hanya dapat menjual rute yang diberikan fixture dan tidak diberi akses pengaturan. Status rute berkonfigurasi 0% tetap Aktif; hapus konfigurasi terakhir pada rute aktif membuat Belum Disetting. Rute nonaktif tanpa konfigurasi tetap Tidak Aktif sampai diaktifkan; aktifkan tanpa konfigurasi menghasilkan Belum Disetting.'),
('A12','Sinkronisasi Cabang diverifikasi pada fetch/refresh berikut setelah commit Pusat; spec tidak menentukan push real-time. Hasil cache lama tidak boleh berlaku untuk transaksi baru. Kontrol revisi edit concurrent bebas implementasi (serialisasi/reject konflik) asalkan tidak menimpa perubahan diam-diam atau membentuk data parsial.'),
]
analysis = [f'# Analysis — {M}', '', '## Requirements', '', 'Sumber utama: `inputs/'+M+'/spec.txt`. Sumber pendukung: `extras/desain-ro-1-5-4-master-komisi-agen.html` (template JSON terdekode dan logika komponen, dibaca sebagai teks).', '', '| ID | Requirement / acceptance criteria | Sumber |', '|---|---|---|']
for k,v in REQ.items(): analysis.append(f"| {k} | {v['description']} | {v['source']} |")
analysis += ['', '### Aktor dan hak akses', '', '| Aktor | Melihat | Mutasi |', '|---|---|---|', '| Kantor Pusat | Daftar rute dan detail komisi | Tambah, edit, hapus, nonaktif, aktif |', '| Kantor Cabang | Data Pusat pada menu Master Komisi Agen | Seluruh mutasi dilarang, termasuk probe server |', '| Agen | Transaksi rute/jenis yang berhak dijual | Tidak ada pengaturan komisi per agen |', '| Tanpa sesi | Tidak dapat mengakses data | Ditolak |', '', '### Aturan validasi', '', '| Data | Validasi | Dasar |', '|---|---|---|', '| Rute | Rute sistem terpilih, arah diperhitungkan; read-only pada modal | Spec + HTML |', '| Jenis Tiket | Wajib; anggota master jenis | Spec + A03 |', '| Golongan Tiket | Wajib; anggota golongan jenis terpilih; reset saat jenis berubah | Spec + HTML |', '| Kelas/Kondisi | Kondisi wajib untuk Kendaraan; null untuk Penumpang | A04 |', '| % Komisi | Wajib; numerik 0–100 inklusif, <=2 desimal, koma/titik | Spec maksimum; lainnya A03 |', '| Kombinasi | Unik tanpa persentase, agen, cabang atau trayek sebagai pembeda | Spec |', '| Alasan Nonaktif | Wajib sesudah trim; panjang maks tidak ditentukan | A05 |', '| Filter | Rentang inklusif; tanggal null tidak cocok range tanggal; rentang terbalik tidak memberi hasil salah | HTML + A08 |', '', '### Alur dan oracle temporal', '', 'Pusat → Master → semua rute → Setting Komisi Rute → Tambah/Edit → validasi → Simpan → transaksi baru memakai konfigurasi committed. Duplikat → Edit baris yang ada. Hapus hanya kombinasi terpilih. Nonaktif menyimpan konfigurasi dan menonaktifkan penggunaannya. Aktif mengembalikan penggunaan existing. Cabang → menu yang sama → Komisi Rute read-only → refresh melihat hasil commit Pusat.', '', 'Fixture temporal: T0 terbentuk pada 5%, commit edit pada T1 menjadi 7,50%, T2 terbentuk sesudah commit; basis contoh Rp1000000, komisi T0 Rp50000 dan T2 Rp75000. Untuk tambah/hapus/nonaktif/aktif, rekam snapshot sebelum/sesudah dan bandingkan transaksi historis. Semua setup dilakukan fixture terisolasi, bukan perubahan inputs/.', '', '## Assumptions Log', '']
for k,v in assumptions: analysis.append(f'- **{k}** — {v}')
(OUT/f'{M}.analysis.md').write_text('\n'.join(analysis)+'\n',encoding='utf-8')
print('spec-analyzer selesai:',len(REQ),'requirements')

# Tahap design-analyzer membaca artefak spec-analyzer dari disk.
analysis_text=(OUT/f'{M}.analysis.md').read_text(encoding='utf-8')
UI = {}
def ui(screen,key,label,role='button',note='HTML; role/name/testid usulan'):
    UI.setdefault(screen,{})[key]={'role':role,'name':label,'testid':f'ro316-{screen}-{key}','note':note}
for screen in ['master-komisi-agen','setting-komisi-rute','komisi-rute']:
    ui(screen,'filter','Filter')
    ui(screen,'table','Daftar Rute' if screen=='master-komisi-agen' else 'Daftar Komisi','table')
    ui(screen,'status','Status','status')
ui('master-komisi-agen','menu-master','Master')
ui('master-komisi-agen','menu-komisi','Master Komisi Agen','link')
ui('master-komisi-agen','search-route','Rute','textbox','HTML placeholder Cari rute; scope panel Filter')
ui('master-komisi-agen','filter-status','Status','combobox')
ui('master-komisi-agen','date-from','Tanggal Awal','textbox','HTML type=date tanpa label mandiri; name/testid usulan')
ui('master-komisi-agen','date-to','Tanggal Akhir','textbox','HTML type=date tanpa label mandiri; name/testid usulan')
ui('master-komisi-agen','page-size','Jumlah Data','combobox','HTML Menampilkan Data 10/20/50; name usulan')
ui('master-komisi-agen','pager','Halaman Berikutnya')
ui('master-komisi-agen','sort-route','Urutkan Rute','button','Ikon sort HTML, perilaku usulan A08')
ui('master-komisi-agen','sort-date','Urutkan Terakhir Diubah','button','Ikon sort HTML, perilaku usulan A08')
ui('master-komisi-agen','setting','Setting komisi rute')
ui('master-komisi-agen','view','Lihat komisi rute')
for screen in ['setting-komisi-rute','komisi-rute']:
    for key,label,role in [('jenis-filter','Jenis Tiket','combobox'),('gol-filter','Golongan Tiket','textbox'),('kelas-filter','Kelas / Kondisi Kendaraan','combobox'),('pct-min','Komisi Minimum','spinbutton'),('pct-max','Komisi Maksimum','spinbutton'),('back','Kembali','button'),('breadcrumb','Master Komisi Agen','link')]: ui(screen,key,label,role)
for key,label in [('add','Tambah Komisi'),('edit','Edit komisi'),('delete','Hapus komisi'),('off','Nonaktifkan Komisi'),('on','Aktifkan Komisi'),('sort-kind','Urutkan Jenis Tiket'),('sort-pct','Urutkan Komisi')]: ui('setting-komisi-rute',key,label)
for screen in ['tambah-komisi-agen','edit-komisi-agen']:
    for key,label,role in [('dialog','Tambah Komisi Agen' if screen.startswith('tambah') else 'Edit Komisi Agen','dialog'),('route','Rute','generic'),('jenis','Jenis Tiket','combobox'),('gol','Golongan Tiket','combobox'),('kelas','Kelas / Kondisi Kendaraan','combobox'),('pct','% Komisi','textbox'),('save','Simpan Komisi','button'),('cancel','Batal','button'),('close','Tutup','button'),('dup-link','Edit baris yang ada','link'),('estimate','Estimasi komisi pada tarif berjalan','generic')]: ui(screen,key,label,role)
for screen,title,confirm in [('hapus-komisi','Hapus Komisi','Hapus Komisi'),('nonaktifkan-komisi','Nonaktifkan Komisi','Nonaktifkan'),('aktifkan-komisi','Aktifkan Komisi','Aktifkan'),('konfirmasi-komisi-nol','Konfirmasi Komisi 0%','Ya, Simpan 0%')]:
    ui(screen,'dialog',title,'dialog'); ui(screen,'confirm',confirm); ui(screen,'cancel','Kembali' if screen=='konfirmasi-komisi-nol' else 'Batal'); ui(screen,'close','Tutup')
ui('nonaktifkan-komisi','reason','Alasan','textbox','HTML textarea placeholder Contoh: Rute tidak beroperasi sementara karena kapal docking')
for key,label,role in [('profile','Nama Perusahaan Agen','generic'),('removed-tab','Komisi Agen','tab'),('removed-add','Tambah Komisi','button'),('removed-table','Komisi Agen','table')]: ui('detail-agen',key,label,role,'Spec; elemen komisi harus tidak ada meskipun HTML menampilkannya')
for key,label,role in [('route','Rute','combobox'),('jenis','Jenis Tiket','combobox'),('gol','Golongan Tiket','combobox'),('kelas','Kelas / Kondisi Kendaraan','combobox'),('sell','Buat Transaksi','button'),('commission','Komisi Agen','generic')]: ui('transaksi-agen',key,label,role,'Inferensi minimal dari spec; layar/label produksi tidak tersedia A07')
for key,label,role in [('commission','Komisi Agen','generic'),('snapshot','Persentase Komisi','generic')]: ui('detail-transaksi',key,label,role,'Inferensi minimal dari spec A07')
inventory=['## UI Inventory','','Inventaris statis; tidak ada PNG atau hasil render visual. Scope selector: panel Filter, dialog aktif, atau row berkunci kombinasi. Name tanpa bintang wajib dicocokkan ke accessible name aktual. Seluruh testid hanya usulan.','']
for screen,elements in UI.items():
    inventory += [f'### {screen}','','| Elemen / label | Role | data-testid usulan | Dasar / state |','|---|---|---|---|']
    for k,v in elements.items(): inventory.append(f"| {v['name']} | {v['role']} | `{v['testid']}` | {v['note']} |")
    inventory.append('')
inventory += ['### State dan pesan','','- Daftar/detail: populated dan empty `Tidak Ada Data yang tersedia`; status `Belum Disetting`, `Aktif`, `Tidak Aktif`.', '- Form: incomplete/invalid/duplicate → Simpan Komisi disabled; kelas Penumpang menampilkan `— (khusus Kendaraan)`; valid → estimasi; edit → pemberitahuan transaksi lama tetap.', '- Persentase invalid: `Format tidak valid. Gunakan angka dengan maksimal 2 desimal, contoh 3,50.`; di atas 100: `Nilai maksimal 100,00%.`.', '- Duplikat: `Kombinasi ini sudah memiliki komisi ...` dengan tautan `Edit baris yang ada`.', '- Sukses tambah/edit: `Komisi ditambahkan. Berlaku untuk transaksi baru.` / `Komisi diperbarui. Berlaku untuk transaksi baru.`.', '- Hapus: informasi kombinasi, jumlah agen terdampak dan transaksi sebelumnya tetap; nonaktif: konfigurasi dipertahankan dan Alasan wajib; aktif: transaksi masa nonaktif tidak dihitung ulang.', '- Cabang: tombol mutasi tidak dirender. Detail Agen: elemen komisi diharapkan absent menurut spec.', '- Loading/error jaringan tidak disediakan template; oracle semantik A05. Header, saldo, logo, menu lain dan switch Role/Page prototipe bukan elemen penting fitur ini.','']
analysis_text=analysis_text.replace('## Assumptions Log','\n'.join(inventory)+'\n## Assumptions Log')
(OUT/f'{M}.analysis.md').write_text(analysis_text,encoding='utf-8')
print('design-analyzer selesai:',len(UI),'layar/state')

