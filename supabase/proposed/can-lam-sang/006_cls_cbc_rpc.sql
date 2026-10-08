begin;

create or replace function public.cls_cbc_start_v1(p_level text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_user uuid := auth.uid();
  v_started integer;
  v_today integer;
  v_total integer;
  v_attempt_no bigint;
  v_hash bigint;
  v_scenario can_lam_sang_private.cbc_scenarios%rowtype;
  v_attempt_id uuid;
begin
  if v_user is null then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'khong_xac_thuc', 'data', null);
  end if;

  if not can_lam_sang_private.cls_user_enabled_v1(v_user) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'chua_mo', 'data', null);
  end if;

  if p_level is null or p_level not in ('co_ban', 'trung_binh', 'nang_cao') then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'level_khong_hop_le', 'data', null);
  end if;

  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(v_user::text, 0)
  );

  select count(*) into v_started
  from can_lam_sang_private.cbc_attempts
  where user_id = v_user and status = 'started';

  if v_started >= 3 and not can_lam_sang_private.cls_is_staff_v1(v_user) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'qua_3_luot_mo', 'data', null);
  end if;

  select count(*) into v_today
  from can_lam_sang_private.cbc_attempts
  where user_id = v_user
    and started_at >= (
      pg_catalog.date_trunc('day', pg_catalog.now() at time zone 'UTC')
      at time zone 'UTC'
    )
    and started_at < (
      pg_catalog.date_trunc('day', pg_catalog.now() at time zone 'UTC') + interval '1 day'
    ) at time zone 'UTC';

  if v_today >= 10 then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'qua_10_luot_ngay', 'data', null);
  end if;

  select count(*) into v_total
  from can_lam_sang_private.cbc_scenarios as s
  join can_lam_sang_private.cbc_patterns as p
    on p.pattern_id = s.pattern_id
  where s.level = p_level
    and p.review_status = 'DA_DUYET';

  if v_total = 0 then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'chua_co_scenario', 'data', null);
  end if;

  select count(*) into v_attempt_no
  from can_lam_sang_private.cbc_attempts
  where user_id = v_user;

  v_hash := pg_catalog.hashtextextended(
    v_user::text || pg_catalog.chr(31) || v_attempt_no::text,
    0
  );

  select s.*
  into v_scenario
  from can_lam_sang_private.cbc_scenarios as s
  join can_lam_sang_private.cbc_patterns as p
    on p.pattern_id = s.pattern_id
  where s.level = p_level
    and p.review_status = 'DA_DUYET'
    and not exists (
      select 1
      from can_lam_sang_private.cbc_attempts as prior
      where prior.user_id = v_user
        and prior.scenario_key = s.scenario_key
    )
  order by pg_catalog.hashtextextended(
             v_hash::text || pg_catalog.chr(31) || s.scenario_key,
             0
           ),
           s.scenario_key
  limit 1;

  if v_scenario.scenario_key is null then
    select s.*
    into v_scenario
    from can_lam_sang_private.cbc_scenarios as s
    join can_lam_sang_private.cbc_patterns as p
      on p.pattern_id = s.pattern_id
    where s.level = p_level
      and p.review_status = 'DA_DUYET'
    order by pg_catalog.hashtextextended(
               v_hash::text || pg_catalog.chr(31) || s.scenario_key,
               0
             ),
             s.scenario_key
    limit 1;
  end if;

  insert into can_lam_sang_private.cbc_attempts (
    user_id, scenario_key, level, variant, sex
  )
  values (
    v_user, v_scenario.scenario_key, v_scenario.level, v_scenario.variant, v_scenario.sex
  )
  returning id into v_attempt_id;

  return pg_catalog.jsonb_build_object(
    'ok', true,
    'code', null,
    'data', pg_catalog.jsonb_build_object(
      'attempt_id', v_attempt_id,
      'level', v_scenario.level,
      'public_scenario', v_scenario.public_scenario
    )
  );
end
$function$;

create or replace function public.cls_cbc_get_v1(p_attempt_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_user uuid := auth.uid();
  v_attempt can_lam_sang_private.cbc_attempts%rowtype;
  v_scenario can_lam_sang_private.cbc_scenarios%rowtype;
begin
  if v_user is null then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'khong_tim_thay', 'data', null);
  end if;

  if not can_lam_sang_private.cls_user_enabled_v1(v_user) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'chua_mo', 'data', null);
  end if;

  select a.*
  into v_attempt
  from can_lam_sang_private.cbc_attempts as a
  where a.id = p_attempt_id
    and a.user_id = v_user
  for update;

  if v_attempt.id is null then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'khong_tim_thay', 'data', null);
  end if;

  select s.*
  into v_scenario
  from can_lam_sang_private.cbc_scenarios as s
  where s.scenario_key = v_attempt.scenario_key;

  if v_attempt.status = 'submitted' then
    return pg_catalog.jsonb_build_object(
      'ok', true,
      'code', 'da_nop',
      'data', v_attempt.result
    );
  end if;

  return pg_catalog.jsonb_build_object(
    'ok', true,
    'code', null,
    'data', pg_catalog.jsonb_build_object(
      'attempt_id', v_attempt.id,
      'level', v_attempt.level,
      'public_scenario', v_scenario.public_scenario
    )
  );
