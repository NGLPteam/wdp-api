SELECT
  hierarchical_id,
  hierarchical_type,
  gp.user_id,
  gp.permission_id,
  gp.action,
  gp.access_grant_id,
  gp.role_id,
  info.directly_assigned
  FROM granted_permissions gp
  INNER JOIN authorizing_entities ent ON gp.auth_path = ent.auth_path AND gp.scope = ent.scope
  LEFT JOIN LATERAL (
    SELECT
      accessible_type = hierarchical_type AND accessible_id = hierarchical_id AS directly_assigned
  ) info ON true
  WHERE
  (NOT directly_assigned OR NOT gp.inferred)
;
