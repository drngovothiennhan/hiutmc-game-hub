begin;

-- Public RPC wrappers are dropped explicitly because the established
-- y_quan_private pattern places callable RPCs in public while all data
-- remains in the private schema.
drop function if exists public.cls_submit_v1(text, text, jsonb);
drop function if exists public.cls_get_case_v1(text);
drop function if exists public.cls_flag_status_v1();

drop schema if exists can_lam_sang_private cascade;

commit;
