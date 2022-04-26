# frozen_string_literal: true

module Seeding
  module Brokers
    module DSL
      # @abstract
      class EntityBuilder < Builder
        before_build :prepare_schemas!

        after_build :add_schemas!

        # @param [String] declaration
        # @return [void]
        def handles_schema!(declaration, suppressed_properties: [])
          @schemas[declaration] = Seeding::Brokers::SchemaBroker.new declaration, suppressed_properties: suppressed_properties

          return self
        end

        # @return [void]
        def add_schemas!
          schemas = Seeding::Brokers::SchemaBroker::Map[@schemas]

          @attributes[:schemas] = Seeding::Brokers::SchemasBroker.new schemas: schemas
        end

        # @return [void]
        def prepare_schemas!
          @schemas = {}
        end
      end
    end
  end
end
