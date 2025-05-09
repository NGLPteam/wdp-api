# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::ListItemDefinition
    # @see Templates::Config::TemplateSlots::ListItemSlots
    # @see Templates::SlotMappings::ListItemInstanceSlots
    class ListItemDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::ListItemInstanceSlots

      inline! :header, default: proc { TemplateSlot.default_template_hash_for("list_item#header") }
      inline! :subheader, default: proc { TemplateSlot.default_template_hash_for("list_item#subheader") }
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
