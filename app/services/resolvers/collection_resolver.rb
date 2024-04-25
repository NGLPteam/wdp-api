# frozen_string_literal: true

module Resolvers
  class CollectionResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsEntity
    include Resolvers::Treelike

    type Types::CollectionConnectionType, null: false

    scope do
      if object.present? && object.kind_of?(Collection)
        object.children
      elsif object.present? && object.respond_to?(:collections)
        object.collections
      else
        Collection.all
      end
    end
  end
end
