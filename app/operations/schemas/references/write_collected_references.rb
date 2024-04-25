# frozen_string_literal: true

module Schemas
  module References
    class WriteCollectedReferences
      include Dry::Monads[:do, :result]

      prepend TransactionalCall

      UNIQUE_BY = %i[referrer_type referrer_id referent_type referent_id path].freeze

      # @param [HasSchemaDefinition] referrer
      # @param [String] path
      # @param [<ApplicationRecord>] referents
      def call(referrer, path, referents)
        yield clear_missing! referrer, path, referents

        yield upsert! referrer, path, referents if referents.any?

        Success nil
      end

      private

      def clear_missing!(referrer, path, referents)
        scope = referrer.schematic_collected_references.by_path(path)

        scope = scope.where.not(referent: referents) if referents.present?

        scope.delete_all

        Success nil
      end

      def upsert!(referrer, path, referents)
        base_columns = {
          referrer_type: referrer.model_name.to_s,
          referrer_id: referrer.id,
          path:
        }

        attributes = referents.map.with_index do |referent, i|
          position = i + 1

          base_columns.merge(
            referent_type: referent.model_name.to_s,
            referent_id: referent.id,
            position:
          )
        end

        Success SchematicCollectedReference.upsert_all(attributes, unique_by: UNIQUE_BY)
      end
    end
  end
end
