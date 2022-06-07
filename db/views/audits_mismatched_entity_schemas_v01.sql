WITH actual AS (
  SELECT 'Community' AS hierarchical_type, id AS hierarchical_id, schema_version_id FROM communities
  UNION ALL
  SELECT 'Collection' AS hierarchical_type, id AS hierarchical_id, schema_version_id FROM collections
  UNION ALL
  SELECT 'Item' AS hierarchical_type, id AS hierarchical_id, schema_version_id FROM items
)
SELECT ent.id AS synced_entity_id,
  ent.link_operator IS NULL AS real,
  ent.entity_id AS source_id, ent.entity_type AS source_type,
  ent.hierarchical_id, ent.hierarchical_type,
  ent.schema_version_id AS synced_schema_version_id,
  actual.schema_version_id AS actual_schema_version_id
  FROM entities ent
  INNER JOIN actual USING (hierarchical_type, hierarchical_id)
  WHERE
    actual.schema_version_id <> ent.schema_version_id
