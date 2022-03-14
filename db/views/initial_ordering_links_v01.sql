SELECT entity_type, entity_id, COALESCE(selected.ordering_id, derived.ordering_id) AS ordering_id
FROM initial_ordering_selections AS selected
FULL OUTER JOIN initial_ordering_derivations AS derived USING (entity_type, entity_id)
WHERE
  entity_type IS NOT NULL
  AND
  entity_id IS NOT NULL
  AND
  (selected.ordering_id IS NOT NULL OR derived.ordering_id IS NOT NULL)
;
