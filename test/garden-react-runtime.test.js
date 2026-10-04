import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

// esbuild is a devDependency. On a machine where the registry blocks it the test is skipped locally,
// but it always runs (and fails if esbuild is missing) in CI, so the check is never silently lost.
let esbuild = null;
try { esbuild = await import('esbuild'); } catch (e) { if (process.env.CI) throw e; }

test('Garden JSX bundle has the React binding required by the configured classic transform', { skip: esbuild ? false : 'esbuild is not installed here (CI installs it)' }, async () => {
  const source = await readFile(new URL('../src/games/garden-continuation.tsx', import.meta.url), 'utf8');
  const compiled = await esbuild.transform(source, { loader: 'tsx', format: 'esm' });

  assert.match(source, /import\s+React\s*,\s*\{[^}]+\}\s*from\s*['"]react['"]/);
  assert.match(compiled.code, /React\.createElement\(/);
});