end
$function$;

create or replace function public.cls_cbc_submit_v1(
  p_attempt_id uuid,
  p_answers jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_user uuid := auth.uid();
  v_attempt can_lam_sang_private.cbc_attempts%rowtype;
  v_scenario can_lam_sang_private.cbc_scenarios%rowtype;
  v_expected jsonb;
  v_received jsonb;
  v_key text;
  v_score integer := 0;
  v_result jsonb;
begin
  if v_user is null then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'khong_tim_thay', 'data', null);
  end if;

  if not can_lam_sang_private.cls_user_enabled_v1(v_user) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'chua_mo', 'data', null);
  end if;

  select a.*
  into v_attempt
  from can_lam_sang_private.cbc_attempts as a
  where a.id = p_attempt_id
    and a.user_id = v_user
  for update;

  if v_attempt.id is null then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'khong_tim_thay', 'data', null);
  end if;

  if v_attempt.status = 'submitted' then
    return pg_catalog.jsonb_build_object('ok', true, 'code', 'da_nop', 'data', v_attempt.result);
  end if;

  if p_answers is null
     or pg_catalog.jsonb_typeof(p_answers) <> 'object'
     or p_answers = '{}'::jsonb
     or pg_catalog.octet_length(p_answers::text) > 65536
     or coalesce(pg_catalog.jsonb_typeof(p_answers -> 'classifications'), '') <> 'object'
  then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
  end if;

  if pg_catalog.jsonb_array_length(pg_catalog.jsonb_path_query_array(p_answers, '$.*')) <> 1
     or coalesce((select count(*) from pg_catalog.jsonb_object_keys(p_answers -> 'classifications')), -1) <> 13 then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
  end if;

  if exists (
    select 1
    from pg_catalog.jsonb_object_keys(p_answers -> 'classifications') as k
    where k not in (
      'Hb','RBC','Hct','MCV','MCH','MCHC','WBC','PLT',
      'neut','lymph','mono','eos','baso'
    )
  ) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
  end if;

  if exists (
    select 1
    from pg_catalog.jsonb_each(p_answers -> 'classifications') as e(k, v)
    where pg_catalog.jsonb_typeof(e.v) <> 'string'
       or e.v #>> '{}' not in ('thap', 'binh_thuong', 'cao')
  ) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
  end if;

  select s.*
  into v_scenario
  from can_lam_sang_private.cbc_scenarios as s
  where s.scenario_key = v_attempt.scenario_key;

  v_expected := v_scenario.answer_key -> 'classifications';

  if pg_catalog.jsonb_array_length(pg_catalog.jsonb_path_query_array(v_expected, '$.*')) <> 13 then
    raise exception 'cbc_answer_key_invalid';
  end if;

  for v_key in
    select pg_catalog.jsonb_object_keys(v_expected)
  loop
    v_received := p_answers -> 'classifications' -> v_key;
    if v_received = v_expected -> v_key then
      v_score := v_score + 1;
    end if;
  end loop;

  v_result := pg_catalog.jsonb_build_object(
    'attempt_id', v_attempt.id,
    'score', round(v_score::numeric / 13, 5),
    'earned', v_score,
    'total', 13,
    'expected_classifications', v_expected
  );

  update can_lam_sang_private.cbc_attempts
  set
    status = 'submitted',
    submitted_at = pg_catalog.now(),
    answers = p_answers,
    result = v_result,
    score = round(v_score::numeric / 13, 5)
  where id = v_attempt.id
    and user_id = v_user
    and status = 'started';

  if not found then
    return pg_catalog.jsonb_build_object('ok', true, 'code', 'da_nop', 'data', v_attempt.result);
  end if;

  return pg_catalog.jsonb_build_object(
    'ok', true,
    'code', null,
    'data', v_result
  );
end
$function$;

revoke all on function public.cls_cbc_start_v1(text)
  from public, anon, authenticated;
revoke all on function public.cls_cbc_get_v1(uuid)
  from public, anon, authenticated;
revoke all on function public.cls_cbc_submit_v1(uuid, jsonb)
  from public, anon, authenticated;

grant execute on function public.cls_cbc_start_v1(text) to authenticated;
grant execute on function public.cls_cbc_get_v1(uuid) to authenticated;
grant execute on function public.cls_cbc_submit_v1(uuid, jsonb) to authenticated;

commit;
