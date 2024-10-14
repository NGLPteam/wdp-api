# frozen_string_literal: true

module Types
  # @see Types::Layouts::SupplementaryDefinitionType
  class AnySupplementaryTemplateDefinitionType < Types::BaseUnion
    description <<~TEXT
    Encompasses all the possible template definition types that can fall under a `SUPPLEMENTARY` layout.
    TEXT

    possible_types "Types::Templates::SupplementaryTemplateDefinitionType"
  end
end
