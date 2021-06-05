# frozen_string_literal: true

module Mutations
  class ReparentCollection < Mutations::BaseMutation
    field :collection, Types::CollectionType, null: true

    argument :collection_id, ID, loads: Types::CollectionType, description: "The collection in need of a new parent", required: true
    argument :parent_id, ID, loads: Types::CollectionParentType, description: "The parent of the collection", required: true

    performs_operation! "mutations.operations.reparent_collection"
  end
end
