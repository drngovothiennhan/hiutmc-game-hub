-- Viện Thực Hành - TMC: ca trực do máy chủ phát ngẫu nhiên, EXP cộng dồn vào hồ sơ bác sĩ HIU Y Quán.
-- Chỉ thêm đối tượng mới. Không sửa bảng, hàm hay dữ liệu của Y Quán đang chạy (ngoại trừ cộng dồn cột clinics.experience khi kết thúc ca).

create table if not exists y_quan_private.tu_chan_catalog (
  case_id text primary key check (case_id ~ '^[a-z0-9][a-z0-9-]{1,80}$'),
  room text not null check (room in ('kham','capcuu')),
  level text,
  active boolean not null default true,
  created_at timestamptz not null default now()
);
create table if not exists y_quan_private.tu_chan_shifts (
  id uuid primary key default gen_random_uuid(),
  member_id uuid not null,
  room text not null check (room in ('kham','capcuu')),
  case_id text not null,
  status text not null default 'open' check (status in ('open','done','abandoned')),
  started_at timestamptz not null default now(),
  finished_at timestamptz,
  score smallint,
  died boolean,
  first_time boolean not null default false,
  exp_awarded integer not null default 0
);
create index if not exists tu_chan_shifts_member_started_idx on y_quan_private.tu_chan_shifts (member_id, started_at desc);
create unique index if not exists tu_chan_shifts_one_open_idx on y_quan_private.tu_chan_shifts (member_id) where status = 'open';
alter table y_quan_private.tu_chan_catalog enable row level security;
alter table y_quan_private.tu_chan_shifts enable row level security;
revoke all on y_quan_private.tu_chan_catalog, y_quan_private.tu_chan_shifts from public, anon, authenticated;

insert into y_quan_private.tu_chan_catalog (case_id, room, level) values
('chan-tam-thong','capcuu','Khó'),
('trung-phong','capcuu','Khó'),
('trung-thu','capcuu','Trung bình'),
('hao-suyen','capcuu','Khó'),
('vi-quan-thong','kham','Dễ'),
('tiet-ta','capcuu','Dễ'),
('huyen-vung','capcuu','Trung bình'),
('yeu-thong','kham','Trung bình'),
('thong-phong','kham','Trung bình'),
('truong-ung','capcuu','Trung bình'),
('soc-phan-ve-thuoc','capcuu','Trung bình'),
('suy-tim-mat-bu-thuy-thung','capcuu','Trung bình'),
('mat-ngu-tam-ty-luong-hu','kham','Dễ'),
('liet-day-vii-ngoai-bien','kham','Trung bình'),
('stemi-thanh-duoi','capcuu','Trung bình'),
('phan-ve-phu-thanh-quan','capcuu','Khó'),
('dot-quy-thieu-mau-cap','capcuu','Khó'),
('ha-duong-huyet-nang','capcuu','Dễ'),
('xhth-tren-xo-gan','capcuu','Trung bình'),
('co-giat-do-sot-cao-tre-em','capcuu','Dễ'),
('thung-o-loet-da-day-ta-trang','capcuu','Dễ'),
('ngo-doc-phospho-huu-co','capcuu','Trung bình'),
('nhiem-toan-ceton-dai-thao-duong','capcuu','Trung bình'),
('vo-lach-chan-thuong-bung-kin','capcuu','Khó'),
('thai-ngoai-tu-cung-vo','capcuu','Khó'),
('kham-tyc-viem-mui-di-ung','kham','Dễ'),
('kham-nhi-bieng-an-ty-hu','kham','Dễ'),
('kham-ho-man-viem-phe-quan-dam-thap','kham','Trung bình'),
('kham-dau-nua-dau-can-duong','kham','Trung bình'),
('kham-thong-ta-ruot-kich-thich','kham','Trung bình'),
('kham-thong-kinh-khi-tre-huyet-u','kham','Trung bình'),
('kham-tieu-khat-dai-thao-duong-tip-2','kham','Khó'),
('kham-tao-bon-man-cao-tuoi-da-benh','kham','Khó'),
('canh-vai-tay-thoai-hoa-csc','kham','Trung bình'),
('thoai-hoa-khop-goi-han-that','kham','Dễ'),
('toa-cot-phong-thoat-vi-dia-dem','kham','Khó'),
('hoi-chung-ong-co-tay-huyet-hu','kham','Trung bình'),
('viem-quanh-khop-vai-dong-cung','kham','Dễ'),
('dau-nua-dau-can-duong-thuong-cang','kham','Trung bình'),
('di-chung-tai-bien-khi-hu-huyet-u','kham','Khó')
on conflict (case_id) do update set room = excluded.room, level = excluded.level;

