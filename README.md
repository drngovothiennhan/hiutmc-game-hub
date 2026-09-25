# HIU TMC Game Hub

Independent academic game hub for the HIU TMC ecosystem.

This repository is separate from `yhct-hiu-4-0`; it does not copy the Study OS application. The Hub reuses the verified HIU TMC SSO session while keeping game modules and their save ownership separate.

## Delivery order

- G1 — read-only audit and existing game contracts
- G2 — Hub shell, identity bridge, world map, routing, responsive/PWA foundation
- G3 — build a new, visually richer Teacher Herb Game sequel in Game Hub. Learners unlock it only after the existing Gia Viên Dược Thảo prerequisite is completed in Study OS. Study OS keeps the current Garden runtime and saves.
- G4 — reviewed academic layer for new content
- G5 — separately plan HIU Y Quán; no current runtime move is implied

G3 uses a one-time, server-verified completion entitlement. It does not copy or continuously synchronize Garden saves. Read `docs/G3_TEACHER_HERB_GAME_PLAN.md` before G3 implementation. The previous Garden extraction map and scenarios remain compatibility references for the existing Study OS game; they are not the current G3 product direction.

## Safety

- Do not store passwords or Supabase service-role/secret keys in the browser app.
- Use the trusted Auth member identity; browser state never grants eligibility or rewards.
- Keep Garden V7 runtime, RPCs, rules and saves in Study OS.
- Do not test against member production saves or enable Garden RPCs in Game Hub.
- Verify isolated storage and rollback before adding sequel persistence or an entitlement backend.
- Keep PRs draft and preserve existing Study OS routes until review and preview gates pass.
