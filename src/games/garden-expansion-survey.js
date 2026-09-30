/**
 * Presentation-only helpers for the Garden Chapter 2 survey map.
 * Everything is derived from the server-returned plot snapshot and inventory;
 * nothing here unlocks plots, writes progress, grants rewards or adds facts.
 */
export const SURVEY_ZONES = [
  { id: 'pond', label: 'Bờ ao', hint: 'Luống 1–3', slots: [1, 2, 3] },
  { id: 'path', label: 'Lối dạo', hint: 'Luống 4–6', slots: [4, 5, 6] },
  { id: 'landscape', label: 'Vùng cảnh quan', hint: 'Luống 7–9', slots: [7, 8, 9] },
];

/** State of one plot on the survey map. */
export function surveyPlotState(plot) {
  if (!plot || plot.unlocked !== true) return 'locked';
  if (Number(plot.harvest_count) > 0) return 'surveyed';
  if (plot.ready_for_harvest === true || plot.status === 'mature') return 'ready';
  if (plot.id && plot.status === 'growing') return 'growing';
  return 'open';
}

/** Build the 9 survey nodes plus per-zone progress and the recommended next plot. */
export function deriveSurveyMap(plots = []) {
  const bySlot = new Map(plots.filter((p) => Number.isInteger(p?.slot_no)).map((p) => [p.slot_no, p]));
  let activeAssigned = false;
  const zones = SURVEY_ZONES.map((zone) => {
    const nodes = zone.slots.map((slot) => {
      const plot = bySlot.get(slot);
      const state = surveyPlotState(plot);
      return { slot, state, harvests: Number(plot?.harvest_count) > 0 ? Number(plot.harvest_count) : 0 };
    });
    const surveyed = nodes.filter((n) => n.state === 'surveyed').length;
    const complete = surveyed === nodes.length;
    let status = complete ? 'complete' : 'pending';
    if (!complete && !activeAssigned) { status = 'active'; activeAssigned = true; }
    return { ...zone, nodes, surveyed, total: nodes.length, complete, status };
  });

  const order = { ready: 0, growing: 1, open: 2 };
  const candidates = zones.flatMap((z) => z.nodes).filter((n) => n.state in order)
    .sort((a, b) => order[a.state] - order[b.state] || a.slot - b.slot);
  const next = candidates[0] || null;
  const hint = !next ? null : next.state === 'ready'
    ? `Luống ${next.slot} đã chín — thu hoạch để ghi vào bản đồ.`
    : next.state === 'growing'
      ? `Luống ${next.slot} đang lớn — chăm đúng lịch rồi quay lại thu hoạch.`
      : `Luống ${next.slot} còn trống — gieo một hạt để bắt đầu khảo sát.`;

  const surveyedTotal = zones.reduce((sum, z) => sum + z.surveyed, 0);
  return {
    zones,
    surveyedTotal,
    nextPlot: next ? { slot: next.slot, state: next.state, hint } : null,
    activeZoneId: zones.find((z) => z.status === 'active')?.id ?? null,
  };
}

/** Scene lighting from the viewer's local hour; purely cosmetic. */
export function sceneTimeOfDay(hour) {
  const h = Number.isFinite(hour) ? ((Math.floor(hour) % 24) + 24) % 24 : 12;
  if (h >= 5 && h < 8) return 'dawn';
  if (h >= 8 && h < 17) return 'day';
  if (h >= 17 && h < 19) return 'dusk';
  return 'night';
}

/** Distinct herb species the member has harvested, from the server inventory. */
export function deriveHerbarium(inventory = []) {
  const seen = new Map();
  for (const item of inventory) {
    if (!item?.seed_key || !(Number(item.quantity) > 0) || seen.has(item.seed_key)) continue;
    seen.set(item.seed_key, { key: item.seed_key, name: item.name, botanical: item.botanical_name, quantity: Number(item.quantity) });
  }
  return [...seen.values()].sort((a, b) => String(a.name).localeCompare(String(b.name), 'vi'));
}
