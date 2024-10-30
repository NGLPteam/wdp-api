# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::DescendantListDefinition
    # @see Templates::Config::TemplateSlots::DescendantListSlots
    # @see Templates::SlotMappings::DescendantListInstanceSlots
    class DescendantListDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::DescendantListInstanceSlots

      inline! :header, default: proc { TemplateSlot.default_template_hash_for("descendant_list#header") }
      inline! :header_aside
      inline! :metadata, default: proc { TemplateSlot.default_template_hash_for("descendant_list#metadata") }
      inline! :subtitle
    end
  end
end
