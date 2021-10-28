# frozen_string_literal: true

module Types
  module Schematic
    class FullTextPropertyType < Types::AbstractObjectType
      implements ScalarPropertyType

      field :full_text, Types::FullTextType, null: true, method: :value
    end
  end
end
