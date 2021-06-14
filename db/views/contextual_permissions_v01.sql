SELECT
  u.id AS user_id,
  hierarchical_id,
  hierarchical_type,
  bool_or(ag.role_id IS NOT NULL) AS has_role,
  COALESCE(bool_or(info.is_direct_role), false) AS has_direct_role,
  COALESCE(array_agg(DISTINCT ag.role_id) FILTER (WHERE ag.role_id IS NOT NULL), '{}') AS role_ids,
  COALESCE(
    array_agg(DISTINCT p.path) FILTER (WHERE access.allowed)
  , '{}') AS allowed_actions,
  jsonb_auth_path(p.path, COALESCE(access.allowed, false)) AS access_control_list,
  jsonb_auth_path(p.suffix, COALESCE(access.allowed, false)) FILTER (WHERE p.self_prefixed) AS grid
  FROM (SELECT id FROM users ORDER BY id) u
  CROSS JOIN entities AS ent
  CROSS JOIN permissions AS p
  LEFT OUTER JOIN access_grants ag ON ent.auth_path <@ ag.auth_path AND ag.user_id = u.id
  LEFT OUTER JOIN roles r ON ag.role_id = r.id
  LEFT JOIN LATERAL (
    SELECT
      accessible_type = hierarchical_type AND accessible_id = hierarchical_id AS is_direct_role,
      r.allowed_actions @> p.path AS is_allowed_action,
      ag.auth_query ~ ent.auth_path AS is_allowed_by_scope
  ) AS info ON true
  LEFT JOIN LATERAL (
    SELECT
      (info.is_allowed_action AND info.is_direct_role)
      OR
      CASE p.head
      WHEN 'self' THEN
        (r.allowed_actions @> (ent.scope || p.suffix) AND NOT is_direct_role)
      ELSE
        is_allowed_action AND NOT is_direct_role
      END AS allowed
  ) AS access ON true
  WHERE p.kind = 'contextual'
  GROUP BY 1, 2, 3
;
