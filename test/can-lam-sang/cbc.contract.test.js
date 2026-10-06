import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import {
  generateScenario,
  convertValue,
  toPublicScenario,
  PROFILES
} from "../../src/can-lam-sang/cbc/generator.mjs";
import { validateInvariants } from "../../src/can-lam-sang/cbc/validator.mjs";
import { classifyScenario, classifyValue } from "../../src/can-lam-sang/cbc/classify.mjs";
import { scoreAnswers } from "../../src/can-lam-sang/cbc/rubric.mjs";
import {
  assertLearnerApproved,
  assertFixtureNeverLearner
} from "../../src/can-lam-sang/cbc/approval-gate.mjs";

const here = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(here, "../..");
const fixtureDir = path.join(repoRoot, "test/fixtures/can-lam-sang/cbc");
const fixture = JSON.parse(
  fs.readFileSync(path.join(fixtureDir, "normal-adult.fixture.json"), "utf8")
);
const tightFixture = JSON.parse(
  fs.readFileSync(path.join(fixtureDir, "r1-r2-bounds.fixture.json"), "utf8")
);
const schemaRoot = path.join(repoRoot, "schemas/can-lam-sang");
const schemas = [
  "cbc-reference.v1.schema.json",
  "cbc-pattern.v1.schema.json",
  "cbc-scenario.v1.schema.json"
].map((name) => JSON.parse(fs.readFileSync(path.join(schemaRoot, name), "utf8")));

function basicSchemaCheck(schema) {
  assert.equal(schema.type, "object");
  assert.equal(schema.additionalProperties, false);
  assert.ok(Array.isArray(schema.required) && schema.required.length > 0);
  assert.ok(schema.properties && typeof schema.properties === "object");
}

function allTextFiles(root) {
  const out = [];
  const stack = [root];

  while (stack.length) {
    const dir = stack.pop();

    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const file = path.join(dir, entry.name);

      if (entry.isDirectory()) {
        stack.push(file);
      } else {
        out.push(file);
      }
    }
  }

  return out;
}

function makeApprovedPattern() {
  return {
    ...fixture,
    pattern_id: "CBC-P01",
    review_status: "DA_DUYET",
    reviewer: "Ths. Ngô Võ Thiện Nhân (sinh viên Y khoa ngành YHCT)",
    approved_at: "2026-10-06",
    approval_ref: "PR-117-CBC-P01",
    reference: {
      resource_id: "R1-R2-APPROVED",
      type: "guideline",
      source: "R1/R2",
      document_name: "CBC reference set",
      agency: "Nguon da duyet",
      year_or_version: "2024",
      citation: "Citation placeholder pending content approval",
      checked_at: "2026-10-06",
      reviewer: "Ths. Ngô Võ Thiện Nhân (sinh viên Y khoa ngành YHCT)",
      approval_status: "DA_DUYET",
      license: "License verified by project owner"
    }
  };
}

test("CBC schemas contain the Step 2a-1 contract fields", () => {
  schemas.forEach(basicSchemaCheck);

  const pattern = schemas.find((schema) => schema.$id.endsWith("cbc-pattern.v1.schema.json"));
  assert.ok(pattern.properties.reviewer);
  assert.ok(pattern.properties.approved_at);
  assert.ok(pattern.properties.approval_ref);
  assert.ok(pattern.properties.reference);
});

test("1000 seeded vectors satisfy interval invariants and differential sum", () => {
  for (let i = 0; i < 1000; i += 1) {
    const scenario = generateScenario({
      pattern: fixture,
      variant: i,
      scenario_id: "fixture-" + i,
      sex: "nam"
    });

    validateInvariants(scenario, "vn_lab");
    validateInvariants(scenario, "conventional");

    const sum = scenario.values.neut
      + scenario.values.lymph
      + scenario.values.mono
      + scenario.values.eos
      + scenario.values.baso;

    assert.equal(Math.round(sum * 10), 1000);
  }
});

test("same seed is identical and variant changes output", () => {
  const first = generateScenario({
    pattern: fixture,
    variant: 17,
    scenario_id: "golden",
    sex: "nam"
  });
  const second = generateScenario({
    pattern: fixture,
    variant: 17,
    scenario_id: "golden",
    sex: "nam"
  });
  const different = generateScenario({
    pattern: fixture,
    variant: 18,
    scenario_id: "golden",
    sex: "nam"
  });

  assert.deepEqual(first, second);
  assert.notDeepEqual(first.values, different.values);
});

