# frozen_string_literal: true

module Types
  # @see Types::Layouts::ListItemDefinitionType
  class AnyListItemTemplateDefinitionType < Types::BaseUnion
    description <<~TEXT
    Encompasses all the possible template definition types that can fall under a `LIST_ITEM` layout.
    TEXT

    possible_types "Types::Templates::ListItemTemplateDefinitionType"
  end
end
