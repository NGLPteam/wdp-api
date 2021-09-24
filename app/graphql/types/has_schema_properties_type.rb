# frozen_string_literal: true

module Types
  module HasSchemaPropertiesType
    include Types::BaseInterface

    field :schema_properties, [Types::AnySchemaPropertyType, { null: false }], null: false,
      description: "A list of schema properties associated with this instance or version."

    # @see Schemas::Instances::ReadProperties
    def schema_properties
      object.read_properties.value_or([])
    end
  end
end
