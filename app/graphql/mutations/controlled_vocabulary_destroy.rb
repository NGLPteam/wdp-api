# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::ControlledVocabularyDestroy
  class ControlledVocabularyDestroy < Mutations::BaseMutation
    description <<~TEXT
    Destroy a single `ControlledVocabulary` record.
    TEXT

    argument :controlled_vocabulary_id, ID, loads: Types::ControlledVocabularyType, required: true do
      description <<~TEXT
      The controlled vocabulary to destroy.
      TEXT
    end

    performs_operation! "mutations.operations.controlled_vocabulary_destroy", destroy: true
  end
end
