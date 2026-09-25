# Garden to Game Hub — gameplay and learning scenarios

**Status:** scenario specification based on the current runtime and verified contract. No new herbs, diagnoses, rewards, or gameplay rules are authored here.
**Scope:** Gia Viên Dược Thảo V7 only. HIU Y Quán stays on its current Study OS runtime.

## Player flow

1. **Enter from the ecosystem.** A signed-in member opens the opt-in/approved Game Hub entry. The Hub validates the existing session and shows the member profile; no second password or new save is created.
2. **Open Gia Viên.** Present a short introduction, “Túi giống”, “Kho dược liệu đã thu hoạch”, credits, and the authoritative plot state. Keep seed stock visually distinct from harvested-herb stock.
3. **First visit.** If initial plot selection is incomplete, explain and select exactly three starting plots, then submit through `herb_garden_select_initial_plots_v3`. Show success only after the server confirms it.
4. **Plant and care.** The member selects an available seed and plot; planting is sent through `herb_garden_plant_v3`. Show the server's care schedule. Water/fertilizer actions use their existing RPCs and display server responses; client clocks are explanatory only.
5. **Growth.** Show the existing 72-hour cycle, up to 12 six-hour water slots, and 3 daily fertilizer slots. Clearly distinguish “đang lớn”, “đủ điều kiện”, “đã chết”, and “đã thu hoạch” from server state. Do not claim maturity or eligibility from browser calculations.
6. **Harvest.** Enable harvest only when the server reports eligibility. Submit `herb_garden_harvest_v3` once; after confirmed success, refresh state and show the separate server-reported herb inventory, matching seed inventory, credits, plot harvest count and event.
7. **Unlock progression.** Explain the next plot requirement. Show the next sequential slot as open only after server state confirms every currently open plot has a valid first harvest; stop at slot 9.
8. **Errors and recovery.** On timeout, auth expiry, denial, or failed action, preserve the server result, show a clear retry/re-auth message, and reload authoritative state. Never optimistically award stock, credits, or unlocks.

## Existing acceptance contract

- Growth cycle: 72 hours.
- Care: up to 12 six-hour water slots and 3 daily fertilizer slots.
- Harvest grace: 24 hours after maturity.
- A valid harvest yields +1 harvested herb, +1 same-species seed, and +3 credits in the server transaction.
- Initial setup: 3 plots; sequential unlocks continue up to 9 after every currently open plot has a first valid harvest.
- Source of truth: existing Supabase RPCs; no direct browser writes to game tables and no reward computation trusted from the client.

## Academic content boundary

Use only the existing Garden catalog and its source fields during the first extraction. Preserve source references and caution fields. Do not add or alter botanical facts, dosage, cautions, curriculum points, achievements, or clinical interpretations until item-level academic review is complete.

## QA sequence

1. Contract/unit tests with a mocked RPC client (no network and no production credentials).
2. Visual/navigation checks at 390px, 768px, tablet landscape, and desktop with action buttons disabled.
3. Isolated identity/rollback verification.
4. Read-only state parity before/after the session bridge in the isolated environment.
5. Mutative gameplay QA only against isolated test data after the isolation/rollback gate is evidenced.
6. Production cutover only after the old Study OS link, deep links, SSO, save parity, and restore plan pass review.
