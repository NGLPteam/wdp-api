SELECT
  'Community' AS accessible_type,
  c.id AS accessible_id,
  r.id AS role_id,
  'User' AS subject_type,
  u.id AS subject_id
  FROM
  communities c
  CROSS JOIN users u
  CROSS JOIN roles r
  WHERE
    'global_admin' = ANY (u.roles)
    AND
    r.identifier = 'admin'
    AND
    NOT EXISTS (
      SELECT 1 FROM access_grants WHERE accessible_type = 'Community' AND accessible_id = c.id AND role_id = r.id AND subject_type = 'User' AND subject_id = u.id
    )
