// Retest 2 bug-candidate 2026-09-25: (1) Alfamart dgn tiket murah (hindari validasi max-transaksi
// supaya ketahuan apakah error-nya sama seperti Indomaret / sudah fixed); (2) "order tersangkut"
// setelah 1 metode gagal, dicoba ganti ke metode lain (VA) di order yang sama.
const { chromium }=require('/home/icun/Project/rorotest/node_modules/@playwright/test');
const fs=require('fs');const HP='083830011881';
const A='/home/icun/Project/rorotest/artifacts/screenshots/retest-stuck/';fs.mkdirSync(A,{recursive:true});
const SEARCH='/home/pencarian?kota_asal=6&kota_tujuan=5&tgl_berangkat=09%2F10%2F2026&jenis=%25&kelas=%25&golongan_kendaraan=%25&Carijadwal=1';
const out={};const save=()=>fs.writeFileSync('/tmp/uu/retest_stuck.json',JSON.stringify(out,null,1));
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

const swals=async(p)=>{const got=[];for(let k=0;k<4;k++){await p.waitForTimeout(2500);const sw=p.locator('.swal2-popup:visible');if(!await sw.count())break;got.push((await sw.innerText()).replace(/\s+/g,' ').trim().slice(0,250));const c=sw.locator('.swal2-confirm');if(await c.count())await c.click();else break;}return got};

