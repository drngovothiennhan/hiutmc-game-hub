import test from 'node:test';
import assert from 'node:assert/strict';
import { deriveGardenExpansion } from '../src/games/garden-expansion-story.js';

const ninePlots = (overrides = {}) => Array.from({ length: 9 }, (_, index) => ({
  slot_no: index + 1,
  unlocked: true,
  harvest_count: index < 8 ? 1 : 0,
  ...overrides[index + 1],
}));

test('expansion chapter stays hidden until all nine server plot rows are unlocked', () => {
  const plots = ninePlots({ 9: { unlocked: false } });
  assert.deepEqual(deriveGardenExpansion(plots), {
    available: false,
    firstHarvests: 0,
    totalPlots: 9,
    surveyComplete: false,
  });
});

test('chapter opens at nine plots and derives survey progress from first harvests', () => {
  assert.deepEqual(deriveGardenExpansion(ninePlots()), {
    available: true,
    firstHarvests: 8,
    totalPlots: 9,
    surveyComplete: false,
  });
});

test('survey completes only after every opened plot has a recorded harvest', () => {
  assert.equal(deriveGardenExpansion(ninePlots({ 9: { harvest_count: 1 } })).surveyComplete, true);
});

test('duplicate or missing plot slots cannot fake the nine-plot gate', () => {
  const duplicateSlot = ninePlots();
  duplicateSlot[8] = { ...duplicateSlot[8], slot_no: 8 };
  assert.equal(deriveGardenExpansion(duplicateSlot).available, false);
});
