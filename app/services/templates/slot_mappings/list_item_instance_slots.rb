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
      inline! :context_abbr
      inline! :context_full
      inline! :context_a
      inline! :context_b
      inline! :context_c
      inline! :nested_header
      inline! :nested_subheader
      inline! :nested_context
      inline! :nested_metadata
    end
  end
end
