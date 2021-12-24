# frozen_string_literal: true

module Types
  # @see ChildEntity
  module ChildEntityType
    include Types::BaseInterface

    implements Types::HasDefaultTimestamps
    implements Types::HasDOIType
    implements Types::HasISSNType
    implements Types::ReferencesEntityVisibilityType
    implements Types::ReferencesGlobalEntityDatesType

    description <<~TEXT
    An interface for entities that can contain actual content, as well as any number of themselves
    in a tree structure.

    In practice, this means a `Collection` or an `Item`, not a `Community`.
    TEXT

    field :identifier, String, null: false do
      description <<~TEXT.strip_heredoc.squish
      A machine-readable identifier for the entity. Not presently used, but will be necessary
      for synchronizing with upstream providers.
      TEXT
    end

    field :summary, String, null: true, description: "A description of the contents of the entity"

    field :root, Boolean, null: false, method: :root?
    field :leaf, Boolean, null: false, method: :leaf?

    field :ancestor_of_type, Types::AnyEntityType, null: true do
      description <<~TEXT
      Look up an ancestor for this entity that implements a specific type. It ascends from this entity,
      so it will first check the parent, then the grandparent, and so on.
      TEXT

      argument :schema, String, required: true, description: "A fully-qualified name of a schema to look for."
    end

    # @param [String] schema
    # @return [HierarchicalEntity, nil]
    def ancestor_of_type(schema:)
      object.ancestor_of_type(schema)
    end

  end
end
