# frozen_string_literal: true

module Schemas
  module Properties
    class CompileContract
      include Dry::Monads[:do, :result]
      include WDPAPI::Deps[compile_schema: "schemas.properties.compile_schema"]

      # @param [SchemaVersion, Schema::Versions::Configuration, <Schemas::Versions::ScalarProperties::Base, Schemas::Versions::PropertyGroupDefinition>] source
      # @return [Dry::Monads::Result::Success(Class)]
      # @return [Dry::Monads::Result::Failure(Symbol, String)]
      def call(source)
        case source
        when Schemas::Properties::Types::List
          build_contract source
        when Schemas::Versions::Configuration
          build_contract source.properties
        when Schemas::Properties::Types.Interface(:properties)
          # :nocov:
          call(source.properties)
          # :nocov:
        when ::SchemaVersion
          build_contract source.configuration.properties
        else
          Failure(nil)
        end.or do
          Failure[:invalid_source, "Cannot derive properties from #{source.inspect}"]
        end
      end

      private

      # @param [<Schemas::Versions::ScalarProperties::Base, Schemas::Versions::PropertyGroupDefinition>] properties
      # @return [Dry::Monads::Result::Success(Class)]
      def build_contract(properties)
        schema = yield compile_schema.call properties

        contract_klass = Class.new(ApplicationContract)

        contract_klass.params schema

        properties.each do |property|
          property.add_to_rules! contract_klass
        end

        Success contract_klass
      end
    end
  end
end
