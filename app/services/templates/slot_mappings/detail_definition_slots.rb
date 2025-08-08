# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::DetailDefinition
    # @see Templates::Config::TemplateSlots::DetailSlots
    # @see Templates::SlotMappings::DetailInstanceSlots
    class DetailDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::DetailInstanceSlots

      block! :body
      inline! :header, default: proc { TemplateSlot.default_template_hash_for("detail#header") }
      block! :items_a
      block! :items_b
      block! :items_c
      block! :items_d
      inline! :subheader, default: proc { TemplateSlot.default_template_hash_for("detail#subheader") }
      block! :summary, default: proc { TemplateSlot.default_template_hash_for("detail#summary") }
    end
  end
end
