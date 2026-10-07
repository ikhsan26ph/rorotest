#!/usr/bin/env python3
"""Susun hasil quote/akses halaman/rekonsiliasi terpisah; tidak menebak verdict finansial."""
import json
import re
from datetime import datetime, timezone
from pathlib import Path
from urllib.parse import urlsplit

ROOT = Path(__file__).resolve().parent.parent
AUDIT = ROOT / 'artifacts' / 'fee-audit'
page_files = sorted(AUDIT.glob('20*/pages.json'))
if not page_files:
    raise SystemExit('Bukti audit halaman tidak ditemukan')
pages = json.loads(page_files[-1].read_text())
if not pages.get('finishedAt'):
    raise SystemExit('Audit halaman masih berjalan; tunggu selesai sebelum report final')
finance = json.loads((AUDIT / 'finance/calculations.json').read_text())
baseline = json.loads((AUDIT / 'finance/baseline.json').read_text())
ledger = json.loads((AUDIT / 'finance/ledger-historical.json').read_text())
instructions = json.loads((AUDIT / 'instructions/instructions.json').read_text())
report_recon = json.loads((AUDIT / 'instructions/report-reconciliation.json').read_text())
cross = json.loads((AUDIT / 'order/cross-role.json').read_text()) if (AUDIT / 'order/cross-role.json').exists() else []
latest = {m['method']: m for m in instructions['methods']}
order = json.loads((AUDIT / 'order/order.json').read_text())
scenarios = json.loads((ROOT / 'scenario/biaya-admin/biaya-admin_scenarios.json').read_text())['scenarios']
run_id = pages['runId']
now = datetime.now(timezone.utc).isoformat()
results = []
metadata = ('id', 'title', 'category', 'priority', 'screen', 'requirements')
for s in scenarios:
    r = {k: s[k] for k in metadata}
    r.update(status='blocked', durationSec=None, error=None, screenshot=None, bugCandidate=None, notes='')
    number = int(s['id'].split('-')[-1])
    if number == 1:
        r['status'] = 'passed' if len(baseline['rows']) == 12 else 'blocked'
        r['notes'] = 'Snapshot 12 channel Finance; tidak ada kredensial pada bukti konfigurasi.'
    elif 2 <= number <= 10:
        method = s['title'].replace('Perhitungan biaya admin ', '').replace(' sebelum dan sesudah perubahan', '')
        c = next((c for c in finance['channels'] if c['method'] == method), None)
        if c:
            r['status'] = c.get('status', 'blocked')
            r['error'] = c.get('error') or (c.get('after', {}).get('error') if r['status'] != 'passed' else None)
            r['screenshot'] = c.get('screenshot')
            r['notes'] = json.dumps({
                'scope': 'Quote backend getFeeAdmin dan renderer showva; gateway/ledger dinilai pada SCN-0027/0025',
                'order': finance['booking'], 'harga': finance['components']['harga'], 'tarifPass': finance['components']['tarifPass'],
                'awal': c['original'], 'uji': c['changed'],
                'feeAwal': c.get('before', {}).get('api', {}).get('biayaadmin'),
                'feeUji': c.get('after', {}).get('api', {}).get('biayaadmin'),
                'totalUji': c.get('after', {}).get('expectedTotal'),
            }, ensure_ascii=False)
        else:
            r['error'] = 'Channel belum dieksekusi'
    elif 11 <= number <= 14:
        role = ['user', 'adminprahu', 'pusat', 'cabang'][number - 11]
        records = [p for p in pages['pages'] if p['role'] == role]
        r['durationSec'] = round(sum(p['durationSec'] for p in records), 2)
        own = next((x for x in cross if x['role'] == role), {})
        r['error'] = 'Rekonsiliasi seluruh halaman belum lengkap; akses tidak membuktikan hitungan, enam route timeout, pelunasan belum dilakukan.'
        r['notes'] = 'Detail order sendiri: ' + json.dumps(own, ensure_ascii=False) + '. '
        r['notes'] += json.dumps({'halamanDiperiksa': len(records), 'aksesPassed': sum(p['status'] == 'passed' for p in records), 'aksesBlocked': [p['route'] for p in records if p['status'] == 'blocked'], 'aksesFailed': [p['route'] for p in records if p['status'] == 'failed']}, ensure_ascii=False)
    elif 15 <= number <= 24:
        report_name = s['title'].replace('Rekonsiliasi laporan ', '')
        r['error'] = 'Rekonsiliasi kontribusi transaksi lunas/agen/asuransi/pembatalan belum dapat dieksekusi; belum ada konfirmasi dummy untuk pelunasan. Instruksi bayar dan debit awal sudah diuji.'
        r['notes'] = 'Halaman laporan dicatat pada report smoke terpisah. Laporan Pemakaian Saldo dapat memuat pemesanan belum lunas menurut rule; jangan menafsirkan semua laporan sebagai paid-only. ' + report_name
        if number == 21:
            checked = [x for x in report_recon['roles'] if x.get('status') == 'checked']
            valid = len(checked) == 3 and all(sum(bool(t['rows']) for t in x['ownRows']) == 7 and all(not t['rows'] or all('3.983' in z for z in t['rows']) for t in x['ownRows']) for x in checked)
            r.update(status='passed' if valid else 'blocked', error=None if valid else 'Rekonsiliasi saldo laporan tiga role belum lengkap.', notes=json.dumps({'roles': [{k:x[k] for k in ['role','summary','ownRows','status'] if k in x} for x in report_recon['roles']]}, ensure_ascii=False))
    elif number == 25:
        valid = len(latest)==9 and sum(m.get('newDebit',0) for m in latest.values())==27881 and all(m.get('newDebit')==(0 if m['method'] in ['Alfamart','Indomaret'] else 3983) for m in latest.values())
        r.update(status='passed' if valid else 'blocked',error=None if valid else 'Debit awal belum cocok.')
        r['notes'] = json.dumps({'debitAwal': [{'metode':m['method'],'kode':m['booking'],'debit':m.get('newDebit'),'status':m['status']} for m in latest.values()], 'totalDebit':sum(m.get('newDebit',0) for m in latest.values()), 'komisi': 'Debit teramati sesuai ceil(265500*1.5%)=3983; bukan subtotal+fee. Bukti setting pada report-reconciliation.json.'},ensure_ascii=False)
    elif number == 26:
        r['status'] = ('blocked' if any(b['cleanup']=='pending' for b in instructions['bookings']) else 'passed') if instructions.get('baselineRestored') else 'failed'
        r['error'] = 'Finance12 baris sudah pulih; sembilan booking masih pending, endpoint expiry respons1 belum membatalkan sebelum batas bayar dan belum ada kredit pengembalian untuk kode run.' if r['status']=='blocked' else (None if r['status']=='passed' else 'Konfigurasi Finance belum sama dengan snapshot awal.')
        r['notes'] = 'Seluruh 12 baris konfigurasi sama dengan snapshot awal. Booking run: ' + json.dumps(instructions['bookings'], ensure_ascii=False) + '. Status cleanup dicatat pada instructions.json dan cleanup.json; hanya booking milik run. Input nama menghapus angka/tanda hubung dari prefix AUTOTEST, sehingga keterlacakan memakai kode order dan jadwal.'
    elif number == 27:
        r.update(status='failed',error='Alfamart dan Indomaret pada order terpisah gagal HTTP 500 ApiException; tujuh metode lain sesuai nominal awal.',screenshot='artifacts/screenshots/biaya-admin-Alfamart-failed.png',bugCandidate='FND-01',notes=json.dumps({'metode':list(latest.values()),'scope':'Instruksi awal saja; OVO/DANA berhenti sebelum otorisasi wallet; tidak ada pembayaran selesai'},ensure_ascii=False))
    elif number == 28:
        r['status'] = 'passed' if ledger['allPassed'] and len(ledger['transitions']) == 19 else 'failed'
        r['error'] = None if r['status'] == 'passed' else 'Transisi saldo historis tidak cocok.'
        r['notes'] = f"{len(ledger['rows'])} transaksi historis; {sum(c['passed'] for c in ledger['transitions'])}/{len(ledger['transitions'])} transisi saldo sesuai. Tidak mengubah transaksi historis."
    elif number == 29:
        r.update(status='failed',error='QRIS L9134606 diterbitkan Rp321000 tetapi reload setelah Finance dipulihkan menampilkan Rp320640, termasuk totalforqr dan query amount simulator (tidak diklik).',screenshot='artifacts/screenshots/biaya-admin-QRIS-after-restore.png',bugCandidate='FND-03',notes='Bukti pending-totals.json dan qris-invoice-amount.json. Bank kembali ke pemilihan metode; persistensi bank belum ditetapkan verdict bug.')
    elif number == 30:
        r.update(status='failed',error='Order W9134565 setelah Alfamart gagal menolak alternatif Indomaret dan QRIS dengan DOUBLE_VA. QRIS pada order baru L9134606 berhasil.',screenshot='artifacts/screenshots/biaya-admin-QRIS-failed.png',bugCandidate='FND-02',notes='Tidak ada debit tambahan untuk upaya gagal; tidak menyelesaikan pembayaran.')
    results.append(r)

