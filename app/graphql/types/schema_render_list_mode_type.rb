# frozen_string_literal: true

module Types
  # @see Schemas::Versions::RenderDefinition#list_mode
  class SchemaRenderListModeType < Types::BaseEnum
    description <<~TEXT
    How instances that implement a certain schema should be rendered outside of an ordering,
    when rendering only entities for the same type of schema.

    This value is currently only intended to be used by the frontend. It enforces no special
    handling within the API itself, unlike an `OrderingRenderModeType`.
    TEXT

    value "GRID", value: "grid"
    value "TABLE", value: "table"
    value "TREE", value: "tree"
  end
end
