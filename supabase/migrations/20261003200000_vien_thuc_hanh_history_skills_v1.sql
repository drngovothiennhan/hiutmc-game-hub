-- Viện Thực Hành: lưu điểm theo kỹ năng của từng ca trực và trả về lịch sử trực.
-- Chỉ thêm cột và hàm mới. Giữ nguyên tu_chan_finish_shift_v1 và tu_chan_profile_v1 để bản cũ vẫn chạy.

alter table y_quan_private.tu_chan_shifts add column if not exists skills jsonb;

-- Ghi điểm kỹ năng (0-100) cho ca vừa kết thúc, sau đó dùng đúng logic tính EXP của v1.
create or replace function public.tu_chan_finish_shift_v2(p_shift_id uuid, p_score integer, p_died boolean default false, p_skills jsonb default null)
returns jsonb
language plpgsql
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  mid uuid := private.current_member_id();
  res jsonb;
  clean jsonb := '{}'::jsonb;
  k text;
  v numeric;
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  res := public.tu_chan_finish_shift_v1(p_shift_id, p_score, p_died);
  if p_skills is not null and jsonb_typeof(p_skills) = 'object' then
    foreach k in array array['hoi_benh','kham','cls','chan_doan','xu_tri','an_toan'] loop
      if p_skills ? k and jsonb_typeof(p_skills -> k) = 'number' then
        v := (p_skills ->> k)::numeric;
        clean := clean || jsonb_build_object(k, least(100, greatest(0, round(v)))::integer);
      end if;
    end loop;
    if clean <> '{}'::jsonb then
      update y_quan_private.tu_chan_shifts
         set skills = clean
       where id = p_shift_id and member_id = mid and status = 'done' and skills is null;
    end if;
  end if;
  return res;
end $function$;

-- Lịch sử trực: điểm trung bình theo kỹ năng, theo khoa và các ca gần nhất.
create or replace function public.tu_chan_history_v1(p_limit integer default 10)
returns jsonb
language plpgsql
stable
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  mid uuid := private.current_member_id();
  lim integer := least(50, greatest(1, coalesce(p_limit, 10)));
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  return jsonb_build_object(
    'skills', (
      select coalesce(jsonb_object_agg(k, a), '{}'::jsonb) from (
        select k, round(avg((s.skills ->> k)::numeric))::integer as a
        from (select skills from y_quan_private.tu_chan_shifts
               where member_id = mid and status = 'done' and skills is not null
               order by finished_at desc limit 20) s,
             unnest(array['hoi_benh','kham','cls','chan_doan','xu_tri','an_toan']) k
        where s.skills ? k
        group by k
      ) z
    ),
    'skills_n', (select count(*) from (select 1 from y_quan_private.tu_chan_shifts
                  where member_id = mid and status = 'done' and skills is not null
                  order by finished_at desc limit 20) q),
    'tracks', (
      select coalesce(jsonb_object_agg(track, jsonb_build_object('n', n, 'avg', a)), '{}'::jsonb) from (
        select coalesce(c.track, 'khac') as track, count(*) as n, round(avg(s.score))::integer as a
        from y_quan_private.tu_chan_shifts s
        left join y_quan_private.tu_chan_catalog c on c.case_id = s.case_id
        where s.member_id = mid and s.status = 'done'
        group by 1
      ) t
    ),
    'recent', coalesce((
      select jsonb_agg(jsonb_build_object('case_id', r.case_id, 'track', r.track, 'score', r.score, 'died', r.died, 'exp', r.exp_awarded, 'at', r.finished_at, 'skills', r.skills) order by r.finished_at desc)
      from (
        select s.case_id, c.track, s.score, s.died, s.exp_awarded, s.finished_at, s.skills
        from y_quan_private.tu_chan_shifts s
        left join y_quan_private.tu_chan_catalog c on c.case_id = s.case_id
        where s.member_id = mid and s.status = 'done'
        order by s.finished_at desc limit lim
      ) r
    ), '[]'::jsonb)
  );
end $function$;

revoke all on function public.tu_chan_finish_shift_v2(uuid, integer, boolean, jsonb), public.tu_chan_history_v1(integer) from public, anon;
grant execute on function public.tu_chan_finish_shift_v2(uuid, integer, boolean, jsonb), public.tu_chan_history_v1(integer) to authenticated, service_role;
