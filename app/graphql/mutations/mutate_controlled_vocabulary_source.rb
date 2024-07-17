# frozen_string_literal: true

module Mutations
  # @abstract
  # @see Mutations::CreateControlledVocabularySource
  # @see Mutations::UpdateControlledVocabularySource
  class MutateControlledVocabularySource < Mutations::BaseMutation
    description <<~TEXT
    A base mutation that is used to share fields between `createControlledVocabularySource` and `updateControlledVocabularySource`.
    TEXT

    field :controlled_vocabulary_source, Types::ControlledVocabularySourceType, null: true do
      description <<~TEXT
      The newly-modified controlled vocabulary source, if successful.
      TEXT
    end
  end
end
