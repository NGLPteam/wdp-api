# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::ListItemDefinitionSlots
    class ListItemTemplateDefinitionSlotsType < AbstractDefinitionSlotMapping
      description <<~TEXT
      Slot definitions for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::ListItemDefinitionSlots
    end
  end
end
