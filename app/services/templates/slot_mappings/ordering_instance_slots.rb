# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::OrderingInstance
    # @see Templates::SlotMappings::OrderingDefinitionSlots
    class OrderingInstanceSlots < AbstractInstanceSlots
      inline! :next_label
      inline! :previous_label
    end
  end
end
