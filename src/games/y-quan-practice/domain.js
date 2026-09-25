import { Y_QUAN_CASE } from './case.js';

export const SESSION_STATES = Object.freeze(['WAITING', 'INVITED', 'IN_CONSULTATION', 'COMPLETED', 'CANCELLED', 'DISCONNECTED', 'INTERRUPTED']);
export const DOCTOR_STATES = Object.freeze(['OFFLINE', 'AVAILABLE', 'AWAY', 'IN_CONSULTATION', 'RECOVERING']);
const DOCTOR_NEXT = Object.freeze({
  OFFLINE: ['AVAILABLE'], AVAILABLE: ['OFFLINE', 'AWAY', 'IN_CONSULTATION'],
  AWAY: ['AVAILABLE', 'OFFLINE'], IN_CONSULTATION: ['AVAILABLE', 'RECOVERING', 'OFFLINE'],
  RECOVERING: ['IN_CONSULTATION', 'AVAILABLE', 'OFFLINE']
});
const NEXT = Object.freeze({
  WAITING: ['INVITED', 'CANCELLED'], INVITED: ['IN_CONSULTATION', 'CANCELLED'],
  IN_CONSULTATION: ['COMPLETED', 'DISCONNECTED', 'INTERRUPTED'],
  DISCONNECTED: ['IN_CONSULTATION', 'INTERRUPTED'], COMPLETED: [], CANCELLED: [], INTERRUPTED: []
});

export function transitionDoctorState(state, next) {
  if (!DOCTOR_NEXT[state]?.includes(next)) throw new Error(`Invalid doctor state transition ${state} -> ${next}`);
  return next;
}

export function isPlayableCase(profile = Y_QUAN_CASE) {
  return profile?.status === 'PUBLISHED' && profile.interviewDomains?.length === 10 && profile.patientProfile?.fictional === true;
}

export function transitionSession(session, next, now = new Date()) {
  if (!NEXT[session.state]?.includes(next)) throw new Error(`Invalid transition ${session.state} -> ${next}`);
  const updated = { ...session, state: next, updatedAt: now.toISOString() };
  if (['COMPLETED', 'CANCELLED', 'INTERRUPTED'].includes(next)) updated.completedAt = now.toISOString();
  if (next === 'IN_CONSULTATION') updated.invitationExpiresAt = null;
  return updated;
}

export function expireInvitation(session, now = new Date()) {
  if (session.state !== 'INVITED' || Date.parse(session.invitationExpiresAt || '') > now.getTime()) return session;
  return { ...transitionSession(session, 'CANCELLED', now), credits: 0, ratingStars: null };
}

export function askFromCase(session, questionId, now = new Date()) {
  if (!isPlayableCase() || session.caseId !== Y_QUAN_CASE.caseId || session.caseVersion !== Y_QUAN_CASE.version) throw new Error('Ca mô phỏng không khớp phiên đã ghim.');
  const domain = Y_QUAN_CASE.interviewDomains.find(item => item.questions.some(question => question.questionId === questionId));
  const question = domain?.questions.find(item => item.questionId === questionId);
  if (!question) return { session, answer: 'Thông tin này chưa có trong ca mô phỏng.' };
  const response = question.responses[0];
  const chosenQuestions = session.chosenQuestions.some(item => item.questionId === questionId)
    ? session.chosenQuestions : [...session.chosenQuestions, { domainId: domain.domainId, questionId, askedAt: now.toISOString() }];
  const recordedEvidence = response.evidenceIds.reduce((all, evidenceId, index) => {
    if (!all.some(item => item.evidenceId === evidenceId)) all.push({ evidenceId, domainId: domain.domainId, questionId, tag: response.tags[index] || response.tags[0], weight: response.weight, recordedAt: now.toISOString() });
    return all;
  }, [...session.recordedEvidence]);
  return { session: { ...session, chosenQuestions, recordedEvidence, updatedAt: now.toISOString() }, answer: response.text };
}

export function gradeSession(session) {
  const pattern = Y_QUAN_CASE.diagnosis.rubric[0];
  const normalized = String(session.diagnosisText || '').trim().toLocaleLowerCase('vi');
  const diagnosis = pattern.acceptedTerms.some(term => normalized.includes(term.toLocaleLowerCase('vi'))) ? pattern.points : 0;
  const required = new Map(Y_QUAN_CASE.interviewDomains.flatMap(domain => domain.questions.flatMap(question => question.responses.flatMap(response => response.tags.includes('KEY') ? response.evidenceIds.map(id => [id, response.weight]) : []))));
  const captured = new Set(session.recordedEvidence.filter(item => item.tag === 'KEY').map(item => item.evidenceId));
  const weight = [...required.values()].reduce((sum, value) => sum + value, 0);
  const inquiry = weight ? 25 * [...required].reduce((sum, [id, value]) => sum + (captured.has(id) ? value : 0), 0) / weight : 0;
  const reasoningText = String(session.reasoningText || '').toLocaleLowerCase('vi');
  const reasoning = Y_QUAN_CASE.diagnosis.reasoningRubric.reduce((sum, row) => sum + (row.keywords.some(word => reasoningText.includes(word.toLocaleLowerCase('vi'))) ? row.points : 0), 0);
  const learningPlan = Y_QUAN_CASE.learningPlan.filter(item => session.selectedLearningKeys.includes(item.key)).reduce((sum, item) => sum + item.points, 0);
  const patientRating = session.ratingStars == null ? 5 : Math.max(0, Math.min(5, session.ratingStars)) * 2;
  const parts = { diagnosis, inquiry: Math.round(inquiry * 100) / 100, reasoning, learningPlan, patientRating };
  return { ...parts, total: Math.min(100, Math.round(Object.values(parts).reduce((sum, value) => sum + value, 0) * 100) / 100) };
}

export function starCredits(stars) { return stars == null ? 0 : Math.max(0, Math.min(5, Math.floor(stars))); }
export function leaderboardAverage(ratings) { return ratings.length < 5 ? null : Math.round(ratings.reduce((sum, stars) => sum + (stars ?? 2.5), 0) / ratings.length * 100) / 100; }
