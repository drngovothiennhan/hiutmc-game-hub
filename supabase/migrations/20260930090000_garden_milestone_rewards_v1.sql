-- Garden milestone rewards v1 (additive only).
-- Adds a claim ledger and two RPCs. Existing plots, plants, wallets, seed
-- inventory and all existing RPCs are unchanged. Rewards are granted once per
-- member per milestone by the server after it verifies progress itself.

create table if not exists public.herb_garden_milestone_claims (
  member_id uuid not null references public.club_members(id) on delete cascade,
  milestone_key text not null,
  reward_credits integer not null check (reward_credits >= 0),
  reward_seeds integer not null check (reward_seeds >= 0),
  seed_key text,
  claimed_at timestamptz not null default now(),
  primary key (member_id, milestone_key)
);
alter table public.herb_garden_milestone_claims enable row level security;
revoke all on public.herb_garden_milestone_claims from public, anon, authenticated;

create or replace function private.herb_garden_milestone_defs_v1()
returns table(milestone_key text, chapter smallint, sort_no smallint, title text, description text, target integer, reward_credits integer, reward_seeds integer)
language sql immutable set search_path = '' as $$
  select * from (values
    ('c1_first_harvest'::text, 1::smallint, 1::smallint, 'Thu hoạch đầu tiên'::text, 'Thu hoạch thành công 1 cây ở bất kỳ ô nào.'::text, 1, 5, 0),
    ('c1_open_4', 1, 2, 'Mở ô thứ 4', 'Mở đủ 4 ô trong khu vườn.', 4, 5, 1),
    ('c1_open_6', 1, 3, 'Mở ô thứ 6', 'Mở đủ 6 ô trong khu vườn.', 6, 8, 1),
    ('c1_open_9', 1, 4, 'Cổng tre mở: đủ 9 ô', 'Mở đủ 9 ô để bước sang Chương 2.', 9, 15, 2),
    ('c2_zone_pond', 2, 5, 'Khảo sát Bờ ao', 'Mỗi ô 1–3 có ít nhất 1 vụ thu hoạch.', 3, 10, 0),
    ('c2_zone_path', 2, 6, 'Khảo sát Lối dạo', 'Mỗi ô 4–6 có ít nhất 1 vụ thu hoạch.', 3, 12, 1),
    ('c2_zone_landscape', 2, 7, 'Khảo sát Vùng cảnh quan', 'Mỗi ô 7–9 có ít nhất 1 vụ thu hoạch.', 3, 15, 1),
    ('c2_herbarium_5', 2, 8, 'Sổ dược thảo 5 loài', 'Thu hoạch được 5 loài dược liệu khác nhau.', 5, 20, 1),
    ('c2_survey_complete', 2, 9, 'Hoàn tất bản đồ khảo sát', 'Cả 9 ô đều có ít nhất 1 vụ thu hoạch.', 9, 30, 3)
  ) as t(milestone_key, chapter, sort_no, title, description, target, reward_credits, reward_seeds);
$$;

create or replace function private.herb_garden_milestone_progress_v1(p_member_id uuid)
returns table(milestone_key text, progress integer)
language sql stable security definer set search_path = '' as $$
  with pl as (
    select slot_no, unlocked, harvest_count from public.herb_garden_plots where member_id = p_member_id
  ), agg as (
    select
      coalesce(sum(harvest_count) filter (where unlocked), 0)::integer as harvests,
      count(*) filter (where unlocked)::integer as opened,
      count(*) filter (where unlocked and harvest_count > 0 and slot_no between 1 and 3)::integer as z1,
      count(*) filter (where unlocked and harvest_count > 0 and slot_no between 4 and 6)::integer as z2,
      count(*) filter (where unlocked and harvest_count > 0 and slot_no between 7 and 9)::integer as z3
    from pl
  ), sp as (
    select count(distinct seed_key)::integer as species from public.herb_garden_plants
    where member_id = p_member_id and harvested_at is not null
  )
  select 'c1_first_harvest', least(agg.harvests, 1) from agg
  union all select 'c1_open_4', least(agg.opened, 4) from agg
  union all select 'c1_open_6', least(agg.opened, 6) from agg
  union all select 'c1_open_9', least(agg.opened, 9) from agg
  union all select 'c2_zone_pond', agg.z1 from agg
  union all select 'c2_zone_path', agg.z2 from agg
  union all select 'c2_zone_landscape', agg.z3 from agg
  union all select 'c2_herbarium_5', least(sp.species, 5) from sp
  union all select 'c2_survey_complete', agg.z1 + agg.z2 + agg.z3 from agg;
$$;

create or replace function private.herb_garden_milestones_for_v1(p_member_id uuid)
returns table(milestone_key text, chapter smallint, sort_no smallint, title text, description text, target integer, progress integer, reward_credits integer, reward_seeds integer, status text, claimed_at timestamptz)
language sql stable security definer set search_path = '' as $$
  select d.milestone_key, d.chapter, d.sort_no, d.title, d.description, d.target,
         least(coalesce(p.progress, 0), d.target),
         d.reward_credits, d.reward_seeds,
         case when c.member_id is not null then 'claimed'
              when coalesce(p.progress, 0) >= d.target then 'claimable'
              when coalesce(p.progress, 0) > 0 then 'in_progress'
              else 'locked' end,
         c.claimed_at
  from private.herb_garden_milestone_defs_v1() d
  left join private.herb_garden_milestone_progress_v1(p_member_id) p on p.milestone_key = d.milestone_key
  left join public.herb_garden_milestone_claims c on c.member_id = p_member_id and c.milestone_key = d.milestone_key
  order by d.sort_no;
