# frozen_string_literal: true

module Types
  module Searching
    class InAnyOperatorInputType < Types::BaseInputObject
      argument :path, String, required: true, as: :left
      argument :value, [String, { null: false }], required: true, as: :right

      def prepare
        ::Searching::Operators::InAny.new left, right
      end
    end
  end
end
