# frozen_string_literal: true

module Schemas
  module Versions
    # Build an array of readers for schema properties on a {SchemaVersion}.
    # They will have no instance, but can be used to iterate properties in
    # the GraphQL API at the schema level.
    #
    # @see Schemas::Properties::ToReaders
    class ReadProperties
      include WDPAPI::Deps[to_readers: "schemas.properties.to_readers"]

      # @param [SchemaVersion] schema_version
      # @return [Dry::Monads::Success<Schemas::Properties::Reader, Schemas::Properties::GroupReader>]
      # @return [Dry::Monads::Failure]
      def call(schema_version, context: nil)
        to_readers.(schema_version, context: context)
      end
    end
  end
end
