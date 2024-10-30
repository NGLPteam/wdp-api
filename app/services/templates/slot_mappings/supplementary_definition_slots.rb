# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::SupplementaryDefinition
    # @see Templates::Config::TemplateSlots::SupplementarySlots
    # @see Templates::SlotMappings::SupplementaryInstanceSlots
    class SupplementaryDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::SupplementaryInstanceSlots

      inline! :contributors_label, default: proc { TemplateSlot.default_template_hash_for("supplementary#contributors_label") }
      inline! :metrics_label, default: proc { TemplateSlot.default_template_hash_for("supplementary#metrics_label") }
    end
  end
end
