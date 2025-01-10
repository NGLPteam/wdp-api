# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::LinkListDefinition
    # @see Templates::Config::TemplateSlots::LinkListSlots
    # @see Templates::SlotMappings::LinkListInstanceSlots
    class LinkListDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::LinkListInstanceSlots

      inline! :block_header
      inline! :block_header_fallback
      inline! :header, default: proc { TemplateSlot.default_template_hash_for("link_list#header") }
      inline! :header_fallback, default: proc { TemplateSlot.default_template_hash_for("link_list#header_fallback") }
      inline! :header_aside
      inline! :list_context
      inline! :metadata, default: proc { TemplateSlot.default_template_hash_for("link_list#metadata") }
      inline! :subtitle
    end
  end
end
