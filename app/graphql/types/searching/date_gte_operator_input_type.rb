# frozen_string_literal: true

module Types
  module Searching
    class DateGTEOperatorInputType < Types::BaseInputObject
      argument :path, String, required: true, as: :left
      argument :value, GraphQL::Types::ISO8601Date, required: true, as: :right

      def prepare
        ::Searching::Operators::DateGTE.new left, right
      end
    end
  end
end
