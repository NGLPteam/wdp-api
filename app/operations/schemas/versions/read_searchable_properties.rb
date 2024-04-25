# frozen_string_literal: true

module Schemas
  module Versions
    class ReadSearchableProperties
      include Dry::Monads[:do, :result]
      include MeruAPI::Deps[
        read_properties: "schemas.versions.read_properties"
      ]

      # @param [HasSchemaDefinition] schema_instance
      # @param [Schemas::Properties::Context, nil] context
      # @return [Dry::Monads::Success<Schemas::Properties::Reader>]
      def call(schema_instance, context: nil)
        properties = yield read_properties.call(schema_instance, context:)

        props = properties.each_with_object([]) do |property, readers|
          extract_value_into! readers, property
        end

        Success props
      end

      private

      # @param [<Schemas::Properties::Reader>] readers
      # @param [Schemas::Properties::GroupReader, Schemas::Properties::Reader] reader
      # @return [void]
      def extract_value_into!(readers, property)
        if property.group?
          property.properties.each do |subproperty|
            extract_value_into! readers, subproperty
          end
        elsif property.searchable?
          readers << property
        end
      end
    end
  end
end
