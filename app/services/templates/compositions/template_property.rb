# frozen_string_literal: true

module Templates
  module Compositions
    # @see ::TemplateProperty
    class TemplateProperty < Shale::Mapper
      attribute :name, ::Mappers::StrippedString
      attribute :kind, Templates::Compositions::TemplatePropertyKind, default: -> { "string" }
      attribute :description, ::Mappers::StrippedString
      attribute :default, Templates::Compositions::EncodedDefault

      xml do
        root "prop"

        map_attribute "name", to: :name
        map_attribute "kind", to: :kind
        map_element "description", to: :description
        map_element "default", to: :default, cdata: true
      end
    end
  end
end
