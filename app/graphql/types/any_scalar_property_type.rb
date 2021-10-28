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
      Types::Schematic::VariableDatePropertyType
    )

    class << self
      def resolve_type(object, context)
        object.graphql_object_type
      end
    end
  end
end
