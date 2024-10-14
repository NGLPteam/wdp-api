# frozen_string_literal: true

module Templates
  module Drops
    # A drop that wraps around a {ControlledVocabularyItem}.
    class ControlledVocabularyItemDrop < Templates::Drops::AbstractDrop
      delegate :description, :identifier, :label, :url, to: :@item

      alias to_s label

      # @param [ControlledVocabularyItem] item
      def initialize(item)
        super()

        @item = item
      end

      # @return [String]
      memoize def id
        @item.to_encoded_id
      end
    end
  end
end
