# frozen_string_literal: true

module Resolvers
  class CollectionResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::SimplyOrdered
    include Resolvers::Treelike

    type Types::CollectionType.connection_type, null: false

    scope { object.present? ? object.collections : Collection.all }
  end
end
