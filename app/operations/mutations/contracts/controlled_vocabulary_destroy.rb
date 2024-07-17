# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::ControlledVocabularyDestroy
    # @see Mutations::Operations::ControlledVocabularyDestroy
    class ControlledVocabularyDestroy < MutationOperations::Contract
      json do
        required(:controlled_vocabulary).value(:controlled_vocabulary)
      end

      rule(:controlled_vocabulary) do
        base.failure "You cannot destroy a default / built-in controlled vocabulary." if value.has_default_namespace?
      end
    end
  end
end
