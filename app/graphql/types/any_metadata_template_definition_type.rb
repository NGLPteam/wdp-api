# frozen_string_literal: true

module Types
  # @see Types::Layouts::MetadataDefinitionType
  class AnyMetadataTemplateDefinitionType < Types::BaseUnion
    description <<~TEXT
    Encompasses all the possible template definition types that can fall under a `METADATA` layout.
    TEXT

    possible_types "Types::Templates::MetadataTemplateDefinitionType"
  end
end
