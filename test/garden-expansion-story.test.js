import test from 'node:test';
import assert from 'node:assert/strict';
import { deriveGardenExpansion, isGardenAdminPreview } from '../src/games/garden-expansion-story.js';

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
    allNineOpen: false,
    adminPreview: false,
    previewOnly: false,
    unlockedCount: 8,
    firstHarvests: 8,
    totalPlots: 9,
    surveyComplete: false,
  });
});

test('chapter opens at nine plots and derives survey progress from first harvests', () => {
  assert.deepEqual(deriveGardenExpansion(ninePlots()), {
    available: true,
    allNineOpen: true,
    adminPreview: false,
    previewOnly: false,
    unlockedCount: 9,
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

test('admin preview shows the chapter early without inventing plot unlocks or harvests', () => {
  const plots = ninePlots({ 4: { unlocked: false }, 5: { unlocked: false }, 6: { unlocked: false }, 7: { unlocked: false }, 8: { unlocked: false }, 9: { unlocked: false } });
  const chapter = deriveGardenExpansion(plots, { adminPreview: isGardenAdminPreview('admin') });
  assert.equal(chapter.available, true);
  assert.equal(chapter.previewOnly, true);
  assert.equal(chapter.allNineOpen, false);
  assert.equal(chapter.unlockedCount, 3);
  assert.equal(chapter.firstHarvests, 3);
  assert.equal(chapter.surveyComplete, false);
  assert.equal(plots.filter((plot) => plot.unlocked).length, 3);
});

test('only the verified admin role enables the preview', () => {
  for (const role of ['member', 'moderator', 'super_mod', '', null, undefined]) {
    assert.equal(isGardenAdminPreview(role), false, `${role} must not receive admin preview`);
  }
  assert.equal(isGardenAdminPreview('ADMIN'), true);
  assert.equal(deriveGardenExpansion(ninePlots({ 9: { unlocked: false } }), { adminPreview: false }).available, false);
});
