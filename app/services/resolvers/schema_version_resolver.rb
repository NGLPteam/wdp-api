# frozen_string_literal: true

module Resolvers
  class SchemaVersionResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination

    type Types::SchemaVersionType.connection_type, null: false

    scope { object.present? ? object.schema_versions : SchemaVersion.all }

    option :namespace, type: String do |scope, value|
      scope.by_namespace(value) if value.present?
    end

    option :order, type: Types::SchemaVersionOrderType, default: "LATEST"

    def apply_order_with_latest(scope)
      scope.order(number: :desc)
    end

    def apply_order_with_oldest(scope)
      scope.order(number: :asc)
    end
  end
end
