# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::SupplementaryInstance
    class SupplementaryInstanceSlots < AbstractInstanceSlots
      inline! :contributors_label
      inline! :metrics_label
    end
  end
end
