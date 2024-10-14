# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::MetadataDefinitionSlots
    class MetadataTemplateDefinitionSlotsType < AbstractDefinitionSlotMapping
      description <<~TEXT
      Slot definitions for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::MetadataDefinitionSlots
    end
  end
end
