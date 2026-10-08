import { readdir, readFile, stat } from 'node:fs/promises';
import path from 'node:path';
import assert from 'node:assert/strict';

const root=path.resolve('dist/can-lam-sang');
const files=await readdir(root);
const js=files.filter(name=>name.endsWith('.js'));
assert.ok(js.includes('bootstrap.js'),'dist/can-lam-sang/bootstrap.js missing');
assert.ok(js.some(name=>name.startsWith('chunk-')),'lazy chunk missing');

for(const name of js){
  const file=path.join(root,name);
  const source=await readFile(file,'utf8');
  const imports=[...source.matchAll(/(?:import\s+(?:[^'"]+?\s+from\s+)?|import\s*\()(['"])([^'"]+)\1/g)].map(m=>m[2]);
  for(const specifier of imports){
    assert.ok(specifier.startsWith('.')===false || !specifier.startsWith('..'),`relative import escapes can-lam-sang: ${name} -> ${specifier}`);
    if(specifier.startsWith('.')){
      const resolved=path.resolve(root,specifier);
      const candidates=[resolved,resolved+'.js',path.join(resolved,'index.js')];
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
let hasCbc=false,hasCore=false;
for(const name of chunks){
  const source=await readFile(path.join(root,name),'utf8');
  if(source.includes('mountCBC')) hasCbc=true;
  if(source.includes('mountCore')) hasCore=true;
}
assert.ok(hasCbc,'CBC implementation was not found in a lazy chunk');
assert.ok(hasCore,'core case implementation was not found in a lazy chunk');
assert.doesNotMatch(bootstrap,/answer_key|diagnosis_options|action_options/,'bootstrap must not embed answer-key structures');
// Runtime-computed imports such as import(prefix + '/src/...') are not bundled and
// are not shipped in dist, so the room loads but every module fetch falls back to HTML.
for(const name of js){
  const source=await readFile(path.join(root,name),'utf8');
  assert.doesNotMatch(source,/['"`]\/src\/can-lam-sang\//,`dist must not load source modules at runtime: ${name}`);
  assert.doesNotMatch(source,/__HIUTMC_APP_PREFIX/,`dist must not compute import paths at runtime: ${name}`);
}
let cbcSource='',coreSource='';
for(const name of chunks){
  const source=await readFile(path.join(root,name),'utf8');
  if(source.includes('mountCBC')) cbcSource=source;
  if(source.includes('mountCore')) coreSource=source;
}
for(const needle of ['INDICES','convertProfileValue','profileUnit']) assert.ok(cbcSource.includes(needle),`CBC chunk must bundle ${needle}`);
for(const needle of ['diagnosisGroups','buildAnswers','toggleSelected']) assert.ok(coreSource.includes(needle),`core chunk must bundle ${needle}`);
console.log('Step 3 dist runtime test: PASS');
