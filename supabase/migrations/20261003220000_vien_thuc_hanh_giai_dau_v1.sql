-- Viện Thực Hành: giải đấu tuần. Mỗi khoa mỗi tuần có tối đa 3 ca cố định cho mọi người chơi.
-- Chỉ thêm bảng, cột và hàm mới. Không đổi hàm cũ.

alter table y_quan_private.tu_chan_shifts add column if not exists challenge_key text;
create index if not exists tu_chan_shifts_challenge_idx on y_quan_private.tu_chan_shifts (challenge_key, member_id) where challenge_key is not null;

-- Bộ ca của tuần được chốt ở lần gọi đầu tiên, đổi danh mục giữa tuần không làm xáo trộn giải.
create table if not exists y_quan_private.tu_chan_challenges (
  challenge_key text primary key,
  case_ids text[] not null,
  created_at timestamptz not null default now()
);
alter table y_quan_private.tu_chan_challenges enable row level security;
revoke all on y_quan_private.tu_chan_challenges from public, anon, authenticated;

create or replace function private.tu_chan_week_key()
returns text language sql stable
as $$ select to_char((now() at time zone 'Asia/Ho_Chi_Minh')::date, 'IYYY"-W"IW') $$;

-- Lấy hoặc tạo bộ ca của tuần cho một khoa (tối đa 3 ca đang hoạt động, xếp theo băm cố định).
create or replace function private.tu_chan_challenge_cases(p_key text, p_track text)
returns text[]
language plpgsql
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private'
as $function$
declare ids text[];
begin
  select case_ids into ids from y_quan_private.tu_chan_challenges where challenge_key = p_key;
  if ids is not null then return ids; end if;
  select coalesce(array_agg(z.case_id order by z.h), '{}') into ids from (
    select k.case_id, md5(p_key || ':' || k.case_id) as h
    from y_quan_private.tu_chan_catalog k
    where k.active and k.track = p_track
    order by h limit 3
  ) z;
  if coalesce(array_length(ids, 1), 0) > 0 then
    insert into y_quan_private.tu_chan_challenges(challenge_key, case_ids) values (p_key, ids) on conflict do nothing;
    select case_ids into ids from y_quan_private.tu_chan_challenges where challenge_key = p_key;
  end if;
  return ids;
end $function$;

-- Trạng thái giải tuần: ca của tuần, kết quả của tôi, bảng xếp hạng top 10.
-- Điểm mỗi ca = điểm của lượt hoàn tất đầu tiên (mỗi ca một lượt tính giải). Lượt dưới 60 giây không được tính điểm.
create or replace function public.tu_chan_challenge_v1(p_track text)
returns jsonb
language plpgsql
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  mid uuid := private.current_member_id();
  ckey text; ids text[]; ends timestamptz; cases jsonb; board jsonb; me jsonb; players bigint;
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  if p_track not in ('noi','ngoai','yhct') then raise exception 'Track invalid'; end if;
  ckey := private.tu_chan_week_key() || ':' || p_track;
  ids := private.tu_chan_challenge_cases(ckey, p_track);
  ends := (date_trunc('week', now() at time zone 'Asia/Ho_Chi_Minh') + interval '7 days') at time zone 'Asia/Ho_Chi_Minh';

  with firsts as (
    select distinct on (s.member_id, s.case_id) s.member_id, s.case_id,
           case when s.finished_at - s.started_at >= interval '60 seconds' then coalesce(s.score, 0) else 0 end as score,
           s.finished_at
    from y_quan_private.tu_chan_shifts s
    where s.challenge_key = ckey and s.status = 'done' and s.case_id = any(coalesce(ids, '{}'))
    order by s.member_id, s.case_id, s.finished_at
  ), tot as (
    select member_id, sum(score)::integer as total, count(*)::integer as n, max(finished_at) as last
    from firsts group by member_id
  ), ranked as (
    select t.*, row_number() over (order by t.total desc, t.n desc, t.last asc) as rk from tot t
  )
  select
    coalesce((select jsonb_agg(jsonb_build_object('case_id', x.cid, 'level', k.level, 'room', k.room, 'my_score', f.score, 'my_done', f.case_id is not null) order by x.ord)
              from unnest(coalesce(ids, '{}')) with ordinality as x(cid, ord)
              left join y_quan_private.tu_chan_catalog k on k.case_id = x.cid
              left join firsts f on f.case_id = x.cid and f.member_id = mid), '[]'::jsonb),
    coalesce((select jsonb_agg(jsonb_build_object('rank', r.rk, 'name', left(coalesce(nullif(btrim(p.display_name), ''), 'Bác sĩ ẩn danh'), 40), 'total', r.total, 'n', r.n, 'me', r.member_id = mid) order by r.rk)
              from ranked r left join public.hiu_y_quan_profiles p on p.member_id = r.member_id
              where r.rk <= 10), '[]'::jsonb),
    (select jsonb_build_object('rank', r.rk, 'total', r.total, 'n', r.n) from ranked r where r.member_id = mid),
    (select count(*) from ranked)
  into cases, board, me, players;

  return jsonb_build_object(
    'key', ckey, 'week', private.tu_chan_week_key(), 'ends_at', ends,
    'n_cases', coalesce(array_length(ids, 1), 0), 'cases', cases, 'board', board,
    'players', players, 'me', me);
end $function$;

-- Nhận ca kế tiếp của giải tuần (ca chưa hoàn tất trong tuần). Nếu đang có ca dở thì tiếp tục ca đó.
create or replace function public.tu_chan_start_challenge_v1(p_track text)
returns jsonb
language plpgsql
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  mid uuid := private.current_member_id();
  c y_quan_private.clinics%rowtype;
  o y_quan_private.tu_chan_shifts%rowtype;
  ckey text; ids text[]; pick text; pick_room text; sid uuid;
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  if p_track not in ('noi','ngoai','yhct') then raise exception 'Track invalid'; end if;
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
  where not exists (select 1 from y_quan_private.tu_chan_shifts s where s.member_id = mid and s.challenge_key = ckey and s.case_id = x.cid and s.status in ('done', 'open'))
  order by x.ord limit 1;
  if pick is null then raise exception 'challenge_done'; end if;
  insert into y_quan_private.tu_chan_shifts(member_id, room, case_id, challenge_key) values (mid, pick_room, pick, ckey) returning id into sid;
  return jsonb_build_object('shift_id', sid, 'case_id', pick, 'room', pick_room, 'track', p_track, 'resumed', false, 'challenge', true, 'doctor_avatar_id', c.doctor_avatar_id, 'experience', c.experience);
end $function$;

revoke all on function public.tu_chan_challenge_v1(text), public.tu_chan_start_challenge_v1(text) from public, anon;
grant execute on function public.tu_chan_challenge_v1(text), public.tu_chan_start_challenge_v1(text) to authenticated, service_role;
revoke all on function private.tu_chan_challenge_cases(text, text), private.tu_chan_week_key() from public, anon, authenticated;
