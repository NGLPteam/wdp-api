SELECT DISTINCT ON (sva.name, ent.entity_id)
  ent.entity_type,
  ent.entity_id,
  sva.name,
  anc.entity_type AS ancestor_type,
  anc.entity_id AS ancestor_id,
  anc.schema_version_id AS ancestor_schema_version_id,
  ent.depth AS origin_depth,
  anc.depth AS ancestor_depth,
  ent.depth - anc.depth AS relative_depth
  FROM entities ent
  INNER JOIN schema_version_ancestors sva USING (schema_version_id)
  INNER JOIN entities anc ON
    ent.auth_path <@ anc.auth_path
    AND
    anc.entity_id <> ent.entity_id
    AND
    anc.schema_version_id = sva.target_version_id
  ORDER BY sva.name, ent.entity_id, anc.depth DESC
;
