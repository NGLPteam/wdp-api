# frozen_string_literal: true

module Types
  module Searching
    # @see ::Searching::Operators::NumericLTE
    class NumericLTEOperatorInputType < Types::BaseInputObject
      description <<~TEXT
      Require that `path ≤ value` while enforcing that value is numeric.

      Note: this will also work for integer paths. Coercion is handled
      transparently by the API.
      TEXT

      argument :path, String, required: true, as: :left
      argument :value, Float, required: true, as: :right

      def prepare
        ::Searching::Operators::NumericLTE.new left, right
      end
    end
  end
end
