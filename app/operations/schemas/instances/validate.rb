# frozen_string_literal: true

module Schemas
  module Instances
    class Validate
      include Dry::Monads[:do, :result]

      include MeruAPI::Deps[
        read_context: "schemas.instances.read_property_context",
        compile_contract: "schemas.properties.compile_contract",
      ]

      # @param [HasSchemaDefinition] entity
      def call(entity, context: nil)
        contract = yield contract_for entity

        context = read_context.call(entity) unless context.kind_of?(Schemas::Properties::Context)

        values = context.field_values

        validation_context = {
          instance: entity,
        }

        result = contract.call(values, validation_context)

        validity = {}.tap do |h|
          h[:valid] = result.success?
          h[:validated_at] = Time.current
          h[:errors] = errors_for result
        end

        Success validity
      end

      private

      def contract_for(entity)
        compile_contract.call entity.schema_version
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
