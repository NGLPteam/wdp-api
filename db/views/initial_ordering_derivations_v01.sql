SELECT DISTINCT ON (entity_id) ord.entity_id, ord.entity_type, ord.id AS ordering_id, ord.identifier
FROM orderings ord
LEFT OUTER JOIN ordering_entry_counts oec ON oec.ordering_id = ord.id
WHERE
  disabled_at IS NULL
  AND
  NOT hidden
ORDER BY entity_id ASC, oec.visible_count DESC NULLS LAST, ord.position ASC, ord.name ASC, ord.identifier ASC;
