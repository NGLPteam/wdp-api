SELECT
  hierarchical_type, hierarchical_id, user_id,
  jsonb_object_agg(name, granted) AS grid,
  jsonb_object_agg(name, jsonb_build_object('direct_access', direct_access, 'inherited_access', inherited_access)) AS debug
  FROM derived_permissions
  GROUP BY 1, 2, 3
