# frozen_string_literal: true

module Schemas
  module Properties
    class Validate
      include Dry::Monads[:do, :result]

      include MeruAPI::Deps[
        compile_contract: "schemas.properties.compile_contract",
        decamelize_hash: "utility.decamelize_hash"
      ]

      # @param [SchemaVersion] version
      # @param [Hash] values
      # @param [HasSchemaDefinition] instance
      # @return [Dry::Monads::Result::Success(Dry::Validation::Result)]
      # @return [Dry::Monads::Result::Failure(:invalid_values, Dry::Validation::Result)]
      def call(schema_version, values, instance: nil)
        contract = yield compile_contract.call schema_version

        corrected_values = decamelize_hash.call(values)

        validation_context = {
          instance:,
        }

        response = contract.call(corrected_values, validation_context).to_monad

        response.or do |result|
          Failure[:invalid_values, result]
        end
      end
    end
  end
end
