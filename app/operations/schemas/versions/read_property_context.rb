# frozen_string_literal: true

module Schemas
  module Versions
    # Build a property context for a {SchemaVersion}.
    #
    # @see Schemas::Properties::Context
    # @see SchemaVersion#to_property_context
    class ReadPropertyContext
      # @param [SchemaVersion] schema_version
      # @return [Schemas::Properties::Context]
      def call(schema_version)
        options = schema_version.to_property_context

        Schemas::Properties::Context.new **options
      end
    end
  end
end
