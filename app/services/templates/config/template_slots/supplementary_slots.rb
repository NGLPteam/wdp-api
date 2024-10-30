# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::SupplementaryDefinition
      # @see Templates::Config::Template::Supplementary
      # @see Templates::SlotMappings::SupplementaryDefinitionSlots
      class SupplementarySlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :supplementary

        attribute :contributors_label, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("supplementary#contributors_label") }

        attribute :metrics_label, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("supplementary#metrics_label") }

        xml do
          root "slots"

          map_element "contributors-label", to: :contributors_label, cdata: true, render_nil: true

          map_element "metrics-label", to: :metrics_label, cdata: true, render_nil: true
        end
      end
    end
  end
end
