# frozen_string_literal: true

module Resolvers
  class SchemaDefinitionResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination
    include Resolvers::SimplyOrdered

    type Types::SchemaDefinitionType.connection_type, null: false

    scope { SchemaDefinition.all }

    option :namespace, type: String do |scope, value|
      scope.by_namespace(value) if value.present?
    end
  end
end