create or replace function public.tu_chan_profile_v1()
returns jsonb
language plpgsql
stable
security definer
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

create or replace function public.tu_chan_start_shift_v1(p_room text)
returns jsonb
language plpgsql
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  mid uuid := private.current_member_id();
  c y_quan_private.clinics%rowtype;
  o y_quan_private.tu_chan_shifts%rowtype;
  pick text;
  sid uuid;
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  if p_room not in ('kham','capcuu') then raise exception 'Room invalid'; end if;
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
   where k.active and k.room = p_room
     and k.case_id not in (select case_id from y_quan_private.tu_chan_shifts where member_id = mid order by started_at desc limit 12)
   order by random() limit 1;
  if pick is null then
    select k.case_id into pick from y_quan_private.tu_chan_catalog k where k.active and k.room = p_room order by random() limit 1;
  end if;
  if pick is null then raise exception 'no_case'; end if;
  insert into y_quan_private.tu_chan_shifts(member_id, room, case_id) values (mid, p_room, pick) returning id into sid;
  return jsonb_build_object('shift_id', sid, 'case_id', pick, 'room', p_room, 'resumed', false, 'doctor_avatar_id', c.doctor_avatar_id, 'experience', c.experience);
end $function$;

create or replace function public.tu_chan_finish_shift_v1(p_shift_id uuid, p_score integer, p_died boolean default false)
returns jsonb
language plpgsql
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  mid uuid := private.current_member_id();
  s y_quan_private.tu_chan_shifts%rowtype;
  sc integer := least(100, greatest(0, coalesce(p_score, 0)));
  dead boolean := coalesce(p_died, false);
  gain integer;
  used integer;
  v_first boolean;
  total bigint;
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  select * into s from y_quan_private.tu_chan_shifts where id = p_shift_id and member_id = mid for update;
  if s.id is null then raise exception 'Shift not found'; end if;
  if s.status <> 'open' then
    select experience into total from y_quan_private.clinics where member_id = mid;
    return jsonb_build_object('ok', true, 'already', true, 'exp_awarded', s.exp_awarded, 'experience', coalesce(total, 0), 'score', s.score, 'first_time', s.first_time);
  end if;
  v_first := not exists (select 1 from y_quan_private.tu_chan_shifts where member_id = mid and case_id = s.case_id and status = 'done');
  gain := case when dead then 2 else 5 + round(sc * 0.25)::integer + case when sc >= 85 then 5 else 0 end end;
  if v_first and not dead then gain := gain + 5; end if;
  if now() - s.started_at < interval '40 seconds' then gain := 0; end if;
  select coalesce(sum(exp_awarded), 0) into used from y_quan_private.tu_chan_shifts
   where member_id = mid and status = 'done' and (finished_at at time zone 'Asia/Ho_Chi_Minh')::date = (now() at time zone 'Asia/Ho_Chi_Minh')::date;
  gain := least(gain, greatest(0, 400 - used));
  update y_quan_private.tu_chan_shifts set status = 'done', finished_at = now(), score = sc, died = dead, first_time = v_first, exp_awarded = gain where id = s.id;
  update y_quan_private.clinics set experience = experience + gain, updated_at = now() where member_id = mid returning experience into total;
  return jsonb_build_object('ok', true, 'already', false, 'exp_awarded', gain, 'experience', coalesce(total, 0), 'score', sc, 'first_time', v_first);
end $function$;

create or replace function public.tu_chan_register_cases_v1(p_cases jsonb)
returns integer
language plpgsql
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare n integer := 0; r record;
begin
  if not exists (select 1 from public.garden_hub_current_member_role_v1() g where g.role = 'admin') then raise exception 'Admin required'; end if;
  if jsonb_typeof(p_cases) <> 'array' then raise exception 'Array required'; end if;
  for r in select x->>'id' as id, x->>'room' as room, x->>'level' as level from jsonb_array_elements(p_cases) x loop
    insert into y_quan_private.tu_chan_catalog(case_id, room, level) values (r.id, r.room, r.level)
    on conflict (case_id) do update set room = excluded.room, level = excluded.level, active = true;
    n := n + 1;
  end loop;
  return n;
end $function$;

revoke all on function public.tu_chan_profile_v1(), public.tu_chan_start_shift_v1(text), public.tu_chan_finish_shift_v1(uuid, integer, boolean), public.tu_chan_register_cases_v1(jsonb) from public, anon;
grant execute on function public.tu_chan_profile_v1(), public.tu_chan_start_shift_v1(text), public.tu_chan_finish_shift_v1(uuid, integer, boolean), public.tu_chan_register_cases_v1(jsonb) to authenticated, service_role;
