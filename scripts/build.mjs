import { access, cp, mkdir, readFile, rm } from 'node:fs/promises';
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
const worker = await readFile('dist/service-worker.js', 'utf8');
const coreBlock = worker.match(/const CORE = \[([\s\S]*?)\]/)?.[1];
if (!coreBlock) throw new Error('Could not read the service worker precache list.');
const coreAssets = [...coreBlock.matchAll(/'([^']+)'/g)].map(([, asset]) => asset);
await Promise.all(coreAssets.map(async asset => {
  try {
    await access(`dist/${asset.slice(1)}`);
  } catch {
    throw new Error(`PWA precache asset is missing from the production build: ${asset}`);
  }
}));
console.log('Game Hub shell and isolated Garden runtime built to dist/.');