# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::PageListDefinition
    class PageListDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::PageListInstanceSlots

      inline! :header
    end
  end
end
