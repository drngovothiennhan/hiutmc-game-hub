begin;

-- Internal feature gate. No client role receives EXECUTE.
create or replace function can_lam_sang_private.cls_user_enabled_v1(p_user_id uuid)
returns boolean
language sql
stable
set search_path = ''
as $function$
  select coalesce((
    select
      f.enabled
      and case f.audience
        when 'allowlist' then (
          p_user_id is not null
          and p_user_id = any(f.allowlist_user_ids)
        )
        when 'all_authenticated' then p_user_id is not null
        else false
      end
    from can_lam_sang_private.feature_flags as f
    where f.flag_key = 'clinical_lab_room_v1'
  ), false)
$function$;

revoke all on function can_lam_sang_private.cls_user_enabled_v1(uuid)
  from public, anon, authenticated;

create or replace function public.cls_flag_status_v1()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_enabled boolean;
begin
  v_enabled := can_lam_sang_private.cls_user_enabled_v1(auth.uid());

  return pg_catalog.jsonb_build_object(
    'ok', true,
    'code', null,
    'data', pg_catalog.jsonb_build_object('enabled', v_enabled)
  );
end
$function$;

create or replace function public.cls_get_case_v1(p_case_id text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_bundle jsonb;
begin
  if not can_lam_sang_private.cls_user_enabled_v1(auth.uid()) then
    return pg_catalog.jsonb_build_object(
      'ok', false,
      'code', 'chua_mo',
      'data', null
    );
  end if;

  select c.public_bundle
  into v_bundle
  from can_lam_sang_private.case_bundles as c
  where c.case_id = p_case_id;

  if v_bundle is null then
    return pg_catalog.jsonb_build_object(
      'ok', false,
      'code', 'khong_tim_thay',
      'data', null
    );
  end if;

  return pg_catalog.jsonb_build_object(
    'ok', true,
    'code', null,
    'data', v_bundle
  );
end
$function$;

create or replace function public.cls_submit_v1(
  p_case_id text,
  p_module text,
  p_answers jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_user uuid := auth.uid();
  v_submission_id uuid;
  v_key jsonb;
  v_reveal jsonb;
  v_code text := null;
begin
  if not can_lam_sang_private.cls_user_enabled_v1(v_user) then
    return pg_catalog.jsonb_build_object(
      'ok', false,
      'code', 'chua_mo',
      'data', null
    );
  end if;

  if v_user is null then
    return pg_catalog.jsonb_build_object(
      'ok', false,
      'code', 'khong_xac_thuc',
      'data', null
    );
  end if;

  if p_module is null
     or p_module not in ('core', 'cbc', 'ecg_monitor', 'xray', 'auscultation')
  then
    return pg_catalog.jsonb_build_object(
      'ok', false,
      'code', 'module_khong_hop_le',
      'data', null
    );
  end if;

  if p_module <> 'core' then
    return pg_catalog.jsonb_build_object(
      'ok', false,
      'code', 'module_chua_ho_tro',
      'data', null
    );
  end if;

  if p_answers is null
     or pg_catalog.jsonb_typeof(p_answers) <> 'object'
     or p_answers = '{}'::jsonb
     or pg_catalog.octet_length(p_answers::text) > 65536
  then
    return pg_catalog.jsonb_build_object(
      'ok', false,
      'code', 'du_lieu_khong_hop_le',
      'data', null
    );
  end if;

  if not exists (
    select 1
    from can_lam_sang_private.case_bundles as c
    where c.case_id = p_case_id
  ) then
    return pg_catalog.jsonb_build_object(
      'ok', false,
      'code', 'khong_tim_thay',
      'data', null
    );
  end if;

  insert into can_lam_sang_private.submissions (
    user_id,
    case_id,
    module,
    answers
  )
  values (
    v_user,
    p_case_id,
    p_module,
    p_answers
  )
  on conflict (user_id, case_id, module) do nothing
  returning id into v_submission_id;

  if v_submission_id is null then
    v_code := 'da_nop';
  end if;

  select a.answer_key
  into v_key
  from can_lam_sang_private.answer_keys as a
  where a.case_id = p_case_id;

  if v_key is null then
    raise exception 'answer_key_missing';
  end if;

  v_reveal := pg_catalog.jsonb_build_object(
    'title_reveal', v_key -> 'title_reveal',
    'resources_after_submission', v_key -> 'resources_after_submission',
    'after_submission_notes', v_key -> 'after_submission_notes',
    'teaching_explanation', v_key -> 'teaching_explanation'
  );

  return pg_catalog.jsonb_build_object(
    'ok', true,
    'code', v_code,
    'data', v_reveal
  );
end
$function$;

revoke all on function public.cls_flag_status_v1()
  from public, anon, authenticated;
revoke all on function public.cls_get_case_v1(text)
  from public, anon, authenticated;
revoke all on function public.cls_submit_v1(text, text, jsonb)
  from public, anon, authenticated;

grant execute on function public.cls_flag_status_v1()
  to authenticated;
grant execute on function public.cls_get_case_v1(text)
  to authenticated;
grant execute on function public.cls_submit_v1(text, text, jsonb)
  to authenticated;

commit;
