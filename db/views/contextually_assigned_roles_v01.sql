SELECT
  cp.hierarchical_id, cp.hierarchical_type, cp.user_id, r.role_id
  FROM contextual_permissions cp
  LEFT JOIN LATERAL (
    SELECT role_id FROM unnest(cp.role_ids) AS x(role_id)
  ) r on TRUE
  WHERE r.role_id IS NOT NULL
;
