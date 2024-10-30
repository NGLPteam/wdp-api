# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::DetailDefinition
      # @see Templates::Config::Template::Detail
      # @see Templates::SlotMappings::DetailDefinitionSlots
      class DetailSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :detail

        attribute :header, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("detail#header") }

        attribute :subheader, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("detail#subheader") }

        attribute :summary, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("detail#summary") }

        xml do
          root "slots"

          map_element "header", to: :header, cdata: true, render_nil: true

          map_element "subheader", to: :subheader, cdata: true, render_nil: true

          map_element "summary", to: :summary, cdata: true, render_nil: true
        end
      end
    end
  end
end
