# frozen_string_literal: true

module Types
  # @abstract
  # @see ::Templates::SlotMappings::AbstractDefinitionSlots
  class AbstractDefinitionSlotMapping < Types::BaseObject
    class << self
      # @param [Class(::Templates::SlotMappings::AbstractDefinitionSlots)] klass
      # @return [void]
      def derive_fields_from!(klass)
        klass.block_slots.each do |name|
          field name, ::Types::TemplateSlotBlockDefinitionType, null: true
        end

        klass.inline_slots.each do |name|
          field name, ::Types::TemplateSlotInlineDefinitionType, null: true
        end
      end
    end
  end
end
