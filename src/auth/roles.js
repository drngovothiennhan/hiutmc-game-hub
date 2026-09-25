// This value is trusted only when it comes from the server-issued app_metadata
// returned by the HIU TMC Supabase Auth endpoint.
const GAME_HUB_ADMIN_ROLES = new Set(['admin', 'administrator', 'super_admin', 'super-admin', 'superadmin', 'system_admin', 'global_admin', 'owner']);

export function isGameHubAdmin(member) {
  return GAME_HUB_ADMIN_ROLES.has(String(member?.role || '').trim().toLowerCase());
}
