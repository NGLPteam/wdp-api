# frozen_string_literal: true

module Types
  # @abstract
  # @see ::Templates::SlotMappings::AbstractInstanceSlots
  class AbstractInstanceSlotMapping < Types::BaseObject
    class << self
      # @param [Class(::Templates::SlotMappings::AbstractInstanceSlots)] klass
      # @return [void]
      def derive_fields_from!(klass)
        klass.block_slots.each do |name|
          field name, ::Types::TemplateSlotBlockInstanceType, null: true
        end

        klass.inline_slots.each do |name|
          field name, ::Types::TemplateSlotInlineInstanceType, null: true
        end
      end
    end
  end
end
