import { questions } from './data.js';

export function seededRandom(seed) {
  let state = seed >>> 0;
  return () => ((state = (1664525 * state + 1013904223) >>> 0) / 4294967296);
}

export function createQuestionPlan(seed) {
  const random = seededRandom(seed);
  const core = questions.filter(question => question.primary);
  const extra = questions.filter(question => !question.primary);
  const shuffled = [...extra];
  for (let i = shuffled.length - 1; i > 0; i--) {
    const j = Math.floor(random() * (i + 1));
    [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
  }
  const plan = [...core, ...shuffled.slice(0, 5)];
  for (let i = plan.length - 1; i > 0; i--) {
    const j = Math.floor(random() * (i + 1));
    [plan[i], plan[j]] = [plan[j], plan[i]];
  }
  return plan;
}

const overlap = (a, b) => {
  const right = new Set(b);
  return a.filter(value => right.has(value)).length;
};
export function scoreAttempt({ asked, captured, selectedB8C, selectedPattern, selectedPrinciple, caseFile }) {
  const categoryCoverage = new Set(asked.map(q => q.category)).size / 10;
  const pertinence = asked.filter(q => q.primary || q.tags?.some(tag => caseFile.keyFindings.includes(tag))).length / Math.max(asked.length, 1);
  const capture = overlap(captured, caseFile.keyFindings) / Math.max(caseFile.keyFindings.length, 1);
  const b8c = overlap(selectedB8C, caseFile.b8c) / 3;
  const pattern = selectedPattern === caseFile.id ? 1 : 0;
  const principle = caseFile.principles.includes(selectedPrinciple) ? 1 : 0;
  return Math.round(35 * (0.65 * categoryCoverage + 0.35 * pertinence) + 20 * capture + 20 * b8c + 15 * pattern + 10 * principle);
}