test("tight R1/R2 fixture generates 2000 normal variants per sex in both profiles", () => {
  const stats = {};

  for (const sex of ["nam", "nữ"]) {
    let accepted = 0;
    let attemptsTotal = 0;
    let attemptsMax = 0;
    const combinations = new Set();

    for (let variant = 0; variant < 2000; variant += 1) {
      const scenario = generateScenario({
        pattern: tightFixture,
        variant,
        scenario_id: "tight-" + sex + "-" + variant,
        sex
      });

      accepted += 1;
      attemptsTotal += scenario.generation_attempts;
      attemptsMax = Math.max(attemptsMax, scenario.generation_attempts);

      const classification = classifyScenario(
        scenario,
        tightFixture,
        sex
      );

      for (const key of [
        "Hb", "RBC", "Hct", "MCV", "MCH", "MCHC", "WBC", "PLT",
        "neut", "lymph", "mono", "eos", "baso"
      ]) {
        assert.equal(classification[key], "binh_thuong");
        assert.equal(
          scenario.values[key] >= tightFixture.indices[key].ranges[sex].low,
          true
        );
        assert.equal(
          scenario.values[key] <= tightFixture.indices[key].ranges[sex].high,
          true
        );
      }

      const differentialSum =
        scenario.values.neut
        + scenario.values.lymph
        + scenario.values.mono
        + scenario.values.eos
        + scenario.values.baso;

      assert.equal(Math.round(differentialSum * 10), 1000);
      assert.ok(
        scenario.values.mono >= tightFixture.indices.mono.ranges[sex].low
        && scenario.values.mono <= tightFixture.indices.mono.ranges[sex].high
      );
      assert.ok(
        scenario.values.eos >= tightFixture.indices.eos.ranges[sex].low
        && scenario.values.eos <= tightFixture.indices.eos.ranges[sex].high
      );
      assert.ok(
        scenario.values.baso >= tightFixture.indices.baso.ranges[sex].low
        && scenario.values.baso <= tightFixture.indices.baso.ranges[sex].high
      );

      combinations.add(
        [
          scenario.values.mono,
          scenario.values.eos,
          scenario.values.baso
        ].join("|")
      );

      validateInvariants(scenario, "vn_lab");
      validateInvariants(scenario, "conventional");
    }

    stats[sex] = {
      accepted,
      attemptsTotal,
      acceptanceRate: accepted / attemptsTotal,
      attemptsMax,
      uniqueMonoEosBaso: combinations.size
    };

    assert.ok(combinations.size >= 20);
  }

  assert.equal(stats.nam.accepted, 2000);
  assert.equal(stats["nữ"].accepted, 2000);
  assert.ok(stats.nam.acceptanceRate > 0);
  assert.ok(stats["nữ"].acceptanceRate > 0);

  console.log("E1/E7 generation stats:", JSON.stringify(stats));
});

test("classification uses sex-specific ranges", () => {
  const range = fixture.indices.Hb.ranges.nam;

  assert.equal(classifyValue(range.low - 1, range, "nam"), "thap");
  assert.equal(classifyValue(range.high + 1, range, "nam"), "cao");
  assert.equal(classifyValue(range.low, range, "nam"), "binh_thuong");
});

test("rubric derives all 13 classifications from the generated scenario", () => {
  const scenario = generateScenario({
    pattern: fixture,
    variant: 2,
    sex: "nam"
  });

  const result = scoreAnswers(
    fixture,
    scenario,
    {
      classifications: fixture.expected_classifications,
      interpretation: "CBC bình thường người lớn"
    }
  );

  assert.equal(result.score, 1);
  assert.equal(result.total, 14);
  assert.equal(result.earned, 14);
});

test("missing CBC classification is scored wrong, not thrown", () => {
  const scenario = generateScenario({
    pattern: fixture,
    variant: 3,
    sex: "nam"
  });
  const answers = {
    classifications: { Hb: "binh_thuong" },
    interpretation: "CBC bình thường người lớn"
  };

  const result = scoreAnswers(fixture, scenario, answers);

  assert.equal(result.total, 14);
  assert.equal(result.earned, 2);
  assert.equal(result.explanations.find((item) => item.index === "RBC").correct, false);
});

test("public scenario exposes only scenario id, sex, values and display units", () => {
  const scenario = generateScenario({
    pattern: fixture,
    variant: 9,
    scenario_id: "public-9",
    sex: "nam"
  });

  const publicVietnam = toPublicScenario(scenario, "vn_lab");
  const publicConventional = toPublicScenario(scenario, "conventional");
  const serialized = JSON.stringify(publicVietnam);

  assert.equal(publicVietnam.scenario_id, "public-9");
  assert.equal(publicVietnam.sex, "nam");
  assert.ok(!serialized.includes("pattern_id"));
  assert.ok(!serialized.includes("name"));
  assert.ok(!serialized.includes("expected"));
  assert.ok(!serialized.includes("review_status"));
  assert.ok(!serialized.includes("internal_units"));
  assert.ok(!serialized.includes("generation_attempts"));

  for (const key of ["Hb", "RBC", "Hct", "MCV", "MCH", "MCHC", "WBC", "PLT"]) {
    const back = convertValue(
      key,
      publicConventional.values[key].value,
      "conventional",
      "vn_lab"
    );
    assert.ok(Math.abs(back - publicVietnam.values[key].value) < 0.11, key);
  }
});

