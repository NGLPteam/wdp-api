# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::ContributorListInstanceSlots
    class ContributorListTemplateInstanceSlotsType < AbstractInstanceSlotMapping
      description <<~TEXT
      Rendered slots for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::ContributorListInstanceSlots
    end
  end
end
