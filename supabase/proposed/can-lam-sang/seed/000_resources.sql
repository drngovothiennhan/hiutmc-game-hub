begin;

-- Resources run before case chunks. This file does not modify runtime flags.
insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-acs-accaha-2025',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/40014670/',
  'ACC/AHA/ACEP/NAEMSP/SCAI, Guideline for the Management of Patients With Acute Coronary Syndromes, 2025.',
  null,
  null,
  'ACC/AHA/ACEP/NAEMSP/SCAI, Guideline for the Management of Patients With Acute Coronary Syndromes, 2025.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-acs-esc-2023-0bce3c0fff0f',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/37622654/',
  '2023 ESC Guidelines for the management of acute coronary syndromes, Eur Heart J 2023.',
  null,
  null,
  '2023 ESC Guidelines for the management of acute coronary syndromes, Eur Heart J 2023.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-acs-esc-2023-6ba1d5ca910a',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/37622654/',
  'European Society of Cardiology. 2023 Guidelines for the management of acute coronary syndromes. Eur Heart J 2023;44:3720-3826. DOI: 10.1093/eurheartj/ehad191.',
  null,
  null,
  'European Society of Cardiology. 2023 Guidelines for the management of acute coronary syndromes. Eur Heart J 2023;44:3720-3826. DOI: 10.1093/eurheartj/ehad191.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-acs-esc-2023-a84a21104b0c',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/37622654/',
  'ESC, Guidelines for the management of acute coronary syndromes, 2023.',
  null,
  null,
  'ESC, Guidelines for the management of acute coronary syndromes, 2023.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-adnexal-torsion-acog-783',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/31348225/',
  'ACOG Committee Opinion No. 783: Adnexal Torsion in Adolescents, 2019.',
  null,
  null,
  'ACOG Committee Opinion No. 783: Adnexal Torsion in Adolescents, 2019.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-af-esc-2020',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/32860505/',
  '2020 ESC Guidelines for the diagnosis and management of atrial fibrillation, Eur Heart J 2021.',
  null,
  null,
  '2020 ESC Guidelines for the diagnosis and management of atrial fibrillation, Eur Heart J 2021.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-airway-das-2015',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/26556848/',
  'Difficult Airway Society 2015 guidelines for management of unanticipated difficult intubation (Br J Anaesth 2015)',
  null,
  null,
  'Difficult Airway Society 2015 guidelines for management of unanticipated difficult intubation (Br J Anaesth 2015)',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ais-aha-2019-63a4cc1eb291',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/31662037/',
  'Powers WJ, et al. 2019 Update to the 2018 Guidelines for the Early Management of Acute Ischemic Stroke. AHA/ASA. Stroke 2019;50:e344.',
  null,
  null,
  'Powers WJ, et al. 2019 Update to the 2018 Guidelines for the Early Management of Acute Ischemic Stroke. AHA/ASA. Stroke 2019;50:e344.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ais-aha-2019-cb3501f185c2',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/31662037/',
  'American Heart Association/American Stroke Association. Guidelines for the Early Management of Acute Ischemic Stroke, 2019 update. https://www.heart.org/-/-/media/Files/Professional/Quality-Improvement/Get-With-the-Guidelines/Get-With-The-Guidelines-Stroke/2019UpdateAHAASAAISGuidelineSlideDeckrevisedADL12919.pdf . Trích: “IV alteplase (0.9 mg/kg, maximum dose 90 mg over 60 min with initial 10% of dose given as bolus over 1 min)”.',
  null,
  null,
  'American Heart Association/American Stroke Association. Guidelines for the Early Management of Acute Ischemic Stroke, 2019 update. https://www.heart.org/-/-/media/Files/Professional/Quality-Improvement/Get-With-the-Guidelines/Get-With-The-Guidelines-Stroke/2019UpdateAHAASAAISGuidelineSlideDeckrevisedADL12919.pdf . Trích: “IV alteplase (0.9 mg/kg, maximum dose 90 mg over 60 min with initial 10% of dose given as bolus over 1 min)”.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ais-aha-2026',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/41582814/',
  'AHA/ASA, Guideline for the Early Management of Patients With Acute Ischemic Stroke, 2026.',
  null,
  null,
  'AHA/ASA, Guideline for the Early Management of Patients With Acute Ischemic Stroke, 2026.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-als-aha-2025',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/41122884/',
  'American Heart Association. Guidelines for CPR and Emergency Cardiovascular Care, adult advanced cardiovascular life support, bản cập nhật gần nhất.',
  null,
  null,
  'American Heart Association. Guidelines for CPR and Emergency Cardiovascular Care, adult advanced cardiovascular life support, bản cập nhật gần nhất.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-als-erc-2025',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/41117572/',
  'European Resuscitation Council. Guidelines, Adult advanced life support, bản cập nhật gần nhất.',
  null,
  null,
  'European Resuscitation Council. Guidelines, Adult advanced life support, bản cập nhật gần nhất.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ami-wses-2022',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/36261857/',
  'World Society of Emergency Surgery (WSES) guidelines on acute mesenteric ischemia: 2022 update, World J Emerg Surg 2022. DOI: 10.1186/s13017-022-00443-x.',
  null,
  null,
  'World Society of Emergency Surgery (WSES) guidelines on acute mesenteric ischemia: 2022 update, World J Emerg Surg 2022. DOI: 10.1186/s13017-022-00443-x.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-anaphylaxis-wao-2020',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/33204386/',
  'World Allergy Organization, Anaphylaxis Guidance, 2020.',
  null,
  null,
  'World Allergy Organization, Anaphylaxis Guidance, 2020.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-anorectal-abscess-ascrs-2022',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/35732009/',
  'Gaertner WB et al. The American Society of Colon and Rectal Surgeons Clinical Practice Guidelines for the Management of Anorectal Abscess, Fistula-in-Ano, and Rectovaginal Fistula. Dis Colon Rectum 2022.',
  null,
  null,
  'Gaertner WB et al. The American Society of Colon and Rectal Surgeons Clinical Practice Guidelines for the Management of Anorectal Abscess, Fistula-in-Ano, and Rectovaginal Fistula. Dis Colon Rectum 2022.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-appendicitis-wses-2020-5b10185705b5',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/32295644/',
  'Di Saverio S et al. Diagnosis and treatment of acute appendicitis: 2020 update of the WSES Jerusalem guidelines. World J Emerg Surg 2020.',
  null,
  null,
  'Di Saverio S et al. Diagnosis and treatment of acute appendicitis: 2020 update of the WSES Jerusalem guidelines. World J Emerg Surg 2020.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-appendicitis-wses-2020-6bac2752e0aa',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/32295644/',
  'Di Saverio S et al. WSES Jerusalem guidelines for diagnosis and treatment of acute appendicitis, 2020.',
  null,
  null,
  'Di Saverio S et al. WSES Jerusalem guidelines for diagnosis and treatment of acute appendicitis, 2020.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-appendicitis-wses-2025',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/41604201/',
  'WSES, Diagnosis and Treatment of Acute Appendicitis: 2025 Edition of the WSES Jerusalem Guidelines, công bố năm 2026.',
  null,
  null,
  'WSES, Diagnosis and Treatment of Acute Appendicitis: 2025 Edition of the WSES Jerusalem Guidelines, công bố năm 2026.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ards-ats-2024',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/38032683/',
  'Guidelines on the management of ARDS (ATS, ESICM, SCCM). Am J Respir Crit Care Med 2024; thông khí bảo vệ phổi, nằm sấp.',
  null,
  null,
  'Guidelines on the management of ARDS (ATS, ESICM, SCCM). Am J Respir Crit Care Med 2024; thông khí bảo vệ phổi, nằm sấp.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ards-berlin-2012',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/22797452/',
  'ARDS Definition Task Force. Acute respiratory distress syndrome: the Berlin Definition. JAMA 2012;307:2526-2533. DOI: 10.1001/jama.2012.5669.',
  null,
  null,
  'ARDS Definition Task Force. Acute respiratory distress syndrome: the Berlin Definition. JAMA 2012;307:2526-2533. DOI: 10.1001/jama.2012.5669.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-asbo-bologna-2017-5e6d01e592df',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/29946347/',
  'Ten Broek RPG et al. Bologna guidelines for diagnosis and management of adhesive small bowel obstruction (ASBO): 2017 update of the evidence-based guidelines from the WSES ASBO working group. World J Emerg Surg 2018;13:24.',
  null,
  null,
  'Ten Broek RPG et al. Bologna guidelines for diagnosis and management of adhesive small bowel obstruction (ASBO): 2017 update of the evidence-based guidelines from the WSES ASBO working group. World J Emerg Surg 2018;13:24.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-asbo-bologna-2017-627c8d4cb120',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/29946347/',
  'World Society of Emergency Surgery (WSES) guidelines for adhesive small bowel obstruction, World J Emerg Surg 2018. DOI: 10.1186/s13017-018-0185-2.',
  null,
  null,
  'World Society of Emergency Surgery (WSES) guidelines for adhesive small bowel obstruction, World J Emerg Surg 2018. DOI: 10.1186/s13017-018-0185-2.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ascites-aasld-2021',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/33942342/',
  'AASLD Practice Guidance: Diagnosis, Evaluation, and Management of Ascites, Spontaneous Bacterial Peritonitis and Hepatorenal Syndrome, 2021. DOI: 10.1002/hep.31884. https://onlinelibrary.wiley.com/doi/full/10.1002/hep.31884',
  null,
  null,
  'AASLD Practice Guidance: Diagnosis, Evaluation, and Management of Ascites, Spontaneous Bacterial Peritonitis and Hepatorenal Syndrome, 2021. DOI: 10.1002/hep.31884. https://onlinelibrary.wiley.com/doi/full/10.1002/hep.31884',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-atlanta-2012',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/23100216/',
  'Revised Atlanta Classification of Acute Pancreatitis 2012 (Banks PA et al., Gut 2013)',
  null,
  null,
  'Revised Atlanta Classification of Acute Pancreatitis 2012 (Banks PA et al., Gut 2013)',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-baveno-vii',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/35120736/',
  'Baveno VII, Renewing Consensus in Portal Hypertension, 2022.',
  null,
  null,
  'Baveno VII, Renewing Consensus in Portal Hypertension, 2022.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-bell-aaohns-2013',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/24189771/',
  'AAO-HNSF, Clinical Practice Guideline: Bell’s Palsy, 2013.',
  null,
  null,
  'AAO-HNSF, Clinical Practice Guideline: Bell’s Palsy, 2013.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-bethesda-2023',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/37427847/',
  'The Bethesda System for Reporting Thyroid Cytopathology, 2023.',
  null,
  null,
  'The Bethesda System for Reporting Thyroid Cytopathology, 2023.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-brady-accaha-2018',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/30586772/',
  'American Heart Association. ACC AHA HRS Guideline on the Evaluation and Management of Patients with Bradycardia and Cardiac Conduction Delay, Circulation 2019;140:e382-e482. DOI: 10.1161/CIR.0000000000000628.',
  null,
  null,
  'American Heart Association. ACC AHA HRS Guideline on the Evaluation and Management of Patients with Bradycardia and Cardiac Conduction Delay, Circulation 2019;140:e382-e482. DOI: 10.1161/CIR.0000000000000628.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-breast-esmo-2024',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/38101773/',
  'ESMO Clinical Practice Guideline: Early Breast Cancer, 2024.',
  null,
  null,
  'ESMO Clinical Practice Guideline: Early Breast Cancer, 2024.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-byt-3610-2015',
  '1.0.0',
  'regulation',
  'https://luatvietnam.vn/y-te/quyet-dinh-3610-qd-byt-2015-ve-viec-ban-hanh-tai-lieu-chuyen-mon-huong-dan-chan-doan-va-xu-tri-ngo-doc-319645-d1.html',
  'Bộ Y tế, Hướng dẫn chẩn đoán và xử trí ngộ độc, Quyết định 3610/QĐ-BYT, 2015.',
  null,
  null,
  'Bộ Y tế, Hướng dẫn chẩn đoán và xử trí ngộ độc, Quyết định 3610/QĐ-BYT, 2015.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-byt-3705-2019',
  '1.0.0',
  'regulation',
  'https://caselaw.vn/van-ban-phap-luat/331396-quyet-dinh-so-3705-qd-byt-ngay-22-08-2019-ve-huong-dan-chan-doan-dieu-tri-sot-xuat-huyet-dengue',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị sốt xuất huyết Dengue (Quyết định 3705/QĐ-BYT, 2019 và cập nhật).',
  null,
  null,
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị sốt xuất huyết Dengue (Quyết định 3705/QĐ-BYT, 2019 và cập nhật).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-byt-4132-2018',
  '1.0.0',
  'other',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị viêm màng não mủ (Quyết định 4132/QĐ-BYT, 2018 hoặc bản hiện hành, cần đối chiếu).',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị viêm màng não mủ (Quyết định 4132/QĐ-BYT, 2018 hoặc bản hiện hành, cần đối chiếu).',
  null,
  null,
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị viêm màng não mủ (Quyết định 4132/QĐ-BYT, 2018 hoặc bản hiện hành, cần đối chiếu).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-byt-5013-2020-6d2fc528fe78',
  '1.0.0',
  'regulation',
  'https://luatvietnam.vn/y-te/quyet-dinh-5013-qd-byt-huong-dan-chan-doan-va-dieu-tri-benh-theo-y-hoc-co-truyen-194863-d1.html',
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị bệnh theo YHCT, kết hợp YHCT với YHHĐ, tập I, Quyết định 5013/QĐ-BYT, 2020, mục Gout (Thống phong).',
  null,
  null,
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị bệnh theo YHCT, kết hợp YHCT với YHHĐ, tập I, Quyết định 5013/QĐ-BYT, 2020, mục Gout (Thống phong).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-byt-5013-2020-769245134460',
  '1.0.0',
  'regulation',
  'https://luatvietnam.vn/y-te/quyet-dinh-5013-qd-byt-huong-dan-chan-doan-va-dieu-tri-benh-theo-y-hoc-co-truyen-194863-d1.html',
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị bệnh theo YHCT, kết hợp YHCT với YHHĐ, tập I, Quyết định 5013/QĐ-BYT, 2020, mục Bệnh dây thần kinh mặt (Khẩu nhãn oa tà).',
  null,
  null,
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị bệnh theo YHCT, kết hợp YHCT với YHHĐ, tập I, Quyết định 5013/QĐ-BYT, 2020, mục Bệnh dây thần kinh mặt (Khẩu nhãn oa tà).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-byt-5013-2020-a40685e8c8a1',
  '1.0.0',
  'regulation',
  'https://luatvietnam.vn/y-te/quyet-dinh-5013-qd-byt-huong-dan-chan-doan-va-dieu-tri-benh-theo-y-hoc-co-truyen-194863-d1.html',
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị bệnh theo y học cổ truyền, kết hợp y học cổ truyền với y học hiện đại, Quyết định 5013/QĐ-BYT, 2020.',
  null,
  null,
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị bệnh theo y học cổ truyền, kết hợp y học cổ truyền với y học hiện đại, Quyết định 5013/QĐ-BYT, 2020.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-byt-5331-2020',
  '1.0.0',
  'regulation',
  'https://luatvietnam.vn/y-te/quyet-dinh-5331-qd-byt-huong-dan-chan-doan-va-xu-tri-dot-quy-nao-196062-d1.html',
  'Bộ Y tế. Hướng dẫn chẩn đoán và xử trí đột quỵ não (Quyết định 5331/QĐ-BYT, 2020).',
  null,
  null,
  'Bộ Y tế. Hướng dẫn chẩn đoán và xử trí đột quỵ não (Quyết định 5331/QĐ-BYT, 2020).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-byt-5481-2020',
  '1.0.0',
  'regulation',
  'https://luatvietnam.vn/y-te/quyet-dinh-5481-qd-byt-huong-dan-chan-doan-va-dieu-tri-dai-thao-duong-tip-2-196326-d1.html',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị đái tháo đường típ 2 (Quyết định 5481/QĐ-BYT, 2020).',
  null,
  null,
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị đái tháo đường típ 2 (Quyết định 5481/QĐ-BYT, 2020).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-byt-708-2015',
  '1.0.0',
  'regulation',
  'https://luatvietnam.vn/y-te/quyet-dinh-708-qd-byt-bo-y-te-93000-d1.html',
  'Bộ Y tế. Hướng dẫn sử dụng kháng sinh (Quyết định 708/QĐ-BYT, 2015).',
  null,
  null,
  'Bộ Y tế. Hướng dẫn sử dụng kháng sinh (Quyết định 708/QĐ-BYT, 2015).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-byt-tt51-2017',
  '1.0.0',
  'regulation',
  'https://luatvietnam.vn/y-te/thong-tu-51-2017-tt-byt-bo-y-te-158294-d1.html',
  'Bộ Y tế, Thông tư 51/2017/TT-BYT hướng dẫn phòng, chẩn đoán và xử trí phản vệ, 2017.',
  null,
  null,
  'Bộ Y tế, Thông tư 51/2017/TT-BYT hướng dẫn phòng, chẩn đoán và xử trí phản vệ, 2017.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-canh-vai-tay-thoai-hoa-csc-1',
  '1.0.0',
  'other',
  'North American Spine Society, Evidence-Based Clinical Guidelines for Multidisciplinary Spine Care: Diagnosis and Treatment of Cervical Radiculopathy from Degenerative Disorders, 2010.',
  'North American Spine Society, Evidence-Based Clinical Guidelines for Multidisciplinary Spine Care: Diagnosis and Treatment of Cervical Radiculopathy from Degenerative Disorders, 2010.',
  null,
  null,
  'North American Spine Society, Evidence-Based Clinical Guidelines for Multidisciplinary Spine Care: Diagnosis and Treatment of Cervical Radiculopathy from Degenerative Disorders, 2010.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-cap-ats-idsa-2019',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/31573350/',
  'ATS/IDSA Guidelines for the diagnosis and treatment of adults with community-acquired pneumonia, 2019.',
  null,
  null,
  'ATS/IDSA Guidelines for the diagnosis and treatment of adults with community-acquired pneumonia, 2019.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-cdi-idsa-2017',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/29462280/',
  'IDSA/SHEA Clinical Practice Guideline for Clostridium difficile Infection in Adults and Children, bản 2017, công bố 2018. https://www.idsociety.org/practice-guideline/clostridium-difficile/',
  null,
  null,
  'IDSA/SHEA Clinical Practice Guideline for Clostridium difficile Infection in Adults and Children, bản 2017, công bố 2018. https://www.idsociety.org/practice-guideline/clostridium-difficile/',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-cdi-idsa-2021',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/34164674/',
  'IDSA/SHEA Focused Update for Management of Clostridioides difficile Infection in Adults, 2021. https://www.idsociety.org/practice-guideline/clostridioides-difficile-2021-focused-update/',
  null,
  null,
  'IDSA/SHEA Focused Update for Management of Clostridioides difficile Infection in Adults, 2021. https://www.idsociety.org/practice-guideline/clostridioides-difficile-2021-focused-update/',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-co-acep-2017',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/27993310/',
  'American College of Emergency Physicians. Clinical policy: critical issues in the management of adult patients presenting to the ED with acute carbon monoxide poisoning. Ann Emerg Med 2017.',
  null,
  null,
  'American College of Emergency Physicians. Clinical policy: critical issues in the management of adult patients presenting to the ED with acute carbon monoxide poisoning. Ann Emerg Med 2017.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-co-giat-do-sot-cao-tre-em-2',
  '1.0.0',
  'other',
  'NICE, Epilepsies in Children, Young People and Adults, NG217, 2022 — mục xử trí trạng thái động kinh co giật.',
  'NICE, Epilepsies in Children, Young People and Adults, NG217, 2022 — mục xử trí trạng thái động kinh co giật.',
  null,
  null,
  'NICE, Epilepsies in Children, Young People and Adults, NG217, 2022 — mục xử trí trạng thái động kinh co giật.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-co-weaver-2009',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/19297574/',
  'Weaver LK. Carbon monoxide poisoning. N Engl J Med 2009;360:1217-1225.',
  null,
  null,
  'Weaver LK. Carbon monoxide poisoning. N Engl J Med 2009;360:1217-1225.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-crc-wses-2018',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/30123315/',
  'Pisano M et al. 2017 WSES guidelines on colon and rectal cancer emergencies: obstruction and perforation. World J Emerg Surg 2018.',
  null,
  null,
  'Pisano M et al. 2017 WSES guidelines on colon and rectal cancer emergencies: obstruction and perforation. World J Emerg Surg 2018.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-dau-nua-dau-can-duong-thuong-cang-1',
  '1.0.0',
  'other',
  'International Headache Society, The International Classification of Headache Disorders, 3rd edition (ICHD-3), 2018.',
  'International Headache Society, The International Classification of Headache Disorders, 3rd edition (ICHD-3), 2018.',
  null,
  null,
  'International Headache Society, The International Classification of Headache Disorders, 3rd edition (ICHD-3), 2018.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-dau-nua-dau-can-duong-thuong-cang-2',
  '1.0.0',
  'other',
  'American Headache Society, The American Headache Society Position Statement on Integrating New Migraine Treatments Into Clinical Practice, 2021.',
  'American Headache Society, The American Headache Society Position Statement on Integrating New Migraine Treatments Into Clinical Practice, 2021.',
  null,
  null,
  'American Headache Society, The American Headache Society Position Statement on Integrating New Migraine Treatments Into Clinical Practice, 2021.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-di-chung-tai-bien-khi-hu-huyet-u-1',
  '1.0.0',
  'other',
  'American Heart Association and American Stroke Association, Guidelines for Adult Stroke Rehabilitation and Recovery, 2016.',
  'American Heart Association and American Stroke Association, Guidelines for Adult Stroke Rehabilitation and Recovery, 2016.',
  null,
  null,
  'American Heart Association and American Stroke Association, Guidelines for Adult Stroke Rehabilitation and Recovery, 2016.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-di-chung-tai-bien-khi-hu-huyet-u-2',
  '1.0.0',
  'other',
  'American Heart Association and American Stroke Association, Guideline for the Prevention of Stroke in Patients With Stroke and Transient Ischemic Attack, 2021.',
  'American Heart Association and American Stroke Association, Guideline for the Prevention of Stroke in Patients With Stroke and Transient Ischemic Attack, 2021.',
  null,
  null,
  'American Heart Association and American Stroke Association, Guideline for the Prevention of Stroke in Patients With Stroke and Transient Ischemic Attack, 2021.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-diarrhea-idsa-2017',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/29053792/',
  'Infectious Diseases Society of America, Clinical Practice Guidelines for the Diagnosis and Management of Infectious Diarrhea, 2017.',
  null,
  null,
  'Infectious Diseases Society of America, Clinical Practice Guidelines for the Diagnosis and Management of Infectious Diarrhea, 2017.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-diverticulitis-wses-2020',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/32381121/',
  'World Society of Emergency Surgery (WSES) guidelines for the management of acute left sided colonic diverticulitis in the emergency setting, World J Emerg Surg 2020. DOI: 10.1186/s13017-020-00336-x.',
  null,
  null,
  'World Society of Emergency Surgery (WSES) guidelines for the management of acute left sided colonic diverticulitis in the emergency setting, World J Emerg Surg 2020. DOI: 10.1186/s13017-020-00336-x.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-dka-ada-2024-3ecf8c7e7f15',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/39052901/',
  'ADA/EASD/JBDS/AACE/DTS, Hyperglycemic Crises in Adults With Diabetes: A Consensus Report, 2024.',
  null,
  null,
  'ADA/EASD/JBDS/AACE/DTS, Hyperglycemic Crises in Adults With Diabetes: A Consensus Report, 2024.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-dka-ada-2024-439d81c681e1',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/39052901/',
  'American Diabetes Association and consensus report. Hyperglycemic crises in adults with diabetes. Diabetes Care 2024;47:1257-1275. DOI: 10.2337/dci24-0032.',
  null,
  null,
  'American Diabetes Association and consensus report. Hyperglycemic crises in adults with diabetes. Diabetes Care 2024;47:1257-1275. DOI: 10.2337/dci24-0032.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-dka-ada-2024-a511779b1c4f',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/39052901/',
  'Umpierrez GE, Davis GM, ElSayed NA, et al. Hyperglycemic Crises in Adults With Diabetes: A Consensus Report, 2024. https://diabetesjournals.org/care/article/47/8/1257/156808/Hyperglycemic-Crises-in-Adults-With-Diabetes-A . Trích: “500–1,000 mL/h during the first 2–4 h”; “fixed-rate intravenous insulin infusion started at 0.1 units/kg/h”.',
  null,
  null,
  'Umpierrez GE, Davis GM, ElSayed NA, et al. Hyperglycemic Crises in Adults With Diabetes: A Consensus Report, 2024. https://diabetesjournals.org/care/article/47/8/1257/156808/Hyperglycemic-Crises-in-Adults-With-Diabetes-A . Trích: “500–1,000 mL/h during the first 2–4 h”; “fixed-rate intravenous insulin infusion started at 0.1 units/kg/h”.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-drowning-szpilman-2012',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/22646632/',
  'Szpilman D, Bierens JJLM, Handley AJ, Orlowski JP. Drowning. N Engl J Med 2012;366:2102-2110.',
  null,
  null,
  'Szpilman D, Bierens JJLM, Handley AJ, Orlowski JP. Drowning. N Engl J Med 2012;366:2102-2110.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-eau-urolithiasis-7478a8988584',
  '1.0.0',
  'guideline',
  'https://uroweb.org/guidelines/urolithiasis',
  'EAU Guidelines on Urolithiasis, 2024.',
  null,
  null,
  'EAU Guidelines on Urolithiasis, 2024.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-eau-urolithiasis-a371e1e02fb2',
  '1.0.0',
  'guideline',
  'https://uroweb.org/guidelines/urolithiasis',
  'European Association of Urology, EAU Guidelines on Urolithiasis, bản cập nhật.',
  null,
  null,
  'European Association of Urology, EAU Guidelines on Urolithiasis, bản cập nhật.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ectopic-acog-193',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/29470343/',
  'American College of Obstetricians and Gynecologists, Practice Bulletin No. 193: Tubal Ectopic Pregnancy, 2018.',
  null,
  null,
  'American College of Obstetricians and Gynecologists, Practice Bulletin No. 193: Tubal Ectopic Pregnancy, 2018.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-esc-hf-2026',
  '1.0.0',
  'other',
  'ESC, Guidelines for the management of heart failure, 2026; cần đối chiếu bản đầy đủ trước khi hoàn thiện đáp án điều trị.',
  'ESC, Guidelines for the management of heart failure, 2026; cần đối chiếu bản đầy đủ trước khi hoàn thiện đáp án điều trị.',
  null,
  null,
  'ESC, Guidelines for the management of heart failure, 2026; cần đối chiếu bản đầy đủ trước khi hoàn thiện đáp án điều trị.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-febrile-seizure-aap-2011',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/21285335/',
  'American Academy of Pediatrics, Febrile Seizures: Guideline for the Neurodiagnostic Evaluation of the Child With a Simple Febrile Seizure, 2011.',
  null,
  null,
  'American Academy of Pediatrics, Febrile Seizures: Guideline for the Neurodiagnostic Evaluation of the Child With a Simple Febrile Seizure, 2011.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-gina-2025-2dd5483279cd',
  '1.0.0',
  'guideline',
  'https://ginasthma.org/wp-content/uploads/2025/11/GINA-Summary-Guide-2025-WEB_FINAL-WMS.pdf',
  'Global Initiative for Asthma, Summary Guide for Asthma Management and Prevention, 2025.',
  null,
  null,
  'Global Initiative for Asthma, Summary Guide for Asthma Management and Prevention, 2025.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-gina-2025-7da41e42542c',
  '1.0.0',
  'guideline',
  'https://ginasthma.org/wp-content/uploads/2025/11/GINA-Summary-Guide-2025-WEB_FINAL-WMS.pdf',
  'Global Initiative for Asthma (GINA) report, bản cập nhật hiện hành.',
  null,
  null,
  'Global Initiative for Asthma (GINA) report, bản cập nhật hiện hành.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-gina-2025-96f4d570b626',
  '1.0.0',
  'guideline',
  'https://ginasthma.org/wp-content/uploads/2025/11/GINA-Summary-Guide-2025-WEB_FINAL-WMS.pdf',
  'Global Initiative for Asthma (GINA), Global Strategy for Asthma Management and Prevention, báo cáo cập nhật.',
  null,
  null,
  'Global Initiative for Asthma (GINA), Global Strategy for Asthma Management and Prevention, báo cáo cập nhật.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-gold-2025-801096d6b722',
  '1.0.0',
  'guideline',
  'https://goldcopd.org/2025-gold-report/',
  'Global Initiative for Chronic Obstructive Lung Disease (GOLD) report, bản cập nhật hiện hành.',
  null,
  null,
  'Global Initiative for Chronic Obstructive Lung Disease (GOLD) report, bản cập nhật hiện hành.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-gold-2025-b5afb3bf4d46',
  '1.0.0',
  'guideline',
  'https://goldcopd.org/2025-gold-report/',
  'Global Initiative for Chronic Obstructive Lung Disease, GOLD Report 2026. https://goldcopd.org/wp-content/uploads/2026/01/GOLD-REPORT-2026-v1.3-8Dec2025_WMV2.pdf . Trích: “A dose of 40 mg prednisone-equivalent per day for 5 days is recommended”; “target saturation of 88-92%”.',
  null,
  null,
  'Global Initiative for Chronic Obstructive Lung Disease, GOLD Report 2026. https://goldcopd.org/wp-content/uploads/2026/01/GOLD-REPORT-2026-v1.3-8Dec2025_WMV2.pdf . Trích: “A dose of 40 mg prednisone-equivalent per day for 5 days is recommended”; “target saturation of 88-92%”.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-gold-2025-dfc065ef2ac5',
  '1.0.0',
  'guideline',
  'https://goldcopd.org/2025-gold-report/',
  'Global Initiative for Chronic Obstructive Lung Disease, Global Strategy for the Diagnosis, Management, and Prevention of COPD, 2025 Report.',
  null,
  null,
  'Global Initiative for Chronic Obstructive Lung Disease, Global Strategy for the Diagnosis, Management, and Prevention of COPD, 2025 Report.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ha-duong-huyet-nang-1',
  '1.0.0',
  'other',
  'American Diabetes Association, Glycemic Goals, Hypoglycemia, and Hyperglycemic Crises: Standards of Care in Diabetes, 2026.',
  'American Diabetes Association, Glycemic Goals, Hypoglycemia, and Hyperglycemic Crises: Standards of Care in Diabetes, 2026.',
  null,
  null,
  'American Diabetes Association, Glycemic Goals, Hypoglycemia, and Hyperglycemic Crises: Standards of Care in Diabetes, 2026.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-he-aasld-2014',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/25042402/',
  'Vilstrup H et al. Hepatic encephalopathy in chronic liver disease: 2014 practice guideline by AASLD and EASL. Hepatology 2014;60:715-735.',
  null,
  null,
  'Vilstrup H et al. Hepatic encephalopathy in chronic liver disease: 2014 practice guideline by AASLD and EASL. Hepatology 2014;60:715-735.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-heat-acsm-2007',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/17473783/',
  'Armstrong LE et al. American College of Sports Medicine position stand: exertional heat illness during training and competition. Med Sci Sports Exerc 2007;39:556-572.',
  null,
  null,
  'Armstrong LE et al. American College of Sports Medicine position stand: exertional heat illness during training and competition. Med Sci Sports Exerc 2007;39:556-572.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-heat-nata-2015',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/26381473/',
  'Casa DJ et al. National Athletic Trainers'' Association position statement: exertional heat illnesses. J Athl Train 2015;50:986-1000.',
  null,
  null,
  'Casa DJ et al. National Athletic Trainers'' Association position statement: exertional heat illnesses. J Athl Train 2015;50:986-1000.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-heat-wms-2024',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/38425235/',
  'Wilderness Medical Society, Clinical Practice Guidelines for the Prevention and Treatment of Heat Illness: 2024 Update, 2024.',
  null,
  null,
  'Wilderness Medical Society, Clinical Practice Guidelines for the Prevention and Treatment of Heat Illness: 2024 Update, 2024.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-heatstroke-epstein-2019',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/31216400/',
  'Epstein Y, Yanovich R. Heatstroke. N Engl J Med 2019;380:2449-2459.',
  null,
  null,
  'Epstein Y, Yanovich R. Heatstroke. N Engl J Med 2019;380:2449-2459.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-hf-esc-2021-3c4bd6c322d6',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/34447992/',
  '2021 ESC Guidelines for the diagnosis and treatment of acute and chronic heart failure, Eur Heart J 2021.',
  null,
  null,
  '2021 ESC Guidelines for the diagnosis and treatment of acute and chronic heart failure, Eur Heart J 2021.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-hf-esc-2021-d80b57211ac1',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/34447992/',
  'ESC, Guidelines for the diagnosis and treatment of acute and chronic heart failure, 2021; Focused Update, 2023.',
  null,
  null,
  'ESC, Guidelines for the diagnosis and treatment of acute and chronic heart failure, 2021; Focused Update, 2023.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-hoi-chung-ong-co-tay-huyet-hu-1',
  '1.0.0',
  'other',
  'American Academy of Orthopaedic Surgeons, Management of Carpal Tunnel Syndrome Evidence-Based Clinical Practice Guideline, 2016.',
  'American Academy of Orthopaedic Surgeons, Management of Carpal Tunnel Syndrome Evidence-Based Clinical Practice Guideline, 2016.',
  null,
  null,
  'American Academy of Orthopaedic Surgeons, Management of Carpal Tunnel Syndrome Evidence-Based Clinical Practice Guideline, 2016.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-hp-acg-2024-33c83083418b',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/39626064/',
  'ACG Clinical Guideline: Treatment of Helicobacter pylori Infection, 2024; bản tóm lược chính thức của ACG. https://gi.org/journals-publications/ebgi/schoenfeld_sep2024/',
  null,
  null,
  'ACG Clinical Guideline: Treatment of Helicobacter pylori Infection, 2024; bản tóm lược chính thức của ACG. https://gi.org/journals-publications/ebgi/schoenfeld_sep2024/',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-hp-acg-2024-9052a89c3452',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/39626064/',
  'American College of Gastroenterology, ACG Clinical Guideline: Treatment of Helicobacter pylori Infection, 2024.',
  null,
  null,
  'American College of Gastroenterology, ACG Clinical Guideline: Treatment of Helicobacter pylori Infection, 2024.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-htn-esc-2018',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/30165516/',
  '2018 ESC/ESH Guidelines for the management of arterial hypertension, Eur Heart J 2018.',
  null,
  null,
  '2018 ESC/ESH Guidelines for the management of arterial hypertension, Eur Heart J 2018.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-htn-esc-2024',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/39210715/',
  'European Society of Cardiology, Guidelines for the Management of Elevated Blood Pressure and Hypertension, 2024.',
  null,
  null,
  'European Society of Cardiology, Guidelines for the Management of Elevated Blood Pressure and Hypertension, 2024.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-iai-wses-2017',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/28702076/',
  'Sartelli M et al. WSES/GAIS/SIS-E/WSIS/AAST global guidelines for intra-abdominal infections. World J Emerg Surg 2021.',
  null,
  null,
  'Sartelli M et al. WSES/GAIS/SIS-E/WSIS/AAST global guidelines for intra-abdominal infections. World J Emerg Surg 2021.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ich-aha-2022',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/35579034/',
  'Greenberg SM, et al. 2022 Guideline for the Management of Patients With Spontaneous Intracerebral Hemorrhage. AHA/ASA. Stroke 2022;53:e282.',
  null,
  null,
  'Greenberg SM, et al. 2022 Guideline for the Management of Patients With Spontaneous Intracerebral Hemorrhage. AHA/ASA. Stroke 2022;53:e282.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ida-camaschella-2015-26935e2f4e8d',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/25946282/',
  'Camaschella C, Iron-deficiency anemia, N Engl J Med 2015;372:1832-1843.',
  null,
  null,
  'Camaschella C, Iron-deficiency anemia, N Engl J Med 2015;372:1832-1843.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ida-camaschella-2015-baab7910198e',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/25946282/',
  'Camaschella C. Iron-deficiency anemia. N Engl J Med 2015;372:1832-43.',
  null,
  null,
  'Camaschella C. Iron-deficiency anemia. N Engl J Med 2015;372:1832-43.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-kdigo-aki-2012',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/22890468/',
  'KDIGO Clinical Practice Guideline for Acute Kidney Injury. Kidney Int Suppl 2012.',
  null,
  null,
  'KDIGO Clinical Practice Guideline for Acute Kidney Injury. Kidney Int Suppl 2012.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-kham-dau-nua-dau-can-duong-1',
  '1.0.0',
  'other',
  'International Headache Society, The International Classification of Headache Disorders, 3rd edition (ICHD-3), 2018.',
  'International Headache Society, The International Classification of Headache Disorders, 3rd edition (ICHD-3), 2018.',
  null,
  null,
  'International Headache Society, The International Classification of Headache Disorders, 3rd edition (ICHD-3), 2018.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-kham-dau-nua-dau-can-duong-2',
  '1.0.0',
  'other',
  'American Headache Society, The American Headache Society Position Statement on Integrating New Migraine Treatments Into Clinical Practice, 2021.',
  'American Headache Society, The American Headache Society Position Statement on Integrating New Migraine Treatments Into Clinical Practice, 2021.',
  null,
  null,
  'American Headache Society, The American Headache Society Position Statement on Integrating New Migraine Treatments Into Clinical Practice, 2021.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-kham-nhi-bieng-an-ty-hu-1',
  '1.0.0',
  'other',
  'World Health Organization, Guideline on Haemoglobin Cutoffs to Define Anaemia in Individuals and Populations, 2024.',
  'World Health Organization, Guideline on Haemoglobin Cutoffs to Define Anaemia in Individuals and Populations, 2024.',
  null,
  null,
  'World Health Organization, Guideline on Haemoglobin Cutoffs to Define Anaemia in Individuals and Populations, 2024.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-kham-nhi-bieng-an-ty-hu-2',
  '1.0.0',
  'other',
  'World Health Organization, WHO Guideline on Use of Ferritin Concentrations to Assess Iron Status in Individuals and Populations, 2020.',
  'World Health Organization, WHO Guideline on Use of Ferritin Concentrations to Assess Iron Status in Individuals and Populations, 2020.',
  null,
  null,
  'World Health Organization, WHO Guideline on Use of Ferritin Concentrations to Assess Iron Status in Individuals and Populations, 2020.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-kham-tao-bon-man-cao-tuoi-da-benh-1',
  '1.0.0',
  'other',
  'American Gastroenterological Association and American College of Gastroenterology, Clinical Practice Guideline: Pharmacological Management of Chronic Idiopathic Constipation, 2023.',
  'American Gastroenterological Association and American College of Gastroenterology, Clinical Practice Guideline: Pharmacological Management of Chronic Idiopathic Constipation, 2023.',
  null,
  null,
  'American Gastroenterological Association and American College of Gastroenterology, Clinical Practice Guideline: Pharmacological Management of Chronic Idiopathic Constipation, 2023.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-kham-thong-kinh-khi-tre-huyet-u-1',
  '1.0.0',
  'other',
  'American College of Obstetricians and Gynecologists, Committee Opinion No. 760: Dysmenorrhea and Endometriosis in the Adolescent, 2018.',
  'American College of Obstetricians and Gynecologists, Committee Opinion No. 760: Dysmenorrhea and Endometriosis in the Adolescent, 2018.',
  null,
  null,
  'American College of Obstetricians and Gynecologists, Committee Opinion No. 760: Dysmenorrhea and Endometriosis in the Adolescent, 2018.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-kham-thong-ta-ruot-kich-thich-1',
  '1.0.0',
  'other',
  'American College of Gastroenterology, ACG Clinical Guideline: Management of Irritable Bowel Syndrome, 2021.',
  'American College of Gastroenterology, ACG Clinical Guideline: Management of Irritable Bowel Syndrome, 2021.',
  null,
  null,
  'American College of Gastroenterology, ACG Clinical Guideline: Management of Irritable Bowel Syndrome, 2021.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-kham-thong-ta-ruot-kich-thich-2',
  '1.0.0',
  'other',
  'Rome Foundation, Rome IV Functional Gastrointestinal Disorders, 2016.',
  'Rome Foundation, Rome IV Functional Gastrointestinal Disorders, 2016.',
  null,
  null,
  'Rome Foundation, Rome IV Functional Gastrointestinal Disorders, 2016.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-kham-tieu-khat-dai-thao-duong-tip-2-1',
  '1.0.0',
  'other',
  'American Diabetes Association, Standards of Care in Diabetes—2025, Diabetes Care.',
  'American Diabetes Association, Standards of Care in Diabetes—2025, Diabetes Care.',
  null,
  null,
  'American Diabetes Association, Standards of Care in Diabetes—2025, Diabetes Care.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-kham-tyc-viem-mui-di-ung-1',
  '1.0.0',
  'other',
  'American Academy of Otolaryngology–Head and Neck Surgery Foundation, Clinical Practice Guideline: Allergic Rhinitis, 2015.',
  'American Academy of Otolaryngology–Head and Neck Surgery Foundation, Clinical Practice Guideline: Allergic Rhinitis, 2015.',
  null,
  null,
  'American Academy of Otolaryngology–Head and Neck Surgery Foundation, Clinical Practice Guideline: Allergic Rhinitis, 2015.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-lavage-aact-2013',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/23418938/',
  'AACT/EAPCCT, Position Paper Update: Gastric Lavage for Gastrointestinal Decontamination, 2013.',
  null,
  null,
  'AACT/EAPCCT, Position Paper Update: Gastric Lavage for Gastrointestinal Decontamination, 2013.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-limb-esvs-2020',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/31899099/',
  'Björck M và cs. Editor''s Choice: European Society for Vascular Surgery 2020 Clinical Practice Guidelines on the Management of Acute Limb Ischaemia. Eur J Vasc Endovasc Surg, 2020.',
  null,
  null,
  'Björck M và cs. Editor''s Choice: European Society for Vascular Surgery 2020 Clinical Practice Guidelines on the Management of Acute Limb Ischaemia. Eur J Vasc Endovasc Surg, 2020.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-mat-ngu-tam-ty-luong-hu-1',
  '1.0.0',
  'other',
  'European Sleep Research Society và European Insomnia Network, The European Insomnia Guideline: An update on the diagnosis and treatment of insomnia, 2023.',
  'European Sleep Research Society và European Insomnia Network, The European Insomnia Guideline: An update on the diagnosis and treatment of insomnia, 2023.',
  null,
  null,
  'European Sleep Research Society và European Insomnia Network, The European Insomnia Guideline: An update on the diagnosis and treatment of insomnia, 2023.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-meningitis-escmid-2016',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/27062097/',
  'van de Beek D, et al. ESCMID guideline: diagnosis and treatment of acute bacterial meningitis. Clin Microbiol Infect 2016;22 Suppl 3:S37-62.',
  null,
  null,
  'van de Beek D, et al. ESCMID guideline: diagnosis and treatment of acute bacterial meningitis. Clin Microbiol Infect 2016;22 Suppl 3:S37-62.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-meningitis-idsa-2004',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/15494903/',
  'Tunkel AR, et al. Practice guidelines for the management of bacterial meningitis. IDSA. Clin Infect Dis 2004;39:1267-84.',
  null,
  null,
  'Tunkel AR, et al. Practice guidelines for the management of bacterial meningitis. IDSA. Clin Infect Dis 2004;39:1267-84.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-methanol-aact-2002',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/12216995/',
  'Barceloux DG et al. American Academy of Clinical Toxicology practice guidelines on the treatment of methanol poisoning. J Toxicol Clin Toxicol 2002;40:415-446.',
  null,
  null,
  'Barceloux DG et al. American Academy of Clinical Toxicology practice guidelines on the treatment of methanol poisoning. J Toxicol Clin Toxicol 2002;40:415-446.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-methanol-ectr-2015',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/25493973/',
  'Roberts DM et al. Recommendations for the role of extracorporeal treatments in the management of acute methanol poisoning: a systematic review and consensus statement (EXTRIP). Crit Care Med 2015;43:461-472.',
  null,
  null,
  'Roberts DM et al. Recommendations for the role of extracorporeal treatments in the management of acute methanol poisoning: a systematic review and consensus statement (EXTRIP). Crit Care Med 2015;43:461-472.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-bung-001-2',
  '1.0.0',
  'textbook',
  'Giáo trình Bệnh học Ngoại khoa, Đại học Y Hà Nội, phần Cấp cứu bụng - Viêm ruột thừa cấp.',
  'Giáo trình Bệnh học Ngoại khoa, Đại học Y Hà Nội, phần Cấp cứu bụng - Viêm ruột thừa cấp.',
  null,
  null,
  'Giáo trình Bệnh học Ngoại khoa, Đại học Y Hà Nội, phần Cấp cứu bụng - Viêm ruột thừa cấp.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-bung-001-3',
  '1.0.0',
  'textbook',
  'Townsend CM et al. Sabiston Textbook of Surgery, 21st edition, 2022, chương Appendix.',
  'Townsend CM et al. Sabiston Textbook of Surgery, 21st edition, 2022, chương Appendix.',
  null,
  null,
  'Townsend CM et al. Sabiston Textbook of Surgery, 21st edition, 2022, chương Appendix.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-bung-002-2',
  '1.0.0',
  'textbook',
  'Giáo trình Bệnh học Ngoại khoa, Đại học Y Hà Nội, bài Tắc ruột.',
  'Giáo trình Bệnh học Ngoại khoa, Đại học Y Hà Nội, bài Tắc ruột.',
  null,
  null,
  'Giáo trình Bệnh học Ngoại khoa, Đại học Y Hà Nội, bài Tắc ruột.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-bung-002-3',
  '1.0.0',
  'textbook',
  'Townsend CM et al. Sabiston Textbook of Surgery, 21st edition, 2022, chương Small Intestine.',
  'Townsend CM et al. Sabiston Textbook of Surgery, 21st edition, 2022, chương Small Intestine.',
  null,
  null,
  'Townsend CM et al. Sabiston Textbook of Surgery, 21st edition, 2022, chương Small Intestine.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-bung-003-1',
  '1.0.0',
  'other',
  'HerniaSurge Group. International guidelines for groin hernia management. Hernia 2018.',
  'HerniaSurge Group. International guidelines for groin hernia management. Hernia 2018.',
  null,
  null,
  'HerniaSurge Group. International guidelines for groin hernia management. Hernia 2018.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-bung-003-2',
  '1.0.0',
  'textbook',
  'Giáo trình Bệnh học Ngoại khoa, Đại học Y Hà Nội, bài Thoát vị thành bụng.',
  'Giáo trình Bệnh học Ngoại khoa, Đại học Y Hà Nội, bài Thoát vị thành bụng.',
  null,
  null,
  'Giáo trình Bệnh học Ngoại khoa, Đại học Y Hà Nội, bài Thoát vị thành bụng.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-bung-003-3',
  '1.0.0',
  'textbook',
  'Townsend CM et al. Sabiston Textbook of Surgery, 21st edition, 2022, chương Abdominal Wall, Umbilicus, Hernia.',
  'Townsend CM et al. Sabiston Textbook of Surgery, 21st edition, 2022, chương Abdominal Wall, Umbilicus, Hernia.',
  null,
  null,
  'Townsend CM et al. Sabiston Textbook of Surgery, 21st edition, 2022, chương Abdominal Wall, Umbilicus, Hernia.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-bung-004-3',
  '1.0.0',
  'textbook',
  'Giáo trình Bệnh học Ngoại khoa, Đại học Y Hà Nội, bài Sỏi mật và viêm túi mật.',
  'Giáo trình Bệnh học Ngoại khoa, Đại học Y Hà Nội, bài Sỏi mật và viêm túi mật.',
  null,
  null,
  'Giáo trình Bệnh học Ngoại khoa, Đại học Y Hà Nội, bài Sỏi mật và viêm túi mật.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-bung-005-3',
  '1.0.0',
  'other',
  'ESGE Clinical Guideline: Endoscopic management of common bile duct stones, 2019.',
  'ESGE Clinical Guideline: Endoscopic management of common bile duct stones, 2019.',
  null,
  null,
  'ESGE Clinical Guideline: Endoscopic management of common bile duct stones, 2019.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-bung-007-2',
  '1.0.0',
  'other',
  'van Hooft JE et al. Self-expandable metal stents for obstructing colonic and extracolonic cancer: ESGE Clinical Guideline update. Endoscopy 2020.',
  'van Hooft JE et al. Self-expandable metal stents for obstructing colonic and extracolonic cancer: ESGE Clinical Guideline update. Endoscopy 2020.',
  null,
  null,
  'van Hooft JE et al. Self-expandable metal stents for obstructing colonic and extracolonic cancer: ESGE Clinical Guideline update. Endoscopy 2020.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-bung-007-3',
  '1.0.0',
  'other',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị ung thư đại trực tràng, Quyết định hiện hành.',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị ung thư đại trực tràng, Quyết định hiện hành.',
  null,
  null,
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị ung thư đại trực tràng, Quyết định hiện hành.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-bung-008-2',
  '1.0.0',
  'textbook',
  'Giáo trình Bệnh học Ngoại khoa, Đại học Y Hà Nội, bài Áp xe hậu môn và rò hậu môn.',
  'Giáo trình Bệnh học Ngoại khoa, Đại học Y Hà Nội, bài Áp xe hậu môn và rò hậu môn.',
  null,
  null,
  'Giáo trình Bệnh học Ngoại khoa, Đại học Y Hà Nội, bài Áp xe hậu môn và rò hậu môn.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-bung-008-3',
  '1.0.0',
  'textbook',
  'Townsend CM et al. Sabiston Textbook of Surgery, 21st edition, 2022, chương Anus.',
  'Townsend CM et al. Sabiston Textbook of Surgery, 21st edition, 2022, chương Anus.',
  null,
  null,
  'Townsend CM et al. Sabiston Textbook of Surgery, 21st edition, 2022, chương Anus.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-001-1',
  '1.0.0',
  'other',
  'ATLS 10th Edition (American College of Surgeons), Chapter 4: Thoracic Trauma, 2018',
  'ATLS 10th Edition (American College of Surgeons), Chapter 4: Thoracic Trauma, 2018',
  null,
  null,
  'ATLS 10th Edition (American College of Surgeons), Chapter 4: Thoracic Trauma, 2018',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-001-2',
  '1.0.0',
  'other',
  'Hướng dẫn quy trình cấp cứu chấn thương ngực của Bộ Y tế Việt Nam (tên hướng dẫn; số quyết định xem can_doi_chieu)',
  'Hướng dẫn quy trình cấp cứu chấn thương ngực của Bộ Y tế Việt Nam (tên hướng dẫn; số quyết định xem can_doi_chieu)',
  null,
  null,
  'Hướng dẫn quy trình cấp cứu chấn thương ngực của Bộ Y tế Việt Nam (tên hướng dẫn; số quyết định xem can_doi_chieu)',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-001-3',
  '1.0.0',
  'other',
  'EAST Practice Management Guidelines: Penetrating thoracic trauma, nhóm tác giả EAST',
  'EAST Practice Management Guidelines: Penetrating thoracic trauma, nhóm tác giả EAST',
  null,
  null,
  'EAST Practice Management Guidelines: Penetrating thoracic trauma, nhóm tác giả EAST',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-002-1',
  '1.0.0',
  'other',
  'ATLS 10th Edition (American College of Surgeons), Chapter 4: Thoracic Trauma, 2018',
  'ATLS 10th Edition (American College of Surgeons), Chapter 4: Thoracic Trauma, 2018',
  null,
  null,
  'ATLS 10th Edition (American College of Surgeons), Chapter 4: Thoracic Trauma, 2018',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-002-2',
  '1.0.0',
  'other',
  'BTS Pleural Disease Guideline 2010 (Thorax 2010; 65 Suppl 2)',
  'BTS Pleural Disease Guideline 2010 (Thorax 2010; 65 Suppl 2)',
  null,
  null,
  'BTS Pleural Disease Guideline 2010 (Thorax 2010; 65 Suppl 2)',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-002-3',
  '1.0.0',
  'other',
  'Hướng dẫn quy trình kỹ thuật dẫn lưu màng phổi và xử trí tràn khí màng phổi của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu)',
  'Hướng dẫn quy trình kỹ thuật dẫn lưu màng phổi và xử trí tràn khí màng phổi của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu)',
  null,
  null,
  'Hướng dẫn quy trình kỹ thuật dẫn lưu màng phổi và xử trí tràn khí màng phổi của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu)',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-003-1',
  '1.0.0',
  'other',
  'ATLS 10th Edition (American College of Surgeons), Chapter 2: Initial Assessment and Management; Chapter 3 và phụ lục Facial Trauma, 2018',
  'ATLS 10th Edition (American College of Surgeons), Chapter 2: Initial Assessment and Management; Chapter 3 và phụ lục Facial Trauma, 2018',
  null,
  null,
  'ATLS 10th Edition (American College of Surgeons), Chapter 2: Initial Assessment and Management; Chapter 3 và phụ lục Facial Trauma, 2018',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-003-3',
  '1.0.0',
  'other',
  'Hướng dẫn quy trình cấp cứu chấn thương hàm mặt và kiểm soát đường thở của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu)',
  'Hướng dẫn quy trình cấp cứu chấn thương hàm mặt và kiểm soát đường thở của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu)',
  null,
  null,
  'Hướng dẫn quy trình cấp cứu chấn thương hàm mặt và kiểm soát đường thở của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu)',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-004-1',
  '1.0.0',
  'other',
  'ATLS 10th Edition (American College of Surgeons), Chapter 3: Shock, 2018',
  'ATLS 10th Edition (American College of Surgeons), Chapter 3: Shock, 2018',
  null,
  null,
  'ATLS 10th Edition (American College of Surgeons), Chapter 3: Shock, 2018',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-004-2',
  '1.0.0',
  'other',
  'Stop the Bleed / Hướng dẫn kiểm soát chảy máu ngoại của Hội Phẫu thuật Chấn thương Hoa Kỳ, 2015 (ACS Committee on Trauma)',
  'Stop the Bleed / Hướng dẫn kiểm soát chảy máu ngoại của Hội Phẫu thuật Chấn thương Hoa Kỳ, 2015 (ACS Committee on Trauma)',
  null,
  null,
  'Stop the Bleed / Hướng dẫn kiểm soát chảy máu ngoại của Hội Phẫu thuật Chấn thương Hoa Kỳ, 2015 (ACS Committee on Trauma)',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-004-3',
  '1.0.0',
  'other',
  'Hướng dẫn quy trình cấp cứu chấn thương chi và cầm máu của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu)',
  'Hướng dẫn quy trình cấp cứu chấn thương chi và cầm máu của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu)',
  null,
  null,
  'Hướng dẫn quy trình cấp cứu chấn thương chi và cầm máu của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu)',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-005-1',
  '1.0.0',
  'other',
  'Hội chứng khoang cấp: AAOS, Journal of the American Academy of Orthopaedic Surgeons, 2005 (Compartment syndrome review)',
  'Hội chứng khoang cấp: AAOS, Journal of the American Academy of Orthopaedic Surgeons, 2005 (Compartment syndrome review)',
  null,
  null,
  'Hội chứng khoang cấp: AAOS, Journal of the American Academy of Orthopaedic Surgeons, 2005 (Compartment syndrome review)',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-005-2',
  '1.0.0',
  'other',
  'ATLS 10th Edition (American College of Surgeons), Chapter 7: Musculoskeletal Trauma, 2018',
  'ATLS 10th Edition (American College of Surgeons), Chapter 7: Musculoskeletal Trauma, 2018',
  null,
  null,
  'ATLS 10th Edition (American College of Surgeons), Chapter 7: Musculoskeletal Trauma, 2018',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-005-3',
  '1.0.0',
  'other',
  'Hướng dẫn chẩn đoán và điều trị gãy xương và hội chứng khoang của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu)',
  'Hướng dẫn chẩn đoán và điều trị gãy xương và hội chứng khoang của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu)',
  null,
  null,
  'Hướng dẫn chẩn đoán và điều trị gãy xương và hội chứng khoang của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu)',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-006-1',
  '1.0.0',
  'other',
  'ATLS 10th Edition (American College of Surgeons), Chapter 7: Musculoskeletal Trauma, 2018',
  'ATLS 10th Edition (American College of Surgeons), Chapter 7: Musculoskeletal Trauma, 2018',
  null,
  null,
  'ATLS 10th Edition (American College of Surgeons), Chapter 7: Musculoskeletal Trauma, 2018',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-006-2',
  '1.0.0',
  'other',
  'BOAST 4: The Management of Severe Open Lower Limb Fractures (British Orthopaedic Association and BAPRAS), 2017',
  'BOAST 4: The Management of Severe Open Lower Limb Fractures (British Orthopaedic Association and BAPRAS), 2017',
  null,
  null,
  'BOAST 4: The Management of Severe Open Lower Limb Fractures (British Orthopaedic Association and BAPRAS), 2017',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-008-1',
  '1.0.0',
  'other',
  'ATLS 10th Edition (American College of Surgeons), Chapter 5: Abdominal and Pelvic Trauma, 2018',
  'ATLS 10th Edition (American College of Surgeons), Chapter 5: Abdominal and Pelvic Trauma, 2018',
  null,
  null,
  'ATLS 10th Edition (American College of Surgeons), Chapter 5: Abdominal and Pelvic Trauma, 2018',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-008-3',
  '1.0.0',
  'other',
  'Hướng dẫn quy trình cấp cứu chấn thương bụng của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu)',
  'Hướng dẫn quy trình cấp cứu chấn thương bụng của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu)',
  null,
  null,
  'Hướng dẫn quy trình cấp cứu chấn thương bụng của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu)',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-101-3',
  '1.0.0',
  'other',
  'Hướng dẫn chẩn đoán và điều trị nhiễm khuẩn huyết, sốc nhiễm khuẩn của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  'Hướng dẫn chẩn đoán và điều trị nhiễm khuẩn huyết, sốc nhiễm khuẩn của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  null,
  null,
  'Hướng dẫn chẩn đoán và điều trị nhiễm khuẩn huyết, sốc nhiễm khuẩn của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-102-3',
  '1.0.0',
  'other',
  'Hướng dẫn quy trình chẩn đoán và điều trị hội chứng tắc ruột cấp của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  'Hướng dẫn quy trình chẩn đoán và điều trị hội chứng tắc ruột cấp của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  null,
  null,
  'Hướng dẫn quy trình chẩn đoán và điều trị hội chứng tắc ruột cấp của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-103-1',
  '1.0.0',
  'other',
  'EAU Guidelines on Urological Infections (European Association of Urology), mục urosepsis và tắc nghẽn đường tiết niệu.',
  'EAU Guidelines on Urological Infections (European Association of Urology), mục urosepsis và tắc nghẽn đường tiết niệu.',
  null,
  null,
  'EAU Guidelines on Urological Infections (European Association of Urology), mục urosepsis và tắc nghẽn đường tiết niệu.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-103-3',
  '1.0.0',
  'other',
  'Hướng dẫn chẩn đoán và điều trị nhiễm khuẩn huyết, sốc nhiễm khuẩn của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  'Hướng dẫn chẩn đoán và điều trị nhiễm khuẩn huyết, sốc nhiễm khuẩn của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  null,
  null,
  'Hướng dẫn chẩn đoán và điều trị nhiễm khuẩn huyết, sốc nhiễm khuẩn của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-104-1',
  '1.0.0',
  'other',
  'Hướng dẫn chẩn đoán và điều trị xuất huyết tiêu hóa trên không do tăng áp lực tĩnh mạch cửa của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  'Hướng dẫn chẩn đoán và điều trị xuất huyết tiêu hóa trên không do tăng áp lực tĩnh mạch cửa của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  null,
  null,
  'Hướng dẫn chẩn đoán và điều trị xuất huyết tiêu hóa trên không do tăng áp lực tĩnh mạch cửa của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-105-2',
  '1.0.0',
  'other',
  'ATLS 10th Edition (American College of Surgeons), Chapter 6: Head Trauma, 2018.',
  'ATLS 10th Edition (American College of Surgeons), Chapter 6: Head Trauma, 2018.',
  null,
  null,
  'ATLS 10th Edition (American College of Surgeons), Chapter 6: Head Trauma, 2018.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-105-3',
  '1.0.0',
  'other',
  'Hướng dẫn quy trình xử trí chấn thương sọ não của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  'Hướng dẫn quy trình xử trí chấn thương sọ não của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  null,
  null,
  'Hướng dẫn quy trình xử trí chấn thương sọ não của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-106-1',
  '1.0.0',
  'other',
  'ATLS 10th Edition (American College of Surgeons), Chapter 7: Spine and Spinal Cord Trauma, 2018.',
  'ATLS 10th Edition (American College of Surgeons), Chapter 7: Spine and Spinal Cord Trauma, 2018.',
  null,
  null,
  'ATLS 10th Edition (American College of Surgeons), Chapter 7: Spine and Spinal Cord Trauma, 2018.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-106-2',
  '1.0.0',
  'other',
  'Guidelines for the management of acute cervical spine and spinal cord injuries: 2013 update, Neurosurgery 2013; và Congress of Neurological Surgeons 2013 guidelines. DOI: 10.1227/NEU.0b013e3182a7d4ba.',
  'Guidelines for the management of acute cervical spine and spinal cord injuries: 2013 update, Neurosurgery 2013; và Congress of Neurological Surgeons 2013 guidelines. DOI: 10.1227/NEU.0b013e3182a7d4ba.',
  null,
  null,
  'Guidelines for the management of acute cervical spine and spinal cord injuries: 2013 update, Neurosurgery 2013; và Congress of Neurological Surgeons 2013 guidelines. DOI: 10.1227/NEU.0b013e3182a7d4ba.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-106-3',
  '1.0.0',
  'other',
  'Hướng dẫn quy trình xử trí chấn thương cột sống và tủy sống của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  'Hướng dẫn quy trình xử trí chấn thương cột sống và tủy sống của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  null,
  null,
  'Hướng dẫn quy trình xử trí chấn thương cột sống và tủy sống của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-107-2',
  '1.0.0',
  'other',
  'Pediatric Advanced Life Support (PALS) guideline: sốc giảm thể tích ở trẻ em, American Heart Association 2020.',
  'Pediatric Advanced Life Support (PALS) guideline: sốc giảm thể tích ở trẻ em, American Heart Association 2020.',
  null,
  null,
  'Pediatric Advanced Life Support (PALS) guideline: sốc giảm thể tích ở trẻ em, American Heart Association 2020.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-107-3',
  '1.0.0',
  'other',
  'Hướng dẫn xử trí sốc ở trẻ em của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  'Hướng dẫn xử trí sốc ở trẻ em của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  null,
  null,
  'Hướng dẫn xử trí sốc ở trẻ em của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-108-2',
  '1.0.0',
  'other',
  'ESVS Clinical Practice Guidelines on the Management of Diseases of the Mesenteric and Renal Arteries and Veins, Eur J Vasc Endovasc Surg 2017. DOI: 10.1016/j.ejvs.2017.06.017.',
  'ESVS Clinical Practice Guidelines on the Management of Diseases of the Mesenteric and Renal Arteries and Veins, Eur J Vasc Endovasc Surg 2017. DOI: 10.1016/j.ejvs.2017.06.017.',
  null,
  null,
  'ESVS Clinical Practice Guidelines on the Management of Diseases of the Mesenteric and Renal Arteries and Veins, Eur J Vasc Endovasc Surg 2017. DOI: 10.1016/j.ejvs.2017.06.017.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-cap-cuu-108-3',
  '1.0.0',
  'other',
  'Hướng dẫn chẩn đoán và điều trị rung nhĩ và bệnh động mạch của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  'Hướng dẫn chẩn đoán và điều trị rung nhĩ và bệnh động mạch của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  null,
  null,
  'Hướng dẫn chẩn đoán và điều trị rung nhĩ và bệnh động mạch của Bộ Y tế Việt Nam (số quyết định xem can_doi_chieu).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-001-1',
  '1.0.0',
  'other',
  'ATLS 10th edition, American College of Surgeons, 2018: chương Chấn thương đầu.',
  'ATLS 10th edition, American College of Surgeons, 2018: chương Chấn thương đầu.',
  null,
  null,
  'ATLS 10th edition, American College of Surgeons, 2018: chương Chấn thương đầu.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-001-3',
  '1.0.0',
  'textbook',
  'Giáo trình Ngoại bệnh lý (Đại học Y Hà Nội và Đại học Y Dược TP.HCM): bài Chấn thương sọ não.',
  'Giáo trình Ngoại bệnh lý (Đại học Y Hà Nội và Đại học Y Dược TP.HCM): bài Chấn thương sọ não.',
  null,
  null,
  'Giáo trình Ngoại bệnh lý (Đại học Y Hà Nội và Đại học Y Dược TP.HCM): bài Chấn thương sọ não.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-002-1',
  '1.0.0',
  'other',
  'Bộ Y tế: Hướng dẫn chẩn đoán và điều trị loãng xương (cập nhật).',
  'Bộ Y tế: Hướng dẫn chẩn đoán và điều trị loãng xương (cập nhật).',
  null,
  null,
  'Bộ Y tế: Hướng dẫn chẩn đoán và điều trị loãng xương (cập nhật).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-002-2',
  '1.0.0',
  'textbook',
  'Giáo trình Chấn thương chỉnh hình, Đại học Y Hà Nội: bài Gãy cổ xương đùi.',
  'Giáo trình Chấn thương chỉnh hình, Đại học Y Hà Nội: bài Gãy cổ xương đùi.',
  null,
  null,
  'Giáo trình Chấn thương chỉnh hình, Đại học Y Hà Nội: bài Gãy cổ xương đùi.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-002-4',
  '1.0.0',
  'other',
  'AAOS Management of Hip Fractures in Older Adults, 2021.',
  'AAOS Management of Hip Fractures in Older Adults, 2021.',
  null,
  null,
  'AAOS Management of Hip Fractures in Older Adults, 2021.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-003-1',
  '1.0.0',
  'textbook',
  'Giáo trình Chấn thương chỉnh hình, Đại học Y Hà Nội: bài Gãy hai xương cẳng tay.',
  'Giáo trình Chấn thương chỉnh hình, Đại học Y Hà Nội: bài Gãy hai xương cẳng tay.',
  null,
  null,
  'Giáo trình Chấn thương chỉnh hình, Đại học Y Hà Nội: bài Gãy hai xương cẳng tay.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-003-2',
  '1.0.0',
  'textbook',
  'Rockwood and Green''s Fractures in Adults, 9th edition, 2019: chương Fractures of the shafts of the radius and ulna.',
  'Rockwood and Green''s Fractures in Adults, 9th edition, 2019: chương Fractures of the shafts of the radius and ulna.',
  null,
  null,
  'Rockwood and Green''s Fractures in Adults, 9th edition, 2019: chương Fractures of the shafts of the radius and ulna.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-003-3',
  '1.0.0',
  'other',
  'ATLS 10th edition, American College of Surgeons, 2018: phần Chấn thương cơ xương khớp.',
  'ATLS 10th edition, American College of Surgeons, 2018: phần Chấn thương cơ xương khớp.',
  null,
  null,
  'ATLS 10th edition, American College of Surgeons, 2018: phần Chấn thương cơ xương khớp.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-004-1',
  '1.0.0',
  'other',
  'ATLS 10th edition, American College of Surgeons, 2018: chương Thoracic Trauma.',
  'ATLS 10th edition, American College of Surgeons, 2018: chương Thoracic Trauma.',
  null,
  null,
  'ATLS 10th edition, American College of Surgeons, 2018: chương Thoracic Trauma.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-004-2',
  '1.0.0',
  'textbook',
  'Giáo trình Ngoại bệnh lý, Đại học Y Dược TP.HCM: bài Chấn thương ngực.',
  'Giáo trình Ngoại bệnh lý, Đại học Y Dược TP.HCM: bài Chấn thương ngực.',
  null,
  null,
  'Giáo trình Ngoại bệnh lý, Đại học Y Dược TP.HCM: bài Chấn thương ngực.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-004-3',
  '1.0.0',
  'other',
  'Bộ Y tế: Hướng dẫn quy trình kỹ thuật chuyên ngành ngoại khoa (dẫn lưu màng phổi).',
  'Bộ Y tế: Hướng dẫn quy trình kỹ thuật chuyên ngành ngoại khoa (dẫn lưu màng phổi).',
  null,
  null,
  'Bộ Y tế: Hướng dẫn quy trình kỹ thuật chuyên ngành ngoại khoa (dẫn lưu màng phổi).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-005-1',
  '1.0.0',
  'other',
  'Bộ Y tế: Hướng dẫn chẩn đoán và điều trị bỏng.',
  'Bộ Y tế: Hướng dẫn chẩn đoán và điều trị bỏng.',
  null,
  null,
  'Bộ Y tế: Hướng dẫn chẩn đoán và điều trị bỏng.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-005-2',
  '1.0.0',
  'other',
  'American Burn Association: Advanced Burn Life Support (ABLS) Provider Manual, 2018.',
  'American Burn Association: Advanced Burn Life Support (ABLS) Provider Manual, 2018.',
  null,
  null,
  'American Burn Association: Advanced Burn Life Support (ABLS) Provider Manual, 2018.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-005-3',
  '1.0.0',
  'other',
  'International Society for Burn Injuries: ISBI Practice Guidelines for Burn Care, 2016.',
  'International Society for Burn Injuries: ISBI Practice Guidelines for Burn Care, 2016.',
  null,
  null,
  'International Society for Burn Injuries: ISBI Practice Guidelines for Burn Care, 2016.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-005-4',
  '1.0.0',
  'other',
  'ATLS 10th edition, American College of Surgeons, 2018: chương Thermal Injuries.',
  'ATLS 10th edition, American College of Surgeons, 2018: chương Thermal Injuries.',
  null,
  null,
  'ATLS 10th edition, American College of Surgeons, 2018: chương Thermal Injuries.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-006-1',
  '1.0.0',
  'other',
  'Bộ Y tế: Hướng dẫn chẩn đoán và điều trị bệnh uốn ván; Chương trình tiêm chủng mở rộng quốc gia.',
  'Bộ Y tế: Hướng dẫn chẩn đoán và điều trị bệnh uốn ván; Chương trình tiêm chủng mở rộng quốc gia.',
  null,
  null,
  'Bộ Y tế: Hướng dẫn chẩn đoán và điều trị bệnh uốn ván; Chương trình tiêm chủng mở rộng quốc gia.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-006-3',
  '1.0.0',
  'other',
  'CDC: Updated Recommendations for Use of Tetanus Toxoid, Reduced Diphtheria Toxoid, and Acellular Pertussis Vaccine (MMWR 2018) và hướng dẫn xử trí vết thương.',
  'CDC: Updated Recommendations for Use of Tetanus Toxoid, Reduced Diphtheria Toxoid, and Acellular Pertussis Vaccine (MMWR 2018) và hướng dẫn xử trí vết thương.',
  null,
  null,
  'CDC: Updated Recommendations for Use of Tetanus Toxoid, Reduced Diphtheria Toxoid, and Acellular Pertussis Vaccine (MMWR 2018) và hướng dẫn xử trí vết thương.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-006-4',
  '1.0.0',
  'textbook',
  'Giáo trình Ngoại bệnh lý, Đại học Y Hà Nội: bài Vết thương phần mềm.',
  'Giáo trình Ngoại bệnh lý, Đại học Y Hà Nội: bài Vết thương phần mềm.',
  null,
  null,
  'Giáo trình Ngoại bệnh lý, Đại học Y Hà Nội: bài Vết thương phần mềm.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-007-1',
  '1.0.0',
  'other',
  'ATLS 10th edition, American College of Surgeons, 2018: chương Shock và Musculoskeletal Trauma.',
  'ATLS 10th edition, American College of Surgeons, 2018: chương Shock và Musculoskeletal Trauma.',
  null,
  null,
  'ATLS 10th edition, American College of Surgeons, 2018: chương Shock và Musculoskeletal Trauma.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-007-3',
  '1.0.0',
  'other',
  'Bộ Y tế: Hướng dẫn quy trình xử trí chấn thương nặng và sốc chấn thương (tài liệu cấp cứu ngoại khoa).',
  'Bộ Y tế: Hướng dẫn quy trình xử trí chấn thương nặng và sốc chấn thương (tài liệu cấp cứu ngoại khoa).',
  null,
  null,
  'Bộ Y tế: Hướng dẫn quy trình xử trí chấn thương nặng và sốc chấn thương (tài liệu cấp cứu ngoại khoa).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-chan-thuong-007-4',
  '1.0.0',
  'textbook',
  'Giáo trình Ngoại bệnh lý, Đại học Y Dược TP.HCM: bài Gãy khung chậu.',
  'Giáo trình Ngoại bệnh lý, Đại học Y Dược TP.HCM: bài Gãy khung chậu.',
  null,
  null,
  'Giáo trình Ngoại bệnh lý, Đại học Y Dược TP.HCM: bài Gãy khung chậu.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-mach-001-3',
  '1.0.0',
  'textbook',
  'Giáo trình Ngoại khoa, bài Thiếu máu chi cấp, Đại học Y Dược TP.HCM.',
  'Giáo trình Ngoại khoa, bài Thiếu máu chi cấp, Đại học Y Dược TP.HCM.',
  null,
  null,
  'Giáo trình Ngoại khoa, bài Thiếu máu chi cấp, Đại học Y Dược TP.HCM.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-noi-tiet-001-4',
  '1.0.0',
  'textbook',
  'Giáo trình Ngoại khoa, bài Bệnh lý tuyến giáp, Đại học Y Hà Nội.',
  'Giáo trình Ngoại khoa, bài Bệnh lý tuyến giáp, Đại học Y Hà Nội.',
  null,
  null,
  'Giáo trình Ngoại khoa, bài Bệnh lý tuyến giáp, Đại học Y Hà Nội.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-san-001-2',
  '1.0.0',
  'other',
  'RCOG Green-top Guideline No. 62: Management of Suspected Ovarian Masses in Premenopausal Women, 2011.',
  'RCOG Green-top Guideline No. 62: Management of Suspected Ovarian Masses in Premenopausal Women, 2011.',
  null,
  null,
  'RCOG Green-top Guideline No. 62: Management of Suspected Ovarian Masses in Premenopausal Women, 2011.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-san-001-3',
  '1.0.0',
  'textbook',
  'Giáo trình Sản phụ khoa, Đại học Y Hà Nội.',
  'Giáo trình Sản phụ khoa, Đại học Y Hà Nội.',
  null,
  null,
  'Giáo trình Sản phụ khoa, Đại học Y Hà Nội.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-tiet-nieu-001-2',
  '1.0.0',
  'textbook',
  'Giáo trình Ngoại khoa, bài Sỏi tiết niệu, Đại học Y Dược TP.HCM.',
  'Giáo trình Ngoại khoa, bài Sỏi tiết niệu, Đại học Y Dược TP.HCM.',
  null,
  null,
  'Giáo trình Ngoại khoa, bài Sỏi tiết niệu, Đại học Y Dược TP.HCM.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-tiet-nieu-001-3',
  '1.0.0',
  'textbook',
  'Bệnh học Ngoại khoa Tiết niệu, Đại học Y Hà Nội.',
  'Bệnh học Ngoại khoa Tiết niệu, Đại học Y Hà Nội.',
  null,
  null,
  'Bệnh học Ngoại khoa Tiết niệu, Đại học Y Hà Nội.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-tiet-nieu-002-1',
  '1.0.0',
  'other',
  'EAU Guidelines on Non-neurogenic Male LUTS, 2024.',
  'EAU Guidelines on Non-neurogenic Male LUTS, 2024.',
  null,
  null,
  'EAU Guidelines on Non-neurogenic Male LUTS, 2024.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-tiet-nieu-002-2',
  '1.0.0',
  'textbook',
  'Giáo trình Ngoại khoa, bài U xơ tuyến tiền liệt, Đại học Y Hà Nội.',
  'Giáo trình Ngoại khoa, bài U xơ tuyến tiền liệt, Đại học Y Hà Nội.',
  null,
  null,
  'Giáo trình Ngoại khoa, bài U xơ tuyến tiền liệt, Đại học Y Hà Nội.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-tiet-nieu-002-3',
  '1.0.0',
  'other',
  'AUA Guideline: Management of Benign Prostatic Hyperplasia, 2023.',
  'AUA Guideline: Management of Benign Prostatic Hyperplasia, 2023.',
  null,
  null,
  'AUA Guideline: Management of Benign Prostatic Hyperplasia, 2023.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-tiet-nieu-003-1',
  '1.0.0',
  'other',
  'EAU Guidelines on Paediatric Urology, chương Acute Scrotum, 2024.',
  'EAU Guidelines on Paediatric Urology, chương Acute Scrotum, 2024.',
  null,
  null,
  'EAU Guidelines on Paediatric Urology, chương Acute Scrotum, 2024.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-tiet-nieu-003-2',
  '1.0.0',
  'textbook',
  'Giáo trình Ngoại khoa, bài Xoắn tinh hoàn, Đại học Y Dược TP.HCM.',
  'Giáo trình Ngoại khoa, bài Xoắn tinh hoàn, Đại học Y Dược TP.HCM.',
  null,
  null,
  'Giáo trình Ngoại khoa, bài Xoắn tinh hoàn, Đại học Y Dược TP.HCM.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-vu-001-1',
  '1.0.0',
  'other',
  'NCCN Clinical Practice Guidelines in Oncology: Breast Cancer, 2025.',
  'NCCN Clinical Practice Guidelines in Oncology: Breast Cancer, 2025.',
  null,
  null,
  'NCCN Clinical Practice Guidelines in Oncology: Breast Cancer, 2025.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-vu-001-3',
  '1.0.0',
  'other',
  'AJCC Cancer Staging Manual, 8th edition, 2017.',
  'AJCC Cancer Staging Manual, 8th edition, 2017.',
  null,
  null,
  'AJCC Cancer Staging Manual, 8th edition, 2017.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ngoai-vu-001-4',
  '1.0.0',
  'other',
  'Hướng dẫn chẩn đoán và điều trị ung thư vú, Bộ Y tế Việt Nam.',
  'Hướng dẫn chẩn đoán và điều trị ung thư vú, Bộ Y tế Việt Nam.',
  null,
  null,
  'Hướng dẫn chẩn đoán và điều trị ung thư vú, Bộ Y tế Việt Nam.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-nice-cg124',
  '1.0.0',
  'other',
  'https://www.nice.org.uk/guidance/cg124',
  'NICE guideline NG124, Hip fracture: management, 2023.',
  null,
  null,
  'NICE guideline NG124, Hip fracture: management, 2023.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-nice-cg141',
  '1.0.0',
  'guideline',
  'https://www.nice.org.uk/guidance/cg141',
  'NICE CG141, Acute upper gastrointestinal bleeding in over 16s: management, 2012, cập nhật 2016. https://www.nice.org.uk/guidance/cg141',
  null,
  null,
  'NICE CG141, Acute upper gastrointestinal bleeding in over 16s: management, 2012, cập nhật 2016. https://www.nice.org.uk/guidance/cg141',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-nice-cg184',
  '1.0.0',
  'guideline',
  'https://www.nice.org.uk/guidance/cg184',
  'NICE CG184, Gastro-oesophageal reflux disease and dyspepsia in adults: investigation and management, 2014, cập nhật 2019. https://www.nice.org.uk/guidance/cg184',
  null,
  null,
  'NICE CG184, Gastro-oesophageal reflux disease and dyspepsia in adults: investigation and management, 2014, cập nhật 2019. https://www.nice.org.uk/guidance/cg184',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-001-1',
  '1.0.0',
  'other',
  'Bộ Y tế. Hướng dẫn quy trình hồi sinh tim phổi (cấp cứu ngừng tuần hoàn) cho người lớn, các quyết định liên quan cấp cứu, hồi sức tích cực và chống độc.',
  'Bộ Y tế. Hướng dẫn quy trình hồi sinh tim phổi (cấp cứu ngừng tuần hoàn) cho người lớn, các quyết định liên quan cấp cứu, hồi sức tích cực và chống độc.',
  null,
  null,
  'Bộ Y tế. Hướng dẫn quy trình hồi sinh tim phổi (cấp cứu ngừng tuần hoàn) cho người lớn, các quyết định liên quan cấp cứu, hồi sức tích cực và chống độc.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-002-1',
  '1.0.0',
  'other',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị nhiễm khuẩn huyết và sốc nhiễm khuẩn; Hướng dẫn quy trình hồi sức cấp cứu.',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị nhiễm khuẩn huyết và sốc nhiễm khuẩn; Hướng dẫn quy trình hồi sức cấp cứu.',
  null,
  null,
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị nhiễm khuẩn huyết và sốc nhiễm khuẩn; Hướng dẫn quy trình hồi sức cấp cứu.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-002-3',
  '1.0.0',
  'other',
  'Hội Tiết niệu Thận học Việt Nam. Hướng dẫn xử trí nhiễm khuẩn tiết niệu có tắc nghẽn.',
  'Hội Tiết niệu Thận học Việt Nam. Hướng dẫn xử trí nhiễm khuẩn tiết niệu có tắc nghẽn.',
  null,
  null,
  'Hội Tiết niệu Thận học Việt Nam. Hướng dẫn xử trí nhiễm khuẩn tiết niệu có tắc nghẽn.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-003-1',
  '1.0.0',
  'other',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị động kinh; Hướng dẫn quy trình cấp cứu trạng thái động kinh.',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị động kinh; Hướng dẫn quy trình cấp cứu trạng thái động kinh.',
  null,
  null,
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị động kinh; Hướng dẫn quy trình cấp cứu trạng thái động kinh.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-003-3',
  '1.0.0',
  'other',
  'Hội Thần kinh học Việt Nam. Khuyến cáo xử trí trạng thái động kinh.',
  'Hội Thần kinh học Việt Nam. Khuyến cáo xử trí trạng thái động kinh.',
  null,
  null,
  'Hội Thần kinh học Việt Nam. Khuyến cáo xử trí trạng thái động kinh.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-004-1',
  '1.0.0',
  'other',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị đái tháo đường typ 2 (phần xử trí biến chứng cấp tính); Hướng dẫn quy trình chăm sóc, điều trị cấp cứu hôn mê tăng thẩm thấu.',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị đái tháo đường typ 2 (phần xử trí biến chứng cấp tính); Hướng dẫn quy trình chăm sóc, điều trị cấp cứu hôn mê tăng thẩm thấu.',
  null,
  null,
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị đái tháo đường typ 2 (phần xử trí biến chứng cấp tính); Hướng dẫn quy trình chăm sóc, điều trị cấp cứu hôn mê tăng thẩm thấu.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-004-3',
  '1.0.0',
  'other',
  'Hội Nội tiết và Đái tháo đường Việt Nam. Khuyến cáo xử trí biến chứng cấp tính đái tháo đường.',
  'Hội Nội tiết và Đái tháo đường Việt Nam. Khuyến cáo xử trí biến chứng cấp tính đái tháo đường.',
  null,
  null,
  'Hội Nội tiết và Đái tháo đường Việt Nam. Khuyến cáo xử trí biến chứng cấp tính đái tháo đường.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-005-1',
  '1.0.0',
  'other',
  'Bộ Y tế. Hướng dẫn quy trình kỹ thuật và xử trí rối loạn điện giải (tăng kali máu) trong hồi sức cấp cứu; Hướng dẫn chẩn đoán và điều trị bệnh thận mạn.',
  'Bộ Y tế. Hướng dẫn quy trình kỹ thuật và xử trí rối loạn điện giải (tăng kali máu) trong hồi sức cấp cứu; Hướng dẫn chẩn đoán và điều trị bệnh thận mạn.',
  null,
  null,
  'Bộ Y tế. Hướng dẫn quy trình kỹ thuật và xử trí rối loạn điện giải (tăng kali máu) trong hồi sức cấp cứu; Hướng dẫn chẩn đoán và điều trị bệnh thận mạn.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-005-3',
  '1.0.0',
  'other',
  'Hội Thận học Việt Nam. Khuyến cáo xử trí cấp cứu tăng kali máu.',
  'Hội Thận học Việt Nam. Khuyến cáo xử trí cấp cứu tăng kali máu.',
  null,
  null,
  'Hội Thận học Việt Nam. Khuyến cáo xử trí cấp cứu tăng kali máu.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-006-1',
  '1.0.0',
  'other',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị các rối loạn nhịp tim; Hướng dẫn quy trình cấp cứu nhịp chậm.',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị các rối loạn nhịp tim; Hướng dẫn quy trình cấp cứu nhịp chậm.',
  null,
  null,
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị các rối loạn nhịp tim; Hướng dẫn quy trình cấp cứu nhịp chậm.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-006-3',
  '1.0.0',
  'other',
  'Hội Tim mạch học Việt Nam. Khuyến cáo xử trí nhịp chậm.',
  'Hội Tim mạch học Việt Nam. Khuyến cáo xử trí nhịp chậm.',
  null,
  null,
  'Hội Tim mạch học Việt Nam. Khuyến cáo xử trí nhịp chậm.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-007-1',
  '1.0.0',
  'other',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị nhồi máu cơ tim cấp có ST chênh lên; Hướng dẫn xử trí sốc tim.',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị nhồi máu cơ tim cấp có ST chênh lên; Hướng dẫn xử trí sốc tim.',
  null,
  null,
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị nhồi máu cơ tim cấp có ST chênh lên; Hướng dẫn xử trí sốc tim.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-007-2',
  '1.0.0',
  'other',
  'Hội Tim mạch học Việt Nam. Khuyến cáo về chẩn đoán và điều trị nhồi máu cơ tim cấp ST chênh lên.',
  'Hội Tim mạch học Việt Nam. Khuyến cáo về chẩn đoán và điều trị nhồi máu cơ tim cấp ST chênh lên.',
  null,
  null,
  'Hội Tim mạch học Việt Nam. Khuyến cáo về chẩn đoán và điều trị nhồi máu cơ tim cấp ST chênh lên.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-008-1',
  '1.0.0',
  'other',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị hội chứng suy hô hấp cấp tiến triển (ARDS); Hướng dẫn quy trình thông khí cơ học trong hồi sức tích cực.',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị hội chứng suy hô hấp cấp tiến triển (ARDS); Hướng dẫn quy trình thông khí cơ học trong hồi sức tích cực.',
  null,
  null,
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị hội chứng suy hô hấp cấp tiến triển (ARDS); Hướng dẫn quy trình thông khí cơ học trong hồi sức tích cực.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-101-3',
  '1.0.0',
  'other',
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí ngộ độc cấp (ngộ độc paracetamol); số quyết định và năm ban hành xin đối chiếu.',
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí ngộ độc cấp (ngộ độc paracetamol); số quyết định và năm ban hành xin đối chiếu.',
  null,
  null,
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí ngộ độc cấp (ngộ độc paracetamol); số quyết định và năm ban hành xin đối chiếu.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-101-4',
  '1.0.0',
  'other',
  'UK TOXBASE. Paracetamol poisoning (hướng dẫn xử trí, bản cập nhật gần nhất).',
  'UK TOXBASE. Paracetamol poisoning (hướng dẫn xử trí, bản cập nhật gần nhất).',
  null,
  null,
  'UK TOXBASE. Paracetamol poisoning (hướng dẫn xử trí, bản cập nhật gần nhất).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-102-1',
  '1.0.0',
  'other',
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí ngộ độc cấp (ngộ độc khí CO); số quyết định và năm xin đối chiếu.',
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí ngộ độc cấp (ngộ độc khí CO); số quyết định và năm xin đối chiếu.',
  null,
  null,
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí ngộ độc cấp (ngộ độc khí CO); số quyết định và năm xin đối chiếu.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-102-4',
  '1.0.0',
  'other',
  'UK TOXBASE. Carbon monoxide poisoning (hướng dẫn xử trí).',
  'UK TOXBASE. Carbon monoxide poisoning (hướng dẫn xử trí).',
  null,
  null,
  'UK TOXBASE. Carbon monoxide poisoning (hướng dẫn xử trí).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-103-1',
  '1.0.0',
  'other',
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí rắn cắn (hồi sức cấp cứu, chống độc); số quyết định và năm ban hành xin đối chiếu.',
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí rắn cắn (hồi sức cấp cứu, chống độc); số quyết định và năm ban hành xin đối chiếu.',
  null,
  null,
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí rắn cắn (hồi sức cấp cứu, chống độc); số quyết định và năm ban hành xin đối chiếu.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-103-3',
  '1.0.0',
  'other',
  'World Health Organization. Snakebite envenoming: a strategy for prevention and control, 2019.',
  'World Health Organization. Snakebite envenoming: a strategy for prevention and control, 2019.',
  null,
  null,
  'World Health Organization. Snakebite envenoming: a strategy for prevention and control, 2019.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-104-1',
  '1.0.0',
  'other',
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí rắn cắn (rắn lục, rối loạn đông máu); số quyết định và năm ban hành xin đối chiếu.',
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí rắn cắn (rắn lục, rối loạn đông máu); số quyết định và năm ban hành xin đối chiếu.',
  null,
  null,
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí rắn cắn (rắn lục, rối loạn đông máu); số quyết định và năm ban hành xin đối chiếu.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-104-3',
  '1.0.0',
  'other',
  'Isbister GK. Procoagulant snake toxins: laboratory studies, diagnosis, and understanding snakebite coagulopathy. Semin Thromb Hemost 2009;35:93-103.',
  'Isbister GK. Procoagulant snake toxins: laboratory studies, diagnosis, and understanding snakebite coagulopathy. Semin Thromb Hemost 2009;35:93-103.',
  null,
  null,
  'Isbister GK. Procoagulant snake toxins: laboratory studies, diagnosis, and understanding snakebite coagulopathy. Semin Thromb Hemost 2009;35:93-103.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-105-1',
  '1.0.0',
  'other',
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí say nóng, say nắng (hồi sức cấp cứu); số quyết định và năm ban hành xin đối chiếu.',
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí say nóng, say nắng (hồi sức cấp cứu); số quyết định và năm ban hành xin đối chiếu.',
  null,
  null,
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí say nóng, say nắng (hồi sức cấp cứu); số quyết định và năm ban hành xin đối chiếu.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-106-1',
  '1.0.0',
  'other',
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí đuối nước (hồi sức cấp cứu); số quyết định và năm ban hành xin đối chiếu.',
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí đuối nước (hồi sức cấp cứu); số quyết định và năm ban hành xin đối chiếu.',
  null,
  null,
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí đuối nước (hồi sức cấp cứu); số quyết định và năm ban hành xin đối chiếu.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-106-2',
  '1.0.0',
  'other',
  'American Heart Association. 2020 Guidelines for CPR and Emergency Cardiovascular Care: Part 3, Special circumstances (drowning).',
  'American Heart Association. 2020 Guidelines for CPR and Emergency Cardiovascular Care: Part 3, Special circumstances (drowning).',
  null,
  null,
  'American Heart Association. 2020 Guidelines for CPR and Emergency Cardiovascular Care: Part 3, Special circumstances (drowning).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-106-4',
  '1.0.0',
  'other',
  'World Health Organization. Preventing drowning: an implementation guide, 2017.',
  'World Health Organization. Preventing drowning: an implementation guide, 2017.',
  null,
  null,
  'World Health Organization. Preventing drowning: an implementation guide, 2017.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-107-1',
  '1.0.0',
  'other',
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí ngộ độc cấp (ngộ độc methanol); số quyết định và năm ban hành xin đối chiếu.',
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí ngộ độc cấp (ngộ độc methanol); số quyết định và năm ban hành xin đối chiếu.',
  null,
  null,
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và xử trí ngộ độc cấp (ngộ độc methanol); số quyết định và năm ban hành xin đối chiếu.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-108-1',
  '1.0.0',
  'other',
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và điều trị xơ gan và biến chứng (bệnh não gan); số quyết định và năm ban hành xin đối chiếu.',
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và điều trị xơ gan và biến chứng (bệnh não gan); số quyết định và năm ban hành xin đối chiếu.',
  null,
  null,
  'Bộ Y tế Việt Nam. Hướng dẫn chẩn đoán và điều trị xơ gan và biến chứng (bệnh não gan); số quyết định và năm ban hành xin đối chiếu.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-108-3',
  '1.0.0',
  'other',
  'European Association for the Study of the Liver. EASL Clinical Practice Guidelines for the management of patients with decompensated cirrhosis. J Hepatol 2018;69:406-460.',
  'European Association for the Study of the Liver. EASL Clinical Practice Guidelines for the management of patients with decompensated cirrhosis. J Hepatol 2018;69:406-460.',
  null,
  null,
  'European Association for the Study of the Liver. EASL Clinical Practice Guidelines for the management of patients with decompensated cirrhosis. J Hepatol 2018;69:406-460.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-cap-cuu-108-4',
  '1.0.0',
  'other',
  'Ferenci P et al. Hepatic encephalopathy: definition, nomenclature, diagnosis, and quantification: final report of the working party at the 11th World Congresses of Gastroenterology, Vienna, 1998. Hepatology 2002;35:716-721.',
  'Ferenci P et al. Hepatic encephalopathy: definition, nomenclature, diagnosis, and quantification: final report of the working party at the 11th World Congresses of Gastroenterology, Vienna, 1998. Hepatology 2002;35:716-721.',
  null,
  null,
  'Ferenci P et al. Hepatic encephalopathy: definition, nomenclature, diagnosis, and quantification: final report of the working party at the 11th World Congresses of Gastroenterology, Vienna, 1998. Hepatology 2002;35:716-721.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-co-xuong-khop-001-1',
  '1.0.0',
  'other',
  'ACR/EULAR 2010 Rheumatoid Arthritis Classification Criteria, PMID 20872595: https://pubmed.ncbi.nlm.nih.gov/20872595/ . Trích: “achievement of a total score of 6 or greater (of a possible 10)”.',
  'ACR/EULAR 2010 Rheumatoid Arthritis Classification Criteria, PMID 20872595: https://pubmed.ncbi.nlm.nih.gov/20872595/ . Trích: “achievement of a total score of 6 or greater (of a possible 10)”.',
  null,
  null,
  'ACR/EULAR 2010 Rheumatoid Arthritis Classification Criteria, PMID 20872595: https://pubmed.ncbi.nlm.nih.gov/20872595/ . Trích: “achievement of a total score of 6 or greater (of a possible 10)”.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-co-xuong-khop-001-2',
  '1.0.0',
  'other',
  '2021 American College of Rheumatology Guideline for the Treatment of Rheumatoid Arthritis: https://pmc.ncbi.nlm.nih.gov/articles/PMC9273041/ . Trích: “Methotrexate monotherapy is strongly recommended over ... Hydroxychloroquine or sulfasalazine” cho người chưa dùng DMARD có hoạt tính vừa-cao; “weekly dose of at least 15 mg within 4 to 6 weeks”.',
  '2021 American College of Rheumatology Guideline for the Treatment of Rheumatoid Arthritis: https://pmc.ncbi.nlm.nih.gov/articles/PMC9273041/ . Trích: “Methotrexate monotherapy is strongly recommended over ... Hydroxychloroquine or sulfasalazine” cho người chưa dùng DMARD có hoạt tính vừa-cao; “weekly dose of at least 15 mg within 4 to 6 weeks”.',
  null,
  null,
  '2021 American College of Rheumatology Guideline for the Treatment of Rheumatoid Arthritis: https://pmc.ncbi.nlm.nih.gov/articles/PMC9273041/ . Trích: “Methotrexate monotherapy is strongly recommended over ... Hydroxychloroquine or sulfasalazine” cho người chưa dùng DMARD có hoạt tính vừa-cao; “weekly dose of at least 15 mg within 4 to 6 weeks”.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-co-xuong-khop-002-1',
  '1.0.0',
  'other',
  'American College of Rheumatology. 2020 ACR Guideline for the Management of Gout. https://pmc.ncbi.nlm.nih.gov/articles/PMC10563586/ . Trích: “1.2 mg immediately followed by 0.6 mg an hour later”; “colchicine, NSAIDs, or glucocorticoids ... first-line therapy”.',
  'American College of Rheumatology. 2020 ACR Guideline for the Management of Gout. https://pmc.ncbi.nlm.nih.gov/articles/PMC10563586/ . Trích: “1.2 mg immediately followed by 0.6 mg an hour later”; “colchicine, NSAIDs, or glucocorticoids ... first-line therapy”.',
  null,
  null,
  'American College of Rheumatology. 2020 ACR Guideline for the Management of Gout. https://pmc.ncbi.nlm.nih.gov/articles/PMC10563586/ . Trích: “1.2 mg immediately followed by 0.6 mg an hour later”; “colchicine, NSAIDs, or glucocorticoids ... first-line therapy”.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-ho-hap-001-1',
  '1.0.0',
  'other',
  'Hướng dẫn chẩn đoán và điều trị hen phế quản, Bộ Y tế Việt Nam, 2016.',
  'Hướng dẫn chẩn đoán và điều trị hen phế quản, Bộ Y tế Việt Nam, 2016.',
  null,
  null,
  'Hướng dẫn chẩn đoán và điều trị hen phế quản, Bộ Y tế Việt Nam, 2016.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-ho-hap-001-3',
  '1.0.0',
  'textbook',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Hen phế quản.',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Hen phế quản.',
  null,
  null,
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Hen phế quản.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-ho-hap-002-1',
  '1.0.0',
  'other',
  'Hướng dẫn chẩn đoán và điều trị bệnh phổi tắc nghẽn mạn tính, Bộ Y tế Việt Nam, 2018.',
  'Hướng dẫn chẩn đoán và điều trị bệnh phổi tắc nghẽn mạn tính, Bộ Y tế Việt Nam, 2018.',
  null,
  null,
  'Hướng dẫn chẩn đoán và điều trị bệnh phổi tắc nghẽn mạn tính, Bộ Y tế Việt Nam, 2018.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-ho-hap-002-3',
  '1.0.0',
  'textbook',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Dược TPHCM, phần Bệnh phổi tắc nghẽn mạn tính.',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Dược TPHCM, phần Bệnh phổi tắc nghẽn mạn tính.',
  null,
  null,
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Dược TPHCM, phần Bệnh phổi tắc nghẽn mạn tính.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-ho-hap-003-1',
  '1.0.0',
  'other',
  'Hướng dẫn chẩn đoán và điều trị viêm phổi cộng đồng ở người lớn, Bộ Y tế Việt Nam, 2016 và bản cập nhật.',
  'Hướng dẫn chẩn đoán và điều trị viêm phổi cộng đồng ở người lớn, Bộ Y tế Việt Nam, 2016 và bản cập nhật.',
  null,
  null,
  'Hướng dẫn chẩn đoán và điều trị viêm phổi cộng đồng ở người lớn, Bộ Y tế Việt Nam, 2016 và bản cập nhật.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-ho-hap-003-3',
  '1.0.0',
  'textbook',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Viêm phổi.',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Viêm phổi.',
  null,
  null,
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Viêm phổi.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-ho-hap-004-2',
  '1.0.0',
  'other',
  'Hướng dẫn chẩn đoán và điều trị thuyên tắc phổi, Hội Tim mạch học Việt Nam, bản cập nhật.',
  'Hướng dẫn chẩn đoán và điều trị thuyên tắc phổi, Hội Tim mạch học Việt Nam, bản cập nhật.',
  null,
  null,
  'Hướng dẫn chẩn đoán và điều trị thuyên tắc phổi, Hội Tim mạch học Việt Nam, bản cập nhật.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-ho-hap-004-3',
  '1.0.0',
  'textbook',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Bệnh tim mạch và hô hấp.',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Bệnh tim mạch và hô hấp.',
  null,
  null,
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Bệnh tim mạch và hô hấp.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-ho-hap-005-1',
  '1.0.0',
  'textbook',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Áp xe phổi.',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Áp xe phổi.',
  null,
  null,
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Áp xe phổi.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-ho-hap-005-2',
  '1.0.0',
  'other',
  'Hướng dẫn chẩn đoán và điều trị các bệnh hô hấp thường gặp, Bộ Y tế Việt Nam, bản cập nhật.',
  'Hướng dẫn chẩn đoán và điều trị các bệnh hô hấp thường gặp, Bộ Y tế Việt Nam, bản cập nhật.',
  null,
  null,
  'Hướng dẫn chẩn đoán và điều trị các bệnh hô hấp thường gặp, Bộ Y tế Việt Nam, bản cập nhật.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-ho-hap-005-3',
  '1.0.0',
  'textbook',
  'Mandell, Douglas and Bennett Principles and Practice of Infectious Diseases, phần Lung Abscess.',
  'Mandell, Douglas and Bennett Principles and Practice of Infectious Diseases, phần Lung Abscess.',
  null,
  null,
  'Mandell, Douglas and Bennett Principles and Practice of Infectious Diseases, phần Lung Abscess.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-huyet-hoc-001-1',
  '1.0.0',
  'other',
  'World Health Organization. Guideline on use of ferritin concentrations to assess iron status in individuals and populations. WHO 2020.',
  'World Health Organization. Guideline on use of ferritin concentrations to assess iron status in individuals and populations. WHO 2020.',
  null,
  null,
  'World Health Organization. Guideline on use of ferritin concentrations to assess iron status in individuals and populations. WHO 2020.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-huyet-hoc-001-3',
  '1.0.0',
  'other',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị thiếu máu thiếu sắt (tài liệu chuyên môn huyết học, cần đối chiếu số hiệu).',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị thiếu máu thiếu sắt (tài liệu chuyên môn huyết học, cần đối chiếu số hiệu).',
  null,
  null,
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị thiếu máu thiếu sắt (tài liệu chuyên môn huyết học, cần đối chiếu số hiệu).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-huyet-hoc-001-4',
  '1.0.0',
  'textbook',
  'Giáo trình Huyết học - Truyền máu, các trường đại học Y Việt Nam.',
  'Giáo trình Huyết học - Truyền máu, các trường đại học Y Việt Nam.',
  null,
  null,
  'Giáo trình Huyết học - Truyền máu, các trường đại học Y Việt Nam.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-huyet-hoc-002-1',
  '1.0.0',
  'other',
  'American Society of Hematology, Summary of Changes to the 2026 Updated Recommendations: https://www.hematology.org/-/media/hematology/files/clinicians/guidelines/ash-itp-summary-of-changes_20260824.pdf . Trích: “Adults, newly dx ITP, platelets <30×10⁹/L, asymptomatic/minor bleeding”; “The threshold for initiating therapy has not been updated.”',
  'American Society of Hematology, Summary of Changes to the 2026 Updated Recommendations: https://www.hematology.org/-/media/hematology/files/clinicians/guidelines/ash-itp-summary-of-changes_20260824.pdf . Trích: “Adults, newly dx ITP, platelets <30×10⁹/L, asymptomatic/minor bleeding”; “The threshold for initiating therapy has not been updated.”',
  null,
  null,
  'American Society of Hematology, Summary of Changes to the 2026 Updated Recommendations: https://www.hematology.org/-/media/hematology/files/clinicians/guidelines/ash-itp-summary-of-changes_20260824.pdf . Trích: “Adults, newly dx ITP, platelets <30×10⁹/L, asymptomatic/minor bleeding”; “The threshold for initiating therapy has not been updated.”',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-huyet-hoc-002-2',
  '1.0.0',
  'other',
  'American Society of Hematology, 2026 ITP Visual Summary: https://www.hematology.org/-/media/hematology/files/clinicians/guidelines/ash-cpg-itp-guidelines-visual-summary-0824.pdf . Trích: “Suggests rituximab + corticosteroids (with or without IVIG)” và “Suggests thrombopoietic agent + corticosteroids (with or without IVIG)”.',
  'American Society of Hematology, 2026 ITP Visual Summary: https://www.hematology.org/-/media/hematology/files/clinicians/guidelines/ash-cpg-itp-guidelines-visual-summary-0824.pdf . Trích: “Suggests rituximab + corticosteroids (with or without IVIG)” và “Suggests thrombopoietic agent + corticosteroids (with or without IVIG)”.',
  null,
  null,
  'American Society of Hematology, 2026 ITP Visual Summary: https://www.hematology.org/-/media/hematology/files/clinicians/guidelines/ash-cpg-itp-guidelines-visual-summary-0824.pdf . Trích: “Suggests rituximab + corticosteroids (with or without IVIG)” và “Suggests thrombopoietic agent + corticosteroids (with or without IVIG)”.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-huyet-hoc-003-1',
  '1.0.0',
  'other',
  'American Society of Hematology Education Program. Thrombotic anti-PF4 immune disorders: HIT, VITT, and beyond, 2023. https://ashpublications.org/hematology/article/2023/1/1/506391/Thrombotic-anti-PF4-immune-disorders-HIT-VITT-and . Trích: “>50% platelet fall AND a nadir of ≥20 × 10^9/L”; “Platelet fall days 5 to 10 after start of heparin”.',
  'American Society of Hematology Education Program. Thrombotic anti-PF4 immune disorders: HIT, VITT, and beyond, 2023. https://ashpublications.org/hematology/article/2023/1/1/506391/Thrombotic-anti-PF4-immune-disorders-HIT-VITT-and . Trích: “>50% platelet fall AND a nadir of ≥20 × 10^9/L”; “Platelet fall days 5 to 10 after start of heparin”.',
  null,
  null,
  'American Society of Hematology Education Program. Thrombotic anti-PF4 immune disorders: HIT, VITT, and beyond, 2023. https://ashpublications.org/hematology/article/2023/1/1/506391/Thrombotic-anti-PF4-immune-disorders-HIT-VITT-and . Trích: “>50% platelet fall AND a nadir of ≥20 × 10^9/L”; “Platelet fall days 5 to 10 after start of heparin”.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-huyet-hoc-003-2',
  '1.0.0',
  'other',
  'American Society of Hematology 2018 Guidelines for Heparin-Induced Thrombocytopenia. https://ashpublications.org/bloodadvances/article/2/22/3360/16129/American-Society-of-Hematology-2018-guidelines-for . Trích: “discontinuation of heparin and initiation of a non-heparin anticoagulant”.',
  'American Society of Hematology 2018 Guidelines for Heparin-Induced Thrombocytopenia. https://ashpublications.org/bloodadvances/article/2/22/3360/16129/American-Society-of-Hematology-2018-guidelines-for . Trích: “discontinuation of heparin and initiation of a non-heparin anticoagulant”.',
  null,
  null,
  'American Society of Hematology 2018 Guidelines for Heparin-Induced Thrombocytopenia. https://ashpublications.org/bloodadvances/article/2/22/3360/16129/American-Society-of-Hematology-2018-guidelines-for . Trích: “discontinuation of heparin and initiation of a non-heparin anticoagulant”.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-nhiem-001-1',
  '1.0.0',
  'other',
  'World Health Organization. Dengue: guidelines for diagnosis, treatment, prevention and control (new edition 2009) và cập nhật WHO 2012 Handbook for clinical management of dengue.',
  'World Health Organization. Dengue: guidelines for diagnosis, treatment, prevention and control (new edition 2009) và cập nhật WHO 2012 Handbook for clinical management of dengue.',
  null,
  null,
  'World Health Organization. Dengue: guidelines for diagnosis, treatment, prevention and control (new edition 2009) và cập nhật WHO 2012 Handbook for clinical management of dengue.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-nhiem-001-3',
  '1.0.0',
  'textbook',
  'Giáo trình Bệnh truyền nhiễm, các trường đại học Y Việt Nam.',
  'Giáo trình Bệnh truyền nhiễm, các trường đại học Y Việt Nam.',
  null,
  null,
  'Giáo trình Bệnh truyền nhiễm, các trường đại học Y Việt Nam.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-nhiem-002-4',
  '1.0.0',
  'textbook',
  'Giáo trình Bệnh truyền nhiễm, các trường đại học Y Việt Nam.',
  'Giáo trình Bệnh truyền nhiễm, các trường đại học Y Việt Nam.',
  null,
  null,
  'Giáo trình Bệnh truyền nhiễm, các trường đại học Y Việt Nam.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-noi-tiet-001-3',
  '1.0.0',
  'textbook',
  'Giáo trình Nội khoa, bộ môn Nội, các trường đại học Y Việt Nam.',
  'Giáo trình Nội khoa, bộ môn Nội, các trường đại học Y Việt Nam.',
  null,
  null,
  'Giáo trình Nội khoa, bộ môn Nội, các trường đại học Y Việt Nam.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-noi-tiet-002-1',
  '1.0.0',
  'other',
  'American Diabetes Association. Standards of Care in Diabetes 2024. Diabetes Care 2024;47(Suppl 1).',
  'American Diabetes Association. Standards of Care in Diabetes 2024. Diabetes Care 2024;47(Suppl 1).',
  null,
  null,
  'American Diabetes Association. Standards of Care in Diabetes 2024. Diabetes Care 2024;47(Suppl 1).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-noi-tiet-002-3',
  '1.0.0',
  'other',
  'KDIGO 2022 Clinical Practice Guideline for Diabetes Management in CKD.',
  'KDIGO 2022 Clinical Practice Guideline for Diabetes Management in CKD.',
  null,
  null,
  'KDIGO 2022 Clinical Practice Guideline for Diabetes Management in CKD.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-noi-tiet-002-4',
  '1.0.0',
  'textbook',
  'Giáo trình Nội khoa, bộ môn Nội, các trường đại học Y Việt Nam.',
  'Giáo trình Nội khoa, bộ môn Nội, các trường đại học Y Việt Nam.',
  null,
  null,
  'Giáo trình Nội khoa, bộ môn Nội, các trường đại học Y Việt Nam.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-noi-tiet-003-1',
  '1.0.0',
  'other',
  'Endocrine Society, Diagnosis and Treatment of Primary Adrenal Insufficiency, 2016: https://www.endocrine.org/clinical-practice-guidelines/primary-adrenal-insufficiency . Trích: “standard dose (250 μg for adults ... ) iv corticotropin stimulation”; “hydrocortisone (15–25 mg) ... in two or three divided oral doses per day”; “fludrocortisone (starting dose, 50–100 μg in adults)”.',
  'Endocrine Society, Diagnosis and Treatment of Primary Adrenal Insufficiency, 2016: https://www.endocrine.org/clinical-practice-guidelines/primary-adrenal-insufficiency . Trích: “standard dose (250 μg for adults ... ) iv corticotropin stimulation”; “hydrocortisone (15–25 mg) ... in two or three divided oral doses per day”; “fludrocortisone (starting dose, 50–100 μg in adults)”.',
  null,
  null,
  'Endocrine Society, Diagnosis and Treatment of Primary Adrenal Insufficiency, 2016: https://www.endocrine.org/clinical-practice-guidelines/primary-adrenal-insufficiency . Trích: “standard dose (250 μg for adults ... ) iv corticotropin stimulation”; “hydrocortisone (15–25 mg) ... in two or three divided oral doses per day”; “fludrocortisone (starting dose, 50–100 μg in adults)”.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-than-001-2',
  '1.0.0',
  'other',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị một số bệnh về thận, tiết niệu (Quyết định 3931/QĐ-BYT, 2015).',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị một số bệnh về thận, tiết niệu (Quyết định 3931/QĐ-BYT, 2015).',
  null,
  null,
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị một số bệnh về thận, tiết niệu (Quyết định 3931/QĐ-BYT, 2015).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-than-001-3',
  '1.0.0',
  'textbook',
  'Giáo trình Nội khoa, bộ môn Nội, các trường đại học Y Việt Nam.',
  'Giáo trình Nội khoa, bộ môn Nội, các trường đại học Y Việt Nam.',
  null,
  null,
  'Giáo trình Nội khoa, bộ môn Nội, các trường đại học Y Việt Nam.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-than-002-1',
  '1.0.0',
  'other',
  'KDIGO 2021 Clinical Practice Guideline for the Management of Glomerular Diseases. Kidney Int 2021.',
  'KDIGO 2021 Clinical Practice Guideline for the Management of Glomerular Diseases. Kidney Int 2021.',
  null,
  null,
  'KDIGO 2021 Clinical Practice Guideline for the Management of Glomerular Diseases. Kidney Int 2021.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-than-002-2',
  '1.0.0',
  'other',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị bệnh thận, tiết niệu (Quyết định 3931/QĐ-BYT, 2015).',
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị bệnh thận, tiết niệu (Quyết định 3931/QĐ-BYT, 2015).',
  null,
  null,
  'Bộ Y tế. Hướng dẫn chẩn đoán và điều trị bệnh thận, tiết niệu (Quyết định 3931/QĐ-BYT, 2015).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-than-002-3',
  '1.0.0',
  'textbook',
  'Giáo trình Nội khoa, bộ môn Nội, các trường đại học Y Việt Nam.',
  'Giáo trình Nội khoa, bộ môn Nội, các trường đại học Y Việt Nam.',
  null,
  null,
  'Giáo trình Nội khoa, bộ môn Nội, các trường đại học Y Việt Nam.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-than-003-1',
  '1.0.0',
  'other',
  'EAU Guidelines on Urological Infections. European Association of Urology 2024.',
  'EAU Guidelines on Urological Infections. European Association of Urology 2024.',
  null,
  null,
  'EAU Guidelines on Urological Infections. European Association of Urology 2024.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-than-003-2',
  '1.0.0',
  'other',
  'IDSA/ESCMID. International Clinical Practice Guidelines for the Treatment of Acute Uncomplicated Cystitis and Pyelonephritis in Women. Clin Infect Dis 2011.',
  'IDSA/ESCMID. International Clinical Practice Guidelines for the Treatment of Acute Uncomplicated Cystitis and Pyelonephritis in Women. Clin Infect Dis 2011.',
  null,
  null,
  'IDSA/ESCMID. International Clinical Practice Guidelines for the Treatment of Acute Uncomplicated Cystitis and Pyelonephritis in Women. Clin Infect Dis 2011.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-than-003-4',
  '1.0.0',
  'textbook',
  'Giáo trình Nội khoa, bộ môn Nội, các trường đại học Y Việt Nam.',
  'Giáo trình Nội khoa, bộ môn Nội, các trường đại học Y Việt Nam.',
  null,
  null,
  'Giáo trình Nội khoa, bộ môn Nội, các trường đại học Y Việt Nam.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-than-004-1',
  '1.0.0',
  'other',
  'KDIGO 2024 Clinical Practice Guideline for the Evaluation and Management of CKD: https://kdigo.org/wp-content/uploads/2024/03/KDIGO-2024-CKD-Guideline.pdf . Trích: “Changes in BP, serum creatinine, and serum potassium should be checked within 2–4 weeks of initiation or increase in the dose of a RASi”; “eGFR ≥20 ml/min per 1.73 m² with urine ACR ≥200 mg/g”.',
  'KDIGO 2024 Clinical Practice Guideline for the Evaluation and Management of CKD: https://kdigo.org/wp-content/uploads/2024/03/KDIGO-2024-CKD-Guideline.pdf . Trích: “Changes in BP, serum creatinine, and serum potassium should be checked within 2–4 weeks of initiation or increase in the dose of a RASi”; “eGFR ≥20 ml/min per 1.73 m² with urine ACR ≥200 mg/g”.',
  null,
  null,
  'KDIGO 2024 Clinical Practice Guideline for the Evaluation and Management of CKD: https://kdigo.org/wp-content/uploads/2024/03/KDIGO-2024-CKD-Guideline.pdf . Trích: “Changes in BP, serum creatinine, and serum potassium should be checked within 2–4 weeks of initiation or increase in the dose of a RASi”; “eGFR ≥20 ml/min per 1.73 m² with urine ACR ≥200 mg/g”.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-than-004-2',
  '1.0.0',
  'other',
  'KDIGO CKD Evaluation and Management page, current status 2026: https://kdigo.org/guidelines/ckd-evaluation-and-management/ . Trích: “KDIGO 2024 ... remains the current global standard”.',
  'KDIGO CKD Evaluation and Management page, current status 2026: https://kdigo.org/guidelines/ckd-evaluation-and-management/ . Trích: “KDIGO 2024 ... remains the current global standard”.',
  null,
  null,
  'KDIGO CKD Evaluation and Management page, current status 2026: https://kdigo.org/guidelines/ckd-evaluation-and-management/ . Trích: “KDIGO 2024 ... remains the current global standard”.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-than-kinh-001-3',
  '1.0.0',
  'textbook',
  'Giáo trình Thần kinh học, bộ môn Thần kinh, các trường đại học Y Việt Nam.',
  'Giáo trình Thần kinh học, bộ môn Thần kinh, các trường đại học Y Việt Nam.',
  null,
  null,
  'Giáo trình Thần kinh học, bộ môn Thần kinh, các trường đại học Y Việt Nam.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-than-kinh-002-3',
  '1.0.0',
  'textbook',
  'Giáo trình Thần kinh học, bộ môn Thần kinh, các trường đại học Y Việt Nam.',
  'Giáo trình Thần kinh học, bộ môn Thần kinh, các trường đại học Y Việt Nam.',
  null,
  null,
  'Giáo trình Thần kinh học, bộ môn Thần kinh, các trường đại học Y Việt Nam.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-than-kinh-003-1',
  '1.0.0',
  'other',
  'NICE NG71 Parkinson''s disease in adults, Recommendations: https://www.nice.org.uk/guidance/ng71/chapter/Recommendations . Trích: “If Parkinson''s disease is suspected, refer people quickly and untreated to a specialist”; “Offer levodopa to people in the early stages of Parkinson''s disease whose motor symptoms impact on their quality of life”; “Do not use structural MRI to diagnose Parkinson''s disease”; “Consider 123I-FP-CIT ... SPECT for people with tremor if essential tremor cannot be clinically differentiated from parkinsonism.”',
  'NICE NG71 Parkinson''s disease in adults, Recommendations: https://www.nice.org.uk/guidance/ng71/chapter/Recommendations . Trích: “If Parkinson''s disease is suspected, refer people quickly and untreated to a specialist”; “Offer levodopa to people in the early stages of Parkinson''s disease whose motor symptoms impact on their quality of life”; “Do not use structural MRI to diagnose Parkinson''s disease”; “Consider 123I-FP-CIT ... SPECT for people with tremor if essential tremor cannot be clinically differentiated from parkinsonism.”',
  null,
  null,
  'NICE NG71 Parkinson''s disease in adults, Recommendations: https://www.nice.org.uk/guidance/ng71/chapter/Recommendations . Trích: “If Parkinson''s disease is suspected, refer people quickly and untreated to a specialist”; “Offer levodopa to people in the early stages of Parkinson''s disease whose motor symptoms impact on their quality of life”; “Do not use structural MRI to diagnose Parkinson''s disease”; “Consider 123I-FP-CIT ... SPECT for people with tremor if essential tremor cannot be clinically differentiated from parkinsonism.”',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-than-kinh-004-1',
  '1.0.0',
  'other',
  'American Heart Association/American Stroke Association. 2026 Guideline for the Early Management of Patients With Acute Ischemic Stroke. https://professional.heart.org/en/science-news/2026-guideline-for-the-early-management-of-patients-with-acute-ischemic-stroke/top-things-to-know . Trích: “within the 4.5-hour thrombolytic treatment window”.',
  'American Heart Association/American Stroke Association. 2026 Guideline for the Early Management of Patients With Acute Ischemic Stroke. https://professional.heart.org/en/science-news/2026-guideline-for-the-early-management-of-patients-with-acute-ischemic-stroke/top-things-to-know . Trích: “within the 4.5-hour thrombolytic treatment window”.',
  null,
  null,
  'American Heart Association/American Stroke Association. 2026 Guideline for the Early Management of Patients With Acute Ischemic Stroke. https://professional.heart.org/en/science-news/2026-guideline-for-the-early-management-of-patients-with-acute-ischemic-stroke/top-things-to-know . Trích: “within the 4.5-hour thrombolytic treatment window”.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-tieu-hoa-001-1',
  '1.0.0',
  'other',
  'NICE CG61, Irritable bowel syndrome in adults: diagnosis and management, 2008, cập nhật 2017. https://www.nice.org.uk/guidance/cg61/chapter/Recommendations',
  'NICE CG61, Irritable bowel syndrome in adults: diagnosis and management, 2008, cập nhật 2017. https://www.nice.org.uk/guidance/cg61/chapter/Recommendations',
  null,
  null,
  'NICE CG61, Irritable bowel syndrome in adults: diagnosis and management, 2008, cập nhật 2017. https://www.nice.org.uk/guidance/cg61/chapter/Recommendations',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-tieu-hoa-009-1',
  '1.0.0',
  'other',
  'ACG Clinical Guideline Update: Ulcerative Colitis in Adults, 2025; bản tóm lược chính thức của ACG. https://gi.org/journals-publications/ebgi/alkazzi_aug2025/',
  'ACG Clinical Guideline Update: Ulcerative Colitis in Adults, 2025; bản tóm lược chính thức của ACG. https://gi.org/journals-publications/ebgi/alkazzi_aug2025/',
  null,
  null,
  'ACG Clinical Guideline Update: Ulcerative Colitis in Adults, 2025; bản tóm lược chính thức của ACG. https://gi.org/journals-publications/ebgi/alkazzi_aug2025/',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-tieu-hoa-010-3',
  '1.0.0',
  'other',
  'Danh mục hướng dẫn của Japanese Society of Hepato-Biliary-Pancreatic Surgery. https://www.jshbps.jp/modules/en/index.php?content_id=47',
  'Danh mục hướng dẫn của Japanese Society of Hepato-Biliary-Pancreatic Surgery. https://www.jshbps.jp/modules/en/index.php?content_id=47',
  null,
  null,
  'Danh mục hướng dẫn của Japanese Society of Hepato-Biliary-Pancreatic Surgery. https://www.jshbps.jp/modules/en/index.php?content_id=47',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-tieu-hoa-012-1',
  '1.0.0',
  'other',
  'British Society of Gastroenterology/BASL. Guidelines on the management of ascites in cirrhosis, Gut 2021. https://gut.bmj.com/content/70/1/9 . Trích: “Ascitic neutrophil >250/mm3 count remains the gold standard for the diagnosis of SBP.”',
  'British Society of Gastroenterology/BASL. Guidelines on the management of ascites in cirrhosis, Gut 2021. https://gut.bmj.com/content/70/1/9 . Trích: “Ascitic neutrophil >250/mm3 count remains the gold standard for the diagnosis of SBP.”',
  null,
  null,
  'British Society of Gastroenterology/BASL. Guidelines on the management of ascites in cirrhosis, Gut 2021. https://gut.bmj.com/content/70/1/9 . Trích: “Ascitic neutrophil >250/mm3 count remains the gold standard for the diagnosis of SBP.”',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-tim-mach-001-1',
  '1.0.0',
  'other',
  'Hướng dẫn chẩn đoán và điều trị nhồi máu cơ tim cấp có ST chênh lên, Bộ Y tế Việt Nam, 2022.',
  'Hướng dẫn chẩn đoán và điều trị nhồi máu cơ tim cấp có ST chênh lên, Bộ Y tế Việt Nam, 2022.',
  null,
  null,
  'Hướng dẫn chẩn đoán và điều trị nhồi máu cơ tim cấp có ST chênh lên, Bộ Y tế Việt Nam, 2022.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-tim-mach-001-3',
  '1.0.0',
  'textbook',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Bệnh mạch vành.',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Bệnh mạch vành.',
  null,
  null,
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Bệnh mạch vành.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-tim-mach-002-2',
  '1.0.0',
  'other',
  'Hướng dẫn chẩn đoán và điều trị hội chứng vành cấp không ST chênh lên, Hội Tim mạch học Việt Nam, bản cập nhật.',
  'Hướng dẫn chẩn đoán và điều trị hội chứng vành cấp không ST chênh lên, Hội Tim mạch học Việt Nam, bản cập nhật.',
  null,
  null,
  'Hướng dẫn chẩn đoán và điều trị hội chứng vành cấp không ST chênh lên, Hội Tim mạch học Việt Nam, bản cập nhật.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-tim-mach-002-3',
  '1.0.0',
  'textbook',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Dược TPHCM, phần Bệnh mạch vành.',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Dược TPHCM, phần Bệnh mạch vành.',
  null,
  null,
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Dược TPHCM, phần Bệnh mạch vành.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-tim-mach-003-1',
  '1.0.0',
  'other',
  'Hướng dẫn chẩn đoán và điều trị tăng huyết áp, Bộ Y tế Việt Nam, 2010 và cập nhật Hội Tim mạch học Việt Nam 2022.',
  'Hướng dẫn chẩn đoán và điều trị tăng huyết áp, Bộ Y tế Việt Nam, 2010 và cập nhật Hội Tim mạch học Việt Nam 2022.',
  null,
  null,
  'Hướng dẫn chẩn đoán và điều trị tăng huyết áp, Bộ Y tế Việt Nam, 2010 và cập nhật Hội Tim mạch học Việt Nam 2022.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-tim-mach-003-3',
  '1.0.0',
  'textbook',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Tăng huyết áp.',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Tăng huyết áp.',
  null,
  null,
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Tăng huyết áp.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-tim-mach-004-1',
  '1.0.0',
  'other',
  'Hướng dẫn chẩn đoán và điều trị suy tim, Bộ Y tế Việt Nam, 2020.',
  'Hướng dẫn chẩn đoán và điều trị suy tim, Bộ Y tế Việt Nam, 2020.',
  null,
  null,
  'Hướng dẫn chẩn đoán và điều trị suy tim, Bộ Y tế Việt Nam, 2020.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-tim-mach-004-3',
  '1.0.0',
  'textbook',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Dược TPHCM, phần Suy tim.',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Dược TPHCM, phần Suy tim.',
  null,
  null,
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Dược TPHCM, phần Suy tim.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-tim-mach-005-2',
  '1.0.0',
  'other',
  'Khuyến cáo về chẩn đoán và điều trị rung nhĩ, Hội Tim mạch học Việt Nam, bản cập nhật.',
  'Khuyến cáo về chẩn đoán và điều trị rung nhĩ, Hội Tim mạch học Việt Nam, bản cập nhật.',
  null,
  null,
  'Khuyến cáo về chẩn đoán và điều trị rung nhĩ, Hội Tim mạch học Việt Nam, bản cập nhật.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-tim-mach-005-3',
  '1.0.0',
  'textbook',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Rối loạn nhịp tim.',
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Rối loạn nhịp tim.',
  null,
  null,
  'Giáo trình Nội khoa, Bộ môn Nội, Trường Đại học Y Hà Nội, phần Rối loạn nhịp tim.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-tim-mach-006-1',
  '1.0.0',
  'other',
  'Hướng dẫn chẩn đoán và điều trị tăng huyết áp, Bộ Y tế Việt Nam, 2010.',
  'Hướng dẫn chẩn đoán và điều trị tăng huyết áp, Bộ Y tế Việt Nam, 2010.',
  null,
  null,
  'Hướng dẫn chẩn đoán và điều trị tăng huyết áp, Bộ Y tế Việt Nam, 2010.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-tim-mach-006-2',
  '1.0.0',
  'other',
  'Khuyến cáo của Hội Tim mạch học Việt Nam về chẩn đoán và điều trị tăng huyết áp, 2022.',
  'Khuyến cáo của Hội Tim mạch học Việt Nam về chẩn đoán và điều trị tăng huyết áp, 2022.',
  null,
  null,
  'Khuyến cáo của Hội Tim mạch học Việt Nam về chẩn đoán và điều trị tăng huyết áp, 2022.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-noi-tim-mach-007-1',
  '1.0.0',
  'other',
  '2023 ACC/AHA/ACCP/HRS Guideline for the Diagnosis and Management of Atrial Fibrillation. https://www.jacc.org/doi/10.1016/j.jacc.2023.08.017 . Trích: “annual thromboembolic risk of ≥2% per year (eg, CHA2DS2-VASc score of ≥2 in men and ≥3 in women), anticoagulation is recommended”.',
  '2023 ACC/AHA/ACCP/HRS Guideline for the Diagnosis and Management of Atrial Fibrillation. https://www.jacc.org/doi/10.1016/j.jacc.2023.08.017 . Trích: “annual thromboembolic risk of ≥2% per year (eg, CHA2DS2-VASc score of ≥2 in men and ≥3 in women), anticoagulation is recommended”.',
  null,
  null,
  '2023 ACC/AHA/ACCP/HRS Guideline for the Diagnosis and Management of Atrial Fibrillation. https://www.jacc.org/doi/10.1016/j.jacc.2023.08.017 . Trích: “annual thromboembolic risk of ≥2% per year (eg, CHA2DS2-VASc score of ≥2 in men and ≥3 in women), anticoagulation is recommended”.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-open-fracture-east-2011',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/21610369/',
  'EAST Practice Management Guidelines: Antibiotic prophylaxis in open fractures, 2011',
  null,
  null,
  'EAST Practice Management Guidelines: Antibiotic prophylaxis in open fractures, 2011',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-pad-accaha-2024',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/38743805/',
  '2024 ACC/AHA Guideline for the Management of Lower Extremity Peripheral Artery Disease.',
  null,
  null,
  '2024 ACC/AHA Guideline for the Management of Lower Extremity Peripheral Artery Disease.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-pancreatitis-acg-2024-22ee1eeffb34',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/38857482/',
  'ACG Guideline: Management of Acute Pancreatitis, 2024 và IAP/APA Evidence-based guidelines for the management of acute pancreatitis, 2013',
  null,
  null,
  'ACG Guideline: Management of Acute Pancreatitis, 2024 và IAP/APA Evidence-based guidelines for the management of acute pancreatitis, 2013',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-pancreatitis-acg-2024-60c6b3c22ea7',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/38857482/',
  'American College of Gastroenterology Guidelines: Management of Acute Pancreatitis, 2024. https://pmc.ncbi.nlm.nih.gov/articles/PMC13221274/',
  null,
  null,
  'American College of Gastroenterology Guidelines: Management of Acute Pancreatitis, 2024. https://pmc.ncbi.nlm.nih.gov/articles/PMC13221274/',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-pancreatitis-wses-2019',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/31210778/',
  'WSES Guidelines for the management of severe acute pancreatitis, 2019',
  null,
  null,
  'WSES Guidelines for the management of severe acute pancreatitis, 2019',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-paracetamol-anzctg-2020',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/31786822/',
  'Chiew AL et al. Updated guidelines for the management of paracetamol poisoning in Australia and New Zealand. Med J Aust 2020;212:175-183.',
  null,
  null,
  'Chiew AL et al. Updated guidelines for the management of paracetamol poisoning in Australia and New Zealand. Med J Aust 2020;212:175-183.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-pe-esc-2019',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/31504429/',
  '2019 ESC Guidelines for the diagnosis and management of acute pulmonary embolism, Eur Heart J 2020.',
  null,
  null,
  '2019 ESC Guidelines for the diagnosis and management of acute pulmonary embolism, Eur Heart J 2020.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-pelvic-wses-2017',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/28115984/',
  'WSES Guidelines: Management of Pelvic Trauma in Hemodynamically Unstable Patients, 2017.',
  null,
  null,
  'WSES Guidelines: Management of Pelvic Trauma in Hemodynamically Unstable Patients, 2017.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-penetrating-abd-wses-2022',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/35246190/',
  'WSES Guidelines: Management of penetrating abdominal trauma, 2022 (World Society of Emergency Surgery)',
  null,
  null,
  'WSES Guidelines: Management of penetrating abdominal trauma, 2022 (World Society of Emergency Surgery)',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ptu-wses-2020',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/31921329/',
  'World Society of Emergency Surgery, Perforated and Bleeding Peptic Ulcer: WSES Guidelines, 2020.',
  null,
  null,
  'World Society of Emergency Surgery, Perforated and Bleeding Peptic Ulcer: WSES Guidelines, 2020.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-rumack-1975',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/1134886/',
  'Rumack BH, Matthew H. Acetaminophen poisoning and toxicity. Pediatrics 1975;55:871-876 (giản đồ Rumack-Matthew).',
  null,
  null,
  'Rumack BH, Matthew H. Acetaminophen poisoning and toxicity. Pediatrics 1975;55:871-876 (giản đồ Rumack-Matthew).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-se-aes-2016',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/26900382/',
  'American Epilepsy Society. Guideline for the treatment of convulsive status epilepticus in children and adults, Epilepsy Curr 2016;16(1):48-61. DOI: 10.5698/1535-7597-16.1.48.',
  null,
  null,
  'American Epilepsy Society. Guideline for the treatment of convulsive status epilepticus in children and adults, Epilepsy Curr 2016;16(1):48-61. DOI: 10.5698/1535-7597-16.1.48.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-sepsis-ssc-2021-89948a253b0a',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/34605781/',
  'Surviving Sepsis Campaign: International Guidelines for Management of Sepsis and Septic Shock 2021. DOI: 10.1007/s00134-021-06506-y.',
  null,
  null,
  'Surviving Sepsis Campaign: International Guidelines for Management of Sepsis and Septic Shock 2021. DOI: 10.1007/s00134-021-06506-y.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-sepsis-ssc-2021-ac318ed1a46d',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/34605781/',
  'Surviving Sepsis Campaign. International Guidelines for Management of Sepsis and Septic Shock 2021. DOI: 10.1097/CCM.0000000000005337.',
  null,
  null,
  'Surviving Sepsis Campaign. International Guidelines for Management of Sepsis and Septic Shock 2021. DOI: 10.1097/CCM.0000000000005337.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-sepsis-ssc-2021-dadd2d2cb325',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/34605781/',
  'Evans L et al. Surviving Sepsis Campaign: International Guidelines for Management of Sepsis and Septic Shock 2021.',
  null,
  null,
  'Evans L et al. Surviving Sepsis Campaign: International Guidelines for Management of Sepsis and Septic Shock 2021.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-sepsis-ssc-2021-ee3c0fd08779',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/34605781/',
  'Society of Critical Care Medicine, Surviving Sepsis Campaign Adult Guidelines. https://sccm.org/survivingsepsiscampaign/guidelines-and-resources/surviving-sepsis-campaign-adult-guidelines . Trích: “at least 30 mL/kg of IV crystalloid in the first 3 hr”; “initial MAP target of 65 mm Hg”.',
  null,
  null,
  'Society of Critical Care Medicine, Surviving Sepsis Campaign Adult Guidelines. https://sccm.org/survivingsepsiscampaign/guidelines-and-resources/surviving-sepsis-campaign-adult-guidelines . Trích: “at least 30 mL/kg of IV crystalloid in the first 3 hr”; “initial MAP target of 65 mm Hg”.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-snakebite-warrell-2010',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/20109866/',
  'Warrell DA. Snakebite. Lancet 2010;375:77-88.',
  null,
  null,
  'Warrell DA. Snakebite. Lancet 2010;375:77-88.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-spleen-wses-2017',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/28828034/',
  'World Society of Emergency Surgery, Splenic Trauma: WSES Classification and Guidelines for Adult and Pediatric Patients, 2017.',
  null,
  null,
  'World Society of Emergency Surgery, Splenic Trauma: WSES Classification and Guidelines for Adult and Pediatric Patients, 2017.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-tbi-btf-2017-021e7a89b068',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/27654000/',
  'Brain Trauma Foundation: Guidelines for the Management of Severe Traumatic Brain Injury, 4th Edition, Neurosurgery 2017. DOI: 10.1227/NEU.0000000000001432.',
  null,
  null,
  'Brain Trauma Foundation: Guidelines for the Management of Severe Traumatic Brain Injury, 4th Edition, Neurosurgery 2017. DOI: 10.1227/NEU.0000000000001432.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-tbi-btf-2017-372ee4b43c67',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/27654000/',
  'Brain Trauma Foundation: Guidelines for the Management of Severe Traumatic Brain Injury, 4th edition, 2016; Surgical Management of Acute Epidural Hematomas, 2006.',
  null,
  null,
  'Brain Trauma Foundation: Guidelines for the Management of Severe Traumatic Brain Injury, 4th edition, 2016; Surgical Management of Acute Epidural Hematomas, 2006.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-tg18-cholangitis-dx-e3a1eb5fa836',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/29032610/',
  'Tokyo Guidelines 2018: diagnostic criteria and severity grading of acute cholangitis. DOI: 10.1002/jhbp.512.',
  null,
  null,
  'Tokyo Guidelines 2018: diagnostic criteria and severity grading of acute cholangitis. DOI: 10.1002/jhbp.512.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-tg18-cholangitis-dx-ef32f039c76b',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/29032610/',
  'Kiriyama S et al. Tokyo Guidelines 2018: diagnostic criteria and severity grading of acute cholangitis. J Hepatobiliary Pancreat Sci 2018.',
  null,
  null,
  'Kiriyama S et al. Tokyo Guidelines 2018: diagnostic criteria and severity grading of acute cholangitis. J Hepatobiliary Pancreat Sci 2018.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-tg18-cholangitis-mgmt-1e9fa1496256',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/28941329/',
  'Tokyo Guidelines 2018: initial management of acute biliary infection and flowchart for acute cholangitis. DOI: 10.1002/jhbp.509.',
  null,
  null,
  'Tokyo Guidelines 2018: initial management of acute biliary infection and flowchart for acute cholangitis. DOI: 10.1002/jhbp.509.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-tg18-cholangitis-mgmt-fdc2d1f4ac6c',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/28941329/',
  'Miura F et al. Tokyo Guidelines 2018: initial management of acute biliary infection and flowchart for acute cholangitis. J Hepatobiliary Pancreat Sci 2018.',
  null,
  null,
  'Miura F et al. Tokyo Guidelines 2018: initial management of acute biliary infection and flowchart for acute cholangitis. J Hepatobiliary Pancreat Sci 2018.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-tg18-cholecystitis-dx',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/29032636/',
  'Yokoe M et al. Tokyo Guidelines 2018: diagnostic criteria and severity grading of acute cholecystitis. J Hepatobiliary Pancreat Sci 2018.',
  null,
  null,
  'Yokoe M et al. Tokyo Guidelines 2018: diagnostic criteria and severity grading of acute cholecystitis. J Hepatobiliary Pancreat Sci 2018.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-tg18-cholecystitis-flow',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/29045062/',
  'Miura F et al. Tokyo Guidelines 2018: flowchart for the management of acute cholecystitis. J Hepatobiliary Pancreat Sci 2018.',
  null,
  null,
  'Miura F et al. Tokyo Guidelines 2018: flowchart for the management of acute cholecystitis. J Hepatobiliary Pancreat Sci 2018.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-thai-ngoai-tu-cung-vo-2',
  '1.0.0',
  'other',
  'European Society of Human Reproduction and Embryology, Guideline on the Management of Ectopic Pregnancy, 2022.',
  'European Society of Human Reproduction and Embryology, Guideline on the Management of Ectopic Pregnancy, 2022.',
  null,
  null,
  'European Society of Human Reproduction and Embryology, Guideline on the Management of Ectopic Pregnancy, 2022.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-thoai-hoa-khop-goi-han-that-1',
  '1.0.0',
  'other',
  'American College of Rheumatology and Arthritis Foundation, 2019 Guideline for the Management of Osteoarthritis of the Hand, Hip, and Knee.',
  'American College of Rheumatology and Arthritis Foundation, 2019 Guideline for the Management of Osteoarthritis of the Hand, Hip, and Knee.',
  null,
  null,
  'American College of Rheumatology and Arthritis Foundation, 2019 Guideline for the Management of Osteoarthritis of the Hand, Hip, and Knee.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-thoai-hoa-khop-goi-han-that-2',
  '1.0.0',
  'other',
  'Osteoarthritis Research Society International, OARSI Guidelines for the Non-Surgical Management of Knee, Hip, and Polyarticular Osteoarthritis, 2019.',
  'Osteoarthritis Research Society International, OARSI Guidelines for the Non-Surgical Management of Knee, Hip, and Polyarticular Osteoarthritis, 2019.',
  null,
  null,
  'Osteoarthritis Research Society International, OARSI Guidelines for the Non-Surgical Management of Knee, Hip, and Polyarticular Osteoarthritis, 2019.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-thong-phong-1',
  '1.0.0',
  'other',
  'American College of Rheumatology, 2020 Guideline for the Management of Gout.',
  'American College of Rheumatology, 2020 Guideline for the Management of Gout.',
  null,
  null,
  'American College of Rheumatology, 2020 Guideline for the Management of Gout.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-thyroid-ata-2016',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/27521067/',
  'Ross DS, et al. 2016 American Thyroid Association Guidelines for Diagnosis and Management of Hyperthyroidism and Other Causes of Thyrotoxicosis. Thyroid 2016.',
  null,
  null,
  'Ross DS, et al. 2016 American Thyroid Association Guidelines for Diagnosis and Management of Hyperthyroidism and Other Causes of Thyrotoxicosis. Thyroid 2016.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-thyroid-nodule-ata-2015',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/26462967/',
  '2015 American Thyroid Association Management Guidelines for Adult Patients with Thyroid Nodules and Differentiated Thyroid Cancer.',
  null,
  null,
  '2015 American Thyroid Association Management Guidelines for Adult Patients with Thyroid Nodules and Differentiated Thyroid Cancer.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-thyroid-storm-jts-2016',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/27746415/',
  'Satoh T, et al. 2016 Guidelines for the management of thyroid storm from the Japan Thyroid Association and Japan Endocrine Society. Endocr J 2016.',
  null,
  null,
  'Satoh T, et al. 2016 Guidelines for the management of thyroid storm from the Japan Thyroid Association and Japan Endocrine Society. Endocr J 2016.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-tirads-acr-2017',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/28372962/',
  'ACR TI-RADS, American College of Radiology, 2017.',
  null,
  null,
  'ACR TI-RADS, American College of Radiology, 2017.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-toa-cot-phong-thoat-vi-dia-dem-1',
  '1.0.0',
  'other',
  'North American Spine Society, Evidence-Based Clinical Guidelines for Multidisciplinary Spine Care: Diagnosis and Treatment of Lumbar Disc Herniation with Radiculopathy, 2012.',
  'North American Spine Society, Evidence-Based Clinical Guidelines for Multidisciplinary Spine Care: Diagnosis and Treatment of Lumbar Disc Herniation with Radiculopathy, 2012.',
  null,
  null,
  'North American Spine Society, Evidence-Based Clinical Guidelines for Multidisciplinary Spine Care: Diagnosis and Treatment of Lumbar Disc Herniation with Radiculopathy, 2012.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-toa-cot-phong-thoat-vi-dia-dem-2',
  '1.0.0',
  'other',
  'NICE, Low Back Pain and Sciatica in Over 16s: Assessment and Management, NG59, 2016, cập nhật 2020.',
  'NICE, Low Back Pain and Sciatica in Over 16s: Assessment and Management, NG59, 2016, cập nhật 2020.',
  null,
  null,
  'NICE, Low Back Pain and Sciatica in Over 16s: Assessment and Management, NG59, 2016, cập nhật 2020.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-tonsillectomy-aaohns-2019',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/30798778/',
  'Clinical practice guideline: Tonsillectomy in children (update), Otolaryngology-Head and Neck Surgery 2019. DOI: 10.1177/0194599818801757.',
  null,
  null,
  'Clinical practice guideline: Tonsillectomy in children (update), Otolaryngology-Head and Neck Surgery 2019. DOI: 10.1177/0194599818801757.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-toxic-alcohols-kraut-2018',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/29342392/',
  'Kraut JA, Mullins ME. Toxic alcohols. N Engl J Med 2018;378:270-280.',
  null,
  null,
  'Kraut JA, Mullins ME. Toxic alcohols. N Engl J Med 2018;378:270-280.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-trauma-bleeding-eu-2023',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/36859355/',
  'European Guideline on Management of Major Bleeding and Coagulopathy Following Trauma, Sixth Edition, 2023.',
  null,
  null,
  'European Guideline on Management of Major Bleeding and Coagulopathy Following Trauma, Sixth Edition, 2023.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-twist-barbosa-2013',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/23103800/',
  'Barbosa JA và cs. Development and initial validation of a scoring system to diagnose testicular torsion in children (TWIST). J Urol, 2013.',
  null,
  null,
  'Barbosa JA và cs. Development and initial validation of a scoring system to diagnose testicular torsion in children (TWIST). J Urol, 2013.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ugib-acg-2021-18648f1657f7',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/33929377/',
  'ACG Clinical Guideline: Upper Gastrointestinal and Ulcer Bleeding, Am J Gastroenterol 2021. DOI: 10.14309/ajg.0000000000001245.',
  null,
  null,
  'ACG Clinical Guideline: Upper Gastrointestinal and Ulcer Bleeding, Am J Gastroenterol 2021. DOI: 10.14309/ajg.0000000000001245.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ugib-acg-2021-8821478c1bdd',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/33929377/',
  'Laine L, Barkun AN, Saltzman JR, et al. ACG Clinical Guideline: Upper Gastrointestinal and Ulcer Bleeding, 2021. https://pubmed.ncbi.nlm.nih.gov/33929377/ . Trích: “red blood cell transfusion at a threshold of 7 g/dL ... endoscopy is suggested within 24 hours after presentation.”',
  null,
  null,
  'Laine L, Barkun AN, Saltzman JR, et al. ACG Clinical Guideline: Upper Gastrointestinal and Ulcer Bleeding, 2021. https://pubmed.ncbi.nlm.nih.gov/33929377/ . Trích: “red blood cell transfusion at a threshold of 7 g/dL ... endoscopy is suggested within 24 hours after presentation.”',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ugib-ican-2019',
  '1.0.0',
  'article',
  'https://pubmed.ncbi.nlm.nih.gov/31634917/',
  'International Consensus Group recommendations on nonvariceal upper gastrointestinal bleeding, Ann Intern Med 2019. DOI: 10.7326/M18-1795.',
  null,
  null,
  'International Consensus Group recommendations on nonvariceal upper gastrointestinal bleeding, Ann Intern Med 2019. DOI: 10.7326/M18-1795.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ukka-hyperkalaemia-94982ae0fdbd',
  '1.0.0',
  'guideline',
  'https://ukkidney.org/guidelines/joint-guidelines/treatment-of-acute-hyperkalaemia-in-adults',
  'UK Kidney Association. Clinical Practice Guideline: Management of Hyperkalaemia in Adults, 2023. https://www.ukkidney.org/sites/default/files/FINAL%20VERSION%20-%20UKKA%20CLINICAL%20PRACTICE%20GUIDELINE%20-%20MANAGEMENT%20OF%20HYPERKALAEMIA%20IN%20ADULTS%20-%20191223.pdf . Trích: “30ml 10% Calcium Gluconate over 10 minutes”; “10 units soluble insulin in 25g glucose”; “K+ ≥ 6.5 mmol/l”.',
  null,
  null,
  'UK Kidney Association. Clinical Practice Guideline: Management of Hyperkalaemia in Adults, 2023. https://www.ukkidney.org/sites/default/files/FINAL%20VERSION%20-%20UKKA%20CLINICAL%20PRACTICE%20GUIDELINE%20-%20MANAGEMENT%20OF%20HYPERKALAEMIA%20IN%20ADULTS%20-%20191223.pdf . Trích: “30ml 10% Calcium Gluconate over 10 minutes”; “10 units soluble insulin in 25g glucose”; “K+ ≥ 6.5 mmol/l”.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-ukka-hyperkalaemia-fef384dbb02e',
  '1.0.0',
  'guideline',
  'https://ukkidney.org/guidelines/joint-guidelines/treatment-of-acute-hyperkalaemia-in-adults',
  'UK Kidney Association. Clinical Practice Guidelines: Treatment of Acute Hyperkalaemia in Adults, bản 2023.',
  null,
  null,
  'UK Kidney Association. Clinical Practice Guidelines: Treatment of Acute Hyperkalaemia in Adults, bản 2023.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-viem-quanh-khop-vai-dong-cung-1',
  '1.0.0',
  'other',
  'Kelley MJ và cs., Shoulder Pain and Mobility Deficits: Adhesive Capsulitis, Journal of Orthopaedic and Sports Physical Therapy Clinical Practice Guidelines, 2013.',
  'Kelley MJ và cs., Shoulder Pain and Mobility Deficits: Adhesive Capsulitis, Journal of Orthopaedic and Sports Physical Therapy Clinical Practice Guidelines, 2013.',
  null,
  null,
  'Kelley MJ và cs., Shoulder Pain and Mobility Deficits: Adhesive Capsulitis, Journal of Orthopaedic and Sports Physical Therapy Clinical Practice Guidelines, 2013.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-who-hbv-2024',
  '1.0.0',
  'guideline',
  'https://who.int/publications/i/item/9789240090903',
  'WHO, Guidelines for the prevention, diagnosis, care and treatment for people with chronic hepatitis B infection, 2024. https://www.who.int/publications/i/item/9789240090903',
  null,
  null,
  'WHO, Guidelines for the prevention, diagnosis, care and treatment for people with chronic hepatitis B infection, 2024. https://www.who.int/publications/i/item/9789240090903',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-who-searo-snakebite-2016',
  '1.0.0',
  'guideline',
  'https://www.who.int/publications/i/item/9789290225300',
  'World Health Organization, Regional Office for South-East Asia. Guidelines for the management of snakebite, 2nd edition, 2016.',
  null,
  null,
  'World Health Organization, Regional Office for South-East Asia. Guidelines for the management of snakebite, 2nd edition, 2016.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-who-tetanus-2017',
  '1.0.0',
  'guideline',
  'https://www.who.int/publications/i/item/WHO-WER9206',
  'WHO: Tetanus vaccines, position paper, Weekly Epidemiological Record, 2017.',
  null,
  null,
  'WHO: Tetanus vaccines, position paper, Weekly Epidemiological Record, 2017.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yeu-thong-1',
  '1.0.0',
  'other',
  'NICE, Low Back Pain and Sciatica in Over 16s: Assessment and Management, NG59, 2016, cập nhật 2020.',
  'NICE, Low Back Pain and Sciatica in Over 16s: Assessment and Management, NG59, 2016, cập nhật 2020.',
  null,
  null,
  'NICE, Low Back Pain and Sciatica in Over 16s: Assessment and Management, NG59, 2016, cập nhật 2020.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-001-1',
  '1.0.0',
  'other',
  'Aletaha D, et al. 2010 Rheumatoid Arthritis Classification Criteria, ACR/EULAR Collaborative Initiative. Arthritis Rheum 2010.',
  'Aletaha D, et al. 2010 Rheumatoid Arthritis Classification Criteria, ACR/EULAR Collaborative Initiative. Arthritis Rheum 2010.',
  null,
  null,
  'Aletaha D, et al. 2010 Rheumatoid Arthritis Classification Criteria, ACR/EULAR Collaborative Initiative. Arthritis Rheum 2010.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-001-2',
  '1.0.0',
  'other',
  'Smolen JS, et al. EULAR recommendations for the management of rheumatoid arthritis, update.',
  'Smolen JS, et al. EULAR recommendations for the management of rheumatoid arthritis, update.',
  null,
  null,
  'Smolen JS, et al. EULAR recommendations for the management of rheumatoid arthritis, update.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-002-2',
  '1.0.0',
  'other',
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị hen phế quản ở người lớn.',
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị hen phế quản ở người lớn.',
  null,
  null,
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị hen phế quản ở người lớn.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-003-1',
  '1.0.0',
  'other',
  'Lacy BE, et al. Bowel Disorders. Gastroenterology 2016 (Rome IV).',
  'Lacy BE, et al. Bowel Disorders. Gastroenterology 2016 (Rome IV).',
  null,
  null,
  'Lacy BE, et al. Bowel Disorders. Gastroenterology 2016 (Rome IV).',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-003-2',
  '1.0.0',
  'other',
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị hội chứng ruột kích thích.',
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị hội chứng ruột kích thích.',
  null,
  null,
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị hội chứng ruột kích thích.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-004-1',
  '1.0.0',
  'other',
  'Fokkens WJ, et al. European Position Paper on Rhinosinusitis and Nasal Polyps (EPOS), Rhinology.',
  'Fokkens WJ, et al. European Position Paper on Rhinosinusitis and Nasal Polyps (EPOS), Rhinology.',
  null,
  null,
  'Fokkens WJ, et al. European Position Paper on Rhinosinusitis and Nasal Polyps (EPOS), Rhinology.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-004-2',
  '1.0.0',
  'other',
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị bệnh tai mũi họng.',
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị bệnh tai mũi họng.',
  null,
  null,
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị bệnh tai mũi họng.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-005-1',
  '1.0.0',
  'other',
  'Hội Ngoại khoa Việt Nam, hướng dẫn chẩn đoán và điều trị bệnh trĩ.',
  'Hội Ngoại khoa Việt Nam, hướng dẫn chẩn đoán và điều trị bệnh trĩ.',
  null,
  null,
  'Hội Ngoại khoa Việt Nam, hướng dẫn chẩn đoán và điều trị bệnh trĩ.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-005-2',
  '1.0.0',
  'other',
  'Davis BR, et al. The American Society of Colon and Rectal Surgeons Clinical Practice Guidelines for the Management of Hemorrhoids. Dis Colon Rectum 2018.',
  'Davis BR, et al. The American Society of Colon and Rectal Surgeons Clinical Practice Guidelines for the Management of Hemorrhoids. Dis Colon Rectum 2018.',
  null,
  null,
  'Davis BR, et al. The American Society of Colon and Rectal Surgeons Clinical Practice Guidelines for the Management of Hemorrhoids. Dis Colon Rectum 2018.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-006-1',
  '1.0.0',
  'other',
  'Hội Tim mạch học Việt Nam, Khuyến cáo chẩn đoán và điều trị tăng huyết áp.',
  'Hội Tim mạch học Việt Nam, Khuyến cáo chẩn đoán và điều trị tăng huyết áp.',
  null,
  null,
  'Hội Tim mạch học Việt Nam, Khuyến cáo chẩn đoán và điều trị tăng huyết áp.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-006-2',
  '1.0.0',
  'other',
  'Mancia G, et al. 2023 ESH Guidelines for the management of arterial hypertension. J Hypertens 2023.',
  'Mancia G, et al. 2023 ESH Guidelines for the management of arterial hypertension. J Hypertens 2023.',
  null,
  null,
  'Mancia G, et al. 2023 ESH Guidelines for the management of arterial hypertension. J Hypertens 2023.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-007-2',
  '1.0.0',
  'other',
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị sỏi tiết niệu.',
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị sỏi tiết niệu.',
  null,
  null,
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị sỏi tiết niệu.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-008-1',
  '1.0.0',
  'other',
  'Dworkin RH, et al. Recommendations for the management of herpes zoster. Clin Infect Dis 2007.',
  'Dworkin RH, et al. Recommendations for the management of herpes zoster. Clin Infect Dis 2007.',
  null,
  null,
  'Dworkin RH, et al. Recommendations for the management of herpes zoster. Clin Infect Dis 2007.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-008-2',
  '1.0.0',
  'other',
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị bệnh da liễu.',
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị bệnh da liễu.',
  null,
  null,
  'Bộ Y tế, Hướng dẫn chẩn đoán và điều trị bệnh da liễu.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-101-1',
  '1.0.0',
  'other',
  'American College of Obstetricians and Gynecologists, Committee Opinion No. 760: Dysmenorrhea and Endometriosis in the Adolescent, Obstet Gynecol 2018;132:e249-e258.',
  'American College of Obstetricians and Gynecologists, Committee Opinion No. 760: Dysmenorrhea and Endometriosis in the Adolescent, Obstet Gynecol 2018;132:e249-e258.',
  null,
  null,
  'American College of Obstetricians and Gynecologists, Committee Opinion No. 760: Dysmenorrhea and Endometriosis in the Adolescent, Obstet Gynecol 2018;132:e249-e258.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-102-1',
  '1.0.0',
  'other',
  'Academy of Breastfeeding Medicine, Clinical Protocol #9: Use of Galactagogues in Initiating or Augmenting Maternal Milk Supply, 2018 revision.',
  'Academy of Breastfeeding Medicine, Clinical Protocol #9: Use of Galactagogues in Initiating or Augmenting Maternal Milk Supply, 2018 revision.',
  null,
  null,
  'Academy of Breastfeeding Medicine, Clinical Protocol #9: Use of Galactagogues in Initiating or Augmenting Maternal Milk Supply, 2018 revision.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-102-2',
  '1.0.0',
  'other',
  'World Health Organization, Guideline: Counselling of Women to Improve Breastfeeding Practices, 2018.',
  'World Health Organization, Guideline: Counselling of Women to Improve Breastfeeding Practices, 2018.',
  null,
  null,
  'World Health Organization, Guideline: Counselling of Women to Improve Breastfeeding Practices, 2018.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-103-1',
  '1.0.0',
  'other',
  'Chang AB, et al., Management of Children With Chronic Wet Cough and Protracted Bacterial Bronchitis: CHEST Guideline and Expert Panel Report, Chest 2017;151:884-890.',
  'Chang AB, et al., Management of Children With Chronic Wet Cough and Protracted Bacterial Bronchitis: CHEST Guideline and Expert Panel Report, Chest 2017;151:884-890.',
  null,
  null,
  'Chang AB, et al., Management of Children With Chronic Wet Cough and Protracted Bacterial Bronchitis: CHEST Guideline and Expert Panel Report, Chest 2017;151:884-890.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-103-2',
  '1.0.0',
  'other',
  'World Health Organization, Pocket Book of Hospital Care for Children, 2nd edition, 2013.',
  'World Health Organization, Pocket Book of Hospital Care for Children, 2nd edition, 2013.',
  null,
  null,
  'World Health Organization, Pocket Book of Hospital Care for Children, 2nd edition, 2013.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-104-1',
  '1.0.0',
  'other',
  'World Health Organization, WHO Child Growth Standards, 2006.',
  'World Health Organization, WHO Child Growth Standards, 2006.',
  null,
  null,
  'World Health Organization, WHO Child Growth Standards, 2006.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-104-2',
  '1.0.0',
  'other',
  'World Health Organization, WHO guideline on the prevention and management of wasting and nutritional oedema (acute malnutrition) in infants and children under 5 years, 2023.',
  'World Health Organization, WHO guideline on the prevention and management of wasting and nutritional oedema (acute malnutrition) in infants and children under 5 years, 2023.',
  null,
  null,
  'World Health Organization, WHO guideline on the prevention and management of wasting and nutritional oedema (acute malnutrition) in infants and children under 5 years, 2023.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-105-1',
  '1.0.0',
  'other',
  'Austin PF, et al., The standardization of terminology of lower urinary tract function in children and adolescents: Update report from the Standardization Committee of the International Children''s Continence Society, Neurourol Urodyn 2016;35:471-481.',
  'Austin PF, et al., The standardization of terminology of lower urinary tract function in children and adolescents: Update report from the Standardization Committee of the International Children''s Continence Society, Neurourol Urodyn 2016;35:471-481.',
  null,
  null,
  'Austin PF, et al., The standardization of terminology of lower urinary tract function in children and adolescents: Update report from the Standardization Committee of the International Children''s Continence Society, Neurourol Urodyn 2016;35:471-481.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-105-2',
  '1.0.0',
  'other',
  'National Institute for Health and Care Excellence, Bedwetting in under 19s, Clinical guideline CG111, 2010.',
  'National Institute for Health and Care Excellence, Bedwetting in under 19s, Clinical guideline CG111, 2010.',
  null,
  null,
  'National Institute for Health and Care Excellence, Bedwetting in under 19s, Clinical guideline CG111, 2010.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-106-1',
  '1.0.0',
  'other',
  'Zuberbier T, et al., The international EAACI/GA2LEN/EuroGuiDerm/APAAACI guideline for the definition, classification, diagnosis, and management of urticaria, Allergy 2022;77:734-766.',
  'Zuberbier T, et al., The international EAACI/GA2LEN/EuroGuiDerm/APAAACI guideline for the definition, classification, diagnosis, and management of urticaria, Allergy 2022;77:734-766.',
  null,
  null,
  'Zuberbier T, et al., The international EAACI/GA2LEN/EuroGuiDerm/APAAACI guideline for the definition, classification, diagnosis, and management of urticaria, Allergy 2022;77:734-766.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-107-2',
  '1.0.0',
  'other',
  'World Health Organization, Haemoglobin concentrations for the diagnosis of anaemia and assessment of severity, 2011.',
  'World Health Organization, Haemoglobin concentrations for the diagnosis of anaemia and assessment of severity, 2011.',
  null,
  null,
  'World Health Organization, Haemoglobin concentrations for the diagnosis of anaemia and assessment of severity, 2011.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