host = urlsplit(baseline['rows'][0]['edit'])
run = dict(module='biaya-admin', runId=run_id, startedAt=pages['startedAt'], finishedAt=now,
           environment={'baseUrl': f'{host.scheme}://{host.netloc}', 'user': 'Multi-role (akun test di config/env.md)', 'role': 'User Umum, Admin Prahu, Operator Pusat, Operator Cabang, Admin Finance'},
           scenarios=results, bookings=instructions['bookings'], financialEvidence={'baselineRestored':instructions.get('baselineRestored'),'completedPayment':False,'initialDebitTotal':sum(m.get('newDebit',0) for m in latest.values())})
result_file = ROOT / f'results/biaya-admin__{run_id}.json'
result_file.write_text(json.dumps(run, indent=2, ensure_ascii=False) + '\n')

smoke_results = []
for index, p in enumerate(pages['pages'], 1):
    smoke_results.append(dict(id=f"SMOKE-{p['role']}-{index:04}", title=f"Akses halaman {p['role']} {p['route']}", category='positive', priority='medium', screen=p['route'], requirements=['REQ-004'], status=p['status'], durationSec=p['durationSec'], error=p.get('error'), screenshot=p.get('screenshot'), bugCandidate=None,
        notes=json.dumps({'finalRoute': p.get('finalRoute'), 'httpStatus': p.get('httpStatus'), 'loadingUnresolved': p.get('loadingUnresolved', False), 'httpErrors': p.get('httpErrors', []), 'perhitungan': 'Belum dievaluasi; akses halaman bukan bukti rekonsiliasi finansial'}, ensure_ascii=False)))
smoke = dict(module='smoke-biaya-admin', runId=run_id, startedAt=pages['startedAt'], finishedAt=now, environment=run['environment'], scenarios=smoke_results)
smoke_file = ROOT / f'results/smoke-biaya-admin__{run_id}.json'
# ANSI escape logs tidak valid sebagai nilai cell Excel; raw evidence tetap disimpan.
def clean(value):
    if isinstance(value, str):
        return re.sub(r'[\x00-\x08\x0b\x0c\x0e-\x1f]', '', re.sub(r'\x1b\[[0-?]*[ -/]*[@-~]', '', value))
    if isinstance(value, list): return [clean(x) for x in value]
    if isinstance(value, dict): return {k:clean(v) for k,v in value.items()}
    return value
smoke_file.write_text(json.dumps(clean(smoke), indent=2, ensure_ascii=False) + '\n')
summary = {status: sum(s['status'] == status for s in results) for status in ['passed', 'failed', 'blocked', 'skipped']}
print(json.dumps({'results': str(result_file), 'smoke': str(smoke_file), 'summary': summary, 'halaman': len(smoke_results)}, ensure_ascii=False))
