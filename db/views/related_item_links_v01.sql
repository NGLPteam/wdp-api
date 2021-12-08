SELECT source_id, target_id, src.schema_version_id
  FROM entity_links
  INNER JOIN items src ON src.id = source_id
  INNER JOIN items tgt ON tgt.id = target_id AND tgt.schema_version_id = src.schema_version_id
  WHERE source_type = 'Item' AND target_type = 'Item'
