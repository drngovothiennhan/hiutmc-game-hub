#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";
import process from "node:process";
import { generateScenario, toPublicScenario } from "../../src/can-lam-sang/cbc/generator.mjs";
import { classifyScenario } from "../../src/can-lam-sang/cbc/classify.mjs";

const LEVELS = new Set(["co_ban", "trung_binh", "nang_cao"]);
const KEYS = [
  "Hb", "RBC", "Hct", "MCV", "MCH", "MCHC", "WBC", "PLT",
  "neut", "lymph", "mono", "eos", "baso"
];
const CLASSIFICATIONS = new Set(["thap", "binh_thuong", "cao"]);

function usage() {
  console.error("Usage: node 008_cls_cbc_seed_generator.mjs <patterns.json> <output.json> [level] [variants]");
}

function readJson(file) {
  return JSON.parse(fs.readFileSync(path.resolve(file), "utf8"));
}

function requirePattern(pattern) {
  if (!pattern) {
    throw new Error("pattern_required");
  }
  if (!LEVELS.has(pattern.level)) {
    throw new Error("level_khong_hop_le:" + pattern.pattern_id);
  }
}

function buildRow(pattern, level, variant, sex) {
  const scenario = generateScenario({
    pattern,
    variant,
    scenario_id: `${pattern.pattern_id}-${level}-${sex}-${variant}`,
    sex,
    profile: "vn_lab"
  });
  const classifications = classifyScenario(
    scenario,
    pattern,
    sex
  );

  for (const key of KEYS) {
    if (!CLASSIFICATIONS.has(classifications[key])) {
      throw new Error("classification_khong_hop_le:" + key);
    }
  }

  const publicScenario = toPublicScenario(scenario, "vn_lab");
  if (JSON.stringify(publicScenario).includes(pattern.pattern_id)) {
    throw new Error("public_scenario_lo_pattern_id");
  }

  return {
    scenario_key: scenario.scenario_id,
    pattern_id: pattern.pattern_id,
    level,
    variant,
    sex,
    public_scenario: publicScenario,
    answer_key: {
      schema_version: pattern.schema_version,
      classifications
    }
  };
}

const [input, output, requestedLevel = "co_ban", requestedVariants = "10"] = process.argv.slice(2);

if (!input || !output) {
  usage();
  process.exit(2);
}

if (!LEVELS.has(requestedLevel)) {
  throw new Error("level_khong_hop_le:" + requestedLevel);
}

const variantCount = Number(requestedVariants);
if (!Number.isInteger(variantCount) || variantCount < 1 || variantCount > 1000) {
  throw new Error("variants_khong_hop_le");
}

const loaded = readJson(input);
const patterns = Array.isArray(loaded) ? loaded : [loaded];
const rows = [];

for (const pattern of patterns) {
  requirePattern(pattern);
  for (const sex of ["nam", "nữ"]) {
    for (let variant = 0; variant < variantCount; variant += 1) {
      rows.push(buildRow(pattern, requestedLevel, variant, sex));
    }
  }
}

const payload = {
  schema_version: "1.0.0",
  generated_at: new Date().toISOString(),
  rows
};

fs.mkdirSync(path.dirname(path.resolve(output)), { recursive: true });
fs.writeFileSync(
  path.resolve(output),
  JSON.stringify(payload, null, 2) + "\n",
  "utf8"
);
console.log(JSON.stringify({ rows: rows.length, output: path.resolve(output) }));
