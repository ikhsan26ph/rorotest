const { chromium }=require('/home/icun/Project/rorotest/node_modules/@playwright/test');
const {loginUser}=require('/home/icun/Project/rorotest/tests/helpers/user-session');
const fs=require('fs');const SS='/home/icun/Project/rorotest/artifacts/screenshots/explore/20260925-user-umum/';fs.mkdirSync(SS,{recursive:true});
const BAD=/print|cetak|download|export|kirim|send|logout|signout|keluar|hapus|delete|batal|cancel|bayar|pay|checkout|savebooking|simpan|wa\.me|whatsapp/i;
(async()=>{const b=await chromium.launch({headless:true});const {context,landing}=await loginUser(b);console.log('LANDING',landing);
const p=await context.newPage();const posts=[];p.on('request',r=>{if(r.method()==='POST'&&!/cdn-cgi/.test(r.url()))posts.push(r.url())});
await p.goto(landing,{waitUntil:'networkidle'});
const nav=await p.evaluate(()=>[...document.querySelectorAll('a[href]')].map(a=>({t:(a.innerText||a.title||a.getAttribute('aria-label')||'').trim().replace(/\s+/g,' ').slice(0,50),h:a.href,vis:!!a.offsetParent,inNav:!!a.closest('nav,header,.sidebar,.navbar,.app-sidebar,.menu,ul')})));
fs.writeFileSync('/tmp/uu/nav.json',JSON.stringify(nav,null,1));
const origin=new URL(landing).origin;const seen=new Set();const out=[];
let queue=[landing,...nav.map(n=>n.h)].filter(h=>(h.startsWith(origin+'/home')||h.startsWith(origin+'/user'))&&!h.includes('#')&&!BAD.test(h));
for(let depth=0;depth<2;depth++){const next=[];
 for(const u of queue){const key=u.split('?')[0];if(seen.has(key))continue;seen.add(key);
  try{const r=await p.goto(u,{waitUntil:'networkidle',timeout:30000});await p.waitForTimeout(800);
   const info=await p.evaluate(()=>({title:document.title,h:[...document.querySelectorAll('h1,h2,h3,h4,h5,.card-title,.page-title')].filter(e=>e.offsetParent).map(e=>e.innerText.trim()).filter(Boolean).slice(0,8),btn:[...document.querySelectorAll('button,input[type=submit],a.btn')].filter(e=>e.offsetParent).map(e=>(e.innerText||e.value||'').trim()).filter(Boolean).slice(0,15),forms:document.querySelectorAll('form').length,tables:[...document.querySelectorAll('table')].filter(t=>t.offsetParent).length,inputs:[...document.querySelectorAll('input,select,textarea')].filter(e=>e.offsetParent&&e.type!=='hidden').map(e=>e.name||e.id).slice(0,20),links:[...document.querySelectorAll('a[href]')].map(a=>a.href)}));
   const name=key.replace(origin,'').replace(/[^a-z0-9]+/gi,'_').replace(/^_|_$/g,'')||'root';
   await p.screenshot({path:SS+name+'.png',fullPage:false});
   out.push({url:key,final:p.url(),status:r&&r.status(),...info,links:undefined,screenshot:name+'.png'});
   console.log('OK',depth,r&&r.status(),key,'|',info.title,'|',info.h.join(' / ').slice(0,100));
   for(const l of info.links)if((l.startsWith(origin+'/home')||l.startsWith(origin+'/user'))&&!l.includes('#')&&!BAD.test(l))next.push(l);
  }catch(e){out.push({url:key,error:e.message.slice(0,150)});console.log('ERR',key,e.message.slice(0,100))}}
 queue=next;}
fs.writeFileSync('/tmp/uu/explore.json',JSON.stringify({landing,pages:out,posts},null,1));console.log('POSTS',posts.length,[...new Set(posts)]);
await context.close();await b.close();})().catch(e=>{console.error('FATAL',e.stack);process.exit(1)});
