# frozen_string_literal: true

module Types
  class CollectionLinkType < Types::AbstractModel
    field :source, "Types::CollectionType", null: false
    field :target, "Types::CollectionType", null: false
    field :operator, Types::CollectionLinkOperatorType, null: false
  end
end
