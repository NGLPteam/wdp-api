# frozen_string_literal: true

module Types
  class CollectionType < Types::AbstractModel
    implements Types::EntityType
    implements Types::HierarchicalEntryType
    implements Types::ContributableType
    implements Types::HasSchemaPropertiesType

    use_direct_connection_and_edge!

    description "A collection of items"

    field :community, Types::CommunityType, null: false

    field :parent, "Types::CollectionParentType", null: true
    field :children, connection_type, null: false, deprecation_reason: "Use Collection.collections"

    field :collections, resolver: Resolvers::SubcollectionResolver, connection: true
    field :contributions, resolver: Resolvers::CollectionContributionResolver, connection: true
    field :items, resolver: Resolvers::ItemResolver, connection: true
    field :links, resolver: Resolvers::CollectionLinkResolver, connection: true
    field :item_links, resolver: Resolvers::CollectionLinkedItemResolver, connection: true

    # @return [Community, Collection]
    def parent
      object.root? ? object.community : object.parent
    end
  end
end
