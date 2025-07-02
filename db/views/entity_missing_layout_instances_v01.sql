SELECT
  entity_type,
  entity_id,
  dld.layout_definition_type,
  layout_definition_id,
  dld.layout_kind
  FROM entity_derived_layout_definitions dld
  LEFT OUTER JOIN layouts_instance_digests lid USING (entity_type, entity_id, layout_definition_id)
  WHERE lid.layout_definition_id IS NULL
;
