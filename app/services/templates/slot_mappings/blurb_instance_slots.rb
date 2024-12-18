# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::BlurbInstance
    # @see Templates::SlotMappings::BlurbDefinitionSlots
    class BlurbInstanceSlots < AbstractInstanceSlots
      inline! :header
      inline! :subheader
      block! :body
    end
  end
end
