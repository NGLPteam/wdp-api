# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::MetadataInstance
    class MetadataInstanceSlots < AbstractInstanceSlots
      inline! :header
    end
  end
end
