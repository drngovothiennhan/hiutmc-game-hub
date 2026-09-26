import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { transform } from 'esbuild';

test('Garden JSX bundle has the React binding required by the configured classic transform', async () => {
  const source = await readFile(new URL('../src/games/garden-continuation.tsx', import.meta.url), 'utf8');
  const compiled = await transform(source, { loader: 'tsx', format: 'esm' });

  assert.match(source, /import\s+React\s*,\s*\{[^}]+\}\s*from\s*['"]react['"]/);
  assert.match(compiled.code, /React\.createElement\(/);
});
