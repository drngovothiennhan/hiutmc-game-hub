# HIU TMC Game Hub

Independent academic game hub for the HIU TMC ecosystem.

This repository is separate from `yhct-hiu-4-0`. It must not copy the Study OS application. The first implementation phase is a modular Hub shell and preview. Existing Garden and HIU Y Quán game state remains in the current Supabase project until the Hub preview and compatibility gates pass.

## Delivery order

- G1 — read-only audit and contract record
- G2 — Hub shell, identity bridge, world map, routing, profile/skill/achievement shells, responsive/PWA foundation
- G3 — migrate Garden UI to the existing authoritative RPCs without changing save data or gameplay
- G4 — reviewed academic layer
- G5 — migrate HIU Y Quán after Garden production is stable

## Safety

- Do not store passwords or Supabase service-role/secret keys in this app.
- Keep Supabase identity and existing game RPCs as the initial source of truth.
- Do not run Garden actions against member production saves during QA.
- Do not merge or deploy a release before CI, preview, SSO, responsive, and save-parity checks pass.
- Preserve legacy Study OS game routes until migration is verified.

G3 mounts the extracted Garden V7 runtime for every authenticated, approved HIU TMC member using a server-verified one-time access receipt. The original sequential plot progression remains active inside the Garden. Gameplay parity and isolated save/reload QA are recorded in docs/GAME_CONTRACTS.md.
