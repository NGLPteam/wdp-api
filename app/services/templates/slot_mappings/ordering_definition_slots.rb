# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::OrderingDefinition
    class OrderingDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::OrderingInstanceSlots

      block! :sample_block

      inline! :sample_inline
    end
  end
end
