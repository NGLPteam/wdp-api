# frozen_string_literal: true

module Schemas
  module Properties
    # A generic interface for building a {Schemas::Properties::Context}
    #
    # @see Schemas::Instances::ReadPropertyContext
    # @see Schemas::Versions::ReadPropertyContext
    class ToContext
      include Dry::Monads[:result]
      include MeruAPI::Deps[
        for_schema_instance: "schemas.instances.read_property_context",
        for_schema_version: "schemas.versions.read_property_context",
      ]

      # @param [ExposesSchemaProperties] source
      # @param [Schemas::Properties::Context, nil] existing
      # @return [Dry::Monads::Success(Schemas::Properties::Context)]
      # @return [Dry::Monads::Failure(:invalid_property_context, String)]
      def call(source, existing: nil)
        return Success(existing) if existing.kind_of?(Schemas::Properties::Context)

        case source
        when Schemas::Types::SchemaInstance
          Success for_schema_instance.(source)
        when ::SchemaVersion
          Success for_schema_version.(source)
        else
          Failure[:invalid_property_context, "Cannot build a property context for #{source.class.name}"]
        end
      end
    end
  end
end
