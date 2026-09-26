const { chromium }=require('/home/icun/Project/rorotest/node_modules/@playwright/test');
const {loginUser}=require('/home/icun/Project/rorotest/tests/helpers/user-session');
const TOK=process.argv[2];const A='/home/icun/Project/rorotest/artifacts/screenshots/';
(async()=>{const b=await chromium.launch({headless:true});const {context}=await loginUser(b);const p=await context.newPage();
const posts=[];context.on('response',async r=>{if(r.request().method()==='POST'&&!/cdn-cgi|getCountDown/.test(r.url())){let x='';try{x=(await r.text()).slice(0,400)}catch{};posts.push({u:r.url().replace(/.*\.com/,''),d:(r.request().postData()||'').slice(0,200),s:r.status(),x})}});
p.on('dialog',d=>{console.log('DIALOG',d.message());d.accept()});
await p.goto('/home/pilihpembayaran/'+TOK,{waitUntil:'networkidle'});await p.waitForTimeout(2000);
const already=await p.locator('#linknya:visible').count();
if(!already){await p.locator('.pilihbankbayar',{hasText:'QRIS'}).first().click();await p.waitForTimeout(3000);
 for(let k=0;k<3;k++){const sw=p.locator('.swal2-popup:visible');if(!await sw.count())break;const t=(await sw.innerText()).replace(/\s+/g,' ');console.log('SWAL',t);
  if(/melebihi|gagal|maaf/i.test(t)){console.log('STOP on swal');break}await sw.locator('.swal2-confirm').click();await p.waitForTimeout(4000);}
 await p.waitForLoadState('networkidle').catch(()=>{});await p.waitForTimeout(4000);}
const t=await p.locator('body').innerText();const i=t.indexOf('LAKUKAN PEMBAYARAN');console.log('TEXT',t.slice(i,i+2500).replace(/\n+/g,' | '));
const sim=await p.locator('#linknya').getAttribute('href').catch(()=>null);console.log('SIMULATOR',sim,'visible',await p.locator('#linknya').isVisible().catch(()=>false));
console.log('QRIMG',JSON.stringify(await p.evaluate(()=>[...document.querySelectorAll('img,canvas')].filter(e=>e.offsetParent&&/qr|downloadqris/i.test((e.src||'')+e.className+e.id)).map(e=>(e.src||e.id).slice(0,200)))));
await p.screenshot({path:A+'user-order-'+process.argv[3]+'-qris.png',fullPage:true});
console.log('POSTS',JSON.stringify(posts,null,1));
if(sim){const s=await context.newPage();await s.goto(sim,{waitUntil:'networkidle'});await s.waitForTimeout(1500);console.log('SIMPAGE',s.url(),'|',(await s.locator('body').innerText()).replace(/\n+/g,' | ').slice(0,1500));
 console.log('SIMCTRLS',JSON.stringify(await s.evaluate(()=>[...document.querySelectorAll('input:not([type=hidden]),button,select,a.btn,form')].map(e=>({t:e.tagName,id:e.id,n:e.name,v:(e.value||'').slice(0,40),txt:(e.innerText||'').trim().slice(0,30),action:e.getAttribute('action')})))));
 require('fs').writeFileSync('/tmp/uu/simulator.html',await s.content());await s.screenshot({path:A+'user-order-'+process.argv[3]+'-simulator.png',fullPage:true});}
await context.close();await b.close();})().catch(e=>{console.error('FATAL',e.stack);process.exit(1)});
