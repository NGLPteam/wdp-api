# frozen_string_literal: true

module Schemas
  module Properties
    class Reader
      extend Dry::Initializer
      include Dry::Core::Equalizer.new(:full_path)

      option :property, AppTypes.Instance(Schemas::Properties::Scalar::Base)
      option :context, AppTypes.Instance(Schemas::Properties::Context), default: proc { Schemas::Properties::Context.new({}) }

      delegate :function, :label, :full_path, :path, :required, :type, :wide?, to: :property

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

      def wide?
        property.always_wide? || property.wide?
      end
    end
  end
end
