-- Resolve the caller's live HIU TMC role without exposing club_members reads.
-- The private definer checks auth.uid() and trusted app_metadata before returning only that member's role.
create or replace function game_hub_private._garden_hub_current_member_role_v1()
returns table(role text)
language plpgsql
stable
security definer
set search_path = pg_catalog, public, game_hub_private, auth
as $function$
declare
  v_auth_user_id uuid := auth.uid();
  v_member_claim text := nullif(auth.jwt() -> 'app_metadata' ->> 'member_id', '');
  v_member_id uuid;
  v_member_role text;
begin
  if v_auth_user_id is null or v_member_claim is null then
    return;
  end if;

  begin
    v_member_id := v_member_claim::uuid;
  exception when invalid_text_representation then
    return;
  end;

  select m.role::text into v_member_role
  from public.club_members m
  where m.id = v_member_id
    and m.auth_user_id = v_auth_user_id
    and m.status::text = 'approved'
    and m.login_enabled is true;

  if not found then
    return;
  end if;

  return query select v_member_role;
end;
$function$;

revoke all on function game_hub_private._garden_hub_current_member_role_v1() from public, anon;
grant usage on schema game_hub_private to authenticated;
grant execute on function game_hub_private._garden_hub_current_member_role_v1() to authenticated;

create or replace function public.garden_hub_current_member_role_v1()
returns table(role text)
language sql
stable
security invoker
set search_path = pg_catalog, public, game_hub_private, auth
as $function$
  select * from game_hub_private._garden_hub_current_member_role_v1();
$function$;

revoke all on function public.garden_hub_current_member_role_v1() from public, anon;
grant execute on function public.garden_hub_current_member_role_v1() to authenticated;
