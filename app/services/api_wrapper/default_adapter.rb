# frozen_string_literal: true

module APIWrapper
  DefaultAdapter = GraphQL::Client::HTTP.new(LocationsConfig.default_graphql_endpoint) do
    include ::APIWrapper::AdapterLogic
  end
end
