# frozen_string_literal: true

module Types
  module Schematic
    class EmailPropertyType < Types::AbstractObjectType
      implements ScalarPropertyType

      field :default_address, String, null: true, method: :default
      field :address, String, null: true, method: :value
    end
  end
end
