# frozen_string_literal: true

module Resolvers
  class EntityLinkResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination
    include Resolvers::SimplyOrdered

    type Types::EntityLinkType.connection_type, null: false

    scope { object.entity_links }
  end
end
