# frozen_string_literal: true

module Types
  module Searching
    # @see ::Searching::Operators::DateGTE
    class DateGTEOperatorInputType < Types::BaseInputObject
      description <<~TEXT
      Require that `path ≥ value` while enforcing that value is a date.
      TEXT

      argument :path, String, required: true, as: :left
      argument :value, GraphQL::Types::ISO8601Date, required: true, as: :right

      def prepare
        ::Searching::Operators::DateGTE.new left, right
      end
    end
  end
end
