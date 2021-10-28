# frozen_string_literal: true

module Schemas
  module Properties
    # A context used for reading values and also produced by {Schemas::Properties::WriteContext}
    # to persist the values with {Schemas::Instances::ApplyValueContext}
    class Context
      extend Dry::Initializer

      EMPTY_HASH = proc { {} }

      option :instance, AppTypes.Instance(HasSchemaDefinition).optional, default: proc { nil }
      option :values, AppTypes::ValueHash, default: EMPTY_HASH
      option :full_texts, AppTypes::FullTextMap, default: EMPTY_HASH
      option :collected_references, AppTypes::CollectedReferenceMap, default: EMPTY_HASH
      option :scalar_references, AppTypes::ScalarReferenceMap, default: EMPTY_HASH

      def default_values
        @default_values ||= {}
      end

      def field_values
        @field_values ||= calculate_field_values
      end

      # @param [String] path
      # @return [<ApplicationRecord>]
      def collected_reference(path)
        collected_references.fetch path, []
      end

      # @param [String] path
      # @return [SchematicText, nil]
      def full_text(path)
        full_texts[path]
      end

      # @param [String] path
      # @return [ApplicationRecord, nil]
      def scalar_reference(path)
        scalar_references[path]
      end

      # @param [String] path
      # @return [Object, nil]
      def value_at(path)
        parts = path.split(?.)

        values.dig(*parts)
      end

      private

      def calculate_field_values
        encoded_collections = collected_references.transform_values do |value|
          value.map(&:to_encoded_id)
        end

        encoded_scalars = scalar_references.transform_values do |value|
          value&.to_encoded_id
        end

        combined_references = encoded_collections.merge(encoded_scalars)

        flattened_references = flatten_map combined_references

        values.deep_merge(flattened_references)
      end

      def flatten_map(reference_map)
        reference_map.each_with_object({}) do |(path, value), new_hash|
          parts = path.split(?.)

          target = parts[0..-2].reduce(new_hash) { |h, k| h[k] ||= {} }

          target[parts.last] = value
        end
      end
    end
  end
end
