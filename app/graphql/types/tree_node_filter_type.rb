# frozen_string_literal: true

module Types
  class TreeNodeFilterType < Types::BaseEnum
    description <<~TEXT.squish
    When retrieving a paginated connection of tree-like entities, this enum is used
    to delineate which class of nodes to retrieve. Usually, you only want roots, but
    two other possibilities are exposed.
    TEXT

    value "ROOTS_ONLY", description: "Fetch only nodes that are \"roots\": nodes that do not have a parent of the same type"
    value "ROOTS_AND_LEAVES", description: "Fetch all nodes that match other filters passed to the resolver"
    value "LEAVES_ONLY", description: "Fetch only nodes that are \"leaves\"; nodes that have a parent of the same type"
  end
end
