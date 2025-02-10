# frozen_string_literal: true

module Templates
  module Digests
    INSTANCE_COLUMNS = %i[
      template_instance_id
      template_instance_type
      template_definition_id
      template_definition_type
      layout_instance_id
      layout_instance_type
      layout_definition_id
      layout_definition_type
      entity_id
      entity_type
      position
      layout_kind
      template_kind
      width
      generation
      config
      slots
      last_rendered_at
      render_duration
    ].freeze
  end
end
