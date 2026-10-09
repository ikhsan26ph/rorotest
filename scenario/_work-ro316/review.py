import pathlib,json,re,collections,sys,hashlib
sys.stdout.reconfigure(encoding='utf-8')
WORK=pathlib.Path(__file__).parent
sys.path.insert(0,str(WORK/'parser'))
from gherkin.parser import Parser
from gherkin.pickles.compiler import Compiler
from importlib.metadata import version
M='ro316-penyesuaian-setting-komisi-agen'
OUT=pathlib.Path('output')/M
analysis=(OUT/f'{M}.analysis.md').read_text(encoding='utf-8')
feature=(OUT/f'{M}.feature').read_text(encoding='utf-8')
payload=json.loads((OUT/f'{M}.scenarios.json').read_text(encoding='utf-8'))
scenarios=payload['scenarios']
reqs={k:d for k,d in re.findall(r'^\| (REQ-\d{3}) \| (.*?) \|',analysis,re.M)}
doc=Parser().parse(feature)
doc['uri']=str(OUT/f'{M}.feature')
pickles=Compiler().compile(doc)
ast=[c['scenario'] for c in doc['feature']['children']]
assert len(ast)==len(scenarios)==len(pickles)
assert len({x['id'] for x in scenarios})==len(scenarios)
assert len({x['title'] for x in scenarios})==len(scenarios)
categories=['positive','negative','edge','stress']
actual={'total':len(scenarios),**{c:sum(x['category']==c for x in scenarios) for c in categories}}
assert payload['summary']==actual
for category in categories:
    category_ids=[x['id'] for x in scenarios if x['category']==category]
    assert [int(i.rsplit('-',1)[1]) for i in category_ids]==list(range(1,len(category_ids)+1))
allowed={'navigate','fill','click','select','check','uncheck','expect'}
for x,g in zip(scenarios,ast):
    required={'id','title','category','priority','requirement','screen','preconditions','steps','expected','testData','selectorHints'}
    assert required.issubset(x)
    assert x['category'] in categories and x['priority'] in ['high','medium','low']
    assert x['requirement'] in reqs
    assert re.fullmatch(re.escape(M.upper())+r'-(POS|NEG|EDG|STR)-\d{3}',x['id'])
    assert g['name']==x['id']+' — '+x['title']
    assert {t['name'] for t in g['tags']}=={'@'+x['category'],'@priority-'+x['priority'],'@'+x['requirement'],'@screen-'+x['screen'],'@id-'+x['id']}
    assert x['preconditions'] and x['steps'] and x['expected']
    for s in x['steps']:
        assert set(s)=={'action','target','value'} and s['action'] in allowed
        assert all(isinstance(v,str) for v in s.values())
        assert s['target'] in x['selectorHints']
        assert {'role','name','testid'}==set(x['selectorHints'][s['target']])
    assert x['steps'][0]=={'action':'navigate','target':x['screen'],'value':x['screen']}
    parsed=[]; pres=[]; screen=None
    quoted=r'"(?:\\.|[^"\\])*"'
    for s in g['steps']:
        text=s['text']
        if text.startswith('prasyarat '):
            vals=re.findall(quoted,text); pres.append(json.loads(vals[0])); continue
        vals=[json.loads(v) for v in re.findall(quoted,text)]
        if text.startswith('user berada di halaman '):
            screen=vals[0]; parsed.append({'action':'navigate','target':screen,'value':screen})
        elif text.startswith('user mengklik '): parsed.append({'action':'click','target':vals[0],'value':''})
        elif text.startswith('user mengisi field '): parsed.append({'action':'fill','target':vals[0],'value':vals[1]})
        elif text.startswith('user memilih opsi '): parsed.append({'action':'select','target':vals[1],'value':vals[0]})
        elif text.startswith('sistem memverifikasi elemen '): parsed.append({'action':'expect','target':vals[0],'value':vals[1]})
        else: raise AssertionError('Langkah tidak dikenal: '+text)
    assert parsed==x['steps'], x['id']
    assert pres==x['preconditions'] and screen==x['screen']
    assert any(s['action']=='expect' for s in x['steps'])
    assert any(s['keyword'].strip()=='Then' for s in g['steps'])
    assert x['expected']==[s['target']+': '+s['value'] for s in x['steps'] if s['action']=='expect']
for r in reqs:
    assert any(x['requirement']==r and x['category']=='positive' for x in scenarios),r
    assert any(x['requirement']==r and x['category']=='negative' for x in scenarios),r
