# frozen_string_literal: true

module APIWrapper
  # Get a `GraphQL::Client`
  class GetClient
    # @param [String] endpoint
    # @return [GraphQL::Client]
    def call(endpoint: LocationsConfig.default_graphql_endpoint)
      adapter = get_adapter_for endpoint

      schema = ::GraphQL::Client.load_schema APIWrapper::CLIENT_SCHEMA_PATH

      ::GraphQL::Client.new(schema:, execute: adapter).tap do |client|
        client.allow_dynamic_queries = true
      end
    end

    private

    # @param [String] endpoint
    # @return [GraphQL::Client::HTTP]
    def get_adapter_for(endpoint)
      ::GraphQL::Client::HTTP.new(endpoint) do
        include ::APIWrapper::AdapterLogic
      end
    end
  end
end
