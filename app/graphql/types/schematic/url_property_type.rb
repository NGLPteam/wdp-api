# frozen_string_literal: true

module Types
  module Schematic
    class URLPropertyType < Types::AbstractObjectType
      description "A schematic reference to a URL, with href, label, and optional title"

      implements ScalarPropertyType

      field :url, Types::URLReferenceType, null: true, method: :value
    end
  end
end
