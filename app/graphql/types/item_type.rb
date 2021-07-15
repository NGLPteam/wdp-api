# frozen_string_literal: true

module Types
  class ItemType < Types::AbstractModel
    implements Types::EntityType
    implements Types::HierarchicalEntryType
    implements Types::ContributableType

    use_direct_connection_and_edge!

    description "An item that belongs to a collection"

    field :collection, Types::CollectionType, null: false
    field :community, Types::CommunityType, null: false
    field :parent, "Types::ItemParentType", null: true
    field :children, connection_type, null: false, deprecation_reason: "Use Item.items"

    field :contributions, resolver: Resolvers::ItemContributionResolver, connection: true
    field :items, resolver: Resolvers::SubitemResolver, connection: true
    field :links, resolver: Resolvers::ItemLinkResolver, connection: true

    # @return [Collection, Item]
    def parent
      object.root? ? object.collection : object.parent
    end
  end
end
