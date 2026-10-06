begin;

do $block$
begin
  if exists (
    select 1
    from can_lam_sang_private.cbc_attempts
    limit 1
  ) and coalesce(current_setting('cls.allow_data_loss', true), 'off') <> 'on' then
    raise exception 'cbc_rollback_blocked_data_present';
  end if;
end
$block$;

drop function if exists public.cls_cbc_submit_v1(uuid, jsonb);
drop function if exists public.cls_cbc_get_v1(uuid);
drop function if exists public.cls_cbc_start_v1(text);

drop table if exists can_lam_sang_private.cbc_attempts;
drop table if exists can_lam_sang_private.cbc_scenarios;
drop table if exists can_lam_sang_private.cbc_case_mappings;
drop table if exists can_lam_sang_private.cbc_patterns;

commit;
