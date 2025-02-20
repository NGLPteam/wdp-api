# frozen_string_literal: true

module Schemas
  module Orderings
    module PathOptions
      class Fetcher < Support::HookBased::Actor
        include Dry::Monads[:do, :result]
        include Dry::Initializer[undefined: false].define -> do
          option :schemas, Schemas::Orderings::Types::OrderingFilters.optional, default: proc { Dry::Core::Constants::EMPTY_ARRAY }
        end

        include MeruAPI::Deps[
          find_all_matching_versions: "schemas.associations.find_all_matching_versions",
        ]

        standard_execution!

        # @return [<SchemaVersionAncestor>]
        attr_reader :ancestors

        # @return [<Schemas::Orderings::PathOptions::Reader>]
        attr_reader :readers

        # @return [<SchemaVersion>]
        attr_reader :versions

        # @return [Dry::Monads::Success<Schemas::Orderings::PathOptions::Reader>]
        def call
          run_callbacks :execute do
            yield prepare!
            yield fetch_schema_properties!
            yield fetch_static_properties!
            yield fetch_ancestor_schema_properties!
            yield fetch_ancestor_static_properties!
          end

          @readers.sort!

          Success @readers
        end

        wrapped_hook! def prepare
          @readers = []
          @versions = yield call_operation("schemas.associations.find_all_matching_versions", schemas)
          @ancestors = yield call_operation("schemas.associations.find_unique_ancestors", versions)

          super
        end

        wrapped_hook! def fetch_schema_properties
          return super if versions.none? && schemas.any?

          props = SchemaVersionProperty.preload(:schema_version).orderable.filtered_by_schema_version(*versions).map do |prop|
            Schemas::Orderings::PathOptions::SchemaReader.new prop
          end

          @readers.concat props

          super
        end

        wrapped_hook! def fetch_static_properties
          props = StaticOrderableProperty.visible.map do |prop|
            Schemas::Orderings::PathOptions::StaticReader.new prop
          end

          @readers.concat props

          super
        end

        wrapped_hook! def fetch_ancestor_static_properties
          return super unless schemas.present? && versions.present?

          props = ancestors.flat_map do |ancestor|
            StaticAncestorOrderableProperty.all.map do |prop|
              Schemas::Orderings::PathOptions::AncestorStaticReader.new ancestor.name, prop, ancestor.target_version
            end
          end

          @readers.concat props

          super
        end

        wrapped_hook! def fetch_ancestor_schema_properties
          return super unless schemas.present? && versions.present?

          props = ancestors.flat_map do |ancestor|
            SchemaVersionProperty.preload(:schema_version).orderable.filtered_by_schema_version(ancestor.target_version).map do |prop|
              Schemas::Orderings::PathOptions::AncestorSchemaReader.new ancestor.name, prop
            end
          end

          @readers.concat props

          super
        end
      end
    end
  end
end
