# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::ControlledVocabularyUpsert
  class ControlledVocabularyUpsert < Mutations::BaseMutation
    description <<~TEXT
    Upsert a controlled vocabulary based on definition.
    TEXT

    field :controlled_vocabulary, Types::ControlledVocabularyType, null: true do
      description <<~TEXT
      The newly-modified controlled vocabulary, if successful.
      TEXT
    end

    argument :definition, GraphQL::Types::JSON, required: true do
      description <<~TEXT
      The JSON definition for a controlled vocabulary.

      All controlled vocabulary details are derived from it.
      TEXT
    end

    argument :select_provider, Boolean, required: false, default_value: false, replace_null_with_default: true do
      description <<~TEXT
      If `true`, this will automatically select the controlled vocabulary as the source for whatever it `provides`.
      TEXT
    end

    performs_operation! "mutations.operations.controlled_vocabulary_upsert"
  end
end
