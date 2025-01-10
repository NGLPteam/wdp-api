# frozen_string_literal: true

module Templates
  module SlotMappings
    # @abstract
    class AbstractInstanceSlots < AbstractSlots
      block_slot_klass ::Templates::Slots::Instances::Block
      inline_slot_klass ::Templates::Slots::Instances::Inline

      def hides_template?
        any? do |_, slot|
          slot&.hides_template?
        end
      end
    end
  end
end
