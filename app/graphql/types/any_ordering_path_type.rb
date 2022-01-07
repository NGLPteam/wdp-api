# frozen_string_literal: true

module Types
  # @see Types::SchemaPropertyOrderingPathType
  # @see Types::StaticOrderingPathType
  class AnyOrderingPathType < Types::BaseUnion
    possible_types Types::SchemaOrderingPathType, Types::StaticOrderingPathType

    description <<~TEXT
    All types in this union implement OrderingPath.
    TEXT

    class << self
      def resolve_type(object, context)
        case object
        when ::Schemas::Orderings::PathOptions::StaticReader
          Types::StaticOrderingPathType
        when ::Schemas::Orderings::PathOptions::SchemaReader
          Types::SchemaOrderingPathType
        else
          # :nocov:
          raise GraphQL::ExecutionError, "Unknown ordering path: #{object.inspect}"
          # :nocov:
        end
      end
    end
  end
end
