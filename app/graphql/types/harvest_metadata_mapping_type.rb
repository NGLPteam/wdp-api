# frozen_string_literal: true

module Types
  # @see HarvestMetadataMapping
  class HarvestMetadataMappingType < Types::AbstractModel
    description <<~TEXT
    A database-backed model.
    TEXT

    field :field, ::Types::HarvestMetadataMappingFieldType, null: false do
      description <<~TEXT
      TEXT
    end
  end
end
