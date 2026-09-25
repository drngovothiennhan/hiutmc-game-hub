# G3 plan — Teacher Herb Game sequel
**Checkpoint:** 2026-09-25  
**Status:** approved product direction; design and integration gates only. No Study OS runtime, Garden save, Supabase schema, or production data was changed.

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

The inspected Garden contract records sequential plot progression: initial three plots, later plots unlock after the currently unlocked plots each have a valid harvest, up to nine. The reviewed contract does **not** identify an explicit “all rounds passed” marker or a completion receipt. Do not treat the plot progression as the completion rule without confirming it against the current Study OS UI, scenario and authoritative server behavior.

G3.1 must identify the exact user-visible pass condition, authoritative producer, and server-readable evidence. If no reliable completion marker exists, document the smallest safe server-side completion assertion that can be added later; do not infer completion from browser state, a client flag, an untrusted member ID, or a guessed plot count.

## One-time unlock contract

Use a one-time, server-verified entitlement exchange. It conveys eligibility only; it does not synchronize Garden save data.

1. The Study OS side confirms its existing completion rule and issues a short-lived proof for the authenticated member and the sequel audience. The proof is submitted in a POST body, never a query string or analytics event.
2. A Game Hub server-side verifier validates issuer, audience, member binding, expiry and unique receipt ID. The member binding must match the current Auth user's trusted `app_metadata.member_id`.
3. In one atomic operation, Game Hub records a minimal entitlement for that member and sequel version. Enforce uniqueness so duplicate/replayed proofs cannot grant duplicate state. Replaying a valid already-consumed proof returns the existing entitlement without creating another.
4. The browser receives only the eligibility/result state. Never trust localStorage or a client-supplied `eligible=true` as access control. Once granted, the sequel can load its own Game Hub save without calling Garden again.

The precise producer/verifier endpoint and persistence mechanism remain a design gate. The reviewed production project has no isolated Supabase branch or proven rollback harness. Do not create production tables/RPCs, secrets, Edge Functions, or write data until a non-production environment and rollback path are verified and the smallest required backend change is reviewed. Prefer a Game Hub-owned entitlement record; add no Garden fields or mutations.

## Delivery slices

| Slice | Work | Exit evidence |
|---|---|---|
| G3.1 — completion contract | Read current Study OS completion scenarios and authoritative server sources; identify exact pass predicate and evidence. Keep this read-only. | Source commit, pass condition, and trustworthy producer recorded; ambiguity resolved without gameplay writes. |
| G3.2 — bridge design | Specify proof claims, audience, expiry, replay/idempotency, identity binding, error cases, and isolated storage/rollback. | Reviewed contract and threat-focused tests; no production changes. |
| G3.3 — sequel shell | Add main-page sequel card and separate route; locked state points to existing Study OS prerequisite. Build richer visual direction in Game Hub. | Responsive preview; locked by default; no Garden RPC/table calls. |
| G3.4 — entitlement vertical slice | Implement isolated server verification and a separate sequel save only after isolation/recovery gate. | Unit/contract tests for locked, eligible, wrong member, expired, replayed and duplicate handoff. |
| G3.5 — sample QA | Verify the designated QA member's completion through the safe authenticated UI and exercise only the sequel in isolated storage. | Positive/negative unlock checks and before/after sequel state evidence; Garden state unchanged. |

## Acceptance and release boundary

- The learner cannot bypass the unlock with a browser flag, direct route, stale receipt, another member's receipt, or duplicate handoff.
- A learner who has not passed the existing Study OS prerequisite stays locked; the Game Hub main page offers the existing prerequisite link.
- An eligible learner receives one durable entitlement; reconnecting does not require a second Garden sync.
- Garden V7 routes, RPCs, save format and production data remain unchanged. The old Study OS experience remains available.
- All gameplay facts, objectives and scoring for the sequel must come from approved source scenarios; do not invent academic claims or alter Garden rules.
- CI/build/isolated preview and authenticated sample QA must pass before declaring G3 complete. Keep PRs draft until those gates pass.
- No merge, production deployment, DNS/domain change, production schema/data mutation, or Study OS source edit is part of this checkpoint.
