# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::LinkListInstance
    class LinkListInstanceSlots < AbstractInstanceSlots
      block! :sample_block

      inline! :sample_inline
    end
  end
end
