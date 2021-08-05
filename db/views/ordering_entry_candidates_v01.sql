SELECT
  ent.entity_type,
  ent.entity_id,
  ent.hierarchical_type,
  ent.hierarchical_id,
  ent.auth_path,
  ent.scope,
  ent.schema_version_id,
  ent.link_operator,
  ent.depth AS entity_depth,
  sv.number AS schema_number,
  sv.parsed AS schema_parsed_number,
  sv.system_slug AS schema_slug,
  sd.kind AS schema_consumer,
  sd.identifier AS schema_identifier,
  sd.namespace AS schema_namespace,
  sd.name AS schema_name,
  ent.created_at AS entity_created_at,
  ent.updated_at AS entity_updated_at,
  src.title AS entity_title,
  src.published_on AS entity_published_on,
  src.properties AS entity_properties
  FROM entities ent
  INNER JOIN schema_versions sv ON sv.id = ent.schema_version_id
  INNER JOIN schema_definitions sd ON sd.id = sv.schema_definition_id
  LEFT OUTER JOIN entity_links link ON entity_type = 'EntityLink' AND entity_id = link.id
  LEFT OUTER JOIN collections collection ON hierarchical_type = 'Collection' AND hierarchical_id = collection.id
  LEFT OUTER JOIN items item ON hierarchical_type = 'Item' AND hierarchical_id = item.id
  LEFT JOIN LATERAL (
    SELECT
    CASE hierarchical_type
    WHEN 'Collection' THEN collection.title
    WHEN 'Item' THEN item.title
    ELSE
      NULL
    END AS title,
    CASE hierarchical_type
    WHEN 'Collection' THEN collection.published_on
    WHEN 'Item' THEN item.published_on
    ELSE
      NULL
    END AS published_on,
    CASE hierarchical_type
    WHEN 'Collection' THEN collection.properties
    WHEN 'Item' THEN item.properties
    ELSE
      NULL
    END AS properties
  ) src ON true
