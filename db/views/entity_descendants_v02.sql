SELECT
  hier.ancestor_type AS parent_type,
  hier.ancestor_id AS parent_id,
  hier.hierarchical_type AS descendant_type,
  hier.hierarchical_id AS descendant_id,
  hier.schema_version_id AS schema_version_id,
  hier.link_operator,
  hier.auth_path,
  hier.descendant_scope AS scope,
  hier.title,
  hier.depth AS actual_depth,
  hier.generations AS relative_depth,
  hier.created_at,
  hier.updated_at
  FROM entity_hierarchies hier
  WHERE hier.ancestor_id <> hier.descendant_id
;
