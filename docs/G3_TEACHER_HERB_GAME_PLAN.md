# G3 plan — Teacher Herb Game sequel
**Checkpoint:** 2026-09-25  
**Status:** completion gate agreed; isolated one-time entitlement vertical slice implemented for QA. No Study OS runtime, Garden save, production schema, or production data was changed.

## Product direction

Game Hub hosts a new, visually richer sequel tentatively named **Teacher Herb Game**. It is a continuation after the learner passes the existing Gia Viên Dược Thảo experience in Study OS. Gia Viên remains in Study OS as the prerequisite game and continues to own its runtime, rules, and save data. Game Hub owns the sequel's UI, art direction, game logic, and separate sequel progress.

On the Game Hub main page, show a sequel card with clear locked/unlocked state. Before eligibility, link the learner to the existing Study OS Gia Viên. After eligibility is confirmed, open the sequel route. Do not embed, mirror, or migrate the old Garden runtime into Game Hub.

## Reuse and separation

- Reuse the verified G2 SSO/session bridge, trusted `app_metadata.member_id`, Game Hub shell, navigation, responsive foundation, and preview pipeline.
- Keep Garden V7 and its current Supabase RPCs/tables exclusively in Study OS. Do not read its save tables from the Game Hub client or copy a Garden save.
- Reuse reviewed visual assets only where their license/source and intended use are established. Create a distinct, more detailed sequel presentation; do not redraw or change Garden V7.
- Store sequel progress separately from Garden. Do not reuse Garden rewards, inventory, credits, plot state, or event history as sequel state.
- Preserve the existing Study OS Garden entry and behavior throughout G3.

## Completion gate: verify before coding

The completion gate is finalized as **exactly plots 1 through 9, all server-confirmed unlocked**. This matches the existing V7 progression display “Đã mở đủ 9 ô”; unlocking plot 9 does not require harvesting plot 9. The user confirmed this as the meaning of passing Gia Viên for this sequel gate on 2026-09-25. There is no explicit Garden completion flag, so the server derives the gate directly from the existing `herb_garden_plots` rows without invoking side-effecting Garden RPCs. The predicate requires 9 rows, minimum slot 1, maximum slot 9, and all 9 `unlocked=true`.

Do not infer eligibility from browser state, a client flag, a member ID supplied by the client, or an assumed count.

## One-time unlock contract

Use a one-time, server-verified entitlement exchange. It conveys eligibility only; it does not synchronize Garden save data.

1. Game Hub calls a parameterless authenticated RPC. The browser sends no member identifier or completion boolean.
2. The backend binds the request to `auth.uid()` and only the trusted `app_metadata.member_id`, checks the linked approved/login-enabled member row, and reads the nine Garden plot rows without calling a Garden RPC.
3. In one atomic operation, the backend creates a minimal entitlement receipt in the unexposed `game_hub_private` schema. A unique `(member_id, game_key)` constraint makes repeated or concurrent requests return the same durable receipt.
4. The browser receives only eligibility, receipt ID, grant time, and a bounded reason. It does not receive Garden rows or a completion proof. It uses the server receipt to render the sequel entry; the sequel route rechecks the entitlement returned by the RPC.

The Game Hub migration and client flow are committed on PR #3. The migration has been applied only to the new isolated QA Supabase project with synthetic source-schema fixtures. Production has not received the migration. Study OS continues to write its existing Garden tables/RPCs; no Study OS source edit, Garden mutation, token secret, or extra proof service is required.

## Delivery slices

| Slice | Work | Exit evidence |
|---|---|---|
| G3.1 — completion contract | Confirm the 9/9 server-unlocked predicate and read existing source schema. | Exact predicate and columns recorded; no gameplay writes. Complete. |
| G3.2 — entitlement vertical slice | Add the private receipt store, authenticated RPC, and fail-closed Game Hub client gate. | Synthetic isolated DB tests pass for 9/9, locked 8/9, replay, trusted claim, and grants. Complete in QA. |
| G3.3 — gated sequel shell | Add the main-page card, a receipt-gated route, and recheck control in Game Hub. | CI and responsive preview pass; locked by default; no Garden runtime/data calls. Complete as a shell only; this is not yet playable gameplay. |
| G3.4 — sequel experience | Build detailed play from the sequel's approved learning scenarios and store its state separately in Game Hub. | Blocked until the sequel's actual content/rules are specified and approved; the current Garden scenarios explicitly do not authorize copying their gameplay into the sequel. |
| G3.5 — sample QA | Verify the designated member's genuine 9/9 completion and play the sequel using isolated data. | Blocked: the verified sample snapshot has no Garden rows; shared production schema has not been changed. Do not manufacture a positive result. |

## Acceptance and release boundary

- The learner cannot bypass the unlock with a browser flag, direct route, stale receipt, another member's receipt, or duplicate handoff.
- A learner who has not passed the existing Study OS prerequisite stays locked; the Game Hub main page offers the existing prerequisite link.
- An eligible learner receives one durable entitlement; reconnecting does not require a second Garden sync.
- Garden V7 routes, RPCs, save format and production data remain unchanged. The old Study OS experience remains available.
- All gameplay facts, objectives and scoring for the sequel must come from approved source scenarios; do not invent academic claims or alter Garden rules.
- CI/build/isolated preview and authenticated sample QA must pass before declaring G3 complete. Keep PRs draft until those gates pass.
- No merge, production deployment, DNS/domain change, production schema/data mutation, or Study OS source edit is part of this checkpoint. The QA entitlement database contains only test schema/fixture tables; synthetic QA rows were removed after tests, leaving zero receipts and zero fixture members.
