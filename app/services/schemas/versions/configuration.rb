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

      def to_contract
        WDPAPI::Container["schemas.properties.compile_contract"].call(properties)
      end
    end
  end
end
