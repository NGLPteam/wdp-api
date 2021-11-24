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

    field :title, String, null: false, description: "A human-readable title for the entity"
    field :doi, String, null: true, description: "The Digital Object Identifier for this entity. See https://doi.org"
    field :summary, String, null: true, description: "A description of the contents of the entity"

    field :published_on, GraphQL::Types::ISO8601Date, null: true,
      deprecation_reason: "Use the variable-precision 'published' field instead"

    field :accessioned, Types::VariablePrecisionDateType, null: false,
      description: "The date this entity was added to its parent"

    field :available, Types::VariablePrecisionDateType, null: false,
      description: "The date this entity was made available"

    field :issued, Types::VariablePrecisionDateType, null: false,
      description: "The date this entity was issued"

    field :published, Types::VariablePrecisionDateType, null: false,
      description: "The date this entity was published"

    field :visibility, Types::EntityVisibilityType, null: false,
      description: "If an entity is available in the frontend"
    field :hidden_at, GraphQL::Types::ISO8601DateTime, null: true,
      description: "If present, this is the timestamp the entity was hidden at"
    field :visible_after_at, GraphQL::Types::ISO8601DateTime, null: true,
      description: "If present, this is the timestamp an entity is visible after"
    field :visible_until_at, GraphQL::Types::ISO8601DateTime, null: true,
      description: "If present, this is the timestamp an entity is visible until"

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false,
      description: "The date this entity was added to the WDP"
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false,
      description: "The date this entity was last updated within the WDP"

    field :root, Boolean, null: false, method: :root?
    field :leaf, Boolean, null: false, method: :leaf?
    field :hidden, Boolean, null: false, method: :visibility_hidden?
    field :visible, Boolean, null: false, method: :visibility_visible?

    field :ancestor_of_type, Types::AnyEntityType, null: true do
      description <<~TEXT
      Look up an ancestor for this entity that implements a specific type. It ascends from this entity,
      so it will first check the parent, then the grandparent, and so on.
      TEXT

      argument :schema, String, required: true, description: "A fully-qualified name of a schema to look for."
    end

    # @param [String] schema_slug
    # @return [HierarchicalEntity]
    def ancestor_of_type(schema:)
      object.ancestor_of_type(schema)
    end
  end
end
