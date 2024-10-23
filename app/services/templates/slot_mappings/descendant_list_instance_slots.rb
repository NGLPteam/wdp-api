# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::DescendantListInstance
    class DescendantListInstanceSlots < AbstractInstanceSlots
      inline! :header
      inline! :header_aside
      inline! :metadata
      inline! :subtitle
    end
  end
end
