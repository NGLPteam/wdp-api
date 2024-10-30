# frozen_string_literal: true

module Types
  class TemplateOrderingPairType < Types::BaseObject
    description <<~TEXT
    An object that provides a next/prev pair for navigating through ordering siblings
    within a template.
    TEXT

    field :count, Int, null: true do
      description <<~TEXT
      The number of entries in the ordering (`null` if no match).
      TEXT
    end

    field :exists, Boolean, null: false do
      description <<~TEXT
      Whether or not the ordering / entry actually exists—can be used to skip rendering.
      TEXT
    end

    field :first, Boolean, null: false do
      description <<~TEXT
      Whether the source entity is the _first_ entity in the ordering.
      TEXT
    end

    field :last, Boolean, null: false do
      description <<~TEXT
      Whether the source entity is the _last_ entity in the ordering.
      TEXT
    end

    field :position, Int, null: true do
      description <<~TEXT
      The source entity's (1-based) position in the ordering.
      TEXT
    end

    field :prev_sibling, "Types::OrderingEntryType", null: true do
      description <<~TEXT
      The previous entry in the current ordering, if one exists. This will be null if this entry is the first.
      TEXT
    end

    field :next_sibling, "Types::OrderingEntryType", null: true do
      description <<~TEXT
      The next entry in the current ordering, if one exists. This will be null if this entry is the last.
      TEXT
    end
  end
end
