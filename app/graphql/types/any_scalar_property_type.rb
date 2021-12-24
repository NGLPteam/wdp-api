# frozen_string_literal: true

module Types
  class AnyScalarPropertyType < Types::BaseUnion
    possible_types(
      Types::Schematic::AssetPropertyType,
      Types::Schematic::AssetsPropertyType,
      Types::Schematic::BooleanPropertyType,
      Types::Schematic::ContributorPropertyType,
      Types::Schematic::ContributorsPropertyType,
      Types::Schematic::DatePropertyType,
      Types::Schematic::EmailPropertyType,
      Types::Schematic::FloatPropertyType,
      Types::Schematic::FullTextPropertyType,
      Types::Schematic::IntegerPropertyType,
      Types::Schematic::MarkdownPropertyType,
      Types::Schematic::MultiselectPropertyType,
      Types::Schematic::SelectPropertyType,
      Types::Schematic::StringPropertyType,
      Types::Schematic::TagsPropertyType,
      Types::Schematic::TimestampPropertyType,
      Types::Schematic::UnknownPropertyType,
      Types::Schematic::URLPropertyType,
      Types::Schematic::VariableDatePropertyType
    )

    description <<~TEXT
    `AnyScalarProperty` represents a collection of known *scalar* properties. In effect,
    it includes every possible schema property type except for groups (`GroupProperty`).

    This union is intended to iterate the properties within a group. To iterate over the
    properties in a `SchemaInstance`, you should use `AnySchemaPropertyType` to ensure that
    you are also seeing groups.

    Any object contained within this union is guaranteed to implement `ScalarProperty`
    as well as `SchemaProperty`.
    TEXT

    class << self
      def resolve_type(object, context)
        object.graphql_object_type
      end
    end
  end
end
