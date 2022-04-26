# frozen_string_literal: true

module Seeding
  module Import
    class UpsertCollection
      include MonadicPersistence
      include Dry::Monads[:result, :do]
      include WDPAPI::Deps[
        attach_image_property: "seeding.import.attach_image_property",
        fetch_schema: "seeding.import.fetch_schema",
        upsert_collection: "collections.upsert",
        upsert_pages: "seeding.import.upsert_pages",
      ]

      # @param [Community, Collection] parent
      # @param [Seeding::Import::Structs::Collections::Base] source
      # @return [Dry::Monads::Result]
      def call(parent, source)
        schema_version = fetch_schema.(source.schema)

        collection = upsert_collection.with_schema(schema_version) do
          yield upsert_collection.(source.identifier, title: source.title, parent: parent, properties: source.properties)
        end

        source.images.each do |key, asset|
          yield attach_image_property.(collection, key, asset)
        end

        yield monadic_save collection

        yield upsert_pages.(collection, source)

        Success collection
      end
    end
  end
end
