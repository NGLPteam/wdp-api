SELECT
  hier.ancestor_type AS entity_type,
  hier.ancestor_id AS entity_id,
  hier.schema_definition_id AS schema_definition_id,
  hier.schema_version_id AS schema_version_id,
  COUNT(*) AS schema_count,
  mode() WITHIN GROUP (ORDER BY hier.depth) AS schema_rank
  FROM entity_hierarchies hier
  WHERE ancestor_id <> descendant_id
  GROUP BY 1, 2, 3, 4
