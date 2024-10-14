# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::OrderingDefinitionSlots
    class OrderingTemplateDefinitionSlotsType < AbstractDefinitionSlotMapping
      description <<~TEXT
      Slot definitions for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::OrderingDefinitionSlots
    end
  end
end
