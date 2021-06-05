# frozen_string_literal: true

module Mutations
  class UpdateCollection < Mutations::BaseMutation
    field :collection, Types::CollectionType, null: true

    argument :collection_id, ID, loads: Types::CollectionType, required: true
    argument :title, String, required: true
    argument :identifier, String, required: true

    performs_operation! "mutations.operations.update_collection"
  end
end
