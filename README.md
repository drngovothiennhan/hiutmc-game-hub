# HIU TMC Game Hub

Independent academic game hub for the HIU TMC ecosystem.

This repository is separate from `yhct-hiu-4-0`; it does not copy the Study OS application. The Hub reuses the verified HIU TMC SSO session while keeping game modules and their save ownership separate.

## Delivery order

- G1 — read-only audit and existing game contracts
- G2 — Hub shell, identity bridge, world map, routing, responsive/PWA foundation
- G3 — continue the same Gia Viên Dược Thảo in Game Hub with a richer presentation after a server-confirmed one-time unlock. Study OS keeps its runtime available until behavior and save parity are accepted.
- G4 — reviewed academic layer for new content
- G5 — separately plan HIU Y Quán; no current runtime move is implied

G3 uses a one-time, server-verified unlock receipt and keeps the existing Garden save format and RPCs authoritative. Read `docs/G3_GARDEN_GAME_PLAN.md` before G3 implementation. The extraction map and scenarios define the behavior that must be preserved.

## Safety

- Do not store passwords or Supabase service-role/secret keys in the browser app.
- Use the trusted Auth member identity; browser state never grants eligibility or rewards.
- Keep the current Study OS runtime available, and preserve its RPC, rules, and save behavior in Game Hub until parity is accepted.
- Do not test against member production saves or enable Garden RPCs in Game Hub.
- Verify isolated storage and rollback before any gameplay persistence or production entitlement backend change.
- Keep PRs draft and preserve existing Study OS routes until review and preview gates pass.
