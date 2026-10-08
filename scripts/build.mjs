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
console.log('Game Hub shell and isolated Garden runtime built to dist/.');
