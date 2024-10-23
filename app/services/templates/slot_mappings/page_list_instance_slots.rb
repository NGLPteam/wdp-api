# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::PageListInstance
    class PageListInstanceSlots < AbstractInstanceSlots
      inline! :header
    end
  end
end
