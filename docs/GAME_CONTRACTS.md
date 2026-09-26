# HIU TMC Game Hub — Existing Game Contracts

**Baseline:** Study OS `drngovothiennhan/yhct-hiu-4-0` at `e10987e3b1ad2764f504e1b882c8f4617b5e627f`  
**Database observed:** Supabase project `gzmpnsrwqjpsbklyflqr`  
**Purpose:** compatibility record for extraction. It is not authorization to change current production gameplay.

## Ownership boundary

- Supabase is authoritative for member identity, approved status, game state, inventory, credits, harvest receipts, plots, and HIU Y Quán attempts/profiles.
- Current game tables link records to `club_members.id` using `member_id`. Hub must use this same member ID and current ecosystem session.
- Browser state is presentation only. Never accept client-supplied reward values, unlock decisions, ownership, or mastery as authoritative.
- Game actions must continue through the currently authorized RPCs. Do not add direct client writes to game tables or expose a Supabase service-role key.
- Existing data stays in the current project for the first Hub release. Do not create new empty save records as a migration substitute.

## Gia Viên Dược Thảo — verified gameplay contract

| Action/rule | Current authoritative behavior | Verified source |
|---|---|---|
| Plant | `herb_garden_plant_v3(p_slot_no)` checks approved member, valid slot, initial plot selection, unlocked/empty slot, and available valid seed; consumes one seed and creates a growing plant with maturity at `now() + 3 days` and expiry at `now() + 4 days`. | Live function definition in Supabase; migration `20260924051021_garden_harvest_grace_24h_and_receipt_guard_v1.sql`. |
| Water | 12 valid six-hour growth slots per 72-hour cycle; the selected plot is submitted to the server RPC. | Live RPC inventory; current Web CI `garden-water-contract-check.mjs`; earlier server care migration and current UI contract. Confirm full v4 body before extraction. |
| Fertilize | 3 valid daily growth-day slots per 72-hour cycle. | Live RPC inventory; current Web CI `garden-fertilizer-contract-check.mjs`; current UI contract. Confirm full v4 body before extraction. |
| Growth/maturity | 72 hours. Server sync marks a plant mature only after the cycle and required 12 water + 3 fertilizer actions; a plant reaching 72 hours without those requirements is marked dead. | Live `herb_garden_state_v3` / sync routines; harvest-grace migration; CI contract scripts. |
| Harvest grace | 24 hours from maturity; expired mature plants cannot be harvested. A migration extended expiry from 6 to 24 hours and the harvest RPC checks expiry. | Migration `20260924051021_garden_harvest_grace_24h_and_receipt_guard_v1.sql`; live `herb_garden_harvest_v3`. |
| Harvest eligibility | The chosen member's chosen slot must hold a live mature plant, have at least 12 water and 3 fertilizer actions, and be before its expiry. | Live `herb_garden_harvest_v3(p_slot_no)` definition. |
| Harvest reward | In the same server transaction: mark plant harvested, add **+1 dược liệu** to `herb_garden_inventory`, add **+1 same-species seed** to `herb_garden_seed_inventory`, add **+3 credits** to wallet, increment plot `harvest_count`, append harvest event/notification, then evaluate unlock progression. | Live `herb_garden_harvest_v3` definition. |
| Seed bag vs harvested herb | Planting consumes from `herb_garden_seed_inventory`; the harvested plant is recorded separately in `herb_garden_inventory`. UI must label these as “Túi giống” and “Kho dược liệu đã thu hoạch.” | Live `herb_garden_plant_v3`, `herb_garden_seed_inventory_v1`, `herb_garden_inventory_v3`; schema inspection. |
| Initial plots | Plot rows 1–9 are ensured; the existing initial-selection flow expects three selected initial plots. | Live `private.ensure_herb_garden_plots_v3`, `herb_garden_state_v3`, and `herb_garden_plant_v3`. |
| Sequential unlock | Count the initial selected plots and unlocked plots. A next plot opens only when every currently unlocked plot has `harvest_count > 0`; then unlock the lowest numbered locked plot. Stops at nine. | Live `private.herb_garden_unlock_progress_v3`. |
| Read state | `herb_garden_state_v3` returns per-plot unlocked/selected flags, harvest count, lifecycle/care state, and sourced herb fields; it runs server synchronization first. | Live function definition. |

### Garden migration invariants

1. Preserve all rows and IDs in `herb_garden_plants`, `herb_garden_inventory`, `herb_garden_seed_inventory`, `herb_garden_wallets`, `herb_garden_events`, `herb_garden_plots`, and `herb_garden_profiles`.
2. Preserve the current RPC contracts and exactly-once transactional harvest behavior; do not let client retries duplicate rewards.
3. Preserve the difference between harvested herb inventory and plantable seed inventory throughout API types, UI labels, and QA.
4. Do not test plant/care/harvest on a real member's production save. Use isolated test identity/data or a transaction that is demonstrably rolled back.
5. Before G3, inspect the complete current `water_v4` and `fertilize_v4` bodies and all grants/RLS dependencies in the new local checkout; names/CI contract alone are insufficient evidence for the Hub adapter.

