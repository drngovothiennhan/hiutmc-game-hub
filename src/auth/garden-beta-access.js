export function canAccessGardenBeta(member) {
  return Boolean(member && typeof member.id === 'string' && member.id.trim());
}

export const canAccessGameHub = canAccessGardenBeta;