test("approval gate requires every learner approval condition", () => {
  const approved = makeApprovedPattern();
  assert.equal(assertLearnerApproved(approved), true);

  const missingReviewer = { ...approved, reviewer: undefined };
  assert.throws(
    () => assertLearnerApproved(missingReviewer),
    /reviewer_chua_duoc_uy_quyen/
  );

  const missingDate = { ...approved, approved_at: undefined };
  assert.throws(
    () => assertLearnerApproved(missingDate),
    /approved_at_khong_hop_le/
  );

  const missingRef = { ...approved, approval_ref: undefined };
  assert.throws(
    () => assertLearnerApproved(missingRef),
    /approval_ref_thieu/
  );

  const unapprovedSource = {
    ...approved,
    reference: { ...approved.reference, approval_status: "CHUA_DUYET" }
  };
  assert.throws(
    () => assertLearnerApproved(unapprovedSource),
    /nguon_pattern_chua_du_metadata_A7/
  );

  const missingSourceField = {
    ...approved,
    reference: { ...approved.reference, license: "" }
  };
  assert.throws(
    () => assertLearnerApproved(missingSourceField),
    /nguon_pattern_chua_du_metadata_A7/
  );
});

test("approval gate rejects FIXTURE_ONLY and CHUA_DUYET", () => {
  assert.throws(
    () => assertFixtureNeverLearner(fixture),
    /fixture_only/
  );

  const unapproved = {
    ...fixture,
    pattern_id: "CBC-P01-UNAPPROVED",
    review_status: "CHUA_DUYET"
  };

  assert.throws(
    () => assertFixtureNeverLearner(unapproved),
    /pattern_chua_duyet/
  );
});

test("validator catches one-pg MCH corruption and 99.9 differential in both profiles", () => {
  const scenario = generateScenario({
    pattern: fixture,
    variant: 22,
    sex: "nam"
  });

  for (const profile of ["vn_lab", "conventional"]) {
    const badMch = structuredClone(scenario);
    badMch.display_profiles[profile].MCH.value += 1;
    assert.throws(
      () => validateInvariants(badMch, profile),
      /MCH_interval_failed/
    );

    const badSum = structuredClone(scenario);
    badSum.display_profiles[profile].baso.value -= 0.1;
    assert.throws(
      () => validateInvariants(badSum, profile),
      /differential_sum_failed/
    );
  }
});

test("both unit profiles round-trip every index and missing sex is rejected", () => {
  const values = {
    Hb: 145, RBC: 5.1, Hct: 0.44, MCV: 90, MCH: 28.4, MCHC: 330,
    WBC: 7.2, PLT: 250, neut: 55, lymph: 30, mono: 7, eos: 2, baso: 1
  };

  for (const key of Object.keys(values)) {
    for (const from of Object.keys(PROFILES)) {
      for (const to of Object.keys(PROFILES)) {
        const shown = convertValue(key, values[key], from, to);
        const back = convertValue(key, shown, to, from);
        assert.ok(
          Math.abs(back - values[key]) < 1e-9,
          key + " " + from + "->" + to
        );
      }
    }
  }

  assert.throws(
    () => generateScenario({
      pattern: fixture,
      variant: 1,
      scenario_id: "missing-sex",
      sex: undefined
    }),
    /sex_thieu/
  );
});

test("CBC engine contains no unseeded random or SQL random ordering", () => {
  for (const root of [
    path.join(repoRoot, "src/can-lam-sang/cbc"),
    schemaRoot
  ]) {
    for (const file of allTextFiles(root)) {
      if (!/\.(mjs|json)$/.test(file)) {
        continue;
      }

      const text = fs.readFileSync(file, "utf8");
      assert.doesNotMatch(text, /Math\.random/);
      assert.doesNotMatch(text, /ORDER\s+BY\s+random\s*\(/i);
    }
  }
});

test("CBC public source files use readable multi-line functions", () => {
  for (const file of [
    "generator.mjs",
    "validator.mjs",
    "classify.mjs",
    "rubric.mjs",
    "approval-gate.mjs"
  ]) {
    const text = fs.readFileSync(
      path.join(repoRoot, "src/can-lam-sang/cbc", file),
      "utf8"
    );

    assert.doesNotMatch(text, /function\s+\w+\([^)]*\)\s*\{[^\n]*\}/);
  }
});
