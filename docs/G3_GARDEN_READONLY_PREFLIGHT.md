# G3 Garden read-only preflight — 2026-09-25

## Scope and source versions

- This is a read-only compatibility checkpoint after the isolated G2 SSO smoke passed.
- Game Hub extraction map and scenarios are on PR #2, branch `g3/garden-runtime-prep`, head `f47cddbc8c57c99adb8973806fc3497a6d4ba344`.
- The extraction map names Study OS main `drngovothiennhan/yhct-hiu-4-0` at `4282a0e0e3d25d6c387bc98be554abbc79b5d0e4`; that is still the current main head.
- Authoritative Supabase inspection was read-only against the active project. No Garden RPC was called and no rows were changed.

## Runtime and persistence observed

Study OS `HerbGardenGameV7.tsx` imports React, lucide icons, the shared Member type, and the Supabase auth service. Its `load()` issues six calls in parallel:

- `herb_garden_state_v3()`
- `herb_garden_inventory_v3()`
- `herb_garden_visit_v2(p_member_id)`
- `herb_garden_seed_inventory_v1()`
- `herb_garden_reward_status_v1()`
- `herb_garden_wallet_v1()`

The action handler passes only `p_slot_no` to the existing plant, water, fertilizer, and harvest RPCs. Initial plot setup submits exactly three distinct slot numbers through `herb_garden_select_initial_plots_v3(p_slots)`. The V7 component contains no local-storage save implementation; persistent state is server-owned.

Current save tables and keys:

| Data | Key / fields |
|---|---|
| Plants | UUID row; member, species key, slot, planted/maturity/expiry timestamps, status, water/fertilizer counters, care streaks, reward counters |
| Harvested herbs | Composite member + species key |
| Seeds | Composite member + species key |
| Wallet | Member key, balance, initialization/update timestamps |
| Plots | Composite member + slot; unlocked/initial-selection flags, harvest count |
| Events | UUID row linked to member and plant, with type, slot and metadata |
| Garden profile | Member key, theme and decor JSON |

The sample member's baseline currently has no rows in plants, harvested inventory, seeds, wallet, plots, events, or Garden profiles. This is a row-count-only result; no personal profile fields or identifiers are recorded here.

## Live RPC and authorization contract

- `plant_v3`, `water_v4`, `fertilize_v4`, `harvest_v3`, and `select_initial_plots_v3` are SECURITY DEFINER and executable by `authenticated` and `service_role`, not `anon`. They resolve the caller's member from Auth and require approval.
- Water and fertilizer delegate to `private.herb_garden_apply_care_v7`; it locks the active plant row, rejects invalid/late/duplicate care slots, updates counters, appends an event and returns the new care state.
- Harvest synchronizes state, requires a mature non-expired plant and 12 water + 3 fertilizer actions, then atomically marks harvest and grants one herb, one same-species seed, three credits, one plot harvest and an event before evaluating sequential unlock.
- Garden tables have RLS enabled, no table policies, and no direct SELECT privilege for `anon` or `authenticated`. The Hub must use the approved public RPC surface.
- The seed-inventory and reward-status RPCs have PUBLIC/anon execute grants, but their bodies require a current approved member before returning data. Do not expose or call private helpers as client APIs; confirm PostgREST schema exposure before any adapter depends on them.

## Critical read-side effects

The V7 page's initial `load()` is not read-only even though most calls are named as reads:

- `state_v3` ensures plot rows and synchronizes plant lifecycle state.
- `visit_v2` also ensures plots and synchronizes the requested member's garden.
- `seed_inventory_v1` may initialize starter seeds.
- `reward_status_v1` may initialize starter seeds and a wallet.
- `wallet_v1` may initialize a wallet.

Therefore, opening the production Garden UI for a parity check could create or update save rows before any action button is pressed. The G2 shell was safe to smoke because it does not call Garden RPCs; do not launch V7 against a production member to “read” the state.

## G3 gate

- No Supabase development branches currently exist.
- No transaction rollback harness has been demonstrated for these SECURITY DEFINER RPCs.
- The authorized sample has an empty Garden baseline, but that alone does not make production writes safe.
- No runtime extraction, Garden read, gameplay action, migration, or Supabase write was performed in this checkpoint.
- Before integrating a live Garden adapter or opening the Garden route, establish a non-production identity/data set or prove a rollback procedure end-to-end. Mocked RPC contract tests and disabled-action UI checks may be developed before that gate; no production read-style RPC may be used for preview smoke.

## Next

Continue code-only G3 work behind the gated Garden route using the exact V7 component behavior and mocked RPC responses. Keep the Study OS route/runtime untouched. Enable live RPC parity and plant/care/harvest QA only after isolated storage and recovery evidence are recorded.
