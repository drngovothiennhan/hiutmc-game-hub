import test from 'node:test';
import assert from 'node:assert/strict';
import { reportGameHubError, sanitizeReportMessage } from '../src/observability/error-reporting.js';

test('error reports redact session credentials and personal contact details', () => {
  const message = sanitizeReportMessage('Bearer access-secret eyJhbGci.eyJzdWI.abcdef user@example.org');
  assert.doesNotMatch(message, /access-secret|eyJhbGci|user@example.org/);
  assert.match(message, /REDACTED/);
});

test('error report sends only allowlisted context and no stack or session token', async t => {
  const originalFetch = globalThis.fetch;
  let captured;
  globalThis.fetch = async (_url, init) => {
    captured = { init, body: JSON.parse(init.body) };
    return { ok: true, status: 200 };
  };
  t.after(() => { globalThis.fetch = originalFetch; });

  const result = await reportGameHubError(
    { accessToken: 'eyJhbGci.eyJzdWI.abcdef' },
    new Error('request failed'),
    { code: 'garden_rpc_http', area: 'garden', operation: 'herb_garden_state_v3', status: 503, email: 'secret@example.org', token: 'should-not-send' }
  );
  assert.equal(result, true);
  assert.equal(captured.body.p_code, 'garden_rpc_http');
  assert.equal(captured.body.p_message, 'request failed');
  assert.deepEqual(captured.body.p_context, { area: 'garden', operation: 'herb_garden_state_v3', status: '503' });
  assert.doesNotMatch(captured.init.body, /secret@example.org|should-not-send|eyJhbGci/);
  assert.equal(captured.init.headers.authorization, 'Bearer eyJhbGci.eyJzdWI.abcdef');
});
