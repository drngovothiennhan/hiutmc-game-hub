import test from 'node:test';
import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';

const targets = [
  ['vien-thuc-hanh', 'https://hiutmc.com/apps/game-hub/vien-thuc-hanh/'],
  ['phong-hoc', 'https://hiutmc.com/apps/game-hub/phong-hoc/'],
  ['tu-chan', 'https://hiutmc.com/apps/game-hub/tu-chan/']
];

test('temporary live smoke: three production routes return HTTP 200', async () => {
  for (const [name, url] of targets) {
    const response = await fetch(url, {
      redirect: 'follow',
      headers: { 'user-agent': 'HIU-TMC-step1A-smoke/1.0' }
    });
    const bytes = Buffer.from(await response.arrayBuffer());
    const sha256 = createHash('sha256').update(bytes).digest('hex');
    console.log(JSON.stringify({
      smoke: name,
      requested_url: url,
      final_url: response.url,
      status: response.status,
      bytes: bytes.length,
      sha256
    }));
    assert.equal(response.status, 200, `${name}: expected HTTP 200`);
  }
});
