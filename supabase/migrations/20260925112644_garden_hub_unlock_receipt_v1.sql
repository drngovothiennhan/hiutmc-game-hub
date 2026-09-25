create schema if not exists game_hub_private;
revoke all on schema game_hub_private from public, anon, authenticated;
grant usage on schema game_hub_private to authenticated;

create table if not exists game_hub_private.garden_hub_unlock_receipts (
  receipt_id uuid primary key default gen_random_uuid(),
  member_id uuid not null,
  game_key text not null check (game_key = 'garden-extended-v1'),
  granted_at timestamptz not null default now(),
  constraint garden_hub_unlock_receipts_member_game_key unique (member_id, game_key)
);
alter table game_hub_private.garden_hub_unlock_receipts enable row level security;
revoke all on table game_hub_private.garden_hub_unlock_receipts from public, anon, authenticated;
create policy deny_client_access_to_garden_hub_unlock_receipts
  on game_hub_private.garden_hub_unlock_receipts
  for all to authenticated using (false) with check (false);

create or replace function game_hub_private._garden_hub_claim_or_get_receipt_v1()
returns table (eligible boolean, receipt_id uuid, granted_at timestamptz, reason text)
language plpgsql
security definer
set search_path = pg_catalog, public, game_hub_private, auth
as $function$
declare
  v_auth_user_id uuid := auth.uid();
  v_member_claim text := nullif(auth.jwt() -> 'app_metadata' ->> 'member_id', '');
  v_member_id uuid;
  v_existing game_hub_private.garden_hub_unlock_receipts%rowtype;
  v_plot_count bigint;
  v_unlocked_count bigint;
  v_min_slot smallint;
  v_max_slot smallint;
begin
  if v_auth_user_id is null or v_member_claim is null then
    return query select false, null::uuid, null::timestamptz, 'identity_unlinked'::text;
    return;
  end if;
  begin
    v_member_id := v_member_claim::uuid;
  exception when invalid_text_representation then
    return query select false, null::uuid, null::timestamptz, 'identity_unlinked'::text;
    return;
  end;
  if not exists (
    select 1 from public.club_members m
    where m.id = v_member_id and m.auth_user_id = v_auth_user_id
      and m.status::text = 'approved' and m.login_enabled is true
  ) then
    return query select false, null::uuid, null::timestamptz, 'identity_unlinked'::text;
    return;
  end if;
  select e.* into v_existing from game_hub_private.garden_hub_unlock_receipts e
  where e.member_id = v_member_id and e.game_key = 'garden-extended-v1';
  if found then
    return query select true, v_existing.receipt_id, v_existing.granted_at, 'already_granted'::text;
    return;
  end if;
  select count(*), count(*) filter (where p.unlocked is true), min(p.slot_no), max(p.slot_no)
    into v_plot_count, v_unlocked_count, v_min_slot, v_max_slot
  from public.herb_garden_plots p where p.member_id = v_member_id;
  if v_plot_count <> 9 or v_unlocked_count <> 9 or v_min_slot <> 1 or v_max_slot <> 9 then
    return query select false, null::uuid, null::timestamptz, 'prerequisite_incomplete'::text;
    return;
  end if;
  insert into game_hub_private.garden_hub_unlock_receipts(member_id, game_key)
  values (v_member_id, 'garden-extended-v1')
  on conflict (member_id, game_key) do nothing;
  select e.* into v_existing from game_hub_private.garden_hub_unlock_receipts e
  where e.member_id = v_member_id and e.game_key = 'garden-extended-v1';
  return query select true, v_existing.receipt_id, v_existing.granted_at, 'granted'::text;
end;
$function$;
revoke all on function game_hub_private._garden_hub_claim_or_get_receipt_v1() from public, anon;
grant execute on function game_hub_private._garden_hub_claim_or_get_receipt_v1() to authenticated;

create or replace function public.garden_hub_claim_or_get_receipt_v1()
returns table (eligible boolean, receipt_id uuid, granted_at timestamptz, reason text)
language sql
security invoker
set search_path = pg_catalog, public, game_hub_private, auth
as $function$
  select * from game_hub_private._garden_hub_claim_or_get_receipt_v1();
$function$;
revoke all on function public.garden_hub_claim_or_get_receipt_v1() from public, anon;
grant execute on function public.garden_hub_claim_or_get_receipt_v1() to authenticated;
