# frozen_string_literal: true

module Schemas
  module Properties
    # A context used for reading values and also produced by {Schemas::Properties::WriteContext}
    # to persist the values with {Schemas::Instances::ApplyValueContext}.
    #
    # @see Types::SchemaInstanceContextType
    class Context
      EMPTY_HASH = proc { {} }

      include Dry::Core::Memoizable
      include Dry::Initializer[undefined: false].define -> do
        option :version, Schemas::Types.Instance(SchemaVersion).optional, default: proc {}
        option :instance, Schemas::Types::SchemaInstance.optional, default: proc {}

        option :type_mapping, Schemas::Properties::TypeMapping::Type, default: proc { version&.type_mapping || Schemas::Properties::TypeMapping.new }

        option :values, Schemas::Types::ValueHash, default: EMPTY_HASH
        option :full_texts, FullText::Types::Map, default: EMPTY_HASH
        option :collected_references, Schemas::References::Types::CollectedMap, default: EMPTY_HASH
        option :scalar_references, Schemas::References::Types::ScalarMap, default: EMPTY_HASH
      end

      delegate :has_any_types?, :has_contributors?, :has_type?, to: :type_mapping

      # @!attribute [r] current_values
      # @return [Hash]
      memoize def current_values
        calculate_current_values
      end

      # @!attribute [r] default_values
      # @return [Hash]
      memoize def default_values
        {}
      end

      # @!attribute [r] field_values
      # @return [Hash]
      memoize def field_values
        calculate_field_values
      end

      # @!attribute [r] filtered_values
      # @return [PropertyHash]
      memoize def filtered_values
        filter_values
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
        filtered_values[path]
      end

      private

      # @return [Hash]
      def calculate_current_values
        property_hash = filter_values

        property_hash.merge! collected_references
        property_hash.merge! scalar_references
        property_hash.merge! full_texts

        property_hash.to_h
      end

      # @return [PropertyHash]
      def calculate_field_values
        property_hash = filter_values

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

      def filter_values
        PropertyHash.new(values).tap do |v|
          v.paths.each do |path|
            v.delete! path unless path.in? type_mapping.paths
          end
        end
      end
    end
  end
end
