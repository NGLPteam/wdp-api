# frozen_string_literal: true

module Types
  # The GraphQL representation of an {OrderingEntry}.
  class OrderingEntryType < Types::AbstractModel
    description "An entry within an ordering, it can refer to an entity or an entity link"

    field :ordering, "Types::OrderingType", null: false, description: "The parent ordering"

    field :entry, "Types::AnyOrderingEntryType", null: false, method: :entity

    field :relative_depth, Integer, null: false do
      description <<~TEXT
      A calculation of the depth of an entry in the hierarchy, relative to the ordering's owning entity.
      TEXT
    end

    field :tree_depth, Integer, null: true do
      description <<~TEXT
      When an ordering's render mode is set to TREE, its entries will have this set.
      It is a normalized depth based on what other entities were accepted into the ordering.
      TEXT
    end
  end
end
