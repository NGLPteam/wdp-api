# frozen_string_literal: true

module Types
  module Searching
    class MatchesOperatorInputType < Types::BaseInputObject
      argument :path, String, required: true, as: :left
      argument :value, String, required: true, as: :right

      def prepare
        ::Searching::Operators::Matches.new left, right
      end
    end
  end
end
