# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::PageListDefinitionSlots
    class PageListTemplateDefinitionSlotsType < AbstractDefinitionSlotMapping
      description <<~TEXT
      Slot definitions for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::PageListDefinitionSlots
    end
  end
end
