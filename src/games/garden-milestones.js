/**
 * Garden milestone rewards (client side).
 * The server decides progress and pays out once per milestone; this module only
 * validates what the server returns and shapes it for the journey panel.
 */
const STATUSES = new Set(['locked', 'in_progress', 'claimable', 'claimed']);

export function normalizeMilestones(rows) {
  if (!Array.isArray(rows)) return null;
  const items = [];
  for (const row of rows) {
    if (!row || typeof row.milestone_key !== 'string' || !STATUSES.has(row.status)) return null;
    const chapter = Number(row.chapter);
    const target = Number(row.target);
    if (![1, 2].includes(chapter) || !(target > 0)) return null;
    items.push({
      key: row.milestone_key,
      chapter,
      sort: Number(row.sort_no) || 0,
      title: String(row.title || ''),
      description: String(row.description || ''),
      target,
      progress: Math.max(0, Math.min(target, Number(row.progress) || 0)),
      credits: Math.max(0, Number(row.reward_credits) || 0),
      seeds: Math.max(0, Number(row.reward_seeds) || 0),
      status: row.status,
      claimedAt: row.claimed_at || null,
    });
  }
  return items.sort((a, b) => a.sort - b.sort);
}

export function summarizeJourney(items) {
  const chapters = [1, 2].map((chapter) => {
    const list = items.filter((item) => item.chapter === chapter);
    const claimed = list.filter((item) => item.status === 'claimed');
    return {
      chapter,
      items: list,
      total: list.length,
      claimed: claimed.length,
      claimable: list.filter((item) => item.status === 'claimable').length,
      creditsTotal: list.reduce((sum, item) => sum + item.credits, 0),
      seedsTotal: list.reduce((sum, item) => sum + item.seeds, 0),
      creditsEarned: claimed.reduce((sum, item) => sum + item.credits, 0),
      seedsEarned: claimed.reduce((sum, item) => sum + item.seeds, 0),
      complete: list.length > 0 && claimed.length === list.length,
    };
  });
  const open = items.filter((item) => item.status !== 'claimed');
  const claimable = open.filter((item) => item.status === 'claimable');
  const next = claimable[0] || open.find((item) => item.status === 'in_progress') || open[0] || null;
  return {
    chapters,
    claimableCount: claimable.length,
    next,
    chapter2Reached: items.some((item) => item.key === 'c1_open_9' && (item.status === 'claimable' || item.status === 'claimed')),
  };
}

/** Message built only from values the server confirmed in its reply. */
export function describeClaim(result) {
  if (!result || typeof result !== 'object') return 'Máy chủ không xác nhận được phần thưởng. Hãy làm mới để kiểm tra.';
  if (result.applied !== true) return 'Mốc này đã được nhận trước đó.';
  const credits = Number(result.credits_reward) || 0;
  const seeds = Number(result.seed_reward) || 0;
  const parts = [];
  if (credits > 0) parts.push(`+${credits} tín dụng`);
  if (seeds > 0) parts.push(`+${seeds} hạt giống`);
  return `${result.title || 'Mốc thưởng'}: ${parts.join(' và ') || 'đã ghi nhận'}. Số dư tín dụng: ${Number(result.wallet_balance) || 0}.`;
}
