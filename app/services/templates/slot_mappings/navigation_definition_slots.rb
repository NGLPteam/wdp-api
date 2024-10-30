# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::NavigationDefinition
    # @see Templates::Config::TemplateSlots::NavigationSlots
    # @see Templates::SlotMappings::NavigationInstanceSlots
    class NavigationDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::NavigationInstanceSlots

      inline! :entity_label, default: proc { TemplateSlot.default_template_hash_for("navigation#entity_label") }
    end
  end
end
