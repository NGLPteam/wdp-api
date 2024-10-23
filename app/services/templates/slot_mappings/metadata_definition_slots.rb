# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::MetadataDefinition
    class MetadataDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::MetadataInstanceSlots

      inline! :header
    end
  end
end
