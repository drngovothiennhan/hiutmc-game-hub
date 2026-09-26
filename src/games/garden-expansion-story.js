const PLOT_SLOTS = Array.from({ length: 9 }, (_, index) => index + 1);

/**
 * Derive the chapter gate from the server-returned Garden plot snapshot.
 * This is presentation only: it never unlocks plots, writes progress, or grants rewards.
 */
export function deriveGardenExpansion(plots = []) {
  const plotsBySlot = new Map(
    plots
      .filter((plot) => Number.isInteger(plot?.slot_no) && PLOT_SLOTS.includes(plot.slot_no))
      .map((plot) => [plot.slot_no, plot]),
  );
  const allNineOpen = PLOT_SLOTS.every((slot) => plotsBySlot.get(slot)?.unlocked === true);
  const firstHarvests = allNineOpen
    ? PLOT_SLOTS.filter((slot) => Number(plotsBySlot.get(slot)?.harvest_count) > 0).length
    : 0;

  return {
    available: allNineOpen,
    firstHarvests,
    totalPlots: PLOT_SLOTS.length,
    surveyComplete: allNineOpen && firstHarvests === PLOT_SLOTS.length,
  };
}
