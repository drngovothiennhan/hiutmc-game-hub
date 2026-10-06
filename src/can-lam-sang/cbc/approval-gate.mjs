export const LEARNER_APPROVED_STATUS = "DA_DUYET";

export function assertLearnerApproved(pattern) {
  if (!pattern || pattern.review_status !== LEARNER_APPROVED_STATUS) {
    throw new Error("pattern_chua_duyet");
  }
  return true;
}

export function assertFixtureNeverLearner(pattern) {
  if (pattern?.review_status === "FIXTURE_ONLY" || String(pattern?.pattern_id || "").startsWith("FIXTURE-")) {
    throw new Error("fixture_only");
  }
  return assertLearnerApproved(pattern);
}
