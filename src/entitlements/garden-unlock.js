import { SUPABASE_PUBLISHABLE_KEY, SUPABASE_URL } from '../config.js';
import { reportGameHubError } from '../observability/error-reporting.js';

const RPC_URL = `${SUPABASE_URL}/rest/v1/rpc/garden_hub_claim_or_get_receipt_v1`;
const RECEIPT_ID = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
const ALLOWED_REASONS = new Set(['granted', 'already_granted', 'identity_unlinked']);

export function isVerifiedGardenUnlockReceipt(value) {
  return value?.eligible === true
    && typeof value.receiptId === 'string'
    && RECEIPT_ID.test(value.receiptId)
    && Number.isFinite(Date.parse(value.grantedAt));
}

export async function claimOrGetGardenUnlockReceipt(session) {
  if (!session?.accessToken) return { eligible: false, reason: 'identity_unlinked' };

  try {
    const response = await fetch(RPC_URL, {
      method: 'POST',
      headers: {
        apikey: SUPABASE_PUBLISHABLE_KEY,
        authorization: `Bearer ${session.accessToken}`,
        'content-type': 'application/json',
        accept: 'application/json'
      },
      body: '{}',
      cache: 'no-store'
    });
    if (!response.ok) {
      void reportGameHubError(session, new Error('Garden beta verification request failed.'), {
        code: 'beta_receipt_http', area: 'access', operation: 'garden_hub_claim_or_get_receipt_v1', status: response.status
      });
      return { eligible: false, reason: 'unavailable' };
    }

    const payload = await response.json();
    const row = Array.isArray(payload) ? payload[0] : payload;
    if (row?.eligible === true) {
      const value = {
        eligible: true,
        receiptId: row.receipt_id,
        grantedAt: row.granted_at,
        reason: ALLOWED_REASONS.has(row.reason) ? row.reason : 'granted'
      };
      if (isVerifiedGardenUnlockReceipt(value)) return value;
      void reportGameHubError(session, new Error('Garden beta verification returned an invalid receipt.'), {
        code: 'beta_receipt_invalid', area: 'access', operation: 'garden_hub_claim_or_get_receipt_v1'
      });
      return { eligible: false, reason: 'unavailable' };
    }
    const reason = ALLOWED_REASONS.has(row?.reason) ? row.reason : 'unavailable';
    if (reason === 'unavailable') {
      void reportGameHubError(session, new Error('Garden beta verification returned an unexpected response.'), {
        code: 'beta_receipt_response', area: 'access', operation: 'garden_hub_claim_or_get_receipt_v1'
      });
    }
    return { eligible: false, reason };
  } catch {
    void reportGameHubError(session, new Error('Garden beta verification could not reach the server.'), {
      code: 'beta_receipt_network', area: 'access', operation: 'garden_hub_claim_or_get_receipt_v1'
    });
    return { eligible: false, reason: 'unavailable' };
  }
}