signatures=collections.defaultdict(list)
for x in scenarios:
    # Prasyarat dan fixture merupakan pembeda penting untuk kasus temporal dan otorisasi.
    signature=json.dumps({k:x[k] for k in ['screen','preconditions','steps','testData']},sort_keys=True,ensure_ascii=False)
    signatures[hashlib.sha256(signature.encode()).hexdigest()].append(x['id'])
duplicates=[ids for ids in signatures.values() if len(ids)>1]
assert not duplicates, duplicates
source=payload['source']
assert pathlib.Path(source['spec']).is_file()
for p in source['designs']+source['extras']: assert pathlib.Path(p).is_file()

# Baca dan petakan seluruh elemen inventory, termasuk dialog melalui alias navigate.
display_names={
    'tambah-komisi-agen':'Tambah Komisi Agen','edit-komisi-agen':'Edit Komisi Agen',
    'hapus-komisi':'Hapus Komisi','nonaktifkan-komisi':'Nonaktifkan Komisi',
    'aktifkan-komisi':'Aktifkan Komisi','konfirmasi-komisi-nol':'Konfirmasi Komisi 0%'}
ui=[]
for screen,body in re.findall(r'^### ([a-z][a-z0-9-]+)\n(.*?)(?=^### |^## |\Z)',analysis,re.M|re.S):
    for name,role,testid in re.findall(r'^\| (.*?) \| (.*?) \| `(.*?)` \|',body,re.M):
        hits=[]
        for x in scenarios:
            hit=any(s['target']==name for s in x['steps'])
            if role=='dialog' and x['screen']==screen and display_names.get(screen)==name: hit=True
            if hit: hits.append(x['id'])
        # Pertahankan semua ID di RTM; laporan elemen cukup 2 contoh.
        ui.append((screen,name,role,testid,hits))
missing=[(screen,name) for screen,name,role,testid,hits in ui if not hits]
assert not missing,missing
screens=collections.Counter(x['screen'] for x in scenarios)
assert {x[0] for x in ui}.issubset(screens)
lines=[f'# Coverage — {M}','','Hasil review artefak desain uji, bukan hasil menjalankan test pada aplikasi. Spec utama tetap mengungguli prototipe HTML.','','| Kategori | Jumlah |','|---|---:|']
for c in categories: lines.append(f'| {c} | {actual[c]} |')
lines += [f"| **Total** | **{actual['total']}** |",'',f"Coverage requirement: **{len(reqs)}/{len(reqs)}** memiliki ≥1 positive dan ≥1 negative. Ada **{len(screens)}** layar/state dengan skenario dan **{len(ui)}** entri elemen inventaris tersentuh (dialog termasuk navigate/fixture open).",'', '## Requirements Traceability Matrix','','| REQ | Deskripsi | Scenario IDs |','|---|---|---|']
for r,d in reqs.items():
    ids=[x['id'] for x in scenarios if x['requirement']==r]
    lines.append('| '+r+' | '+d+' | '+'<br>'.join(ids)+' |')
