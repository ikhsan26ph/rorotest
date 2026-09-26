// Order User Umum: 13 jenis tiket di jadwal AUTOTEST-20260925-PPBPN-01. DRY=1 → savebooking di-abort.
const { chromium }=require('/home/icun/Project/rorotest/node_modules/@playwright/test');
const {loginUser}=require('/home/icun/Project/rorotest/tests/helpers/user-session');
const HP='083830011881';
(async()=>{const b=await chromium.launch({headless:true});const {context}=await loginUser(b);const p=await context.newPage();
let sb=0;await context.route('**/home/savebooking**',r=>{sb++;console.log('SAVEBOOKING REQUEST #'+sb);if(sb>1||process.env.DRY){console.log('ABORTED savebooking #'+sb);return r.abort()}return r.continue()});
p.on('response',async r=>{if(/savebooking/.test(r.url())){let x='';try{x=await r.text()}catch{};console.log('SAVEBOOKING RESP',r.status(),x.slice(0,300))}});
p.on('dialog',d=>{console.log('DIALOG',d.message().slice(0,120));d.accept()});p.on('pageerror',e=>console.log('PAGEERROR',e.message));
await p.goto('/home/pencarian?kota_asal=6&kota_tujuan=5&tgl_berangkat=09%2F10%2F2026&jenis=%25&kelas=%25&golongan_kendaraan=%25&Carijadwal=1',{waitUntil:'networkidle'});await p.waitForTimeout(2000);
const card=await p.locator('body').innerText();if(!card.includes('AUTOTEST-20260925-PPBPN-01'))throw new Error('jadwal AUTOTEST tidak ditemukan');
await p.locator('#btn_pilih2296').click();await p.waitForTimeout(2500);
const q=p.locator('.masukkan-jumlah:visible');const n=await q.count();if(n!==13)throw new Error('expected 13 rows, got '+n);
for(let i=0;i<10;i++){await q.nth(i).fill('1');await q.nth(i).dispatchEvent('keyup');await q.nth(i).dispatchEvent('change');}
await p.locator('.pesannya2296').click();await p.waitForURL(/inputpesanan/,{timeout:60000});await p.waitForLoadState('networkidle').catch(()=>{});await p.waitForTimeout(3000);
// pembeli (prefill profil) + HP test
await p.locator('#no_hp_pemesan').fill(HP);
// kendaraan
const kn=await p.locator('[id^=nama_pemilik]:visible').count();
for(let i=1;i<=kn;i++){await p.locator('#nama_pemilik'+i).fill('AUTOTEST KENDARAAN '+String.fromCharCode(64+i));await p.locator('#nopol'+i).fill('DD'+(9100+i)+'AT');await p.locator('#kota_kend'+i).selectOption({label:'Parepare'});}
// bonus sopir/kernet → nonaktif
const cbs=p.locator('input.check_gunakan:visible');let un=0;for(let i=0,m=await cbs.count();i<m;i++){const c=cbs.nth(i);if(await c.isChecked()){const id=await c.getAttribute('id');await p.locator(`label[for="${id}"]`).click().catch(()=>c.click({force:true}));un++;await p.waitForTimeout(400);}}
// penumpang
const titles=p.locator('select[name="title_penumpang[]"]:visible');const pn=await titles.count();
for(let i=0;i<pn;i++){const t=titles.nth(i);const cls=(await t.getAttribute('class')).toUpperCase();const idx=(await t.getAttribute('id')).replace('titleberangkat','');
 const opts=await t.locator('option').evaluateAll(os=>os.map(o=>({v:o.value,t:o.text.trim()})));const op=opts.find(o=>o.v&&!/pilih/i.test(o.t));await t.selectOption(op.v);
 await p.locator('.nama_penumpang'+idx).fill('AUTOTEST PENUMPANG '+String.fromCharCode(65+i));
 const jt=p.locator('#jenis_identitasberangkat'+idx);if(await jt.count()&&await jt.isVisible()){await jt.selectOption('KTP').catch(async()=>{});const id=p.locator('.identitas_penumpang'+idx+':visible');if(await id.count())await id.fill('990925'+String(9100+i).padStart(10,'0'));}
 const dob=cls.includes('BAYI')?'01/01/2026':cls.includes('ANAK')?'01/01/2018':'01/01/1990';const d=p.locator('#datepicker'+idx);await d.fill(dob);await d.dispatchEvent('change');await p.keyboard.press('Escape');
 await p.locator('#kotaberangkat'+idx).selectOption({label:'Parepare'});}
await p.waitForTimeout(2000);
await p.locator('label[for=exampleCustomCheckbox1266]').click().catch(()=>p.locator('#exampleCustomCheckbox1266').check({force:true}));await p.waitForTimeout(1000);
const state=await p.evaluate(()=>({pembeli:['title1','nama','emailPemesan','no_hp_pemesan','jenis_identitas','kotak2'].map(i=>{const e=document.getElementById(i);return i+'='+(e.tagName==='SELECT'?e.options[e.selectedIndex]?.text:e.value)}),
 pax:[...document.querySelectorAll('select[name="title_penumpang[]"]')].filter(e=>e.offsetParent).map(t=>{const k=t.id.replace('titleberangkat','');return [t.className.match(/title(DEWASA|ANAK|BAYI)/)?.[1],t.value,document.querySelector('.nama_penumpang'+k)?.value,document.getElementById('datepicker'+k)?.value,document.getElementById('kotaberangkat'+k)?.selectedOptions[0]?.text].join('|')}),
 bonus:[...document.querySelectorAll('input.check_gunakan')].filter(e=>e.offsetParent).map(e=>e.checked),terms:document.getElementById('exampleCustomCheckbox1266').checked,btnDisabled:document.getElementById('lanjut_bayar').disabled}));
console.log('KENDARAAN',kn,'BONUS UNCHECKED',un);console.log('STATE',JSON.stringify(state));
const tot=(await p.locator('body').innerText()).match(/Total Pembayaran\s*Rp\.?\s*([\d.]+)/);console.log('TOTAL',tot&&tot[1]);if(!tot||parseInt(tot[1].replace(/\./g,''))>=9500000)throw new Error('total too large for QRIS: '+(tot&&tot[1]));
await p.evaluate(()=>{window.__log=[];const oz=window.zemPopover;window.zemPopover=function(el,msg){window.__log.push('POPOVER: '+msg+' @'+(typeof el==='string'?el:(el&&el.attr&&(el.attr('class')||el.attr('id')))));return oz&&oz.apply(this,arguments)};const oa=jQuery.ajax;jQuery.ajax=function(o){window.__log.push('AJAX: '+(o&&o.url));return oa.apply(this,arguments)};});
const evs=await p.locator('#lanjut_bayar').evaluate(e=>(jQuery._data(e,'events')||{}).click?.length||0);console.log('CLICK HANDLERS',evs);if(evs!==1)throw new Error('expected 1 handler, got '+evs);
if(await p.locator('#lanjut_bayar').isDisabled())throw new Error('lanjut_bayar disabled');
await p.locator('#lanjut_bayar').click();
await p.waitForTimeout(process.env.DRY?8000:30000);await p.waitForLoadState('networkidle').catch(()=>{});
console.log('LOG',JSON.stringify(await p.evaluate(()=>window.__log).catch(()=>'navigated')));
console.log('SWAL',JSON.stringify(await p.locator('.swal2-popup:visible,.popover:visible').allInnerTexts().catch(()=>[])));
console.log('SBCOUNT',sb,'URL',p.url());
await p.screenshot({path:'/tmp/uu/order-'+(process.env.DRY?'dry':'real')+'.png',fullPage:true});
await context.close();await b.close();})().catch(e=>{console.error('FATAL',e.stack);process.exit(1)});
