import { diagnosisGroups, buildAnswers, esc, messageForCoreCode, toggleSelected } from '../../src/can-lam-sang/core/ui-helpers.mjs';

function reviewLabel(item) {
  return item?.review_label ? '<span class="cls-review-label" data-review-label>'+esc(item.review_label)+'</span>' : '';
}
function trackLabel(value) {
  return ({noi:'Nội',ngoai:'Ngoại',yhct:'YHCT',khac:'Khác'}[value] || value || '');
}
function notice(text, error=false) {
  return '<div class="cls-notice'+(error?' cls-error':'')+'">'+esc(text)+'</div>';
}

export async function mountCore(root,{rpc,onHome}) {
  let cases = [];
  let selectedCase = null;
  let selected = {};
  let filter = '';

  const renderList = () => {
    const visible = cases.filter(item => {
      const q=filter.trim().toLocaleLowerCase('vi-VN');
      return !q || [item.case_id,item.title,item.track,item.specialty].filter(Boolean).join(' ').toLocaleLowerCase('vi-VN').includes(q);
    });
    root.innerHTML = '<div class="cls-header"><button type="button" class="cls-link" id="home">← Phòng Cận Lâm Sàng</button><h1>Ca bệnh lõi</h1><p>156 ca mô phỏng · chọn ca để bắt đầu</p></div>'+
      '<div class="cls-search"><label for="case-filter">Lọc ca bệnh</label><input id="case-filter" type="search" autocomplete="off" placeholder="Mã ca, tiêu đề, chuyên khoa…" value="'+esc(filter)+'"></div>'+
      '<div class="cls-case-list">'+(visible.length?visible.map(item =>
        '<button type="button" class="cls-case-card" data-case="'+esc(item.case_id)+'"><div><strong>'+esc(item.title)+'</strong><div class="cls-muted">'+esc(trackLabel(item.track))+(item.specialty?' · '+esc(item.specialty):'')+'</div></div><div class="cls-case-meta">'+reviewLabel(item)+(item.submitted?'<span class="cls-submitted">Đã nộp</span>':'')+'</div></button>'
      ).join(''):notice('Không có ca phù hợp với bộ lọc.'))+'</div>';
    root.querySelector('#home').onclick=onHome;
    const input=root.querySelector('#case-filter');
    input.oninput=e=>{filter=e.target.value;renderList();const el=root.querySelector('#case-filter');el.focus();el.setSelectionRange(el.value.length,el.value.length);};
    root.querySelectorAll('[data-case]').forEach(button=>button.onclick=()=>openCase(button.dataset.case));
  };

  const renderCase = (bundle, review, result=null) => {
    const groups=diagnosisGroups(bundle.choices);
    const diagnosisHtml=groups.map(([group,values])=>'<fieldset class="cls-fieldset"><legend>'+esc(group)+'</legend>'+values.map((value,i)=>{
      const id='choice-'+group+'-'+i;
      const checked=(selected[group]||[]).includes(value);
      return '<label class="cls-choice" for="'+esc(id)+'"><input id="'+esc(id)+'" type="checkbox" data-group="'+esc(group)+'" data-value="'+esc(value)+'" '+(checked?'checked':'')+'><span>'+esc(value)+'</span></label>';
    }).join('')+'</fieldset>').join('');
    const actions=(bundle.choices.actions||[]).map((value,i)=>{
      const id='action-'+i,checked=(selected.actions||[]).includes(value);
      return '<label class="cls-choice" for="'+id+'"><input id="'+id+'" type="checkbox" data-group="actions" data-value="'+esc(value)+'" '+(checked?'checked':'')+'><span>'+esc(value)+'</span></label>';
    }).join('');
    const clinical='<section class="cls-card"><h2>Bệnh án công khai</h2><p>'+esc(bundle.presentation?.intro)+'</p><dl class="cls-dl"><dt>Người bệnh</dt><dd>'+esc(bundle.demographics?.patient_label)+'</dd><dt>Tuổi / giới</dt><dd>'+esc(bundle.demographics?.age)+' / '+esc(bundle.demographics?.sex)+'</dd><dt>Dấu hiệu sinh tồn</dt><dd>mạch '+esc(bundle.vitals?.hr)+' · HA '+esc(bundle.vitals?.sbp)+'/'+esc(bundle.vitals?.dbp)+' · RR '+esc(bundle.vitals?.rr)+' · T '+esc(bundle.vitals?.temperature_c)+' · SpO₂ '+esc(bundle.vitals?.spo2)+'</dd></dl>'+
      '<h3>Hỏi bệnh</h3>'+(bundle.history||[]).map(x=>'<p><strong>'+esc(x.question)+'</strong><br>'+esc(x.response)+'</p>').join('')+
      '<h3>Khám</h3>'+(bundle.examination||[]).map(x=>'<p><strong>'+esc(x.group)+' · '+esc(x.item)+'</strong><br>'+esc(x.finding)+'</p>').join('')+
      '<h3>Cận lâm sàng</h3>'+(bundle.investigations||[]).map(x=>'<p><strong>'+esc(x.name)+'</strong> · '+esc(x.duration_minutes)+' phút<br>'+esc(x.result)+'</p>').join('')+'</section>';
    let resultHtml='';
    if(result){
      resultHtml='<section class="cls-result"><h2>Kết quả</h2>'+reviewLabel(review)+'<h3>'+esc(result.title_reveal || bundle.title)+'</h3>'+(result.teaching_explanation?'<p>'+esc(result.teaching_explanation)+'</p>':'')+
        (Array.isArray(result.resources_after_submission)&&result.resources_after_submission.length?'<h3>Tài liệu sau khi nộp</h3><ul>'+result.resources_after_submission.map(x=>'<li>'+esc(x.title||x.citation||x.source)+'</li>').join('')+'</ul>':'')+
        (Array.isArray(result.after_submission_notes)&&result.after_submission_notes.length?'<h3>Ghi chú sau nộp</h3>'+result.after_submission_notes.map(x=>'<p>'+esc(x.text||x.reason)+'</p>').join(''):'')+'</section>';
    }
    root.innerHTML='<div class="cls-header"><button type="button" class="cls-link" id="back">← Danh sách ca</button><h1>'+esc(bundle.title)+'</h1>'+reviewLabel(review)+'</div>'+clinical+
      (!result?'<form id="case-form"><section class="cls-card"><h2>Chẩn đoán</h2>'+diagnosisHtml+'</section><section class="cls-card"><h2>Hành động</h2><div class="cls-choice-grid">'+actions+'</div></section><button class="cls-submit" type="submit">Nộp ca bệnh</button><div id="form-error" aria-live="polite"></div></form>':resultHtml);
    root.querySelector('#back').onclick=()=>{selectedCase=null;selected={};renderList();};
    root.querySelectorAll('input[data-group]').forEach(input=>input.onchange=e=>{selected=toggleSelected(selected,e.target.dataset.group,e.target.dataset.value,e.target.checked);});
    root.querySelector('#case-form')?.addEventListener('submit',async e=>{
      e.preventDefault();
      const answers=buildAnswers(bundle.choices,selected);
      if(!answers){root.querySelector('#form-error').innerHTML=notice('Hãy chọn ít nhất một đáp án ở mỗi nhóm chẩn đoán.',true);return;}
      const response=await rpc('cls_submit_v1',{p_case_id:bundle.case_id,p_module:'core',p_answers:answers});
      if(!response?.ok){if(response?.code==='da_nop'){renderCase(bundle,review,response.data);return;}root.querySelector('#form-error').innerHTML=notice(messageForCoreCode(response?.code),true);return;}
      renderCase(bundle,review,response.data);
    });
  };

  async function openCase(caseId) {
    root.innerHTML=notice('Đang mở ca bệnh…');
    try {
      const response=await rpc('cls_get_case_v1',{p_case_id:caseId});
      if(!response?.ok){root.innerHTML=notice(messageForCoreCode(response?.code),true);return;}
      const bundle=response.data;
      const item=cases.find(x=>x.case_id===caseId);
      selected={};
      if(item?.submitted){
        const result=await rpc('cls_get_submission_v1',{p_case_id:caseId});
        if(result?.ok && result?.code==='da_nop') renderCase(bundle,response.data,result.data);
        else renderCase(bundle,response.data,null);
      } else renderCase(bundle,response.data,null);
    } catch(error) {root.innerHTML=notice(messageForCoreCode(error.code),true);}
  }

  try {
    const response=await rpc('cls_list_cases_v1');
    if(!response?.ok){root.innerHTML=notice(messageForCoreCode(response?.code),true);return;}
    cases=response.data?.cases || (Array.isArray(response.data)?response.data:[]);
    renderList();
  } catch(error) {root.innerHTML=notice(messageForCoreCode(error.code),true);}
}
