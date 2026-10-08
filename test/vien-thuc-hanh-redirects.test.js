import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile, readdir, stat } from 'node:fs/promises';

const read = path => readFile(new URL(path, import.meta.url), 'utf8');

// Từ 08/10/2026 Viện Thực Hành nằm ở hiutmc-ecosystem (hiutmc.com/apps/vienthuchanh/). Game Hub chỉ giữ
// trang chuyển hướng để link cũ vẫn mở đúng phòng, và không còn mã, ảnh hay ngân hàng ca của Viện.
const MOVED = { 'vien-thuc-hanh': '', 'phong-hoc': 'phong-hoc/', 'tu-chan': 'truc/', 'can-lam-sang': 'can-lam-sang/' };

test('old Vien routes are tiny redirects that keep the query string', async () => {
  for (const [old, target] of Object.entries(MOVED)) {
    const dir = new URL(`../public/${old}/`, import.meta.url);
    assert.deepEqual(await readdir(dir), ['index.html'], `${old} must hold only the redirect page`);
    const html = await read(`../public/${old}/index.html`);
    const url = `https://hiutmc.com/apps/vienthuchanh/${target}`;
    assert.ok(html.includes(`location.replace("${url}"+location.search+location.hash)`), `${old} keeps ?muc / ?arena`);
    assert.ok(html.includes(`content="0;url=${url}"`), `${old} works without JavaScript`);
    assert.match(html, /name="robots" content="noindex"/);
    assert.ok((await stat(new URL(`../public/${old}/index.html`, import.meta.url))).size < 2000);
  }
});

test('Game Hub no longer builds, caches or lists Vien rooms', async () => {
  assert.doesNotMatch(await read('../scripts/build.mjs'), /can-lam-sang/);
  assert.doesNotMatch(await read('../service-worker.js'), /tu-chan|phong-hoc|vien-thuc-hanh|can-lam-sang/);
  assert.doesNotMatch(await read('../src/data/world-map.js'), /can-lam-sang|four-diagnosis/);
});

test('HIU Y Quan still owns personalization and sends doctors to Truc at its new home', async () => {
  const yq = await read('../public/y-quan-live/game.js');
  assert.match(yq, /tu_chan_personalize_v1/, 'personalization lives in HIU Y Quan (Game Hub)');
  assert.match(yq, /tu_chan_personal_v1/);
  assert.ok(yq.includes('href="https://hiutmc.com/apps/vienthuchanh/truc/"'), 'absolute URL so the Eco proxy does not prefix it');
  for (const f of ['doctor-male', 'doctor-female']) assert.ok((await stat(new URL(`../public/y-quan-live/art/${f}.webp`, import.meta.url))).size > 3000);
});
