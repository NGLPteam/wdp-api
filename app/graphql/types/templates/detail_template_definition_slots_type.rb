# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::DetailDefinitionSlots
    class DetailTemplateDefinitionSlotsType < AbstractDefinitionSlotMapping
      description <<~TEXT
      Slot definitions for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::DetailDefinitionSlots
    end
  end
end
