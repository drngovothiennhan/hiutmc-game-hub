-- Viện Thực Hành: cá nhân hóa HIU Y Quán theo cấp. Cấp tính từ EXP của y quán (clinics.experience).
-- Cấp 4 (700 EXP) đổi tên hiển thị và lời chào; cấp 5 áo học viện; cấp 6 áo tông sư; cấp 7 giao diện Danh y.
-- Thêm bảng và hàm mới; hai hàm cũ hiu_y_quan_activate_v1, hiu_y_quan_customize_v1 chỉ được thêm bước kiểm tra cấp khi đổi tên hoặc đổi áo.

create or replace function private.tu_chan_level(p_exp bigint)
returns integer language sql immutable
as $$ select case when coalesce(p_exp,0) >= 6000 then 7 when p_exp >= 3000 then 6 when p_exp >= 1500 then 5
                  when p_exp >= 700 then 4 when p_exp >= 300 then 3 when p_exp >= 100 then 2 else 1 end $$;

create table if not exists y_quan_private.tu_chan_personal (
  member_id uuid primary key,
  theme text not null default 'ngoc' check (theme in ('ngoc','dao','cham','muc','vang')),
  frame text not null default 'none' check (frame in ('none','tre','sen','rong')),
  motto text check (motto is null or char_length(motto) <= 60),
  updated_at timestamptz not null default now()
);
alter table y_quan_private.tu_chan_personal enable row level security;
revoke all on y_quan_private.tu_chan_personal from public, anon, authenticated;

