# frozen_string_literal: true

module Types
  module Searching
    class DateLTEOperatorInputType < Types::BaseInputObject
      argument :path, String, required: true, as: :left
      argument :value, GraphQL::Types::ISO8601Date, required: true, as: :right

      def prepare
        ::Searching::Operators::DateLTE.new left, right
      end
    end
  end
end
