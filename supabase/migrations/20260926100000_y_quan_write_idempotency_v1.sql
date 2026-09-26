-- One authenticated write gateway for Y Quan. The request key and result are
-- committed in the same transaction as the gameplay RPC, so a retry after a
-- timeout returns the first result instead of awarding twice.
create table if not exists y_quan_private.write_requests (
  member_id uuid not null references public.club_members(id) on delete cascade,
  request_id uuid not null,
  operation text not null,
  request_body jsonb not null,
  response jsonb,
  created_at timestamptz not null default now(),
  primary key (member_id, request_id)
);

alter table y_quan_private.write_requests enable row level security;
revoke all on y_quan_private.write_requests from public, anon, authenticated;
drop policy if exists y_quan_private_no_client_access on y_quan_private.write_requests;
create policy y_quan_private_no_client_access on y_quan_private.write_requests
  for all to public using (false) with check (false);

create or replace function public.y_quan_write_idempotent_v1(
  p_idempotency_key uuid,
  p_operation text,
  p_payload jsonb default '{}'::jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $function$
declare
  mid uuid := private.current_member_id();
  body jsonb := coalesce(p_payload, '{}'::jsonb);
  prior y_quan_private.write_requests%rowtype;
  result jsonb;
begin
  if mid is null or not private.is_approved() then
    raise exception 'Approved member required';
  end if;
  if p_idempotency_key is null then raise exception 'Idempotency key required'; end if;
  if p_operation not in (
    'y_quan_open_clinic_v1', 'y_quan_close_clinic_v1',
    'y_quan_register_patient_v1', 'y_quan_submit_daily_case_v1',
    'y_quan_submit_case_v1', 'y_quan_rate_doctor_v1',
    'y_quan_send_message_v1'
  ) then raise exception 'Unsupported Y Quan write operation'; end if;
  if jsonb_typeof(body) <> 'object' then raise exception 'Write payload must be an object'; end if;

  insert into y_quan_private.write_requests(member_id, request_id, operation, request_body)
  values (mid, p_idempotency_key, p_operation, body)
  on conflict (member_id, request_id) do nothing;

  select * into prior from y_quan_private.write_requests
  where member_id = mid and request_id = p_idempotency_key
  for update;

  if prior.operation <> p_operation or prior.request_body <> body then
    raise exception 'Idempotency key was reused with a different request';
  end if;
  if prior.response is not null then return prior.response; end if;

  case p_operation
    when 'y_quan_open_clinic_v1' then
      result := public.y_quan_open_clinic_v1(body->>'p_doctor_avatar_id');
    when 'y_quan_close_clinic_v1' then
      result := public.y_quan_close_clinic_v1();
    when 'y_quan_register_patient_v1' then
      result := public.y_quan_register_patient_v1((body->>'p_doctor_id')::uuid);
    when 'y_quan_submit_daily_case_v1' then
      result := public.y_quan_submit_daily_case_v1(
        (body->>'p_slot_no')::smallint,
        array(select jsonb_array_elements_text(coalesce(body->'p_answered_domains', '[]'::jsonb))),
        body->>'p_diagnosis', body->>'p_reasoning'
      );
    when 'y_quan_submit_case_v1' then
      result := public.y_quan_submit_case_v1(
        (body->>'p_visit_id')::uuid,
        array(select jsonb_array_elements_text(coalesce(body->'p_answered_domains', '[]'::jsonb))),
        body->>'p_diagnosis', body->>'p_reasoning'
      );
    when 'y_quan_rate_doctor_v1' then
      result := public.y_quan_rate_doctor_v1((body->>'p_visit_id')::uuid, (body->>'p_stars')::smallint);
    when 'y_quan_send_message_v1' then
      result := public.y_quan_send_message_v1((body->>'p_visit_id')::uuid, body->>'p_body');
  end case;

  update y_quan_private.write_requests
  set response = result
  where member_id = mid and request_id = p_idempotency_key;
  return result;
end
$function$;

revoke all on function public.y_quan_write_idempotent_v1(uuid, text, jsonb) from public, anon;
grant execute on function public.y_quan_write_idempotent_v1(uuid, text, jsonb) to authenticated;

-- Require all client-side writes to pass through the key-checking gateway.
revoke all on function public.y_quan_open_clinic_v1(text) from public, anon, authenticated;
revoke all on function public.y_quan_close_clinic_v1() from public, anon, authenticated;
revoke all on function public.y_quan_register_patient_v1(uuid) from public, anon, authenticated;
revoke all on function public.y_quan_submit_daily_case_v1(smallint, text[], text, text) from public, anon, authenticated;
revoke all on function public.y_quan_submit_case_v1(uuid, text[], text, text) from public, anon, authenticated;
revoke all on function public.y_quan_rate_doctor_v1(uuid, smallint) from public, anon, authenticated;
revoke all on function public.y_quan_send_message_v1(uuid, text) from public, anon, authenticated;
