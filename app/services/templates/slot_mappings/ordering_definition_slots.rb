# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::OrderingDefinition
    # @see Templates::Config::TemplateSlots::OrderingSlots
    # @see Templates::SlotMappings::OrderingInstanceSlots
    class OrderingDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::OrderingInstanceSlots

      inline! :previous_label, default: proc { TemplateSlot.default_template_hash_for("ordering#previous_label") }
      inline! :next_label, default: proc { TemplateSlot.default_template_hash_for("ordering#next_label") }
    end
  end
end
