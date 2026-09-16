const KEY='baby-track-v1';
const defaultData={profile:{name:'',birthDate:''},entries:[],growth:[],milestones:{}};
let data=JSON.parse(localStorage.getItem(KEY)||'null')||defaultData;
const $=s=>document.querySelector(s), $$=s=>[...document.querySelectorAll(s)];
const save=()=>{localStorage.setItem(KEY,JSON.stringify(data));render()};
const icons={feed:'🍼',sleep:'🌙',diaper:'☁️',tummy:'🧸',note:'✎'};
const names={feed:'Feeding',sleep:'Sleep',diaper:'Diaper',tummy:'Tummy time',note:'Note'};
const milestones=[
 ['0–2 months',['Looks at your face','Reacts to loud sounds','Moves both arms and both legs','Holds head up briefly during tummy time']],
 ['2–4 months',['Smiles to get attention','Makes sounds other than crying','Holds head steady when held','Brings hands to mouth']],
 ['4–6 months',['Laughs','Takes turns making sounds','Rolls from tummy to back','Leans on hands while sitting']],
 ['6–9 months',['Looks when name is called','Makes repeated sounds','Sits without support','Moves objects from one hand to another']],
 ['9–12 months',['Waves bye-bye','Understands “no”','Pulls up to stand','Picks up small items with thumb and finger']],
 ['12–18 months',['Tries to say words besides mama/dada','Points to ask for something','Walks without holding on','Scribbles']],
 ['18–24 months',['Says at least two words together','Points to things in a book','Runs','Uses a spoon']],
 ['2–3 years',['Has short back-and-forth conversations','Names things in a book','Jumps with both feet','Uses a fork']]
];
function fmtTime(v){return new Date(v).toLocaleTimeString([],{hour:'numeric',minute:'2-digit'})}
function fmtDate(v){return new Date(v+'T12:00:00').toLocaleDateString([],{month:'short',day:'numeric',year:'numeric'})}
function age(){if(!data.profile.birthDate)return '';const b=new Date(data.profile.birthDate+'T12:00:00'),n=new Date();let months=(n.getFullYear()-b.getFullYear())*12+n.getMonth()-b.getMonth();if(n.getDate()<b.getDate())months--;if(months<0)return 'Arriving soon';if(months<1){const d=Math.max(0,Math.floor((n-b)/86400000));return `${d} day${d===1?'':'s'} old`}if(months<24)return `${months} month${months===1?'':'s'} old`;const y=Math.floor(months/12),m=months%12;return `${y} year${y===1?'':'s'}${m?`, ${m} mo`:''} old`}
function render(){
 $('#todayDate').textContent=new Date().toLocaleDateString([],{weekday:'short',month:'short',day:'numeric'});
 $('#greeting').textContent=data.profile.name?`Hi, ${data.profile.name} ♡`:'Today'; $('#babyAge').textContent=age()||"Set up your baby's profile to begin";
 const today=new Date().toDateString(), todays=data.entries.filter(e=>new Date(e.time).toDateString()===today);
 const count=t=>todays.filter(e=>e.type===t).length;
 $('#todayStats').innerHTML=`<div class="stat"><strong>${count('feed')}</strong><small>feeds</small></div><div class="stat"><strong>${count('diaper')}</strong><small>diapers</small></div><div class="stat"><strong>${count('sleep')}</strong><small>sleep logs</small></div>`;
 renderEntries($('#recentList'),data.entries.slice().sort((a,b)=>new Date(b.time)-new Date(a.time)).slice(0,5)); renderTimeline(); renderGrowth(); renderMilestones();
}
function renderEntries(el,entries){el.innerHTML=entries.length?entries.map(e=>`<div class="entry"><div class="entry-icon">${icons[e.type]||'•'}</div><div class="entry-body"><strong>${names[e.type]||e.type}${e.detail?` · ${escapeHtml(e.detail)}`:''}</strong><small>${escapeHtml(e.note||'Logged')}</small></div><span class="entry-time">${fmtTime(e.time)}</span></div>`).join(''):'<div class="empty">Nothing logged yet.<br>Use a quick action to add the first entry.</div>'}
function renderTimeline(){const f=$('#filters .active')?.dataset.filter||'all';let e=data.entries.slice().sort((a,b)=>new Date(b.time)-new Date(a.time));if(f!=='all')e=e.filter(x=>x.type===f);renderEntries($('#timelineList'),e)}
function renderGrowth(){const latest=data.growth.slice().sort((a,b)=>b.date.localeCompare(a.date))[0];$('#growthLatest').innerHTML=latest?`<div class="metric"><strong>${latest.weight||'—'}</strong><small>lb weight</small></div><div class="metric"><strong>${latest.length||'—'}</strong><small>in length</small></div><div class="metric"><strong>${latest.head||'—'}</strong><small>in head</small></div>`:'<div class="empty">No measurements yet.</div>';const g=data.growth.slice().sort((a,b)=>b.date.localeCompare(a.date));$('#growthList').innerHTML=g.length?g.map(x=>`<div class="entry"><div class="entry-icon">↗</div><div class="entry-body"><strong>${[x.weight&&x.weight+' lb',x.length&&x.length+' in'].filter(Boolean).join(' · ')||'Measurement'}</strong><small>${escapeHtml(x.note||'Growth record')}</small></div><span class="entry-time">${fmtDate(x.date)}</span></div>`).join(''):'<div class="empty">Measurements you add will appear here.</div>'}
function renderMilestones(){let total=0,done=0;milestones.forEach(([,ms])=>ms.forEach(m=>{total++;if(data.milestones[m])done++}));$('#milestoneProgress').innerHTML=`<strong>${done} milestones celebrated</strong><p class="muted">Use this as a memory log rather than a test. Bring development questions to your child's clinician.</p><div class="progress"><i style="width:${total?done/total*100:0}%"></i></div>`;$('#milestoneList').innerHTML=milestones.map(([group,ms])=>`<div class="milestone-group"><h2>${group}</h2>${ms.map(m=>`<label class="milestone"><input type="checkbox" data-milestone="${encodeURIComponent(m)}" ${data.milestones[m]?'checked':''}><span>${m}</span></label>`).join('')}</div>`).join('');$$('[data-milestone]').forEach(c=>c.onchange=()=>{data.milestones[decodeURIComponent(c.dataset.milestone)]=c.checked;save()})}
function escapeHtml(s){return String(s).replace(/[&<>'"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;',"'":'&#39;','"':'&quot;'}[c]))}
$$('[data-nav]').forEach(b=>b.onclick=()=>{$$('.view').forEach(v=>v.classList.toggle('active',v.id===b.dataset.nav));$$('.bottom-nav button').forEach(x=>x.classList.toggle('active',x.dataset.nav===b.dataset.nav));window.scrollTo(0,0);render()});
$$('#quickActions button').forEach(b=>b.onclick=()=>openEntry(b.dataset.type));$('#addNote').onclick=()=>openEntry('note');
function openEntry(type){$('#entryType').value=type;$('#entryTitle').textContent=`Log ${names[type]}`;const now=new Date(Date.now()-new Date().getTimezoneOffset()*60000).toISOString().slice(0,16);$('#entryTime').value=now;$('#entryNote').value='';const fields=$('#entryFields');fields.innerHTML=type==='feed'?'<label>Details<select id="detail"><option>Breast</option><option>Bottle</option><option>Formula</option><option>Solids</option></select></label>':type==='diaper'?'<label>Type<select id="detail"><option>Wet</option><option>Dirty</option><option>Wet + dirty</option></select></label>':type==='sleep'?'<label>Duration (minutes)<input id="detail" type="number" min="0" placeholder="Optional"></label>':type==='tummy'?'<label>Duration (minutes)<input id="detail" type="number" min="0" placeholder="Optional"></label>':'';$('#entryDialog').showModal()}
$('#saveEntry').onclick=e=>{e.preventDefault();if(!$('#entryTime').value)return;data.entries.push({id:crypto.randomUUID?.()||Date.now(),type:$('#entryType').value,time:$('#entryTime').value,detail:$('#detail')?.value||'',note:$('#entryNote').value});save();$('#entryDialog').close()};
$('#addGrowth').onclick=()=>{$('#growthDate').value=new Date().toISOString().slice(0,10);$('#growthDialog').showModal()};
$('#saveGrowth').onclick=e=>{e.preventDefault();if(!$('#growthDate').value)return;data.growth.push({date:$('#growthDate').value,weight:$('#weight').value,length:$('#length').value,head:$('#head').value,note:$('#growthNote').value});save();$('#growthDialog').close();$('#growthForm').reset()};
$('#profileBtn').onclick=()=>{$('#babyName').value=data.profile.name;$('#birthDate').value=data.profile.birthDate;$('#profileDialog').showModal()};$('#saveProfile').onclick=e=>{e.preventDefault();data.profile={name:$('#babyName').value.trim(),birthDate:$('#birthDate').value};save();$('#profileDialog').close()};
$('#filters').onclick=e=>{if(!e.target.dataset.filter)return;$$('#filters .chip').forEach(x=>x.classList.toggle('active',x===e.target));renderTimeline()};
$('#exportData').onclick=()=>{const blob=new Blob([JSON.stringify(data,null,2)],{type:'application/json'}),a=document.createElement('a');a.href=URL.createObjectURL(blob);a.download='baby-track-data.json';a.click();URL.revokeObjectURL(a.href)};
render();