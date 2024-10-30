# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::ListItemInstance
    # @see Templates::SlotMappings::ListItemDefinitionSlots
    class ListItemInstanceSlots < AbstractInstanceSlots
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
