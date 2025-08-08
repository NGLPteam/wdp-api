# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::DetailInstance
    # @see Templates::SlotMappings::DetailDefinitionSlots
    class DetailInstanceSlots < AbstractInstanceSlots
      block! :body
      inline! :header
      block! :items_a
      block! :items_b
      block! :items_c
      block! :items_d
      inline! :subheader
      block! :summary
    end
  end
end
