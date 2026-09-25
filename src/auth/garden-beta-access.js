// The identity bootstrap provides this member object only after Supabase Auth verifies
// a trusted HIU TMC app_metadata.member_id. The receipt RPC independently checks that
// the linked club_members row is approved and login-enabled before granting access.
export function canAccessGardenBeta(member) {
  return Boolean(member && typeof member.id === 'string' && member.id.trim());
}

export const canAccessGameHub = canAccessGardenBeta;
