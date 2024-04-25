# frozen_string_literal: true

module Schemas
  module Instances
    # Build an array of readers for schema properties on a {SchemaVersion}.
    # They will have no instance, but can be used to iterate properties in
    # the GraphQL API at the schema level.
    #
    # @see Schemas::Properties::ToReaders
    class ReadProperties
      include MeruAPI::Deps[to_readers: "schemas.properties.to_readers"]

      # @param [HasSchemaDefinition] schema_instance
      # @param [Schemas::Properties::Context, nil] context
      # @return [Dry::Monads::Success<Schemas::Properties::Reader, Schemas::Properties::GroupReader>]
      # @return [Dry::Monads::Failure]
      def call(schema_instance, context: nil)
        to_readers.(schema_instance, context:)
      end
    end
  end
end
