# frozen_string_literal: true

module Schemas
  module Instances
    class ReadProperties
      include Dry::Monads[:do, :list, :result]
      include WDPAPI::Deps[to_context: "schemas.instances.read_property_context", to_reader: "schemas.properties.to_reader"]

      # @param [HasSchemaDefinition] schema_instance
      # @return [<Schemas::Properties::Reader, Schemas::Properties::GroupReader>]
      def call(schema_instance)
        options = {}

        options[:context] = yield to_context.call schema_instance

        results = schema_instance.schema_version.configuration.properties.map do |property|
          to_reader.call property, options
        end

        result = yield List::Result.coerce(results).traverse

        Success result.to_a
      end
    end
  end
end
