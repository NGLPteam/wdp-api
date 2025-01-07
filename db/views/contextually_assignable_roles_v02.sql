SELECT DISTINCT ON (hierarchical_id, hierarchical_type, gp.user_id, ar.target_role_id)
  hierarchical_id,
  hierarchical_type,
  gp.user_id,
  ar.target_role_id AS role_id,
  ar.priority
  FROM (
    SELECT DISTINCT user_id, accessible_id, accessible_type, role_id, auth_path, scope, inferred
    FROM granted_permissions
    WHERE action = 'self.manage_access'
  ) gp
  INNER JOIN assignable_role_targets ar ON ar.source_role_id = gp.role_id
  INNER JOIN authorizing_entities ent ON gp.auth_path = ent.auth_path AND gp.scope = ent.scope
  LEFT JOIN LATERAL (
    SELECT
      accessible_type = hierarchical_type AND accessible_id = hierarchical_id AS directly_assigned
  ) info ON true
  WHERE
  (NOT directly_assigned OR NOT gp.inferred)
;
