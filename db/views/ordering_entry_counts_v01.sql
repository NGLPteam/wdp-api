SELECT
  ordering_id,
  COUNT(*) FILTER (WHERE visible) AS visible_count,
  COUNT(*) AS entries_count
FROM ordering_entries oe
LEFT OUTER JOIN entity_visibilities ev USING (entity_type, entity_id)
LEFT JOIN LATERAL (
  SELECT
  CASE ev.visibility
  WHEN 'visible' THEN TRUE
  WHEN 'hidden' THEN FALSE
  WHEN 'limited' THEN ev.visibility_range @> CURRENT_TIMESTAMP
  ELSE FALSE END AS visible
) visibility ON true
GROUP BY ordering_id
