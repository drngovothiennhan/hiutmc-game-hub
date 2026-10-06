begin;

create table if not exists can_lam_sang_private.cbc_patterns (
  pattern_id text primary key,
  schema_version text not null,
  name text not null,
  population text not null default 'adult',
  level text not null,
  indices jsonb not null,
  reference_metadata jsonb not null default '{}'::jsonb,
  review_status text not null default 'CHUA_DUYET',
  reviewer text,
  reviewed_at timestamptz,
  approval_ref text,
  created_at timestamptz not null default pg_catalog.now(),
  constraint cbc_patterns_population_check
    check (population = 'adult'),
  constraint cbc_patterns_level_check
    check (level in ('co_ban', 'trung_binh', 'nang_cao')),
  constraint cbc_patterns_indices_object_check
    check (pg_catalog.jsonb_typeof(indices) = 'object'),
  constraint cbc_patterns_reference_metadata_object_check
    check (pg_catalog.jsonb_typeof(reference_metadata) = 'object'),
  constraint cbc_patterns_review_status_check
    check (review_status in ('CHUA_DUYET', 'DA_DUYET')),
  constraint cbc_patterns_approved_metadata_check
    check (
      review_status <> 'DA_DUYET'
      or (
        reviewer is not null and pg_catalog.btrim(reviewer) <> ''
        and reviewed_at is not null
        and approval_ref is not null and pg_catalog.btrim(approval_ref) <> ''
      )
    )
);

create table if not exists can_lam_sang_private.cbc_case_mappings (
  case_id text primary key
    references can_lam_sang_private.case_bundles(case_id)
    on delete cascade,
  pattern_id text not null
    references can_lam_sang_private.cbc_patterns(pattern_id),
  mapping_version text not null,
  evidence_resource_id text,
  reviewer text,
  review_status text not null default 'CHUA_DUYET',
  reviewed_at timestamptz,
  approval_ref text,
  review_note text,
  created_at timestamptz not null default pg_catalog.now(),
  constraint cbc_case_mappings_review_status_check
    check (review_status in ('CHUA_DUYET', 'DA_DUYET')),
  constraint cbc_case_mappings_approved_metadata_check
    check (
      review_status <> 'DA_DUYET'
      or (
        reviewer is not null and pg_catalog.btrim(reviewer) <> ''
        and reviewed_at is not null
        and approval_ref is not null and pg_catalog.btrim(approval_ref) <> ''
      )
    )
);

create table if not exists can_lam_sang_private.cbc_scenarios (
  scenario_key text primary key,
  pattern_id text not null
    references can_lam_sang_private.cbc_patterns(pattern_id),
  level text not null,
  variant integer not null,
  sex text not null,
  public_scenario jsonb not null,
  answer_key jsonb not null,
  created_at timestamptz not null default pg_catalog.now(),
  constraint cbc_scenarios_level_check
    check (level in ('co_ban', 'trung_binh', 'nang_cao')),
  constraint cbc_scenarios_variant_check
    check (variant >= 0),
  constraint cbc_scenarios_sex_check
    check (sex in ('nam', 'nữ')),
  constraint cbc_scenarios_public_object_check
    check (pg_catalog.jsonb_typeof(public_scenario) = 'object'),
  constraint cbc_scenarios_answer_object_check
    check (pg_catalog.jsonb_typeof(answer_key) = 'object'),
  constraint cbc_scenarios_public_no_pattern_check
    check (
      not (
        public_scenario ?| array['pattern_id','review_status','reviewer','approval_ref','answer_key']
      )
      and pg_catalog.position(pattern_id in public_scenario::text) = 0
    ),
  constraint cbc_scenarios_answer_classifications_check
    check (
      pg_catalog.jsonb_typeof(answer_key -> 'classifications') = 'object'
      and pg_catalog.jsonb_object_length(answer_key -> 'classifications') = 13
    )
);

create table if not exists can_lam_sang_private.cbc_attempts (
  id uuid primary key default pg_catalog.gen_random_uuid(),
  user_id uuid not null
    references auth.users(id)
    on delete cascade,
  scenario_key text not null
    references can_lam_sang_private.cbc_scenarios(scenario_key),
  level text not null,
  variant integer not null,
  sex text not null,
  status text not null default 'started',
  started_at timestamptz not null default pg_catalog.now(),
  submitted_at timestamptz,
  answers jsonb,
  result jsonb,
  score numeric(6,5),
  constraint cbc_attempts_level_check
    check (level in ('co_ban', 'trung_binh', 'nang_cao')),
  constraint cbc_attempts_variant_check
    check (variant >= 0),
  constraint cbc_attempts_sex_check
    check (sex in ('nam', 'nữ')),
  constraint cbc_attempts_status_check
    check (status in ('started', 'submitted')),
  constraint cbc_attempts_started_submitted_check
    check (
      (status = 'started' and submitted_at is null)
      or
      (status = 'submitted' and submitted_at is not null)
    ),
  constraint cbc_attempts_answers_object_check
    check (answers is null or pg_catalog.jsonb_typeof(answers) = 'object'),
  constraint cbc_attempts_result_object_check
    check (result is null or pg_catalog.jsonb_typeof(result) = 'object'),
  constraint cbc_attempts_score_check
    check (score is null or (score >= 0 and score <= 1))
);

create index if not exists cbc_attempts_user_status_idx
  on can_lam_sang_private.cbc_attempts (user_id, status);

create index if not exists cbc_attempts_user_created_at_idx
  on can_lam_sang_private.cbc_attempts (user_id, started_at);

create index if not exists cbc_scenarios_level_idx
  on can_lam_sang_private.cbc_scenarios (level, scenario_key);

alter table can_lam_sang_private.cbc_patterns enable row level security;
alter table can_lam_sang_private.cbc_case_mappings enable row level security;
alter table can_lam_sang_private.cbc_scenarios enable row level security;
alter table can_lam_sang_private.cbc_attempts enable row level security;

revoke all on table
  can_lam_sang_private.cbc_patterns,
  can_lam_sang_private.cbc_case_mappings,
  can_lam_sang_private.cbc_scenarios,
  can_lam_sang_private.cbc_attempts
  from public, anon, authenticated;

commit;
