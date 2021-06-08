# frozen_string_literal: true

module Types
  class ItemType < Types::AbstractModel
    implements Types::EntityType
    implements Types::HierarchicalEntryType
    implements Types::ContributableType

    description "An item that belongs to a collection"

    field :collection, Types::CollectionType, null: false
    field :community, Types::CommunityType, null: false
    field :contributions, Types::ItemContributionType.connection_type, null: false
    field :parent, "Types::ItemParentType", null: true
    field :children, connection_type, null: false
    field :links, Types::ItemLinkType.connection_type, null: false, method: :item_links

    # @return [Collection, Item]
    def parent
      object.root? ? object.collection : object.parent
    end
  end
end
