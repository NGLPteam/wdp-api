SELECT
  hierarchical_id,
  hierarchical_type,
  gp.user_id,
  true AS has_any_role,
  bool_or(directly_assigned) AS has_direct_role,
  array_agg(DISTINCT gp.access_grant_id) AS access_grant_ids,
  array_agg(DISTINCT gp.role_id) AS role_ids,
  array_agg(DISTINCT gp.action) AS allowed_actions,
  jsonb_auth_path(gp.action, true) AS access_control_list,
  jsonb_auth_path(subpath(gp.action, 1, nlevel(gp.action) - 1), true) FILTER (WHERE gp.action ~ 'self.*') AS grid,
  MIN(gp.created_at) AS created_at,
  MAX(gp.updated_at) AS updated_at
  FROM granted_permissions gp
  INNER JOIN authorizing_entities ent ON gp.auth_path = ent.auth_path AND gp.scope = ent.scope
  LEFT JOIN LATERAL (
    SELECT
      accessible_type = hierarchical_type AND accessible_id = hierarchical_id AS directly_assigned
  ) info ON true
  WHERE
  (NOT directly_assigned OR NOT gp.inferred)
  GROUP BY 1, 2, 3
;
