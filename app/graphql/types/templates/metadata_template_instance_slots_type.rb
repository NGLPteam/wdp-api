# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::MetadataInstanceSlots
    class MetadataTemplateInstanceSlotsType < AbstractInstanceSlotMapping
      description <<~TEXT
      Rendered slots for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::MetadataInstanceSlots
    end
  end
end
