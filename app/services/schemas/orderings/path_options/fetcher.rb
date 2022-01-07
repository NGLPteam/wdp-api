# frozen_string_literal: true

module Schemas
  module Orderings
    module PathOptions
      class Fetcher
        include Dry::Monads[:do, :result]
        include Dry::Initializer[undefined: false].define -> do
          option :schemas, Schemas::Orderings::Types::OrderingFilters.optional, default: proc { [] }
        end

        include WDPAPI::Deps[
          find_all_matching_versions: "schemas.associations.find_all_matching_versions",
        ]

        def call
          schema_props = yield fetch_schema_properties

          static_props = yield fetch_static_properties

          sorted_props = (schema_props + static_props).sort

          Success sorted_props
        end

        private

        # @return [Dry::Monads::Success<Schemas::Orderings::PathOptions::SchemaReader>]
        def fetch_schema_properties
          versions = yield find_all_matching_versions.call schemas

          return Success([]) if versions.none? && schemas.any?

          props = SchemaVersionProperty.preload(:schema_version).orderable.filtered_by_schema_version(*versions).map do |prop|
            Schemas::Orderings::PathOptions::SchemaReader.new prop
          end

          Success props
        end

        # @return [Dry::Monads::Success<Schemas::Orderings::PathOptions::StaticReader>]
        def fetch_static_properties
          props = StaticOrderableProperty.visible.map do |prop|
            Schemas::Orderings::PathOptions::StaticReader.new prop
          end

          Success props
        end
      end
    end
  end
end
