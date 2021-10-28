# frozen_string_literal: true

module Schemas
  module Instances
    class ReadPropertyContext
      include Dry::Monads[:result]

      # @param [HasSchemaDefinition] schema_instance
      # @return [Schemas::Properties::Context]
      def call(schema_instance)
        options = {}

        options[:instance] = schema_instance
        options[:values] = schema_instance&.properties&.values || {}
        options[:collected_references] = schema_instance.schematic_collected_references.to_reference_map
        options[:full_texts] = schema_instance.schematic_texts.to_reference_map
        options[:scalar_references] = schema_instance.schematic_scalar_references.to_reference_map

        Success Schemas::Properties::Context.new options
      end
    end
  end
end
