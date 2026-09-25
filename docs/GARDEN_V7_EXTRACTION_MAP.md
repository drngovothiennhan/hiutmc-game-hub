> **G3 direction (2026-09-25):** Active extraction map for moving the same Gia Viên Dược Thảo runtime into Game Hub in controlled stages. Study OS remains available until parity is accepted. The one-time receipt gates access; Garden saves and RPCs remain authoritative and are not copied. See [G3 plan](G3_GARDEN_GAME_PLAN.md).

# Garden V7 extraction map

**Status:** Source contract verified; Game Hub runtime port is in progress. This document maps Study OS as the behavioral source and does not by itself prove parity.
**Read-only source:** `drngovothiennhan/yhct-hiu-4-0` `main` at `4282a0e0e3d25d6c387bc98be554abbc79b5d0e4`.
**Game Hub base:** `g3/garden-runtime-prep`, forked from `g2/game-hub-shell`.
**Data boundary:** keep the existing Supabase project, member identity and RPC contracts. No schema/RPC edits, direct table writes, generated herb facts, or production game actions.

## Runtime and dependency map

| Concern | Exact existing source | Extraction decision |
|---|---|---|
| Garden gameplay component | `src/components/game/HerbGardenGameV7.tsx`, SHA `869d8d5f7894deb717d289347d038d3296eeb593` | Preserve behavior; place behind a dedicated Garden entry point. Do not rewrite gameplay. |
| Game facade | `src/components/game/HerbGardenGame.tsx`, SHA `ec089e6f3982967bdb931632ba6196c949792f6a` | Do not copy wholesale: it selects HIU Y Quán and imports Y Quán V20 components. Replace only the Garden module boundary with a Garden-only host. |
| Auth/Supabase client | `src/services/authService.ts`, SHA `15c858d912ba99fd752357238a1fb30fc6405f3c` | Build a Hub adapter around the existing member session and the same Supabase project. Never copy the Study OS login UI or password handling. |
| Member shape | `src/types/index.ts`, SHA `7f3507dd9d9d849e0a82a618ff6198f69f167dea` | Pass the minimum verified member shape required by V7: `id` and any display fields actually read by the component. `id` must come from trusted HIU TMC `app_metadata.member_id`. |
| React | Study OS `react@18.3.1` | Required because V7 uses React hooks. Pin compatible versions in the Hub build before extraction. |
| Icons | Study OS `lucide-react@0.468.0` | V7 imports the icons used by its current Garden panels. |
| Supabase SDK | Study OS `@supabase/supabase-js@2.57.4` | Needed only for the authenticated RPC adapter. Use the public publishable key; no service key. |
| Decorative sprite | `public/garden-decor-sprite.svg`, SHA `5645f9c0d0d8549d17a7b46b36dd07b48ab1e86a` | Copy as a static asset and preserve its existing `garden-decor-sprite.svg#<symbol>` IDs. |
| V7 direct styles | `src/herb-garden-v2.css` SHA `ff4bf0189cb898996e4a55486a15629556f8751d`; `src/garden-v6.css` SHA `0329a9e6e41dadf762bd9c9c50072fd5c29973a2`; `src/garden-rewards.css` SHA `720df7f99df2db47db4c5d54d0e5c5c9234e7524` | Include only with an isolated Garden document/entry so broad selectors cannot restyle the Hub shell. |
| Garden host styles | `src/garden-sky-v8.css` SHA `258e1ea3bb77aa466323a0210c25a8ccbd139bd0`; `src/garden-personalization.css` SHA `e166793e2bd6e42ea702cb8d074cf3906cd0cb17`; `src/garden-professional-v7.css` SHA `e70d243b4ff726562935d3c7f5801e099ef0641c`; `src/garden-community-v13.css` SHA `a2c03b64e1f380617b72afcd628b5110a5ea3f16` | Review class usage and include only the styles V7 actually needs. Do not import Y Quán styles. |

The complete Study OS facade also imports Y Quán V20/engagement CSS and components. Those remain outside G3.

## Server contract used by V7

| Purpose | Existing RPCs |
|---|---|
| Garden snapshot and supporting reads | `herb_garden_state_v3`, `herb_garden_inventory_v3`, `herb_garden_visit_v2`, `herb_garden_seed_inventory_v1`, `herb_garden_reward_status_v1`, `herb_garden_wallet_v1` |
| Initial plot selection | `herb_garden_select_initial_plots_v3` |
| Player actions | `herb_garden_plant_v3`, `herb_garden_water_v4`, `herb_garden_fertilize_v4`, `herb_garden_harvest_v3` |

V7 calls `herb_garden_fertilize_v4`. Do not copy the facade's legacy `fertilizerLegacy: herb_garden_fertilize_v3` marker as the current runtime contract. Rewards, maturity, care eligibility and unlocks remain server-owned.

## Hub integration boundary

1. Receive the ecosystem bridge and verify the Supabase access token.
2. Resolve the member ID only from trusted `app_metadata.member_id`; do not accept a client-provided ID as authority.
3. Establish the same user's Supabase session in the Garden adapter; do not create a Garden save or a Hub-only account.
4. Render V7 under a separate `/garden/` build entry with an explicit “Quay lại Game Hub” path. Keep HIU Y Quán on its existing Study OS URL until its later phase.
5. Keep Garden reads/actions unavailable in public preview until a dedicated test identity or demonstrably safe rollback harness is verified.

## Verification gates still required

- Inspect the complete live `water_v4` and `fertilize_v4` definitions, execute grants and authorization checks from the approved source environment before the adapter calls them.
- Verify an isolated approved test identity or rollback harness.
- Compare the same test member's Garden snapshot before/after SSO, with no save reset or duplicate record.
- Run gameplay contract QA only in the isolated environment; do not plant, water, fertilize or harvest on a production member's save.
