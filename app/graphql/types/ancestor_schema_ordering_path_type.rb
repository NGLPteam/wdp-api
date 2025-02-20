# frozen_string_literal: true

module Types
  class AncestorSchemaOrderingPathType < Types::BaseObject
    implements Types::OrderingPathType

    description <<~TEXT
    This ordering path represents a schema property and is variably
    available based on whether matched entities' _ancestor_ schemas
    implement it.
    TEXT

    field :schema_version, Types::SchemaVersionType, null: false
  end
end
