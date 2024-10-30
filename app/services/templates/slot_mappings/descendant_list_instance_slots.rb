# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::DescendantListInstance
    # @see Templates::SlotMappings::DescendantListDefinitionSlots
    class DescendantListInstanceSlots < AbstractInstanceSlots
      inline! :header
      inline! :header_aside
      inline! :metadata
      inline! :subtitle
    end
  end
end
