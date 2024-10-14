# frozen_string_literal: true

module Templates
  module SlotMappings
    # @abstract
    class AbstractDefinitionSlots < AbstractSlots
      block_slot_klass ::Templates::Slots::Definitions::Block
      inline_slot_klass ::Templates::Slots::Definitions::Inline

      defines :instance_slots_klass, type: Templates::Types.Inherits(::Templates::SlotMappings::AbstractInstanceSlots).optional

      # @return [Class(Templates::SlotMappings::AbstractInstanceSlots)]
      def instance_slots_klass
        self.class.instance_slots_klass
      end
    end
  end
end
