# frozen_string_literal: true

module Seeding
  module Import
    class UpsertCollections
      include Dry::Monads[:result, :do]
      include MeruAPI::Deps[
        upsert_collection: "seeding.import.upsert_collection",
      ]

      # @param [Community, Collection] parent
      # @param [#collections] source
      # @return [Dry::Monads::Result]
      def call(parent, source)
        source.collections.each do |collection_source|
          collection = yield upsert_collection.(parent, collection_source)

          next if collection_source.collections.blank?

          # Recurse subcollections
          yield call(collection, collection_source)
        end

        Success()
      end
    end
  end
end
