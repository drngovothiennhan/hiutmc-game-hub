-- Gia Viên Dược Thảo progress v1 (additive only).
-- Stores the Gia Viên journey state per approved HIU TMC member, so progress
-- follows the account instead of only the device. Grants no credits, rewards
-- or Garden/Y Quán data, and changes no existing table or RPC.
-- Not applied to production yet: apply only after the preview login test passes.

create table if not exists public.gia_vien_progress (
  member_id uuid primary key references public.club_members(id) on delete cascade,
  state jsonb not null default '{}'::jsonb
    check (jsonb_typeof(state) = 'object' and octet_length(state::text) <= 20000),
  updated_at timestamptz not null default now()
);

alter table public.gia_vien_progress enable row level security;
revoke all on public.gia_vien_progress from public, anon, authenticated;

create or replace function public.gia_vien_get_progress_v1()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  mid uuid := private.current_member_id();
begin
  if mid is null or not private.is_approved() then
    raise exception 'Approved member required';
  end if;
  return (select p.state from public.gia_vien_progress p where p.member_id = mid);
end;
$$;

create or replace function public.gia_vien_save_progress_v1(p_state jsonb)
returns timestamptz
language plpgsql
security definer
set search_path = ''
as $$
declare
  mid uuid := private.current_member_id();
  v_at timestamptz := now();
begin
  if mid is null or not private.is_approved() then
    raise exception 'Approved member required';
  end if;
  if p_state is null or jsonb_typeof(p_state) <> 'object' or octet_length(p_state::text) > 20000 then
    raise exception 'Invalid progress payload';
  end if;
  insert into public.gia_vien_progress (member_id, state, updated_at)
  values (mid, p_state, v_at)
  on conflict (member_id) do update
    set state = excluded.state, updated_at = excluded.updated_at;
  return v_at;
end;
$$;

revoke all on function public.gia_vien_get_progress_v1() from public, anon;
grant execute on function public.gia_vien_get_progress_v1() to authenticated;
revoke all on function public.gia_vien_save_progress_v1(jsonb) from public, anon;
grant execute on function public.gia_vien_save_progress_v1(jsonb) to authenticated;