## HIU Y Quán — verified preservation boundary

- The currently wired game runtime is `HiuYQuanGameV20.tsx` plus `src/components/game/yquan-v20/*`; the parent game facade selects `game=hiu-y-quan`.
- Current Web CI includes unified V20 contract checks, mobile/visual checks, and a runtime playthrough script.
- Existing server-owned records include `hiu_y_quan_profiles`, `hiu_y_quan_cases`, `hiu_y_quan_attempts`, `hiu_y_quan_engagement_profiles`, `hiu_y_quan_mastery`, and `hiu_y_quan_herb_challenge_sessions`.
- Relevant installed RPC families include `hiu_y_quan_*` activation, case, appointment, collection, consultation, and gameplay routines. They remain in Study OS/Supabase during G2/G3; Y Quán extraction belongs to G5.
- This audit verified runtime wiring, table presence, and RPC inventory. It did not certify case-content provenance, clinical pedagogy, or patient-simulation correctness. Do not add or generate cases during migration.

## Identity and authorization contract

- Reuse the HIU TMC/Study OS Supabase identity and `club_members.id`; carry only the minimum profile fields: member ID, role, display name, and avatar.
- Current Study OS login calls the `member-login` Edge Function and establishes a Supabase Auth session. Its ecosystem bridge uses an `ecosystem_sso=1` URL fragment, calls `setSession`, and removes the fragment from browser history.
- Never copy passwords, create a Hub-only credential, accept user-editable metadata as authority, or trust a client-supplied `member_id` for writes.
- Inspected game tables have RLS enabled. No direct table policies were returned by the catalog query; current game behavior is mediated by server functions. Before new Hub data or direct table access, review effective grants, RLS, each `SECURITY DEFINER` function's explicit member/approval checks, and function execute grants.
- Several read-oriented RPCs showed `anon` execute grants in metadata. Their bodies require an approved-member check in the inspected paths; verify individually and avoid exposing them as unauthenticated Hub APIs.

## Academic layer is not part of this compatibility contract

Do not insert unverified herb facts, formulas, clinical cases, point coordinates, mastery scores, or achievements during G2/G3. Current Garden UI/data includes an existing herb catalog; its field presence does not mean every academic source has been audited. G4 requires item-level provenance and review. AI may explain reviewed canonical content after a learner action, but it cannot play, alter save history, grant rewards, or award mastery.

## G3 acceptance tests required before release

Use contract/unit tests and an isolated approved test identity to verify:

- 72-hour maturity; 12 water slots; 3 fertilizer slots; 24-hour harvest grace.
- No harvest until all server predicates pass; no harvest after expiry.
- One valid harvest produces exactly one herb, one matching seed, +3 credits, one harvest increment/event, and the expected unlock result.
- Each open plot requires at least one valid harvest before the next sequential slot opens; progression stops at slot 9.
- The same member's Garden snapshot before and after Hub login is identical until a deliberate test action is applied; no new/reset save appears.
- Cross-member reads/writes are denied; unauthenticated calls are denied where required; no service-role key is shipped.
- Old Study OS path and game links continue to work until Hub login, deep link, and save-parity smoke pass.
- Mobile, tablet-landscape, and desktop shell/navigation; offline UI never claims a server action synchronized.

No G3 acceptance transaction was run during G1. The production database was not mutated.


## G2 shell boundary update — 2026-09-25

The separate Game Hub repository has now been created. Its shell consumes an incoming HIU TMC Supabase session and uses the server-issued `app_metadata.member_id`; it does not query `club_members` directly or create Hub credentials. The existing Garden and Y Quán links remain outbound links to the current Study OS runtime, and no game state is read or written by the shell. SSO/CORS and member-session behavior remain unverified until a public preview can be exercised.


## G3 beta access policy — 2026-09-26

- The beta is available to every linked HIU TMC member whose current database record is approved and has login enabled, regardless of role.
- The browser only uses the linked member ID to begin verification. The authenticated receipt RPC independently checks `auth.uid()`, trusted `app_metadata.member_id`, approval, and `login_enabled`; a role claim or client flag cannot issue a receipt.
- Anonymous, unlinked, unapproved, and login-disabled accounts receive no beta route or unlock receipt. The private receipt table remains inaccessible to client roles, and the receipt RPC remains authenticated-only.
- Game Hub runtime errors are sent to the authenticated `garden_hub_report_error_v1` RPC after sensitive values are removed and context is allowlisted. Reports are rate-limited and appear in Admin Center > Nhật ký from `ecosystem_audit_log`.
- This access policy does not change gameplay progression or existing saves. Do not test gameplay persistence against member production saves.
