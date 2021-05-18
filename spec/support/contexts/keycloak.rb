# frozen_string_literal: true

require_relative "../token_helper"

RSpec.shared_context "with mocked keycloak" do
  let(:config_server_url) { KeycloakRack::Config.new.server_url }
  let(:config_realm_id) { KeycloakRack::Config.new.realm_id }

  let(:token_helper) { TokenHelper.new }
  let(:jwks_response) { token_helper.jwks.as_json }

  let(:public_key_url) do
    "#{config_server_url}/realms/#{config_realm_id}/protocol/openid-connect/certs"
  end

  let(:mocked_public_key_response) do
    {
      body: jwks_response.to_json,
      status: 200
    }
  end

  before do
    stub_request(:get, public_key_url).
      to_return(mocked_public_key_response)
  end
end

RSpec.configure do |config|
  config.include_context "with mocked keycloak", type: :request
end
