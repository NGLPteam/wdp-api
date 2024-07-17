# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::ControlledVocabularySourceUpdate
    # @see Mutations::Operations::ControlledVocabularySourceUpdate
    class ControlledVocabularySourceUpdate < MutationOperations::Contract
      json do
        required(:controlled_vocabulary_source).value(:controlled_vocabulary_source)
        required(:controlled_vocabulary).value(:controlled_vocabulary)
      end
    end
  end
end
