import csv,json,re,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parent.parent
run=sys.argv[1];directory=ROOT/'artifacts/fee-purchase'/run
data=json.loads((directory/'new-sync.json').read_text())
assert data.get('finishedAt') and not data.get('fatal'), 'Run belum selesai normal'
source=json.loads((ROOT/'scenario/fee-sync-new/fee-sync-new_scenarios.json').read_text())['scenarios']
assert len(data['methods'])==len(data['bookings'])==len(data['scenarios'])==len(source)==9
assert len({b['code'] for b in data['bookings']})==9
assert data['completedPayment'] is False and data['financeChangedByRun'] is False
rows=[];booking_rows=[]
for i,(m,s,actual) in enumerate(zip(data['methods'],source,data['scenarios']),1):
    for key in ['id','title','category','priority','screen','requirements']:assert s[key]==actual[key]
    assert actual['durationSec'] is not None
    order=json.loads((directory/'orders'/m.get('orderTag',f'order-{i:02}')/'order.json').read_text())
    assert order['savebookingCount']==1 and order['bookings'][0]['code']==m['booking']
    if actual['status']=='passed':
        for body,fee in [(m['initialBody'],m['initialFee']),(m['payment']['body'],m['payment']['fee'])]:
            values=re.findall(r'Biaya Admin\s*Rp\.?\s*([\d.]+)',body)
            assert values and all(int(value.replace('.',''))==fee for value in values)
        assert all(x['codeVisible'] for x in [m['detailBefore'],m['payment'],m['detailAfter']])
        assert len(m['detailBefore']['values'])==len(m['detailAfter']['values'])==1
        assert m['initialFee']==m['detailBefore']['fee']==m['payment']['fee']==m['detailAfter']['fee']
        assert m['initialTotal']==m['payment']['total']==m['gateway']['money']['amount']
        label_checks={'initial':[int(v.replace('.','')) for v in re.findall(r'Biaya Admin\s*Rp\.?\s*([\d.]+)',m['initialBody'])],'reload':[int(v.replace('.','')) for v in re.findall(r'Biaya Admin\s*Rp\.?\s*([\d.]+)',m['payment']['body'])],'scope':'Semua pasangan Biaya Admin/Rp dari rendered body; dua lokasi payment diperiksa, bukan diasumsikan satu.'}
        m['additionalPaymentLabelCheck']=label_checks
        details=json.loads(actual['notes']);details['allPaymentFeeLabels']=label_checks;actual['notes']=json.dumps(details,ensure_ascii=False)
    elif actual['status']=='failed':assert actual['error'] and Path(actual['screenshot']).stat().st_size>0
    else:assert actual['error']
    html=(directory/'orders'/m.get('orderTag',f'order-{i:02}')/'payment.html').read_text()
    expiry=re.search(r'id="isicountdown"[^>]*>(.*?)</span>',html,re.S)
    expiry=re.sub('<[^>]+>','',expiry[1]).strip() if expiry else 'Tidak terbaca'
    detail=m.get('detailBefore',{}).get('fee');payment=m.get('payment',{}).get('fee');after=m.get('detailAfter',{}).get('fee')
    rows.append([m['method'],m['booking'],m['financeBefore']['jumlah'],m['financeBefore']['processing'],m['components']['subtotal'],m.get('initialFee'),detail,payment,after,m.get('gatewayHTTP'),m.get('financeStable'),actual['status'],actual['error'] or ''])
    booking_rows.append(f"| {m['booking']} | {m['method']} | {order['bookings'][0]['scheduleId']} | {expiry} | pending |")
(directory/'new-sync.json').write_text(json.dumps(data,indent=2,ensure_ascii=False)+'\n')
(ROOT/'results'/f'fee-sync-new__{run}.json').write_text(json.dumps(data,indent=2,ensure_ascii=False)+'\n')
csv_path=ROOT/'reports'/f'fee-sync-new-matrix__{run}.csv'
with csv_path.open('w',encoding='utf-8-sig',newline='') as f:
    writer=csv.writer(f);writer.writerow(['Metode','KodeBaru','JumlahFinance','ProcessingFeeFinance','Subtotal','FeeAwal','FeeDetailSebelum','BiayaAdminPaymentReload','FeeDetailSesudah','GatewayHTTP','FinanceStablePerOrder','Verdict','Error']);writer.writerows(rows)
test_data=ROOT/'results'/f'_test-data__fee-sync-new__{run}.md'
test_data.write_text('# Order baru untuk sinkronisasi fee\n\nPengguna secara eksplisit meminta order baru;9booking baru ini berbeda dari run terdahulu. Satu tiket Dewasa/order, data fiktif dan kontak test dari config. Tidak ada pelunasan/otorisasi wallet/simulator. Finance tidak diubah oleh run.\n\n| Kode | Metode | Jadwal | Batas bayar UI saat persiapan | Cleanup |\n|---|---|---|---|---|\n'+'\n'.join(booking_rows)+'\n\nOrder belum lunas. Kontrol pembatalan langsung tidak ditemukan pada detail yang diperiksa; status cleanup tidak dianggap selesai dan kuota/saldo tidak dianggap kembali. Bukti HTML/observasi per order di artifacts/fee-purchase/'+run+'/; fee masing-masing detail/payment dibaca ulang fresh dengan kode sama.\n')
counts={s:sum(r['status']==s for r in data['scenarios']) for s in ['passed','failed','blocked','skipped']}
print(json.dumps({'runId':run,'bookings':9,'counts':counts,'financeSameAtEnd':data.get('financeSameAtEnd'),'matrix':str(csv_path),'testData':str(test_data)},ensure_ascii=False))
