# frozen_string_literal: true

module Types
  class AnySchemaPropertyType < Types::BaseUnion
    possible_types(
      *Types::AnyScalarPropertyType.possible_types,
      Types::Schematic::GroupPropertyType
    )

    class << self
      def resolve_type(object, context)
        object.graphql_object_type
      end
    end
  end
end
