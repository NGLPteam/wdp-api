SELECT DISTINCT ON (entity_id)
  sequence_id AS id, entity_type, entity_id, stale_at, created_at, updated_at
  FROM layout_invalidations
  ORDER BY entity_id, stale_at DESC
