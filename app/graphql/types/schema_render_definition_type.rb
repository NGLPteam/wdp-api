# frozen_string_literal: true

module Types
  # @see Schemas::Versions::RenderDefinition
  class SchemaRenderDefinitionType < Types::BaseObject
    description <<~TEXT
    Configuration for controlling how instances of a schema render outside of orderings.
    TEXT

    field :list_mode, Types::SchemaRenderListModeType, null: false,
      description: "How to render a list"
  end
end
