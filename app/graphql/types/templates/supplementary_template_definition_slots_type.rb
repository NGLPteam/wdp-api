# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::SupplementaryDefinitionSlots
    class SupplementaryTemplateDefinitionSlotsType < AbstractDefinitionSlotMapping
      description <<~TEXT
      Slot definitions for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::SupplementaryDefinitionSlots
    end
  end
end