insert into can_lam_sang_private.resources (
  resource_id, schema_version, resource_type, source, title,
  organization, year_version, citation, checked_date, reviewer,
  review_status, license, provenance_tags
) values (
  'legacy-yhct-kham-108-1',
  '1.0.0',
  'other',
  'Blanpied PR, et al., Neck Pain: Revision 2017, Clinical Practice Guidelines, J Orthop Sports Phys Ther 2017;47:A1-A83.',
  'Blanpied PR, et al., Neck Pain: Revision 2017, Clinical Practice Guidelines, J Orthop Sports Phys Ther 2017;47:A1-A83.',
  null,
  null,
  'Blanpied PR, et al., Neck Pain: Revision 2017, Clinical Practice Guidelines, J Orthop Sports Phys Ther 2017;47:A1-A83.',
  null,
  null,
  'CHUA_DUYET',
  null,
  array['legacy_unverified']::text[]
)
on conflict (resource_id) do update set
  schema_version = excluded.schema_version,
  resource_type = excluded.resource_type,
  source = excluded.source,
  title = excluded.title,
  organization = excluded.organization,
  year_version = excluded.year_version,
  citation = excluded.citation,
  checked_date = excluded.checked_date,
  reviewer = excluded.reviewer,
  review_status = excluded.review_status,
  license = excluded.license,
  provenance_tags = excluded.provenance_tags;

commit;
