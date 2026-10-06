-- DESTRUCTIVE ROLLBACK.
-- If submissions exist, export them first. To intentionally allow data loss,
-- execute: select set_config('cls.allow_data_loss', 'on', false);
-- in the same database session before running this file.

begin;

do $guard$
declare
  v_has_submissions boolean := false;
begin
  if pg_catalog.to_regclass('can_lam_sang_private.submissions') is not null then
    execute
      'select exists (select 1 from can_lam_sang_private.submissions)'
      into v_has_submissions;
  end if;

  if v_has_submissions
     and pg_catalog.current_setting('cls.allow_data_loss', true) is distinct from 'on'
  then
    raise exception
      'CLS rollback blocked: submissions exist. Export can_lam_sang_private.submissions, then set cls.allow_data_loss=on in this session before retrying.';
  end if;
end
$guard$;

drop function if exists public.cls_submit_v1(text, text, jsonb);
drop function if exists public.cls_get_case_v1(text);
drop function if exists public.cls_flag_status_v1();

drop schema if exists can_lam_sang_private cascade;

commit;
