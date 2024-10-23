# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::NavigationInstance
    class NavigationInstanceSlots < AbstractInstanceSlots
      inline! :entity_label
    end
  end
end
