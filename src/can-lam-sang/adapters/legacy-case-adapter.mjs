const PUBLIC_SCHEMA_VERSION = '1.0.0';
const ANSWER_SCHEMA_VERSION = '1.0.0';
const RESOURCE_SCHEMA_VERSION = '1.0.0';
const LEGACY_REVIEW_STATUS = 'CHUA_DUYET';

const SOURCE_TYPE = Object.freeze({
  pubmed: 'article',
  huong_dan_web: 'guideline',
  van_ban_byt: 'regulation',
  sach_giao_trinh: 'textbook'
});

const safeText = value => value == null ? '' : String(value);

function requireLegacyCase(input) {
  if (!input || typeof input !== 'object' || Array.isArray(input)) throw new TypeError('legacy case must be an object');
  if (!/^[a-z0-9][a-z0-9-]{2,80}$/.test(safeText(input.id))) throw new TypeError('legacy case id invalid');
  return input;
}

function normalizeId(value) {
  const x = safeText(value).toLowerCase().replace(/[^a-z0-9._-]+/g, '-').replace(/^-+|-+$/g, '');
  return x || 'unknown';
}

function sourceFor(caseId, sourceText, verification, index) {
  const source = verification?.url
    || (verification?.pmid ? `https://pubmed.ncbi.nlm.nih.gov/${verification.pmid}/` : '')
    || sourceText
    || `legacy:${caseId}:${index}`;
  const id = verification?.id ? `legacy-${normalizeId(verification.id)}` : `legacy-${normalizeId(caseId)}-${index + 1}`;
  return {
    schema_version: RESOURCE_SCHEMA_VERSION,
    resource_id: id,
    resource_type: SOURCE_TYPE[verification?.loai] || 'other',
    source,
    title: sourceText || id,
    organization: null,
    year_version: null,
    citation: sourceText || source,
    checked_date: null,
    reviewer: null,
    review_status: LEGACY_REVIEW_STATUS,
    license: null,
    provenance_tags: ['legacy_unverified']
  };
}

function legacyResources(c) {
  const sources = Array.isArray(c.nguon) ? c.nguon : [];
  const checks = Array.isArray(c.nguon_kiem) ? c.nguon_kiem : [];
  const out = [];
  const seen = new Set();
  sources.forEach((sourceText, index) => {
    const verification = checks.find(item => item && item.i === index) || null;
    const resource = sourceFor(c.id, safeText(sourceText), verification, index);
    if (!seen.has(resource.resource_id)) {
      seen.add(resource.resource_id);
      out.push(resource);
    }
  });
  return out;
}

function diagnosisChoice(raw) {
  const text = safeText(raw);
  if (text.startsWith('+')) return { text: text.slice(1), credit: 'full' };
  if (text.startsWith('~')) return { text: text.slice(1), credit: 'partial' };
  return { text, credit: 'none' };
}

function actionChoice(raw) {
  const text = safeText(raw);
  const marker = text.startsWith('++') ? '++' : ['+','-','!'].includes(text[0]) ? text[0] : '';
  const body = marker ? text.slice(marker.length) : text;
  const [label = '', minutes = '0', ...why] = body.split('|');
  const grade = marker === '++' ? 'critical'
    : marker === '+' ? 'recommended'
    : marker === '-' ? 'waste'
    : marker === '!' ? 'harmful'
    : 'neutral';
  const time = Number(minutes);
  return {
    text: label,
    time_minutes: Number.isFinite(time) && time >= 0 ? time : 0,
    grade,
    rationale: why.join('|')
  };
}

function trackOf(c) {
  if (['noi','ngoai','yhct'].includes(c.track)) return c.track;
  if (c.opt && c.opt.bd) return 'yhct';
  if (c.group === 'ngoai' || c.id === 'thai-ngoai-tu-cung-vo') return 'ngoai';
  return 'noi';
}

function modeOf(c) {
  if (c.mode === 'tay' || c.mode === 'dongtay') return c.mode;
  return c.setting === 'capcuu' || c.setting === 'giuong' ? 'tay' : 'dongtay';
}

export function adaptLegacyCase(input) {
  const c = requireLegacyCase(input);
  const v = c.vitals || {};
  const diagnosisOptions = {};
  for (const key of ['ydx','bd','bc','the','phap','phuong','huyet']) {
    if (Array.isArray(c.opt?.[key])) diagnosisOptions[key] = c.opt[key].map(diagnosisChoice);
  }

  const public_bundle = {
    schema_version: PUBLIC_SCHEMA_VERSION,
    case_id: c.id,
    data_origin: 'synthetic',
    review_status: LEGACY_REVIEW_STATUS,
    title: safeText(c.title),
    setting: c.setting,
    level: c.level,
    track: trackOf(c),
    mode: modeOf(c),
    demographics: {
      age: c.age,
      sex: c.sex,
      patient_label: safeText(c.name)
    },
    presentation: {
      intro: safeText(c.intro),
      place: c.place == null ? null : safeText(c.place),
      clock: c.clock == null ? null : safeText(c.clock),
      night: Boolean(c.night)
    },
    vitals: {
      hr: Number(v.hr),
      sbp: Number(v.sbp),
      dbp: Number(v.dbp),
      rr: Number(v.rr),
      temperature_c: Number(v.t),
      spo2: Number(v.spo2)
    },
    history: (Array.isArray(c.ask) ? c.ask : []).map(item => ({
      question: safeText(item?.[0]),
      response: safeText(item?.[1])
    })),
    examination: (Array.isArray(c.exam) ? c.exam : []).map(item => ({
      group: safeText(item?.[0]),
      item: safeText(item?.[1]),
      finding: safeText(item?.[2])
    })),
    investigations: (Array.isArray(c.tests) ? c.tests : []).map(item => ({
      name: safeText(item?.[0]),
      duration_minutes: Number.isFinite(Number(item?.[1])) ? Number(item[1]) : 0,
      result: safeText(item?.[2])
    })),
    resources: legacyResources(c)
  };

  const answer_key = {
    schema_version: ANSWER_SCHEMA_VERSION,
    case_id: c.id,
    server_only: true,
    history_essential_indices: (Array.isArray(c.ask) ? c.ask : []).flatMap((item, index) => item?.[2] === 'e' ? [index] : []),
    examination_essential_indices: (Array.isArray(c.exam) ? c.exam : []).flatMap((item, index) => item?.[3] === 'e' ? [index] : []),
    investigation_roles: (Array.isArray(c.tests) ? c.tests : []).map((item, index) => ({
      index,
      role: item?.[3] === 'e' ? 'essential' : item?.[3] === 'w' ? 'waste' : 'neutral'
    })),
    diagnosis_options: diagnosisOptions,
    action_options: (Array.isArray(c.actions) ? c.actions : []).map(actionChoice),
    teaching_explanation: safeText(c.teach)
  };

  return { public_bundle, answer_key };
}

export default adaptLegacyCase;
