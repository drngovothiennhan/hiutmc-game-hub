begin;

update can_lam_sang_private.cls_publish_config
set
  unreviewed_enabled = true,
  unreviewed_expires_at = '2026-10-12 23:59:59+07'
where config_id = true;

commit;
