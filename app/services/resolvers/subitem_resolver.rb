# frozen_string_literal: true

module Resolvers
  class SubitemResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination
    include Resolvers::SimplyOrdered

    type "Types::ItemConnectionType", null: false

    scope do
      if object.kind_of?(Item)
        object.children
      elsif object.present? && object.respond_to?(:items)
        object.items
      else
        # :nocov:
        Item.none
        # :nocov:
      end
    end
  end
end
