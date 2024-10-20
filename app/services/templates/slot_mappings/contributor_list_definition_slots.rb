# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::ContributorListDefinition
    class ContributorListDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::ContributorListInstanceSlots

      block! :sample_block

      inline! :sample_inline
    end
  end
end
