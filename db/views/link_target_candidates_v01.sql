SELECT
  src.entity_type AS source_type,
  src.entity_id AS source_id,
  src.system_slug AS source_slug,
  target.entity_type AS target_type,
  target.entity_id AS target_id,
  target.auth_path,
  target.system_slug,
  target.depth,
  target.title,
  CASE WHEN target.entity_type = 'Collection' THEN target.entity_id ELSE NULL END AS collection_id,
  CASE WHEN target.entity_type = 'Item' THEN target.entity_id ELSE NULL END AS item_id,
  target.created_at,
  target.updated_at
  FROM entities src
  INNER JOIN entities target ON
    target.entity_type IN ('Collection', 'Item')
    AND
    NOT (src.auth_path <@ target.auth_path)
    AND
    src.auth_path <> target.auth_path
    AND
    NOT (src.auth_path @> target.auth_path)
  LEFT OUTER JOIN entity_links existing_link ON
    src.entity_type = existing_link.source_type
    AND
    src.entity_id = existing_link.source_id
    AND
    target.entity_type = existing_link.target_type
    AND
    target.entity_id = existing_link.target_id
  WHERE
    existing_link.id IS NULL
;
