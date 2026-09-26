// Uji satu metode bayar pada order User Umum: node method.js <token> "<label metode>" <tag>
const { chromium }=require('/home/icun/Project/rorotest/node_modules/@playwright/test');
const {loginUser}=require('/home/icun/Project/rorotest/tests/helpers/user-session');
const [TOK,METHOD,TAG]=process.argv.slice(2);const A='/home/icun/Project/rorotest/artifacts/screenshots/paymethods/';require('fs').mkdirSync(A,{recursive:true});
(async()=>{const b=await chromium.launch({headless:true});const {context}=await loginUser(b);const p=await context.newPage();
const posts=[];context.on('response',async r=>{if(r.request().method()==='POST'&&!/cdn-cgi|getCountDown|reloadfaspay|getdetailpembelianbooking/.test(r.url())){let x='';try{x=(await r.text()).replace(/\s+/g,' ').slice(0,450)}catch{};posts.push(r.url().replace(/.*\.com/,'')+' ['+(r.request().postData()||'').slice(0,160)+'] => '+x)}});
context.on('page',np=>console.log('NEWPAGE',np.url()));p.on('dialog',d=>{console.log('DIALOG',d.message());d.accept()});
const swals=async(tag)=>{for(let k=0;k<4;k++){await p.waitForTimeout(2500);const sw=p.locator('.swal2-popup:visible');if(!await sw.count())return;const t=(await sw.innerText()).replace(/\s+/g,' ').trim();console.log('SWAL['+tag+']',t);
  const c=sw.locator('.swal2-confirm');if(await c.count())await c.click();else return;}};
await p.goto('/home/pilihpembayaran/'+TOK,{waitUntil:'networkidle'});await p.waitForTimeout(2500);
if(await p.locator('.btn-ganti:visible').count()){console.log('GANTI: current method active → click Ganti Metode');await p.locator('.btn-ganti:visible').first().click();await swals('ganti');await p.waitForTimeout(2500);}
const opt=p.locator('.pilihbankbayar:visible').filter({hasText:new RegExp('^\\s*'+METHOD+'\\s*$')});
if(!await opt.count()){console.log('RESULT',METHOD,'OPTION NOT VISIBLE (method list not shown)');}
else{await opt.first().click();await swals('pilih');await p.waitForLoadState('networkidle').catch(()=>{});await p.waitForTimeout(3000);
 const lanj=p.locator('.lanjutbayar:visible');if(!posts.some(x=>x.includes('apifaspay'))&&await lanj.count()){console.log('CLICK lanjutbayar:',(await lanj.first().innerText()).trim());await lanj.first().click();await swals('lanjut');await p.waitForTimeout(5000);}}
const t=await p.locator('body').innerText();const i=t.indexOf('DATA PEMBAYARAN');console.log('PAGE',(i>=0?t.slice(i,i+900):t.slice(t.indexOf('LAKUKAN'),t.indexOf('LAKUKAN')+500)).replace(/\n+/g,' | '));
console.log('BUTTONS',JSON.stringify(await p.locator('button:visible,a.btn:visible,#linknya:visible').evaluateAll(es=>es.map(e=>(e.innerText||'').trim()).filter(Boolean))));
console.log('SIMLINK',await p.locator('#linknya').getAttribute('href').catch(()=>null));
console.log('POSTS\n  '+posts.join('\n  '));
await p.screenshot({path:A+TAG+'.png',fullPage:true});
await context.close();await b.close();})().catch(e=>{console.error('FATAL',e.stack);process.exit(1)});
