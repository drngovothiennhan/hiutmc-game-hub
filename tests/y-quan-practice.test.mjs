import test from 'node:test';
import { readFile } from 'node:fs/promises';
import assert from 'node:assert/strict';
import { Y_QUAN_CASE } from '../src/games/y-quan-practice/case.js';
import { askFromCase, expireInvitation, gradeSession, isPlayableCase, leaderboardAverage, starCredits, transitionDoctorState, transitionSession } from '../src/games/y-quan-practice/domain.js';
import { renderWorldMap } from '../src/components/world-map.js';

const at = new Date('2026-09-25T10:00:00.000Z');
function session(overrides = {}) {
  return {
    sessionId: 'test-session', doctorId: 'admin-1', patientLabel: 'Nhân vật mô phỏng',
    caseId: Y_QUAN_CASE.caseId, caseVersion: Y_QUAN_CASE.version, state: 'IN_CONSULTATION',
    doctorState: 'IN_CONSULTATION', chosenQuestions: [], recordedEvidence: [], selectedLearningKeys: [],
    diagnosisText: '', reasoningText: '', ratingStars: null, credits: 0,
    createdAt: at.toISOString(), updatedAt: at.toISOString(), invitationExpiresAt: null,
    completedAt: null, ...overrides
  };
}

test('only a published, fictional 10-domain case passes playability guard', () => {
  assert.equal(isPlayableCase(), true);
  assert.equal(isPlayableCase({ ...Y_QUAN_CASE, status: 'DRAFT' }), false);
  assert.equal(isPlayableCase({ ...Y_QUAN_CASE, interviewDomains: [] }), false);
  assert.equal(isPlayableCase({ ...Y_QUAN_CASE, patientProfile: { fictional: false } }), false);
  assert.equal(Y_QUAN_CASE.interviewDomains.length, 10);
});

test('a question outside the case receives the neutral fixed response', () => {
  const result = askFromCase(session(), 'free-form-not-in-bank', at);
  assert.equal(result.answer, 'Thông tin này chưa có trong ca mô phỏng.');
  assert.deepEqual(result.session.chosenQuestions, []);
  assert.deepEqual(result.session.recordedEvidence, []);
});

test('recovery retains all gathered evidence and question timestamps', () => {
  const asked = askFromCase(session(), 'q-cold-01', at).session;
  const disconnected = transitionSession(asked, 'DISCONNECTED', new Date(at.getTime() + 5000));
  const resumed = transitionSession(disconnected, 'IN_CONSULTATION', new Date(at.getTime() + 8000));
  assert.deepEqual(resumed.recordedEvidence, asked.recordedEvidence);
  assert.deepEqual(resumed.chosenQuestions, asked.chosenQuestions);
  assert.equal(resumed.doctorState, 'IN_CONSULTATION');
});

test('unanswered invitation expires without awarding or deducting credits', () => {
  const invited = session({ state: 'INVITED', doctorState: 'AVAILABLE', invitationExpiresAt: at.toISOString(), credits: 0 });
  const expired = expireInvitation(invited, new Date(at.getTime() + 60_000));
  assert.equal(expired.state, 'CANCELLED');
  assert.equal(expired.credits, 0);
  assert.equal(expired.recordedEvidence.length, 0);
});

test('full rubric scores exactly 100; speed is not part of scoring', () => {
  let full = session({ diagnosisText: 'Thận dương hư', reasoningText: 'Sợ lạnh, thích ấm, đau thắt lưng gối, tiểu trong lượng nhiều', selectedLearningKeys: Y_QUAN_CASE.learningPlan.map(x => x.key), ratingStars: 5 });
  for (const domain of Y_QUAN_CASE.interviewDomains) {
    full = askFromCase(full, domain.questions[0].questionId, at).session;
  }
  const score = gradeSession(full);
  assert.deepEqual([score.diagnosis, score.inquiry, score.reasoning, score.learningPlan, score.patientRating, score.total], [35, 25, 20, 10, 10, 100]);
  assert.equal(gradeSession({ ...full, playbackSpeed: 0.5 }).total, score.total);
});

test('stars convert to at most five credits; leaderboard waits for five completed cases', () => {
  assert.equal(starCredits(1), 1);
  assert.equal(starCredits(5), 5);
  assert.equal(starCredits(7), 5);
  assert.equal(leaderboardAverage([5, 4, 3, 5]), null);
  assert.equal(leaderboardAverage([5, 4, 3, 5, 3]), 4);
});

test('the patient fixture contains fictional, non-identifying fields and no prescription plan', () => {
  const profile = Y_QUAN_CASE.patientProfile;
  assert.equal(profile.fictional, true);
  assert.deepEqual(Object.keys(profile).sort(), ['ageBand', 'context', 'displayName', 'fictional']);
  assert.doesNotMatch(JSON.stringify(profile), /@|\+?\d[\d ()-]{7,}/);
  assert.equal(Y_QUAN_CASE.learningPlan.some(item => /thuốc|liều|kê đơn|prescription/i.test(item.label)), false);
  assert.equal(Y_QUAN_CASE.feedback.learningNote.includes('cần giảng viên'), true);
});

test('Y Quan demo is available from the Hub without signing in', () => {
  const html = renderWorldMap(null, null, false, null);
  assert.match(html, /data-place-id="y-quan-demo"/);
  assert.ok(html.includes('href="/y-quan-practice/">Mở bản demo'));
  assert.match(html, /Không cần đăng nhập/);
});
test('doctor presence transitions are explicit and reject impossible jumps', () => {
  assert.equal(transitionDoctorState('OFFLINE', 'AVAILABLE'), 'AVAILABLE');
  assert.equal(transitionDoctorState('AVAILABLE', 'AWAY'), 'AWAY');
  assert.equal(transitionDoctorState('AVAILABLE', 'IN_CONSULTATION'), 'IN_CONSULTATION');
  assert.equal(transitionDoctorState('IN_CONSULTATION', 'RECOVERING'), 'RECOVERING');
  assert.equal(transitionDoctorState('RECOVERING', 'IN_CONSULTATION'), 'IN_CONSULTATION');
  assert.throws(() => transitionDoctorState('OFFLINE', 'IN_CONSULTATION'), /Invalid doctor state transition/);
});


test('Y Quan clinic scene is included in the lobby, consultation, and offline cache', async () => {
  const [app, serviceWorker, image] = await Promise.all([
    readFile(new URL('../public/y-quan-practice/app.js', import.meta.url), 'utf8'),
    readFile(new URL('../service-worker.js', import.meta.url), 'utf8'),
    readFile(new URL('../public/assets/y-quan-clinic-room.webp', import.meta.url))
  ]);
  assert.ok(app.includes('/assets/y-quan-clinic-room.webp'));
  assert.match(app, /yq-clinic-scene/);
  assert.match(app, /yq-room-banner/);
  assert.match(serviceWorker, /hiutmc-game-hub-shell-v4/);
  assert.ok(serviceWorker.includes('/assets/y-quan-clinic-room.webp'));
  assert.equal(image.subarray(0, 4).toString(), 'RIFF');
  assert.equal(image.subarray(8, 12).toString(), 'WEBP');
});
