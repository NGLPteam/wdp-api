# frozen_string_literal: true

module Types
  class CollectionType < Types::AbstractModel
    implements Types::EntityType
    implements Types::HierarchicalEntryType
    implements Types::ContributableType

    description "A collection of items"

    field :community, Types::CommunityType, null: false

    field :parent, "Types::CollectionParentType", null: true
    field :children, connection_type, null: false

    field :contributions, Types::CollectionContributionType.connection_type, null: false

    field :items, resolver: Resolvers::ItemResolver
    field :links, Types::CollectionLinkType.connection_type, null: false, method: :collection_links
    field :item_links, Types::CollectionLinkedItemType.connection_type, null: false, method: :collection_linked_items

    # @return [Community, Collection]
    def parent
      object.root? ? object.community : object.parent
    end
  end
end
