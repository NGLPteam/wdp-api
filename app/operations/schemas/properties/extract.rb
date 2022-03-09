# frozen_string_literal: true

module Schemas
  module Properties
    # A polymorphic operation to get at the list of properties for a schema version, schema instance, etc.
    #
    # @see ExposesSchemaProperties
    class Extract
      # @param [ExposesSchemaProperties] source
      # @raise [TypeError] when an invalid model is provided
      # @return [<Schemas::Properties::BaseDefinition>]
      def call(source)
        case source
        when ::Schemas::Types::SchemaInstance
          call source.schema_version
        when ::SchemaVersion
          source.configuration.properties
        else
          raise TypeError, "Cannot extract schema properties from #{source.class.name}"
        end
      end
    end
  end
end
