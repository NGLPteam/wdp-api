# frozen_string_literal: true

module Schemas
  module Instances
    class ApplyGeneratedProperties
      include Dry::Monads[:do, :result]
      include WDPAPI::Deps[apply: "schemas.instances.apply", generate: "schemas.static.generate"]

      prepend TransactionalCall

      # @param [HasSchemaDefinition] entity
      # @return [Dry::Monads::Result]
      def call(entity)
        values = yield generate_values_for entity

        saved_entity = yield apply.call entity, values

        Success saved_entity
      end

      private

      def generate_values_for(entity)
        generator_key = entity.schema_definition.system_slug.tr(?:, ?.)

        Success generate[generator_key].call
      rescue Dry::Container::Error
        empty_values = {}

        Success empty_values
      end
    end
  end
end
