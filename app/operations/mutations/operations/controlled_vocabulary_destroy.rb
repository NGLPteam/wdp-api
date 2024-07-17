# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::ControlledVocabularyDestroy
    class ControlledVocabularyDestroy
      include MutationOperations::Base

      use_contract! :controlled_vocabulary_destroy

      # @param [ControlledVocabulary] controlled_vocabulary
      # @return [void]
      def call(controlled_vocabulary:)
        destroy_model! controlled_vocabulary, auth: true
      end
    end
  end
end
