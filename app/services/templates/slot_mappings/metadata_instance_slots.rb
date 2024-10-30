# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::MetadataInstance
    # @see Templates::SlotMappings::MetadataDefinitionSlots
    class MetadataInstanceSlots < AbstractInstanceSlots
      inline! :header
    end
  end
end