create or replace function private.tu_chan_personal_json(p_mid uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private'
as $function$
declare lvl integer; ex bigint; pr record; pe record;
begin
  select coalesce(c.experience, 0) into ex from y_quan_private.clinics c where c.member_id = p_mid;
  lvl := private.tu_chan_level(coalesce(ex, 0));
  select display_name, outfit into pr from public.hiu_y_quan_profiles where member_id = p_mid;
  select theme, frame, motto into pe from y_quan_private.tu_chan_personal where member_id = p_mid;
  return jsonb_build_object(
    'level', lvl, 'experience', coalesce(ex, 0),
    'has_profile', pr.display_name is not null,
    'display_name', pr.display_name, 'outfit', coalesce(pr.outfit, 'classic'),
    'theme', coalesce(pe.theme, 'ngoc'), 'frame', coalesce(pe.frame, 'none'), 'motto', pe.motto,
    'unlock', jsonb_build_object(
      'rename', 4, 'motto', 4,
      'themes', jsonb_build_object('ngoc', 1, 'dao', 4, 'cham', 4, 'muc', 5, 'vang', 7),
      'frames', jsonb_build_object('none', 1, 'tre', 4, 'sen', 5, 'rong', 6),
      'outfits', jsonb_build_object('classic', 1, 'academy', 5, 'master', 6)));
end $function$;

create or replace function public.tu_chan_personal_v1()
returns jsonb
language plpgsql
stable
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare mid uuid := private.current_member_id();
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  return private.tu_chan_personal_json(mid);
end $function$;

-- Lưu cá nhân hóa. Tham số null nghĩa là giữ nguyên. Chỉ kiểm tra cấp với phần thật sự thay đổi.
create or replace function public.tu_chan_personalize_v1(p_display_name text default null, p_motto text default null, p_theme text default null, p_frame text default null, p_outfit text default null)
returns jsonb
language plpgsql
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  mid uuid := private.current_member_id();
  lvl integer; cur_name text; cur_outfit text; cur_theme text; cur_frame text; cur_motto text;
  nm text; mt text; th text; fr text; ou text; need integer;
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  select display_name, coalesce(outfit, 'classic') into cur_name, cur_outfit from public.hiu_y_quan_profiles where member_id = mid;
  if cur_name is null then raise exception 'profile_required'; end if;
  lvl := private.tu_chan_level(coalesce((select experience from y_quan_private.clinics where member_id = mid), 0));
  select coalesce(theme, 'ngoc'), coalesce(frame, 'none'), motto into cur_theme, cur_frame, cur_motto from y_quan_private.tu_chan_personal where member_id = mid;
  cur_theme := coalesce(cur_theme, 'ngoc'); cur_frame := coalesce(cur_frame, 'none');

  nm := coalesce(btrim(p_display_name), cur_name);
  if nm is distinct from cur_name then
    if lvl < 4 then raise exception 'locked:rename:4'; end if;
    if char_length(nm) not between 2 and 40 or nm ~ '[<>&[:cntrl:]]' then raise exception 'invalid_name'; end if;
  end if;

  mt := case when p_motto is null then cur_motto else nullif(btrim(p_motto), '') end;
  if mt is distinct from cur_motto and mt is not null then
    if lvl < 4 then raise exception 'locked:motto:4'; end if;
    if char_length(mt) > 60 or mt ~ '[<>&[:cntrl:]]' then raise exception 'invalid_motto'; end if;
  end if;

  th := coalesce(lower(btrim(p_theme)), cur_theme);
  if th not in ('ngoc','dao','cham','muc','vang') then raise exception 'invalid_theme'; end if;
  if th <> cur_theme then
    need := case th when 'ngoc' then 1 when 'dao' then 4 when 'cham' then 4 when 'muc' then 5 else 7 end;
    if lvl < need then raise exception 'locked:theme:%', need; end if;
  end if;

  fr := coalesce(lower(btrim(p_frame)), cur_frame);
  if fr not in ('none','tre','sen','rong') then raise exception 'invalid_frame'; end if;
  if fr <> cur_frame then
    need := case fr when 'none' then 1 when 'tre' then 4 when 'sen' then 5 else 6 end;
    if lvl < need then raise exception 'locked:frame:%', need; end if;
  end if;

  ou := coalesce(lower(btrim(p_outfit)), cur_outfit);
  if ou not in ('classic','academy','master') then raise exception 'invalid_outfit'; end if;
  if ou <> cur_outfit then
    need := case ou when 'classic' then 1 when 'academy' then 5 else 6 end;
    if lvl < need then raise exception 'locked:outfit:%', need; end if;
  end if;

  update public.hiu_y_quan_profiles set display_name = nm, outfit = ou, updated_at = now() where member_id = mid;
  insert into y_quan_private.tu_chan_personal(member_id, theme, frame, motto, updated_at) values (mid, th, fr, mt, now())
  on conflict (member_id) do update set theme = excluded.theme, frame = excluded.frame, motto = excluded.motto, updated_at = now();
  return private.tu_chan_personal_json(mid);
end $function$;

-- Hàm cũ: đổi tên hiển thị của hồ sơ đã có cần đạt cấp 4. Kích hoạt lần đầu và giữ nguyên tên không bị ảnh hưởng.
create or replace function public.hiu_y_quan_activate_v1(p_display_name text, p_gender text)
returns jsonb
language plpgsql
security definer
set search_path to ''
as $function$
declare mid uuid:=private.current_member_id(); clean_name text:=btrim(coalesce(p_display_name,'')); clean_gender text:=lower(btrim(coalesce(p_gender,'')));
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  if char_length(clean_name) not between 2 and 40 then raise exception 'Tên nhân vật phải từ 2 đến 40 ký tự.'; end if;
  if clean_gender not in ('male','female') then raise exception 'Giới tính nhân vật không hợp lệ.'; end if;
  if exists (select 1 from public.hiu_y_quan_profiles where member_id = mid and display_name is distinct from clean_name)
     and private.tu_chan_level(coalesce((select experience from y_quan_private.clinics where member_id = mid), 0)) < 4 then
    raise exception 'Cần đạt cấp 4 (Bác sĩ điều trị, 700 EXP) để đổi tên hiển thị.';
  end if;
  insert into public.hiu_y_quan_profiles(member_id,display_name,gender,activated_at,updated_at)
  values(mid,clean_name,clean_gender,now(),now())
  on conflict(member_id) do update set display_name=excluded.display_name,gender=excluded.gender,updated_at=now();
  perform private.ensure_herb_garden_wallet(mid);
  return jsonb_build_object('active',true,'display_name',clean_name,'gender',clean_gender,'wallet_balance',(select balance from public.herb_garden_wallets where member_id=mid));
end $function$;

-- Hàm cũ: đổi sang áo học viện cần cấp 5, áo tông sư cần cấp 6. Giữ nguyên áo hiện tại không bị ảnh hưởng.
create or replace function public.hiu_y_quan_customize_v1(p_gender text, p_outfit text)
returns jsonb
language plpgsql
security definer
set search_path to ''
as $function$
declare
  mid uuid:=private.current_member_id();
  clean_gender text:=lower(btrim(coalesce(p_gender,'')));
  clean_outfit text:=lower(btrim(coalesce(p_outfit,'')));
  cur_outfit text; need integer; lvl integer;
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  if clean_gender not in ('male','female') then raise exception 'Giới tính nhân vật không hợp lệ.'; end if;
  if clean_outfit not in ('classic','academy','master') then raise exception 'Trang phục nhân vật không hợp lệ.'; end if;
  select coalesce(outfit,'classic') into cur_outfit from public.hiu_y_quan_profiles where member_id = mid;
  need := case clean_outfit when 'classic' then 1 when 'academy' then 5 else 6 end;
  lvl := private.tu_chan_level(coalesce((select experience from y_quan_private.clinics where member_id = mid), 0));
  if cur_outfit is not null and clean_outfit <> cur_outfit and lvl < need then
    raise exception 'Trang phục này cần cấp cao hơn. Áo học viện: cấp 5, áo tông sư: cấp 6.';
  end if;
  update public.hiu_y_quan_profiles
  set gender=clean_gender,outfit=clean_outfit,updated_at=now()
  where member_id=mid;
  if not found then raise exception 'Hãy kích hoạt nhân vật HIU - Y - Quán trước.'; end if;
  return jsonb_build_object('ok',true,'gender',clean_gender,'outfit',clean_outfit);
end $function$;

revoke all on function public.tu_chan_personal_v1(), public.tu_chan_personalize_v1(text, text, text, text, text) from public, anon;
grant execute on function public.tu_chan_personal_v1(), public.tu_chan_personalize_v1(text, text, text, text, text) to authenticated, service_role;
revoke all on function private.tu_chan_level(bigint), private.tu_chan_personal_json(uuid) from public, anon, authenticated;
