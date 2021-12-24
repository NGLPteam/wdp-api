# frozen_string_literal: true

module Mutations
  class ReparentEntity < Mutations::BaseMutation
    description <<~TEXT.strip_heredoc
    A polymorphic mutation to reassign an entity to another point in the hierarchy.

    It performs validations to make sure that the parent entity can accept the child.
    TEXT

    field :child, Types::AnyChildEntityType, null: true do
      description "If the child was successfully reparented, this field will be populated"
    end

    argument :child_id, ID, loads: Types::AnyChildEntityType, required: true, attribute: true do
      description <<~TEXT.strip_heredoc
      The collection in need of a new parent
      TEXT
    end

    argument :parent_id, ID, loads: Types::AnyEntityType, required: true, attribute: true do
      description <<~TEXT.strip_heredoc
      The ID for the new parent entity. For children of the collection type, this
      must be a community or another collection. For children of the item type,
      this must be a collection or another item.
      TEXT
    end

    performs_operation! "mutations.operations.reparent_entity"
  end
end
