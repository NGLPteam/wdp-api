# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::OrderingDefinition
    class OrderingDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::OrderingInstanceSlots

      inline! :previous_label
      inline! :next_label
    end
  end
end
