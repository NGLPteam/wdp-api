# frozen_string_literal: true

module Schemas
  module Utility
    # Extract a {SchemaVersion} from something that connects to one.
    class VersionFor
      # @param [ApplicationRecord, #schema_version] thing
      # @raise [TypeError] if a schema error cannot be derived
      # @return [SchemaVersion]
      def call(thing)
        case thing
        when SchemaVersion
          thing
        when Entity, HasSchemaDefinition
          thing.schema_version
        when AppTypes.Interface(:schema_version)
          call(thing.schema_version)
        else
          raise TypeError, "Cannot get a SchemaVersion from #{thing.inspect}"
        end
      end
    end
  end
end
