# frozen_string_literal: true

module Types
  module Searching
    # @see ::Searching::Operators::Equals
    class EqualsOperatorInputType < Types::BaseInputObject
      description <<~TEXT
      Require that `path = value`.
      TEXT

      argument :path, String, required: true, as: :left
      argument :value, GraphQL::Types::JSON, required: true, as: :right

      def prepare
        ::Searching::Operators::Equals.new left, right
      end
    end
  end
end
