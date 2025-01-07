SELECT
  hierarchical_id,
  hierarchical_type,
  gp.user_id,
  gp.access_grant_id
  FROM granted_permissions gp
  INNER JOIN authorizing_entities ent ON gp.auth_path = ent.auth_path AND gp.scope = ent.scope
  LEFT JOIN LATERAL (
    SELECT
      accessible_type = hierarchical_type AND accessible_id = hierarchical_id AS directly_assigned
  ) info ON true
  WHERE
  (NOT directly_assigned OR NOT gp.inferred)
  GROUP BY 1, 2, 3, 4
;
