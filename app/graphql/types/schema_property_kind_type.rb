# frozen_string_literal: true

module Types
  class SchemaPropertyKindType < Types::BaseEnum
    description <<~TEXT
    The _kind_ of a data type for a schema property. Mostly informational
    in the API, this value represents the underlying structure of the data type.
    TEXT

    value "GROUP", value: "group", description: "A composite of other properties. See `GroupProperty`"
    value "REFERENCE", value: "reference" do
      description <<~TEXT
      A reference (or references) to other models in the system.

      See `AssetProperty`, `ContributorsProperty` for examples
      TEXT
    end

    value "COMPLEX", value: "complex" do
      description <<~TEXT
      A complex data type that is composed of multiple subproperties
      or requires other processing. Their values cannot be easily
      mapped to GraphQL / JavaScript primitives.

      See `VariableDateProperty`, `FullTextProperty` for examples.
      TEXT
    end

    value "SIMPLE", value: "simple" do
      description <<~TEXT
      The most common type of property, and what most values are likely to be. Strings,
      integers, floats, booleans, and so on.
      TEXT
    end
  end
end
