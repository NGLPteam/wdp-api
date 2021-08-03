# frozen_string_literal: true

module Schemas
  module Properties
    class Validate
      include Dry::Monads[:do, :result]

      include WDPAPI::Deps[compile_contract: "schemas.properties.compile_contract"]

      # @param [SchemaVersion] version
      # @param [Hash] values
      # @return [Dry::Monads::Result::Success(Dry::Validation::Result)]
      # @return [Dry::Mondas::Result::Failure(:invalid_values, Dry::Validation::Result)]
      def call(schema_version, values)
        contract_klass = yield compile_contract.call schema_version

        contract = contract_klass.new

        contract.call(values).to_monad.or do |result|
          Failure[:invalid_values, result]
        end
      end
    end
  end
end
