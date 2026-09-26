-- Private, per-visit chat between the assigned doctor and patient.
-- Clients use authenticated RPCs; message rows are never directly exposed.
create table if not exists y_quan_private.visit_messages (
  id uuid primary key default gen_random_uuid(),
  visit_id uuid not null references y_quan_private.visits(id) on delete cascade,
  sender_id uuid not null references public.club_members(id) on delete cascade,
  body text not null check (char_length(body) between 1 and 1000 and body = btrim(body)),
  created_at timestamptz not null default now()
);

create index if not exists y_quan_visit_messages_recent_idx
  on y_quan_private.visit_messages(visit_id, created_at desc, id desc);

alter table y_quan_private.visit_messages enable row level security;
revoke all on y_quan_private.visit_messages from public, anon, authenticated;
drop policy if exists y_quan_private_no_client_access on y_quan_private.visit_messages;
create policy y_quan_private_no_client_access on y_quan_private.visit_messages
  for all to public using (false) with check (false);

create or replace function public.y_quan_visit_messages_v1(p_visit_id uuid)
returns table(message_id uuid, sender_id uuid, sender_name text, body text, created_at timestamptz, is_mine boolean)
language plpgsql
stable
security definer
set search_path = ''
as $function$
declare
  mid uuid := private.current_member_id();
begin
  if mid is null or not private.is_approved() then
    raise exception 'Approved member required';
  end if;
  if not exists (
    select 1 from y_quan_private.visits v
    where v.id = p_visit_id and (v.doctor_id = mid or v.patient_id = mid)
  ) then
    raise exception 'Visit not found or access denied';
  end if;

  return query
  select recent.id, recent.sender_id, recent.full_name, recent.body, recent.created_at,
         recent.sender_id = mid
  from (
    select m.id, m.sender_id, cm.full_name, m.body, m.created_at
    from y_quan_private.visit_messages m
    join public.club_members cm on cm.id = m.sender_id
    where m.visit_id = p_visit_id
    order by m.created_at desc, m.id desc
    limit 100
  ) recent
  order by recent.created_at, recent.id;
end
$function$;

create or replace function public.y_quan_send_message_v1(p_visit_id uuid, p_body text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $function$
declare
  mid uuid := private.current_member_id();
  clean_body text := btrim(coalesce(p_body, ''));
  new_id uuid;
  sent_at timestamptz;
begin
  if mid is null or not private.is_approved() then
    raise exception 'Approved member required';
  end if;
  if char_length(clean_body) not between 1 and 1000 then
    raise exception 'Message must contain 1 to 1000 characters';
  end if;
  if not exists (
    select 1 from y_quan_private.visits v
    where v.id = p_visit_id and (v.doctor_id = mid or v.patient_id = mid)
  ) then
    raise exception 'Visit not found or access denied';
  end if;

  insert into y_quan_private.visit_messages(visit_id, sender_id, body)
  values (p_visit_id, mid, clean_body)
  returning id, created_at into new_id, sent_at;
  return jsonb_build_object('message_id', new_id, 'created_at', sent_at);
end
$function$;

revoke all on function public.y_quan_visit_messages_v1(uuid) from public, anon;
revoke all on function public.y_quan_send_message_v1(uuid, text) from public, anon;
grant execute on function public.y_quan_visit_messages_v1(uuid) to authenticated;
grant execute on function public.y_quan_send_message_v1(uuid, text) to authenticated;
