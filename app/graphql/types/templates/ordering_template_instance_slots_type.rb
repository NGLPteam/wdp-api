# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::OrderingInstanceSlots
    class OrderingTemplateInstanceSlotsType < AbstractInstanceSlotMapping
      description <<~TEXT
      Rendered slots for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::OrderingInstanceSlots
    end
  end
end
