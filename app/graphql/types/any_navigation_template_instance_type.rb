# frozen_string_literal: true

module Types
  # @see Types::Layouts::NavigationInstanceType
  class AnyNavigationTemplateInstanceType < Types::BaseUnion
    description <<~TEXT
    Encompasses all the possible template instance types that can fall under a `NAVIGATION` layout.
    TEXT

    possible_types "Types::Templates::NavigationTemplateInstanceType"
  end
end
