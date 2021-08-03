# frozen_string_literal: true

module Schemas
  module Properties
    class GroupDefinition < BaseDefinition
      include CompilesToSchema
      include Dry::Core::Equalizer.new(:path, inspect: false)

      attribute :legend, :string
      attribute :properties, ScalarDefinition.to_array_type, default: proc { [] }

      validates :properties, presence: true, unique_items: true

      alias full_path path

      # @return [void]
      def add_to_schema!(context)
        return if exclude_from_schema?

        schema = to_dry_schema

        if required?
          context.required(key).filled(schema)
        else
          context.optional(key).maybe(schema)
        end
      end

      # @return [void]
      def add_to_rules!(context)
        properties.each do |property|
          property.add_to_rules! context
        end
      end

      def exclude_from_schema?
        return true if properties.blank?
        return true if properties.all?(&:exclude_from_schema?)

        false
      end

      def required?
        properties.any?(&:actually_required?)
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
