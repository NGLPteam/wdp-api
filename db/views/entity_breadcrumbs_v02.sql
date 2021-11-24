SELECT
  ent.entity_type,
  ent.entity_id,
  ent.system_slug AS entity_slug,
  crumb.entity_type AS crumb_type,
  crumb.entity_id AS crumb_id,
  crumb.schema_version_id AS schema_version_id,
  crumb.auth_path,
  crumb.system_slug,
  crumb.depth
  FROM entities ent
  INNER JOIN entities crumb ON ent.auth_path <@ crumb.auth_path AND crumb.entity_id <> ent.entity_id
;
