# frozen_string_literal: true

module Schemas
  module Versions
    # Reorder the {SchemaVersion versions} for a specific {SchemaDefinition},
    # based on their semantic version. We need to sort within Ruby and update
    # Postgres owing to the current impossibility of adding a dedicated semver
    # type in PG.
    #
    # In future, we may be able to remove this with a non-Heroku PG build.
    #
    # @see https://pgxn.org/dist/semver/
    class Reorder
      include Dry::Monads[:do, :result]
      include QueryOperation

      # @param [SchemaDefinition] schema_definition
      # @return [Dry::Monads::Result]
      def call(schema_definition)
        versions = yield sort_versions schema_definition

        return Success(nil) if versions.blank?

        query = yield build_query schema_definition, versions

        Success sql_update! query
      end

      private

      def schema_versions
        @schema_versions ||= SchemaVersion.arel_table
      end

      def build_position_statement(versions)
        Arel::Nodes::Case.new(schema_versions[:id]).tap do |stmt|
          versions.each_with_index do |version, index|
            position = index + 1

            stmt.when(version.id).then(position)
          end

          stmt.else(versions.length + 10)
        end
      end

      def build_query(schema_definition, versions)
        um = Arel::UpdateManager.new

        um.table schema_versions

        position_value = build_position_statement versions

        current_value = schema_versions[:id].eq(versions.first.id)

        um.set [
          [schema_versions[:position], position_value],
          [schema_versions[:current], current_value]
        ]

        um.where schema_versions[:schema_definition_id].eq(schema_definition.id)

        Success um.to_sql
      end

      def sort_versions(definition)
        sorted = definition.schema_versions.reload.to_a.sort do |a, b|
          b.number <=> a.number
        end

        Success sorted
      end
    end
  end
end
