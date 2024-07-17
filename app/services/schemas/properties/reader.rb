# frozen_string_literal: true

module Schemas
  module Properties
    # A wrapper around a {Schemas::Properties::Scalar::Base scalar property} that marries it to
    # a {Schemas::Properties::Context value context}. It is consumed by the GraphQL API in order
    # to introspect the properties on a schema instance in a type-safe way.
    #
    # @see Types::Schematic::ScalarPropertyType
    class Reader < BaseReader
      option :property, AppTypes.Instance(Schemas::Properties::Scalar::Base)
      option :context, AppTypes.Instance(Schemas::Properties::Context), default: proc { Schemas::Properties::Context.new({}) }

      delegate :function, :label, :full_path, :path, :required, :search_path, :type, to: :property
      delegate_missing_to :property

      # @return [Dry::Monads::Result]
      def available_entities
        Dry::Monads.Try(NoMethodError) do
          property.available_entities_for context.instance
        end.to_result.flatten
      end

      # @return [ControlledVocabulary, nil]
      def configured_controlled_vocabulary
        Dry::Monads.Try(NoMethodError) do
          property.configured_controlled_vocabulary
        end.to_result.flatten
      end

      def default
        property.default if property.has_default?
      end

      # @return [Class]
      def graphql_object_type
        klass_prefix = property.type.camelize(:upper)

        "::Types::Schematic::#{klass_prefix}PropertyType".constantize
      end

      # @return [<Schemas::Properties::Scalar::SelectOption>]
      def options
        property.options if property.respond_to?(:options)
      end

      def value
        property.read_value_from context
      end

      def wants
        property.try(:wants)
      end

      def wide?
        property.always_wide? || property.wide?
      end

      # @!group Search Stuff

      # @return [<String>]
      def search_operators
        MeruAPI::Container["searching.operators.for_type"].(type)
      end

      # @!endgroup
    end
  end
end
