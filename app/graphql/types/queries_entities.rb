# frozen_string_literal: true

module Types
  module QueriesEntities
    include Types::BaseInterface

    description <<~TEXT
    Fields for querying all entities from the top level of the hierarchy.
    TEXT

    field :asset, Types::AnyAssetType, null: true do
      description "Look up an asset by slug"

      argument :slug, Types::SlugType, required: true
    end

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

    field :community_by_title, Types::CommunityType, null: true do
      description "Look up a community by its title"

      argument :title, String, required: true
    end

    field :item, Types::ItemType, null: true do
      description "Look up an item by slug"

      argument :slug, Types::SlugType, required: true
    end

    def asset(slug:)
      Support::Loaders::RecordLoader.for(Asset).load(slug)
    end

    def collection(slug:)
      Support::Loaders::RecordLoader.for(Collection).load(slug).tap do |collection|
        track_entity_event! collection
      end
    end

    def community(slug:)
      Support::Loaders::RecordLoader.for(Community).load(slug).tap do |community|
        track_entity_event! community
      end
    end

    # @param [String] title
    # @return [Community, nil]
    def community_by_title(title:)
      Community.by_title(title).first.tap do |community|
        track_entity_event! community
      end
    end

    def item(slug:)
      Support::Loaders::RecordLoader.for(Item).load(slug).tap do |item|
        track_entity_event! item
      end
    end
  end
end
