# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    add_field GraphQL::Types::Relay::NodeField

    add_field GraphQL::Types::Relay::NodesField

    field :collections, resolver: Resolvers::CollectionResolver

    field :collection, Types::CollectionType, null: true do
      argument :id, ID, required: true
    end

    field :item, Types::ItemType, null: true do
      argument :id, ID, required: true
    end

    field :viewer, Types::UserType, null: true,
      description: "The currently authenticated user. AKA: you"

    def collection(id:)
      WDPAPISchema.object_from_id(id, context)
    end

    def item(id:)
      WDPAPISchema.object_from_id(id, context)
    end

    def viewer
      context[:current_user] unless context[:current_user].anonymous?
    end
  end
end
