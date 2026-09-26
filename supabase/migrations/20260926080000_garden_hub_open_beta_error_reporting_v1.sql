-- Open Garden beta to every approved, login-enabled HIU TMC member.
-- Record sanitized Game Hub failures in the shared Admin Center audit feed.
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
    where m.id = v_member_id
      and m.auth_user_id = v_auth_user_id
      and m.status::text = 'approved'
      and m.login_enabled is true
  ) then
    return query select false, null::uuid, null::timestamptz, 'identity_unlinked'::text;
    return;
  end if;

  select e.* into v_existing
  from game_hub_private.garden_hub_unlock_receipts e
  where e.member_id = v_member_id
    and e.game_key = 'garden-extended-v1';

  if found then
    return query select true, v_existing.receipt_id, v_existing.granted_at, 'already_granted'::text;
    return;
  end if;

  insert into game_hub_private.garden_hub_unlock_receipts(member_id, game_key)
  values (v_member_id, 'garden-extended-v1')
  on conflict (member_id, game_key) do nothing;

  select e.* into v_existing
  from game_hub_private.garden_hub_unlock_receipts e
  where e.member_id = v_member_id
    and e.game_key = 'garden-extended-v1';

  return query select true, v_existing.receipt_id, v_existing.granted_at, 'granted'::text;
end;
$function$;

create or replace function public.garden_hub_claim_or_get_receipt_v1()
returns table (eligible boolean, receipt_id uuid, granted_at timestamptz, reason text)
language sql
set search_path = pg_catalog, public, game_hub_private, auth
as $function$
  select * from game_hub_private._garden_hub_claim_or_get_receipt_v1();
$function$;

revoke all on function game_hub_private._garden_hub_claim_or_get_receipt_v1() from public, anon;
grant execute on function game_hub_private._garden_hub_claim_or_get_receipt_v1() to authenticated;

revoke all on function public.garden_hub_claim_or_get_receipt_v1() from public, anon;
grant execute on function public.garden_hub_claim_or_get_receipt_v1() to authenticated;

create index if not exists ecosystem_audit_log_game_hub_errors_member_created_idx
  on public.ecosystem_audit_log(actor_member_id, created_at desc)
  where action = 'game_hub_error';

create or replace function public.garden_hub_report_error_v1(
  p_code text,
  p_message text,
  p_route text default null,
  p_context jsonb default '{}'::jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = pg_catalog, public, auth
as $function$
declare
  v_auth_user_id uuid := auth.uid();
  v_member_claim text := nullif(auth.jwt() -> 'app_metadata' ->> 'member_id', '');
  v_member_id uuid;
  v_member_role text;
  v_code text;
  v_message text;
  v_route text;
  v_context jsonb;
  v_recent_count integer;
begin
  if v_auth_user_id is null or v_member_claim is null then
    return jsonb_build_object('logged', false, 'reason', 'identity_unlinked');
  end if;

  begin
    v_member_id := v_member_claim::uuid;
  exception when invalid_text_representation then
    return jsonb_build_object('logged', false, 'reason', 'identity_unlinked');
  end;

  select m.role::text into v_member_role
  from public.club_members m
  where m.id = v_member_id
    and m.auth_user_id = v_auth_user_id
    and m.status::text = 'approved'
    and m.login_enabled is true;

  if not found then
    return jsonb_build_object('logged', false, 'reason', 'identity_unlinked');
  end if;

  select count(*)::integer into v_recent_count
  from public.ecosystem_audit_log a
  where a.actor_member_id = v_member_id
    and a.action = 'game_hub_error'
    and a.created_at > now() - interval '10 minutes';

  if v_recent_count >= 30 then
    return jsonb_build_object('logged', false, 'reason', 'rate_limited');
  end if;

  v_code := left(regexp_replace(coalesce(p_code, 'application_error'), '[^a-zA-Z0-9_.:-]', '_', 'g'), 64);
  v_message := left(regexp_replace(coalesce(nullif(btrim(p_message), ''), 'Unknown application error'),
    '(?i)bearer[[:space:]]+[A-Za-z0-9._~+/-]+', 'Bearer [REDACTED]', 'g'), 500);
  v_message := regexp_replace(v_message,
    'eyJ[A-Za-z0-9_-]+\.eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+', '[REDACTED_TOKEN]', 'g');
  v_route := left(split_part(split_part(coalesce(p_route, ''), '?', 1), '#', 1), 160);

  if p_context is null or jsonb_typeof(p_context) <> 'object' then
    v_context := '{}'::jsonb;
  else
    v_context := jsonb_strip_nulls(jsonb_build_object(
      'area', left(p_context ->> 'area', 50),
      'operation', left(p_context ->> 'operation', 100),
      'status', left(p_context ->> 'status', 50),
      'errorType', left(p_context ->> 'errorType', 50)
    ));
  end if;

  insert into public.ecosystem_audit_log(actor_member_id, actor_role, action, target_type, target_id, details)
  values (
    v_member_id,
    v_member_role::public.app_role,
    'game_hub_error',
    'game_hub',
    nullif(v_route, ''),
    jsonb_build_object(
      'source', 'hiutmc-game-hub',
      'code', v_code,
      'message', v_message,
      'route', nullif(v_route, ''),
      'context', v_context
    )
  );

  return jsonb_build_object('logged', true);
end;
$function$;

revoke all on function public.garden_hub_report_error_v1(text,text,text,jsonb) from public, anon;
grant execute on function public.garden_hub_report_error_v1(text,text,text,jsonb) to authenticated;
