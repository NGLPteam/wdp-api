# frozen_string_literal: true

module Types
  # @see Types::Layouts::SupplementaryInstanceType
  class AnySupplementaryTemplateInstanceType < Types::BaseUnion
    description <<~TEXT
    Encompasses all the possible template instance types that can fall under a `SUPPLEMENTARY` layout.
    TEXT

    possible_types "Types::Templates::SupplementaryTemplateInstanceType"
  end
end
