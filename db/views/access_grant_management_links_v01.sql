SELECT
  ag.id AS access_grant_id,
  csp.user_id AS user_id
  FROM access_grants ag
  INNER JOIN permissions mp ON path = 'self.manage_access'
  INNER JOIN contextual_single_permissions csp ON
    csp.hierarchical_type = ag.accessible_type
    AND
    csp.hierarchical_id = ag.accessible_id
    AND
    csp.permission_id = mp.id
;
