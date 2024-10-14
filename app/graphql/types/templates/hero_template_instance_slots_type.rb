# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::HeroInstanceSlots
    class HeroTemplateInstanceSlotsType < AbstractInstanceSlotMapping
      description <<~TEXT
      Rendered slots for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::HeroInstanceSlots
    end
  end
end
