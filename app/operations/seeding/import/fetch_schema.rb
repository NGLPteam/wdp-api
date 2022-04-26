# frozen_string_literal: true

module Seeding
  module Import
    # Fetch a schema (and cache the result so the fetch only happens once per declaration).
    class FetchSchema
      prepend Dry::Effects.Cache(import: :call)

      # @param [String] declaration
      # @return [SchemaVersion]
      def call(declaration)
        SchemaVersion[declaration]
      end
    end
  end
end
