# frozen_string_literal: true

module Types
  class AnySchemaPropertyType < Types::BaseUnion
    possible_types(
      *Types::AnyScalarPropertyType.possible_types,
      Types::Schematic::GroupPropertyType
    )

    description <<~TEXT
    `AnySchemaProperty` represents the top level of a schema instance's properties. It can include any scalar property, as
    well as any `GroupProperty` that the instance might have. To query only scalar properties, see `AnyScalarProperty`.

    All properties contained in this union are guaranteed to implement `SchemaProperty`.
    TEXT

    class << self
      def resolve_type(object, context)
        object.graphql_object_type
      end
    end
  end
end
