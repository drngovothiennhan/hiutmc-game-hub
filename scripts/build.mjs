import { cp, mkdir, rm } from 'node:fs/promises';
import { build } from 'esbuild';

await rm('dist', { recursive: true, force: true });
await mkdir('dist/assets', { recursive: true });
await mkdir('dist/src', { recursive: true });
await cp('index.html', 'dist/index.html');
await cp('manifest.webmanifest', 'dist/manifest.webmanifest');
await cp('service-worker.js', 'dist/service-worker.js');
await cp('src/styles.css', 'dist/src/styles.css');
await cp('public', 'dist', { recursive: true });
await build({
  entryPoints: ['src/app.js'],
  bundle: true,
  format: 'esm',
  target: ['es2022'],
  outfile: 'dist/assets/app.js',
  loader: { '.tsx': 'tsx', '.css': 'css' },
  assetNames: 'assets/[name]-[hash]',
  minify: true
});
// Publish each Y Quan entry as one module. A proxy or stale cache must not
// leave an entry page pointing at a missing transitive import.
await build({
  entryPoints: {
    'y-quan-live/game': 'public/y-quan-live/game.js',
    'y-quan-live/interview/app': 'public/y-quan-live/interview/app.js'
  },
  bundle: true,
  format: 'esm',
  target: ['es2022'],
  outdir: 'dist',
  minify: true
});
// Step 2a-3: this is intentionally the final build call. Code splitting keeps
// CBC behind the flag-gated dynamic import while resolving all source imports.
await build({
  entryPoints: ['public/can-lam-sang/bootstrap.js'],
  bundle: true,
  format: 'esm',
  splitting: true,
  outdir: 'dist',
  outbase: 'public',
  entryNames: 'can-lam-sang/[name]',
  chunkNames: 'can-lam-sang/chunk-[name]-[hash]',
  target: ['es2022']
});
await rm('dist/can-lam-sang/cbc.js', { force: true });
await rm('dist/can-lam-sang/core.js', { force: true });
console.log('Game Hub shell, isolated Garden runtime, and CBC draft runtime built to dist/.');
