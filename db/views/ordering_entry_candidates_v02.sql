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
  ent.title AS entity_title,
  ent.created_at AS entity_created_at,
  ent.updated_at AS entity_updated_at,

  ent.properties AS entity_properties,

  sv.namespace AS schema_namespace,
  sv.identifier AS schema_identifier,
  sv.kind AS schema_kind,
  sv.number AS schema_number,
  sv.parsed AS schema_parsed_number,
  sv.declaration AS schema_version_slug,
  sd.name AS schema_name
  FROM entities ent
  INNER JOIN schema_versions sv ON sv.id = ent.schema_version_id
  INNER JOIN schema_definitions sd ON sd.id = sv.schema_definition_id
