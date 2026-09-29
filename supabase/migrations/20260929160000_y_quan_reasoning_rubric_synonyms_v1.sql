-- Accept natural wording for the Thap van daily-case reasoning rubric.
-- Additive: only y_quan_submit_daily_case_v1 is replaced; diagnosis, Bat cuong,
-- inquiry weights, XP and credit formulas are unchanged.
create or replace function public.y_quan_submit_daily_case_v1(
  p_slot_no smallint,
  p_answered_domains text[],
  p_diagnosis text,
  p_reasoning text
)
returns jsonb
language plpgsql
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  mid uuid := private.current_member_id();
  d date := (now() at time zone 'Asia/Ho_Chi_Minh')::date;
  s y_quan_private.daily_slots%rowtype;
  valid_ids text[] := array['cold','sweat','pain','bowel','food','chest','senses','thirst','history','course'];
  answered text[];
  n integer;
  diagnosis_points integer;
  b8c_points integer;
  inquiry_points integer;
  matched integer;
  term_count integer;
  reasoning_points integer;
  score integer;
  xp integer;
  credits integer;
  normalized_diagnosis text := lower(coalesce(p_diagnosis,''));
  normalized_reasoning text := lower(coalesce(p_reasoning,''));
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  select * into s from y_quan_private.daily_slots
  where doctor_id=mid and local_day=d and slot_no=p_slot_no for update;
  if s.doctor_id is null then raise exception 'Daily case not found'; end if;
  if s.completed_at is not null then
    return jsonb_build_object('already_completed',true,'bot_score',s.bot_score,'experience',s.experience_awarded);
  end if;

  select coalesce(array_agg(distinct x),'{}') into answered
  from unnest(coalesce(p_answered_domains,'{}')) x where x=any(valid_ids);
  n := cardinality(answered);
  if n <> 10 then
    raise exception 'Complete all ten Thap van domains before submitting';
  end if;

  diagnosis_points := case
    when s.case_profile_id='can-khi-uat-ket'
      and (normalized_diagnosis like '%can khí uất kết%' or normalized_diagnosis like '%can khí uất%') then 40
    when s.case_profile_id='ty-vi-hu-han'
      and (normalized_diagnosis like '%tỳ vị hư hàn%' or normalized_diagnosis like '%tỳ vị hư%') then 40
    when s.case_profile_id='am-hu-hoa-vuong'
      and (normalized_diagnosis like '%âm hư hỏa vượng%' or normalized_diagnosis like '%âm hư hỏa%') then 40
    else 0 end;
  if s.case_profile_id='can-khi-uat-ket' then
    b8c_points := case when normalized_diagnosis like '%bát cương: lý · khí trệ thiên thực · hàn nhiệt không nổi bật%' then 20 else 0 end;
  elsif s.case_profile_id='ty-vi-hu-han' then
    b8c_points := case when normalized_diagnosis like '%bát cương: lý · hàn · hư%' then 20 else 0 end;
  else
    b8c_points := case when normalized_diagnosis like '%bát cương: lý · nhiệt hư · hư%' then 20 else 0 end;
  end if;
  inquiry_points := round(20.0 * least(n,10) / 10);

  -- Each rubric term accepts natural wording; a term counts once when any
  -- alternative appears. Term counts and the 20-point weight are unchanged.
  select count(*) into matched from jsonb_array_elements(
    case s.case_profile_id
      when 'can-khi-uat-ket' then '[["tình chí","cảm xúc","tâm trạng","bực bội"],["căng thẳng","áp lực","lo lắng"],["ngực sườn","tức sườn","hai bên sườn"],["đầy tức","tức nặng","căng tức"],["thở dài","thở hắt"],["kinh nguyệt","chu kỳ"]]'::jsonb
      when 'ty-vi-hu-han' then '[["sợ lạnh","ghét lạnh","bụng lạnh","tay chân lạnh"],["thích ấm","thích đồ ấm","uống ấm","ưa ấm"],["ăn kém","ăn ít","chán ăn","kém ăn","nhanh no"],["đại tiện lỏng","phân lỏng","đi ngoài lỏng","tiêu chảy"],["chườm ấm","xoa ấm","chườm nóng"]]'::jsonb
      else '[["triều nhiệt","nóng chiều","nóng về chiều","nóng âm ỉ","nóng buổi chiều"],["mồ hôi trộm","mồ hôi khi ngủ","mồ hôi lúc ngủ","mồ hôi ban đêm","mồ hôi đêm"],["ù tai","tai ù"],["lưng gối","mỏi lưng","lưng mỏi","gối mỏi"],["khô họng","họng khô","khô miệng","miệng khô"]]'::jsonb
    end
  ) grp
  where exists (
    select 1 from jsonb_array_elements_text(grp) kw
    where position(kw in normalized_reasoning) > 0
  );
  term_count := case s.case_profile_id when 'can-khi-uat-ket' then 6 else 5 end;
  reasoning_points := round(20.0 * matched / term_count);
  score := least(100,diagnosis_points+b8c_points+inquiry_points+reasoning_points);
  xp := score;
  credits := floor(score/20.0);

  update y_quan_private.daily_slots
  set completed_at=now(),bot_score=score,experience_awarded=xp
  where doctor_id=mid and local_day=d and slot_no=p_slot_no;
  update y_quan_private.clinics
  set experience=experience+xp,updated_at=now(),last_seen_at=now()
  where member_id=mid;
  insert into y_quan_private.credit_ledger(member_id,source_kind,source_id,delta,metadata)
  values(mid,'case',s.slot_id,credits,jsonb_build_object(
    'bot_score',score,'experience',xp,'full',score=100,'case_profile_id',s.case_profile_id
  ))
  on conflict(member_id,source_kind,source_id) do nothing;
  return jsonb_build_object(
    'bot_score',score,'bot_stars',case when score>=90 then 5 when score>=80 then 4 when score>=65 then 3 when score>=50 then 2 else 1 end,
    'experience',xp,'credits',credits,'full_case',score=100
  );
end $function$;
