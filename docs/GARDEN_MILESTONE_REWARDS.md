# Garden milestone rewards (Chapters 1 + 2)

Server-authoritative, once per member per milestone. Added by
`20260930090000_garden_milestone_rewards_v1.sql` and
`20260930091000_garden_milestone_rewards_notification_kind_fix_v1.sql`
(both already applied to the shared Supabase project; additive only).

| Key | Ch. | Condition (server-verified) | Credits | Seeds |
|---|---|---|---|---|
| c1_first_harvest | 1 | ≥1 harvest | 5 | 0 |
| c1_open_4 | 1 | 4 plots open | 5 | 1 |
| c1_open_6 | 1 | 6 plots open | 8 | 1 |
| c1_open_9 | 1 | 9 plots open (opens Chapter 2) | 15 | 2 |
| c2_zone_pond | 2 | plots 1–3 each harvested | 10 | 0 |
| c2_zone_path | 2 | plots 4–6 each harvested | 12 | 1 |
| c2_zone_landscape | 2 | plots 7–9 each harvested | 15 | 1 |
| c2_herbarium_5 | 2 | 5 distinct species harvested | 20 | 1 |
| c2_survey_complete | 2 | all 9 plots harvested | 30 | 3 |

Total 120 credits + 10 seeds. Seed rewards are of the member's lowest-stock harvested species (fallback Hoàng kỳ).

## RPCs
- `herb_garden_milestones_v1()` → rows with progress and status (`locked|in_progress|claimable|claimed`).
- `herb_garden_claim_milestone_v1(p_key)` → `{applied, credits_reward, seed_reward, seed_key, seed_quantity, wallet_balance}`; a repeat returns `applied:false`. A per-member advisory lock plus the `(member_id, milestone_key)` primary key prevent double payment.
- Ledger table `herb_garden_milestone_claims` has RLS on and no direct grants.

## Boundaries
Existing plots, plants, wallets, inventories and RPCs are untouched. The client only displays what the server returns and never grants anything. Verified in a rolled-back transaction (claim, repeat, invalid key, unmet condition); no member data was changed.
