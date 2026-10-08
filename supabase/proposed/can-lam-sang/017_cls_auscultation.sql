-- Phòng Cận Lâm Sàng — trạm nghe tim/phổi (module 'auscultation').
-- Âm thanh: HLS-CMDS (Torabi, Shirani, Reilly; IEEE Data Descriptions; CC BY 4.0), ghi từ mô hình (manikin).
-- Bảng aus_clips (id -> nhãn) là dữ liệu riêng: KHÔNG commit bản seed vào repo công khai.
begin;

create table if not exists can_lam_sang_private.aus_clips (
  clip_id text primary key check (clip_id ~ '^[0-9a-f]{16}$'),
  kind text not null check (kind in ('heart', 'lung')),
  sex text not null check (sex in ('nam', 'nu')),
  sound_type text not null,
  site text not null,
  review_status text not null default 'CHUA_DUYET' check (review_status in ('CHUA_DUYET', 'DA_DUYET')),
  source_file text not null,
  gain_db numeric,
  bytes integer,
  constraint aus_clips_type_check check (
    (kind = 'heart' and sound_type in ('normal','early_systolic_murmur','mid_systolic_murmur','late_systolic_murmur','late_diastolic_murmur','s3','s4','atrial_fibrillation','av_block','tachycardia'))
    or
    (kind = 'lung' and sound_type in ('normal','coarse_crackles','fine_crackles','wheezing','rhonchi','pleural_rub'))
  ),
  constraint aus_clips_site_check check (
    (kind = 'heart' and site in ('apex','rusb','lusb','llsb','rc','lc'))
    or
    (kind = 'lung' and site in ('rua','rma','rla','lua','lma','lla'))
  )
);

create table if not exists can_lam_sang_private.aus_attempts (
  id uuid primary key default pg_catalog.gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  kind text not null check (kind in ('heart', 'lung')),
  target_type text not null,
  site_map jsonb not null check (pg_catalog.jsonb_typeof(site_map) = 'object'),
  options jsonb not null check (pg_catalog.jsonb_typeof(options) = 'array'),
  status text not null default 'started' check (status in ('started', 'submitted')),
  started_at timestamptz not null default pg_catalog.now(),
  submitted_at timestamptz,
  answers jsonb check (answers is null or pg_catalog.jsonb_typeof(answers) = 'object'),
  result jsonb check (result is null or pg_catalog.jsonb_typeof(result) = 'object'),
  score numeric check (score is null or (score >= 0 and score <= 1)),
  constraint aus_attempts_state_check check (
    (status = 'started' and submitted_at is null) or (status = 'submitted' and submitted_at is not null)
  )
);
create index if not exists aus_attempts_user_status_idx on can_lam_sang_private.aus_attempts (user_id, status);

alter table can_lam_sang_private.aus_clips enable row level security;
alter table can_lam_sang_private.aus_attempts enable row level security;
revoke all on table can_lam_sang_private.aus_clips, can_lam_sang_private.aus_attempts from public, anon, authenticated;

create or replace function public.cls_aus_start_v1(p_kind text)
returns jsonb language plpgsql security definer set search_path = ''
as $function$
declare
  v_user uuid := auth.uid();
  v_sites text[];
  v_types text[];
  v_target text;
  v_map jsonb := '{}'::jsonb;
  v_site text;
  v_clip text;
  v_opts jsonb;
  v_open integer;
  v_today integer;
  v_id uuid;
