# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::PageListDefinition
    # @see Templates::Config::TemplateSlots::PageListSlots
    # @see Templates::SlotMappings::PageListInstanceSlots
    class PageListDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::PageListInstanceSlots

      inline! :header, default: proc { TemplateSlot.default_template_hash_for("page_list#header") }
    end
  end
end
