begin;

create or replace function can_lam_sang_private.cls_validate_core_submission_v1(p_case_id text,p_answers jsonb)
returns boolean language plpgsql security definer set search_path = '' as $function$
declare v_key jsonb; v_name text;
begin
 select answer_key into v_key from can_lam_sang_private.core_case_bundles where case_id=p_case_id and review_status in('CHUA_DUYET','DA_DUYET');
 if v_key is null or p_answers is null or pg_catalog.jsonb_typeof(p_answers)<>'object' then return false; end if;
 for v_name in select pg_catalog.jsonb_object_keys(p_answers) loop
   if not(v_key ? v_name) then return false; end if;
 end loop;
 return true;
end $function$;

create or replace function public.cls_submit_v1(p_case_id text,p_answers jsonb)
returns jsonb language plpgsql security definer set search_path = '' as $function$
declare v_status text;
begin
 select review_status into v_status from can_lam_sang_private.core_case_bundles where case_id=p_case_id;
 if not can_lam_sang_private.cls_validate_core_submission_v1(p_case_id,p_answers) then return pg_catalog.jsonb_build_object('ok',false,'code','answers_khong_hop_le','data',null); end if;
 return pg_catalog.jsonb_build_object('ok',true,'code',null,'data',can_lam_sang_private.cls_review_fields_v1(v_status));
end $function$;
revoke all on function public.cls_submit_v1(text,jsonb) from public,anon,authenticated;
grant execute on function public.cls_submit_v1(text,jsonb) to authenticated;
commit;