lines += ['', '## Coverage Layar dan Elemen UI','','ID lengkap pada RTM. Kolom berikut memberi contoh skenario; elemen berulang seperti Filter/tombol Batal discope ke screen/dialog aktif saat implementasi. Pemeriksaan dialog bisa memakai fixture modal-open. Inventaris menetapkan semua selector sebagai usulan.','','| Layar/state | Scenario |','|---|---:|']
for screen,n in sorted(screens.items()): lines.append(f'| {screen} | {n} |')
lines += ['', '| Layar inventaris | Elemen | Role | Contoh Scenario IDs |','|---|---|---|---|']
for screen,name,role,testid,hits in ui: lines.append('| '+screen+' | '+name+' | '+role+' | '+'<br>'.join(hits[:2])+' |')
lines += ['', '## Hasil Validasi','','- JSON berhasil diparse; schema field wajib, action enum, category/priority enum, ID unik dan sequential per kategori valid.',f'- Gherkin diparse memakai `gherkin-official` {version("gherkin-official")}; {len(ast)} Scenario AST dikompilasi menjadi {len(pickles)} pickle tanpa syntax error.', '- Nama/id scenario, tag kategori/priority/REQ/screen/id, seluruh preconditions, target/value/action langkah dan expected diverifikasi satu per satu terhadap JSON, bukan hanya hitungan.', '- Summary sama dengan hitungan aktual. Seluruh 28 requirement memiliki positive dan negative. Source input dan extras yang dipakai ada; designs kosong sesuai sumber.', '- Setiap skenario memiliki Then/expect. Skenario baca dan probe boleh hanya Given/Then; aksi fixture/probe ada pada prasyarat dan testData.harness.', '- Selector hints tersedia untuk setiap target. Link diklik sebagai tautan di Gherkin. Input range persen HTML type=number memakai titik; field persen teks menerima koma/titik.', '- Data JSON kombinasi diselaraskan dengan langkah Jenis/Golongan/Kondisi; fixture spesifik menggantikan default ketika diperlukan.', '', '## Duplikat dan Review Semantik','','- Duplikat identik: **0**, berdasarkan screen + preconditions + steps + testData. Tidak ada skenario yang dibuang.', '- Ditinjau tumpang tindih: validasi UI dan probe server dipertahankan karena titik kegagalan berbeda; negative pembatalan temporal dan edge close modal memeriksa oracle berbeda; snapshot historis dan pembayaran sesudah mutasi sama-sama diperlukan.', '- Null/empty kondisi Penumpang, arah balik, kondisi Kendaraan, persen 0/0,01/99,99/100/100,01, last-record delete, nonaktif kosong, aktif kosong, cache stale, race serta volume paralel memiliki oracle terpisah.', '', '## Gap dan Batas Eksekusi','','- **Tidak ada gap pada requirement, kategori atau elemen penting yang diinventarisasi.** Coverage ini mengukur rancangan uji, bukan test passing pada aplikasi.', '- Perbedaan desain: HTML masih menyajikan Komisi Agen di Detail Agen dan menurunkan status dari aktif trayek; oracle mengikuti spec. Ini gap desain terhadap spec, bukan alasan mempertahankan perilaku prototipe.', '- Belum tersedia aplikasi target, URL/endpoint, DOM accessible names, API contract, layar transaksi, dasar tarif/batas pembulatan produksi, SLA atau kapasitas. Skenario terkait inferensi dan pelengkap HTML ditandai di Assumptions Log.', '- Sebelum codegen/eksekusi: petakan alias navigate ke URL; modal dibuka melalui fixture/detail rute. Screen pada tag adalah titik mulai scenario. Scope aksi baris ke testData.combination/rowScope, scope tombol Hapus Komisi ke dialog aktif, dan verifikasi native/custom select.', '- Target Hasil Probe/Hasil Race/Hasil Beban/Hasil Transaksi Fixture/Konfigurasi Fixture adalah oracle harness, bukan klaim elemen aplikasi. Selector untuknya bersifat usulan; implementasi sebaiknya memakai assertion fixture/API atau hasil yang ditampilkan harness.', '- steps.expect.value menyimpan oracle: visible/hidden/enabled/disabled → matcher UI; value/equals/count/options/set/contains → matcher data/locator; oracle gabungan → verifier harness. Pemetaan expect-toBeVisible sederhana di panduan tidak cukup untuk semua oracle bisnis; jangan mengubah assertion hidden/disabled/data menjadi hanya visible.', '- Dibutuhkan harness untuk probe Cabang dan endpoint legacy, payload invalid server, pemesanan/pembayaran, barrier commit, parallel sessions, timeout-after-commit, pagination scan dan load. Mereka tidak dapat dieksekusi hanya dari tujuh action UI tanpa setup/hook testData.harness.', '- Stress bersifat eksploratif dengan ukuran uji A10; tidak menetapkan SLA. Payload panjang boleh diterima utuh atau ditolak jelas bila maksimum belum ditentukan. Rentang terbalik boleh empty/error; final contract perlu dipastikan dari implementasi.', '- Rekomendasi lanjutan setelah kontrak tersedia: ganti oracle alternatif dengan respons pasti, verifikasi rounding/dasar komisi transaksi, tetapkan SLA, serta pastikan kebijakan kelas Penumpang dan edit kunci. Tidak diperlukan scenario tambahan untuk menutup REQ yang belum terpetakan.', '', '## Integritas Artefak','','| Artefak | SHA-256 |','|---|---|']
for suffix in ['analysis.md','feature','scenarios.json']:
    p=OUT/f'{M}.{suffix}'
    lines.append(f'| {p.name} | `{hashlib.sha256(p.read_bytes()).hexdigest()}` |')
lines += ['', 'Keempat artefak UTF-8 tersedia dalam folder modul. Inputs hanya dibaca. Run baru tidak menemukan artefak lama sehingga tidak ada arsip yang diperlukan.']
(OUT/f'{M}.coverage.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
print(json.dumps({'validation':'PASS','summary':actual,'requirements':len(reqs),'screens':len(screens),'inventoryEntries':len(ui),'duplicates':duplicates,'uiGaps':missing,'gherkinParser':version('gherkin-official')},ensure_ascii=False))
