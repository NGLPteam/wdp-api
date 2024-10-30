# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::LinkListInstance
    # @see Templates::SlotMappings::LinkListDefinitionSlots
    class LinkListInstanceSlots < AbstractInstanceSlots
      inline! :header
      inline! :header_aside
      inline! :metadata
      inline! :subtitle
    end
  end
end
