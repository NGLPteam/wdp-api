# frozen_string_literal: true

module Types
  # @see Schemas::Properties::Scalar::Base
  class AnySearchablePropertyType < Types::BaseUnion
    possible_types(
      Types::Schematic::BooleanPropertyType,
      Types::Schematic::DatePropertyType,
      Types::Schematic::FloatPropertyType,
      Types::Schematic::FullTextPropertyType,
      Types::Schematic::IntegerPropertyType,
      Types::Schematic::MarkdownPropertyType,
      Types::Schematic::MultiselectPropertyType,
      Types::Schematic::SelectPropertyType,
      Types::Schematic::StringPropertyType,
      Types::Schematic::TimestampPropertyType,
      Types::Schematic::VariableDatePropertyType,
    )

    description <<~TEXT
    `AnySearchableProperty` represents a property that can be searched on.

    Any property underneath this can be assured to implement `SearchableProperty`.
    TEXT

    class << self
      def resolve_type(object, context)
        object.graphql_object_type
      end
    end
  end
end
