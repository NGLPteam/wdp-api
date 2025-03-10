# frozen_string_literal: true

module Schemas
  module Instances
    # This stores the raw property values for a {SchemaInstance}, along with
    # {Schemas::Header a signature header} for a {SchemaVersion}.
    class PropertySet
      include StoreModel::Model

      # @!attribute [rw] schema
      # A signature from a {SchemaVersion} that signs this property set
      # as belonging to said schema. It is used for validations when
      # applying new properties, to make sure that everything is in sync.
      # @return [Schemas::Header]
      attribute :schema, Schemas::Header.to_type, default: proc { {} }

      # @!attribute [rw] values
      # The authoritative source for non-reference property values.
      # @return [::Support::PropertyHash]
      attribute :values, :property_hash, default: proc { {} }

      # @return [String]
      def inspect
        value_paths = Array(values&.paths).map(&:inspect).join(", ")

        "#<#{self.class}#{schema&.suffix} (#{value_paths})>"
      end
    end
  end
end
