# frozen_string_literal: true

module Types
  module HierarchicalEntryType
    include Types::BaseInterface

    description "A hierarchical entity, like a collection or an item."

    field :identifier, String, null: false do
      description <<~TEXT.strip_heredoc.squish
      A machine-readable identifier for the entity. Not presently used, but will be necessary
      for synchronizing with upstream providers.
      TEXT
    end

    field :title, String, null: true, description: "A human-readable title for the entity"
    field :doi, String, null: true, description: "The Digital Object Identifier for this entity. See https://doi.org"
    field :summary, String, null: true, description: "A description of the contents of the entity"

    field :published_on, GraphQL::Types::ISO8601Date, null: true, description: "The date the entity was published on, if present"

    field :visibility, Types::EntityVisibilityType, null: false,
      description: "If an entity is available in the frontend"
    field :hidden_at, GraphQL::Types::ISO8601DateTime, null: true,
      description: "If present, this is the timestamp the entity was hidden at"
    field :visible_after_at, GraphQL::Types::ISO8601DateTime, null: true,
      description: "If present, this is the timestamp an entity is visible after"
    field :visible_until_at, GraphQL::Types::ISO8601DateTime, null: true,
      description: "If present, this is the timestamp an entity is visible until"

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :root, Boolean, null: false, method: :root?
    field :leaf, Boolean, null: false, method: :leaf?
    field :hidden, Boolean, null: false, method: :visibility_hidden?
    field :visible, Boolean, null: false, method: :visibility_visible?
  end
end
