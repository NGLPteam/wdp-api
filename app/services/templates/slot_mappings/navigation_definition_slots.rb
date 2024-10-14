# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::NavigationDefinition
    class NavigationDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::NavigationInstanceSlots

      block! :sample_block

      inline! :sample_inline
    end
  end
end
