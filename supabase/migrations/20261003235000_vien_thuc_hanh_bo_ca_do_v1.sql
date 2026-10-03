-- Viện Thực Hành: thoát giữa ca thì bỏ ca dở để lần vào sau nhận ca mới (trước đây quay lại đúng ca cũ trong 3 giờ).
-- Chỉ thêm hàm mới. Ca bỏ không được tính EXP.
create or replace function public.tu_chan_abandon_v1()
returns jsonb
language plpgsql
security definer
set search_path to 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
as $function$
declare
  mid uuid := private.current_member_id();
  n integer;
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  update y_quan_private.tu_chan_shifts set status = 'abandoned', finished_at = now()
   where member_id = mid and status = 'open';
  get diagnostics n = row_count;
  return jsonb_build_object('abandoned', n);
end $function$;

revoke all on function public.tu_chan_abandon_v1() from public, anon;
grant execute on function public.tu_chan_abandon_v1() to authenticated, service_role;
