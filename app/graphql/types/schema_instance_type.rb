# frozen_string_literal: true

module Types
  module SchemaInstanceType
    include Types::BaseInterface
    include Types::HasSchemaPropertiesType

    description <<~TEXT
    Being an instance that implements a schema version with strongly-typed properties.
    Overlaps with Entity, but intended for focused access to just the properties
    and the necessary context.
    TEXT

    field :schema_instance_context, Types::SchemaInstanceContextType, null: false,
      description: "The context for our schema instance. Includes form values and necessary referents."

    def schema_instance_context
      Loaders::SchemaPropertyContextLoader.for(object.class).load(object)
    end

    # @see Schemas::Instances::ReadProperties
    def schema_properties
      Promise.all([
                    schema_instance_context,
                    Loaders::AssociationLoader.for(object.class, :schematic_collected_references).load(object),
                    Loaders::AssociationLoader.for(object.class, :schematic_scalar_references).load(object),
                  ]).then do |(context, *)|
        object.read_properties(context: context).value_or([])
      end
    end
  end
end
