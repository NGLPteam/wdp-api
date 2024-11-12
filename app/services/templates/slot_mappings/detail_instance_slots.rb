# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::DetailInstance
    # @see Templates::SlotMappings::DetailDefinitionSlots
    class DetailInstanceSlots < AbstractInstanceSlots
      inline! :header
      inline! :subheader
      block! :summary
      block! :body
    end
  end
end
