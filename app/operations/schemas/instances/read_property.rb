# frozen_string_literal: true

module Schemas
  module Instances
    class ReadProperty
      include Dry::Monads[:do, :list, :result]
      include WDPAPI::Deps[to_context: "schemas.instances.read_property_context", to_reader: "schemas.properties.to_reader"]

      # @param [HasSchemaDefinition] schema_instance
      # @param [String] full_path
      # @param [Schemas::Properties::Context, nil] context
      # @return [Schemas::Properties::Reader, Schemas::Properties::GroupReader]
      def call(schema_instance, full_path, context: nil)
        options = {}

        options[:context] = context.kind_of?(Schemas::Properties::Context) ? context : yield(to_context.call(schema_instance))

        property = schema_instance.schema_version.configuration.property_for full_path

        return Failure[:unknown_property, "#{full_path} is not a known property"] if property.blank?

        to_reader.call property, options
      end
    end
  end
end
