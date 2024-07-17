# frozen_string_literal: true

module ControlledVocabularies
  class CalculateItemSet
    include Dry::Monads[:result]

    # @param [ControlledVocabulary] controlled_vocabulary
    # @return [<Hash>]
    def call(controlled_vocabulary)
      item_set = controlled_vocabulary.controlled_vocabulary_items.roots.in_default_order.map(&:to_item_set)

      Success item_set
    end
  end
end
