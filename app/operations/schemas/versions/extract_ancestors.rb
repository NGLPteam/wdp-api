# frozen_string_literal: true

module Schemas
  module Versions
    class ExtractAncestors
      include Dry::Monads[:do, :result]
      include MeruAPI::Deps[find_matching_versions: "schemas.associations.find_matching_versions"]

      # @param [SchemaVersion] schema_version
      # @return [{ String => Integer }] hash of association names and matched version counts
      def call(schema_version)
        ancestors = schema_version.configuration.ancestors

        results = ancestors.map do |ancestor|
          yield extract_for schema_version, ancestor
        end

        Success results.to_h
      end

      private

      # @param [SchemaVersion] schema_version
      # @param [Schemas::Associations::NamedAncestor] ancestor
      # @return [Dry::Monads::Success(String, Integer)]
      def extract_for(schema_version, ancestor)
        versions = yield find_matching_versions.call ancestor

        audit_scope = SchemaVersionAncestor.by_source(schema_version).by_name(ancestor.name)

        if versions.none?
          audit_scope.delete_all

          return Success[ancestor.name, 0]
        end

        base_columns = { schema_version_id: schema_version.id, name: ancestor.name }

        attributes = versions.map do |version|
          base_columns.merge(target_version_id: version.id)
        end

        SchemaVersionAncestor.upsert_all(
          attributes,
          unique_by: %i[schema_version_id target_version_id name],
          returning: nil
        )

        audit_scope.sans_target(versions).delete_all

        Success[ancestor.name, versions.size]
      end
    end
  end
end
