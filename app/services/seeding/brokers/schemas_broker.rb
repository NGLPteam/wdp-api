# frozen_string_literal: true

module Seeding
  module Brokers
    # A broker for handling a mapping of {SchemaBroker} for
    # a given entity type.
    class SchemasBroker < Broker
      attribute :schemas, Seeding::Brokers::SchemaBroker::Map

      # @param [SchemaVersion] schema_version
      # @return [SchemaBroker, nil]
      def broker_for(schema_version)
        case schema_version
        when ::SchemaVersion
          schemas.values.detect do |broker|
            broker.supported? schema_version
          end
        when ::HasSchemaDefinition, Seeding::Types::Interface(:schema_version)
          broker_for schema_version.schema_version
        end
      end

      def supported?(schema_version)
        broker_for(schema_version).present?
      end
    end
  end
end
