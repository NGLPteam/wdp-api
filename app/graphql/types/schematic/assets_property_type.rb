# frozen_string_literal: true

module Types
  module Schematic
    class AssetsPropertyType < Types::AbstractObjectType
      implements ScalarPropertyType

      field :assets, [Types::AnyAssetType, { null: false }], null: false, method: :value
    end
  end
end