begin
  if v_user is null then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'khong_xac_thuc', 'data', null);
  end if;
  if not can_lam_sang_private.cls_user_enabled_v1(v_user) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'chua_mo', 'data', null);
  end if;
  if p_kind is null or p_kind not in ('heart', 'lung') then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'kind_khong_hop_le', 'data', null);
  end if;

  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(v_user::text, 1));

  select count(*) into v_open from can_lam_sang_private.aus_attempts where user_id = v_user and status = 'started';
  if v_open >= 5 and not can_lam_sang_private.cls_is_staff_v1(v_user) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'qua_5_luot_mo', 'data', null);
  end if;
  select count(*) into v_today from can_lam_sang_private.aus_attempts
   where user_id = v_user and started_at >= pg_catalog.date_trunc('day', pg_catalog.now() at time zone 'UTC') at time zone 'UTC';
  if v_today >= 40 and not can_lam_sang_private.cls_is_staff_v1(v_user) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'qua_40_luot_ngay', 'data', null);
  end if;

  v_sites := case p_kind when 'heart' then array['apex','rusb','lusb','llsb']
                         else array['rua','rma','rla','lua','lma','lla'] end;

  -- target types that have at least one visible clip at a standard site
  select pg_catalog.array_agg(distinct c.sound_type) into v_types
  from can_lam_sang_private.aus_clips c
  where c.kind = p_kind and c.site = any(v_sites)
    and can_lam_sang_private.cls_content_visible_v1(c.review_status);
  if v_types is null or not ('normal' = any(v_types)) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'chua_co_scenario', 'data', null);
  end if;

  -- pick the target at random; "normal" gets the same chance as any other type
  select t into v_target from pg_catalog.unnest(v_types) as t order by pg_catalog.random() limit 1;

  foreach v_site in array v_sites loop
    select c.clip_id into v_clip
    from can_lam_sang_private.aus_clips c
    where c.kind = p_kind and c.site = v_site and c.sound_type = v_target
      and can_lam_sang_private.cls_content_visible_v1(c.review_status)
    order by pg_catalog.random() limit 1;
    if v_clip is null then
      select c.clip_id into v_clip
      from can_lam_sang_private.aus_clips c
      where c.kind = p_kind and c.site = v_site and c.sound_type = 'normal'
        and can_lam_sang_private.cls_content_visible_v1(c.review_status)
      order by pg_catalog.random() limit 1;
    end if;
    if v_clip is null then
      return pg_catalog.jsonb_build_object('ok', false, 'code', 'chua_co_scenario', 'data', null);
    end if;
    v_map := v_map || pg_catalog.jsonb_build_object(v_site, v_clip);
    v_clip := null;
  end loop;

  -- 5 shuffled answer options: the target plus 4 distractors of the same kind
  select pg_catalog.jsonb_agg(o order by pg_catalog.random()) into v_opts from (
    select v_target as o
    union all
    (select t from pg_catalog.unnest(v_types) as t where t <> v_target order by pg_catalog.random() limit 4)
  ) s;

  insert into can_lam_sang_private.aus_attempts (user_id, kind, target_type, site_map, options)
  values (v_user, p_kind, v_target, v_map, v_opts)
  returning id into v_id;

  return pg_catalog.jsonb_build_object('ok', true, 'code', null, 'data',
    pg_catalog.jsonb_build_object(
      'attempt_id', v_id, 'kind', p_kind, 'options', v_opts,
      'sites', (select pg_catalog.jsonb_agg(pg_catalog.jsonb_build_object('site', k, 'clip_id', v_map ->> k) order by pg_catalog.array_position(v_sites, k)) from pg_catalog.jsonb_object_keys(v_map) as k)
    ) || can_lam_sang_private.cls_review_fields_v1('CHUA_DUYET'));
end
$function$;

create or replace function can_lam_sang_private.aus_view_v1(p_attempt can_lam_sang_private.aus_attempts)
returns jsonb language plpgsql security definer set search_path = ''
as $function$
declare
  v_sites text[] := case p_attempt.kind when 'heart' then array['apex','rusb','lusb','llsb'] else array['rua','rma','rla','lua','lma','lla'] end;
begin
  return pg_catalog.jsonb_build_object(
    'attempt_id', p_attempt.id, 'kind', p_attempt.kind, 'status', p_attempt.status, 'options', p_attempt.options,
    'sites', (select pg_catalog.jsonb_agg(pg_catalog.jsonb_build_object('site', k, 'clip_id', p_attempt.site_map ->> k) order by pg_catalog.array_position(v_sites, k))
              from pg_catalog.jsonb_object_keys(p_attempt.site_map) as k)
  ) || case when p_attempt.status = 'submitted'
         then pg_catalog.jsonb_build_object('answers', p_attempt.answers, 'result', p_attempt.result, 'score', p_attempt.score)
         else '{}'::jsonb end
    || can_lam_sang_private.cls_review_fields_v1('CHUA_DUYET');
end
$function$;

create or replace function public.cls_aus_get_v1(p_attempt_id uuid)
returns jsonb language plpgsql security definer set search_path = ''
as $function$
declare
  v_user uuid := auth.uid();
  v_a can_lam_sang_private.aus_attempts%rowtype;
begin
  if v_user is null then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'khong_xac_thuc', 'data', null);
  end if;
  if not can_lam_sang_private.cls_user_enabled_v1(v_user) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'chua_mo', 'data', null);
  end if;
  select * into v_a from can_lam_sang_private.aus_attempts where id = p_attempt_id and user_id = v_user;
  if v_a.id is null then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'khong_tim_thay', 'data', null);
  end if;
  return pg_catalog.jsonb_build_object('ok', true, 'code', null, 'data', can_lam_sang_private.aus_view_v1(v_a));
