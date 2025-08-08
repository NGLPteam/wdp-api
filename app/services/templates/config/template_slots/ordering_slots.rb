# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::OrderingDefinition
      # @see Templates::Config::Template::Ordering
      # @see Templates::SlotMappings::OrderingDefinitionSlots
      class OrderingSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :ordering

        attribute :next_label, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("ordering#next_label") }

        attribute :previous_label, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("ordering#previous_label") }

        xml do
          root "slots"

          map_element "next-label", to: :next_label, render_nil: true

          map_element "previous-label", to: :previous_label, render_nil: true
        end
      end
    end
  end
end
