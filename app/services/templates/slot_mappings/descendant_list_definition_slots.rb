# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::DescendantListDefinition
    class DescendantListDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::DescendantListInstanceSlots

      block! :sample_block

      inline! :sample_inline
    end
  end
end
