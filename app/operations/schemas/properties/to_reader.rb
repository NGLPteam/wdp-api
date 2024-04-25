# frozen_string_literal: true

module Schemas
  module Properties
    # Build an individual reader for a schema property, with optional context.
    class ToReader
      include Dry::Monads[:do, :result]
      include MeruAPI::Deps[to_context: "schemas.properties.to_context"]

      # @param [Schemas::Properties::BaseDefinition] property
      # @option base_options [Schemas::Properties::Context] :context
      # @return [Dry::Monads::Success(Schemas::Properties::GroupReader)]
      # @return [Dry::Monads::Success(Schemas::Properties::Reader)]
      def call(property, context: nil)
        options = {}

        options[:context] = context if context.kind_of?(Schemas::Properties::Context)

        if property.group?
          compile_group property, **options
        else
          compile_property property, **options
        end
      end

      private

      # @param [Schemas::Properties::GroupDefinition] group
      # @return [Dry::Monads::Success(Schemas::Properties::GroupReader)]
      def compile_group(group, **base_options)
        options = base_options.merge(group:)

        options[:properties] = group.properties.map do |property|
          yield compile_property property, **options
        end

        Success Schemas::Properties::GroupReader.new **options
      end

      # @param [Schemas::Properties::Scalar::Base] property
      # @return [Dry::Monads::Success(Schemas::Properties::Reader)]
      def compile_property(property, **base_options)
        options = base_options.merge(property:)

        Success Schemas::Properties::Reader.new **options
      end
    end
  end
end
