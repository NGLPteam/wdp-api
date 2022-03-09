# frozen_string_literal: true

module Loaders
  # Load the property context for a schema instance.
  #
  # @see Schemas::Instances::ReadPropertyContext
  # @see Schemas::Properties::Context
  class SchemaPropertyContextLoader < GraphQL::Batch::Loader
    include WDPAPI::Deps[to_context: "schemas.instances.read_property_context"]

    # @param [Class<HasSchemaDefinition>] model
    def initialize(model, **args)
      @model = model
      super(**args)
    end

    # @param [HasSchemaDefinition] record
    def load(record)
      super(Schemas::Types::SchemaInstance[record])
    end

    # @note We want to load the associations on all records, even if they have the same id
    #
    # @param [HasSchemaDefinition] record
    # @return [String]
    def cache_key(record)
      record.object_id
    end

    # @param [<HasSchemaDefinition>] records
    # @return [void]
    def perform(records)
      records.each do |record|
        context = to_context.call record

        fulfill record, context
      end
    end
  end
end
