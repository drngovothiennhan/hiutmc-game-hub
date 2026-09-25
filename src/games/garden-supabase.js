import { SUPABASE_PUBLISHABLE_KEY, SUPABASE_URL } from '../config.js';
import { SESSION_STORAGE_KEY } from '../auth/session.js';

// Reuse the access token already verified by the Game Hub session bootstrap.
// Tokens stay in memory/localStorage and are never included in diagnostics.
function currentAccessToken() {
  try {
    const session = JSON.parse(localStorage.getItem(SESSION_STORAGE_KEY) || 'null');
    return typeof session?.accessToken === 'string' ? session.accessToken : '';
  } catch {
    return '';
  }
}

export const gardenSupabase = {
  async rpc(name, args = {}) {
    const token = currentAccessToken();
    if (!token) return { data: null, error: new Error('Phiên đăng nhập đã hết hạn. Hãy mở Game Hub lại từ HIU TMC.') };
    try {
      const response = await fetch(`${SUPABASE_URL}/rest/v1/rpc/${encodeURIComponent(name)}`, {
        method: 'POST',
        headers: {
          apikey: SUPABASE_PUBLISHABLE_KEY,
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(args),
        cache: 'no-store'
      });
      const data = await response.json().catch(() => null);
      if (!response.ok) return { data: null, error: new Error(data?.message || 'Không thể đồng bộ trạng thái Gia Viên.') };
      return { data, error: null };
    } catch {
      return { data: null, error: new Error('Không thể kết nối để đồng bộ Gia Viên.') };
    }
  }
};
