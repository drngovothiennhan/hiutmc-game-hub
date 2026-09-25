const PRIVILEGED_ROLES = new Set(['admin', 'mod', 'super_mod']);

export function canAccessGardenBeta(member) {
  return Boolean(member && PRIVILEGED_ROLES.has(String(member.role || '').trim().toLowerCase()));
}
