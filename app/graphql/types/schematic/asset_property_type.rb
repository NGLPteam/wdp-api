# frozen_string_literal: true

module Types
  module Schematic
    class AssetPropertyType < Types::AbstractObjectType
      implements ScalarPropertyType

      field :asset, Types::AnyAssetType, null: true, method: :value
    end
  end
end
