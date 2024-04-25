# frozen_string_literal: true

module Schemas
  module Instances
    class ReadOrderablePropertyValues
      include Dry::Monads[:do, :result]
      include MeruAPI::Deps[
        read_properties: "schemas.instances.read_properties"
      ]

      # @param [HasSchemaDefinition] schema_instance
      # @param [Schemas::Properties::Context, nil] context
      # @return [Dry::Monads::Success(Hash)]
      def call(schema_instance, context: nil)
        properties = yield read_properties.call(schema_instance, context:)

        values = properties.each_with_object({}) do |property, v|
          extract_value_into! v, property
        end

        Success values
      end

      private

      # @param [{ String => Object }] values
      # @param [Schemas::Properties::GroupReader, Schemas::Properties::Reader] reader
      # @return [void]
      def extract_value_into!(values, property)
        if property.group?
          property.properties.each do |subproperty|
            extract_value_into! values, subproperty
          end
        elsif property.orderable?
          values[property.full_path] = property.value
        end
      end
    end
  end
end