$$;

create or replace function private.herb_garden_claim_milestone_v1(p_member_id uuid, p_key text)
returns jsonb
language plpgsql security definer set search_path = '' as $$
declare d record; prog integer; got boolean; sk text; bal integer; seed_qty integer;
begin
  select * into d from private.herb_garden_milestone_defs_v1() where milestone_key = p_key;
  if d.milestone_key is null then raise exception 'Mốc thưởng không tồn tại.'; end if;
  -- serialise per member so a double tap cannot pay twice
  perform pg_advisory_xact_lock(hashtextextended('garden_milestone:' || p_member_id::text, 0));
  if exists (select 1 from public.herb_garden_milestone_claims where member_id = p_member_id and milestone_key = p_key) then
    select balance into bal from public.herb_garden_wallets where member_id = p_member_id;
    return jsonb_build_object('applied', false, 'reason', 'already_claimed', 'milestone_key', p_key, 'wallet_balance', coalesce(bal, 0));
  end if;
  select progress into prog from private.herb_garden_milestone_progress_v1(p_member_id) where milestone_key = p_key;
  if coalesce(prog, 0) < d.target then raise exception 'Chưa đạt điều kiện của mốc này.'; end if;

  sk := null;
  if d.reward_seeds > 0 then
    -- seed of a species the member has harvested with the lowest stock; else Hoàng kỳ
    select s.seed_key into sk from public.herb_garden_seed_inventory s
      where s.member_id = p_member_id and exists (select 1 from public.herb_garden_inventory i where i.member_id = p_member_id and i.seed_key = s.seed_key)
      order by s.quantity asc, s.seed_key asc limit 1;
    sk := coalesce(sk, 'hoang-ky');
  end if;

  insert into public.herb_garden_milestone_claims(member_id, milestone_key, reward_credits, reward_seeds, seed_key)
    values (p_member_id, p_key, d.reward_credits, d.reward_seeds, sk)
    on conflict do nothing returning true into got;
  if got is not true then
    return jsonb_build_object('applied', false, 'reason', 'already_claimed', 'milestone_key', p_key);
  end if;

  perform private.ensure_herb_garden_wallet(p_member_id);
  update public.herb_garden_wallets set balance = balance + d.reward_credits, updated_at = now()
    where member_id = p_member_id returning balance into bal;
  if d.reward_seeds > 0 then
    insert into public.herb_garden_seed_inventory(member_id, seed_key, quantity, updated_at)
      values (p_member_id, sk, d.reward_seeds, now())
      on conflict (member_id, seed_key) do update set quantity = public.herb_garden_seed_inventory.quantity + d.reward_seeds, updated_at = now();
    select quantity into seed_qty from public.herb_garden_seed_inventory where member_id = p_member_id and seed_key = sk;
  end if;
  insert into public.notifications(member_id, kind, title, body)
    values (p_member_id, 'herb_garden_milestone_reward', 'Nhận thưởng mốc Gia Viên',
            d.title || ': +' || d.reward_credits || ' tín dụng' || case when d.reward_seeds > 0 then ' và +' || d.reward_seeds || ' hạt giống.' else '.' end);
  return jsonb_build_object('applied', true, 'milestone_key', p_key, 'title', d.title,
    'credits_reward', d.reward_credits, 'seed_reward', d.reward_seeds, 'seed_key', sk,
    'seed_quantity', seed_qty, 'wallet_balance', bal);
end $$;

create or replace function public.herb_garden_milestones_v1()
returns table(milestone_key text, chapter smallint, sort_no smallint, title text, description text, target integer, progress integer, reward_credits integer, reward_seeds integer, status text, claimed_at timestamptz)
language plpgsql stable security definer set search_path = '' as $$
declare mid uuid := private.current_member_id();
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  return query select * from private.herb_garden_milestones_for_v1(mid);
end $$;

create or replace function public.herb_garden_claim_milestone_v1(p_key text)
returns jsonb
language plpgsql security definer set search_path = '' as $$
declare mid uuid := private.current_member_id();
begin
  if mid is null or not private.is_approved() then raise exception 'Approved member required'; end if;
  return private.herb_garden_claim_milestone_v1(mid, p_key);
end $$;

revoke all on function private.herb_garden_milestone_defs_v1() from public, anon, authenticated;
revoke all on function private.herb_garden_milestone_progress_v1(uuid) from public, anon, authenticated;
revoke all on function private.herb_garden_milestones_for_v1(uuid) from public, anon, authenticated;
revoke all on function private.herb_garden_claim_milestone_v1(uuid, text) from public, anon, authenticated;
revoke all on function public.herb_garden_milestones_v1() from public, anon;
revoke all on function public.herb_garden_claim_milestone_v1(text) from public, anon;
grant execute on function public.herb_garden_milestones_v1() to authenticated;
grant execute on function public.herb_garden_claim_milestone_v1(text) to authenticated;
