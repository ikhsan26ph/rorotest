const { chromium }=require('/home/icun/Project/rorotest/node_modules/@playwright/test');
const {loginPartner}=require('/home/icun/Project/rorotest/tests/helpers/partner-session');
const tok=process.argv[2];const tag=process.argv[3];
(async()=>{const b=await chromium.launch({headless:true});const {context}=await loginPartner(b,'Operator Cabang');const p=await context.newPage();
const posts=[];p.on('response',async r=>{if(r.request().method()==='POST'&&!/cdn-cgi|getDataModal/.test(r.url())){let x='';try{x=(await r.text()).slice(0,300)}catch{};posts.push({u:r.url().replace(/.*\.com/,''),d:(r.request().postData()||'').slice(0,300),s:r.status(),x})}});
p.on('dialog',d=>{console.log('DIALOG',d.type(),d.message());d.accept()});
await p.goto('/home/pilihpembayarancabang/'+tok,{waitUntil:'networkidle'});await p.waitForTimeout(1500);
const body=await p.locator('body').innerText();
if(/E-TIKET/.test(body)&&/Pemesanan tiket berhasil/.test(body)){console.log('ALREADY PAID');}
else{
const total=body.match(/Total Pembayaran\s*\n?\s*Rp\.?\s*([\d.]+)/i)[1];console.log('TOTAL',total);
await p.locator('.toggle_tunai').check({force:true});await p.waitForTimeout(600);
await p.locator('input.nominal').fill(total);await p.locator('input.nominal').dispatchEvent('keyup');await p.waitForTimeout(600);
await p.locator('#lanjut_tiket').click();
for(let k=0;k<4;k++){await p.waitForTimeout(2500);const sw=p.locator('.swal2-popup:visible, .swal-modal:visible, .modal.show');
 if(await sw.count()){const t=(await sw.first().innerText()).replace(/\s+/g,' ');console.log('SWAL',k,t);
  const btn=sw.first().locator('.swal2-confirm:visible, .swal-button--confirm:visible, button:has-text("Ya"):visible, button:has-text("OK"):visible').first();
  if(await btn.count()){await btn.click();console.log('clicked confirm');} else break;} else break;}
await p.waitForLoadState('networkidle').catch(()=>{});await p.waitForTimeout(3000);}
console.log('URL',p.url());
const tail=(await p.locator('body').innerText());const i=tail.search(/Status Bayar/);console.log('TEXT',tail.slice(i,i+800).replace(/\n+/g,' | '));
const ctrls=await p.evaluate(()=>[...document.querySelectorAll('input,button,a.btn')].filter(e=>e.offsetParent!==null&&e.getBoundingClientRect().top>0).map(e=>({tag:e.tagName,type:e.type,id:e.id,name:e.name,cls:e.className.slice(0,50),val:(e.value||'').slice(0,40),txt:(e.innerText||'').trim().slice(0,30),checked:e.checked,dis:e.disabled})).filter(c=>!/hamburger|signOut|btn-topup|radio_web/.test(c.cls+c.id)));
console.log(JSON.stringify(ctrls));console.log('POSTS',JSON.stringify(posts,null,1));
await p.screenshot({path:`/home/icun/Project/rorotest/artifacts/screenshots/order-${tag}-payment-done.png`,fullPage:true});
await context.close();await b.close();})().catch(e=>{console.error('FATAL',e.stack);process.exit(1)});
