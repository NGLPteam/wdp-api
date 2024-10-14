# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::DescendantListInstanceSlots
    class DescendantListTemplateInstanceSlotsType < AbstractInstanceSlotMapping
      description <<~TEXT
      Rendered slots for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::DescendantListInstanceSlots
    end
  end
end
