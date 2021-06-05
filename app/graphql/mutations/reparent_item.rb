# frozen_string_literal: true

module Mutations
  class ReparentItem < Mutations::BaseMutation
    description <<~TEXT.strip_heredoc
    Reassign the item to another point in the hierarchy.

    This will also update any descendant items, if need be.
    TEXT

    field :item, Types::ItemType, null: true

    argument :item_id, ID, loads: Types::ItemType, required: true do
      description <<~TEXT.strip_heredoc
      The collection in need of a new parent
      TEXT
    end

    argument :parent_id, ID, loads: Types::ItemParentType, required: true do
      description <<~TEXT.strip_heredoc
      The id for the item's new parent. This can be a collection or another item.
      TEXT
    end

    performs_operation! "mutations.operations.reparent_item"
  end
end
