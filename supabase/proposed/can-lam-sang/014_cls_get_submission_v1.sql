begin;

create or replace function public.cls_get_submission_v1(p_case_id text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_user uuid := auth.uid();
  v_status text;
  v_key jsonb;
begin
  if v_user is null then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'khong_xac_thuc', 'data', null);
  end if;

  if not can_lam_sang_private.cls_user_enabled_v1(v_user) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'chua_mo', 'data', null);
  end if;

  select c.review_status
  into v_status
  from can_lam_sang_private.case_bundles as c
  where c.case_id = p_case_id
    and can_lam_sang_private.cls_content_visible_v1(c.review_status)
    and exists (
      select 1
      from can_lam_sang_private.submissions as s
      where s.user_id = v_user
        and s.case_id = c.case_id
        and s.module = 'core'
    );

  if v_status is null then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'khong_tim_thay', 'data', null);
  end if;

  select a.answer_key
  into v_key
  from can_lam_sang_private.answer_keys as a
  where a.case_id = p_case_id;

  if v_key is null then
    raise exception 'answer_key_missing';
  end if;

  return pg_catalog.jsonb_build_object(
    'ok', true,
    'code', 'da_nop',
    'data',
      pg_catalog.jsonb_build_object(
        'title_reveal', v_key -> 'title_reveal',
        'resources_after_submission', v_key -> 'resources_after_submission',
        'after_submission_notes', v_key -> 'after_submission_notes',
        'teaching_explanation', v_key -> 'teaching_explanation'
      )
      || can_lam_sang_private.cls_review_fields_v1(v_status)
  );
end
$function$;

revoke all on function public.cls_get_submission_v1(text)
  from public, anon, authenticated;
grant execute on function public.cls_get_submission_v1(text)
  to authenticated;

commit;
