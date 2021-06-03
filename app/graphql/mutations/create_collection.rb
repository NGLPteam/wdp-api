# frozen_string_literal: true

module Mutations
  class CreateCollection < Mutations::BaseMutation
    field :collection, Types::CollectionType, null: true

    argument :parent_id, ID, loads: Types::CollectionParentType, description: "The parent of the collection", required: true
    argument :title, String, required: true
    argument :identifier, String, required: true

    performs_operation! "mutations.operations.create_collection"
  end
end
