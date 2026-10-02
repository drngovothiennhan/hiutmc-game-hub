-- Viện Thực Hành: fail closed for intake cases when syncing the duty catalog.
-- Existing released legacy cases use status "draft"; new intake cases use "nhap".
-- Missing/unknown status must never activate a brand-new catalog row.

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
  if not exists (
    select 1 from public.garden_hub_current_member_role_v1() g where g.role = 'admin'
  ) then
    raise exception 'Admin required';
  end if;
  if jsonb_typeof(p_cases) <> 'array' then
    raise exception 'Array required';
  end if;

  for r in
    select
      x->>'id' as id,
      x->>'room' as room,
      x->>'level' as level,
      nullif(x->>'status', '') as status
    from jsonb_array_elements(p_cases) x
  loop
    if r.id is null or r.id !~ '^[a-z0-9][a-z0-9-]{1,80}$' then
      raise exception 'Case id invalid';
    end if;
    if r.room not in ('kham', 'capcuu') then
      raise exception 'Case room invalid for %', r.id;
    end if;

    v_active := case
      when r.status = 'nhap' then false
      when r.status in ('draft', 'reviewed', 'approved') then true
      else null
    end;

    insert into y_quan_private.tu_chan_catalog(case_id, room, level, active)
    values (r.id, r.room, r.level, coalesce(v_active, false))
    on conflict (case_id) do update
      set room = excluded.room,
          level = excluded.level,
          active = case
            when r.status = 'nhap' then false
            when r.status in ('draft', 'reviewed', 'approved') then true
            else y_quan_private.tu_chan_catalog.active
          end;
    n := n + 1;
  end loop;
  return n;
end $function$;

-- Keep the ten intake GI cases out of random duty assignment until they are reviewed.
update y_quan_private.tu_chan_catalog
set active = false
where case_id in (
  'noi-tieu-hoa-001','noi-tieu-hoa-002','noi-tieu-hoa-003','noi-tieu-hoa-004','noi-tieu-hoa-005',
  'noi-tieu-hoa-006','noi-tieu-hoa-007','noi-tieu-hoa-008','noi-tieu-hoa-009','noi-tieu-hoa-010'
);

revoke all on function public.tu_chan_register_cases_v1(jsonb) from public, anon;
grant execute on function public.tu_chan_register_cases_v1(jsonb) to authenticated, service_role;
