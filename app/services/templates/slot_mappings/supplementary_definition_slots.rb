# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::SupplementaryDefinition
    class SupplementaryDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::SupplementaryInstanceSlots

      block! :sample_block

      inline! :sample_inline
    end
  end
end
