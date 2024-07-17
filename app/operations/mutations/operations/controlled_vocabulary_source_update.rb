# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::ControlledVocabularySourceUpdate
    class ControlledVocabularySourceUpdate
      include MutationOperations::Base

      use_contract! :controlled_vocabulary_source_update

      # @param [ControlledVocabularySource] controlled_vocabulary_source
      # @param [ControlledVocabulary] controlled_vocabulary
      # @return [void]
      def call(controlled_vocabulary_source:, controlled_vocabulary:, **)
        authorize controlled_vocabulary_source, :update?

        assign_attributes!(controlled_vocabulary_source, controlled_vocabulary:)

        persist_model! controlled_vocabulary_source, attach_to: :controlled_vocabulary_source
      end
    end
  end
end
