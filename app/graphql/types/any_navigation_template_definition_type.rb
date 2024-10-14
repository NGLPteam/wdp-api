# frozen_string_literal: true

module Types
  # @see Types::Layouts::NavigationDefinitionType
  class AnyNavigationTemplateDefinitionType < Types::BaseUnion
    description <<~TEXT
    Encompasses all the possible template definition types that can fall under a `NAVIGATION` layout.
    TEXT

    possible_types "Types::Templates::NavigationTemplateDefinitionType"
  end
end
