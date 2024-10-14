# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::NavigationDefinitionSlots
    class NavigationTemplateDefinitionSlotsType < AbstractDefinitionSlotMapping
      description <<~TEXT
      Slot definitions for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::NavigationDefinitionSlots
    end
  end
end
