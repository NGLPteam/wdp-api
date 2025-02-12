# frozen_string_literal: true

module Types
  # @see Harvesting::Options::Mapping
  # @see Types::HarvestOptionsMappingInputType
  class HarvestOptionsMappingType < Types::BaseObject
    description <<~TEXT
    Options that control mapping of entities during the harvesting process.
    TEXT

    field :auto_create_volumes_and_issues, Boolean, null: false do
      description <<~TEXT
      Harvesting certain journals may require creating volumes/issues automatically.
      TEXT
    end

    field :link_identifiers_globally, Boolean, null: false do
      description <<~TEXT
      When linking to existing entities, it may be necessary to use global identifiers,
      as there may be some entities that are created outside of a specific harvesting
      attempt, or exist elsewhere in the hierarchy.

      This will look for a globally unique identifier for an entity, and fail if it finds
      duplicates.
      TEXT
    end

    field :use_metadata_mappings, Boolean, null: false do
      description <<~TEXT
      When resolving to existing entities, the system may rely on
      metadata mappings to figure out where something should go based
      on the presence of certain fields in the metadata.
      TEXT
    end
  end
end
