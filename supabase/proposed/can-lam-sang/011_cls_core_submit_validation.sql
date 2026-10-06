begin;


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
  v_review_status text;
  v_review jsonb;
  v_code text := null;
  v_allowed_keys integer := 0;
  v_key_name text;
  v_value jsonb;
  v_diagnosis_options jsonb;
  v_action_options jsonb;
  v_max_selected integer := 32;
begin
  if v_user is null then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'khong_xac_thuc', 'data', null);
  end if;

  if not can_lam_sang_private.cls_user_enabled_v1(v_user) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'chua_mo', 'data', null);
  end if;

  if p_module is null
     or p_module not in ('core', 'cbc', 'ecg_monitor', 'xray', 'auscultation')
  then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'module_khong_hop_le', 'data', null);
  end if;

  if p_module <> 'core' then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'module_chua_ho_tro', 'data', null);
  end if;

  if p_answers is null
     or pg_catalog.jsonb_typeof(p_answers) <> 'object'
     or p_answers = '{}'::jsonb
     or pg_catalog.octet_length(p_answers::text) > 65536
  then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
  end if;

  select c.review_status
  into v_review_status
  from can_lam_sang_private.case_bundles as c
  where c.case_id = p_case_id
    and can_lam_sang_private.cls_content_visible_v1(c.review_status);

  if v_review_status is null then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'khong_tim_thay', 'data', null);
  end if;

  select a.answer_key
  into v_key
  from can_lam_sang_private.answer_keys as a
  where a.case_id = p_case_id;

  if v_key is null then
    raise exception 'answer_key_missing';
  end if;

  v_diagnosis_options := v_key -> 'diagnosis_options';
  v_action_options := v_key -> 'action_options';

  if pg_catalog.jsonb_typeof(v_diagnosis_options) <> 'object'
     or pg_catalog.jsonb_typeof(v_action_options) <> 'array'
     or pg_catalog.jsonb_array_length(v_action_options) > v_max_selected
  then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
  end if;

  if exists (
    select 1
    from pg_catalog.jsonb_each(v_diagnosis_options) as group_item(group_name, options)
    where pg_catalog.jsonb_typeof(group_item.options) <> 'array'
       or pg_catalog.jsonb_array_length(group_item.options) > v_max_selected
       or exists (
         select 1
         from pg_catalog.jsonb_array_elements(group_item.options) as opt
         where pg_catalog.jsonb_typeof(opt) <> 'object'
            or pg_catalog.jsonb_typeof(opt -> 'text') <> 'string'
       )
  ) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
  end if;

  if exists (
    select 1
    from pg_catalog.jsonb_array_elements(v_action_options) as opt
    where pg_catalog.jsonb_typeof(opt) <> 'object'
       or pg_catalog.jsonb_typeof(opt -> 'text') <> 'string'
  ) then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
  end if;

  /*
   * The answer-key schema defines the per-case choice domains:
   * diagnosis_options.<group> and action_options[].text.
   * Submission keys are the case's diagnosis groups plus "actions".
   * Every required key must be present; every submitted value must be
   * one of that case's own choices. No generic object is accepted.
   */
  select count(*)
  into v_allowed_keys
  from pg_catalog.jsonb_object_keys(v_diagnosis_options);

  if not (p_answers ? 'actions') then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
  end if;

  if (
    select count(*)
    from pg_catalog.jsonb_object_keys(p_answers)
  ) <> v_allowed_keys + 1 then
    return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
  end if;

  for v_key_name in
    select pg_catalog.jsonb_object_keys(p_answers)
  loop
    if v_key_name <> 'actions'
       and not ((v_key -> 'diagnosis_options') ? v_key_name)
    then
      return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
    end if;

    if v_key_name = 'actions' then
      if pg_catalog.jsonb_typeof(p_answers -> v_key_name) <> 'array'
         or pg_catalog.jsonb_array_length(p_answers -> v_key_name) = 0
      then
        return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
      end if;

      if exists (
        select 1
        from pg_catalog.jsonb_array_elements_text(p_answers -> v_key_name) as a(text_value)
        where not exists (
          select 1
          from pg_catalog.jsonb_array_elements(v_action_options) as opt
          where opt ->> 'text' = a.text_value
        )
      ) then
        return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
      end if;
    else
      v_value := p_answers -> v_key_name;

      if pg_catalog.jsonb_typeof(v_value) = 'string' then
        if not exists (
          select 1
          from pg_catalog.jsonb_array_elements(v_diagnosis_options -> v_key_name) as opt
          where opt ->> 'text' = v_value #>> '{}'
        ) then
          return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
        end if;
      elsif pg_catalog.jsonb_typeof(v_value) = 'array'
         and pg_catalog.jsonb_array_length(v_value) > 0
         and pg_catalog.jsonb_array_length(v_value) <= v_max_selected
      then
        if exists (
          select 1
          from pg_catalog.jsonb_array_elements_text(v_value) as selected(text_value)
          where not exists (
            select 1
            from pg_catalog.jsonb_array_elements(coalesce(v_key -> 'diagnosis_options' -> v_key_name, '[]'::jsonb)) as opt
            where opt ->> 'text' = selected.text_value
          )
        ) then
          return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
        end if;
      else
        return pg_catalog.jsonb_build_object('ok', false, 'code', 'answers_khong_hop_le', 'data', null);
      end if;
    end if;
  end loop;

  insert into can_lam_sang_private.submissions (
    user_id, case_id, module, answers
  )
  values (
    v_user, p_case_id, p_module, p_answers
  )
  on conflict (user_id, case_id, module) do nothing
  returning id into v_submission_id;

  if v_submission_id is null then
    v_code := 'da_nop';
  end if;

  v_reveal := pg_catalog.jsonb_build_object(
    'title_reveal', v_key -> 'title_reveal',
    'resources_after_submission', v_key -> 'resources_after_submission',
    'after_submission_notes', v_key -> 'after_submission_notes',
    'teaching_explanation', v_key -> 'teaching_explanation'
  );

  v_review := can_lam_sang_private.cls_review_fields_v1(v_review_status);

  return pg_catalog.jsonb_build_object(
    'ok', true,
    'code', v_code,
    'data',
      (v_reveal - 'review_status' - 'review_label')
      || v_review
  );
end
$function$;

revoke all on function public.cls_submit_v1(text, text, jsonb)
  from public, anon, authenticated;
grant execute on function public.cls_submit_v1(text, text, jsonb)
  to authenticated;

commit;
