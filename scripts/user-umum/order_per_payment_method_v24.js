// Reproduksi rate limit 2026-09-25 (Cloudflare 1015) — sama seperti order_per_payment_method.js,
// tapi login akun User Umum #6 (pengirimphv24@gmail.com) karena akun #5 sedang gagal login (lihat shared/decisions.md 2026-09-28).
const { chromium }=require('/home/icun/Project/rorotest/node_modules/@playwright/test');
const fs=require('fs');const HP='083830011881';const A='/home/icun/Project/rorotest/artifacts/screenshots/paymethods3/';fs.mkdirSync(A,{recursive:true});
const METHODS=(process.env.METHODS||'Bank Mandiri,Bank BCA,Bank BNI,Bank BRI,QRIS,OVO,DANA,Alfamart,Indomaret').split(',');
const SEARCH='/home/pencarian?kota_asal=6&kota_tujuan=5&tgl_berangkat=09%2F10%2F2026&jenis=%25&kelas=%25&golongan_kendaraan=%25&Carijadwal=1';
const out=[];const save=()=>fs.writeFileSync('/tmp/uu/permethod_v24.json',JSON.stringify(out,null,1));
fs.mkdirSync('/tmp/uu',{recursive:true});
async function loginV24(browser){
  const context=await browser.newContext({baseURL:'https://jn-rorodemo.prahu-hub.com',viewport:{width:1440,height:900}});
  const page=await context.newPage();
  await page.goto('/user/login',{waitUntil:'domcontentloaded',timeout:60000});
  await page.locator('#username').waitFor({state:'visible',timeout:30000});
  await page.locator('#username').fill('pengirimphv24@gmail.com');
  await page.locator('#password').fill('qwerty12345');
  await page.locator('#login1').click();
  await page.waitForURL((u)=>!/\/user\/login/i.test(u.pathname),{timeout:30000});
  await page.waitForLoadState('networkidle').catch(()=>{});
  await page.close();
  return {context};
}
(async()=>{const b=await chromium.launch({headless:true});const {context}=await loginV24(b);const p=await context.newPage();
let sb=0;await context.route('**/home/savebooking**',r=>{sb++;if(sb>1){console.log('ABORT extra savebooking');return r.abort()}return r.continue()});
const posts=[];context.on('response',async r=>{if(r.request().method()==='POST'&&/CheckMaxXendit|apifaspay|saveva|getFeeAdmin/.test(r.url())){let x='';try{x=(await r.text()).replace(/\s+/g,' ').slice(0,400)}catch{};posts.push(r.url().replace(/.*\.com/,'')+' ['+(r.request().postData()||'').slice(0,120)+'] => '+x)}});
let dlg=[];p.on('dialog',d=>{dlg.push(d.message().slice(0,120));d.accept()});
const swals=async()=>{const got=[];for(let k=0;k<4;k++){await p.waitForTimeout(2500);const sw=p.locator('.swal2-popup:visible');if(!await sw.count())break;got.push((await sw.innerText()).replace(/\s+/g,' ').trim().slice(0,200));const c=sw.locator('.swal2-confirm');if(await c.count())await c.click();else break;}return got};
for(let m=0;m<METHODS.length;m++){const METHOD=METHODS[m];const rec={method:METHOD};out.push(rec);sb=0;posts.length=0;dlg=[];
 try{
  if(m>0)await p.waitForTimeout(20000);
  await p.goto(SEARCH,{waitUntil:'domcontentloaded'});await p.locator('[id^=btn_pilih]').first().waitFor({timeout:60000});
  const card=await p.locator('body').innerText();if(!card.includes('AUTOTEST-20260925-PPBPN-01'))throw new Error('jadwal AUTOTEST tidak ditemukan');
  await p.locator('#btn_pilih2296').click();await p.waitForTimeout(2500);
  const q=p.locator('.masukkan-jumlah:visible');const n=await q.count();if(!n)throw new Error('tidak ada tiket tersedia');
  const rows=await q.evaluateAll(es=>es.map(e=>({k:+e.getAttribute('max_kuota')||0,t:e.closest('tr').innerText.replace(/\s+/g,' ').trim().replace(/ Pesan$/,'')})));
  let idx=rows.map((r,i)=>[r,i]).filter(([r])=>r.k>0||!r.k).map(([,i])=>i)[m%n]??0;
  if(process.env.CHEAP){const price=t=>+((t.match(/([\d.]+)$/)||[])[1]||'999999999').replace(/\./g,'');idx=rows.map((r,i)=>[price(r.t),i]).sort((a,b)=>a[0]-b[0])[m%Math.min(2,n)][1];}
  rec.ticket=rows[idx].t;await q.nth(idx).fill('1');await q.nth(idx).dispatchEvent('keyup');await q.nth(idx).dispatchEvent('change');
  await p.locator('.pesannya2296').click();await p.waitForURL(/inputpesanan/,{timeout:60000});await p.waitForLoadState('networkidle').catch(()=>{});await p.waitForTimeout(3000);
  await p.locator('#no_hp_pemesan').fill(HP);
  const kn=await p.locator('[id^=nama_pemilik]:visible').count();
  for(let i=1;i<=kn;i++){await p.locator('#nama_pemilik'+i).fill('AUTOTEST KENDARAAN '+String.fromCharCode(64+m+1));await p.locator('#nopol'+i).fill('DD'+(9200+m)+'AT');await p.locator('#kota_kend'+i).selectOption({label:'Parepare'});}
  const cbs=p.locator('input.check_gunakan:visible');for(let i=0,c=await cbs.count();i<c;i++){const cb=cbs.nth(i);if(await cb.isChecked()){await p.locator(`label[for="${await cb.getAttribute('id')}"]`).click();await p.waitForTimeout(400);}}
  const titles=p.locator('select[name="title_penumpang[]"]:visible');
  for(let i=0,pn=await titles.count();i<pn;i++){const t=titles.nth(i);const cls=(await t.getAttribute('class')).toUpperCase();const k=(await t.getAttribute('id')).replace('titleberangkat','');
   const opts=await t.locator('option').evaluateAll(os=>os.map(o=>({v:o.value,t:o.text.trim()})));await t.selectOption(opts.find(o=>o.v&&!/pilih/i.test(o.t)).v);
   await p.locator('.nama_penumpang'+k).fill('AUTOTEST PENUMPANG '+String.fromCharCode(65+m));
   const jt=p.locator('#jenis_identitasberangkat'+k);if(await jt.count()&&await jt.isVisible()){await jt.selectOption('KTP').catch(()=>{});const id=p.locator('.identitas_penumpang'+k+':visible');if(await id.count())await id.fill('990925'+String(9200+m).padStart(10,'0'));}
   const d=p.locator('#datepicker'+k);await d.fill(cls.includes('BAYI')?'01/01/2026':cls.includes('ANAK')?'01/01/2018':'01/01/1990');await d.dispatchEvent('change');await p.keyboard.press('Escape');
   await p.locator('#kotaberangkat'+k).selectOption({label:'Parepare'});}
  await p.waitForTimeout(1500);await p.locator('label[for=exampleCustomCheckbox1266]').click();await p.waitForTimeout(800);
  const evs=await p.locator('#lanjut_bayar').evaluate(e=>(jQuery._data(e,'events')||{}).click?.length||0);if(evs!==1)throw new Error('handler lanjut_bayar = '+evs);
  await p.locator('#lanjut_bayar').click();
  await p.waitForURL(/pilihpembayaran\//,{timeout:90000});rec.savebooking=sb;rec.token=p.url().split('/').pop();
  await p.waitForLoadState('networkidle').catch(()=>{});await p.waitForTimeout(2500);
  rec.orderId=((await p.locator('body').innerText()).match(/Order : ([A-Z]\d{7})/)||[])[1];
  const tt=(await p.locator('body').innerText()).match(/Total Pembayaran\s*Rp\.?\s*([\d.]+)/);rec.hargaTiket=tt&&tt[1];
  console.log(`[${METHOD}] order ${rec.orderId} (${rec.ticket}) savebooking=${sb}`);
  posts.length=0;
  const opt=p.locator('.pilihbankbayar:visible').filter({hasText:new RegExp('^\\s*'+METHOD+'\\s*$')});
  if(!await opt.count())throw new Error('opsi metode tidak tampil');
  await opt.first().click();rec.swal=await swals();await p.waitForLoadState('networkidle').catch(()=>{});await p.waitForTimeout(3000);
  const lanj=p.locator('.lanjutbayar:visible, .clickdana:visible, .bayarovo:visible');
  if(!posts.some(x=>x.includes('/home/apifaspay '))&&await lanj.count()){rec.lanjut=(await lanj.first().innerText()).trim();const before=p.url();await lanj.first().click();rec.swal2=await swals();await p.waitForTimeout(5000);if(p.url()!==before){rec.redirect=p.url().slice(0,120);await p.screenshot({path:A+String(m+1).padStart(2,'0')+'-'+METHOD.replace(/\W+/g,'_')+'-redirect.png'});await p.goBack().catch(()=>{});await p.waitForTimeout(2000);}}
  const body=await p.locator('body').innerText();const i=body.indexOf('DATA PEMBAYARAN');rec.page=(i>=0?body.slice(i,i+350):'').replace(/\n+/g,' | ');
  rec.va=(body.match(/(Nomor Virtual Account|Kode Pembayaran)\s*\n?\s*([\d ]{8,})/)||[])[2]||null;
  rec.admin=(body.match(/Biaya Admin\s*\n?\s*Rp\.?\s*([\d.]+)/)||[])[1]||null;
  rec.simlink=await p.locator('#linknya').getAttribute('href').catch(()=>null);
  rec.dialogs=dlg;rec.posts=[...posts];
  const api=posts.find(x=>x.includes('/home/apifaspay'))||'';rec.status=/Exception|error_code|DOUBLE_VA|ERROR/i.test(api)||rec.swal.some(s=>/Maaf|Terganggu|gagal/i.test(s))?'BLOCKED/ERROR':(api?'OK':'NO GATEWAY CALL');
  console.log(`[${METHOD}] ${rec.status} | va=${rec.va} admin=${rec.admin} | swal=${JSON.stringify(rec.swal)} | redirect=${rec.redirect||'-'}`);
  console.log('   api:',api.slice(0,330));
  await p.screenshot({path:A+String(m+1).padStart(2,'0')+'-'+METHOD.replace(/\W+/g,'_')+'.png',fullPage:true});
 }catch(e){rec.error=e.message.slice(0,300);rec.savebooking=sb;console.log(`[${METHOD}] ERROR ${rec.error}`);await p.screenshot({path:A+String(m+1).padStart(2,'0')+'-'+METHOD.replace(/\W+/g,'_')+'-error.png',fullPage:true}).catch(()=>{});
  if(/1015|rate limit/i.test(await p.locator('body').innerText().catch(()=>''))){console.log('RATE LIMITED — stop');save();break;}}
 save();}
await context.close();await b.close();})().catch(e=>{console.error('FATAL',e.stack);save();process.exit(1)});
