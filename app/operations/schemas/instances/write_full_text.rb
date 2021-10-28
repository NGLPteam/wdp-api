# frozen_string_literal: true

module Schemas
  module Instances
    class WriteFullText
      include Dry::Monads[:do, :result]

      include WDPAPI::Deps[
        derive_dictionary: "full_text.derive_dictionary",
        extract_text_content: "full_text.extract_text_content",
        normalize: "full_text.normalizer",
      ]

      prepend TransactionalCall

      UNIQUE_BY = %i[entity_type entity_id path].freeze

      # @param [HasSchemaDefinition] entity
      # @param [String] path
      # @param [Hash, SchematicText] value
      def call(entity, path, value)
        normalized = normalize.call value

        if normalized[:content].present?
          yield upsert! entity, path, **normalized
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
      def upsert!(entity, path, content:, kind:, lang:, **)
        attributes = {
          entity_type: entity.model_name.to_s,
          entity_id: entity.id,
          path: path,
          content: content,
          kind: kind,
          lang: lang,
        }

        attributes[:text_content] = extract_text_content.call(content: content, kind: kind)

        attributes[:dictionary] = derive_dictionary.call lang

        Success SchematicText.upsert(attributes, unique_by: UNIQUE_BY)
      end
    end
  end
end
