# frozen_string_literal: true

module Mutations
  class CreateCollection < Mutations::BaseMutation
    field :collection, Types::CollectionType, null: true

    argument :title, String, required: true
    argument :description, String, required: true

    performs_operation! "mutations.operations.create_collection"
  end
end
