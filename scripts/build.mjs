import { cp, mkdir, rm } from 'node:fs/promises';
import { build } from 'esbuild';

await rm('dist', { recursive: true, force: true });
await mkdir('dist/assets', { recursive: true });
await cp('index.html', 'dist/index.html');
await cp('manifest.webmanifest', 'dist/manifest.webmanifest');
await cp('service-worker.js', 'dist/service-worker.js');
await cp('public', 'dist', { recursive: true });

// The standalone Y Quán static route imports only these reviewed, versioned
// modules at runtime. Copy the narrow module set it needs; don't expose all src.
await mkdir('dist/src/auth', { recursive: true });
await mkdir('dist/src/games/y-quan-practice', { recursive: true });
await cp('src/auth/roles.js', 'dist/src/auth/roles.js');
await cp('src/games/y-quan-practice/case.js', 'dist/src/games/y-quan-practice/case.js');
await cp('src/games/y-quan-practice/domain.js', 'dist/src/games/y-quan-practice/domain.js');

await build({
  entryPoints: ['src/app.js'],
  bundle: true,
  format: 'esm',
  target: ['es2022'],
  outfile: 'dist/assets/app.js',
  loader: { '.tsx': 'tsx', '.css': 'css' },
  define: { __GAME_HUB_ADMIN_PREVIEW__: JSON.stringify(process.env.GAME_HUB_ADMIN_PREVIEW === 'true') },
  assetNames: 'assets/[name]-[hash]',
  minify: true
});
console.log('Game Hub shell, isolated Y Quán admin preview, and Garden runtime built to dist/.');
