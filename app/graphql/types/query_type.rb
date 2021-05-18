# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    add_field GraphQL::Types::Relay::NodeField

    add_field GraphQL::Types::Relay::NodesField

    field :collections, resolver: Resolvers::CollectionResolver

    field :collection, Types::CollectionType, null: true do
      description "Look up a collection by slug"

      argument :slug, Types::SlugType, required: true
    end

    field :communities, resolver: Resolvers::CommunityResolver

    field :community, Types::CommunityType, null: true do
      description "Look up a community by slug"

      argument :slug, Types::SlugType, required: true
    end

    field :item, Types::ItemType, null: true do
      description "Look up an item by slug"

      argument :slug, Types::SlugType, required: true
    end

    field :contributor, Types::AnyContributorType, null: true do
      description "Look up a contributor by slug"

      argument :slug, Types::SlugType, required: true
    end

    field :viewer, Types::UserType, null: true,
      description: "The currently authenticated user. AKA: you"

    def collection(slug:)
      Collection.find slug
    end

    def contributor(slug:)
      Contributor.find slug
    end

    def community(slug:)
      Community.find slug
    end

    def item(slug:)
      Item.find slug
    end

    def viewer
      context[:current_user] unless context[:current_user].anonymous?
    end
  end
end
