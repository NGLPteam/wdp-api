# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::MetadataDefinition
    # @see Templates::Config::TemplateSlots::MetadataSlots
    # @see Templates::SlotMappings::MetadataInstanceSlots
    class MetadataDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::MetadataInstanceSlots

      inline! :header
      block! :items_a
      block! :items_b
      block! :items_c
      block! :items_d
    end
  end
end
