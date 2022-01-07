# frozen_string_literal: true

module Types
  # @see Schemas::Orderings::OrderDefinition#path
  module OrderingPathType
    include Types::BaseInterface

    description <<~TEXT
    This represents a valid path that can be used for orderings.
    TEXT

    field :path, String, null: false do
      description "The exact path that should be provided to mutation inputs."
    end

    field :grouping, Types::OrderingPathGroupingType, null: false do
      description "A logical grouping for ordering paths"
    end

    field :label_prefix, String, null: true do
      description <<~TEXT
      Some paths may have a prefix. For instance, schema properties will have the name of the schema.
      TEXT
    end

    field :label, String, null: false do
      description "A human-readable label for the path"
    end

    field :description, String, null: true do
      description "A helpful description of the path"
    end

    field :type, Types::SchemaPropertyTypeType, null: false do
      description "The schema property type"
    end
  end
end
