# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::NavigationInstance
    # @see Templates::SlotMappings::NavigationDefinitionSlots
    class NavigationInstanceSlots < AbstractInstanceSlots
      inline! :entity_label
    end
  end
end
