# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::ControlledVocabularySourceUpdate
  class ControlledVocabularySourceUpdate < Mutations::MutateControlledVocabularySource
    description <<~TEXT
    Update a single `ControlledVocabularySource`'s provider.
    TEXT

    argument :controlled_vocabulary_source_id, ID, loads: Types::ControlledVocabularySourceType, required: true do
      description <<~TEXT
      The controlled vocabulary source to update.
      TEXT
    end

    argument :controlled_vocabulary_id, ID, loads: Types::ControlledVocabularyType, required: true do
      description <<~TEXT
      The controlled vocabulary to select as the provider
      TEXT
    end

    performs_operation! "mutations.operations.controlled_vocabulary_source_update"
  end
end
