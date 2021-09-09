# frozen_string_literal: true

module Mutations
  class DestroyCollection < Mutations::BaseMutation
    description <<~TEXT.strip_heredoc
    Destroy a collection by ID.
    TEXT

    argument :collection_id, ID, loads: Types::CollectionType, description: "The ID for the collection to destroy", required: true

    performs_operation! "mutations.operations.destroy_collection", destroy: true
  end
end
