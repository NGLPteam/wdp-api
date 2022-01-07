SELECT sv.id AS schema_version_id,
  ent.entity_id,
  ent.entity_type,
  ord.id AS ordering_id,
  svo.identifier,
  conditions.*,
  CASE
  WHEN missing THEN 'missing'
  WHEN mismatch THEN 'mismatch'
  WHEN modified THEN 'modified'
  ELSE
    'pristine'
  END AS status
  FROM schema_versions sv
  CROSS JOIN unnest(sv.ordering_identifiers) AS svo(identifier)
  INNER JOIN entities ent ON
    ent.schema_version_id = sv.id AND ent.link_operator IS NULL
  LEFT OUTER JOIN orderings ord ON
    ord.entity_type = ent.entity_type AND ord.entity_id = ent.entity_id AND ord.identifier = svo.identifier
  LEFT JOIN LATERAL (
    SELECT
      ord.id IS NULL AS missing,
      ord.id IS NOT NULL AND NOT ord.pristine AS modified,
      ord.id IS NOT NULL AND ord.schema_version_id IS DISTINCT FROM sv.id AS mismatch
  ) conditions ON true
;
