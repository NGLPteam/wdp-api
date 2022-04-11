# frozen_string_literal: true

module Types
  module Searching
    # @see ::Searching::Operators::InAny
    class InAnyOperatorInputType < Types::BaseInputObject
      description <<~TEXT
      Require that the `path` must include or be one of the strings provided in `value`.

      The actual value of `path` may be an array (multiselect) or string (select).
      TEXT

      argument :path, String, required: true, as: :left
      argument :value, [String, { null: false }], required: true, as: :right

      def prepare
        ::Searching::Operators::InAny.new left, right
      end
    end
  end
end
