begin;

create table if not exists can_lam_sang_private.cls_publish_config (
  config_id boolean primary key default true,
  unreviewed_enabled boolean not null default false,
  unreviewed_expires_at timestamptz,
  label_text text not null default 'Ca mô phỏng do A.I mô phỏng — CHƯA KIỂM DUYỆT',
  updated_at timestamptz not null default pg_catalog.now(),
  constraint cls_publish_config_label_check check (pg_catalog.btrim(label_text) <> '')
);
insert into can_lam_sang_private.cls_publish_config(config_id) values(true) on conflict(config_id) do nothing;

create or replace function can_lam_sang_private.cls_content_visible_v1(p_review_status text)
returns boolean language plpgsql security definer set search_path = '' as $function$
declare c can_lam_sang_private.cls_publish_config%rowtype;
begin
 select * into c from can_lam_sang_private.cls_publish_config where config_id=true;
 if p_review_status='DA_DUYET' then return true; end if;
 if p_review_status<>'CHUA_DUYET' then return false; end if;
 return coalesce(c.unreviewed_enabled,false) and c.unreviewed_expires_at is not null and pg_catalog.now() <= c.unreviewed_expires_at;
end $function$;

create or replace function can_lam_sang_private.cls_review_fields_v1(p_review_status text)
returns jsonb language plpgsql security definer set search_path = '' as $function$
declare c can_lam_sang_private.cls_publish_config%rowtype;
begin
 select * into c from can_lam_sang_private.cls_publish_config where config_id=true;
 return pg_catalog.jsonb_build_object('review_status',p_review_status,'review_label',case when p_review_status='DA_DUYET' then null when p_review_status='CHUA_DUYET' and can_lam_sang_private.cls_content_visible_v1(p_review_status) then c.label_text else null end);
end $function$;

-- L1 proposal: the existing CBC RPCs are replaced with the same contracts plus server review fields.
create or replace function public.cls_cbc_start_v1(p_level text)
returns jsonb language plpgsql security definer set search_path = '' as $function$
declare v_user uuid:=auth.uid(); v_s can_lam_sang_private.cbc_scenarios%rowtype; v_id uuid; v_review jsonb;
begin
 if v_user is null then return pg_catalog.jsonb_build_object('ok',false,'code','khong_xac_thuc','data',null); end if;
 if not can_lam_sang_private.cls_user_enabled_v1(v_user) then return pg_catalog.jsonb_build_object('ok',false,'code','chua_mo','data',null); end if;
 if p_level is null or p_level not in('co_ban','trung_binh','nang_cao') then return pg_catalog.jsonb_build_object('ok',false,'code','level_khong_hop_le','data',null); end if;
 select s.* into v_s from can_lam_sang_private.cbc_scenarios s join can_lam_sang_private.cbc_patterns p on p.pattern_id=s.pattern_id where s.level=p_level and can_lam_sang_private.cls_content_visible_v1(p.review_status) order by s.scenario_key limit 1;
 if v_s.scenario_key is null then return pg_catalog.jsonb_build_object('ok',false,'code','chua_co_scenario','data',null); end if;
 insert into can_lam_sang_private.cbc_attempts(user_id,scenario_key,level,variant,sex) values(v_user,v_s.scenario_key,v_s.level,v_s.variant,v_s.sex) returning id into v_id;
 v_review:=can_lam_sang_private.cls_review_fields_v1((select p.review_status from can_lam_sang_private.cbc_patterns p where p.pattern_id=v_s.pattern_id));
 return pg_catalog.jsonb_build_object('ok',true,'code',null,'data',pg_catalog.jsonb_build_object('attempt_id',v_id,'level',v_s.level,'public_scenario',v_s.public_scenario)||v_review);
end $function$;

create or replace function public.cls_cbc_get_v1(p_attempt_id uuid)
returns jsonb language plpgsql security definer set search_path = '' as $function$
declare v_user uuid:=auth.uid(); v_a can_lam_sang_private.cbc_attempts%rowtype; v_s can_lam_sang_private.cbc_scenarios%rowtype; v_review jsonb;
begin
 if v_user is null then return pg_catalog.jsonb_build_object('ok',false,'code','khong_tim_thay','data',null); end if;
 if not can_lam_sang_private.cls_user_enabled_v1(v_user) then return pg_catalog.jsonb_build_object('ok',false,'code','chua_mo','data',null); end if;
 select a.* into v_a from can_lam_sang_private.cbc_attempts a where a.id=p_attempt_id and a.user_id=v_user for update;
 if v_a.id is null then return pg_catalog.jsonb_build_object('ok',false,'code','khong_tim_thay','data',null); end if;
 select s.* into v_s from can_lam_sang_private.cbc_scenarios s where s.scenario_key=v_a.scenario_key;
 if v_a.status='submitted' then return pg_catalog.jsonb_build_object('ok',true,'code','da_nop','data',v_a.result); end if;
 v_review:=can_lam_sang_private.cls_review_fields_v1((select p.review_status from can_lam_sang_private.cbc_patterns p where p.pattern_id=v_s.pattern_id));
 return pg_catalog.jsonb_build_object('ok',true,'code',null,'data',pg_catalog.jsonb_build_object('attempt_id',v_a.id,'level',v_a.level,'public_scenario',v_s.public_scenario)||v_review);
end $function$;

-- Core case RPC signatures are reserved here; full adapter/storage integration remains a separate proposal and is not executed in L1.
create or replace function public.cls_get_case_v1(p_case_id text)
returns jsonb language plpgsql security definer set search_path = '' as $function$
begin return pg_catalog.jsonb_build_object('ok',false,'code','chua_mo','data',null); end $function$;
commit;
