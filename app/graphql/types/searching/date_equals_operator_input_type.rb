# frozen_string_literal: true

module Types
  module Searching
    class DateEqualsOperatorInputType < Types::BaseInputObject
      argument :path, String, required: true, as: :left
      argument :value, GraphQL::Types::ISO8601Date, required: true, as: :right

      def prepare
        ::Searching::Operators::DateEquals.new left, right
      end
    end
  end
end
