# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::DescendantListDefinitionSlots
    class DescendantListTemplateDefinitionSlotsType < AbstractDefinitionSlotMapping
      description <<~TEXT
      Slot definitions for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::DescendantListDefinitionSlots
    end
  end
end
