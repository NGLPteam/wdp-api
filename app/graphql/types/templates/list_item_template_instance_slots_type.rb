# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::ListItemInstanceSlots
    class ListItemTemplateInstanceSlotsType < AbstractInstanceSlotMapping
      description <<~TEXT
      Rendered slots for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::ListItemInstanceSlots
    end
  end
end
