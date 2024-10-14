# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::PageListDefinition
    class PageListDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::PageListInstanceSlots

      block! :sample_block

      inline! :sample_inline
    end
  end
end
