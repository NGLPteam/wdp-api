# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::LinkListInstanceSlots
    class LinkListTemplateInstanceSlotsType < AbstractInstanceSlotMapping
      description <<~TEXT
      Rendered slots for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::LinkListInstanceSlots
    end
  end
end
