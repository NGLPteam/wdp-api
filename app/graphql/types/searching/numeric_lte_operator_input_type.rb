# frozen_string_literal: true

module Types
  module Searching
    class NumericLTEOperatorInputType < Types::BaseInputObject
      argument :path, String, required: true, as: :left
      argument :value, Float, required: true, as: :right

      def prepare
        ::Searching::Operators::NumericLTE.new left, right
      end
    end
  end
end
