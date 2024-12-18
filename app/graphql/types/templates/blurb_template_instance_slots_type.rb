# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::BlurbInstanceSlots
    class BlurbTemplateInstanceSlotsType < AbstractInstanceSlotMapping
      description <<~TEXT
      Rendered slots for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::BlurbInstanceSlots
    end
  end
end
