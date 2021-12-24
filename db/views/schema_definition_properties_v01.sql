WITH aggregated_versions AS (
  SELECT svp.schema_definition_id, svp.path, svp.type,
    bool_or(sv.current) AS current,
    jsonb_agg(
      jsonb_build_object(
        'id', sv.id,
        'number', sv.number,
        'slug', sv.declaration
      )
      ORDER BY sv.position DESC
    ) AS versions,
    COUNT(DISTINCT schema_version_id) AS version_count,
    array_agg(DISTINCT schema_version_id) AS covered_version_ids,
    MIN(svp.created_at) AS created_at,
    MAX(svp.updated_at) AS updated_at
    FROM schema_version_properties svp
    INNER JOIN schema_versions sv ON sv.id = svp.schema_version_id AND sv.schema_definition_id = svp.schema_definition_id
    GROUP BY 1, 2, 3
), defining_properties AS (
  SELECT DISTINCT ON (sv.schema_definition_id, svp.path, svp.type)
    sv.schema_definition_id, svp.path, svp.type, svp.kind, svp.label,
    svp.array, svp.nested, svp.orderable, svp.required, svp.extract_path,
    svp.metadata, svp.default_value
  FROM schema_version_properties AS svp
  INNER JOIN schema_versions sv ON sv.id = svp.schema_version_id AND sv.schema_definition_id = svp.schema_definition_id
  ORDER BY sv.schema_definition_id, svp.path, svp.type, sv.parsed DESC
)
SELECT dp.*,
  av.current, av.versions, av.covered_version_ids, av.version_count, av.created_at, av.updated_at
FROM aggregated_versions AS av
INNER JOIN defining_properties AS dp USING (schema_definition_id, path, type);
