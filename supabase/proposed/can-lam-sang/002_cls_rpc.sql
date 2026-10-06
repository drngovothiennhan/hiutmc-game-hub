begin;

-- Established HIU TMC pattern from y_quan_private:
-- private tables + public RPC wrappers. New CLS RPCs tighten the function
-- environment to SET search_path = '' and schema-qualify every relation.
--
-- Feature flag semantics:
--   enabled = false => nobody is enabled, including allowlisted users.
--   enabled = true + empty allowlist => every authenticated user is enabled.
--   enabled = true + non-empty allowlist => only listed authenticated users.

create or replace function public.cls_flag_status_v1()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_user uuid := auth.uid();
  v_enabled boolean := false;
begin
  select
    f.enabled
    and (
      pg_catalog.cardinality(f.allowlist_user_ids) = 0
      or (
        v_user is not null
        and v_user = any(f.allowlist_user_ids)
      )
    )
  into v_enabled
  from can_lam_sang_private.feature_flags as f
  where f.flag_key = 'clinical_lab_room_v1';

  return pg_catalog.jsonb_build_object(
    'enabled',
    coalesce(v_enabled, false)
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
  v_user uuid := auth.uid();
  v_enabled boolean := false;
  v_bundle jsonb;
begin
  -- R1: flag is checked before any case bundle is read.
  select
    f.enabled
    and (
      pg_catalog.cardinality(f.allowlist_user_ids) = 0
      or (
        v_user is not null
        and v_user = any(f.allowlist_user_ids)
      )
    )
  into v_enabled
  from can_lam_sang_private.feature_flags as f
  where f.flag_key = 'clinical_lab_room_v1';

  if not coalesce(v_enabled, false) then
    return pg_catalog.jsonb_build_object('code', 'chua_mo');
  end if;

  select c.public_bundle
  into v_bundle
  from can_lam_sang_private.case_bundles as c
  where c.case_id = p_case_id;

  if v_bundle is null then
    return pg_catalog.jsonb_build_object('code', 'khong_tim_thay');
  end if;

  -- A5/R3: enabled path returns the public whitelist object only.
  return v_bundle;
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
  v_enabled boolean := false;
  v_submission_id uuid;
  v_key jsonb;
begin
  -- R1: flag is checked before case/answer data or submission writes.
  select
    f.enabled
    and (
      pg_catalog.cardinality(f.allowlist_user_ids) = 0
      or (
        v_user is not null
        and v_user = any(f.allowlist_user_ids)
      )
    )
  into v_enabled
  from can_lam_sang_private.feature_flags as f
  where f.flag_key = 'clinical_lab_room_v1';

  if not coalesce(v_enabled, false) then
    return pg_catalog.jsonb_build_object('code', 'chua_mo');
  end if;

  if v_user is null then
    return pg_catalog.jsonb_build_object('code', 'khong_xac_thuc');
  end if;

  if p_module is null
     or p_module not in ('core', 'cbc', 'ecg_monitor', 'xray', 'auscultation')
  then
    return pg_catalog.jsonb_build_object('code', 'module_khong_hop_le');
  end if;

  if p_answers is null
     or pg_catalog.jsonb_typeof(p_answers) <> 'object'
  then
    return pg_catalog.jsonb_build_object('code', 'du_lieu_khong_hop_le');
  end if;

  if not exists (
    select 1
    from can_lam_sang_private.case_bundles as c
    where c.case_id = p_case_id
  ) then
    return pg_catalog.jsonb_build_object('code', 'khong_tim_thay');
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
    return pg_catalog.jsonb_build_object('code', 'da_nop');
  end if;

  -- A5: answer material is read only after the successful submission write.
  select a.answer_key
  into v_key
  from can_lam_sang_private.answer_keys as a
  where a.case_id = p_case_id;

  if v_key is null then
    raise exception 'answer_key_missing';
  end if;

  return pg_catalog.jsonb_build_object(
    'title_reveal', v_key -> 'title_reveal',
    'resources_after_submission', v_key -> 'resources_after_submission',
    'after_submission_notes', v_key -> 'after_submission_notes',
    'teaching_explanation', v_key -> 'teaching_explanation'
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
