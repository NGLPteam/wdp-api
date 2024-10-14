# frozen_string_literal: true

module Types
  # @see Types::Layouts::MetadataInstanceType
  class AnyMetadataTemplateInstanceType < Types::BaseUnion
    description <<~TEXT
    Encompasses all the possible template instance types that can fall under a `METADATA` layout.
    TEXT

    possible_types "Types::Templates::MetadataTemplateInstanceType"
  end
end
