SELECT source_id, target_id, src.schema_version_id
  FROM entity_links
  INNER JOIN collections src ON src.id = source_id
  INNER JOIN collections tgt ON tgt.id = target_id AND tgt.schema_version_id = src.schema_version_id
  WHERE source_type = 'Collection' AND target_type = 'Collection'
