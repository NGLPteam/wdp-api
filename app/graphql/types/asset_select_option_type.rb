# frozen_string_literal: true

module Types
  class AssetSelectOptionType < Types::BaseObject
    description "A select option for a single asset"

    field :label, String, null: false
    field :value, String, null: false
    field :kind, Types::AssetKindType, null: false
  end
end
