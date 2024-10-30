# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::DetailDefinition
    # @see Templates::Config::TemplateSlots::DetailSlots
    # @see Templates::SlotMappings::DetailInstanceSlots
    class DetailDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::DetailInstanceSlots

      inline! :header, default: proc { TemplateSlot.default_template_hash_for("detail#header") }
      inline! :subheader, default: proc { TemplateSlot.default_template_hash_for("detail#subheader") }
      block! :summary, default: proc { TemplateSlot.default_template_hash_for("detail#summary") }
    end
  end
end
