# frozen_string_literal: true

module Mutations
  class UpdateCollection < Mutations::BaseMutation
    description "Update a collection"

    field :collection, Types::CollectionType, null: true, description: "A new representation of the collection, on a successful update"

    argument :collection_id, ID, loads: Types::CollectionType, required: true
    argument :title, String, required: true, description: "Human readable title for the collection"

    performs_operation! "mutations.operations.update_collection"
  end
end
