# frozen_string_literal: true

module Seeding
  module Import
    class UpsertCommunity
      include Dry::Monads[:result, :do]
      include MonadicPersistence
      include MeruAPI::Deps[
        attach_image_property: "seeding.import.attach_image_property",
        fetch_schema: "seeding.import.fetch_schema",
        upsert_community: "communities.upsert",
        upsert_collections: "seeding.import.upsert_collections",
        upsert_pages: "seeding.import.upsert_pages",
      ]

      # @param [Seeding::Import::Structs::Community] source
      # @return [Dry::Monads::Success(Community)]
      def call(source)
        community = yield upsert_community.(source.identifier, title: source.title)

        community.schema_version = fetch_schema.(source.schema)

        source.images.each do |key, asset|
          yield attach_image_property.(community, key, asset)
        end

        yield monadic_save community

        yield upsert_pages.(community, source)

        yield upsert_collections.(community, source)

        Success community
      end
    end
  end
end
