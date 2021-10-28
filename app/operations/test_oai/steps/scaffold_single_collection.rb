# frozen_string_literal: true

module TestOAI
  module Steps
    class ScaffoldSingleCollection
      include Dry::Monads[:do, :result]
      include MonadicPersistence

      def call(community, identifier:, title:, schema_version: "default:collection")
        return Failure[:missing_identifier, "must provide identifier"] if identifier.blank?

        collection = community.collections.by_identifier(identifier).first_or_initialize

        collection.title = title
        collection.schema_version = SchemaVersion[schema_version]

        monadic_save collection
      end
    end
  end
end
