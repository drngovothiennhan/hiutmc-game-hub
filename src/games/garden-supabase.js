import { SUPABASE_PUBLISHABLE_KEY, SUPABASE_URL } from '../config.js';
import { getValidAccessToken } from '../auth/session.js';
import { reportGameHubError } from '../observability/error-reporting.js';

export const gardenSupabase = {
  async rpc(name, args = {}) {
    const token = await getValidAccessToken();
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
        cache: 'no-store',
        signal: AbortSignal.timeout(15_000)
      });
      const data = await response.json().catch(() => null);
      if (!response.ok) {
        void reportGameHubError({ accessToken: token }, new Error('A Garden gameplay request failed.'), {
          code: 'garden_rpc_http', area: 'garden', operation: name, status: response.status
        });
        const error = new Error(data?.message || 'Không thể đồng bộ trạng thái Gia Viên.');
        // A 5xx can be emitted after the function began processing a write,
        // so its outcome is ambiguous just like a network timeout.
        error.code = response.status >= 500 ? 'GARDEN_RPC_TRANSPORT' : 'GARDEN_RPC_HTTP';
        error.status = response.status;
        return { data: null, error };
      }
      return { data, error: null };
    } catch (cause) {
      void reportGameHubError({ accessToken: token }, new Error('A Garden gameplay request could not reach the server.'), {
        code: 'garden_rpc_network', area: 'garden', operation: name
      });
      const error = new Error('Không thể kết nối để đồng bộ Gia Viên.');
      error.code = 'GARDEN_RPC_TRANSPORT';
      error.cause = cause;
      return { data: null, error };
    }
  }
};
