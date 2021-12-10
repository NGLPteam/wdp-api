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

    field :schema_property, Types::AnySchemaPropertyType, null: true do
      description <<~TEXT
      Read a single schema property by its full path.
      TEXT

      argument :full_path, String, required: true,
        description: "The full path to the schema property. Please note, paths are snake_case, not camelCase."
    end

    # @see Loaders::SchemaPropertyContextLoader
    def schema_instance_context
      Loaders::SchemaPropertyContextLoader.for(object.class).load(object)
    end

    # @see Schemas::Instances::ReadProperties
    # @see HasSchemaDefinition#read_properties
    def schema_properties
      with_schema_associations_loaded.then do |(context, *)|
        object.read_properties(context: context).value_or([])
      end
    end

    # @see Schemas::Instances::ReadProperty
    # @see HasSchemaDefinition#read_property
    def schema_property(full_path:)
      with_schema_associations_loaded.then do |(context, *)|
        object.read_property(full_path, context: context).value_or(nil)
      end
    end

    private

    def with_schema_associations_loaded
      Promise.all(
        [
          schema_instance_context,
          Loaders::AssociationLoader.for(object.class, :schematic_collected_references).load(object),
          Loaders::AssociationLoader.for(object.class, :schematic_scalar_references).load(object),
          Loaders::AssociationLoader.for(object.class, :schematic_texts).load(object)
        ]
      )
    end
  end
end
