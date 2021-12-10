# frozen_string_literal: true

module Schemas
  module Versions
    class Configuration
      include StoreModel::Model
      include Schemas::Properties::CompilesToSchema

      attribute :id, :string
      attribute :name, :string
      attribute :consumer, :string
      attribute :version, :semantic_version
      attribute :orderings, Schemas::Orderings::Definition.to_array_type, default: proc { [] }
      attribute :properties, Schemas::Properties::Definition.to_array_type, default: proc { [] }

      validates :consumer, inclusion: { in: %w[community collection item metadata] }

      validates :version, :id, :name, presence: true

      validates :orderings, :properties, unique_items: true

      # @param [#to_s] identifier
      def has_ordering?(identifier)
        id = identifier.to_s

        orderings.any? do |ordering|
          ordering.id == id
        end
      end

      # @param [#to_s] identifier
      # @return [Schemas::Orderings::Definition, nil]
      def ordering_definition_for(identifier)
        id = identifier.to_s

        orderings.detect do |ordering|
          ordering.id == id
        end
      end

      # @param [String] full_path
      # @return [Schemas::Properties::GroupDefinition, Schemas::Properties::ScalarDefinition]
      def property_for(full_path)
        find_prop = ->(prop) do
          throw :found, prop if prop.full_path == full_path

          next unless prop.group?

          next unless full_path.starts_with? prop.prefix

          prop.properties.each(&find_prop)
        end

        catch(:found) do
          properties.each(&find_prop)

          nil
        end
      end

      # @return [<String>]
      def property_paths
        build_paths = ->(prop, paths) do
          if prop.group?
            prop.properties.each_with_object(paths, &build_paths)
          else
            next if block_given? && !yield(prop)

            paths << prop.full_path
          end
        end

        properties.each_with_object([], &build_paths)
      end

      def collected_reference_paths
        property_paths do |prop|
          prop.kind_of?(Schemas::Properties::Scalar::CollectedReference)
        end
      end

      def scalar_reference_paths
        property_paths do |prop|
          prop.kind_of?(Schemas::Properties::Scalar::ScalarReference)
        end
      end

      def text_reference_paths
        property_paths do |prop|
          prop.kind_of?(Schemas::Properties::Scalar::FullText)
        end
      end

      def to_contract
        WDPAPI::Container["schemas.properties.compile_contract"].call(properties)
      end
    end
  end
end
