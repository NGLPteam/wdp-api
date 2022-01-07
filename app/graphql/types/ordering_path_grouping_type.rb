# frozen_string_literal: true

module Types
  class OrderingPathGroupingType < Types::BaseEnum
    description "A logical grouping for ordering paths."

    value "ENTITY", value: "entity" do
      description <<~TEXT
      Static properties that are directly on an entity.
      TEXT
    end

    value "LINK", value: "link" do
      description <<~TEXT
      Static properties that are derived from a link.
      TEXT
    end

    value "PROPS", value: "props" do
      description <<~TEXT
      Paths under this type come from a schema. Not every entity is guaranteed
      to have one, and in orderings with mixed entities, missing props will be
      treated as null.
      TEXT
    end

    value "SCHEMA", value: "schema" do
      description <<~TEXT
      Static properties that are derived from a schema.
      TEXT
    end
  end
end
