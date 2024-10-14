# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::LinkListDefinition
    class LinkListDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::LinkListInstanceSlots

      block! :sample_block

      inline! :sample_inline
    end
  end
end
