# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::BlurbInstance
    # @see Templates::SlotMappings::BlurbDefinitionSlots
    class BlurbInstanceSlots < AbstractInstanceSlots
      block! :body
      inline! :header
      inline! :subheader
    end
  end
end
