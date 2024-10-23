# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::ListItemDefinition
    class ListItemDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::ListItemInstanceSlots

      inline! :header
      inline! :subheader
      block! :description
      inline! :meta_a
      inline! :meta_b
      inline! :context_a
      inline! :context_b
      inline! :context_c
    end
  end
end
