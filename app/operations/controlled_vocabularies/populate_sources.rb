# frozen_string_literal: true

module ControlledVocabularies
  class PopulateSources
    include Dry::Monads[:result]

    def call
      ControlledVocabularySource.populate!

      Success()
    end
  end
end
