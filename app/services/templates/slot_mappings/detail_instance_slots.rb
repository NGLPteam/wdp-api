# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::DetailInstance
    class DetailInstanceSlots < AbstractInstanceSlots
      inline! :header
      inline! :subheader
      block! :summary
    end
  end
end
