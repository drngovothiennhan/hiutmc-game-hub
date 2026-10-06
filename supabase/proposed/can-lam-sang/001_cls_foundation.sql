begin;

create schema if not exists can_lam_sang_private;

revoke all on schema can_lam_sang_private from public, anon, authenticated;

create table if not exists can_lam_sang_private.feature_flags (
  flag_key text primary key,
  enabled boolean not null default false,
  allowlist_user_ids uuid[] not null default '{}'::uuid[],
  constraint feature_flags_key_check
    check (flag_key ~ '^[a-z0-9_]+$')
);

create table if not exists can_lam_sang_private.case_bundles (
  case_id text primary key,
  schema_version text not null,
  data_origin text not null,
  review_status text not null,
  public_bundle jsonb not null,
  content_sha256 text not null,
  constraint case_bundles_data_origin_check
    check (data_origin in ('synthetic', 'anonymized')),
  constraint case_bundles_review_status_check
    check (review_status in ('CHUA_DUYET', 'DA_DUYET')),
  constraint case_bundles_public_bundle_object_check
    check (pg_catalog.jsonb_typeof(public_bundle) = 'object'),
  constraint case_bundles_public_identity_check
    check (
      public_bundle ->> 'case_id' = case_id
      and public_bundle ->> 'schema_version' = schema_version
      and public_bundle ->> 'data_origin' = data_origin
      and public_bundle ->> 'review_status' = review_status
    ),
  constraint case_bundles_public_no_answer_key_check
    check (
      not (
        public_bundle ?| array[
          'opt',
          'actions',
          'teach',
          'answer_key',
          'resources',
          'resources_after_submission',
          'after_submission_notes',
          'title_reveal'
        ]
      )
    ),
  constraint case_bundles_sha256_check
    check (content_sha256 ~ '^[a-f0-9]{64}$')
);

create table if not exists can_lam_sang_private.answer_keys (
  case_id text primary key
    references can_lam_sang_private.case_bundles(case_id)
    on delete cascade,
  answer_key jsonb not null,
  content_sha256 text not null,
  constraint answer_keys_object_check
    check (pg_catalog.jsonb_typeof(answer_key) = 'object'),
  constraint answer_keys_identity_check
    check (
      answer_key ->> 'case_id' = case_id
      and answer_key ->> 'server_only' = 'true'
    ),
  constraint answer_keys_sha256_check
    check (content_sha256 ~ '^[a-f0-9]{64}$')
);

create table if not exists can_lam_sang_private.resources (
  resource_id text primary key,
  schema_version text not null,
  resource_type text not null,
  source text not null,
  title text not null,
  organization text,
  year_version text,
  citation text not null,
  checked_date date,
  reviewer text,
  review_status text not null,
  license text,
  provenance_tags text[] not null default '{}'::text[],
  constraint resources_type_check
    check (resource_type in ('guideline', 'article', 'regulation', 'textbook', 'web', 'other')),
  constraint resources_review_status_check
    check (review_status in ('CHUA_DUYET', 'DA_DUYET')),
  constraint resources_required_text_check
    check (
      pg_catalog.btrim(source) <> ''
      and pg_catalog.btrim(title) <> ''
      and pg_catalog.btrim(citation) <> ''
    ),
  constraint resources_approved_metadata_check
    check (
      review_status <> 'DA_DUYET'
      or (
        organization is not null and pg_catalog.btrim(organization) <> ''
        and year_version is not null and pg_catalog.btrim(year_version) <> ''
        and checked_date is not null
        and reviewer is not null and pg_catalog.btrim(reviewer) <> ''
        and license is not null and pg_catalog.btrim(license) <> ''
      )
    )
);

create table if not exists can_lam_sang_private.submissions (
  id uuid primary key default pg_catalog.gen_random_uuid(),
  user_id uuid not null,
  case_id text not null
    references can_lam_sang_private.case_bundles(case_id),
  module text not null,
  answers jsonb not null,
  created_at timestamptz not null default pg_catalog.now(),
  constraint submissions_module_check
    check (module in ('core', 'cbc', 'ecg_monitor', 'xray', 'auscultation')),
  constraint submissions_answers_object_check
    check (pg_catalog.jsonb_typeof(answers) = 'object'),
  constraint submissions_no_duplicate
    unique (user_id, case_id, module)
);

alter table can_lam_sang_private.feature_flags enable row level security;
alter table can_lam_sang_private.case_bundles enable row level security;
alter table can_lam_sang_private.answer_keys enable row level security;
alter table can_lam_sang_private.resources enable row level security;
alter table can_lam_sang_private.submissions enable row level security;

revoke all on all tables in schema can_lam_sang_private from public, anon, authenticated;
revoke all on all sequences in schema can_lam_sang_private from public, anon, authenticated;

alter default privileges in schema can_lam_sang_private
  revoke all on tables from public, anon, authenticated;
alter default privileges in schema can_lam_sang_private
  revoke all on sequences from public, anon, authenticated;
alter default privileges in schema can_lam_sang_private
  revoke execute on functions from public, anon, authenticated;

insert into can_lam_sang_private.feature_flags (
  flag_key,
  enabled,
  allowlist_user_ids
)
values (
  'clinical_lab_room_v1',
  false,
  '{}'::uuid[]
)
on conflict (flag_key) do nothing;

commit;
