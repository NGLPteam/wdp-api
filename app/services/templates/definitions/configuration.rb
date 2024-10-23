# frozen_string_literal: true

module Templates
  module Definitions
    class Configuration < Shale::Mapper
      include Mappers::BetterXMLPrinting

      attribute :template_kind, Templates::Definitions::TemplateKind

      attribute :props, Templates::Definitions::ConfigProperty, collection: true
      attribute :description, Mappers::StrippedString
      attribute :layout_kind, Templates::Definitions::LayoutKind
      attribute :has_background, Shale::Type::Boolean, default: -> { false }
      attribute :has_variant, Shale::Type::Boolean, default: -> { false }

      xml do
        root "config"

        map_attribute "layout", to: :layout_kind
        map_attribute "has-background", to: :has_background
        map_attribute "has-variant", to: :has_variant
        map_element "description", to: :description
        map_element "prop", to: :props
      end
    end
  end
end
