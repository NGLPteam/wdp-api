# frozen_string_literal: true

module Types
  # @see HarvestMapping
  class HarvestMappingType < Types::AbstractModel
    description <<~TEXT
    A specific mapping to be used by a `HarvestSource`,
    possibly an optional `HarvestSet`, and other options
    in order to harvest records from the source and produce
    entities.

    It can produce a `HarvestAttempt`.
    TEXT

    implements Types::HarvestAttemptableType
    implements Types::HasHarvestMetadataFormatType
    implements Types::HasHarvestOptionsType

    field :harvest_attempts, resolver: ::Resolvers::HarvestAttemptResolver do
      description <<~TEXT
      Attempts produced by this mapping.
      TEXT
    end

    field :harvest_records, resolver: ::Resolvers::HarvestRecordResolver do
      description <<~TEXT
      Records associated with this mapping.
      TEXT
    end

    field :harvest_set, Types::HarvestSetType, null: true do
      description <<~TEXT
      The optionally-associated harvest set for this mapping.
      TEXT
    end

    field :target_entity, ::Types::HarvestTargetType, null: false do
      description <<~TEXT
      The target entity for the attempt. All harvest entities will be nested under this entity, unless otherwise specified.
      TEXT
    end

    load_association! :target_entity
  end
end
