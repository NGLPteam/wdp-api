# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::BlurbDefinition
    # @see Templates::Config::TemplateSlots::BlurbSlots
    # @see Templates::SlotMappings::BlurbInstanceSlots
    class BlurbDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::BlurbInstanceSlots

      inline! :header
      inline! :subheader
      block! :body
    end
  end
end
