# frozen_string_literal: true

RSpec.shared_context "with mocked keycloak" do
  let_it_be(:config_server_url) { KeycloakRack::Config.new.server_url }
  let_it_be(:config_realm_id) { KeycloakRack::Config.new.realm_id }

  let_it_be(:token_helper) { TestingAPI::TestContainer["tokens.helper"] }
  let_it_be(:jwks_response) { token_helper.jwks.as_json }

  let_it_be(:public_key_url) do
    "#{config_server_url}/realms/#{config_realm_id}/protocol/openid-connect/certs"
  end

  let_it_be(:mocked_public_key_response) do
    {
      body: jwks_response.to_json,
      status: 200
    }
  end

  before do
    stub_request(:get, public_key_url).to_return(mocked_public_key_response)
  end
end

RSpec.configure do |config|
  config.include_context "with mocked keycloak", type: :request
end
