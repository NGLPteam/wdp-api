# frozen_string_literal: true

module Types
  module HasSchemaPropertiesType
    include Types::BaseInterface

    field :schema_properties, [Types::AnySchemaPropertyType, { null: false }], null: false,
      description: "A list of schema properties associated with this instance or version."

    # @see Schemas::Instances::ReadProperties
    def schema_properties
      if object.kind_of?(HasSchemaDefinition)
        Loaders::AssociationLoader.for(object.class, :schematic_collected_references).load(object)
        Loaders::AssociationLoader.for(object.class, :schematic_scalar_references).load(object)
      end

      object.read_properties.value_or([])
    end
  end
end
