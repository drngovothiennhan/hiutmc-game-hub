const PLOT_SLOTS = Array.from({ length: 9 }, (_, index) => index + 1);

/** Admin preview is read-only and based only on the verified auth role. */
export function isGardenAdminPreview(role) {
  return String(role || '').trim().toLowerCase() === 'admin';
}

/**
 * Derive the chapter gate from the server-returned Garden plot snapshot.
 * This is presentation only: it never unlocks plots, writes progress, or grants rewards.
 */
export function deriveGardenExpansion(plots = [], { adminPreview = false } = {}) {
  const plotsBySlot = new Map(
    plots
      .filter((plot) => Number.isInteger(plot?.slot_no) && PLOT_SLOTS.includes(plot.slot_no))
      .map((plot) => [plot.slot_no, plot]),
  );
  const allNineOpen = PLOT_SLOTS.every((slot) => plotsBySlot.get(slot)?.unlocked === true);
  const unlockedCount = PLOT_SLOTS.filter((slot) => plotsBySlot.get(slot)?.unlocked === true).length;
  const firstHarvests = PLOT_SLOTS.filter((slot) => plotsBySlot.get(slot)?.unlocked === true
    && Number(plotsBySlot.get(slot)?.harvest_count) > 0).length;

  return {
    available: allNineOpen || adminPreview,
    allNineOpen,
    adminPreview,
    previewOnly: adminPreview && !allNineOpen,
    unlockedCount,
    firstHarvests,
    totalPlots: PLOT_SLOTS.length,
    surveyComplete: allNineOpen && firstHarvests === PLOT_SLOTS.length,
  };
}
