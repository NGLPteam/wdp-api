SELECT
  ent.entity_type AS parent_type,
  ent.entity_id AS parent_id,
  descendant.hierarchical_type AS descendant_type,
  descendant.hierarchical_id AS descendant_id,
  descendant.id AS entity_reference_id,
  descendant.schema_version_id AS schema_version_id,
  descendant.link_operator,
  descendant.auth_path,
  descendant.scope,
  descendant.title,
  descendant.depth AS actual_depth,
  descendant.depth - ent.depth AS relative_depth,
  descendant.created_at,
  descendant.updated_at
  FROM entities ent
  INNER JOIN entities descendant ON
    ent.auth_path <> descendant.auth_path
    AND
    ent.auth_path @> descendant.auth_path
  WHERE
    ent.link_operator IS NULL
;
