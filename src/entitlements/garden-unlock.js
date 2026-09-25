import { SUPABASE_PUBLISHABLE_KEY, SUPABASE_URL } from '../config.js';

const RPC_URL = `${SUPABASE_URL}/rest/v1/rpc/garden_hub_claim_or_get_receipt_v1`;
const RECEIPT_ID = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
const ALLOWED_REASONS = new Set(['granted', 'already_granted', 'prerequisite_incomplete', 'identity_unlinked']);

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
    if (!response.ok) return { eligible: false, reason: 'unavailable' };

    const payload = await response.json();
    const row = Array.isArray(payload) ? payload[0] : payload;
    if (row?.eligible === true) {
      const value = {
        eligible: true,
        receiptId: row.receipt_id,
        grantedAt: row.granted_at,
        reason: ALLOWED_REASONS.has(row.reason) ? row.reason : 'granted'
      };
      return isVerifiedGardenUnlockReceipt(value)
        ? value
        : { eligible: false, reason: 'unavailable' };
    }
    const reason = ALLOWED_REASONS.has(row?.reason) ? row.reason : 'unavailable';
    return { eligible: false, reason };
  } catch {
    return { eligible: false, reason: 'unavailable' };
  }
}
