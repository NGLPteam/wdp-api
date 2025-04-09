WITH contextual_access_management AS (
  SELECT
    ag.subject_id AS user_id,
    ag.role_id,
    bool_or(r.allowed_actions ~ '*.manage_access') AS can_manage_access_contextually
  FROM access_grants ag
  INNER JOIN roles r ON r.id = ag.role_id
  WHERE ag.subject_type = 'User'
  GROUP BY ag.subject_id, ag.role_id
)
SELECT
  u.id AS user_id,
  am.can_manage_access_globally,
  am.can_manage_access_contextually,
  CASE
  WHEN am.can_manage_access_globally THEN 'global'::access_management
  WHEN am.can_manage_access_contextually THEN 'contextual'::access_management
  ELSE
    'forbidden'::access_management
  END AS access_management
FROM users u
LEFT OUTER JOIN contextual_access_management cam ON cam.user_id = u.id
LEFT JOIN LATERAL (
  SELECT 'global_admin' = ANY(u.roles) AS can_manage_access_globally,
  COALESCE(cam.can_manage_access_contextually, false) AS can_manage_access_contextually
) AS am ON TRUE
