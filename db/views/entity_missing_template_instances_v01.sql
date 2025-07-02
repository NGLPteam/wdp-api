SELECT
  entity_type,
  entity_id,
  dld.layout_definition_type,
  layout_definition_id,
  tdd.template_definition_type,
  template_definition_id,
  dld.layout_kind,
  tdd.template_kind,
  tdd.position
  FROM entity_derived_layout_definitions dld
  INNER JOIN templates_definition_digests tdd USING (layout_definition_type, layout_definition_id, layout_kind)
  LEFT OUTER JOIN templates_instance_digests tid USING (entity_type, entity_id, layout_definition_id, template_definition_id)
  WHERE tid.layout_definition_id IS NULL
;
