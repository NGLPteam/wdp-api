# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::SupplementaryInstance
    # @see Templates::SlotMappings::SupplementaryDefinitionSlots
    class SupplementaryInstanceSlots < AbstractInstanceSlots
      inline! :contributors_label
      inline! :metrics_label
    end
  end
end
