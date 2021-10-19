# frozen_string_literal: true

module Resolvers
  class PageResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination

    type Types::PageType.connection_type, null: false

    scope { object.present? ? object.pages : Page.none }
  end
end
