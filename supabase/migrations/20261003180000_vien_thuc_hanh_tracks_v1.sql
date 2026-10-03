-- Viện Thực Hành: lọc ca trực theo ba chuyên khoa (Nội, Ngoại, Y học cổ truyền).
-- Chỉ thêm cột và hàm mới; giữ nguyên tu_chan_start_shift_v1 để bản cũ vẫn chạy.

alter table y_quan_private.tu_chan_catalog add column if not exists track text;
do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'tu_chan_catalog_track_check') then
    alter table y_quan_private.tu_chan_catalog add constraint tu_chan_catalog_track_check check (track is null or track in ('noi','ngoai','yhct'));
  end if;
end $$;

update y_quan_private.tu_chan_catalog set track = 'yhct' where track is null and case_id in ('chan-tam-thong', 'trung-phong', 'trung-thu', 'hao-suyen', 'vi-quan-thong', 'tiet-ta', 'huyen-vung', 'yeu-thong', 'thong-phong', 'truong-ung', 'soc-phan-ve-thuoc', 'suy-tim-mat-bu-thuy-thung', 'mat-ngu-tam-ty-luong-hu', 'liet-day-vii-ngoai-bien', 'stemi-thanh-duoi', 'phan-ve-phu-thanh-quan', 'dot-quy-thieu-mau-cap', 'ha-duong-huyet-nang', 'xhth-tren-xo-gan', 'kham-tyc-viem-mui-di-ung', 'kham-nhi-bieng-an-ty-hu', 'kham-ho-man-viem-phe-quan-dam-thap', 'kham-dau-nua-dau-can-duong', 'kham-thong-ta-ruot-kich-thich', 'kham-thong-kinh-khi-tre-huyet-u', 'kham-tieu-khat-dai-thao-duong-tip-2', 'kham-tao-bon-man-cao-tuoi-da-benh', 'canh-vai-tay-thoai-hoa-csc', 'thoai-hoa-khop-goi-han-that', 'toa-cot-phong-thoat-vi-dia-dem', 'hoi-chung-ong-co-tay-huyet-hu', 'viem-quanh-khop-vai-dong-cung', 'dau-nua-dau-can-duong-thuong-cang', 'di-chung-tai-bien-khi-hu-huyet-u');
update y_quan_private.tu_chan_catalog set track = 'noi' where track is null and case_id in ('co-giat-do-sot-cao-tre-em', 'ngo-doc-phospho-huu-co', 'nhiem-toan-ceton-dai-thao-duong');
update y_quan_private.tu_chan_catalog set track = 'ngoai' where track is null and case_id in ('thung-o-loet-da-day-ta-trang', 'vo-lach-chan-thuong-bung-kin', 'thai-ngoai-tu-cung-vo');
update y_quan_private.tu_chan_catalog set track = 'noi' where track is null and case_id in ('noi-tieu-hoa-001', 'noi-tieu-hoa-002', 'noi-tieu-hoa-003', 'noi-tieu-hoa-004', 'noi-tieu-hoa-005', 'noi-tieu-hoa-006', 'noi-tieu-hoa-007', 'noi-tieu-hoa-008', 'noi-tieu-hoa-009', 'noi-tieu-hoa-010');

create or replace function public.tu_chan_start_shift_v2(p_track text)
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
  pick_room text;
  sid uuid;
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
    return jsonb_build_object('shift_id', o.id, 'case_id', o.case_id, 'room', o.room, 'track', (select k.track from y_quan_private.tu_chan_catalog k where k.case_id = o.case_id), 'resumed', true, 'doctor_avatar_id', c.doctor_avatar_id, 'experience', c.experience);
  end if;
  if (select count(*) from y_quan_private.tu_chan_shifts where member_id = mid and (started_at at time zone 'Asia/Ho_Chi_Minh')::date = (now() at time zone 'Asia/Ho_Chi_Minh')::date) >= 40 then
    raise exception 'daily_limit';
  end if;
  select k.case_id, k.room into pick, pick_room from y_quan_private.tu_chan_catalog k
   where k.active and k.track = p_track
     and k.case_id not in (select case_id from y_quan_private.tu_chan_shifts where member_id = mid order by started_at desc limit 12)
   order by random() limit 1;
  if pick is null then
    select k.case_id, k.room into pick, pick_room from y_quan_private.tu_chan_catalog k where k.active and k.track = p_track order by random() limit 1;
  end if;
  if pick is null then raise exception 'no_case'; end if;
  insert into y_quan_private.tu_chan_shifts(member_id, room, case_id) values (mid, pick_room, pick) returning id into sid;
  return jsonb_build_object('shift_id', sid, 'case_id', pick, 'room', pick_room, 'track', p_track, 'resumed', false, 'doctor_avatar_id', c.doctor_avatar_id, 'experience', c.experience);
end $function$;

create or replace function public.tu_chan_register_cases_v1(p_cases jsonb)
returns integer
language plpgsql
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  n integer := 0;
  r record;
  v_active boolean;
begin
  if not exists (select 1 from public.garden_hub_current_member_role_v1() g where g.role = 'admin') then
    raise exception 'Admin required';
  end if;
  if jsonb_typeof(p_cases) <> 'array' then raise exception 'Array required'; end if;
  for r in
    select x->>'id' as id, x->>'room' as room, x->>'level' as level, nullif(x->>'status', '') as status, nullif(x->>'track', '') as track
    from jsonb_array_elements(p_cases) x
  loop
    if r.id is null or r.id !~ '^[a-z0-9][a-z0-9-]{1,80}$' then raise exception 'Case id invalid'; end if;
    if r.room not in ('kham', 'capcuu') then raise exception 'Case room invalid for %', r.id; end if;
    if r.track is not null and r.track not in ('noi','ngoai','yhct') then raise exception 'Case track invalid for %', r.id; end if;
    v_active := case
      when r.status = 'nhap' then false
      when r.status in ('draft', 'reviewed', 'approved') then true
      else null
    end;
    insert into y_quan_private.tu_chan_catalog(case_id, room, level, active, track)
    values (r.id, r.room, r.level, coalesce(v_active, false), r.track)
    on conflict (case_id) do update
      set room = excluded.room,
          level = excluded.level,
          track = coalesce(excluded.track, y_quan_private.tu_chan_catalog.track),
          active = case
            when r.status = 'nhap' then false
            when r.status in ('draft', 'reviewed', 'approved') then true
            else y_quan_private.tu_chan_catalog.active
          end;
    n := n + 1;
  end loop;
  return n;
end $function$;

revoke all on function public.tu_chan_start_shift_v2(text) from public, anon;
grant execute on function public.tu_chan_start_shift_v2(text) to authenticated, service_role;
