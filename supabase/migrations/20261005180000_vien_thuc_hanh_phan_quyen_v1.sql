-- Viện Thực Hành (05/10/2026): phân quyền ca theo nhóm người chơi. Chưa thu tiền.
--   guest   = ca trải nghiệm cho khách (chỉ chơi trên máy, không EXP, không cần tài khoản)
--   outside = thành viên đăng ký ngoài (source_file = 'self-registration'): chơi hầu hết ca, có EXP
--   full    = thành viên HIU TMC: chơi toàn bộ ca
-- Máy chủ chỉ phát ca (ca trực, giải tuần) trong phạm vi nhóm của người chơi. Nguồn dữ liệu: data/tier-config.json.
alter table y_quan_private.tu_chan_catalog add column if not exists min_tier text not null default 'outside';
alter table y_quan_private.tu_chan_catalog drop constraint if exists tu_chan_catalog_min_tier_check;
alter table y_quan_private.tu_chan_catalog add constraint tu_chan_catalog_min_tier_check check (min_tier in ('guest','outside','full'));

create or replace function private.tu_chan_tier_rank(p text)
returns integer language sql immutable set search_path = pg_catalog
as $$ select case p when 'guest' then 1 when 'outside' then 2 when 'full' then 3 else 0 end $$;

create or replace function private.tu_chan_member_tier(p_mid uuid)
returns text language sql stable security definer set search_path = pg_catalog, public
as $$ select case when m.source_file = 'self-registration' then 'outside' else 'full' end from public.club_members m where m.id = p_mid $$;
revoke all on function private.tu_chan_tier_rank(text), private.tu_chan_member_tier(uuid) from public, anon, authenticated;

update y_quan_private.tu_chan_catalog set min_tier = 'outside';
update y_quan_private.tu_chan_catalog set min_tier = 'guest' where case_id in ('co-giat-do-sot-cao-tre-em', 'noi-tieu-hoa-002', 'noi-tim-mach-006', 'noi-ho-hap-003', 'ngoai-bung-001', 'ngoai-bung-004', 'ngoai-chan-thuong-006', 'vi-quan-thong', 'kham-tyc-viem-mui-di-ung', 'thoai-hoa-khop-goi-han-that');
update y_quan_private.tu_chan_catalog set min_tier = 'full' where case_id in ('noi-noi-tiet-003', 'noi-huyet-hoc-002', 'noi-than-004', 'noi-co-xuong-khop-001', 'noi-than-kinh-003', 'noi-tieu-hoa-011', 'noi-tim-mach-007', 'noi-ho-hap-006', 'noi-nhiem-003', 'noi-noi-tiet-004', 'noi-tieu-hoa-012', 'noi-than-005', 'noi-than-kinh-004', 'noi-huyet-hoc-003', 'noi-co-xuong-khop-002');


create or replace function public.tu_chan_start_shift_v2(p_track text)
 returns jsonb language plpgsql security definer
 set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  mid uuid := private.current_member_id();
  mrank integer;
  c y_quan_private.clinics%rowtype;
  o y_quan_private.tu_chan_shifts%rowtype;
  pick text;
  pick_room text;
  sid uuid;
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  if p_track not in ('noi','ngoai','yhct') then raise exception 'Track invalid'; end if;
  mrank := private.tu_chan_tier_rank(private.tu_chan_member_tier(mid));
  select * into c from y_quan_private.clinics where member_id = mid;
  if c.member_id is null then raise exception 'clinic_required'; end if;
  perform pg_advisory_xact_lock(hashtextextended('tu_chan:' || mid::text, 0));
  update y_quan_private.tu_chan_shifts set status = 'abandoned', finished_at = now()
   where member_id = mid and status = 'open' and started_at < now() - interval '3 hours';
  select * into o from y_quan_private.tu_chan_shifts where member_id = mid and status = 'open';
  if o.id is not null then
    return jsonb_build_object('shift_id', o.id, 'case_id', o.case_id, 'room', o.room, 'track', (select k.track from y_quan_private.tu_chan_catalog k where k.case_id = o.case_id), 'resumed', true, 'doctor_avatar_id', c.doctor_avatar_id, 'experience', c.experience);
  end if;
  if (select count(*) from y_quan_private.tu_chan_shifts where member_id = mid and (started_at at time zone 'Asia/Ho_Chi_Minh')::date = (now() at time zone 'Asia/Ho_Chi_Minh')::date) >= 40 then
    raise exception 'daily_limit';
  end if;
  select k.case_id, k.room into pick, pick_room from y_quan_private.tu_chan_catalog k
   where k.active and k.track = p_track and private.tu_chan_tier_rank(k.min_tier) <= mrank
     and k.case_id not in (select case_id from y_quan_private.tu_chan_shifts where member_id = mid order by started_at desc limit 12)
   order by random() limit 1;
  if pick is null then
    select k.case_id, k.room into pick, pick_room from y_quan_private.tu_chan_catalog k where k.active and k.track = p_track and private.tu_chan_tier_rank(k.min_tier) <= mrank order by random() limit 1;
  end if;
  if pick is null then raise exception 'no_case'; end if;
  insert into y_quan_private.tu_chan_shifts(member_id, room, case_id) values (mid, pick_room, pick) returning id into sid;
  return jsonb_build_object('shift_id', sid, 'case_id', pick, 'room', pick_room, 'track', p_track, 'resumed', false, 'doctor_avatar_id', c.doctor_avatar_id, 'experience', c.experience);
