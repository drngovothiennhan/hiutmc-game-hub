begin;
drop function if exists public.cls_get_case_v1(text);
drop function if exists public.cls_cbc_get_v1(uuid);
drop function if exists public.cls_cbc_start_v1(text);
drop function if exists can_lam_sang_private.cls_review_fields_v1(text);
drop function if exists can_lam_sang_private.cls_content_visible_v1(text);
drop table if exists can_lam_sang_private.cls_publish_config;
commit;
