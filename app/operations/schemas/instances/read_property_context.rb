# frozen_string_literal: true

module Schemas
  module Instances
    # Read the {Schemas::Properties::Context property context} for {HasSchemaDefinition a schema instance}.
    class ReadPropertyContext
      # @param [HasSchemaDefinition] schema_instance
      # @return [Schemas::Properties::Context]
      def call(schema_instance)
        version = schema_instance.schema_version

        options = version.to_property_context

        options[:instance] = schema_instance
        options[:values] = schema_instance&.properties&.values || {}
        options[:collected_references] = schema_instance.schematic_collected_references.to_reference_map
        options[:full_texts] = schema_instance.schematic_texts.to_reference_map
        options[:scalar_references] = schema_instance.schematic_scalar_references.to_reference_map

        Schemas::Properties::Context.new options
      end
    end
  end
end
