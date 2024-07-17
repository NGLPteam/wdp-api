# frozen_string_literal: true

module Types
  module Schematic
    class ControlledVocabularyPropertyType < Types::AbstractObjectType
      implements ScalarPropertyType
      implements HasControlledVocabularyType

      field :controlled_vocabulary_item, Types::ControlledVocabularyItemType, null: true, method: :value
    end
  end
end
