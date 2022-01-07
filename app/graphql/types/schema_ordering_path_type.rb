# frozen_string_literal: true

module Types
  class SchemaOrderingPathType < Types::BaseObject
    implements Types::OrderingPathType

    description <<~TEXT
    This ordering path represents a schema property and is variably
    available based on whether matched entities' schemas implement it.
    TEXT

    field :schema_version, Types::SchemaVersionType, null: false
  end
end
