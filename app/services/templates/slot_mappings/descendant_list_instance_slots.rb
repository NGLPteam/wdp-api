# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::DescendantListInstance
    # @see Templates::SlotMappings::DescendantListDefinitionSlots
    class DescendantListInstanceSlots < AbstractInstanceSlots
      inline! :block_header
      inline! :block_header_fallback
      inline! :header
      inline! :header_fallback
      inline! :header_aside
      inline! :list_context
      inline! :metadata
      inline! :subtitle
    end
  end
end
