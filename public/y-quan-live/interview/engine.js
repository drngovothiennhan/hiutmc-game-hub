import { questions } from './data.js';

export function seededRandom(seed) {
  let state = seed >>> 0;
  return () => ((state = (1664525 * state + 1013904223) >>> 0) / 4294967296);
}

export function createQuestionPlan(seed) {
  const random = seededRandom(seed);
  const categories = [...new Set(questions.map(question => question.category))];
  const plan = categories.map(category => {
    const choices = questions.filter(question => question.category === category);
    return choices[Math.floor(random() * choices.length)];
  });
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
  const coverage = new Set(asked.map(q => q.category)).size / 10;
  const capture = overlap(captured, caseFile.keyFindings) / Math.max(caseFile.keyFindings.length, 1);
  const b8c = overlap(selectedB8C, caseFile.b8c) / Math.max(caseFile.b8c.length, 1);
  const diagnosis = selectedPattern === caseFile.id ? 1 : 0;
  const principle = caseFile.principles.includes(selectedPrinciple) ? 1 : 0;
  return Math.round(20 * coverage + 20 * capture + 20 * b8c + 30 * diagnosis + 10 * principle);
}

export function starsForScore(score) {
  if (score >= 90) return 5;
  if (score >= 80) return 4;
  if (score >= 65) return 3;
  if (score >= 50) return 2;
  return 1;
}
