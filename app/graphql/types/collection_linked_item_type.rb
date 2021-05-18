# frozen_string_literal: true

module Types
  class CollectionLinkedItemType < Types::AbstractModel
    field :source, "Types::CollectionType", null: false
    field :target, "Types::ItemType", null: false
    field :operator, Types::CollectionLinkedItemOperatorType, null: false
  end
end
