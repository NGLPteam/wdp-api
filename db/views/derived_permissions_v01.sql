SELECT
  ent.hierarchical_type,
  ent.hierarchical_id,
  ag.user_id,
  pn.key AS name,
  COALESCE(bool_or(
    r.allowed_actions @> (text2ltree('self') || pn.path) AND ag.accessible_type = ent.hierarchical_type AND ag.accessible_id = ent.hierarchical_id
  ) OR bool_or(
    r.allowed_actions @> (ent.role_prefix || pn.path) AND ag.auth_query ~ ent.auth_path
  ), false) AS granted,
  COALESCE(bool_or(
    r.allowed_actions @> (text2ltree('self') || pn.path) AND ag.accessible_type = ent.hierarchical_type AND ag.accessible_id = ent.hierarchical_id
  ), false) AS direct_access,
  COALESCE(bool_or(
    r.allowed_actions @> (ent.role_prefix || pn.path) AND ag.auth_query ~ ent.auth_path
  ), false) AS inherited_access
  FROM entities ent
  CROSS JOIN permission_names AS pn
  INNER JOIN access_grants ag ON ag.auth_path @> ent.auth_path
  INNER JOIN roles r ON ag.role_id = r.id
  GROUP BY 1, 2, 3, 4
