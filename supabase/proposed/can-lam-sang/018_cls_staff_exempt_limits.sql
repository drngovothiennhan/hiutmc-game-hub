begin;

-- Nhân viên (admin, mod, super_mod) không bị giới hạn số lượt đang mở và số lượt mỗi ngày.
-- Giới hạn chỉ áp dụng cho người chơi. Chưa áp production; cần duyệt trước khi chạy.
-- Thứ tự áp: chạy file này trước 006 và 017.
create or replace function can_lam_sang_private.cls_is_staff_v1(p_user_id uuid)
returns boolean
language sql
stable
set search_path = ''
as $function$
  select p_user_id is not null
    and p_user_id = auth.uid()
    and exists (
      select 1
      from public.garden_hub_current_member_role_v1() as g
      where g.role in ('admin', 'mod', 'super_mod')
    )
$function$;

revoke all on function can_lam_sang_private.cls_is_staff_v1(uuid)
  from public, anon, authenticated;

commit;
