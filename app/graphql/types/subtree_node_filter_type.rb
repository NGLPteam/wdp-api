# frozen_string_literal: true

module Types
  class SubtreeNodeFilterType < Types::BaseEnum
    description <<~TEXT.squish
    When retrieving subtypes of a specific entity, you can distinguish between grabbing
    its children (default) or all of its descendants.
    TEXT

    value "CHILDREN", description: "Fetch only the first level of the same type of entity (Item, Collection)"
    value "DESCENDANTS", description: "Fetch all descendant entities of the same base type (Item, Collection)"
  end
end
