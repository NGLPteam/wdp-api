# frozen_string_literal: true

module Types
  module Schematic
    class StringPropertyType < Types::AbstractObjectType
      implements ScalarPropertyType

      field :default, String, null: true
      field :content, String, null: true, method: :value
    end
  end
end
