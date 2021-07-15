# frozen_string_literal: true

module Resolvers
  class CollectionResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination
    include Resolvers::SimplyOrdered
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
