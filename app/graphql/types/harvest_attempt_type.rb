# frozen_string_literal: true

module Types
  # @see HarvestAttempt
  class HarvestAttemptType < Types::AbstractModel
    description <<~TEXT
    A record of a single attempt at harvesting.
    TEXT

    implements Types::HasHarvestErrorsType
    implements Types::HasHarvestMetadataFormatType

    field :harvest_source, "::Types::HarvestSourceType", null: false do
      description <<~TEXT
      The source associated with the attempt.
      TEXT
    end

    field :harvest_mapping, "::Types::HarvestMappingType", null: true do
      description <<~TEXT
      An optional mapping that may have constrained the harvest attempt.
      TEXT
    end

    field :harvest_set, "::Types::HarvestSetType", null: true do
      description <<~TEXT
      An optional set that may have constrained the harvest attempt.
      TEXT
    end

    field :target_entity, ::Types::HarvestTargetType, null: false do
      description <<~TEXT
      The target entity for the attempt. All harvest entities will be nested under this entity, unless otherwise specified.
      TEXT
    end

    field :harvest_records, resolver: ::Resolvers::HarvestRecordResolver do
      description <<~TEXT
      Records associated with this attempt specifically.
      TEXT
    end

    field :note, String, null: true do
      description <<~TEXT
      An optional note for this harvesting attempt.
      TEXT
    end

    field :began_at, GraphQL::Types::ISO8601DateTime, null: true do
      description <<~TEXT
      The time the attempt began.
      TEXT
    end

    field :ended_at, GraphQL::Types::ISO8601DateTime, null: true do
      description <<~TEXT
      The time the attempt ended.
      TEXT
    end

    field :record_count, Integer, null: true do
      description <<~TEXT
      The number of records (if available).
      TEXT
    end

    load_association! :harvest_mapping
    load_association! :harvest_set
    load_association! :harvest_source
    load_association! :target_entity
  end
end
