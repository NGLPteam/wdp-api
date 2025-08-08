# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::ListItemDefinition
    # @see Templates::Config::TemplateSlots::ListItemSlots
    # @see Templates::SlotMappings::ListItemInstanceSlots
    class ListItemDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::ListItemInstanceSlots

      inline! :context_a
      inline! :context_abbr
      inline! :context_b
      inline! :context_c
      inline! :context_full
      block! :description
      inline! :header, default: proc { TemplateSlot.default_template_hash_for("list_item#header") }
      inline! :meta_a
      inline! :meta_b
      inline! :nested_context
      inline! :nested_header
      inline! :nested_metadata
      inline! :nested_subheader
      inline! :subheader, default: proc { TemplateSlot.default_template_hash_for("list_item#subheader") }
    end
  end
end
