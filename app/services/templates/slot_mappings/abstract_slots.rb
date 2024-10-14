# frozen_string_literal: true

module Templates
  module SlotMappings
    # @abstract
    class AbstractSlots
      extend Dry::Core::ClassAttributes

      include Support::EnhancedStoreModel

      SlotKlass = ::Templates::Types.Interface(:to_type)
      SlotList = ::Templates::Types::Array.of(Templates::Types::Coercible::Symbol)

      defines :inline_slots, :block_slots, type: SlotList
      defines :inline_slot_klass, :block_slot_klass, type: SlotKlass.optional

      block_slots [].freeze
      inline_slots [].freeze

      class << self
        def block!(name)
          block_slots [*block_slots, name].freeze

          attribute name, block_slot_klass.to_type
        end

        def inline!(name)
          inline_slots [*inline_slots, name].freeze

          attribute name, inline_slot_klass.to_type
        end
      end
    end
  end
end
