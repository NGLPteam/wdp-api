# frozen_string_literal: true

module Mutations
  class ReparentCollection < Mutations::BaseMutation
    description <<~TEXT.strip_heredoc
    Reassign the collection to another point in the hierarchy.

    This will update all child collections and descended items, if need be.
    TEXT

    field :collection, Types::CollectionType, null: true

    argument :collection_id, ID, loads: Types::CollectionType, required: true do
      description <<~TEXT.strip_heredoc
      The collection in need of a new parent
      TEXT
    end

    argument :parent_id, ID, loads: Types::CollectionParentType, required: true do
      description <<~TEXT.strip_heredoc
      The id for the collection's new parent. This can be a community or another collection.
      TEXT
    end

    performs_operation! "mutations.operations.reparent_collection"
  end
end
