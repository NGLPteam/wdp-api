# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::SupplementaryDefinition
    class SupplementaryDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::SupplementaryInstanceSlots

      inline! :contributors_label
      inline! :metrics_label
    end
  end
end
