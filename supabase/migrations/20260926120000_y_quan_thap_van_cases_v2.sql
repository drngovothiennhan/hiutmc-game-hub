-- HIU Y Quan: spaced daily training cases and server-owned case-specific scoring.
-- Existing visits, credits, ratings, and completed slots are preserved.
alter table y_quan_private.daily_slots
  add column if not exists case_profile_id text,
  add column if not exists case_prompt text;

update y_quan_private.daily_slots
set case_profile_id = case ((slot_no - 1) % 3)
      when 0 then 'can-khi-uat-ket'
      when 1 then 'ty-vi-hu-han'
      else 'am-hu-hoa-vuong'
    end,
    case_prompt = case ((slot_no - 1) % 3)
      when 0 then 'Gần đây tôi hay thấy tức ở hai bên sườn, lúc có lúc không.'
      when 1 then 'Bụng tôi đau âm ỉ, ăn lạnh vào thì khó chịu hơn.'
      else 'Chiều tối tôi hay thấy nóng âm ỉ, đêm ngủ không yên.'
    end
where case_profile_id is null or case_prompt is null;

create or replace function public.y_quan_open_clinic_v1(p_doctor_avatar_id text)
returns jsonb
language plpgsql
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  mid uuid := private.current_member_id();
  d date := (now() at time zone 'Asia/Ho_Chi_Minh')::date;
  start_minute integer := floor(random() * 121)::integer;
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  if p_doctor_avatar_id not in ('male','female') then raise exception 'Doctor avatar invalid'; end if;

  insert into y_quan_private.clinics(member_id,doctor_avatar_id,is_open,last_seen_at,updated_at)
  values(mid,p_doctor_avatar_id,true,now(),now())
  on conflict(member_id) do update
  set doctor_avatar_id=excluded.doctor_avatar_id,is_open=true,last_seen_at=now(),updated_at=now();

  insert into y_quan_private.daily_slots(doctor_id,local_day,slot_no,starts_at,case_profile_id,case_prompt)
  select mid,d,n::smallint,
         (d::timestamp + time '08:00' + make_interval(mins => start_minute + (n - 1) * 120))
           at time zone 'Asia/Ho_Chi_Minh',
         p.profile_id,p.prompt
  from generate_series(1,5) as g(n)
  cross join lateral (
    select profile_id,prompt from (values
      ('can-khi-uat-ket','Gần đây tôi hay thấy tức ở hai bên sườn, lúc có lúc không.'),
      ('ty-vi-hu-han','Bụng tôi đau âm ỉ, ăn lạnh vào thì khó chịu hơn.'),
      ('am-hu-hoa-vuong','Chiều tối tôi hay thấy nóng âm ỉ, đêm ngủ không yên.')
    ) as cases(profile_id,prompt)
    order by random() limit 1
  ) p
  on conflict(doctor_id,local_day,slot_no) do nothing;

  return public.y_quan_dashboard_v1();
end $function$;

create or replace function public.y_quan_dashboard_v1()
returns jsonb
language plpgsql
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  mid uuid := private.current_member_id();
  d date := (now() at time zone 'Asia/Ho_Chi_Minh')::date;
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  return jsonb_build_object(
    'doctor',(select to_jsonb(c) from y_quan_private.clinics c where c.member_id=mid),
    'local_day',d,
    'experience',coalesce((select experience from y_quan_private.clinics where member_id=mid),0),
    'credits',coalesce((select sum(delta) from y_quan_private.credit_ledger where member_id=mid),0),
    'slots',coalesce((
      select jsonb_agg(jsonb_build_object(
        'slot_no',s.slot_no,'starts_at',s.starts_at,'visit_id',v.id,
        'status',coalesce(v.status,case when s.completed_at is not null then 'completed' else 'scheduled' end),
        'bot_score',greatest(s.bot_score,coalesce(v.bot_score,0)),
        'experience',s.experience_awarded+coalesce(v.experience_awarded,0),
        'stars',r.stars,'case_profile_id',s.case_profile_id,'case_prompt',s.case_prompt
      ) order by s.starts_at)
      from y_quan_private.daily_slots s
      left join y_quan_private.visits v using(doctor_id,local_day,slot_no)
      left join y_quan_private.ratings r on r.visit_id=v.id
      where s.doctor_id=mid and s.local_day=d
    ),'[]'::jsonb),
    'average_stars',(select round(avg(stars)::numeric,2) from y_quan_private.ratings where doctor_id=mid)
  );
end $function$;

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
