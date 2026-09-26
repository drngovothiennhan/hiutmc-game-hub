# Garden expansion — Chapter 2

## Unlock condition

Show Chapter 2 only when the authoritative `herb_garden_state_v3` snapshot contains all nine distinct plot slots (1–9) with `unlocked = true`. Missing or duplicate slots keep the chapter hidden. The browser derives visibility only; it never grants plot access.

## Story and activity

The approved landscape elements are the pond, garden path, and expanded scenery. After the ninth plot opens, these form the Chapter 2 scene and three selectable story stops. The opening activity is to survey all nine plots by recording at least one harvest in each. Progress comes from each server-returned `harvest_count`.

## Compatibility and reward boundary

- Keep the Study OS save, current Garden RPCs, plot progression, seed bag, herb inventory, and credit wallet unchanged.
- Add no tables, migrations, direct database writes, new reward, academic fact, treatment guidance, or achievement.
- Present the survey as complete only when every opened slot has `harvest_count > 0`.
- Do not mutate or test a real member's production save to simulate the nine-plot state.
