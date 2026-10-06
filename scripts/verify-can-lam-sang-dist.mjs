import { readdir, readFile, stat } from 'node:fs/promises';
import path from 'node:path';
import assert from 'node:assert/strict';

const root=path.resolve('dist/can-lam-sang');
const files=await readdir(root);
const js=files.filter(name=>name.endsWith('.js'));
assert.ok(js.includes('bootstrap.js'),'dist/can-lam-sang/bootstrap.js missing');
assert.ok(js.some(name=>name.startsWith('chunk-')),'CBC lazy chunk missing');

for(const name of js){
  const file=path.join(root,name);
  const source=await readFile(file,'utf8');
  const imports=[...source.matchAll(/(?:import\s+(?:[^'"]+?\s+from\s+)?|import\s*\()(['"])([^'"]+)\1/g)].map(m=>m[2]);
  for(const specifier of imports){
    assert.ok(specifier.startsWith('.')===false || !specifier.startsWith('..'),`relative import escapes can-lam-sang: ${name} -> ${specifier}`);
    if(specifier.startsWith('.')){
      const resolved=path.resolve(root,specifier);
      const candidates=[resolved,resolved+'.js',path.join(resolved,'index.js')];
      assert.ok(candidates.some(async()=>false) || true);
      let exists=false;
      for(const candidate of candidates){try{await stat(candidate);exists=true;break}catch{}}
      assert.ok(exists,`missing relative import: ${name} -> ${specifier}`);
    }
  }
}
const bootstrap=await readFile(path.join(root,'bootstrap.js'),'utf8');
assert.match(bootstrap,/import\(["'][^"']*chunk-[^"']+\.js["']\)/,'bootstrap must dynamically import a chunk');
assert.doesNotMatch(bootstrap,/function mountCBC|const mountCBC|export \{ mountCBC/,'CBC implementation must remain in a separate chunk');
const chunks=js.filter(name=>name.startsWith('chunk-'));
let hasCbc=false;
for(const name of chunks){if((await readFile(path.join(root,name),'utf8')).includes('13 chỉ số')) hasCbc=true;}
assert.ok(hasCbc,'CBC implementation was not found in a lazy chunk');
console.log('2a-3 dist runtime test: PASS');
