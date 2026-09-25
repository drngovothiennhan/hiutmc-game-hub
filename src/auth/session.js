import { SUPABASE_PUBLISHABLE_KEY, SUPABASE_URL } from '../config.js';

export const SESSION_STORAGE_KEY = 'hiutmc-game-hub-session-v1';
const BRIDGE_FLAG = 'ecosystem_sso';

function decodeJwtPayload(token) {
  try {
    const part = token.split('.')[1];
    const normalized = part.replace(/-/g, '+').replace(/_/g, '/');
    const padded = normalized + '='.repeat((4 - normalized.length % 4) % 4);
    return JSON.parse(decodeURIComponent(escape(atob(padded))));
  } catch {
    return {};
  }
}

function expiryFromToken(token) {
  const exp = Number(decodeJwtPayload(token).exp || 0);
  return exp > 0 ? exp * 1000 : Date.now() + 45 * 60 * 1000;
}

function clearBridgeFragment() {
  window.history.replaceState(null, '', window.location.pathname + window.location.search);
}

function consumeIncomingBridge() {
  if (!window.location.hash) return null;
  const fragment = new URLSearchParams(window.location.hash.slice(1));
  if (fragment.get(BRIDGE_FLAG) !== '1') return null;
  const accessToken = fragment.get('access_token') || '';
  const refreshToken = fragment.get('refresh_token') || '';
  clearBridgeFragment();
  if (accessToken.length < 40 || refreshToken.length < 20) throw new Error('Phiên HIU TMC gửi sang không hợp lệ. Hãy mở Game Hub lại từ hệ sinh thái.');
  return { accessToken, refreshToken, expiresAt: expiryFromToken(accessToken) };
}

function readStoredSession() {
  try {
    const value = JSON.parse(localStorage.getItem(SESSION_STORAGE_KEY) || 'null');
    if (value?.accessToken && value?.refreshToken) return value;
  } catch {}
  return null;
}

function saveSession(session) {
  localStorage.setItem(SESSION_STORAGE_KEY, JSON.stringify(session));
}

export function buildLegacySsoUrl(href, session) {
  const target = new URL(href);
  if (session?.accessToken && session?.refreshToken) {
    target.hash = new URLSearchParams({
      ecosystem_sso: '1',
      access_token: session.accessToken,
      refresh_token: session.refreshToken
    }).toString();
  }
  return target.toString();
}

async function refreshIfNeeded(session) {
  if (session.expiresAt - Date.now() > 90_000) return session;
  const response = await fetch(`${SUPABASE_URL}/auth/v1/token?grant_type=refresh_token`, {
    method: 'POST',
    headers: { apikey: SUPABASE_PUBLISHABLE_KEY, 'Content-Type': 'application/json' },
    body: JSON.stringify({ refresh_token: session.refreshToken }),
    cache: 'no-store'
  });
  const body = await response.json().catch(() => ({}));
  if (!response.ok || !body.access_token || !body.refresh_token) throw new Error('Phiên đăng nhập đã hết hạn. Hãy mở Game Hub lại từ HIU TMC.');
  return {
    accessToken: body.access_token,
    refreshToken: body.refresh_token,
    expiresAt: Number(body.expires_at || 0) * 1000 || expiryFromToken(body.access_token)
  };
}

async function verifyMember(accessToken) {
  const authResponse = await fetch(`${SUPABASE_URL}/auth/v1/user`, {
    headers: { apikey: SUPABASE_PUBLISHABLE_KEY, Authorization: `Bearer ${accessToken}` },
    cache: 'no-store'
  });
  const authUser = await authResponse.json().catch(() => ({}));
  if (!authResponse.ok || !authUser.id) throw new Error('Không xác minh được phiên thành viên. Hãy đăng nhập lại từ HIU TMC.');

  // app_metadata is issued by the trusted HIU TMC auth service. Do not query
  // club_members directly from the Hub: the existing game database exposes
  // member state through approved server functions, not client table reads.
  const memberId = String(authUser.app_metadata?.member_id || '');
  if (!memberId) throw new Error('Phiên này chưa liên kết hồ sơ HIU TMC. Hãy đăng nhập lại từ HIU TMC.');
  return {
    id: memberId,
    displayName: 'Thành viên HIU TMC',
    role: String(authUser.app_metadata?.role || 'member'),
    avatarUrl: ''
  };
}

export async function bootstrapSession() {
  const bridged = consumeIncomingBridge();
  const session = bridged || readStoredSession();
  if (!session) return { member: null, session: null, error: null };
  try {
    const refreshed = await refreshIfNeeded(session);
    const member = await verifyMember(refreshed.accessToken);
    const complete = { ...refreshed, member };
    saveSession(complete);
    return { member, session: complete, error: null };
  } catch (error) {
    localStorage.removeItem(SESSION_STORAGE_KEY);
    return { member: null, session: null, error: error instanceof Error ? error.message : 'Không thể xác minh phiên HIU TMC.' };
  }
}

export async function logout() {
  const session = readStoredSession();
  localStorage.removeItem(SESSION_STORAGE_KEY);
  if (!session?.accessToken) return;
  await fetch(`${SUPABASE_URL}/auth/v1/logout?scope=local`, {
    method: 'POST',
    headers: { apikey: SUPABASE_PUBLISHABLE_KEY, Authorization: `Bearer ${session.accessToken}` },
    keepalive: true
  }).catch(() => {});
}
