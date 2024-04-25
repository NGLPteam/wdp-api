# frozen_string_literal: true

module Schemas
  module Instances
    class WriteFullText
      include Dry::Monads[:do, :result]

      include MeruAPI::Deps[
        derive_dictionary: "full_text.derive_dictionary",
        extract_text_content: "full_text.extract_text_content",
        normalize: "full_text.normalizer",
      ]

      prepend TransactionalCall

      UNIQUE_BY = %i[entity_type entity_id path].freeze

      # @param [HasSchemaDefinition] entity
      # @param [String] path
      # @param [Hash, SchematicText] value
      def call(entity, path, value, weight: ?D)
        normalized = normalize.call value

        if normalized[:content].present?
          yield upsert!(entity, path, **normalized, weight:)
        else
          yield clear! entity, path
        end

        Success nil
      end

      private

      def clear!(entity, path)
        Success SchematicText.by_entity(entity).by_path(path).delete_all
      end

      # @param [HasSchemaDefinition] entity
      # @param [String] path
      # @param [String] content
      # @param [String] lang
      def upsert!(entity, path, content:, kind:, lang:, weight:, **)
        attributes = {
          entity_type: entity.model_name.to_s,
          entity_id: entity.id,
          path:,
          content:,
          kind:,
          lang:,
          weight:,
        }

        attributes[:schema_version_property_id] = property_id_for entity, path

        attributes[:text_content] = extract_text_content.call(content:, kind:)

        attributes[:dictionary] = derive_dictionary.call lang

        Success SchematicText.upsert(attributes, unique_by: UNIQUE_BY)
      end

      def property_id_for(entity, path)
        entity.schema_version.schema_version_properties.by_path(path).first&.id
      end
    end
  end
end
