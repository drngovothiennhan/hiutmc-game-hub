-- notifications.kind is CHECK-constrained; reuse the existing seed-reward kind.
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
    values (p_member_id, 'herb_garden_seed_reward', 'Nhận thưởng mốc Gia Viên',
            d.title || ': +' || d.reward_credits || ' tín dụng' || case when d.reward_seeds > 0 then ' và +' || d.reward_seeds || ' hạt giống.' else '.' end);
  return jsonb_build_object('applied', true, 'milestone_key', p_key, 'title', d.title,
    'credits_reward', d.reward_credits, 'seed_reward', d.reward_seeds, 'seed_key', sk,
    'seed_quantity', seed_qty, 'wallet_balance', bal);
end $$;


revoke all on function private.herb_garden_claim_milestone_v1(uuid, text) from public, anon, authenticated;
