# frozen_string_literal: true

module Schemas
  module Instances
    class Validate
      include Dry::Monads[:do, :result]

      include WDPAPI::Deps[
        read_context: "schemas.instances.read_property_context",
        compile_contract: "schemas.properties.compile_contract",
      ]

      # @param [HasSchemaDefinition] entity
      def call(entity, context: nil)
        contract = contract_for entity

        values = values_for entity, context

        result = contract.call(values)

        validity = {}.tap do |h|
          h[:valid] = result.success?
          h[:validated_at] = Time.current
          h[:errors] = errors_for result
        end

        Success validity
      end

      private

      def contract_for(entity)
        contract_klass = yield compile_contract.call entity.schema_version

        contract_klass.new
      end

      def context_for(entity, context)
        return context if context.present?

        yield read_context.call entity
      end

      def values_for(entity, context)
        context_for(entity, context).field_values
      end

      def errors_for(result)
        result.errors.each_with_object([]) do |error, errors|
          path = error.path.join(?.).presence

          next if path.blank? || /\Abase\z/.match?(path)

          errors << to_schema_error(error)
        end
      end

      # @api private
      # @param [Dry::Schema::Message, Dry::Schema::Hint, Dry::Validation::Message] error
      # @return [{ Symbol => Object }]
      def to_schema_error(error)
        {}.tap do |h|
          h[:hint] = error.hint?
          h[:path] = error.path.join(?.)
          h[:base] = false
          h[:message] = error.text
          h[:metadata] = error.meta
        end
      end
    end
  end
end
