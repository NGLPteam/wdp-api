# frozen_string_literal: true

module Types
  module Schematic
    module HasControlledVocabularyType
      include Types::BaseInterface

      field :controlled_vocabulary, ::Types::ControlledVocabularyType, null: true do
        description <<~TEXT
        The vocabulary configured for this property, based on its `wants` value
        and whatever is currently configured in `ControlledVocabularySource`.
        TEXT
      end

      field :wants, String, null: true do
        description <<~TEXT
        The key used to determine which `ControlledVocabulary` to fetch.

        See `#controlledVocabulary`.
        TEXT
      end

      # @return [Promise(ControlledVocabulary), nil]
      def controlled_vocabulary
        Loaders::ControlledVocabularyProvider.load object.wants
      end
    end
  end
end
