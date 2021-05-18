# frozen_string_literal: true

module Types
  class ItemLinkType < Types::AbstractModel
    field :source, "Types::ItemType", null: false
    field :target, "Types::ItemType", null: false
    field :operator, Types::ItemLinkOperatorType, null: false
  end
end
