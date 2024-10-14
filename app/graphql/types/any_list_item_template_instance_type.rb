# frozen_string_literal: true

module Types
  # @see Types::Layouts::ListItemInstanceType
  class AnyListItemTemplateInstanceType < Types::BaseUnion
    description <<~TEXT
    Encompasses all the possible template instance types that can fall under a `LIST_ITEM` layout.
    TEXT

    possible_types "Types::Templates::ListItemTemplateInstanceType"
  end
end
