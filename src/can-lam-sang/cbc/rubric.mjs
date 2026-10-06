export function scoreAnswers(pattern, scenario, answers) {
  if (!pattern || !scenario || !answers) throw new TypeError("pattern_scenario_answers_required");
  const expected = pattern.expected_classifications;
  if (!expected || typeof expected !== "object") throw new Error("rubric_chua_cau_hinh");
  let total = 0, earned = 0;
  const explanations = [];
  for (const [key, expectedValue] of Object.entries(expected)) {
    total += 1;
    const got = answers.classifications?.[key];
    if (got === expectedValue) {
      earned += 1;
      explanations.push({index:key,correct:true,expected:expectedValue});
    } else {
      explanations.push({index:key,correct:false,expected:expectedValue,received:got ?? null});
    }
  }
  const interpretationOk = Array.isArray(pattern.accepted_interpretations)
    ? pattern.accepted_interpretations.includes(answers.interpretation)
    : false;
  if (Array.isArray(pattern.accepted_interpretations) && pattern.accepted_interpretations.length) {
    total += 1;
    if (interpretationOk) earned += 1;
    explanations.push({index:"interpretation",correct:interpretationOk,expected:pattern.accepted_interpretations});
  }
  return {score: total ? earned / total : 0, earned, total, explanations};
}
