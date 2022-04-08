# frozen_string_literal: true

module Types
  module Searching
    class AndOperatorInputType < Types::BaseInputObject
      argument :left, "Types::SearchPredicateInputType", required: true
      argument :right, "Types::SearchPredicateInputType", required: true

      def prepare
        ::Searching::Operators::And.new left, right
      end
    end
  end
end
