# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::DetailDefinition
    class DetailDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::DetailInstanceSlots

      inline! :header
      inline! :subheader
      block! :summary
    end
  end
end
