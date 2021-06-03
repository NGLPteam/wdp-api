# frozen_string_literal: true

module Mutations
  class CreateItem < Mutations::BaseMutation
    field :item, Types::ItemType, null: true

    argument :parent_id, ID, loads: Types::ItemParentType, description: "The parent of the item", required: true
    argument :title, String, required: true
    argument :identifier, String, required: true

    performs_operation! "mutations.operations.create_item"
  end
end
