# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::OrderingInstance
    class OrderingInstanceSlots < AbstractInstanceSlots
      inline! :previous_label
      inline! :next_label
    end
  end
end
