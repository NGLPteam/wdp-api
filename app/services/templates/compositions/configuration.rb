# frozen_string_literal: true

module Templates
  module Compositions
    class Configuration < Shale::Mapper
      include Mappers::BetterXMLPrinting

      attribute :template_kind, Templates::Compositions::TemplateKind

      attribute :props, Templates::Compositions::TemplateProperty, collection: true
      attribute :slots, Templates::Compositions::Slot, collection: true
      attribute :description, Mappers::StrippedString
      attribute :layout_kind, Templates::Compositions::LayoutKind
      attribute :has_background, Shale::Type::Boolean, default: -> { false }
      attribute :has_variant, Shale::Type::Boolean, default: -> { false }

      xml do
        root "config"

        map_attribute "layout", to: :layout_kind
        map_attribute "has-background", to: :has_background
        map_attribute "has-variant", to: :has_variant
        map_element "description", to: :description
        map_element "prop", to: :props
        map_element "slot", to: :slots
      end
    end
  end
end