end $function$;

create or replace function public.tu_chan_start_shift_v1(p_room text)
 returns jsonb language plpgsql security definer
 set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  mid uuid := private.current_member_id();
  mrank integer;
  c y_quan_private.clinics%rowtype;
  o y_quan_private.tu_chan_shifts%rowtype;
  pick text;
  sid uuid;
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  if p_room not in ('kham','capcuu') then raise exception 'Room invalid'; end if;
  mrank := private.tu_chan_tier_rank(private.tu_chan_member_tier(mid));
  select * into c from y_quan_private.clinics where member_id = mid;
  if c.member_id is null then raise exception 'clinic_required'; end if;
  perform pg_advisory_xact_lock(hashtextextended('tu_chan:' || mid::text, 0));
  update y_quan_private.tu_chan_shifts set status = 'abandoned', finished_at = now()
   where member_id = mid and status = 'open' and started_at < now() - interval '3 hours';
  select * into o from y_quan_private.tu_chan_shifts where member_id = mid and status = 'open';
  if o.id is not null then
    return jsonb_build_object('shift_id', o.id, 'case_id', o.case_id, 'room', o.room, 'resumed', true, 'doctor_avatar_id', c.doctor_avatar_id, 'experience', c.experience);
  end if;
  if (select count(*) from y_quan_private.tu_chan_shifts where member_id = mid and (started_at at time zone 'Asia/Ho_Chi_Minh')::date = (now() at time zone 'Asia/Ho_Chi_Minh')::date) >= 40 then
    raise exception 'daily_limit';
  end if;
  select k.case_id into pick from y_quan_private.tu_chan_catalog k
   where k.active and k.room = p_room and private.tu_chan_tier_rank(k.min_tier) <= mrank
     and k.case_id not in (select case_id from y_quan_private.tu_chan_shifts where member_id = mid order by started_at desc limit 12)
   order by random() limit 1;
  if pick is null then
    select k.case_id into pick from y_quan_private.tu_chan_catalog k where k.active and k.room = p_room and private.tu_chan_tier_rank(k.min_tier) <= mrank order by random() limit 1;
  end if;
  if pick is null then raise exception 'no_case'; end if;
  insert into y_quan_private.tu_chan_shifts(member_id, room, case_id) values (mid, p_room, pick) returning id into sid;
  return jsonb_build_object('shift_id', sid, 'case_id', pick, 'room', p_room, 'resumed', false, 'doctor_avatar_id', c.doctor_avatar_id, 'experience', c.experience);
end $function$;

