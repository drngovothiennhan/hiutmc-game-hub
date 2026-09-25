# G3 plan — Gia Viên Dược Thảo in Game Hub

**Direction:** G3 is one continuous Gia Viên Dược Thảo experience. Study OS remains the current runtime while Game Hub receives the same Garden runtime in controlled stages.

## Product and data contract

- Keep the existing Gia Viên Dược Thảo experience in Study OS available until the Game Hub runtime passes parity checks and a later cutover is approved.
- After the learner completes the agreed Study OS prerequisite, Game Hub records one durable, idempotent unlock receipt. The receipt is a one-time access decision, not a copy of Garden state.
- The gate is exactly plots 1–9 present and server-confirmed `unlocked=true` for all nine. Unlocking plot 9 completes the gate; harvesting plot 9 is not an extra requirement.
- Continue using the existing Garden save format and authoritative Garden RPCs. Do not copy, reset, or duplicate a member's plants, inventory, wallet, plots, or event history.
- Trust only the authenticated `app_metadata.member_id`, bound server-side to `auth.uid()` and the approved/login-enabled member profile. Never accept a client member ID or completion flag.
- Preserve the approved G2 Ecosystem → Game Hub SSO bridge. Keep bridge tokens in the URL fragment and remove them after receipt.

## Runtime extraction

The Game Hub runtime is based on Study OS `src/components/game/HerbGardenGameV7.tsx` at source commit `4282a0e0e3d25d6c387bc98be554abbc79b5d0e4`. The extraction keeps its scenario, timing, RPC names, save fields, reward handling, inventory separation, and plot progression. The Hub adapter supplies the verified session to the existing RPCs; it must not invent Garden rules or call the Study OS host page.

The initial Game Hub visual pass may improve the scene around the existing Garden board while keeping its interactions and data contracts intact. Visual changes must not change growing, care, harvest, reward, unlock, or save behavior.

## Delivery stages

| Stage | Work | Exit evidence |
| --- | --- | --- |
| G3.1 | Verify source runtime, completion gate, RPCs, save fields, and side effects read-only. | Source commit and extraction map recorded; no gameplay writes. |
| G3.2 | Implement the private one-time unlock receipt and fail-closed client gate. | Isolated synthetic tests for 9/9, 8/9, repeat calls, untrusted identity, and unavailable RPC; no production migration. |
| G3.3 | Port Garden V7 and its visual assets into Game Hub behind the receipt gate. | CI/build and isolated preview; source-to-Hub contract review. |
| G3.4 | Verify planting, care, harvest, seed bag, herb storage, plot unlock, and save reload against the existing runtime. | QA on an isolated dataset with a rollback path and before/after evidence. |
| G3.5 | Keep both runtimes available until the parity report is accepted. | Separate release decision; no automatic Study OS cutover. |

## Safety and current checkpoint

- No merge, production deployment, DNS change, Study OS edit, production schema change, or production gameplay write is included in this PR.
- The designated QA member is `20262026`; use the secure browser login flow and never request credentials in chat.
- Do not use the member's production Garden for gameplay until isolation and rollback are verified. If an isolated backend cannot support the same authenticated source functions, pause live gameplay QA and report the blocker.
- Do not claim parity based on a successful build or a page opening. The five gameplay flows in G3.4 and persisted before/after state are required.
