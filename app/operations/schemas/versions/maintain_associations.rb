# frozen_string_literal: true

module Schemas
  module Versions
    # Maintain the set of {SchemaVersionAssociation} records tied to a {SchemaVersion}.
    class MaintainAssociations
      include Dry::Monads[:do, :result]

      # @param [SchemaVersion] schema_version
      # @return [Dry::Monads::Result]
      def call(schema_version)
        ids = yield upsert! schema_version

        yield prune! schema_version, ids

        yield update_cache! schema_version

        Success()
      end

      private

      # @param [SchemaVersion] source
      # @return [Dry::Monads::Success<String>] the upserted IDs
      def upsert!(source)
        rows = yield upsert_rows_for source

        return Success([]) if rows.blank?

        result = SchemaVersionAssociation.upsert_all rows, unique_by: %i[source_id target_id name], returning: %i[id]

        ids = result.pluck("id")

        Success ids
      end

      # @param [SchemaVersion] source
      # @param [<String>] ids
      # @return [Dry::Monads::Result]
      def prune!(source, ids)
        SchemaVersionAssociation.by_source(source).where.not(id: ids).delete_all

        Success()
      end

      # @param [SchemaVersion] source
      # @return [Dry::Monads::Result]
      def update_cache!(source)
        source.reload

        columns = {}

        columns[:enforces_parent] = source.parent_associations.exists?
        columns[:enforces_children] = source.child_associations.exists?
        columns[:enforced_parent_declarations] = source.enforced_parent_versions.pluck(:declaration)
        columns[:enforced_child_declarations] = source.enforced_child_versions.pluck(:declaration)

        source.update_columns columns

        return Success()
      end

      # @param [SchemaVersion] source
      # @return [Dry::Monads::Success<Hash>]
      def upsert_rows_for(source)
        config = source.configuration

        mapping = {}

        mapping["parent"] = yield versions_for config.parents
        mapping["child"] = yield versions_for config.children

        rows = mapping.flat_map do |(name, targets)|
          targets.map do |target|
            { source_id: source.id, target_id: target.id, name: }
          end
        end

        Success rows
      end

      # @return [Dry::Monads::Success<SchemaVersion>]
      def versions_for(associations)
        matching = associations.flat_map(&:find_matching_versions).uniq

        Success matching
      end
    end
  end
end
