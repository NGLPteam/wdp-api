# frozen_string_literal: true

module Schemas
  module Properties
    class GroupDefinition < BaseDefinition
      include CompilesToSchema
      include Dry::Core::Equalizer.new(:path, inspect: false)

      # @!attribute [rw] legend
      # @return [String]
      attribute :legend, :string

      # @!attribute [rw] properties
      # @return [<Schemas::Properties::Scalar::Base>]
      attribute :properties, ScalarDefinition.to_array_type, default: proc { [] }

      validates :properties, presence: true, unique_items: true

      # @return [void]
      def add_to_schema!(context)
        return if exclude_from_schema?

        contract = to_dry_validation

        if required?
          context.required(key).filled(contract.schema)
        else
          context.optional(key).maybe(contract.schema)
        end
      end

      def exclude_from_schema?
        return true if properties.blank?
        return true if properties.all?(&:exclude_from_schema?)

        false
      end

      def prefix
        "#{full_path}."
      end

      def required?
        properties.any?(&:actually_required?)
      end

      def version_property_label
        legend.presence || super
      end

      def to_version_property_metadata
        super.merge(
          property_count: properties.size,
        )
      end

      include Dry::Monads::Do.for(:write_values_within!)

      def write_values_within!(context)
        context.within_group! path do
          properties.each do |property|
            yield property.write_values_within! context
          end
        end

        Success nil
      end
    end
  end
end
