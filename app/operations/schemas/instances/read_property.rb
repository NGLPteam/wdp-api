# frozen_string_literal: true

module Schemas
  module Instances
    # Build {Schemas::Properties::Reader a reader} (or {Schemas::Properties::GroupReader group reader})
    # for a single schema property on {HasSchemaDefinition an instance}.
    class ReadProperty
      include MeruAPI::Deps[fetch_reader: "schemas.properties.fetch_reader"]

      # @param [HasSchemaDefinition] schema_instance
      # @param [String] full_path
      # @param [Schemas::Properties::Context, nil] context
      # @return [Schemas::Properties::Reader, Schemas::Properties::GroupReader]
      def call(schema_instance, full_path, context: nil)
        fetch_reader.(schema_instance, full_path, context:)
      end
    end
  end
end
