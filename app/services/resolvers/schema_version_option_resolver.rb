# frozen_string_literal: true

module Resolvers
  class SchemaVersionOptionResolver < AbstractResolver
    include Resolvers::BySchemaKind

    type [Types::SchemaVersionOptionType, { null: false }], null: false

    scope { SchemaVersion.in_default_order.preload(:schema_definition) }

    option :namespace, type: String do |scope, value|
      scope.by_namespace(value) if value.present?
    end

    def apply_order_with_latest(scope)
      scope.order(number: :desc)
    end

    def apply_order_with_oldest(scope)
      scope.order(number: :asc)
    end
  end
end
