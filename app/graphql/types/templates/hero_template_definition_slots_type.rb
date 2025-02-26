# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::HeroDefinitionSlots
    class HeroTemplateDefinitionSlotsType < AbstractDefinitionSlotMapping
      description <<~TEXT
      Slot definitions for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::HeroDefinitionSlots
    end
  end
end
