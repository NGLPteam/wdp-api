# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::ListItemInstance
    # @see Templates::SlotMappings::ListItemDefinitionSlots
    class ListItemInstanceSlots < AbstractInstanceSlots
      inline! :context_a
      inline! :context_abbr
      inline! :context_b
      inline! :context_c
      inline! :context_full
      block! :description
      inline! :header
      inline! :meta_a
      inline! :meta_b
      inline! :nested_context
      inline! :nested_header
      inline! :nested_metadata
      inline! :nested_subheader
      inline! :subheader
    end
  end
end
