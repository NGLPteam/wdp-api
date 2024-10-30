# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::OrderingDefinition
      # @see Templates::Config::Template::Ordering
      # @see Templates::SlotMappings::OrderingDefinitionSlots
      class OrderingSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :ordering

        attribute :previous_label, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("ordering#previous_label") }

        attribute :next_label, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("ordering#next_label") }

        xml do
          root "slots"

          map_element "previous-label", to: :previous_label, cdata: true, render_nil: true

          map_element "next-label", to: :next_label, cdata: true, render_nil: true
        end
      end
    end
  end
end
