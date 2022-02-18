# frozen_string_literal: true

module Schemas
  module Properties
    # A context used for reading values and also produced by {Schemas::Properties::WriteContext}
    # to persist the values with {Schemas::Instances::ApplyValueContext}
    class Context
      extend Dry::Initializer

      EMPTY_HASH = proc { {} }

      option :instance, Schemas::Types::SchemaInstance.optional, default: proc { nil }
      option :values, Schemas::Types::ValueHash, default: EMPTY_HASH
      option :full_texts, FullText::Types::Map, default: EMPTY_HASH
      option :collected_references, Schemas::References::Types::CollectedMap, default: EMPTY_HASH
      option :scalar_references, Schemas::References::Types::ScalarMap, default: EMPTY_HASH

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
        property_hash = PropertyHash.new values

        encoded_collections = collected_references.transform_values do |value|
          value.map(&:to_encoded_id)
        end

        encoded_scalars = scalar_references.transform_values do |value|
          value&.to_encoded_id
        end

        property_hash.merge! encoded_collections
        property_hash.merge! encoded_scalars
        property_hash.merge! full_texts

        property_hash.to_h
      end
    end
  end
end
