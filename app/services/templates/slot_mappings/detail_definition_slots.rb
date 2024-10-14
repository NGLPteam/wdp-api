# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::DetailDefinition
    class DetailDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::DetailInstanceSlots

      block! :sample_block

      inline! :sample_inline
    end
  end
end
