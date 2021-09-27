# frozen_string_literal: true

module Schemas
  module Instances
    class AlterAndGenerateJob < ApplicationJob
      queue_as :maintenance

      # @param [HasSchemaDefinition] schema_instance
      # @param [SchemaVersion, String] schema_version (@see Schemas::Versions::Find)
      # @return [void]
      def perform(schema_instance, schema_version)
        schema_instance.alter_and_generate!(schema_version).value!
      end
    end
  end
end
