# frozen_string_literal: true

module Schemas
  module References
    class WriteScalarReference
      include Dry::Monads[:do, :result]

      prepend TransactionalCall

      UNIQUE_BY = %i[referrer_type referrer_id path].freeze

      # @param [HasSchemaDefinition] referrer
      # @param [String] path
      # @param [ApplicationRecord, nil] referents
      def call(referrer, path, referent)
        if referent.present?
          yield upsert! referrer, path, referent
        else
          yield clear! referrer, path
        end

        Success nil
      end

      private

      def clear!(referrer, path)
        Success SchematicScalarReference.by_referrer(referrer).by_path(path).delete_all
      end

      def upsert!(referrer, path, referent)
        attributes = {
          referrer_type: referrer.model_name.to_s,
          referrer_id: referrer.id,
          path:,
          referent_type: referent.model_name.to_s,
          referent_id: referent.id
        }

        Success SchematicScalarReference.upsert(attributes, unique_by: UNIQUE_BY)
      end
    end
  end
end
