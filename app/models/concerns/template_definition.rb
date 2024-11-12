# frozen_string_literal: true

module TemplateDefinition
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  include HasLayoutKind
  include HasTemplateKind

  included do
    scope :sans_positions, ->(*positions) do
      positions.flatten!.uniq!

      next all if positions.blank?

      where.not(position: positions)
    end
  end

  monadic_matcher! def export(...)
    call_operation("templates.config.export", self, ...)
  end

  # @return [{ String => Object }]
  def export_properties
    slice(*template_record.property_names_for_configuration)
      .transform_values(&:as_json)
      .deep_stringify_keys
  end

  # @see Templates::SlotMappings::AbstractSlots#export
  # @return [{ String => String, nil }]
  def export_slots
    slots.export
  end

  # @see Templates::Renderer
  # @return [Dry::Monads::Success(TemplateInstance)]
  monadic_matcher! def render(...)
    call_operation("templates.render", self, ...)
  end

  monadic_operation! def render_slots(entity:)
    call_operation("templates.definitions.render_slots", self, entity)
  end
end
