# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::BlurbDefinitionSlots
    class BlurbTemplateDefinitionSlotsType < AbstractDefinitionSlotMapping
      description <<~TEXT
      Slot definitions for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::BlurbDefinitionSlots
    end
  end
end
