# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::MetadataInstance
    # @see Templates::SlotMappings::MetadataDefinitionSlots
    class MetadataInstanceSlots < AbstractInstanceSlots
      inline! :header
      block! :items_a
      block! :items_b
      block! :items_c
      block! :items_d
    end
  end
end
