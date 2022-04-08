# frozen_string_literal: true

module Types
  module Searching
    class EqualsOperatorInputType < Types::BaseInputObject
      argument :path, String, required: true, as: :left
      argument :value, GraphQL::Types::JSON, required: true, as: :right

      def prepare
        ::Searching::Operators::Equals.new left, right
      end
    end
  end
end
