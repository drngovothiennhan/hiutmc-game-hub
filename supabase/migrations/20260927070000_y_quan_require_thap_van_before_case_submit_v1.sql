-- A real-patient visit cannot be submitted until the doctor records all ten
-- Thap van domains. Existing scoring, credits, visit state, and ratings remain intact.
create or replace function public.y_quan_submit_case_v1(
  p_visit_id uuid,
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
  v y_quan_private.visits%rowtype;
  valid_ids text[] := array['cold','sweat','pain','bowel','food','chest','senses','thirst','history','course'];
  answered text[];
  n integer;
  diagnosis_points integer;
  inquiry_points integer;
  reasoning_points integer;
  score integer;
  xp integer;
  credits integer;
  matched integer;
begin
  if mid is null or not private.is_approved() then
    raise exception 'Approved member required';
  end if;

  select * into v from y_quan_private.visits where id = p_visit_id for update;
  if v.id is null or v.doctor_id <> mid then
    raise exception 'Visit does not belong to this doctor';
  end if;
  if v.status = 'completed' then
    return jsonb_build_object('already_completed', true, 'bot_score', v.bot_score, 'experience', v.experience_awarded);
  end if;

  select coalesce(array_agg(distinct x), '{}') into answered
  from unnest(coalesce(p_answered_domains, '{}')) x
  where x = any(valid_ids);
  n := cardinality(answered);
  if n <> 10 then
    raise exception 'Complete all ten Thap van domains before submitting';
  end if;

  diagnosis_points := case
    when lower(coalesce(p_diagnosis, '')) like '%thận dương hư%'
      or lower(coalesce(p_diagnosis, '')) like '%thận dương bất túc%' then 35
    else 0
  end;
  inquiry_points := round(35.0 * least(n, 10) / 10);
  select count(*) into matched
  from unnest(array['sợ lạnh','thích ấm','lưng','gối','tiểu trong','lượng nhiều']) kw
  where position(kw in lower(coalesce(p_reasoning, ''))) > 0;
  reasoning_points := round(30.0 * matched / 6);
  score := least(100, diagnosis_points + inquiry_points + reasoning_points);
  xp := score;
  credits := floor(score / 20.0);

  update y_quan_private.visits
  set status = 'completed', answered_domains = answered,
      diagnosis = left(coalesce(p_diagnosis, ''), 300),
      reasoning = left(coalesce(p_reasoning, ''), 1500),
      bot_score = score, experience_awarded = xp, completed_at = now()
  where id = v.id;
  update y_quan_private.clinics
  set experience = experience + xp, updated_at = now()
  where member_id = mid;
  insert into y_quan_private.credit_ledger(member_id, source_kind, source_id, delta, metadata)
  values (mid, 'case', v.id, credits, jsonb_build_object('bot_score', score, 'experience', xp, 'full', score = 100))
  on conflict (member_id, source_kind, source_id) do nothing;

  return jsonb_build_object('already_completed', false, 'bot_score', score, 'experience', xp, 'credits', credits, 'full_case', score = 100);
end
$function$;

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

  if s.case_profile_id='can-khi-uat-ket' then
    select count(*) into matched from unnest(array['tình chí','căng thẳng','ngực sườn','đầy tức','thở dài','kinh nguyệt']) kw
    where position(kw in normalized_reasoning)>0;
    term_count := 6;
  elsif s.case_profile_id='ty-vi-hu-han' then
    select count(*) into matched from unnest(array['sợ lạnh','thích ấm','ăn kém','đại tiện lỏng','chườm ấm']) kw
    where position(kw in normalized_reasoning)>0;
    term_count := 5;
  else
    select count(*) into matched from unnest(array['triều nhiệt','mồ hôi trộm','ù tai','lưng gối','khô họng']) kw
    where position(kw in normalized_reasoning)>0;
    term_count := 5;
  end if;
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
