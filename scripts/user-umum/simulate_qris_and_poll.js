const { chromium }=require('/home/icun/Project/rorotest/node_modules/@playwright/test');
const {loginUser}=require('/home/icun/Project/rorotest/tests/helpers/user-session');
const A='/home/icun/Project/rorotest/artifacts/screenshots/';
(async()=>{const b=await chromium.launch({headless:true});const {context}=await loginUser(b);const p=await context.newPage();
const log=[];context.on('response',async r=>{const u=r.url();if(/simulator|cekva|reloadfaspay|callback|xendit|faspay/i.test(u)){let x='';try{x=(await r.text()).replace(/\s+/g,' ').slice(0,250)}catch{};log.push(r.request().method()+' '+r.status()+' '+u.replace(/.*\.com/,'')+' => '+x)}});
await p.goto('/home/pilihpembayaran/azN1bGk0cUdYSnpRNzR1QlB4S3ZWUT09',{waitUntil:'networkidle'});await p.waitForTimeout(3000);
const href=await p.locator('#linknya').getAttribute('href');console.log('SIMLINK',href);
if(!/amount=\d+/.test(href))throw new Error('simulator link invalid');
const [sim]=await Promise.all([context.waitForEvent('page'),p.locator('#linknya').click()]);
await sim.waitForLoadState('domcontentloaded');console.log('SIM BODY',(await sim.locator('body').innerText().catch(()=>'')).slice(0,200));
await sim.screenshot({path:A+'user-order-C9031737-simulator-retry.png'}).catch(()=>{});
let paid=false;
for(let k=0;k<9;k++){await p.waitForTimeout(20000);
 const s=await context.newPage();await s.goto('/home/daftarpembelian',{waitUntil:'networkidle'});await s.waitForFunction(()=>!document.body.innerText.includes('Mohon tunggu sebentar'),null,{timeout:60000}).catch(()=>{});
 const t=await s.locator('body').innerText();const i=t.indexOf('C9031737');const row=t.slice(i,i+330).replace(/\s+/g,' ');
 const st=(row.match(/Lakukan Pembayaran|Order Selesai|Sudah Bayar|Lunas|Cetak Tiket|Order Expired|Menunggu[^|]{0,30}/)||['?'])[0];
 console.log('POLL',k,new Date().toISOString().slice(11,19),st);
 if(!/Lakukan Pembayaran/.test(row)){paid=true;console.log('ROW',row);await s.screenshot({path:A+'user-order-C9031737-after-retry.png'});await s.close();break;}
 await s.close();}
await p.reload({waitUntil:'networkidle'});await p.waitForTimeout(3000);
const t=await p.locator('body').innerText();console.log('PAYPAGE',p.url(),'|',t.slice(t.indexOf('Beranda'),t.indexOf('Beranda')+500).replace(/\n+/g,' | '));
await p.screenshot({path:A+'user-order-C9031737-paypage-after-retry.png',fullPage:true});
console.log('LOG\n'+log.join('\n'));console.log('PAID',paid);
await context.close();await b.close();})().catch(e=>{console.error('FATAL',e.stack);process.exit(1)});
