# Garden expansion — Chapter 2

## Unlock condition

Show Chapter 2 only when the authoritative `herb_garden_state_v3` snapshot contains all nine distinct plot slots (1–9) with `unlocked = true`. Missing or duplicate slots keep the chapter hidden. The browser derives visibility only; it never grants plot access.

## Story and activity

The approved landscape elements are the pond, garden path, and expanded scenery. After the ninth plot opens, these form the Chapter 2 scene and three selectable story stops. The opening activity is to survey all nine plots by recording at least one harvest in each. Progress comes from each server-returned `harvest_count`.

## Compatibility and reward boundary

- Keep the Study OS save, current Garden RPCs, plot progression, seed bag, herb inventory, and credit wallet unchanged.
- Chapter 2 itself adds no academic fact or treatment guidance. Rewards are now paid only through the server milestone RPCs in `docs/GARDEN_MILESTONE_REWARDS.md`; the browser never grants anything.
- Present the survey as complete only when every opened slot has `harvest_count > 0`.
- Do not mutate or test a real member's production save to simulate the nine-plot state.

## Survey map upgrade (presentation only)

- The three story stops map to plot zones: Bờ ao (plots 1–3), Lối dạo (4–6), Vùng cảnh quan (7–9). Each zone is complete when all its plots have `harvest_count > 0`.
- The survey map shows each plot as locked / open / growing / ready / surveyed from server fields and links to the live plot board. "Việc tiếp theo" suggests ready → growing → empty plots.
- The herbarium lists distinct species with quantity > 0 from the existing server inventory.
- Scene lighting follows the viewer's local hour and ambient motion is disabled under `prefers-reduced-motion`.
- Still no new tables, RPCs, rewards, achievements or academic/treatment content. Logic lives in `src/games/garden-expansion-survey.js` with tests.
