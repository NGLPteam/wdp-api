# frozen_string_literal: true

module Templates
  module Definitions
    class ConfigProperty < Shale::Mapper
      attribute :name, ::Mappers::StrippedString
      attribute :description, ::Mappers::StrippedString
      attribute :default, Templates::Definitions::EncodedDefault
      attribute :kind, Templates::Definitions::ConfigPropertyKind, default: -> { "string" }
      attribute :enum_name, Shale::Type::String

      xml do
        root "prop"

        map_attribute "name", to: :name
        map_attribute "kind", to: :kind
        map_attribute "enum", to: :enum_name
        map_element "description", to: :description
        map_element "default", to: :default, cdata: true
      end

      def to_record
        {
          name:,
          property_kind_name: kind,
          enum_name:,
          default:,
          description:,
        }.compact.stringify_keys
      end
    end
  end
end