async function createOrder(p, context, tag, pickCheapest){
  let sb=0;const routeHandler=r=>{sb++;if(sb>1){console.log('  ABORT extra savebooking');return r.abort()}return r.continue()};
  await context.route('**/home/savebooking**', routeHandler);
  const posts=[];const respHandler=async r=>{if(r.request().method()==='POST'&&/CheckMaxXendit|apifaspay|saveva|getFeeAdmin/.test(r.url())){let x='';try{x=(await r.text()).replace(/\s+/g,' ').slice(0,500)}catch{};posts.push(r.url().replace(/.*\.com/,'')+' ['+(r.request().postData()||'').slice(0,150)+'] => '+x)}};
  context.on('response', respHandler);
  let dlg=[];const dialogHandler=d=>{dlg.push(d.message().slice(0,150));d.accept()};
  p.on('dialog', dialogHandler);
  const rec={tag};
  try{
    await p.goto(SEARCH,{waitUntil:'domcontentloaded'});await p.locator('[id^=btn_pilih]').first().waitFor({timeout:60000});
    const card=await p.locator('body').innerText();if(!card.includes('AUTOTEST-20260925-PPBPN-01'))throw new Error('jadwal AUTOTEST tidak ditemukan');
    await p.locator('#btn_pilih2296').click();await p.waitForTimeout(2500);
    const q=p.locator('.masukkan-jumlah:visible');const n=await q.count();if(!n)throw new Error('tidak ada tiket tersedia');
    const rows=await q.evaluateAll(es=>es.map(e=>({k:+e.getAttribute('max_kuota')||0,t:e.closest('tr').innerText.replace(/\s+/g,' ').trim().replace(/ Pesan$/,'')})));
    const price=t=>+((t.match(/([\d.]+)$/)||[])[1]||'999999999').replace(/\./g,'');
    let idx = pickCheapest ? rows.map((r,i)=>[price(r.t),i]).sort((a,b)=>a[0]-b[0])[0][1] : 0;
    rec.ticket=rows[idx].t;console.log('  ticket picked:',rec.ticket);
    await q.nth(idx).fill('1');await q.nth(idx).dispatchEvent('keyup');await q.nth(idx).dispatchEvent('change');
    await p.locator('.pesannya2296').click();await p.waitForURL(/inputpesanan/,{timeout:60000});await p.waitForLoadState('networkidle').catch(()=>{});await p.waitForTimeout(3000);
    await p.locator('#no_hp_pemesan').fill(HP);
    const kn=await p.locator('[id^=nama_pemilik]:visible').count();
    for(let i=1;i<=kn;i++){await p.locator('#nama_pemilik'+i).fill('AUTOTEST KENDARAAN RETEST');await p.locator('#nopol'+i).fill('DD9299AT');await p.locator('#kota_kend'+i).selectOption({label:'Parepare'});}
    const cbs=p.locator('input.check_gunakan:visible');for(let i=0,c=await cbs.count();i<c;i++){const cb=cbs.nth(i);if(await cb.isChecked()){await p.locator(`label[for="${await cb.getAttribute('id')}"]`).click();await p.waitForTimeout(400);}}
    const titles=p.locator('select[name="title_penumpang[]"]:visible');
    for(let i=0,pn=await titles.count();i<pn;i++){const t=titles.nth(i);const cls=(await t.getAttribute('class')).toUpperCase();const k=(await t.getAttribute('id')).replace('titleberangkat','');
     const opts=await t.locator('option').evaluateAll(os=>os.map(o=>({v:o.value,t:o.text.trim()})));await t.selectOption(opts.find(o=>o.v&&!/pilih/i.test(o.t)).v);
     await p.locator('.nama_penumpang'+k).fill('AUTOTEST PENUMPANG RETEST');
     const jt=p.locator('#jenis_identitasberangkat'+k);if(await jt.count()&&await jt.isVisible()){await jt.selectOption('KTP').catch(()=>{});const id=p.locator('.identitas_penumpang'+k+':visible');if(await id.count())await id.fill('9909259299');}
     const d=p.locator('#datepicker'+k);await d.fill(cls.includes('BAYI')?'01/01/2026':cls.includes('ANAK')?'01/01/2018':'01/01/1990');await d.dispatchEvent('change');await p.keyboard.press('Escape');
     await p.locator('#kotaberangkat'+k).selectOption({label:'Parepare'});}
    await p.waitForTimeout(1500);await p.locator('label[for=exampleCustomCheckbox1266]').click().catch(()=>{});await p.waitForTimeout(800);
    const evs=await p.locator('#lanjut_bayar').evaluate(e=>(jQuery._data(e,'events')||{}).click?.length||0);if(evs!==1)throw new Error('handler lanjut_bayar = '+evs);
    await p.locator('#lanjut_bayar').click();
    await p.waitForURL(/pilihpembayaran\//,{timeout:90000});rec.savebooking=sb;rec.token=p.url().split('/').pop();
    await p.waitForLoadState('networkidle').catch(()=>{});await p.waitForTimeout(2500);
    rec.orderId=((await p.locator('body').innerText()).match(/Order : ([A-Z]\d{7})/)||[])[1];
    console.log('  order created:',rec.orderId,'token',rec.token);
  }catch(e){rec.error=e.message.slice(0,300);}
  context.off('response', respHandler); p.off('dialog', dialogHandler);
  rec._posts=posts; rec._dlg=dlg;
  return rec;
}

async function tryMethod(p, context, METHOD, tag){
  const posts=[];const respHandler=async r=>{if(r.request().method()==='POST'&&/CheckMaxXendit|apifaspay|saveva|getFeeAdmin/.test(r.url())){let x='';try{x=(await r.text()).replace(/\s+/g,' ').slice(0,500)}catch{};posts.push(r.url().replace(/.*\.com/,'')+' ['+(r.request().postData()||'').slice(0,150)+'] => '+x)}};
  context.on('response', respHandler);
  let dlg=[];const dialogHandler=d=>{dlg.push(d.message().slice(0,200));d.accept()};
  p.on('dialog', dialogHandler);
  const rec={method:METHOD};
  try{
    if(await p.locator('.btn-ganti:visible').count()){
      rec.gantiVisible=true;
      await p.locator('.btn-ganti:visible').first().click();
      rec.gantiSwal=await swals(p);
      await p.waitForTimeout(2000);
    } else rec.gantiVisible=false;
    const opt=p.locator('.pilihbankbayar:visible').filter({hasText:new RegExp('^\\s*'+METHOD+'\\s*$')});
    rec.optionVisible = await opt.count() > 0;
    if(!rec.optionVisible){ rec.note='opsi metode tidak tampil (mungkin masih terkunci ke metode lama)'; }
    else{
      await opt.first().click();rec.swal=await swals(p);await p.waitForLoadState('networkidle').catch(()=>{});await p.waitForTimeout(3000);
      const lanj=p.locator('.lanjutbayar:visible, .clickdana:visible, .bayarovo:visible');
      if(!posts.some(x=>x.includes('/home/apifaspay '))&&await lanj.count()){await lanj.first().click();rec.swal2=await swals(p);await p.waitForTimeout(4000);}
      const body=await p.locator('body').innerText();const i=body.indexOf('DATA PEMBAYARAN');rec.page=(i>=0?body.slice(i,i+350):'').replace(/\n+/g,' | ');
      rec.va=(body.match(/(Nomor Virtual Account|Kode Pembayaran)\s*\n?\s*([\d ]{8,})/)||[])[2]||null;
    }
    await p.screenshot({path:A+tag+'.png',fullPage:true});
  }catch(e){rec.error=e.message.slice(0,300);await p.screenshot({path:A+tag+'-error.png',fullPage:true}).catch(()=>{});}
  context.off('response', respHandler); p.off('dialog', dialogHandler);
  const api=posts.find(x=>x.includes('/home/apifaspay'))||'';
  rec.status=/Exception|error_code|DOUBLE_VA|ERROR/i.test(api)||(rec.swal||[]).some(s=>/Maaf|Terganggu|gagal/i.test(s))?'BLOCKED/ERROR':(api?'OK':'NO GATEWAY CALL');
  rec.posts=posts;rec.dialogs=dlg;
  return rec;
}

(async()=>{
  const b=await chromium.launch({headless:true});
  const {context}=await loginV24(b);
  const p=await context.newPage();

  console.log('=== TEST 1: Alfamart dengan tiket termurah ===');
  const orderA=await createOrder(p, context, 'alfamart-cheap', true);
  out.orderA=orderA;save();
  if(orderA.token){
    const rA=await tryMethod(p, context, 'Alfamart', '01-alfamart-cheap');
    out.alfamartCheapResult=rA;save();
    console.log('  ALFAMART(cheap) status:',rA.status,'| swal:',JSON.stringify(rA.swal));
    console.log('  api:',(rA.posts.find(x=>x.includes('apifaspay'))||'').slice(0,350));
  }

  await p.waitForTimeout(5000);

  console.log('=== TEST 2: order tersangkut (Indomaret gagal -> ganti ke Bank Mandiri) ===');
  const orderB=await createOrder(p, context, 'stuck-order', true);
  out.orderB=orderB;save();
  if(orderB.token){
    await p.goto('/home/pilihpembayaran/'+orderB.token,{waitUntil:'networkidle'});await p.waitForTimeout(2000);
    const rIndo=await tryMethod(p, context, 'Indomaret', '02-indomaret-first-fail');
    out.indomaretFirstResult=rIndo;save();
    console.log('  INDOMARET(first) status:',rIndo.status);
    await p.waitForTimeout(3000);
    // reload page fresh (simulate user coming back) before trying to switch method
    await p.goto('/home/pilihpembayaran/'+orderB.token,{waitUntil:'networkidle'});await p.waitForTimeout(2000);
    const rMandiri=await tryMethod(p, context, 'Bank Mandiri', '03-mandiri-after-indomaret-fail');
    out.mandiriAfterFailResult=rMandiri;save();
    console.log('  MANDIRI(after fail) gantiVisible:',rMandiri.gantiVisible,'optionVisible:',rMandiri.optionVisible,'status:',rMandiri.status);
    console.log('  api:',(rMandiri.posts.find(x=>x.includes('apifaspay'))||rMandiri.posts.join(' | ')).slice(0,400));
  }

  save();
  await context.close();await b.close();
})().catch(e=>{console.error('FATAL',e.stack);save();process.exit(1)});
