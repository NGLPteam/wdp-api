# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::PageListInstance
    # @see Templates::SlotMappings::PageListDefinitionSlots
    class PageListInstanceSlots < AbstractInstanceSlots
      inline! :header
    end
  end
end
