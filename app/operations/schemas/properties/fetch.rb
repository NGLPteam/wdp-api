# frozen_string_literal: true

module Schemas
  module Properties
    # A polymorphic operation to fetch a single property.
    #
    # @see ExposesSchemaProperties
    class Fetch
      # @param [ExposesSchemaProperties] source
      # @raise [TypeError] when an invalid source is provided
      # @return [Schemas::Properties::BaseDefinition, nil]
      def call(source, full_path)
        case source
        when ::Schemas::Types::SchemaInstance
          call source.schema_version, full_path
        when ::SchemaVersion
          source.configuration.property_for full_path
        else
          raise TypeError, "Cannot fetch schema properties from #{source.class.name}"
        end
      end
    end
  end
end
