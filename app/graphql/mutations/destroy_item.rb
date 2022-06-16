# frozen_string_literal: true

module Mutations
  class DestroyItem < Mutations::BaseMutation
    description <<~TEXT
    Destroy an item by ID.
    TEXT

    argument :item_id, ID, loads: Types::ItemType, description: "The ID for the item to destroy", required: true

    performs_operation! "mutations.operations.destroy_item", destroy: true
  end
end
