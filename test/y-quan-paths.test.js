import test from 'node:test';
import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { gameHubBasePath, gameHubPath } from '../public/y-quan-live/paths.js';
import { readFile } from 'node:fs/promises';

test('Y Quan links resolve under both the Pages root and HIU TMC app mount', () => {
  assert.equal(gameHubBasePath('/y-quan-live/interview/'), '/');
  assert.equal(gameHubPath('y-quan-live/', '/y-quan-live/interview/'), '/y-quan-live/');
  assert.equal(gameHubBasePath('/apps/game-hub/y-quan-live/interview/'), '/apps/game-hub/');
  assert.equal(gameHubPath('y-quan-live/', '/apps/game-hub/y-quan-live/interview/'), '/apps/game-hub/y-quan-live/');
});

test('Y Quan entry pages load mount-aware modules and the Thap van back link uses the shared resolver', async () => {
  const [entry, interviewEntry, interview] = await Promise.all([
    readFile(new URL('../public/y-quan-live/index.html', import.meta.url), 'utf8'),
    readFile(new URL('../public/y-quan-live/interview/index.html', import.meta.url), 'utf8'),
    readFile(new URL('../public/y-quan-live/interview/app.js', import.meta.url), 'utf8')
  ]);
  assert.match(entry, /import\(base\+'y-quan-live\/game\.js\?v=20261004\.1'\)/);
  assert.match(interviewEntry, /import\(base\+'y-quan-live\/interview\/app\.js\?v=20261004\.1'\)/);
  assert.match(interview, /href="\$\{gameHubPath\('y-quan-live\/'\)\}\?v=\$\{Y_QUAN_ROUTE_VERSION\}"/);
  assert.doesNotMatch(interview, /href="\/y-quan-live\//);
});

test('Y Quan browser modules parse before deployment', () => {
  for (const path of ['public/y-quan-live/game.js', 'public/y-quan-live/interview/app.js']) {
    execFileSync(process.execPath, ['--check', path], { stdio: 'pipe' });
  }
});
