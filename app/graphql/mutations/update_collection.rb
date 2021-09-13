# frozen_string_literal: true

module Mutations
  class UpdateCollection < Mutations::BaseMutation
    description "Update a collection"

    field :collection, Types::CollectionType, null: true, description: "A new representation of the collection, on a successful update"

    argument :collection_id, ID, loads: Types::CollectionType, required: true

    include Mutations::Shared::UpdateHierarchicalEntityArguments

    performs_operation! "mutations.operations.update_collection"
  end
end
