# frozen_string_literal: true

module Mutations
  class ReparentItem < Mutations::BaseMutation
    field :item, Types::ItemType, null: true

    argument :item_id, ID, loads: Types::ItemType, description: "The item in need of a new parent", required: true
    argument :parent_id, ID, loads: Types::ItemParentType, description: "The parent of the item", required: true

    performs_operation! "mutations.operations.reparent_item"
  end
end
