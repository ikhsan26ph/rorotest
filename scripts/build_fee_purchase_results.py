"""Verdict dari angka/label actual run baru, tidak menganggap akses laporan sebagai rekonsiliasi."""
import json,re,sys
from pathlib import Path
from datetime import datetime,timezone
ROOT=Path(__file__).resolve().parent.parent
run_id=sys.argv[1];D=ROOT/'artifacts/fee-purchase'/run_id
read=lambda name:json.loads((D/name).read_text())
purchase=read('purchase.json');verification=read('verification.json');pending=read('pending-ready.json');reports=read('reports.json');retail=read('retail-quotes.json') if (D/'retail-quotes.json').exists() else {'channels':[]}
if not all(x.get('finishedAt') for x in [purchase,verification,pending,reports]):raise SystemExit('Tahap masih aktif; tidak membuat verdict final')
active=read('active-retry.json') if (D/'active-retry.json').exists() else {'channels':[]}
if (D/'reports-retry.json').exists():
 retry=read('reports-retry.json')
 if not retry.get('finishedAt'):raise SystemExit('Retry laporan masih aktif')
 reports['reports']=[next((q for q in retry['reports'] if q['role']==p['role'] and q['href']==p['href'] and q['status']=='observed'),p) for p in reports['reports']]
source=json.loads((ROOT/'scenario/fee-purchase/fee-purchase_scenarios.json').read_text())['scenarios'];results=[]
user=next((r for r in verification['roles'] if r['role']=='user'),{});views={v['code']:v for v in user.get('orders',[])};methods=purchase['methods']
metadata=('id','title','category','priority','screen','requirements')
notes=lambda x:json.dumps(x,ensure_ascii=False)
report_paths=['laporanpenjualanharian','laporanPendapatanPenumpang','laporanrincianpendapatankendaraan','laporanpendapatanpertrip','laporanpembatalantiket','laporanrekapasuransi','laporanpemakaiansaldo','laporanpenjualanharianagen','laporanrekappenjualanagen','laporanpembatalantiketagen']
for i,s in enumerate(source,1):
 r={k:s[k] for k in metadata};r.update(status='blocked',durationSec=None,error=None,screenshot=None,bugCandidate=None,notes='')
 if i<=9:
  m=methods[i-1];a=next((a for a in m.get('apiObservations',[]) if a['route']=='/home/apifaspay'),{});v=views.get(m.get('booking'),{});g=a.get('responseMoney',{}).get('amount');q=next((q for q in retail['channels'] if q['method']==m['method']),{});
  if a.get('httpStatus',0)>=400 or a.get('exception'):
   r.update(status='failed',error=f"{m['method']} pada order baru {m.get('booking')} HTTP{a.get('httpStatus')} {a.get('exception')}; instruksi bayar belum berhasil.",screenshot=q.get('failureScreenshot') or v.get('gatewayFailureScreenshot'),bugCandidate='FND-FP-01')
   if not r['screenshot']:r.update(status='blocked',error=r['error']+' Bukti screenshot kegagalan belum tersedia; tidak menerbitkan failed tanpa bukti wajib.')
  elif a.get('httpStatus')==200:
   activeRead=next((c for c in active['channels'] if c['code']==m.get('booking')),{});initial=m.get('paymentUI',{});n=lambda t:int(re.sub(r'\D','',str(t)) or 0)
   valid=g==m['expectedTotal'] and n(initial.get('fee'))==m['expectedFee'] and n(initial.get('total'))==m['expectedTotal'] and v.get('detailFee')==m['expectedFee'] and (i>3 or activeRead.get('status')=='passed')
   r['status']='passed' if valid else ('failed' if v.get('feeStatus')=='failed' else 'blocked')
   if r['status']=='failed':r.update(error='Card detail berbeda dari fee instruksi yang diterbitkan.',screenshot=v.get('screenshot'),bugCandidate='FND-FP-02')
   elif not valid:r['error']='Satu komponen gateway/payment/card belum dapat dicocokkan.'
  else:r['error']='Response gateway belum dapat dibuktikan.'
  r['notes']=notes({'kode':m.get('booking'),'komponen':m.get('components'),'konfigurasiAsli':m.get('before'),'konfigurasiUji':m.get('changed'),'tersimpan':m.get('persisted'),'expectedFee':m.get('expectedFee'),'gateway':a,'paymentAwal':{k:m.get('paymentUI',{}).get(k) for k in ['fee','total']},'detailObservedAfterRestore':{k:v.get(k) for k in ['detailSubtotal','detailFee','feeStatus']},'quoteRetailOnly':{k:q.get(k) for k in ['quote','status','scope']},'activeConfigRetry':next((c for c in active['channels'] if c['code']==m.get('booking')),None),'paid':False,'walletAuthorizationNotStarted':m.get('walletAuthorizationNotStarted'), 'testIssueAwal':m.get('error')})
 elif 10<=i<=13:
  role=['user','adminprahu','pusat','cabang'][i-10];v=next((v for v in verification['roles'] if v['role']==role),{});o=v.get('orders',[])
  valid=len(o)==9 and all(t.get('listSubtotalMatch') for t in o)
  r['status']='passed' if valid else 'blocked';r['error']=None if valid else v.get('error') or 'Daftar tidak memuat seluruh kode/nilai pembanding.'
  r['notes']=notes({'role':role,'headerAktual':v.get('headers'),'scope':'Kolom Harga Tiket cocok subtotal aktual tiap order. Admin fee tidak ditampilkan pada daftar. Detail hanya diperiksa dari link/breadcrumb aktual; tiga role admin/operator tidak menampilkan tautan detail order pending.','rows':[{'code':t['code'],'row':t.get('row'),'subtotal':t.get('listAmounts'),'detailFee':t.get('detailFee'),'detailHrefAvailable':bool(t.get('detailHref')),'error':t.get('detailError')} for t in o]})
 elif 14<=i<=23:
  slug=report_paths[i-14];matches=[p for p in reports['reports'] if p['href'].rstrip('/').split('/')[-1].lower()==slug.lower()]
  scope=[]
  for p in matches:
   scope.append({k:p.get(k) for k in ['role','title','status','headers','filters','ownRows','tripRows','footer','detailObservations','error']})
  if i==20:
   data=[]
   for p in matches:
    rows=[x for d in p.get('detailObservations',[]) for x in d.get('ownRows',[])];data.append({'role':p['role'],'rows':rows})
   ledger={x['code']:x['rows'] for x in verification['ledger']}
   def debits(rows):return sum(int(x.replace('.','')) for row in rows for x in re.findall(r'-\s*Rp\.\s*([\d.]+)',row))
   check=[]
   for role in data:
    for row in role['rows']:check.append({'role':role['role'],'code':row['code'],'reportDebit':debits(row['rows']),'ledgerDebit':debits(ledger.get(row['code'],[])),'hasLedgerRow':bool(ledger.get(row['code'])),'hasReportRow':bool(row['rows'])})
   valid=len(matches)==3 and len(check)==27 and all(x['reportDebit']==x['ledgerDebit'] and x['hasLedgerRow']==x['hasReportRow'] for x in check)
   r.update(status='passed' if valid else 'blocked',error=None if valid else 'Kontribusi saldo per kode belum lengkap/selaras pada tiga role.')
   r['notes']=notes({'reports':scope,'comparison':check,'scope':'Per kode run; tidak memakai agregat trip yang mengandung order lain.'})
  else:
   r['error']='Kontribusi laporan transaksi lunas/agen/asuransi/pembatalan tidak dapat dicocokkan: order run belum dibayar, belum ada konfirmasi dummy/prasyarat transaksi terkait.'
   r['notes']=notes({'reports':scope,'scope':'Nilai, header, periode dan keberadaan kode diamati; opening bukan bukti fee/revenue sama. Tidak membuat order kendaraan/agen/pembatalan tambahan di luar9channel User Umum.'})
 elif i==24:
  valid=purchase.get('baselineRestored') and verification.get('financeStillRestored') and retail.get('baselineRestored') and active.get('baselineRestored')
  r.update(status='passed' if valid else 'blocked',error=None if valid else 'Pemulihan akhir belum terbukti lengkap.',notes=notes({'original':purchase['baseline'],'final':active.get('finalFinance') or verification.get('finalFinance'),'bookings':purchase['bookings'],'cleanup':'Sembilan order belum lunas/pending; tidak ditemukan pembatalan langsung sebelum expiry. Batas bayar/status tercatat pada daftar test-data; bukan cleanup selesai.'}))
 elif i==25:
  failed=[p for p in pending['payments'] if p['status']=='failed'];r.update(status='failed' if failed else ('passed' if len(pending['payments'])==7 and all(p['status']=='passed' for p in pending['payments']) else 'blocked'),error='Tujuh halaman pembayaran menghitung fee Finance terbaru dan berbeda dari snapshot instruksi/detail order.' if failed else None,screenshot=next((p['screenshot'] for p in failed if p['method']=='QRIS'),failed[0]['screenshot'] if failed else None),bugCandidate='FND-FP-03' if failed else None,notes=notes({'scope':'DOM ready, handler tersedia, lookup selesai, nominal visible. Preliminary commit-only records tidak dipakai untuk verdict.','values':[{k:p.get(k) for k in ['method','code','expectedFee','issuedTotal','fee','total','api','readiness','status','error']} for p in pending['payments']]}))
 elif i==26:
  ledger=verification['ledger'];success={m['booking']:m for m in methods if next((a for a in m.get('apiObservations',[]) if a['route']=='/home/apifaspay'),{}).get('httpStatus')==200};commission=reports.get('commission');rate=float(commission['value']) if commission and re.fullmatch(r'\d+(\.\d+)?',commission['value']) else None
  check=[]
  import math
  for l in ledger:
   m=next(m for m in methods if m.get('booking')==l['code']);actual=sum(int(x.replace('.','')) for row in l['rows'] for x in re.findall(r'-\s*Rp\.\s*([\d.]+)',row));expected=math.ceil(m['components']['harga']*rate/100) if rate is not None and l['code'] in success else 0 if rate is not None else None;check.append({'code':l['code'],'actualDebit':actual,'expectedDebit':expected,'rows':l['rows']})
  valid=len(check)==9 and rate is not None and all(x['actualDebit']==x['expectedDebit'] for x in check)
  r.update(status='passed' if valid else 'blocked',error=None if valid else 'Debit/komisi aktual belum lengkap.',notes=notes({'commissionActual':commission,'ruleSource':'Dokumen Rule RORO v1.5.0: komisi harga tanpa pass, pembulatan ke atas; berbeda dari dasar fee admin pengguna.','perOrder':check,'totalOwnDebit':sum(x['actualDebit'] for x in check)}))
 results.append(r)
# Hilangkan ANSI/control-char dari salinan report; raw diagnostics tetap ada.
def clean(x):
 if isinstance(x,str):return re.sub(r'[\x00-\x08\x0b\x0c\x0e-\x1f]','',re.sub(r'\x1b\[[0-?]*[ -/]*[@-~]','',x))
 if isinstance(x,list):return [clean(y) for y in x]
 if isinstance(x,dict):return {k:clean(v) for k,v in x.items()}
 return x
run={'module':'fee-purchase','runId':run_id,'startedAt':purchase['startedAt'],'finishedAt':datetime.now(timezone.utc).isoformat(),'environment':{'baseUrl':purchase['baseline'][0]['edit'].split('/admin/')[0],'user':'Akun test config/env.md','role':'User Umum/Admin Prahu/Operator Pusat/Operator Cabang/Admin Finance'},'bookings':purchase['bookings'],'completedPayment':False,'scenarios':results}
file=ROOT/f'results/fee-purchase__{run_id}.json';file.write_text(json.dumps(clean(run),indent=2,ensure_ascii=False)+'\n');print(json.dumps({'file':str(file),'counts':{k:sum(s['status']==k for s in results) for k in ['passed','failed','blocked','skipped']}},ensure_ascii=False))
