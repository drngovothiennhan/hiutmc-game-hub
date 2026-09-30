import test from 'node:test';
import assert from 'node:assert/strict';
import { deriveSurveyMap, sceneTimeOfDay, deriveHerbarium, surveyPlotState } from '../src/games/garden-expansion-survey.js';

const nine = (o = {}) => Array.from({ length: 9 }, (_, i) => ({ slot_no: i + 1, unlocked: true, harvest_count: 0, ...o[i + 1] }));

test('plot state comes only from server fields', () => {
  assert.equal(surveyPlotState(undefined), 'locked');
  assert.equal(surveyPlotState({ unlocked: false, harvest_count: 5 }), 'locked');
  assert.equal(surveyPlotState({ unlocked: true, harvest_count: 2 }), 'surveyed');
  assert.equal(surveyPlotState({ unlocked: true, harvest_count: 0, ready_for_harvest: true }), 'ready');
  assert.equal(surveyPlotState({ unlocked: true, harvest_count: 0, id: 'x', status: 'growing' }), 'growing');
  assert.equal(surveyPlotState({ unlocked: true, harvest_count: 0 }), 'open');
});

test('zones advance in order and only one is active', () => {
  const map = deriveSurveyMap(nine({ 1: { harvest_count: 1 }, 2: { harvest_count: 1 }, 3: { harvest_count: 1 }, 4: { harvest_count: 1 } }));
  assert.deepEqual(map.zones.map((z) => z.status), ['complete', 'active', 'pending']);
  assert.equal(map.surveyedTotal, 4);
  assert.equal(map.activeZoneId, 'path');
});

test('next plot prefers ready, then growing, then empty', () => {
  const map = deriveSurveyMap(nine({ 2: { id: 'a', status: 'growing' }, 5: { ready_for_harvest: true }, 1: { harvest_count: 1 } }));
  assert.equal(map.nextPlot.slot, 5);
  assert.equal(map.nextPlot.state, 'ready');
  const growingOnly = deriveSurveyMap(nine({ 2: { id: 'a', status: 'growing' } }));
  assert.equal(growingOnly.nextPlot.slot, 2);
  assert.equal(deriveSurveyMap(nine({ 1: { harvest_count: 1 }, 2: { harvest_count: 1 }, 3: { harvest_count: 1 }, 4: { harvest_count: 1 }, 5: { harvest_count: 1 }, 6: { harvest_count: 1 }, 7: { harvest_count: 1 }, 8: { harvest_count: 1 }, 9: { harvest_count: 1 } })).nextPlot, null);
});

test('completed survey leaves no active zone', () => {
  const all = nine(Object.fromEntries([1, 2, 3, 4, 5, 6, 7, 8, 9].map((s) => [s, { harvest_count: 1 }])));
  const map = deriveSurveyMap(all);
  assert.equal(map.activeZoneId, null);
  assert.ok(map.zones.every((z) => z.complete));
});

test('time of day buckets and invalid hours', () => {
  assert.equal(sceneTimeOfDay(6), 'dawn');
  assert.equal(sceneTimeOfDay(12), 'day');
  assert.equal(sceneTimeOfDay(18), 'dusk');
  assert.equal(sceneTimeOfDay(23), 'night');
  assert.equal(sceneTimeOfDay(2), 'night');
  assert.equal(sceneTimeOfDay(NaN), 'day');
});

test('herbarium lists distinct harvested species only', () => {
  const list = deriveHerbarium([
    { seed_key: 'b', name: 'Bạc hà', botanical_name: 'Mentha', quantity: 2 },
    { seed_key: 'a', name: 'Actiso', botanical_name: 'Cynara', quantity: 1 },
    { seed_key: 'b', name: 'Bạc hà', botanical_name: 'Mentha', quantity: 9 },
    { seed_key: 'c', name: 'Cúc', botanical_name: 'Chrysanthemum', quantity: 0 },
  ]);
  assert.deepEqual(list.map((x) => x.key), ['a', 'b']);
});
