const { chromium }=require('/home/icun/Project/rorotest/node_modules/@playwright/test');
const {loginPartner}=require('/home/icun/Project/rorotest/tests/helpers/partner-session');
const tok=process.argv[2];const tag=process.argv[3];const EMAIL='pengirim.ph2021@gmail.com';const dir='/home/icun/Project/rorotest/artifacts/';
(async()=>{const b=await chromium.launch({headless:true});const {context}=await loginPartner(b,'Operator Cabang');const p=await context.newPage();
const posts=[];context.on('response',async r=>{if(r.request().method()==='POST'&&!/cdn-cgi|getDataModal/.test(r.url())){let x='';try{x=(await r.text()).slice(0,200)}catch{};posts.push({u:r.url().replace(/.*\.com/,''),d:(r.request().postData()||'').slice(0,300),s:r.status(),x})}});
context.on('page',np=>console.log('NEWPAGE',np.url()));
p.on('download',async d=>{const f=dir+`E-Tiket-${tag}.pdf`;await d.saveAs(f).catch(e=>console.log('dl err',e.message));console.log('DOWNLOAD',d.suggestedFilename(),'->',f)});
p.on('dialog',d=>{console.log('DIALOG',d.message());d.accept()});
await p.goto('/home/pilihpembayarancabang/'+tok,{waitUntil:'networkidle'});await p.waitForTimeout(1500);
const body=await p.locator('body').innerText();
if(!/Pemesanan tiket berhasil/.test(body)){console.log('NOT PAID - stop');await b.close();process.exit(2);}
await p.locator('label[for=exampleCustomInline1]').click();await p.locator('label[for=exampleCustomInline2]').click();await p.waitForTimeout(700);
const em=p.locator('input.kirim_tiket_email');console.log('email disabled?',await em.isDisabled(),'prefill=',await em.inputValue());
await em.fill(EMAIL);
const st=await p.evaluate(()=>({cetak:document.querySelector('#exampleCustomInline1').checked,bagasi:document.querySelector('#exampleCustomInline3').checked,kirim:document.querySelector('#exampleCustomInline2').checked,email:document.querySelector('input.kirim_tiket_email').value}));
console.log('STATE',JSON.stringify(st));
if(!(st.cetak&&st.kirim&&!st.bagasi&&st.email===EMAIL)){console.log('STATE MISMATCH stop');await b.close();process.exit(3);}
await p.locator('#proses_tiket').click();
for(let k=0;k<4;k++){await p.waitForTimeout(3000);const sw=p.locator('.swal2-popup:visible, .swal-modal:visible');
 if(await sw.count()){console.log('SWAL',k,(await sw.first().innerText()).replace(/\s+/g,' '));const btn=sw.first().locator('.swal2-confirm:visible, .swal-button--confirm:visible').first();if(await btn.count()){await btn.click();console.log('clicked confirm')}else break}else break}
await p.waitForTimeout(8000);
const t=await p.locator('body').innerText();const i=t.search(/E-TIKET/);console.log('TEXT',t.slice(Math.max(0,i-200),i+400).replace(/\n+/g,' | '));
console.log('ALERT',JSON.stringify(await p.locator('.alert:visible').allInnerTexts()));
console.log('POSTS',JSON.stringify(posts,null,1));
await p.screenshot({path:dir+`screenshots/order-${tag}-eticket-confirmed.png`,fullPage:true});
await context.close();await b.close();})().catch(e=>{console.error('FATAL',e.stack);process.exit(1)});
