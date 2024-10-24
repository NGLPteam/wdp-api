# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::LinkListDefinition
    class LinkListDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::LinkListInstanceSlots

      inline! :header
      inline! :header_aside
      inline! :metadata
      inline! :subtitle
    end
  end
end
