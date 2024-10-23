# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::NavigationDefinition
    class NavigationDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::NavigationInstanceSlots

      inline! :entity_label
    end
  end
end
