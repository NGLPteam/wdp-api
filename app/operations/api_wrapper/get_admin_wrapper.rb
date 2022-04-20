# frozen_string_literal: true

module APIWrapper
  class GetAdminWrapper
    include WDPAPI::Deps[
      get_graphql_client: "api_wrapper.get_client",
      get_token: "password_flow.get_token"
    ]

    # @return [APIWrapper::Wrapper]
    def call(username, password, endpoint: LocationsConfig.default_graphql_endpoint)
      access_token = get_token.(username, password, via_admin: true)

      client = get_graphql_client.(endpoint: endpoint)

      ::APIWrapper::Wrapper.new(client, access_token.access_token)
    end
  end
end
