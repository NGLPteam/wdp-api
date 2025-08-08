# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::DescendantListDefinition
    # @see Templates::Config::TemplateSlots::DescendantListSlots
    # @see Templates::SlotMappings::DescendantListInstanceSlots
    class DescendantListDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::DescendantListInstanceSlots

      inline! :block_header
      inline! :block_header_fallback
      inline! :header, default: proc { TemplateSlot.default_template_hash_for("descendant_list#header") }
      inline! :header_aside
      inline! :header_fallback
      inline! :list_context
      inline! :metadata
      inline! :subtitle
    end
  end
end
