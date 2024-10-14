# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::ListItemDefinition
    class ListItemDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::ListItemInstanceSlots

      block! :sample_block

      inline! :sample_inline
    end
  end
end
