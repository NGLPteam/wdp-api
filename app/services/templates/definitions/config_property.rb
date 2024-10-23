# frozen_string_literal: true

module Templates
  module Definitions
    class ConfigProperty < Shale::Mapper
      attribute :name, Templates::Definitions::StrippedString
      attribute :description, Templates::Definitions::Description
      attribute :default, Templates::Definitions::EncodedDefault
      attribute :kind, Templates::Definitions::ConfigPropertyKind, default: -> { "string" }
      attribute :enum, Shale::Type::String

      xml do
        root "prop"

        map_attribute "name", to: :name
        map_attribute "kind", to: :kind
        map_attribute "enum", to: :enum
        map_element "description", to: :description
        map_element "default", to: :default, cdata: true
      end
    end
  end
end
