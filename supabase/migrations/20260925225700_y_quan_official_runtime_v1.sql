-- HIU Y Quán multiplayer runtime. All client access goes through authenticated RPCs;
-- tables and the credit ledger remain isolated from Gia Viên Dược Thảo.
create schema if not exists y_quan_private;

create table if not exists y_quan_private.clinics (
 member_id uuid primary key references public.club_members(id) on delete cascade,
 doctor_avatar_id text not null check (doctor_avatar_id in ('male','female')),
 is_open boolean not null default false,
 last_seen_at timestamptz not null default now(),
 experience bigint not null default 0 check (experience >= 0),
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists y_quan_private.daily_slots (
 doctor_id uuid not null references public.club_members(id) on delete cascade,
 local_day date not null,
 slot_no smallint not null check (slot_no between 1 and 5),
 starts_at timestamptz not null,
 slot_id uuid not null unique default gen_random_uuid(),
 completed_at timestamptz,
 bot_score smallint not null default 0 check (bot_score between 0 and 100),
 experience_awarded integer not null default 0 check (experience_awarded >= 0),
 primary key (doctor_id,local_day,slot_no),
 unique (doctor_id,local_day,starts_at)
);
create table if not exists y_quan_private.visits (
 id uuid primary key default gen_random_uuid(),
 doctor_id uuid not null references public.club_members(id),
 patient_id uuid not null references public.club_members(id),
 local_day date not null,
 slot_no smallint not null,
 status text not null default 'registered' check (status in ('registered','completed')),
 answered_domains text[] not null default '{}',
 diagnosis text not null default '',
 reasoning text not null default '',
 bot_score smallint not null default 0 check (bot_score between 0 and 100),
 experience_awarded integer not null default 0,
 created_at timestamptz not null default now(),
 completed_at timestamptz,
 check (doctor_id <> patient_id),
 unique (doctor_id,local_day,slot_no),
 foreign key (doctor_id,local_day,slot_no) references y_quan_private.daily_slots(doctor_id,local_day,slot_no)
);
create table if not exists y_quan_private.ratings (
 visit_id uuid primary key references y_quan_private.visits(id),
 patient_id uuid not null references public.club_members(id),
 doctor_id uuid not null references public.club_members(id),
 stars smallint not null check (stars between 1 and 5),
 created_at timestamptz not null default now(),
 check (patient_id <> doctor_id)
);
create table if not exists y_quan_private.credit_ledger (
 id bigint generated always as identity primary key,
 member_id uuid not null references public.club_members(id),
 source_kind text not null check (source_kind in ('case','patient_rating','herb_purchase','credit_exchange')),
 source_id uuid not null,
 delta integer not null,
 metadata jsonb not null default '{}'::jsonb,
 created_at timestamptz not null default now(),
 unique (member_id,source_kind,source_id),
 check (((source_kind in ('case','patient_rating')) and delta >= 0) or source_kind in ('herb_purchase','credit_exchange'))
);
create index if not exists y_quan_visits_patient_recent_idx on y_quan_private.visits(patient_id,created_at desc);
create index if not exists y_quan_visits_doctor_recent_idx on y_quan_private.visits(doctor_id,created_at desc);
create index if not exists y_quan_ratings_patient_idx on y_quan_private.ratings(patient_id);
create index if not exists y_quan_ratings_doctor_recent_idx on y_quan_private.ratings(doctor_id,created_at desc);
alter table y_quan_private.clinics enable row level security;
alter table y_quan_private.daily_slots enable row level security;
alter table y_quan_private.visits enable row level security;
alter table y_quan_private.ratings enable row level security;
alter table y_quan_private.credit_ledger enable row level security;
revoke all on schema y_quan_private from public,anon,authenticated;
revoke all on all tables in schema y_quan_private from public,anon,authenticated;
drop policy if exists y_quan_private_no_client_access on y_quan_private.clinics;
create policy y_quan_private_no_client_access on y_quan_private.clinics for all to public using(false) with check(false);
drop policy if exists y_quan_private_no_client_access on y_quan_private.daily_slots;
create policy y_quan_private_no_client_access on y_quan_private.daily_slots for all to public using(false) with check(false);
drop policy if exists y_quan_private_no_client_access on y_quan_private.visits;
create policy y_quan_private_no_client_access on y_quan_private.visits for all to public using(false) with check(false);
drop policy if exists y_quan_private_no_client_access on y_quan_private.ratings;
create policy y_quan_private_no_client_access on y_quan_private.ratings for all to public using(false) with check(false);
drop policy if exists y_quan_private_no_client_access on y_quan_private.credit_ledger;
create policy y_quan_private_no_client_access on y_quan_private.credit_ledger for all to public using(false) with check(false);

CREATE OR REPLACE FUNCTION public.y_quan_clinics_v1()
 RETURNS TABLE(doctor_id uuid, display_name text, profile_avatar_url text, doctor_avatar_id text, is_open boolean, total_credits bigint, average_stars numeric)
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
AS $function$
declare mid uuid:=private.current_member_id();
begin
 if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
 return query
 select c.member_id,m.full_name,m.avatar_url,c.doctor_avatar_id,
        c.is_open and c.last_seen_at>now()-interval '3 minutes',
        coalesce((select sum(l.delta) from y_quan_private.credit_ledger l where l.member_id=c.member_id),0)::bigint,
        (select round(avg(r.stars)::numeric,2) from y_quan_private.ratings r where r.doctor_id=c.member_id)
 from y_quan_private.clinics c join public.club_members m on m.id=c.member_id
 where m.status::text='approved' and c.member_id<>mid
 order by c.is_open desc,c.last_seen_at desc;
end $function$;

CREATE OR REPLACE FUNCTION public.y_quan_close_clinic_v1()
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
AS $function$
declare mid uuid:=private.current_member_id();
begin
 if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
 update y_quan_private.clinics set is_open=false,last_seen_at=now(),updated_at=now() where member_id=mid;
 return jsonb_build_object('ok',true);
end $function$;

CREATE OR REPLACE FUNCTION public.y_quan_dashboard_v1()
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
AS $function$
declare mid uuid:=private.current_member_id(); d date:=(now() at time zone 'Asia/Ho_Chi_Minh')::date;
begin
 if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
 return jsonb_build_object(
  'doctor',(select to_jsonb(c) from y_quan_private.clinics c where c.member_id=mid),
  'local_day',d,
  'experience',coalesce((select experience from y_quan_private.clinics where member_id=mid),0),
  'credits',coalesce((select sum(delta) from y_quan_private.credit_ledger where member_id=mid),0),
  'slots',coalesce((select jsonb_agg(jsonb_build_object('slot_no',s.slot_no,'starts_at',s.starts_at,'visit_id',v.id,'status',coalesce(v.status,case when s.completed_at is not null then 'completed' else 'scheduled' end),'bot_score',greatest(s.bot_score,coalesce(v.bot_score,0)),'experience',s.experience_awarded+coalesce(v.experience_awarded,0),'stars',r.stars) order by s.starts_at) from y_quan_private.daily_slots s left join y_quan_private.visits v using(doctor_id,local_day,slot_no) left join y_quan_private.ratings r on r.visit_id=v.id where s.doctor_id=mid and s.local_day=d),'[]'::jsonb),
  'average_stars',(select round(avg(stars)::numeric,2) from y_quan_private.ratings where doctor_id=mid)
 );
end $function$;

CREATE OR REPLACE FUNCTION public.y_quan_doctor_visits_v1()
 RETURNS TABLE(visit_id uuid, patient_id uuid, patient_name text, patient_avatar_url text, local_day date, slot_no smallint, status text, bot_score smallint, stars smallint, created_at timestamp with time zone)
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
AS $function$
declare mid uuid:=private.current_member_id();
begin
 if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
 return query select v.id,v.patient_id,m.full_name,m.avatar_url,v.local_day,v.slot_no,v.status,v.bot_score,r.stars,v.created_at
 from y_quan_private.visits v join public.club_members m on m.id=v.patient_id
 left join y_quan_private.ratings r on r.visit_id=v.id
 where v.doctor_id=mid order by v.created_at desc limit 50;
end $function$;

CREATE OR REPLACE FUNCTION public.y_quan_leaderboard_v1(p_limit integer DEFAULT 50)
 RETURNS TABLE(rank_no bigint, doctor_id uuid, display_name text, doctor_avatar_id text, credits bigint, experience bigint, average_stars numeric, rating_count bigint)
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
AS $function$
declare mid uuid:=private.current_member_id();
begin
 if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
 return query
 select row_number() over(order by coalesce(cr.total,0) desc,c.experience desc,m.full_name)::bigint,
 c.member_id,m.full_name,c.doctor_avatar_id,coalesce(cr.total,0)::bigint,c.experience,
 coalesce(rt.avg_stars,0)::numeric,coalesce(rt.cnt,0)::bigint
 from y_quan_private.clinics c join public.club_members m on m.id=c.member_id
 left join lateral(select sum(delta) total from y_quan_private.credit_ledger where member_id=c.member_id) cr on true
 left join lateral(select round(avg(stars)::numeric,2) avg_stars,count(*) cnt from y_quan_private.ratings where doctor_id=c.member_id) rt on true
 where m.status::text='approved'
 order by coalesce(cr.total,0) desc,c.experience desc,m.full_name limit greatest(1,least(coalesce(p_limit,50),100));
end $function$;

CREATE OR REPLACE FUNCTION public.y_quan_open_clinic_v1(p_doctor_avatar_id text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
AS $function$
declare mid uuid:=private.current_member_id(); d date:=(now() at time zone 'Asia/Ho_Chi_Minh')::date;
begin
 if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
 if p_doctor_avatar_id not in ('male','female') then raise exception 'Doctor avatar invalid'; end if;
 insert into y_quan_private.clinics(member_id,doctor_avatar_id,is_open,last_seen_at,updated_at)
 values(mid,p_doctor_avatar_id,true,now(),now())
 on conflict(member_id) do update set doctor_avatar_id=excluded.doctor_avatar_id,is_open=true,last_seen_at=now(),updated_at=now();
 insert into y_quan_private.daily_slots(doctor_id,local_day,slot_no,starts_at)
 select mid,d,row_number() over(order by minute_of_day)::smallint,
        (d::timestamp + time '08:00' + make_interval(mins=>minute_of_day)) at time zone 'Asia/Ho_Chi_Minh'
 from (select minute_of_day from generate_series(0,599) minute_of_day order by random() limit 5) x
 on conflict do nothing;
 return public.y_quan_dashboard_v1();
end $function$;

CREATE OR REPLACE FUNCTION public.y_quan_patient_visits_v1()
 RETURNS TABLE(visit_id uuid, doctor_id uuid, doctor_name text, doctor_avatar_id text, profile_avatar_url text, local_day date, slot_no smallint, status text, bot_score smallint, stars smallint)
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
AS $function$
declare mid uuid:=private.current_member_id();
begin
 if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
 return query select v.id,v.doctor_id,m.full_name,c.doctor_avatar_id,m.avatar_url,v.local_day,v.slot_no,v.status,v.bot_score,r.stars
 from y_quan_private.visits v join public.club_members m on m.id=v.doctor_id
 join y_quan_private.clinics c on c.member_id=v.doctor_id
 left join y_quan_private.ratings r on r.visit_id=v.id
 where v.patient_id=mid order by v.created_at desc limit 50;
end $function$;

CREATE OR REPLACE FUNCTION public.y_quan_rate_doctor_v1(p_visit_id uuid, p_stars smallint)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
AS $function$
declare mid uuid := private.current_member_id(); v y_quan_private.visits%rowtype;
begin
 if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
 if p_stars not between 1 and 5 then raise exception 'Rating must be 1..5'; end if;
 select * into v from y_quan_private.visits where id=p_visit_id for update;
 if v.id is null or v.patient_id<>mid or v.status<>'completed' then raise exception 'Only the patient of a completed visit can rate this doctor'; end if;
 insert into y_quan_private.ratings(visit_id,patient_id,doctor_id,stars) values(v.id,mid,v.doctor_id,p_stars);
 insert into y_quan_private.credit_ledger(member_id,source_kind,source_id,delta,metadata) values(v.doctor_id,'patient_rating',v.id,p_stars,jsonb_build_object('stars',p_stars));
 return jsonb_build_object('ok',true,'stars',p_stars);
end $function$;

CREATE OR REPLACE FUNCTION public.y_quan_register_patient_v1(p_doctor_id uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
AS $function$
declare mid uuid:=private.current_member_id(); v_slot y_quan_private.daily_slots%rowtype; v_id uuid; d date:=(now() at time zone 'Asia/Ho_Chi_Minh')::date;
begin
 if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
 if mid=p_doctor_id then raise exception 'You cannot register at your own clinic'; end if;
 if not exists(select 1 from y_quan_private.clinics c where c.member_id=p_doctor_id and c.is_open and c.last_seen_at>now()-interval '3 minutes') then raise exception 'Doctor is not available'; end if;
 select s.* into v_slot from y_quan_private.daily_slots s
 where s.doctor_id=p_doctor_id and s.local_day=d and not exists(select 1 from y_quan_private.visits v where v.doctor_id=s.doctor_id and v.local_day=s.local_day and v.slot_no=s.slot_no)
 order by s.starts_at limit 1 for update skip locked;
 if v_slot.doctor_id is null then raise exception 'No appointments available today'; end if;
 insert into y_quan_private.visits(doctor_id,patient_id,local_day,slot_no)
 values(p_doctor_id,mid,d,v_slot.slot_no) returning id into v_id;
 return jsonb_build_object('visit_id',v_id,'doctor_id',p_doctor_id,'slot_no',v_slot.slot_no,'scheduled_at',v_slot.starts_at,'status','registered');
end $function$;

CREATE OR REPLACE FUNCTION public.y_quan_submit_case_v1(p_visit_id uuid, p_answered_domains text[], p_diagnosis text, p_reasoning text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
AS $function$
declare mid uuid:=private.current_member_id(); v y_quan_private.visits%rowtype;
 valid_ids text[]:=array['cold','sweat','pain','bowel','food','chest','senses','thirst','history','course'];
 answered text[]; n integer; diagnosis_points integer; inquiry_points integer; reasoning_points integer; score integer; xp integer; credits integer; matched integer;
begin
 if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
 select * into v from y_quan_private.visits where id=p_visit_id for update;
 if v.id is null or v.doctor_id<>mid then raise exception 'Visit does not belong to this doctor'; end if;
 if v.status='completed' then return jsonb_build_object('already_completed',true,'bot_score',v.bot_score,'experience',v.experience_awarded); end if;
 select coalesce(array_agg(distinct x),'{}') into answered from unnest(coalesce(p_answered_domains,'{}')) x where x=any(valid_ids);
 n:=cardinality(answered);
 diagnosis_points:=case when lower(coalesce(p_diagnosis,'')) like '%thận dương hư%' or lower(coalesce(p_diagnosis,'')) like '%thận dương bất túc%' then 35 else 0 end;
 inquiry_points:=round(35.0*least(n,10)/10);
 select count(*) into matched from unnest(array['sợ lạnh','thích ấm','lưng','gối','tiểu trong','lượng nhiều']) kw where position(kw in lower(coalesce(p_reasoning,'')))>0;
 reasoning_points:=round(30.0*matched/6);
 score:=least(100,diagnosis_points+inquiry_points+reasoning_points);
 xp:=score; credits:=floor(score/20.0);
 update y_quan_private.visits set status='completed',answered_domains=answered,diagnosis=left(coalesce(p_diagnosis,''),300),reasoning=left(coalesce(p_reasoning,''),1500),bot_score=score,experience_awarded=xp,completed_at=now() where id=v.id;
 update y_quan_private.clinics set experience=experience+xp,updated_at=now() where member_id=mid;
 insert into y_quan_private.credit_ledger(member_id,source_kind,source_id,delta,metadata)
 values(mid,'case',v.id,credits,jsonb_build_object('bot_score',score,'experience',xp,'full',score=100))
 on conflict(member_id,source_kind,source_id) do nothing;
 return jsonb_build_object('already_completed',false,'bot_score',score,'experience',xp,'credits',credits,'full_case',score=100);
end $function$;

CREATE OR REPLACE FUNCTION public.y_quan_submit_daily_case_v1(p_slot_no smallint, p_answered_domains text[], p_diagnosis text, p_reasoning text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog', 'public', 'private', 'y_quan_private', 'auth'
AS $function$
declare mid uuid:=private.current_member_id(); d date:=(now() at time zone 'Asia/Ho_Chi_Minh')::date;
 s y_quan_private.daily_slots%rowtype; valid_ids text[]:=array['cold','sweat','pain','bowel','food','chest','senses','thirst','history','course'];
 answered text[]; n integer; diag integer; inquiry integer; matched integer; reasoning_score integer; score integer; xp integer; credits integer;
begin
 if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
 select * into s from y_quan_private.daily_slots where doctor_id=mid and local_day=d and slot_no=p_slot_no for update;
 if s.doctor_id is null then raise exception 'Daily case not found'; end if;
 if s.completed_at is not null then return jsonb_build_object('already_completed',true,'bot_score',s.bot_score,'experience',s.experience_awarded); end if;
 select coalesce(array_agg(distinct x),'{}') into answered from unnest(coalesce(p_answered_domains,'{}')) x where x=any(valid_ids);
 n:=cardinality(answered);
 diag:=case when lower(coalesce(p_diagnosis,'')) like '%thận dương hư%' or lower(coalesce(p_diagnosis,'')) like '%thận dương bất túc%' then 35 else 0 end;
 inquiry:=round(35.0*least(n,10)/10);
 select count(*) into matched from unnest(array['sợ lạnh','thích ấm','lưng','gối','tiểu trong','lượng nhiều']) kw where position(kw in lower(coalesce(p_reasoning,'')))>0;
 reasoning_score:=round(30.0*matched/6);
 score:=least(100,diag+inquiry+reasoning_score);
 xp:=score; credits:=floor(score/20.0);
 update y_quan_private.daily_slots set completed_at=now(),bot_score=score,experience_awarded=xp where doctor_id=mid and local_day=d and slot_no=p_slot_no;
 update y_quan_private.clinics set experience=experience+xp,updated_at=now(),last_seen_at=now() where member_id=mid;
 insert into y_quan_private.credit_ledger(member_id,source_kind,source_id,delta,metadata)
 values(mid,'case',s.slot_id,credits,jsonb_build_object('score',score,'experience',xp,'full',score=100))
 on conflict(member_id,source_kind,source_id) do nothing;
 return jsonb_build_object('bot_score',score,'experience',xp,'credits',credits,'full_case',score=100);
end $function$;

revoke all on function public.y_quan_clinics_v1() from public,anon;
revoke all on function public.y_quan_close_clinic_v1() from public,anon;
revoke all on function public.y_quan_dashboard_v1() from public,anon;
revoke all on function public.y_quan_doctor_visits_v1() from public,anon;
revoke all on function public.y_quan_leaderboard_v1(integer) from public,anon;
revoke all on function public.y_quan_open_clinic_v1(text) from public,anon;
revoke all on function public.y_quan_patient_visits_v1() from public,anon;
revoke all on function public.y_quan_rate_doctor_v1(uuid,smallint) from public,anon;
revoke all on function public.y_quan_register_patient_v1(uuid) from public,anon;
revoke all on function public.y_quan_submit_case_v1(uuid,text[],text,text) from public,anon;
revoke all on function public.y_quan_submit_daily_case_v1(smallint,text[],text,text) from public,anon;
grant execute on function public.y_quan_clinics_v1() to authenticated;
grant execute on function public.y_quan_close_clinic_v1() to authenticated;
grant execute on function public.y_quan_dashboard_v1() to authenticated;
grant execute on function public.y_quan_doctor_visits_v1() to authenticated;
grant execute on function public.y_quan_leaderboard_v1(integer) to authenticated;
grant execute on function public.y_quan_open_clinic_v1(text) to authenticated;
grant execute on function public.y_quan_patient_visits_v1() to authenticated;
grant execute on function public.y_quan_rate_doctor_v1(uuid,smallint) to authenticated;
grant execute on function public.y_quan_register_patient_v1(uuid) to authenticated;
grant execute on function public.y_quan_submit_case_v1(uuid,text[],text,text) to authenticated;
grant execute on function public.y_quan_submit_daily_case_v1(smallint,text[],text,text) to authenticated;