create or replace function public.tu_chan_start_challenge_v1(p_track text)
 returns jsonb language plpgsql security definer
 set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  mid uuid := private.current_member_id();
  mrank integer;
  c y_quan_private.clinics%rowtype;
  o y_quan_private.tu_chan_shifts%rowtype;
  ckey text; ids text[]; pick text; pick_room text; sid uuid;
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  if p_track not in ('noi','ngoai','yhct') then raise exception 'Track invalid'; end if;
  mrank := private.tu_chan_tier_rank(private.tu_chan_member_tier(mid));
  select * into c from y_quan_private.clinics where member_id = mid;
  if c.member_id is null then raise exception 'clinic_required'; end if;
  perform pg_advisory_xact_lock(hashtextextended('tu_chan:' || mid::text, 0));
  update y_quan_private.tu_chan_shifts set status = 'abandoned', finished_at = now()
   where member_id = mid and status = 'open' and started_at < now() - interval '3 hours';
  select * into o from y_quan_private.tu_chan_shifts where member_id = mid and status = 'open';
  if o.id is not null then
    return jsonb_build_object('shift_id', o.id, 'case_id', o.case_id, 'room', o.room, 'track', (select k.track from y_quan_private.tu_chan_catalog k where k.case_id = o.case_id), 'resumed', true, 'challenge', o.challenge_key is not null, 'doctor_avatar_id', c.doctor_avatar_id, 'experience', c.experience);
  end if;
  if (select count(*) from y_quan_private.tu_chan_shifts where member_id = mid and (started_at at time zone 'Asia/Ho_Chi_Minh')::date = (now() at time zone 'Asia/Ho_Chi_Minh')::date) >= 40 then
    raise exception 'daily_limit';
  end if;
  ckey := private.tu_chan_week_key() || ':' || p_track;
  ids := private.tu_chan_challenge_cases(ckey, p_track);
  if coalesce(array_length(ids, 1), 0) = 0 then raise exception 'no_case'; end if;
  select x.cid, k.room into pick, pick_room
  from unnest(ids) with ordinality as x(cid, ord)
  join y_quan_private.tu_chan_catalog k on k.case_id = x.cid
  where private.tu_chan_tier_rank(k.min_tier) <= mrank
    and not exists (select 1 from y_quan_private.tu_chan_shifts s where s.member_id = mid and s.challenge_key = ckey and s.case_id = x.cid and s.status in ('done', 'open'))
  order by x.ord limit 1;
  if pick is null then raise exception 'challenge_done'; end if;
  insert into y_quan_private.tu_chan_shifts(member_id, room, case_id, challenge_key) values (mid, pick_room, pick, ckey) returning id into sid;
  return jsonb_build_object('shift_id', sid, 'case_id', pick, 'room', pick_room, 'track', p_track, 'resumed', false, 'challenge', true, 'doctor_avatar_id', c.doctor_avatar_id, 'experience', c.experience);
end $function$;

create or replace function public.tu_chan_profile_v1()
 returns jsonb language plpgsql stable security definer
 set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  mid uuid := private.current_member_id();
  c y_quan_private.clinics%rowtype;
  o y_quan_private.tu_chan_shifts%rowtype;
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  select * into c from y_quan_private.clinics where member_id = mid;
  select * into o from y_quan_private.tu_chan_shifts where member_id = mid and status = 'open' and started_at > now() - interval '3 hours';
  return jsonb_build_object(
    'tier', private.tu_chan_member_tier(mid),
    'has_clinic', c.member_id is not null,
    'display_name', (select full_name from public.club_members where id = mid),
    'doctor_avatar_id', c.doctor_avatar_id,
    'experience', coalesce(c.experience, 0),
    'credits', coalesce((select sum(delta) from y_quan_private.credit_ledger where member_id = mid), 0),
    'average_stars', (select round(avg(stars)::numeric, 2) from y_quan_private.ratings where doctor_id = mid),
    'shifts_done', (select count(*) from y_quan_private.tu_chan_shifts where member_id = mid and status = 'done'),
    'avg_score', (select round(avg(score)::numeric, 1) from y_quan_private.tu_chan_shifts where member_id = mid and status = 'done'),
    'today_exp', coalesce((select sum(exp_awarded) from y_quan_private.tu_chan_shifts where member_id = mid and status = 'done' and (finished_at at time zone 'Asia/Ho_Chi_Minh')::date = (now() at time zone 'Asia/Ho_Chi_Minh')::date), 0),
    'open_room', o.room,
    'recent', coalesce((select jsonb_agg(jsonb_build_object('room', room, 'score', score, 'exp', exp_awarded, 'at', finished_at) order by finished_at desc)
      from (select * from y_quan_private.tu_chan_shifts where member_id = mid and status = 'done' order by finished_at desc limit 5) r), '[]'::jsonb)
  );
end $function$;
