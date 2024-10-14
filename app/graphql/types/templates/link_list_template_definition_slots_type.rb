# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::LinkListDefinitionSlots
    class LinkListTemplateDefinitionSlotsType < AbstractDefinitionSlotMapping
      description <<~TEXT
      Slot definitions for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::LinkListDefinitionSlots
    end
  end
end
