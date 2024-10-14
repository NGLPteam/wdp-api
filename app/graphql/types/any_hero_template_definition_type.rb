# frozen_string_literal: true

module Types
  # @see Types::Layouts::HeroDefinitionType
  class AnyHeroTemplateDefinitionType < Types::BaseUnion
    description <<~TEXT
    Encompasses all the possible template definition types that can fall under a `HERO` layout.
    TEXT

    possible_types "Types::Templates::HeroTemplateDefinitionType"
  end
end
