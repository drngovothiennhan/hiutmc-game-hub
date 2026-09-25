# Game Hub UX handoff — G3 Garden

**Status:** G3 Garden runtime extraction brief, 2026-09-25.

## Product flow

- Keep the existing Gia Viên Dược Thảo route in Study OS available while Game Hub work is in preview.
- Show the same Garden experience as locked in Game Hub until the server confirms the learner has unlocked plots 1–9 in Study OS.
- Record one private, idempotent receipt on first eligible entry. The browser cannot submit a member ID or completion flag.
- After the receipt is verified, open the Gia Viên runtime in Game Hub. It is the same game and uses the existing Garden save format and authoritative RPC behavior.
- The learner must see an active Garden runtime, not an entitlement receipt page or an empty handoff shell.

## Runtime and visual direction

- Extract `HerbGardenGameV7` and its cleared Garden assets from the current Study OS source. Keep Garden rules, actions, labels, data fields, and rewards aligned with the source.
- A richer scene may frame the existing board and panels, but must not create separate game rules or duplicate the Garden save.
- Keep HIU TMC SSO and member identity server-verified. The Hub may use only the trusted `app_metadata.member_id` claim.
- Maintain responsive behavior at 320, 390, 711, 768, and 1024px widths.

## Release boundary

The Study OS runtime remains active until Game Hub passes the scenario comparison and isolated save/reload checks. Do not merge, deploy production, change DNS, or write production Garden data as part of G3 preview work.