end
$function$;

create or replace function public.cls_aus_submit_v1(p_attempt_id uuid, p_answers jsonb)
returns jsonb language plpgsql security definer set search_path = ''
as $function$
declare
  v_user uuid := auth.uid();
  v_a can_lam_sang_private.aus_attempts%rowtype;
  v_type text;
  v_site text;
  v_ok_type boolean;
  v_ok_site boolean;
  v_correct_sites text[];
  v_score numeric;
  v_detail jsonb;
  v_result jsonb;
begin
  if v_user is null then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'khong_xac_thuc', 'data', null);
  end if;
  if not can_lam_sang_private.cls_user_enabled_v1(v_user) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'chua_mo', 'data', null);
  end if;
  select * into v_a from can_lam_sang_private.aus_attempts where id = p_attempt_id and user_id = v_user for update;
  if v_a.id is null then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'khong_tim_thay', 'data', null);
  end if;
  if v_a.status = 'submitted' then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'da_nop', 'data', can_lam_sang_private.aus_view_v1(v_a));
  end if;
  if p_answers is null or pg_catalog.jsonb_typeof(p_answers) <> 'object'
     or (select count(*) from pg_catalog.jsonb_object_keys(p_answers)) <> 2
     or not (p_answers ? 'type') or not (p_answers ? 'site')
     or pg_catalog.jsonb_typeof(p_answers -> 'type') <> 'string'
     or pg_catalog.jsonb_typeof(p_answers -> 'site') <> 'string' then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
  end if;
  v_type := p_answers ->> 'type';
  v_site := p_answers ->> 'site';
  if not (v_a.options @> pg_catalog.to_jsonb(v_type))
     or not (v_site = 'none' or v_a.site_map ? v_site) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
  end if;

  select pg_catalog.array_agg(m.k order by m.k) into v_correct_sites
  from pg_catalog.jsonb_object_keys(v_a.site_map) as m(k)
  join can_lam_sang_private.aus_clips c on c.clip_id = v_a.site_map ->> m.k
  where c.sound_type = v_a.target_type and v_a.target_type <> 'normal';

  v_ok_type := v_type = v_a.target_type;
  v_ok_site := case when v_a.target_type = 'normal' then v_site = 'none'
                    else v_correct_sites is not null and v_site = any(v_correct_sites) end;
  v_score := (case when v_ok_type then 0.6 else 0 end) + (case when v_ok_site then 0.4 else 0 end);

  select pg_catalog.jsonb_agg(pg_catalog.jsonb_build_object('site', m.k, 'sound_type', c.sound_type, 'source', 'HLS-CMDS (CC BY 4.0)') order by m.k)
  into v_detail
  from pg_catalog.jsonb_object_keys(v_a.site_map) as m(k)
  join can_lam_sang_private.aus_clips c on c.clip_id = v_a.site_map ->> m.k;

  v_result := pg_catalog.jsonb_build_object(
    'type_correct', v_ok_type, 'site_correct', v_ok_site,
    'target_type', v_a.target_type, 'correct_sites', coalesce(pg_catalog.to_jsonb(v_correct_sites), '[]'::jsonb),
    'per_site', v_detail,
    'note', 'Âm thanh ghi từ mô hình (manikin) bằng ống nghe điện tử; ở điểm không có bản ghi bất thường, hệ thống dùng bản ghi bình thường tại điểm đó.');

  update can_lam_sang_private.aus_attempts
     set status = 'submitted', submitted_at = pg_catalog.now(), answers = p_answers, result = v_result, score = v_score
   where id = v_a.id returning * into v_a;

  return pg_catalog.jsonb_build_object('ok', true, 'code', null, 'data', can_lam_sang_private.aus_view_v1(v_a));
end
$function$;

revoke all on function public.cls_aus_start_v1(text) from public, anon, authenticated;
revoke all on function public.cls_aus_get_v1(uuid) from public, anon, authenticated;
revoke all on function public.cls_aus_submit_v1(uuid, jsonb) from public, anon, authenticated;
revoke all on function can_lam_sang_private.aus_view_v1(can_lam_sang_private.aus_attempts) from public, anon, authenticated;
grant execute on function public.cls_aus_start_v1(text) to authenticated;
grant execute on function public.cls_aus_get_v1(uuid) to authenticated;
grant execute on function public.cls_aus_submit_v1(uuid, jsonb) to authenticated;

commit;
