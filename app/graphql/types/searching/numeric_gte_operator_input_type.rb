# frozen_string_literal: true

module Types
  module Searching
    class NumericGTEOperatorInputType < Types::BaseInputObject
      argument :path, String, required: true, as: :left
      argument :value, Float, required: true, as: :right

      def prepare
        ::Searching::Operators::NumericGTE.new left, right
      end
    end
  end
end
