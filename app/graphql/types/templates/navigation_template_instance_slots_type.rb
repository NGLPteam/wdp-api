# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::NavigationInstanceSlots
    class NavigationTemplateInstanceSlotsType < AbstractInstanceSlotMapping
      description <<~TEXT
      Rendered slots for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::NavigationInstanceSlots
    end
  end
end
