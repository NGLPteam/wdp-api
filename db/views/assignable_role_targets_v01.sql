SELECT
  source.id AS source_role_id,
  row_number() OVER target_w AS priority,
  target.id AS target_role_id,
  row_number() OVER source_w AS source_priority,
  source.name AS source_name,
  target.name AS target_name
  FROM roles source
  INNER JOIN roles target ON target.priority < source.priority
  WHERE source.allowed_actions ~ '*.manage_access'
  WINDOW source_w AS (
    ORDER BY source.primacy, source.priority DESC, source.kind,
      target.primacy, target.priority DESC, target.kind
  ), target_w AS (
    PARTITION BY source.id
    ORDER BY target.primacy, target.priority DESC, target.kind
  )
  ORDER BY row_number() OVER source_w
;
