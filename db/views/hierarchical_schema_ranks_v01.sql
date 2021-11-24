SELECT
  ent.entity_type,
  ent.entity_id,
  sv.schema_definition_id AS schema_definition_id,
  COUNT(DISTINCT crumb.schema_version_id) AS distinct_version_count,
  COUNT(*) AS schema_count,
  mode() WITHIN GROUP (ORDER BY crumb.depth) AS schema_rank
  FROM entities ent
  INNER JOIN entities crumb ON
    ent.auth_path @> crumb.auth_path
    AND
    crumb.entity_id <> ent.entity_id
    AND
    crumb.link_operator IS NULL
  INNER JOIN schema_versions sv ON crumb.schema_version_id = sv.id
  GROUP BY 1, 2, 3
  ORDER BY
    mode() WITHIN GROUP (ORDER BY crumb.depth) ASC,
    COUNT(*) DESC
