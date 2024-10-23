# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::ContributorListDefinition
    class ContributorListDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::ContributorListInstanceSlots

      inline! :header
    end
  end
end
