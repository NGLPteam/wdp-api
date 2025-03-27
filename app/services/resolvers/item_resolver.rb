# frozen_string_literal: true

module Resolvers
  class ItemResolver < AbstractResolver
    include Resolvers::Enhancements::AppliesPolicyScope
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::FiltersByEntityPermission
    include Resolvers::OrderedAsEntity
    include Resolvers::Treelike

    type Types::ItemConnectionType, null: false

    scope do
      if object.kind_of?(Item)
        item.children
      elsif object.present? && object.respond_to?(:items)
        object.items
      else
        # We should not be fetching all items at once, but maybe we will in the future (for search?)
        Item.none
      end
    end
  end
end
