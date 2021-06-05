# frozen_string_literal: true

module Mutations
  class UpdateItem < Mutations::BaseMutation
    field :item, Types::ItemType, null: true

    argument :item_id, ID, loads: Types::ItemType, description: "The item to update", required: true
    argument :title, String, required: true
    argument :identifier, String, required: true

    performs_operation! "mutations.operations.update_item"
  end
end
