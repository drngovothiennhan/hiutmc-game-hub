const GAME_HUB_STAFF_ROLES = new Set(['admin', 'mod', 'super_mod']);

export function canAccessGardenBeta(member) {
  const role = String(member?.role || '').trim().toLowerCase();
  return Boolean(member && typeof member.id === 'string' && member.id.trim() && GAME_HUB_STAFF_ROLES.has(role));
}

export const canAccessGameHub = canAccessGardenBeta;
