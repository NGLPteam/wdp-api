SELECT DISTINCT ON (harvest_source_id, harvest_set_id, harvest_mapping_id)
  harvest_source_id, harvest_set_id, harvest_mapping_id, id AS harvest_attempt_id
  FROM harvest_attempts
  ORDER BY harvest_source_id, harvest_set_id, harvest_mapping_id, created_at DESC
;
