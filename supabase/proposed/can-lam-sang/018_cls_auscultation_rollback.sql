begin;
do $block$
begin
  if exists (select 1 from can_lam_sang_private.aus_attempts limit 1)
     and coalesce(current_setting('cls.allow_data_loss', true), 'off') <> 'on' then
    raise exception 'aus_rollback_blocked_data_present';
  end if;
end
$block$;
drop function if exists public.cls_aus_submit_v1(uuid, jsonb);
drop function if exists public.cls_aus_get_v1(uuid);
drop function if exists public.cls_aus_start_v1(text);
drop function if exists can_lam_sang_private.aus_view_v1(can_lam_sang_private.aus_attempts);
drop table if exists can_lam_sang_private.aus_attempts;
drop table if exists can_lam_sang_private.aus_clips;
commit;
