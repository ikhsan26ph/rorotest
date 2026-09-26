const { chromium }=require('/home/icun/Project/rorotest/node_modules/@playwright/test');
const {loginUser}=require('/home/icun/Project/rorotest/tests/helpers/user-session');
const A='/home/icun/Project/rorotest/artifacts/screenshots/paymethods/';
(async()=>{const b=await chromium.launch({headless:true});const {context}=await loginUser(b);const p=await context.newPage();
p.on('dialog',d=>{console.log('DIALOG',d.message());d.accept()});
const nav=[];p.on('framenavigated',f=>{if(f===p.mainFrame())nav.push(f.url().slice(0,140))});
await p.goto('/home/pilihpembayaran/dlFWMGdDamU3L3U1SUdSYjI2NTdVUT09',{waitUntil:'networkidle'});await p.waitForTimeout(2500);
await p.locator('.clickdana:visible, .btn-bayar-dana:visible').first().click();
await p.waitForURL(/xendit\.co/,{timeout:30000});await p.waitForLoadState('networkidle').catch(()=>{});
await p.getByRole('button',{name:'Proceed to Pay'}).click();
await p.waitForTimeout(8000);await p.waitForLoadState('networkidle').catch(()=>{});
console.log('AFTER PAY URL',p.url());console.log('TEXT',(await p.locator('body').innerText()).replace(/\s+/g,' ').slice(0,600));
await p.screenshot({path:A+'07-dana-after-pay.png',fullPage:true});
console.log('NAV\n  '+nav.join('\n  '));
for(let k=0;k<6;k++){await p.waitForTimeout(15000);const s=await context.newPage();await s.goto('/home/daftarpembelian',{waitUntil:'networkidle'});await s.waitForFunction(()=>!document.body.innerText.includes('Mohon tunggu sebentar'),null,{timeout:60000}).catch(()=>{});
 const t=await s.locator('body').innerText();const i=t.indexOf('M9031934');const row=t.slice(i,i+300).replace(/\s+/g,' ');console.log('POLL',k,row.slice(0,230));await s.close();if(!/Lakukan Pembayaran/.test(row))break;}
await context.close();await b.close();})().catch(e=>{console.error('FATAL',e.stack);process.exit(1)});
