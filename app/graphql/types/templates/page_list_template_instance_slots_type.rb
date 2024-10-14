# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::PageListInstanceSlots
    class PageListTemplateInstanceSlotsType < AbstractInstanceSlotMapping
      description <<~TEXT
      Rendered slots for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::PageListInstanceSlots
    end
  end
end
