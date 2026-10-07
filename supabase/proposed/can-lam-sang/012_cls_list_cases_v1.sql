begin;

create or replace function public.cls_list_cases_v1()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_user uuid := auth.uid();
  v_cases jsonb;
begin
  if v_user is null then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'khong_xac_thuc', 'data', null);
  end if;

  if not can_lam_sang_private.cls_user_enabled_v1(v_user) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'chua_mo', 'data', null);
  end if;

  select coalesce(
    pg_catalog.jsonb_agg(
      pg_catalog.jsonb_build_object(
        'case_id', c.case_id,
        'title', c.public_bundle ->> 'title',
        'track', c.public_bundle ->> 'track',
        'specialty', c.public_bundle ->> 'specialty',
        'review_status', rf ->> 'review_status',
        'review_label', rf ->> 'review_label',
        'submitted',
          exists (
            select 1
            from can_lam_sang_private.submissions s
            where s.user_id = v_user
              and s.case_id = c.case_id
              and s.module = 'core'
          )
      )
      order by c.case_id
    ),
    '[]'::jsonb
  )
  into v_cases
  from can_lam_sang_private.case_bundles c
  cross join lateral can_lam_sang_private.cls_review_fields_v1(c.review_status) rf
  where can_lam_sang_private.cls_content_visible_v1(c.review_status);

  return pg_catalog.jsonb_build_object(
    'ok', true,
    'code', null,
    'data', pg_catalog.jsonb_build_object('cases', v_cases)
  );
end
$function$;

revoke all on function public.cls_list_cases_v1()
  from public, anon, authenticated;

grant execute on function public.cls_list_cases_v1()
  to authenticated;

commit;
