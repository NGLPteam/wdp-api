# frozen_string_literal: true

module Types
  # @see Types::Layouts::HeroInstanceType
  class AnyHeroTemplateInstanceType < Types::BaseUnion
    description <<~TEXT
    Encompasses all the possible template instance types that can fall under a `HERO` layout.
    TEXT

    possible_types "Types::Templates::HeroTemplateInstanceType"
  end
end
