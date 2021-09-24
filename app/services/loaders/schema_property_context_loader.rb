# frozen_string_literal: true

module Loaders
  class SchemaPropertyContextLoader < GraphQL::Batch::Loader
    include WDPAPI::Deps[to_context: "schemas.instances.read_property_context"]

    include Dry::Monads::Do.for(:perform)

    IsSchemaInstance = AppTypes.Instance(HasSchemaDefinition)

    def initialize(model, **args)
      @model = model
      super(**args)
    end

    def load(record)
      super(IsSchemaInstance[record])
    end

    # We want to load the associations on all records, even if they have the same id
    def cache_key(record)
      record.object_id
    end

    def perform(records)
      records.each do |record|
        context = yield to_context.call record

        fulfill record, context
      end
    end
  end
end
