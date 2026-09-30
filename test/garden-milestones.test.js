import test from 'node:test';
import assert from 'node:assert/strict';
import { normalizeMilestones, summarizeJourney, describeClaim } from '../src/games/garden-milestones.js';

const row = (key, chapter, sort, status, o = {}) => ({ milestone_key: key, chapter, sort_no: sort, title: key, description: '', target: 3, progress: 1, reward_credits: 5, reward_seeds: 1, status, claimed_at: null, ...o });

test('normalize rejects malformed server replies', () => {
  assert.equal(normalizeMilestones(null), null);
  assert.equal(normalizeMilestones([row('a', 3, 1, 'locked')]), null);
  assert.equal(normalizeMilestones([row('a', 1, 1, 'weird')]), null);
  assert.equal(normalizeMilestones([row('a', 1, 1, 'locked', { target: 0 })]), null);
});

test('normalize clamps progress and sorts', () => {
  const items = normalizeMilestones([row('b', 1, 2, 'locked', { progress: 99 }), row('a', 1, 1, 'locked', { progress: -2 })]);
  assert.deepEqual(items.map((i) => i.key), ['a', 'b']);
  assert.equal(items[1].progress, 3);
  assert.equal(items[0].progress, 0);
});

test('journey totals per chapter and reaches chapter 2 via c1_open_9', () => {
  const items = normalizeMilestones([
    row('c1_first_harvest', 1, 1, 'claimed', { reward_seeds: 0 }),
    row('c1_open_9', 1, 2, 'claimable', { reward_credits: 15, reward_seeds: 2 }),
    row('c2_zone_pond', 2, 3, 'locked', { reward_credits: 10, reward_seeds: 0 }),
  ]);
  const j = summarizeJourney(items);
  assert.equal(j.chapters[0].claimed, 1);
  assert.equal(j.chapters[0].creditsTotal, 20);
  assert.equal(j.chapters[0].creditsEarned, 5);
  assert.equal(j.chapters[1].complete, false);
  assert.equal(j.claimableCount, 1);
  assert.equal(j.next.key, 'c1_open_9');
  assert.equal(j.chapter2Reached, true);
});

test('next milestone falls back to in-progress and null when all claimed', () => {
  const j = summarizeJourney(normalizeMilestones([row('a', 1, 1, 'claimed'), row('b', 2, 2, 'in_progress')]));
  assert.equal(j.next.key, 'b');
  assert.equal(summarizeJourney(normalizeMilestones([row('a', 1, 1, 'claimed')])).next, null);
  assert.equal(summarizeJourney([]).chapter2Reached, false);
});

test('claim message uses server-confirmed numbers only', () => {
  assert.match(describeClaim({ applied: true, title: 'X', credits_reward: 5, seed_reward: 1, wallet_balance: 12 }), /\+5 tín dụng và \+1 hạt giống.*12/);
  assert.match(describeClaim({ applied: true, title: 'X', credits_reward: 5, seed_reward: 0, wallet_balance: 5 }), /^X: \+5 tín dụng\./);
  assert.match(describeClaim({ applied: false }), /đã được nhận/);
  assert.match(describeClaim(null), /không xác nhận/);
});
