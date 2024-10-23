# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::DescendantListDefinition
    class DescendantListDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::DescendantListInstanceSlots

      inline! :header
      inline! :header_aside
      inline! :metadata
      inline! :subtitle
    end
  end
end
