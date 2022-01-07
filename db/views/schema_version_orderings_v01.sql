SELECT sv.id AS schema_version_id,
  d.definition ->> 'id' AS identifier,
  d.definition ->> 'name' AS name,
  jsonb_to_bigint(d.definition -> 'position') AS schema_position,
  d.definition_index,
  jsonb_to_boolean(d.definition -> 'constant') AS constant,
  jsonb_to_boolean(d.definition -> 'hidden') AS hidden,
  d.definition #>> '{render,mode}' AS render_mode,
  p.paths,
  p.paths_with_direction,
  d.definition
FROM schema_versions AS sv
CROSS JOIN jsonb_array_elements(sv.configuration -> 'orderings') WITH ORDINALITY AS d(definition, definition_index)
LEFT JOIN LATERAL (
  SELECT
    array_agg(defn ->> 'path' ORDER BY position) AS paths,
    jsonb_object_agg(defn ->> 'path', defn ->> 'direction') AS paths_with_direction
  FROM jsonb_array_elements(jsonb_path_query_array(d.definition, '$.order[*]')) WITH ORDINALITY AS x(defn, position)
) AS p ON true;
