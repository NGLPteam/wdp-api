# frozen_string_literal: true

module Schemas
  module Properties
    # Build an array of {Schemas::Properties::Reader readers} and {Schemas::Properties::GroupReader group readers}
    # for all properties on {HasSchemaDefinition an instance} or {SchemaVersion a version}.
    #
    # @see Schemas::Properties::ToContext
    # @see Schemas::Properties::ToReader
    class ToReaders
      include Dry::Monads[:do, :list, :result]
      include WDPAPI::Deps[
        extract: "schemas.properties.extract",
        to_context: "schemas.properties.to_context",
        to_reader: "schemas.properties.to_reader",
      ]

      # @param [ExposesSchemaProperties] source
      # @param [Schemas::Properties::Context, nil] context
      # @return [Dry::Monads::Success<Schemas::Properties::Reader, Schemas::Properties::GroupReader>]
      # @return [Dry::Monads::Failure(:invalid_schema_property_source, String)]
      def call(source, context: nil)
        options = {}

        options[:context] = yield to_context.(source, existing: context)

        readers = yield extract_and_convert source, options

        Success readers.to_a
      end

      private

      # @return [Dry::Monads::Success(Dry::Monads::List::Result<Schemas::Properties::Reader, Schemas::Properties::GroupReader>)]
      def extract_and_convert(source, options)
        properties = extract.(source)

        results = properties.map do |property|
          to_reader.call property, options
        end

        List::Result.coerce(results).traverse
      end
    end
  end
end
