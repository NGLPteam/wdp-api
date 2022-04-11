# frozen_string_literal: true

module Types
  module Searching
    # @see ::Searching::Operators::And
    class AndOperatorInputType < Types::BaseInputObject
      description <<~TEXT
      The boolean result of evaluating the left and right predicates. Both must be true.

      While this is implemented, it is not likely that the first version of the search
      UI will utilize it. It is intended for advanced searching.
      TEXT

      argument :left, "Types::SearchPredicateInputType", required: true
      argument :right, "Types::SearchPredicateInputType", required: true

      def prepare
        ::Searching::Operators::And.new left, right
      end
    end
  end
end
