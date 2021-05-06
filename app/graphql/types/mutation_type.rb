# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_collection, mutation: Mutations::CreateCollection
  end
end
