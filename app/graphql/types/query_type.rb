# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description <<~TEXT
    The entry point for retrieving data from within the WDP API.
    TEXT

    add_field GraphQL::Types::Relay::NodeField

    add_field GraphQL::Types::Relay::NodesField

    field :collection, Types::CollectionType, null: true do
      description "Look up a collection by slug"

      argument :slug, Types::SlugType, required: true
    end

    field :communities, resolver: Resolvers::CommunityResolver do
      description "List all communities"
    end

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

    field :roles, resolver: Resolvers::RoleResolver do
      description "List all roles"
    end

    field :viewer, Types::UserType, null: true,
      description: "The currently authenticated user. AKA: you"

    def collection(slug:)
      Loaders::RecordLoader.for(Collection).load(slug)
    end

    def contributor(slug:)
      Loaders::RecordLoader.for(Contributor).load(slug)
    end

    def community(slug:)
      Loaders::RecordLoader.for(Community).load(slug)
    end

    def item(slug:)
      Loaders::RecordLoader.for(Item).load(slug)
    end

    def viewer
      context[:current_user] unless context[:current_user].anonymous?
    end
  end
end
