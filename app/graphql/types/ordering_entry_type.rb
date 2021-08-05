# frozen_string_literal: true

module Types
  class OrderingEntryType < Types::AbstractModel
    description "An entry within an ordering, it can refer to an entity or an entity link"

    field :ordering, "Types::OrderingType", null: false, description: "The parent ordering"

    field :entry, "Types::AnyOrderingEntryType", null: false, method: :entity
  end
end
