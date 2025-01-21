# frozen_string_literal: true

module Types
  # @see ContributionRoleConfiguration
  class ContributionRoleConfigurationInputType < Types::HashInputObject
    description <<~TEXT
    Configuration for the controlled vocabulary used for contribution roles on a given `source`.
    TEXT

    argument :controlled_vocabulary_id, ID, loads: Types::ControlledVocabularyType, required: true do
      description <<~TEXT
      The set of items to use for contribution roles for this source.
      TEXT
    end

    argument :default_item_id, ID, loads: Types::ControlledVocabularyItemType, required: true do
      description <<~TEXT
      The default item to use when a contribution is created but no role is provided.
      This is necessary as a fallback for harvesting and other use cases.
      TEXT
    end

    argument :other_item_id, ID, loads: Types::ControlledVocabularyItemType, required: false do
      description <<~TEXT
      The "other" item in the set, if available (logic to be implemented later).
      TEXT
    end
  end
end
