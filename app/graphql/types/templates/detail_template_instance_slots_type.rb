# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::DetailInstanceSlots
    class DetailTemplateInstanceSlotsType < AbstractInstanceSlotMapping
      description <<~TEXT
      Rendered slots for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::DetailInstanceSlots
    end
  end
end
