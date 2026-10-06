#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";
import process from "node:process";
import crypto from "node:crypto";
import { generateScenario, toPublicScenario } from "../../../src/can-lam-sang/cbc/generator.mjs";
import { classifyScenario } from "../../../src/can-lam-sang/cbc/classify.mjs";

const LEVELS = new Set(["co_ban", "trung_binh", "nang_cao"]);
const KEYS = [
  "Hb", "RBC", "Hct", "MCV", "MCH", "MCHC", "WBC", "PLT",
  "neut", "lymph", "mono", "eos", "baso"
];
const CLASSIFICATIONS = new Set(["thap", "binh_thuong", "cao"]);

const SCENARIO_SALT = "HIU-TMC-CBC-v1-scenario-salt";
const SQL_TABLE = "can_lam_sang_private.cbc_scenarios";

function usage() {
  console.error("Usage: node 008_cls_cbc_seed_generator.mjs <patterns.json> <output.(json|sql)> [level] [variants] [--sql]");
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

function opaqueScenarioId(scenarioKey) {
  return crypto.createHash("sha256")
    .update(scenarioKey + SCENARIO_SALT, "utf8")
    .digest("hex")
    .slice(0, 12);
}

function buildRow(pattern, level, variant, sex) {
  const scenarioKey = `${pattern.pattern_id}.hash-${level}-${sex}-${variant}`;
  const scenario = generateScenario({
    pattern,
    variant,
    scenario_id: opaqueScenarioId(scenarioKey),
    sex,
    profile: "vn_lab"
  });
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
    scenario_key: scenarioKey,
    pattern_id: pattern.pattern_id,
    level: pattern.level,
    variant,
    sex,
    public_scenario: publicScenario,
    answer_key: {
      schema_version: pattern.schema_version,
      classifications
    }
  };
}

const args = process.argv.slice(2);
const sqlMode = args.includes("--sql");
const cleanArgs = args.filter((arg) => arg !== "--sql");
const [input, output, requestedLevel = "co_ban", requestedVariants = "10"] = cleanArgs;

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
  if (pattern.level !== requestedLevel) continue;
  for (const sex of ["nam", "nữ"]) {
    for (let variant = 0; variant < variantCount; variant += 1) {
      rows.push(buildRow(pattern, requestedLevel, variant, sex));
    }
  }
}

const payload = {
  schema_version: "1.0.0",
  rows
};

function sqlLiteral(value) {
  return "'" + String(value).replaceAll("'", "''") + "'";
}

function sqlJson(value) {
  return sqlLiteral(JSON.stringify(value));
}

function toSql(rowsToWrite) {
  const ordered = [...rowsToWrite].sort((a, b) => a.scenario_key.localeCompare(b.scenario_key));
  const values = ordered.map((row) =>
    "(" + [
      sqlLiteral(row.scenario_key),
      sqlLiteral(row.pattern_id),
      sqlLiteral(row.level),
      row.variant,
      sqlLiteral(row.sex),
      sqlJson(row.public_scenario) + "::jsonb",
      sqlJson(row.answer_key) + "::jsonb"
    ].join(", ") + ")"
  );
  return [
    "begin;",
    "",
    `insert into ${SQL_TABLE} (scenario_key, pattern_id, level, variant, sex, public_scenario, answer_key)`,
    "values",
    values.join(",\n"),
    "on conflict (scenario_key) do nothing;",
    "",
    "commit;",
    ""
  ].join("\n");
}

const outputText = sqlMode ? toSql(rows) : JSON.stringify(payload, null, 2) + "\n";
fs.mkdirSync(path.dirname(path.resolve(output)), { recursive: true });
fs.writeFileSync(path.resolve(output), outputText, "utf8");
console.log(JSON.stringify({ rows: rows.length, output: path.resolve(output), mode: sqlMode ? "sql" : "json" }));

fs.mkdirSync(path.dirname(path.resolve(output)), { recursive: true });
fs.writeFileSync(
  path.resolve(output),
  JSON.stringify(payload, null, 2) + "\n",
  "utf8"
);
console.log(JSON.stringify({ rows: rows.length, output: path.resolve(output) }));
