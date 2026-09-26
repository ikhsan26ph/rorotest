const { chromium }=require('/home/icun/Project/rorotest/node_modules/@playwright/test');
const {loginPartner}=require('/home/icun/Project/rorotest/tests/helpers/partner-session');
const fs=require('fs');
const inputUrl='/partner/inputpesanan/Ty9Ud0xMenE3cjkxSkFwcjJGaUphZz09';
async function chooseParepare(loc){for(let i=0,n=await loc.count();i<n;i++){const el=loc.nth(i);if(await el.isEnabled().catch(()=>false)){await el.selectOption({label:'Parepare'}).catch(async()=>{const opts=await el.locator('option').evaluateAll(os=>os.map(o=>({v:o.value,t:o.textContent.trim()})));const op=opts.find(o=>/Parepare/i.test(o.t));if(op)await el.selectOption(op.v)});}}}
async function firstReal(el){const opts=await el.locator('option').evaluateAll(os=>os.map(o=>({v:o.value,t:o.textContent.trim()})));const op=opts.find(o=>o.v && !/^(AK|- Pilih|0)$/i.test(o.v) && !/pilih/i.test(o.t));if(op)await el.selectOption(op.v,{force:true});}
(async()=>{const b=await chromium.launch({headless:true});const {context}=await loginPartner(b,'Operator Cabang');const p=await context.newPage();const posts=[];p.on('response',async r=>{if(r.request().method()==='POST'){let x='';try{x=(await r.text()).slice(0,500)}catch{};posts.push({s:r.status(),u:r.url(),x})}});let sb=0;await p.route('**/home/savebooking**',r=>{sb++;console.log('SAVEBOOKING REQUEST #'+sb, (r.request().postData()||'').length,'bytes');if(sb>1||process.env.DRY){console.log('ABORTED savebooking #'+sb);return r.abort()}return r.continue()});
p.on('dialog',d=>{console.log('DIALOG',d.message());d.accept()});
p.on('pageerror',e=>console.log('PAGEERROR',e.message));
await p.goto(inputUrl,{waitUntil:'networkidle'});
await p.locator('#kategoripembeli').selectOption('relasi_pelanggan');await p.waitForTimeout(1000);await p.locator('#pilihanrelasi').selectOption('252');await p.waitForTimeout(2500);
// kendaraan
for(let i=0,n=await p.locator('.nama_pemilik_kendaraan:enabled').count();i<n;i++) await p.locator('.nama_pemilik_kendaraan:enabled').nth(i).fill(`AUTOTEST KENDARAAN ${String.fromCharCode(65+i)}`);
for(let i=0,n=await p.locator('.nopol_kendaraan:enabled').count();i<n;i++) await p.locator('.nopol_kendaraan:enabled').nth(i).fill(`DD${String(9000+i).padStart(4,'0')}AT`);
await chooseParepare(p.locator('select.kota_kendaraan:enabled'));
for(let i=0,n=await p.locator('select.muatan_kendaraan:enabled').count();i<n;i++) await p.locator('select.muatan_kendaraan:enabled').nth(i).selectOption({label:'KOSONG'}).catch(()=>{});
// penumpang, isi per kartu agar usia sesuai golongan
const cards=p.locator('.jumlah_data_penumpang');
for(let i=0,n=await cards.count();i<n;i++){
 const c=cards.nth(i);const txt=(await c.innerText()).toUpperCase();
 const title=c.locator('select[name="title_penumpang[]"]:enabled');if(await title.count())await firstReal(title.first());
 const kind=((await title.first().getAttribute('kelasnih').catch(()=>''))||(await title.first().getAttribute('class').catch(()=>''))||'').toUpperCase();
 const name=c.locator('input.nama_penumpang:enabled');if(await name.count())await name.first().fill(`AUTOTEST PENUMPANG ${String.fromCharCode(65+i)}`);
 const jt=c.locator('select[name="jenis_identitas[]"]:enabled');const adult=await jt.first().getAttribute('ktpdewasa').catch(()=>null)==='1';if(await jt.count()&&adult)await jt.first().selectOption('KTP',{force:true}).catch(()=>firstReal(jt.first()));
 const ident=c.locator('input[name="identitas_penumpang[]"]:enabled');if(await ident.count()&&adult&&await ident.first().isVisible())await ident.first().fill(`990925${String(i+1).padStart(10,'0')}`);
 const dob=c.locator('input.tgl_lahir:enabled');if(await dob.count()){const v=kind.includes('BAYI')?'01/01/2026':kind.includes('ANAK')?'01/01/2018':'01/01/1990';await dob.first().fill(v);await dob.first().dispatchEvent('change');}
 await chooseParepare(c.locator('select[name="kota_penumpang[]"]:enabled'));
}
// bagasi
for(let i=0,n=await p.locator('.nama_pemilik_bagasi:enabled').count();i<n;i++)await p.locator('.nama_pemilik_bagasi:enabled').nth(i).fill(`AUTOTEST BAGASI ${String.fromCharCode(65+i)}`);
for(let i=0,n=await p.locator('select.pembawa_bagasi:enabled').count();i<n;i++)await firstReal(p.locator('select.pembawa_bagasi:enabled').nth(i));
for(let i=0,n=await p.locator('.nopol_bagasi:enabled').count();i<n;i++)await p.locator('.nopol_bagasi:enabled').nth(i).fill('DD9000AT');
await chooseParepare(p.locator('select.kota_bagasi:enabled'));
await p.waitForTimeout(3000);
await p.locator('#exampleCustomCheckbox1266').check({force:true});
const empties=await p.locator('input:enabled:visible,select:enabled:visible').evaluateAll(es=>es.filter(e=>e.required && (!e.value||/^- Pilih|^AK$/.test(e.value))).map(e=>({id:e.id,name:e.name,cls:e.className,value:e.value})));
const invalid=await p.locator('form[name=inputpesanan] :invalid').evaluateAll(es=>es.map(e=>({tag:e.tagName,id:e.id,name:e.name,cls:e.className,value:e.value,required:e.required,validation:e.validationMessage})));
const logical=await p.evaluate(()=>({passengers:[...document.querySelectorAll('.jumlah_data_penumpang')].map(v=>Object.fromEntries(['title_penumpang[]','nama_penumpang[]','jenis_identitas[]','identitas_penumpang[]','tgl_berangkat[]','kota_penumpang[]'].map(n=>[n,v.querySelector(`[name="${n}"]`)?.value]))),bags:[...document.querySelectorAll('.jumlah_bagasi')].map(v=>Object.fromEntries(['nama_penumpang[]','tgl_berangkat[]','identitas_penumpang[]','kota_penumpang[]'].map(n=>[n,v.querySelector(`[name="${n}"]`)?.value]))),terms:document.querySelector('#exampleCustomCheckbox1266')?.checked}));
console.log('LOGICAL',JSON.stringify(logical));
console.log('COUNTS',JSON.stringify({vehicles:await p.locator('.nama_pemilik_kendaraan:enabled').count(),passengers:await cards.count(),bags:await p.locator('.nama_pemilik_bagasi:enabled').count(),empties,invalid,formValid:await p.locator('form[name=inputpesanan]').evaluate(f=>f.checkValidity()),buttonDisabled:await p.locator('#lanjut_bayar').isDisabled()}));
const pageTxt=await p.locator('body').innerText();console.log('SUMMARY',(pageTxt.match(/Total Pembayaran[\s\S]{0,40}/g)||[]).join(' || ').replace(/\s+/g,' '), '| jadwal:', /AUTOTEST-20260925-PPBPN-01/.test(pageTxt));
{const cbs=p.locator('.div_bonus .bonus input[type=checkbox][class*=xcheckformberangkat_]');const n=await cbs.count();let un=0;
for(let i=0;i<n;i++){const c=cbs.nth(i);if(await c.isChecked()){const id=await c.getAttribute('id');if(id&&await p.locator(`label[for="${id}"]`).count())await p.locator(`label[for="${id}"]`).click();else await c.click({force:true});un++;await p.waitForTimeout(300);}}
await p.waitForTimeout(2500);
const st=await p.evaluate(()=>[...document.querySelectorAll('.div_bonus .bonus')].map(r=>r.getAttribute('on')+':'+r.querySelector('input[type=checkbox][class*=xcheckformberangkat_]')?.checked));
console.log('BONUS UNCHECKED',un,'of',n,'state',JSON.stringify(st));
const tt=(await p.locator('body').innerText()).match(/Total Pembayaran\s*Rp\.?\s*([\d.]+)/);console.log('TOTAL AFTER BONUS',tt&&tt[1]);
if(st.some(x=>!x.startsWith('off')))throw new Error('bonus row still on');
if(!tt||tt[1]!=='107.000.832')throw new Error('total mismatch '+(tt&&tt[1]));}
if(process.env.BONUSDBG){console.log('BONUS',JSON.stringify(await p.evaluate(()=>[...document.querySelectorAll('.div_bonus')].map((d,i)=>({i,vis:!!d.offsetParent,rows:[...d.querySelectorAll('.bonus')].map(r=>({on:r.getAttribute('on'),vis:!!r.offsetParent,chk:[...r.querySelectorAll('input[type=checkbox]')].map(c=>c.className.slice(-40)+':'+c.checked+':'+c.disabled),title:r.querySelector('[name^=titlenya_penumpangbonus]')?.value,tdis:r.querySelector('[name^=titlenya_penumpangbonus]')?.disabled,label:r.innerText.replace(/\s+/g,' ').slice(0,120)}))})))));
 const d0=p.locator('.div_bonus').first();await d0.scrollIntoViewIfNeeded().catch(()=>{});await p.screenshot({path:'/tmp/op13/bonus.png'});await context.close();await b.close();return;}
await p.evaluate(()=>{window.__log=[];const oz=window.zemPopover;window.zemPopover=function(el,msg){window.__log.push('POPOVER: '+msg+' @'+(typeof el==='string'?el:(el&&el.attr&&(el.attr('class')||el.attr('id')))));return oz&&oz.apply(this,arguments)};const oa=jQuery.ajax;jQuery.ajax=function(o){window.__log.push('AJAX: '+(o&&o.url));return oa.apply(this,arguments)};});
const evs=await p.locator('#lanjut_bayar').evaluate(e=>(jQuery._data(e,'events')||{}).click?.length||0);console.log('CLICK HANDLERS',evs);
if(evs!==1)throw new Error('expected exactly 1 click handler, got '+evs);
await p.locator('#lanjut_bayar').click();
await p.waitForTimeout(6000);
console.log('LOG',JSON.stringify(await p.evaluate(()=>window.__log)));
if(process.env.DRY){await p.screenshot({path:'/tmp/op13/neworder-dry2.png',fullPage:true});await context.close();await b.close();return;}
console.log('POPOVERS',JSON.stringify(await p.locator('.popover:visible,.tooltip:visible,.swal2-container:visible').allTextContents()));
await p.waitForTimeout(3000);
await p.waitForLoadState('networkidle').catch(()=>{});await p.waitForTimeout(5000);console.log('SBCOUNT',sb);console.log('RESULT',JSON.stringify({url:p.url(),title:await p.title(),posts:posts.slice(-12),body:(await p.locator('body').innerText()).slice(-5000)}));
await p.screenshot({path:'/home/icun/Project/rorotest/artifacts/screenshots/all-tickets-neworder-submit.png',fullPage:true});
await context.close();await b.close();
})().catch(e=>{console.error('FATAL',e.stack);process.exit(1)});
