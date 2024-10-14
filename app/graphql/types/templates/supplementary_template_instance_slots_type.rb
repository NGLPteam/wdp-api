# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::SupplementaryInstanceSlots
    class SupplementaryTemplateInstanceSlotsType < AbstractInstanceSlotMapping
      description <<~TEXT
      Rendered slots for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::SupplementaryInstanceSlots
    end
  end
end
