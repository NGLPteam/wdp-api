# frozen_string_literal: true

module Types
  module Searching
    # @see ::Searching::Operators::Matches
    class MatchesOperatorInputType < Types::BaseInputObject
      description <<~TEXT
      Use full-text search on `path` to match `value`.

      As with top-level query searches, basic quoting and similar features are supported. See
      [websearch_to_tsquery](https://www.postgresql.org/docs/13/textsearch-controls.html) for
      more information.
      TEXT

      argument :path, String, required: true, as: :left
      argument :value, String, required: true, as: :right

      def prepare
        ::Searching::Operators::Matches.new left, right
      end
    end
  end
end
