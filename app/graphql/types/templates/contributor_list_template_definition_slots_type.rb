# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SlotMappings::ContributorListDefinitionSlots
    class ContributorListTemplateDefinitionSlotsType < AbstractDefinitionSlotMapping
      description <<~TEXT
      Slot definitions for the associated template.
      TEXT

      derive_fields_from! ::Templates::SlotMappings::ContributorListDefinitionSlots
    end
  end
end
