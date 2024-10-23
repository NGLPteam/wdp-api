# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::ContributorListInstance
    class ContributorListInstanceSlots < AbstractInstanceSlots
      inline! :header
    end
  end
end
