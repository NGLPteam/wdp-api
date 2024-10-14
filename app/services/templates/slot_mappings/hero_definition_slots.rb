# frozen_string_literal: true

module Templates
  module SlotMappings
    # @see Templates::HeroDefinition
    class HeroDefinitionSlots < AbstractDefinitionSlots
      instance_slots_klass Templates::SlotMappings::HeroInstanceSlots

      block! :sample_block

      inline! :sample_inline
    end
  end
end
